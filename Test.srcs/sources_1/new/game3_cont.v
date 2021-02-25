`timescale 1ns / 1ps

module game3_cont(input [6:0] X, [5:0] Y, input GAME_ON, CLK,
    input [2:0] FREQ_RANGE,
    output reg [6:0] S_PLANE_X = 4, output reg [5:0] S_PLANE_Y = 0,
    output reg BARRIER_OLED = 0, reg S_PLANE_ON = 0, reg T_PLANE_OLED = 0, 
    output reg GAMEOVER_ON = 0, reg CONGRATS_ON = 0, reg EXPLOSION_ON = 0,
    output reg [15:0] T_PLANE_COLOUR = 0, output reg [5:0] GAMEOVER_Y = 0, 
    output reg [6:0] CONGRATS_X = 95
    );

    parameter [15:0] WHITE  = 16'hFFFF;
    parameter [15:0] GREEN  = 16'h07E0;
    parameter [15:0] YELLOW = 16'hFFE0;
    parameter [15:0] RED    = 16'hF800;
    parameter [15:0] BLACK  = 16'h0000;


    reg [8:0] COUNTER = 0;
    reg COUNTERSTOP = 0;
    reg [6:0] COUNTER2 = 0;
    
    reg T_PLANE_ON = 0;
    
    always @ (posedge CLK)
    begin

        if (GAME_ON == 0) 
        begin
            COUNTERSTOP <= 0;
            COUNTER <= 0;
            COUNTER2 <= 0;
            CONGRATS_X <= 95;
            CONGRATS_ON <= 0;
            EXPLOSION_ON <= 0;
        end
        
        else // GAME_ON
        begin
        
            // plane crash
            if (((COUNTER > 9'd67) && (COUNTER < 9'd96) && (FREQ_RANGE != 3)) 
                || ((COUNTER > 9'd155) && (COUNTER < 9'd184) && (FREQ_RANGE != 2)) 
                || ((COUNTER > 9'd243) && (COUNTER < 9'd273) && (FREQ_RANGE != 4)) 
                || ((COUNTER > 9'd331) && (COUNTER < 9'd360) && (FREQ_RANGE != 1)))
            begin
                COUNTERSTOP <= 1;
            end
        
            COUNTER <= COUNTERSTOP ? COUNTER : (COUNTER == 9'd400) ? 400 : COUNTER + 1;
            COUNTER2 <= (COUNTER2 > 7'd90) ? 0 : (COUNTER == 9'd400) ? S_PLANE_X + 1 : 4;
            
            // Game won
            if (COUNTER == 9'd400) 
            begin
                CONGRATS_ON <= 1;
                CONGRATS_X <= CONGRATS_X - 1;
                S_PLANE_ON <= 1;
                T_PLANE_ON <= 0;
                S_PLANE_Y <= S_PLANE_Y;
                S_PLANE_X <= COUNTER2;
            end
        
            // game over
            if (COUNTERSTOP == 1)
            begin
                GAMEOVER_Y <= GAMEOVER_Y == 25? 25 : GAMEOVER_Y + 1;
                GAMEOVER_ON <= 1;
                EXPLOSION_ON <= 1;
                S_PLANE_Y <= S_PLANE_Y;
                S_PLANE_ON <= 0;
                T_PLANE_ON <= 0;
            end
            else
            begin
                GAMEOVER_ON <= 0;
                GAMEOVER_Y <= 0;
            end
            
            // top plane view
            if ((FREQ_RANGE == 0) && (COUNTERSTOP == 0) && (COUNTER < 9'd400))
            begin
                S_PLANE_X <= 7'd4;
                S_PLANE_Y <= 6'd23;
                T_PLANE_ON <= 1;
                S_PLANE_ON <= 0;
            end
            
            //side plane view
            else if ((FREQ_RANGE == 1) && (COUNTERSTOP == 0) && (COUNTER < 9'd400))
            begin
                S_PLANE_X <= 7'd4;
                S_PLANE_Y <= 6'd5;
                S_PLANE_ON <= 1;
                T_PLANE_ON <= 0;
            end

            else if ((FREQ_RANGE == 2) && (COUNTERSTOP == 0) && (COUNTER < 9'd400))
            begin
                S_PLANE_X <= 7'd4;
                S_PLANE_Y <= 6'd19;
                S_PLANE_ON <= 1;
                T_PLANE_ON <= 0;
            end

            else if ((FREQ_RANGE == 3) && (COUNTERSTOP == 0) && (COUNTER < 9'd400))
            begin
                S_PLANE_X <= 7'd4;
                S_PLANE_Y <= 6'd33;
                S_PLANE_ON <= 1;
                T_PLANE_ON <= 0;
            end

            else if ((FREQ_RANGE == 4) && (COUNTERSTOP == 0) && (COUNTER < 9'd400))
            begin
                S_PLANE_X <= 7'd4;
                S_PLANE_Y <= 6'd47;
                S_PLANE_ON <= 1;
                T_PLANE_ON <= 0;
            end
            else if (COUNTER == 9'd400 && FREQ_RANGE == 1)
            begin
                S_PLANE_ON <= 1;
                S_PLANE_Y <= 6'd5;
                S_PLANE_X <= COUNTER2;
            end
            else if (COUNTER == 9'd400 && FREQ_RANGE == 2)
            begin
                S_PLANE_ON <= 1;
                S_PLANE_Y <= 6'd19;
                S_PLANE_X <= COUNTER2;
            end
            else if (COUNTER == 9'd400 && FREQ_RANGE == 3)
            begin
                S_PLANE_ON <= 1;
                S_PLANE_Y <= 6'd33;
                S_PLANE_X <= COUNTER2;
            end
            else if (COUNTER == 9'd400 && FREQ_RANGE == 4)
            begin
                S_PLANE_ON <= 1;
                S_PLANE_Y <= 6'd47;
                S_PLANE_X <= COUNTER2;
            end
        end
    end
  
  
  
  
  
    always @ (*)
    begin
        if (GAME_ON == 0)
        begin
            BARRIER_OLED = 0;
            T_PLANE_OLED = 0;
        end
        else // GAME_ON
        begin
            // barrier
            if (X < 92 && X > 3 && Y > 3 && Y < 60)
            begin
                if      (Y >  3 && Y < 18 && ((COUNTER + X > 9'd86 && COUNTER + X < 9'd93) 
                                           || (COUNTER + X > 9'd174 && COUNTER + X < 9'd181) 
                                           || (COUNTER + X > 9'd262 && COUNTER + X < 9'd269))) BARRIER_OLED = 1;
                else if (Y > 17 && Y < 32 && ((COUNTER + X > 9'd86 && COUNTER + X < 9'd93) 
                                           || (COUNTER + X > 9'd262 && COUNTER + X < 9'd269) 
                                           || (COUNTER + X > 9'd350 && COUNTER + X < 9'd357))) BARRIER_OLED = 1;
                else if (Y > 31 && Y < 46 && ((COUNTER + X > 9'd174 && COUNTER + X < 9'd181) 
                                           || (COUNTER + X > 9'd262 && COUNTER + X < 9'd269) 
                                           || (COUNTER + X > 9'd350 && COUNTER + X < 9'd357))) BARRIER_OLED = 1;
                else if (Y > 45 && Y < 60 && ((COUNTER + X > 9'd86 && COUNTER + X < 9'd93) 
                                           || (COUNTER + X > 9'd174 && COUNTER + X < 9'd181) 
                                           || (COUNTER + X > 9'd350 && COUNTER + X < 9'd357))) BARRIER_OLED = 1;
                else BARRIER_OLED = 0;
            end
            else BARRIER_OLED = 0;

            // top plane view
            if (T_PLANE_ON == 1)
            begin

                if (((Y == 23 || Y == 40) && (X > 9 && X < 14)) || (((Y > 22 && Y < 29) || (Y > 34 && Y < 41)) && (X == 10 || X == 13)) 
                    || ((Y == 28 || Y == 35) && ((X > 5 && X < 11) || (X > 12 && X < 17))) 
                    || (X == 4 && (Y > 24 && Y < 39)) || (X == 6 && (Y > 24 && Y < 29)) || (X == 6 && (Y > 34 && Y < 39)) 
                    || ((Y == 25 || Y == 38) && (X > 3 && X < 7)) || (X == 17 && (Y == 29 || Y == 34))
                    || (X == 18 && (Y > 29 && Y < 34))) 
                    begin T_PLANE_OLED = 1; T_PLANE_COLOUR = BLACK; end
                else if ((X == 5 && (Y > 25 && Y < 38)) || (((Y > 23 && Y < 29) 
                    || (Y > 34 && Y < 40)) && (X == 11 || X == 12))) 
                    begin T_PLANE_OLED = 1; T_PLANE_COLOUR = GREEN; end
                else if ((X > 9 && X < 15) && (Y > 29 && Y < 34)) 
                    begin T_PLANE_OLED = 1; T_PLANE_COLOUR = YELLOW; end
                else if (((X > 5 && X < 17) && (Y > 28 && Y < 35) && !((X > 9 && X < 15) && (Y > 29 && Y < 34))) 
                    || (X == 17 && (Y > 29 && Y < 34 ))) 
                    begin T_PLANE_OLED = 1; T_PLANE_COLOUR = WHITE; end
                else if (X == 19 && (Y == 31 || Y ==32)) 
                    begin T_PLANE_OLED = 1; T_PLANE_COLOUR = RED; end
                else T_PLANE_OLED = 0;
            end
       
        end

    end

endmodule