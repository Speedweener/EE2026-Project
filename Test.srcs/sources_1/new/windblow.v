`timescale 1ns / 1ps

module windblow([6:0] X, [5:0] Y, input [11:0] MAXSOUND, input CLK, MID, CLK_DEBOUNCE,
    output reg [15:0] BAR_COLOR = 0, output reg [15:0] LED = 0);
    
      parameter [15:0] WHITE  = 16'hFFFF;
      parameter [15:0] GREEN  = 16'h07E0;
      parameter [15:0] YELLOW = 16'hFFE0;
      parameter [15:0] RED    = 16'hF800;
      parameter [15:0] BLACK  = 16'h0000;
      parameter [15:0] BLUE   = 16'h07E0; // Changed to green
      parameter [15:0] PURPLE = 16'hD198;
      parameter [15:0] ORANGE = 16'hFBE0;
      parameter [15:0] CYAN   = 16'h07FD;
      parameter [15:0] PINK   = 16'hFC9C;
    
    reg [15:0] POWERLEVEL = 0;
    reg [4:0] FRAMECOUNTER = 0;
    reg [3:0] JUMPCOUNTER = 0;
    reg [3:0] WINDCOUNTER = 0;
    reg [4:0] TIMERCOUNTER;
    
    
    reg [6:0] NO1X = 00;  //For Countdown Timer
    reg [5:0] NO1Y = 00;
    reg [6:0] NO2X = 05;
    reg [5:0] NO2Y = 00;

    reg [6:0] SLIMEX = 46;
    reg [5:0] SLIMEY = 10;
    reg [6:0] FLOWERX = 38;
    reg [5:0] FLOWERY = 55;
    reg [6:0] FLOWERX2 = 50;
    reg [6:0] FLOWERX3 = 62;
    
    reg [1:0] OUTCOME = 0;
    reg [1:0] DIVIDER = 0;
    reg [5:0] TIMEDIVIDER = 0;

    reg GAMEOVER_ON=0;
    wire GAMEOVER_OLED;
    reg CONGRATS_ON = 0;
    wire CONGRATS_OLED;
    reg BLOWN = 0;
    
    game_over displaygameover(.X(X), .Y(Y), .X_START(18), .Y_START(25), .GAMEOVER_ON(GAMEOVER_ON), .ON(GAMEOVER_OLED));
    congrats displaycongrats( .X(X), .Y(Y), .X_START(-27), .Y_START(20), .CONGRATS_ON(CONGRATS_ON), .ON(CONGRATS_OLED));
    
    
    
    always @ (posedge CLK_DEBOUNCE)begin
    if(MID) begin
    TIMERCOUNTER =0;
    OUTCOME = 0;
    POWERLEVEL = 0;
    SLIMEX = 46;
    SLIMEY = 10;
    JUMPCOUNTER = 0;
    FRAMECOUNTER = 0;
    FLOWERX = 38;
    FLOWERY = 55;
    FLOWERX2 = 50;
    FLOWERX3 = 62;
    end
    DIVIDER<=DIVIDER+1;
    TIMEDIVIDER<=TIMEDIVIDER+1;

    if(TIMEDIVIDER==49) begin
       TIMERCOUNTER <=TIMERCOUNTER+1;
     end

    if(DIVIDER == 3) begin
    FRAMECOUNTER <=FRAMECOUNTER + 1;
      if(MAXSOUND>3400) begin
       POWERLEVEL <= POWERLEVEL +1;
       LED = LED << 1;
       LED = LED + 1;
       end
      else begin
      POWERLEVEL<=0;
      LED <=0;
      end
       
      if(POWERLEVEL>5)
      BLOWN <= 1;
      else 
      BLOWN <=0;    

    JUMPCOUNTER <=JUMPCOUNTER + 1;
    case(JUMPCOUNTER)
               4'b0000: SLIMEX <= SLIMEX-1; 
               4'b0001: SLIMEX <= SLIMEX-1; 
               4'b0010: SLIMEX <= SLIMEX+2; 
               4'b0011: SLIMEX <= SLIMEX+3; 
               4'b0100: SLIMEX <= SLIMEX+5; 
               4'b0101: SLIMEX <= SLIMEX+3; 
               4'b0110: SLIMEX <= SLIMEX+2; 
               4'b0111: SLIMEX <= SLIMEX+1; 
               4'b1000: SLIMEX <= SLIMEX+0; 
               4'b1001: SLIMEX <= SLIMEX+0; 
               4'b1010: SLIMEX <= SLIMEX-2; 
               4'b1011: SLIMEX <= SLIMEX-3; 
               4'b1100: SLIMEX <= SLIMEX-4; 
               4'b1101: SLIMEX <= SLIMEX-3; 
               4'b1110: SLIMEX <= SLIMEX-2; 
               4'b1111: SLIMEX <= SLIMEX-0; 
      endcase
    if(JUMPCOUNTER==2 || JUMPCOUNTER==5 || JUMPCOUNTER==8 || JUMPCOUNTER==11  || JUMPCOUNTER==14 )
       SLIMEY<=SLIMEY + 1;
       
    if(BLOWN)begin
       if(SLIMEY>4)
       SLIMEY<=SLIMEY - 2;
       
       WINDCOUNTER<=WINDCOUNTER+1;
        case(WINDCOUNTER)
                  4'b0000: FLOWERX <= FLOWERX-1; 
                  4'b0001: FLOWERX3 <= FLOWERX3+1 ; 
                  4'b0010: FLOWERX <= FLOWERX-2;
                  4'b0011: FLOWERX2 <= FLOWERX2-2;  
                  4'b0100: FLOWERX3 <= FLOWERX3+2;  
                  4'b0101: FLOWERX <= FLOWERX-1; 
                  4'b0110: FLOWERX2 <= FLOWERX2-1;  
                  4'b0111: FLOWERX3 <= FLOWERX3-1; 
                  4'b1000: FLOWERX2 <= FLOWERX2+1;  
                  4'b1001: FLOWERX <= FLOWERX+1;  
                  4'b1010: FLOWERX2 <= FLOWERX2+1;  
                  4'b1011: FLOWERX <= FLOWERX+2; 
                  4'b1100: FLOWERX3 <= FLOWERX3-1;
                  4'b1101: FLOWERX <= FLOWERX+1; 
                  4'b1110: FLOWERX2 <= FLOWERX2+1;
                  4'b1111: FLOWERX3 <= FLOWERX3-1;
         endcase
     end
     
     if(SLIMEY>=42)begin
     OUTCOME = 2;  
     TIMERCOUNTER = 0;      
     end
     
     if(TIMERCOUNTER>=21)begin
     OUTCOME = 1; 
     SLIMEY = 0; 
     TIMERCOUNTER = 21;      
     end
     
     end //end of divider
end


    always @ (*)
    begin
    BAR_COLOR = WHITE;
    if(OUTCOME==0) begin
    if(Y == FLOWERY - 3 && X == FLOWERX)  BAR_COLOR = YELLOW; // FLOWER CORE
    else if(Y == FLOWERY - 2 && X >= FLOWERX-1 && X <= FLOWERX+1)  BAR_COLOR = YELLOW;
    else if(Y == FLOWERY - 1 && X >= FLOWERX-2 && X <= FLOWERX+2)  BAR_COLOR = YELLOW;
    else if(Y == FLOWERY - 0 && X >= FLOWERX-3 && X <= FLOWERX+3)  BAR_COLOR = YELLOW;
    else if(Y == FLOWERY + 1 && X >= FLOWERX-2 && X <= FLOWERX+2)  BAR_COLOR = YELLOW;
    else if(Y == FLOWERY + 2 && X >= FLOWERX-1 && X <= FLOWERX+1)  BAR_COLOR = YELLOW;
    else if(Y == FLOWERY - 3 && X == FLOWERX)  BAR_COLOR = YELLOW;
    
    else if(Y == FLOWERY - 5 && X == FLOWERX)  BAR_COLOR = PINK; //FLOWER PETAL
    else if(Y == FLOWERY - 4 && X >= FLOWERX-1 && X <= FLOWERX+1)  BAR_COLOR = PINK;
    else if(Y == FLOWERY - 3 && X >= FLOWERX-1 && X <= FLOWERX+1)  BAR_COLOR = PINK;
    else if(Y == FLOWERY - 2 && X >= FLOWERX-2 && X <= FLOWERX+2)  BAR_COLOR = PINK;
    else if(Y == FLOWERY - 1 && X >= FLOWERX-4 && X <= FLOWERX+4)  BAR_COLOR = PINK;
    else if(Y == FLOWERY - 0 && X >= FLOWERX-5 && X <= FLOWERX+5)  BAR_COLOR = PINK;
    else if(Y == FLOWERY + 1 && X >= FLOWERX-4 && X <= FLOWERX+4)  BAR_COLOR = PINK;
    else if(Y == FLOWERY + 2 && X >= FLOWERX-2 && X <= FLOWERX+2)  BAR_COLOR = PINK;
    else if(Y == FLOWERY + 3 && X >= FLOWERX-1 && X <= FLOWERX+1)  BAR_COLOR = PINK;
    else if(Y == FLOWERY + 4 && X >= FLOWERX-1 && X <= FLOWERX+1)  BAR_COLOR = PINK;
    else if(Y == FLOWERY + 5 && X == FLOWERX)  BAR_COLOR = PINK;
    
    else if(Y == FLOWERY - 6 && X >= FLOWERX-1 && X <= FLOWERX+1)  BAR_COLOR = PURPLE; //FLOWER EDGE
    else if(Y == FLOWERY - 5 && X >= FLOWERX-2 && X <= FLOWERX+2)  BAR_COLOR = PURPLE; //FLOWER EDGE
    else if(Y == FLOWERY - 4 && X >= FLOWERX-2 && X <= FLOWERX+2)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY - 3 && X >= FLOWERX-2 && X <= FLOWERX+2)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY - 2 && X >= FLOWERX-5 && X <= FLOWERX+5)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY - 1 && X >= FLOWERX-6 && X <= FLOWERX+6)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY - 0 && X >= FLOWERX-6 && X <= FLOWERX+6)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 1 && X >= FLOWERX-6 && X <= FLOWERX+6)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 2 && X >= FLOWERX-5 && X <= FLOWERX+5)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 3 && X >= FLOWERX-2 && X <= FLOWERX+2)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 4 && X >= FLOWERX-2 && X <= FLOWERX+2)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 5 && X >= FLOWERX-2 && X <= FLOWERX+2)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 6 && X >= FLOWERX-1 && X <= FLOWERX+1)  BAR_COLOR = PURPLE;
    
    else if(Y == FLOWERY - 3 && X == FLOWERX2)  BAR_COLOR = YELLOW; // FLOWER CORE
    else if(Y == FLOWERY - 2 && X >= FLOWERX2-1 && X <= FLOWERX2+1)  BAR_COLOR = YELLOW;
    else if(Y == FLOWERY - 1 && X >= FLOWERX2-2 && X <= FLOWERX2+2)  BAR_COLOR = YELLOW;
    else if(Y == FLOWERY - 0 && X >= FLOWERX2-3 && X <= FLOWERX2+3)  BAR_COLOR = YELLOW;
    else if(Y == FLOWERY + 1 && X >= FLOWERX2-2 && X <= FLOWERX2+2)  BAR_COLOR = YELLOW;
    else if(Y == FLOWERY + 2 && X >= FLOWERX2-1 && X <= FLOWERX2+1)  BAR_COLOR = YELLOW;
    else if(Y == FLOWERY - 3 && X == FLOWERX2)  BAR_COLOR = YELLOW;
    
    else if(Y == FLOWERY - 5 && X == FLOWERX2)  BAR_COLOR = PINK; //FLOWER PETAL
    else if(Y == FLOWERY - 4 && X >= FLOWERX2-1 && X <= FLOWERX2+1)  BAR_COLOR = PINK;
    else if(Y == FLOWERY - 3 && X >= FLOWERX2-1 && X <= FLOWERX2+1)  BAR_COLOR = PINK;
    else if(Y == FLOWERY - 2 && X >= FLOWERX2-2 && X <= FLOWERX2+2)  BAR_COLOR = PINK;
    else if(Y == FLOWERY - 1 && X >= FLOWERX2-4 && X <= FLOWERX2+4)  BAR_COLOR = PINK;
    else if(Y == FLOWERY - 0 && X >= FLOWERX2-5 && X <= FLOWERX2+5)  BAR_COLOR = PINK;
    else if(Y == FLOWERY + 1 && X >= FLOWERX2-4 && X <= FLOWERX2+4)  BAR_COLOR = PINK;
    else if(Y == FLOWERY + 2 && X >= FLOWERX2-2 && X <= FLOWERX2+2)  BAR_COLOR = PINK;
    else if(Y == FLOWERY + 3 && X >= FLOWERX2-1 && X <= FLOWERX2+1)  BAR_COLOR = PINK;
    else if(Y == FLOWERY + 4 && X >= FLOWERX2-1 && X <= FLOWERX2+1)  BAR_COLOR = PINK;
    else if(Y == FLOWERY + 5 && X == FLOWERX2)  BAR_COLOR = PINK;
    
    else if(Y == FLOWERY - 6 && X >= FLOWERX2-1 && X <= FLOWERX2+1)  BAR_COLOR = PURPLE; //FLOWER EDGE
    else if(Y == FLOWERY - 5 && X >= FLOWERX2-2 && X <= FLOWERX2+2)  BAR_COLOR = PURPLE; //FLOWER EDGE
    else if(Y == FLOWERY - 4 && X >= FLOWERX2-2 && X <= FLOWERX2+2)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY - 3 && X >= FLOWERX2-2 && X <= FLOWERX2+2)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY - 2 && X >= FLOWERX2-5 && X <= FLOWERX2+5)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY - 1 && X >= FLOWERX2-6 && X <= FLOWERX2+6)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY - 0 && X >= FLOWERX2-6 && X <= FLOWERX2+6)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 1 && X >= FLOWERX2-6 && X <= FLOWERX2+6)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 2 && X >= FLOWERX2-5 && X <= FLOWERX2+5)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 3 && X >= FLOWERX2-2 && X <= FLOWERX2+2)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 4 && X >= FLOWERX2-2 && X <= FLOWERX2+2)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 5 && X >= FLOWERX2-2 && X <= FLOWERX2+2)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 6 && X >= FLOWERX2-1 && X <= FLOWERX2+1)  BAR_COLOR = PURPLE;
    
    else if(Y == FLOWERY - 3 && X == FLOWERX3)  BAR_COLOR = YELLOW; // FLOWER CORE
    else if(Y == FLOWERY - 2 && X >= FLOWERX3-1 && X <= FLOWERX3+1)  BAR_COLOR = YELLOW;
    else if(Y == FLOWERY - 1 && X >= FLOWERX3-2 && X <= FLOWERX3+2)  BAR_COLOR = YELLOW;
    else if(Y == FLOWERY - 0 && X >= FLOWERX3-3 && X <= FLOWERX3+3)  BAR_COLOR = YELLOW;
    else if(Y == FLOWERY + 1 && X >= FLOWERX3-2 && X <= FLOWERX3+2)  BAR_COLOR = YELLOW;
    else if(Y == FLOWERY + 2 && X >= FLOWERX3-1 && X <= FLOWERX3+1)  BAR_COLOR = YELLOW;
    else if(Y == FLOWERY - 3 && X == FLOWERX3)  BAR_COLOR = YELLOW;
    
    else if(Y == FLOWERY - 5 && X == FLOWERX3)  BAR_COLOR = PINK; //FLOWER PETAL
    else if(Y == FLOWERY - 4 && X >= FLOWERX3-1 && X <= FLOWERX3+1)  BAR_COLOR = PINK;
    else if(Y == FLOWERY - 3 && X >= FLOWERX3-1 && X <= FLOWERX3+1)  BAR_COLOR = PINK;
    else if(Y == FLOWERY - 2 && X >= FLOWERX3-2 && X <= FLOWERX3+2)  BAR_COLOR = PINK;
    else if(Y == FLOWERY - 1 && X >= FLOWERX3-4 && X <= FLOWERX3+4)  BAR_COLOR = PINK;
    else if(Y == FLOWERY - 0 && X >= FLOWERX3-5 && X <= FLOWERX3+5)  BAR_COLOR = PINK;
    else if(Y == FLOWERY + 1 && X >= FLOWERX3-4 && X <= FLOWERX3+4)  BAR_COLOR = PINK;
    else if(Y == FLOWERY + 2 && X >= FLOWERX3-2 && X <= FLOWERX3+2)  BAR_COLOR = PINK;
    else if(Y == FLOWERY + 3 && X >= FLOWERX3-1 && X <= FLOWERX3+1)  BAR_COLOR = PINK;
    else if(Y == FLOWERY + 4 && X >= FLOWERX3-1 && X <= FLOWERX3+1)  BAR_COLOR = PINK;
    else if(Y == FLOWERY + 5 && X == FLOWERX3)  BAR_COLOR = PINK;
    
    else if(Y == FLOWERY - 6 && X >= FLOWERX3-1 && X <= FLOWERX3+1)  BAR_COLOR = PURPLE; //FLOWER EDGE
    else if(Y == FLOWERY - 5 && X >= FLOWERX3-2 && X <= FLOWERX3+2)  BAR_COLOR = PURPLE; //FLOWER EDGE
    else if(Y == FLOWERY - 4 && X >= FLOWERX3-2 && X <= FLOWERX3+2)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY - 3 && X >= FLOWERX3-2 && X <= FLOWERX3+2)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY - 2 && X >= FLOWERX3-5 && X <= FLOWERX3+5)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY - 1 && X >= FLOWERX3-6 && X <= FLOWERX3+6)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY - 0 && X >= FLOWERX3-6 && X <= FLOWERX3+6)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 1 && X >= FLOWERX3-6 && X <= FLOWERX3+6)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 2 && X >= FLOWERX3-5 && X <= FLOWERX3+5)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 3 && X >= FLOWERX3-2 && X <= FLOWERX3+2)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 4 && X >= FLOWERX3-2 && X <= FLOWERX3+2)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 5 && X >= FLOWERX3-2 && X <= FLOWERX3+2)  BAR_COLOR = PURPLE;
    else if(Y == FLOWERY + 6 && X >= FLOWERX3-1 && X <= FLOWERX3+1)  BAR_COLOR = PURPLE;
          
    else if(BLOWN && ((X<=(SLIMEX-3) && X>=(SLIMEX-4)) || (X<=(SLIMEX+4) && X>=(SLIMEX+3))) && ((Y==SLIMEY-3)||(Y==SLIMEY-2))) BAR_COLOR = RED; //EYES HURT
    else if(BLOWN && ((X==(SLIMEX-2) || X==(SLIMEX-5)) || (X==(SLIMEX+5) || X==(SLIMEX+2))) && ((Y==SLIMEY-1)||(Y==(SLIMEY-4)))) BAR_COLOR = RED;
    
    else if(BLOWN && ((X>=SLIMEX-4 &&  X<=SLIMEX+2)) && (Y==SLIMEY+3)) BAR_COLOR = RED; //SMILE HURT
    else if(BLOWN && ((X==SLIMEX-5 ||  X==SLIMEX+3)) && (Y==SLIMEY+4)) BAR_COLOR = RED;
    
    else if(BLOWN == 0 && ((X<=(SLIMEX-3) && X>=(SLIMEX-4)) || (X<=(SLIMEX+4) && X>=(SLIMEX+3))) && ((Y==SLIMEY)||(Y==SLIMEY-5)||(Y==SLIMEY-3)||(Y==SLIMEY-2))) BAR_COLOR = BLACK; //EYES
    else if(BLOWN == 0 && ((X<=(SLIMEX-3) && X>=(SLIMEX-4)) || (X<=(SLIMEX+4) && X>=(SLIMEX+3))) && ((Y==SLIMEY-1)||(Y==SLIMEY-4))) BAR_COLOR = WHITE; //EYES NORMAL
    else if(BLOWN == 0 && ((X==(SLIMEX-2) || X==(SLIMEX-5)) || (X==(SLIMEX+5) || X==(SLIMEX+2))) && ((Y==SLIMEY-1)||(Y==(SLIMEY-4)))) BAR_COLOR = BLACK;
    else if(BLOWN == 0 && ((X==(SLIMEX-1) || X==(SLIMEX-6)) || (X==(SLIMEX+6) || X==(SLIMEX+1))) && ((Y==SLIMEY-2)||(Y==(SLIMEY-3)))) BAR_COLOR = BLACK;
    else if(BLOWN == 0 && ((X==(SLIMEX-2) || X==(SLIMEX-5)) || (X==(SLIMEX+5) || X==(SLIMEX+2))) && ((Y==SLIMEY-2)||(Y==(SLIMEY-3)))) BAR_COLOR = WHITE;
    
    else if(BLOWN == 0 && ((X>=SLIMEX-4 &&  X<=SLIMEX+2)) && (Y==SLIMEY+3)) BAR_COLOR = RED; //SMILE NORMAL
    else if(BLOWN == 0 && ((X==SLIMEX-5 ||  X==SLIMEX+3)) && (Y==SLIMEY+2)) BAR_COLOR = RED;

    

        
        else if(Y==SLIMEY-15 && X==SLIMEX) BAR_COLOR = BLUE; //BODY
        else if(Y==SLIMEY-14 && (X>=SLIMEX-1 && X<=SLIMEX+1)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY-13 && (X>=SLIMEX-1 && X<=SLIMEX+1)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY-12 && (X>=SLIMEX-1 && X<=SLIMEX+1)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY-11 && (X>=SLIMEX-2 && X<=SLIMEX+1)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY-10 && (X>=SLIMEX-2 && X<=SLIMEX+2)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY-9 && (X>=SLIMEX-3 && X<=SLIMEX+3)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY-8 && (X>=SLIMEX-4 && X<=SLIMEX+4)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY-7 && (X>=SLIMEX-5 && X<=SLIMEX+5)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY-6 && (X>=SLIMEX-7 && X<=SLIMEX+6)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY-5 && (X>=SLIMEX-8 && X<=SLIMEX+7)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY-4 && (X>=SLIMEX-9 && X<=SLIMEX+8)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY-3 && (X>=SLIMEX-10 && X<=SLIMEX+9)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY-2 && (X>=SLIMEX-11 && X<=SLIMEX+9)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY-1 && (X>=SLIMEX-11 && X<=SLIMEX+9)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY-0 && (X>=SLIMEX-10 && X<=SLIMEX+8)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY+1 && (X>=SLIMEX-10 && X<=SLIMEX+8)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY+2 && (X>=SLIMEX-9 && X<=SLIMEX+8)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY+3 && (X>=SLIMEX-9 && X<=SLIMEX+7)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY+4 && (X>=SLIMEX-8 && X<=SLIMEX+6)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY+5 && (X>=SLIMEX-7 && X<=SLIMEX+5)) BAR_COLOR = BLUE;
        else if(Y==SLIMEY+6 && (X>=SLIMEX-6 && X<=SLIMEX+3)) BAR_COLOR = BLUE;
        
        
         case(TIMERCOUNTER)
           5'b00000:
           begin 
                   if(Y == NO1Y &&     X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; // TWO
              else if(Y == NO1Y + 2 && X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; 
              else if(Y == NO1Y + 4 && X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; 
              else if(Y >= NO1Y + 2 && Y <= NO1Y + 4  && X == NO1X )  BAR_COLOR = RED; 
              else if(Y >= NO1Y  &&    Y <= NO1Y + 2  && X == NO1X + 2)  BAR_COLOR = RED; 
               
              else if(Y == NO2Y &&     X >= NO2X      && X <= NO2X + 2 )  BAR_COLOR = RED; // ZERO
              else if(Y == NO2Y + 4 && X >= NO2X      && X <= NO2X + 2 )  BAR_COLOR = RED; 
              else if(Y >= NO2Y  &&    Y <= NO2Y + 4  && X == NO2X)  BAR_COLOR = RED; 
              else if(Y >= NO2Y  &&    Y <= NO2Y + 4  && X == NO2X + 2)  BAR_COLOR = RED; 
            end
           
           5'b00001:
           begin 
                   if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED;    // ONE
              
              else if(Y == NO2Y &&     X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; // NINE
              else if(Y == NO2Y + 2 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
              else if(Y == NO2Y + 4 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
              else if(Y >= NO2Y  &&    Y <= NO2Y +2  && X == NO2X)  BAR_COLOR = RED; 
              else if(Y >= NO2Y  &&    Y <= NO2Y +4  && X == NO2X + 2)  BAR_COLOR = RED; 
           end
           
           5'b00010:
           begin 
               if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED;    // ONE
          
               else if(Y == NO2Y &&     X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; // EIGHT
               else if(Y == NO2Y + 2 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
               else if(Y == NO2Y + 4 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
               else if(Y >= NO2Y  &&    Y <= NO2Y +4  && X == NO2X)  BAR_COLOR = RED; 
               else if(Y >= NO2Y  &&    Y <= NO2Y +4  && X == NO2X + 2)  BAR_COLOR = RED; 
           end
           
           5'b00011:
           begin 
               if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED;    // ONE
          
               else if(Y == NO2Y &&     X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; // SEVEN
               else if(Y >= NO2Y  &&    Y <= NO2Y +4  && X == NO2X + 2)  BAR_COLOR = RED; 
           end
           
           5'b00100:
           begin 
               if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED;    // ONE
          
               else if(Y == NO2Y &&     X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; // SIX
               else if(Y == NO2Y + 2 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
               else if(Y == NO2Y + 4 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
               else if(Y >= NO2Y  &&    Y <= NO2Y +4  && X == NO2X)  BAR_COLOR = RED; 
               else if(Y >= NO2Y +2 &&  Y <= NO2Y +4  && X == NO2X + 2)  BAR_COLOR = RED; 
           end
           
           5'b00101:
           begin 
                   if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED;    // ONE
              
              else if(Y == NO2Y &&     X >= NO2X &&      X <= NO2X + 2 )  BAR_COLOR = RED; // FIVE
              else if(Y == NO2Y + 2 && X >= NO2X &&      X <= NO2X + 2 )  BAR_COLOR = RED; 
              else if(Y == NO2Y + 4 && X >= NO2X &&      X <= NO2X + 2 )  BAR_COLOR = RED; 
              else if(Y >= NO2Y     && Y <= NO2Y + 2  && X == NO2X)  BAR_COLOR = RED; 
              else if(Y >= NO2Y + 2 && Y <= NO2Y+ 4  &&  X == NO2X + 2)  BAR_COLOR = RED; 
            end
           
           5'b00110:
           begin
                   if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED;    // ONE
              
              else if(Y == NO2Y + 2 && X >= NO2X &&      X <= NO2X + 2 )  BAR_COLOR = RED; // FOUR
              else if(Y >= NO2Y     && Y <= NO2Y + 2  && X == NO2X)  BAR_COLOR = RED; 
              else if(Y >= NO2Y     && Y <= NO2Y+ 4  &&  X == NO2X + 2)  BAR_COLOR = RED; 
           end
           
           5'b00111:
           begin
                   if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED;    // ONE
              
              else if(Y == NO2Y &&     X >= NO2X      && X <= NO2X + 2 )  BAR_COLOR = RED; // THREE
              else if(Y == NO2Y + 2 && X >= NO2X      && X <= NO2X + 2 )  BAR_COLOR = RED; 
              else if(Y == NO2Y + 4 && X >= NO2X      && X <= NO2X + 2 )  BAR_COLOR = RED; 
              else if(Y >= NO2Y  &&    Y <= NO2Y + 4  && X == NO2X + 2)  BAR_COLOR = RED; 
           end
           
           5'b01000:
           begin
                   if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED;    // ONE
              
              else if(Y == NO2Y &&     X >= NO2X      && X <= NO2X + 2 )  BAR_COLOR = RED; // TWO
              else if(Y == NO2Y + 2 && X >= NO2X      && X <= NO2X + 2 )  BAR_COLOR = RED; 
              else if(Y == NO2Y + 4 && X >= NO2X      && X <= NO2X + 2 )  BAR_COLOR = RED; 
              else if(Y >= NO2Y + 2 && Y <= NO2Y + 4  && X == NO2X )  BAR_COLOR = RED; 
              else if(Y >= NO2Y  &&    Y <= NO2Y + 2  && X == NO2X + 2)  BAR_COLOR = RED; 
           end
           
           5'b01001:
           begin
                   if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED;    // ONE
              
              else if(Y >= NO1Y  &&    Y <= NO2Y + 4  && X == NO2X + 2)  BAR_COLOR = RED;    // ONE
        
           end
           
           5'b01010:
           begin
                    if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED;    // ONE
          
               else if(Y == NO2Y &&     X >= NO2X      && X <= NO2X + 2 )  BAR_COLOR = RED; // ZERO
               else if(Y == NO2Y + 4 && X >= NO2X      && X <= NO2X + 2 )  BAR_COLOR = RED; 
               else if(Y >= NO2Y  &&    Y <= NO2Y + 4  && X == NO2X)  BAR_COLOR = RED; 
               else if(Y >= NO2Y  &&    Y <= NO2Y + 4  && X == NO2X + 2)  BAR_COLOR = RED; 
           end
           
           5'b01011:
           begin
                    if(Y == NO1Y &&     X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; // ZERO
               else if(Y == NO1Y + 4 && X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; 
               else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X)  BAR_COLOR = RED; 
               else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED; 
         
               else if(Y == NO2Y &&     X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; // NINE
               else if(Y == NO2Y + 2 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
               else if(Y == NO2Y + 4 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
               else if(Y >= NO2Y  &&    Y <= NO2Y +2  && X == NO2X)  BAR_COLOR = RED; 
               else if(Y >= NO2Y  &&    Y <= NO2Y +4  && X == NO2X + 2)  BAR_COLOR = RED; 
           end
          
           5'b01100:
           begin
                    if(Y == NO1Y &&     X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; // ZERO
               else if(Y == NO1Y + 4 && X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; 
               else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X)  BAR_COLOR = RED; 
               else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED; 
         
               else if(Y == NO2Y &&     X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; // EIGHT
               else if(Y == NO2Y + 2 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
               else if(Y == NO2Y + 4 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
               else if(Y >= NO2Y  &&    Y <= NO2Y +4  && X == NO2X)  BAR_COLOR = RED; 
               else if(Y >= NO2Y  &&    Y <= NO2Y +4  && X == NO2X + 2)  BAR_COLOR = RED; 
          end
          
           5'b01101:
           begin
                    if(Y == NO1Y &&     X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; // ZERO
               else if(Y == NO1Y + 4 && X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; 
               else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X)  BAR_COLOR = RED; 
               else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED; 
         
               else if(Y == NO2Y &&     X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; // SEVEN
               else if(Y >= NO2Y  &&    Y <= NO2Y +4  && X == NO2X + 2)  BAR_COLOR = RED; 
          end
          
           5'b01110:
           begin
                    if(Y == NO1Y &&     X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; // ZERO
               else if(Y == NO1Y + 4 && X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; 
               else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X)  BAR_COLOR = RED; 
               else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED; 
         
               else if(Y == NO2Y &&     X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; // SIX
               else if(Y == NO2Y + 2 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
               else if(Y == NO2Y + 4 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
               else if(Y >= NO2Y  &&    Y <= NO2Y +4  && X == NO2X)  BAR_COLOR = RED; 
               else if(Y >= NO2Y +2 &&  Y <= NO2Y +4  && X == NO2X + 2)  BAR_COLOR = RED; 
          end
          
           5'b01111:
           begin
                    if(Y == NO1Y &&     X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; // ZERO
               else if(Y == NO1Y + 4 && X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; 
               else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X)  BAR_COLOR = RED; 
               else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED; 
         
               else if(Y == NO2Y &&     X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; // FIVE
               else if(Y == NO2Y + 2 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
               else if(Y == NO2Y + 4 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
               else if(Y >= NO2Y  &&    Y <= NO2Y + 2 && X == NO2X)  BAR_COLOR = RED; 
               else if(Y >= NO2Y + 2 && Y <= NO2Y +4  && X == NO2X + 2)  BAR_COLOR = RED; 
          end
          
           5'b10000:
           begin
                    if(Y == NO1Y &&     X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; // ZERO
               else if(Y == NO1Y + 4 && X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; 
               else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X)  BAR_COLOR = RED; 
               else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED; 
         
               else if(Y == NO2Y + 2 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; //FOUR
               else if(Y >= NO2Y  &&    Y <= NO2Y + 2 && X == NO2X)  BAR_COLOR = RED; 
               else if(Y >= NO2Y  &&    Y <= NO2Y +4  && X == NO2X + 2)  BAR_COLOR = RED; 
           end
        
           5'b10001:
          begin
                   if(Y == NO1Y &&     X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; // ZERO
              else if(Y == NO1Y + 4 && X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; 
              else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X)  BAR_COLOR = RED; 
              else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED; 
        
              else if(Y == NO2Y &&     X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; // THREE
              else if(Y == NO2Y + 2 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
              else if(Y == NO2Y + 4 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
              else if(Y >= NO2Y  &&    Y <= NO2Y +4  && X == NO2X + 2)  BAR_COLOR = RED; 
         end
         
          5'b10010:
          begin
                   if(Y == NO1Y &&     X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; // ZERO
              else if(Y == NO1Y + 4 && X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; 
              else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X)  BAR_COLOR = RED; 
              else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED; 
        
              else if(Y == NO2Y &&     X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; // TW0
              else if(Y == NO2Y + 2 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
              else if(Y == NO2Y + 4 && X >= NO2X &&     X <= NO2X + 2 )  BAR_COLOR = RED; 
              else if(Y >= NO2Y + 2 &&    Y <= NO2Y +4  && X == NO2X )  BAR_COLOR = RED; 
              else if(Y >= NO2Y  &&    Y <= NO2Y +2  && X == NO2X + 2)  BAR_COLOR = RED; 
         end
         
          5'b10011:
          begin
                   if(Y == NO1Y &&     X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; // ZERO
              else if(Y == NO1Y + 4 && X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; 
              else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X)  BAR_COLOR = RED; 
              else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED; 
        
              else if(Y >= NO2Y  &&    Y <= NO2Y + 4  && X == NO2X + 2)  BAR_COLOR = RED;    // ONE
          end
         
          5'b10100:
          begin
               if(Y == NO1Y &&     X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; // ZERO
          else if(Y == NO1Y + 4 && X >= NO1X      && X <= NO1X + 2 )  BAR_COLOR = RED; 
          else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X)  BAR_COLOR = RED; 
          else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED; 
          
          else if(Y == NO2Y &&     X >= NO2X      && X <= NO2X + 2 )  BAR_COLOR = RED; // ZERO
          else if(Y == NO2Y + 4 && X >= NO2X      && X <= NO2X + 2 )  BAR_COLOR = RED; 
          else if(Y >= NO2Y  &&    Y <= NO2Y + 4  && X == NO2X)  BAR_COLOR = RED; 
          else if(Y >= NO2Y  &&    Y <= NO2Y + 4  && X == NO2X + 2)  BAR_COLOR = RED; 
          end
           default:
           begin
                if(Y == NO1Y &&     X >= NO1X &&      X <= NO1X + 2 )  BAR_COLOR = RED; // ZERO
           else if(Y == NO1Y + 4 && X >= NO1X &&      X <= NO1X + 2 )  BAR_COLOR = RED; 
           else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X)  BAR_COLOR = RED; 
           else if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  BAR_COLOR = RED; 
           
                if(Y == NO2Y &&     X >= NO2X      && X <= NO2X + 2 )  BAR_COLOR = RED; // ZERO
           else if(Y == NO2Y + 4 && X >= NO2X      && X <= NO2X + 2 )  BAR_COLOR = RED; 
           else if(Y >= NO2Y  &&    Y <= NO2Y + 4  && X == NO2X)  BAR_COLOR = RED; 
           else if(Y >= NO2Y  &&    Y <= NO2Y + 4  && X == NO2X + 2)  BAR_COLOR = RED; 
           end
        endcase       
    end
       else if(OUTCOME == 1)begin
        CONGRATS_ON = 1;
        if(CONGRATS_OLED) BAR_COLOR = RED;
    
        end
        
        else if(OUTCOME == 2)begin
        GAMEOVER_ON=1;
        if(GAMEOVER_OLED) BAR_COLOR = RED;
        end
     

     end
endmodule