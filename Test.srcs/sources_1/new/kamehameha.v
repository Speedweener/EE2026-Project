`timescale 1ns / 1ps

module kamehameha([6:0] X, [5:0] Y, input [11:0] MAXSOUND, input CLK, MID, CLK_DEBOUNCE,
    output reg [15:0] BAR_COLOR = 0, output reg [15:0] LED = 0);
    
      parameter [15:0] WHITE  = 16'hFFFF;
      parameter [15:0] GREEN  = 16'h07E0;
      parameter [15:0] YELLOW = 16'hFFE0;
      parameter [15:0] RED    = 16'hF800;
      parameter [15:0] BLACK  = 16'h0000;
      parameter [15:0] BLUE   = 16'h039C;
      parameter [15:0] PURPLE = 16'hD198;
      parameter [15:0] ORANGE = 16'hFBE0;
      parameter [15:0] CYAN   = 16'h07FD;
      parameter [15:0] PINK   = 16'hFC9C;
    

    reg [4:0] POWERLEVEL = 0;
    reg [4:0] FRAMECOUNTER = 0;
    reg [3:0] JUMPCOUNTER = 0;
    reg [4:0] TIMERCOUNTER;
    
    
    reg [6:0] NO1X = 00;  //For Countdown Timer
    reg [5:0] NO1Y = 00;
    reg [6:0] NO2X = 05;
    reg [5:0] NO2Y = 00;

    reg [6:0] SLIMEX = 82; // Slime Position
    reg [5:0] SLIMEY = 27;
    
    reg [6:0] HEALTHX = 90; // Health Bar
    reg [5:0] HEALTHY = 03;
    reg [5:0] HEALTH = 40;
    
    reg [1:0] OUTCOME = 0;
    reg [3:0] DIVIDER = 0;
    reg [1:0] JUMPDIVIDER = 0;
    reg [5:0] TIMEDIVIDER = 0;

    reg GAMEOVER_ON=0;
    wire GAMEOVER_OLED;
    reg CONGRATS_ON=0;
    wire CONGRATS_OLED;

    game_over displaygameover(.X(X), .Y(Y), .X_START(18), .Y_START(25), .GAMEOVER_ON(GAMEOVER_ON), .ON(GAMEOVER_OLED));
    congrats displaycongrats( .X(X), .Y(Y), .X_START(-27), .Y_START(20), .CONGRATS_ON(CONGRATS_ON), .ON(CONGRATS_OLED));
   

   always @ (posedge CLK_DEBOUNCE)begin
    if(MID) begin
    HEALTH = 40;
    TIMERCOUNTER = 0;
    OUTCOME = 0;
    POWERLEVEL = 0;
    SLIMEX = 82;
    SLIMEY = 27;
    JUMPCOUNTER = 0;
    FRAMECOUNTER = 0;
    DIVIDER=0;
    TIMEDIVIDER=0;
    JUMPDIVIDER=0;
    end
    
    DIVIDER<=DIVIDER+1;
    TIMEDIVIDER<=TIMEDIVIDER+1;
    JUMPDIVIDER<=JUMPDIVIDER+1;


    if(TIMEDIVIDER==49) begin
       TIMERCOUNTER <=TIMERCOUNTER+1;
    end

    if(DIVIDER == 9) begin
    DIVIDER = 0;
    FRAMECOUNTER <=FRAMECOUNTER + 1;
      if(MAXSOUND>3300) begin
       POWERLEVEL <= POWERLEVEL +1;
       LED = LED << 1;
       LED = LED + 1;
       end
       
        if(FRAMECOUNTER == 19)begin
                  HEALTH = HEALTH - ((POWERLEVEL>8) ? 20 : (POWERLEVEL>4) ? 10 : (POWERLEVEL>2) ? 5 : 0 );
                  if(HEALTH >40)
                  HEALTH = 0; //Since Health cannot be <0 
                                                                                                      
                  POWERLEVEL <= 0;
                  LED <= 0;
                  FRAMECOUNTER <=0;
        end    
    
    end //end of divider
    
    if(JUMPDIVIDER==2) begin
      JUMPDIVIDER<= 0;
      
      JUMPCOUNTER <=JUMPCOUNTER + 1;

      case(JUMPCOUNTER)
                 4'b0000: SLIMEY <= SLIMEY-1; 
                 4'b0001: SLIMEY <= SLIMEY-1; 
                 4'b0010: SLIMEY <= SLIMEY+2; 
                 4'b0011: SLIMEY <= SLIMEY+3; 
                 4'b0100: SLIMEY <= SLIMEY+5; 
                 4'b0101: SLIMEY <= SLIMEY+3; 
                 4'b0110: SLIMEY <= SLIMEY+2; 
                 4'b0111: SLIMEY <= SLIMEY+1; 
                 4'b1000: SLIMEY <= SLIMEY+0; 
                 4'b1001: SLIMEY <= SLIMEY+0; 
                 4'b1010: SLIMEY <= SLIMEY-2; 
                 4'b1011: SLIMEY <= SLIMEY-3; 
                 4'b1100: SLIMEY <= SLIMEY-4; 
                 4'b1101: SLIMEY <= SLIMEY-3; 
                 4'b1110: SLIMEY <= SLIMEY-2; 
                 4'b1111: SLIMEY <= SLIMEY-0; 
        endcase
      if(JUMPCOUNTER==15 || JUMPCOUNTER == 8) // MOVES 2 pixels every second - > 20 seconds, 40 pixels
         SLIMEX<=SLIMEX - 1 ;
     end
  
   if(HEALTH<=0) begin
     OUTCOME = 1;
     SLIMEX = 82;
   end
   
   if(SLIMEX<28) begin
     OUTCOME = 2;
     HEALTH = 40;
   end

end


 always @ (*)
    begin
    
    BAR_COLOR = BLACK;
    if(OUTCOME == 0) begin
    if(FRAMECOUNTER<15) begin
        if (X < 14 && X > 8 && (Y == 18 || Y == 26)) BAR_COLOR = RED; //HEAD
        else if ((X == 7 || X ==15) && (Y <25 && Y>19)) BAR_COLOR = RED; //HEAD
        else if ((X == 8 || X ==14) && (Y == 19 || Y==25)) BAR_COLOR = RED; //HEAD
        else if (X == 13 && Y == 21) BAR_COLOR = RED; //HEAD
        
        else if ((X == 11) && (Y <37 && Y>25)) BAR_COLOR = RED; //BODY
        
        else if ((X==10 && Y==36) || (X==9 && Y==37)|| (X==8 && Y==38) // LEFT LEG
        || (X==7 && Y==39) || (X==6 && Y==40)) BAR_COLOR = RED;
        
        else if (X==6 && Y>40 && Y<48) BAR_COLOR = RED;
        
        else if ((X==12 && Y==36) || (X==13 && Y==37)|| (X==14 && Y==38)// RIGHT LEG
          || (X==15 && Y==39) || (X==16 && Y==40)) BAR_COLOR = RED;
          
        else if (X==16 && Y>40 && Y<48) BAR_COLOR = RED;
        
        else if ((X==10 && Y==26) || (X==9 && Y==27)|| (X==8 && Y==28) // LEFT HAND
        || (X==7 && Y==29) || (X==6 && Y==30)) BAR_COLOR = RED;
        
        else if ((X==12 && Y==26) || (X==13 && Y==27)|| (X==14 && Y>=28 && Y<=30) // RIGHT HAND
        || (X==13 && Y==31) || (X==12 && Y==32) || (X==11 && Y==33) || (X==10 && Y==34) || 
        (X==9 && Y==35)) BAR_COLOR = RED;
        
        else if (FRAMECOUNTER==1 && ((X==4 && Y==30) || (X==9 && Y==30) || (X>=6 && X<=7 && Y==32) //CHARGE1
        || (X==4 && Y==35) || (X==9 && Y==35))) BAR_COLOR = CYAN;                                                  
        
        
        else if (FRAMECOUNTER==2 && ((X==5 && Y==31) || (X==8 && Y==31) || (X>=6 && X<=7 && Y>=32 && Y<=33) //CHARGE2
        || (X==5 && Y==34) || (X==8 && Y==34))) BAR_COLOR = CYAN;              
 
        else if (FRAMECOUNTER==3 && ((X==4 && Y==30) || (X==3 && Y==29) || (X>=6 && X<=7 && Y>=32 && Y<=33) //CHARGE3
        ||(X==9 && Y==30) || (X==10 && Y==29) ||(X==4 && Y==35) || (X==3 && Y==36) ||(X==9 && Y==35) || (X==10 && Y==36))) BAR_COLOR = CYAN;              
        
        else if (FRAMECOUNTER==4 && (((X==4 || X==9) && Y==30) || (X>=5 && X<=8 && Y>=31 && Y<=34) //CHARGE4
        || ((X==4 || X==9) && Y==35))) BAR_COLOR = CYAN;              
        
        else if ((FRAMECOUNTER==5||FRAMECOUNTER==7||FRAMECOUNTER==9||FRAMECOUNTER==11||FRAMECOUNTER==13) && (((X==3 || X==10) && (Y==29 || Y == 36)) || ((X==2 || X==11) && (Y==28|| Y == 37)) || (X>=4 && X<=9 && Y>=30 && Y<=35) //CHARGE5
        || ((X==4 || X==9) && Y==35))) BAR_COLOR = CYAN;         
             
        else if ((FRAMECOUNTER==6||FRAMECOUNTER==8||FRAMECOUNTER==10||FRAMECOUNTER==12||FRAMECOUNTER==14) && ((X==2  && Y>=31 && Y<=35) || (X==3 && (Y==30|| Y==31 || Y==36))
        || (X>=4 && X<=8 && Y>=29 && Y<=35) || (X==9 && Y>= 30 && Y<=35) || (X==10 && Y>= 31 && Y<=34) || (X>=4 && X<= 8 && Y==37))) BAR_COLOR = CYAN; 
        
        else if(((X<=(SLIMEX-3) && X>=(SLIMEX-4)) || (X<=(SLIMEX+4) && X>=(SLIMEX+3))) && ((Y==SLIMEY)||(Y==SLIMEY-5)||(Y==SLIMEY-3)||(Y==SLIMEY-2))) BAR_COLOR = BLACK; //EYES
        else if(((X<=(SLIMEX-3) && X>=(SLIMEX-4)) || (X<=(SLIMEX+4) && X>=(SLIMEX+3))) && ((Y==SLIMEY-1)||(Y==SLIMEY-4))) BAR_COLOR = WHITE; //EYES
        else if(((X==(SLIMEX-2) || X==(SLIMEX-5)) || (X==(SLIMEX+5) || X==(SLIMEX+2))) && ((Y==SLIMEY-1)||(Y==(SLIMEY-4)))) BAR_COLOR = BLACK;
        else if(((X==(SLIMEX-1) || X==(SLIMEX-6)) || (X==(SLIMEX+6) || X==(SLIMEX+1))) && ((Y==SLIMEY-2)||(Y==(SLIMEY-3)))) BAR_COLOR = BLACK;
        else if(((X==(SLIMEX-2) || X==(SLIMEX-5)) || (X==(SLIMEX+5) || X==(SLIMEX+2))) && ((Y==SLIMEY-2)||(Y==(SLIMEY-3)))) BAR_COLOR = WHITE;
        
        else if(((X>=SLIMEX-4 &&  X<=SLIMEX+2)) && (Y==SLIMEY+3)) BAR_COLOR = RED; //SMILE
        else if(((X==SLIMEX-5 ||  X==SLIMEX+3)) && (Y==SLIMEY+2)) BAR_COLOR = RED;

        
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
       end
       
       if(FRAMECOUNTER>=15)begin 
       if (X < 14 && X > 8 && (Y == 18 || Y == 26)) BAR_COLOR = RED; //HEAD
       else if ((X == 7 || X ==15) && (Y <25 && Y>19)) BAR_COLOR = RED; //HEAD
       else if ((X == 8 || X ==14) && (Y == 19 || Y==25)) BAR_COLOR = RED; //HEAD
       else if (X == 13 && Y == 21) BAR_COLOR = RED; //HEAD
       
       else if ((X == 11) && (Y <38 && Y>25)) BAR_COLOR = RED; //BODY
       
       else if ((X==10 && Y==38) || (X==9 && Y==39)|| (X==8 && Y==40) // LEFT LEG
       || (X==7 && Y==41) || (X==6 && Y==42) || (X==5 && Y==43) || (X==4 && Y==44)|| (X==3 && Y==45)) BAR_COLOR = RED;
       
       else if ((X>=12 && X<=16 && Y == 37) || (X==16 && Y>=37 && Y<=45)) BAR_COLOR = RED; //RIGHT LEG
         
       else if ((X>=5 && X<= 22 && Y==30) || (X==21 && Y<=35 && Y>=31)|| (X==22 && Y<=30 && Y>=26)) BAR_COLOR = RED; //HANDS
       
      
                                                           
        // POWER1       
        
       else if(X>50 && X<59 && Y>25 && Y<28 && FRAMECOUNTER==17 ) BAR_COLOR = CYAN;
       else if(X>56 && X<59 && Y>27 && Y<30 && FRAMECOUNTER==17 ) BAR_COLOR = CYAN;
       else if(X>22 && X<59 && Y>29 && Y<35 && FRAMECOUNTER==17 ) BAR_COLOR = CYAN;
       else if(X>56 && X<59 && Y>34 && Y<37 && FRAMECOUNTER==17 ) BAR_COLOR = CYAN;
       else if(X>50 && X<59 && Y>36 && Y<39 && FRAMECOUNTER==17 ) BAR_COLOR = CYAN;
       
       else if(X>87 && X<96 && Y>25 && Y<28 && FRAMECOUNTER==18 ) BAR_COLOR = CYAN;
       else if(X>93 && X<96 && Y>27 && Y<30 && FRAMECOUNTER==18 ) BAR_COLOR = CYAN;
       else if(X>22 && X<96 && Y>29 && Y<35 && FRAMECOUNTER==18 ) BAR_COLOR = CYAN;
       else if(X>93 && X<96 && Y>34 && Y<37 && FRAMECOUNTER==18 ) BAR_COLOR = CYAN;
       else if(X>87 && X<96 && Y>36 && Y<39 && FRAMECOUNTER==18 ) BAR_COLOR = CYAN;
       
       
          
          // POWER2       
       else if(X>22 && X<59 && ((Y>34 && Y<39) || (Y>25 && Y<30)) && FRAMECOUNTER==17 && POWERLEVEL >4) BAR_COLOR = YELLOW;
       else if(X>22 && X<96 && ((Y>34 && Y<39) || (Y>25 && Y<30)) && FRAMECOUNTER==18 && POWERLEVEL >4) BAR_COLOR = YELLOW;
           
           // POWER3       
       else if(X>22 && X<59 && ((Y>38 && Y<48) || (Y>18 && Y<26)) && FRAMECOUNTER==17 && POWERLEVEL >8) BAR_COLOR = GREEN;
       else if(X>22 && X<96 && ((Y>38 && Y<48) || (Y>18 && Y<26)) && FRAMECOUNTER==18 && POWERLEVEL >8) BAR_COLOR = GREEN;
       
       
       else if(FRAMECOUNTER>=17 && ((X<=(SLIMEX-3) && X>=(SLIMEX-4)) || (X<=(SLIMEX+4) && X>=(SLIMEX+3))) && ((Y==SLIMEY-3)||(Y==SLIMEY-2))) BAR_COLOR = RED; //EYES
       else if(FRAMECOUNTER>=17 && ((X==(SLIMEX-2) || X==(SLIMEX-5)) || (X==(SLIMEX+5) || X==(SLIMEX+2))) && ((Y==SLIMEY-1)||(Y==(SLIMEY-4)))) BAR_COLOR = RED;
       
       else if(FRAMECOUNTER<=16 && ((X<=(SLIMEX-3) && X>=(SLIMEX-4)) || (X<=(SLIMEX+4) && X>=(SLIMEX+3))) && ((Y==SLIMEY)||(Y==SLIMEY-5)||(Y==SLIMEY-3)||(Y==SLIMEY-2))) BAR_COLOR = BLACK; //EYES
       else if(FRAMECOUNTER<=16 && ((X<=(SLIMEX-3) && X>=(SLIMEX-4)) || (X<=(SLIMEX+4) && X>=(SLIMEX+3))) && ((Y==SLIMEY-1)||(Y==SLIMEY-4))) BAR_COLOR = WHITE; //EYES
       else if(FRAMECOUNTER<=16 && ((X==(SLIMEX-2) || X==(SLIMEX-5)) || (X==(SLIMEX+5) || X==(SLIMEX+2))) && ((Y==SLIMEY-1)||(Y==(SLIMEY-4)))) BAR_COLOR = BLACK;
       else if(FRAMECOUNTER<=16 && ((X==(SLIMEX-1) || X==(SLIMEX-6)) || (X==(SLIMEX+6) || X==(SLIMEX+1))) && ((Y==SLIMEY-2)||(Y==(SLIMEY-3)))) BAR_COLOR = BLACK;
       else if(FRAMECOUNTER<=16 && ((X==(SLIMEX-2) || X==(SLIMEX-5)) || (X==(SLIMEX+5) || X==(SLIMEX+2))) && ((Y==SLIMEY-2)||(Y==(SLIMEY-3)))) BAR_COLOR = WHITE;
       
       else if(FRAMECOUNTER<=16 && ((X>=SLIMEX-4 &&  X<=SLIMEX+2)) && (Y==SLIMEY+3)) BAR_COLOR = RED; //SMILE
       else if(FRAMECOUNTER<=16 && ((X==SLIMEX-5 ||  X==SLIMEX+3)) && (Y==SLIMEY+2)) BAR_COLOR = RED;

       
       else if(FRAMECOUNTER>=17 && ((X>=SLIMEX-4 &&  X<=SLIMEX+2)) && (Y==SLIMEY+3)) BAR_COLOR = RED; //SMILE
       else if(FRAMECOUNTER>=17 && ((X==SLIMEX-5 ||  X==SLIMEX+3)) && (Y==SLIMEY+4)) BAR_COLOR = RED;
       
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
       end
       
            if(Y>=HEALTHY && Y<=HEALTHY+2 &&  X>=HEALTHX-HEALTH && X<=HEALTHX) BAR_COLOR = GREEN;
       else if(Y>=HEALTHY && Y<=HEALTHY+2 &&  X>=HEALTHX-40 && X<=HEALTHX) BAR_COLOR = RED;
       
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