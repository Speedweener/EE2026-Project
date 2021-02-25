`timescale 1ns / 1ps

module menu([6:0] X, [5:0] Y, input UP, LEFT, DOWN, RIGHT, MID, CLK_DEBOUNCE, CLK_5HZ,
    output reg [2:0] MODE = 0, output reg [15:0] MENU_COLOR = 0
    );
    
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
      
    reg [15:0] MENULED = 16'b1010101010101010;
    reg [2:0] SELECT = 0;

    reg [2:0] FRAME = 0;
      
    always @ (posedge CLK_DEBOUNCE)begin
          if(RIGHT && (SELECT == 0 || SELECT == 2))
             SELECT <= SELECT + 1;
             
          else if(LEFT && (SELECT == 1 || SELECT == 3))
             SELECT <= SELECT - 1;
             
          else if(DOWN && (SELECT == 0 || SELECT == 1))
             SELECT <= SELECT + 2;
             
          else if(UP && (SELECT == 2 || SELECT == 3))
             SELECT <= SELECT - 2;
             
          else if(MID && (SELECT == 0)) begin
             SELECT <= 5;
             MODE <= 1;
          end
          
          else if(MID && (SELECT == 1)) begin
             SELECT <= 5;
             MODE <= 2;
          end
          
          else if(MID && (SELECT == 2)) begin
             SELECT <= 5;
             MODE <= 3;
          end
          
          else if(MID && (SELECT == 3)) begin
             SELECT <= 5;
             MODE <= 4;
          end
          
          else if(UP && (SELECT == 5)) begin
             SELECT <= 0;
             MODE <= 0;
          end
          
          end
      
    
    reg [6:0] NO1X = 16;  //MIC (WORDS)
      reg [5:0] NO1Y = 24;
      
      reg [6:0] NO2X = 59;  // GAME1(WORDS)
      reg [5:0] NO2Y = 24;
      
      reg [6:0] NO3X = 11;  // GAME2(WORDS)
      reg [5:0] NO3Y = 56;
      
      reg [6:0] NO4X = 59;  // GAME3(WORDS)
      reg [5:0] NO4Y = 56;
      
      reg [6:0] NO5X = 15; // MIC ANIMATION
      reg [5:0] NO5Y = 11;
      
      reg [6:0] NO6X = 52; // KAMEHAMEHA ANIMATION
      reg [5:0] NO6Y = 8;
      
      reg [6:0] NO7X = 16;  //BLOW ANIMATION
      reg [5:0] NO7Y = 40;
      
      reg [6:0] NO8X = 58; // PITCH PERFECT ANIMATION
      reg [5:0] NO8Y = 41;
    
    always @ (posedge CLK_5HZ) begin
       FRAME <= (FRAME==4) ? 0 : FRAME+1;
    end
      
          
    
    always @ (X or Y)
     begin
               if((Y == NO1Y || Y == NO1Y + 5) &&  ((X >= NO1X +7 && X <= NO1X + 9) || (X >= NO1X+12 && X <= NO1X + 14)))  MENU_COLOR = RED; // MIC
        else if(Y == NO1Y + 1 && (X == NO1X +1 || X == NO1X +3))  MENU_COLOR = RED; 
        else if(Y >= NO1Y + 2 && Y <= NO1Y + 3 && X == NO1X +2 )  MENU_COLOR = RED; 
        else if(Y >= NO1Y  && Y <= NO1Y +5  && (X == NO1X || X==NO1X + 4 || X==NO1X + 8 || X==NO1X + 12))  MENU_COLOR = RED; 
        
        else if((Y == NO2Y)  && ((X >= NO2X+1 && X <=NO2X + 3) || (X >= NO2X+7 && X <= NO2X +9) || (X == NO2X+12) || (X == NO2X +16) || (X>=NO2X +19 && X<=NO2X +21)))  MENU_COLOR = RED; // GAME 
        else if((Y == NO2Y+1) &&  ((X==NO2X) || (X==NO2X+4) || (X==NO2X+7) ||      (X==NO2X+9) ||  (X >= NO2X+12 && X <= NO2X+13) || (X == NO2X+15) || (X == NO2X +16) || (X==NO2X +19)))  MENU_COLOR = RED; 
        else if((Y == NO2Y+2) &&  ((X==NO2X) || (X==NO2X+7) || (X==NO2X+9) ||    (X == NO2X+12) || (X == NO2X+14) || (X == NO2X +16) || (X>=NO2X +19 && X<=NO2X +21)))  MENU_COLOR = RED; 
        else if((Y == NO2Y+3) &&  ((X==NO2X) || (X==NO2X+3) ||(X==NO2X+4) ||  (X>=NO2X+7 && X<=NO2X+9) || (X == NO2X+12) || (X == NO2X+14) || (X == NO2X +16) || (X==NO2X +19)))  MENU_COLOR = RED; 
        else if((Y == NO2Y+4) &&  ((X==NO2X) || (X==NO2X+4) || (X==NO2X+7) || (X==NO2X+9) || (X == NO2X+12) || (X == NO2X+12)|| (X == NO2X +16) || (X==NO2X +19)))  MENU_COLOR = RED; 
        else if((Y == NO2Y+5) && ((X>= NO2X +1 && X <= NO2X + 3) ||         (X == NO2X+7) || (X == NO2X +9) || (X == NO2X+12) || (X == NO2X +16) || (X>=NO2X +19 && X<=NO2X +21)))  MENU_COLOR = RED; 
        
        else if((Y >= NO2Y && Y <= NO2Y+5) &&  (X == NO2X +26))  MENU_COLOR = RED; // ONE
        else if((Y == NO2Y +1) &&  (X == NO2X +25))  MENU_COLOR = RED; 
        
        else if((Y == NO3Y)  && ((X >= NO3X+1 && X <=NO3X + 3) || (X >= NO3X+7 && X <= NO3X +9) || (X == NO3X+12) || (X == NO3X +16) || (X>=NO3X +19 && X<=NO3X +21)))  MENU_COLOR = RED; // GAME 
        else if((Y == NO3Y+1) &&  ((X==NO3X) || (X==NO3X+4) || (X==NO3X+7) ||      (X==NO3X+9) ||  (X >= NO3X+12 && X <= NO3X+13) || (X == NO3X+15) || (X == NO3X +16) || (X==NO3X +19)))  MENU_COLOR = RED; 
        else if((Y == NO3Y+2) &&  ((X==NO3X) || (X==NO3X+7) || (X==NO3X+9) ||    (X == NO3X+12) || (X == NO3X+14) || (X == NO3X +16) || (X>=NO3X +19 && X<=NO3X +21)))  MENU_COLOR = RED; 
        else if((Y == NO3Y+3) &&  ((X==NO3X) || (X==NO3X+3) ||(X==NO3X+4) ||  (X>=NO3X+7 && X<=NO3X+9) || (X == NO3X+12) || (X == NO3X+14) || (X == NO3X +16) || (X==NO3X +19)))  MENU_COLOR = RED; 
        else if((Y == NO3Y+4) &&  ((X==NO3X) || (X==NO3X+4) || (X==NO3X+7) || (X==NO3X+9) || (X == NO3X+12) || (X == NO3X +16) || (X==NO3X +19)))  MENU_COLOR = RED; 
        else if((Y == NO3Y+5) && ((X>= NO3X +1 && X <= NO3X + 3) ||         (X == NO3X+7) || (X == NO3X +9) || (X == NO3X+12) || (X == NO3X +16) || (X>=NO3X +19 && X<=NO3X +21)))  MENU_COLOR = RED; 
        
        else if((Y == NO3Y || Y == NO3Y+2 || Y == NO3Y+5) &&  (X >= NO3X +25 && X <= NO3X +27))  MENU_COLOR = RED; // TWO
        else if((Y >= NO3Y +2 && Y <= NO3Y +5) &&  (X == NO3X+25))  MENU_COLOR = RED; 
        else if((Y >= NO3Y && Y <= NO3Y +2) &&  (X == NO3X+27))  MENU_COLOR = RED; 
        
        else if((Y == NO4Y)  && ((X >= NO4X+1 && X <=NO4X + 3) || (X >= NO4X+7 && X <= NO4X +9) || (X == NO4X+12) || (X == NO4X +16) || (X>=NO4X +19 && X<=NO4X +21)))  MENU_COLOR = RED; // GAME 
        else if((Y == NO4Y+1) &&  ((X==NO4X) || (X==NO4X+4) || (X==NO4X+7) ||      (X==NO4X+9) ||  (X >= NO4X+12 && X <= NO4X+13) || (X == NO4X+15) || (X == NO4X +16) || (X==NO4X +19)))  MENU_COLOR = RED; 
        else if((Y == NO4Y+2) &&  ((X==NO4X) || (X==NO4X+7) || (X==NO4X+9) ||    (X == NO4X+12) || (X == NO4X+14) || (X == NO4X +16) || (X>=NO4X +19 && X<=NO4X +21)))  MENU_COLOR = RED; 
        else if((Y == NO4Y+3) &&  ((X==NO4X) || (X==NO4X+3) ||(X==NO4X+4) ||  (X>=NO4X+7 && X<=NO4X+9) || (X == NO4X+12) || (X == NO4X+14) || (X == NO4X +16) || (X==NO4X +19)))  MENU_COLOR = RED; 
        else if((Y == NO4Y+4) &&  ((X==NO4X) || (X==NO4X+4) || (X==NO4X+7) || (X==NO4X+9) || (X == NO4X+12) || (X == NO4X +16) || (X==NO4X +19)))  MENU_COLOR = RED; 
        else if((Y == NO4Y+5) && ((X>= NO4X +1 && X <= NO4X + 3) ||         (X == NO4X+7) || (X == NO4X +9) || (X == NO4X+12) || (X == NO4X +16) || (X>=NO4X +19 && X<=NO4X +21)))  MENU_COLOR = RED; 
        
        else if((Y == NO4Y || Y == NO4Y+2 || Y == NO4Y+5) &&  (X >= NO4X +25 && X <= NO4X +27))  MENU_COLOR = RED; // THREE
        else if((Y >= NO4Y && Y <= NO4Y +5) &&  (X == NO4X+27))  MENU_COLOR = RED; 
         
        
        
        
        else if (X >=  4 && X <= 43 && Y >=  2 && Y <= 29) MENU_COLOR = BLACK; //FIRST BOX
        else if (X >= 52 && X <= 91 && Y >=  2 && Y <= 29) MENU_COLOR = BLACK; //SECOND BOX
        else if (X >=  4 && X <= 43 && Y >= 34 && Y <= 61) MENU_COLOR = BLACK; //THIRD BOX
        else if (X >= 52 && X <= 91 && Y >= 34 && Y <= 61) MENU_COLOR = BLACK; //FOURTH BOX
        
        else if (SELECT == 0 && X >= 2 && X <= 45 && Y >= 0 && Y <= 31) MENU_COLOR = GREEN; //SELECT FIRST
        else if (SELECT == 1 && X >= 50 && X <= 93 && Y >= 0 && Y <= 31) MENU_COLOR = GREEN; //SELECT SECOND
        else if (SELECT == 2 && X >= 2 && X <= 45 && Y >= 32 && Y <= 63) MENU_COLOR = GREEN; //SELECT THIRD
        else if (SELECT == 3 && X >= 50 && X <= 93 && Y >= 32 && Y <= 63) MENU_COLOR = GREEN; //SELECT FOURTH
        
        
        else MENU_COLOR = BLACK;

        case(FRAME)
      3'b000: begin


           if((Y == NO5Y-4 || Y == NO5Y-1 || Y == NO5Y+2 || Y == NO5Y+5 || Y == NO5Y+8) && X >= NO5X +19 && X <= NO5X+24) MENU_COLOR = RED; //MICROPHONE
      else if(Y >= NO5Y-3 && Y <= NO5Y+7 && (X == NO5X +18 || X == NO5X+20 || X == NO5X+23 || X == NO5X+25)) MENU_COLOR = RED; //MICROPHONE
      else if((Y == NO5Y+9 || Y == NO5Y+10) && X >= NO5X +21 && X <= NO5X+22) MENU_COLOR = RED; //MICROPHONE
      else if((Y == NO5Y+11) && X >= NO5X +18 && X <= NO5X+25) MENU_COLOR = RED; //MICROPHONE
      
      else if((Y == NO5Y|| Y == NO5Y+3) && X == NO5X) MENU_COLOR = RED; //WAVE 1
      else if((Y == NO5Y+1|| Y == NO5Y+2) && X == NO5X+1) MENU_COLOR = RED; //WAVE 1
      
      else if((Y == NO5Y-1 || Y == NO5Y+4) && X == NO5X+3) MENU_COLOR = RED; //WAVE 2
      else if((Y >= NO5Y && Y <= NO5Y+3) && X == NO5X+4) MENU_COLOR = RED; //WAVE 2


      else if(Y == NO6Y     && X >= NO6X && X <= NO6X+39) MENU_COLOR = GREEN;
      else if(Y == NO6Y + 1 && X >= NO6X && X <= NO6X+39) MENU_COLOR = GREEN;
      else if(Y == NO6Y + 2 && X >= NO6X && X <= NO6X+39) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 3 && X >= NO6X && X <= NO6X+39) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 4 && X >= NO6X && X <= NO6X+39) MENU_COLOR = BLUE;
      else if(Y == NO6Y + 5 && X >= NO6X && X <= NO6X+39) MENU_COLOR = BLUE;
      else if(Y == NO6Y + 6 && X >= NO6X && X <= NO6X+39) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 7 && X >= NO6X && X <= NO6X+39) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 8 && X >= NO6X && X <= NO6X+39) MENU_COLOR = GREEN;
      else if(Y == NO6Y + 9 && X >= NO6X && X <= NO6X+39) MENU_COLOR = GREEN;
      
      else if(Y == NO7Y && ((X >= NO7X && X <= NO7X+4)||(X >= NO7X+11 && X <= NO7X+15))) MENU_COLOR = RED; //EYES
      
      else if(((Y == NO7Y+6)||(Y==NO7Y+9)) && (X >= NO7X+5 && X <= NO7X+9)) MENU_COLOR = RED; //MOUTH SMALL
      else if((Y >= NO7Y+6 && Y<=NO7Y+9) && (X == NO7X+5 || X == NO7X+9)) MENU_COLOR = RED; 
 
      else if(Y >= NO8Y+1 && Y <= NO8Y+6 && (X == NO8X || X == NO8X+3)) MENU_COLOR = RED; //SYMBOL1
      else if(Y == NO8Y+1 && (X >= NO8X && X <= NO8X+3)) MENU_COLOR = RED;
      else if(Y >= NO8Y+5 && Y <= NO8Y+6 && (X== NO8X-1 || X == NO8X+2)) MENU_COLOR = RED;
      
      else if(Y >= NO8Y +3 && Y <= NO8Y+8 && X == NO8X+7 ) MENU_COLOR = GREEN; //SYMBOL2
      else if(Y == NO8Y +3 && (X >= NO8X+7 && X <= NO8X+9)) MENU_COLOR = GREEN;
      else if(Y >= NO8Y+7 && Y <= NO8Y+8 && X== NO8X+6) MENU_COLOR = GREEN;

      else if(Y >= NO8Y+2 && Y <= NO8Y+7 && (X == NO8X+15 || X == NO8X+18)) MENU_COLOR = RED; //SYMBOL1
      else if(Y == NO8Y+2 && (X >= NO8X+15 && X <= NO8X+18)) MENU_COLOR = RED;
      else if(Y >= NO8Y+6 && Y <= NO8Y+7 && (X== NO8X+14 || X == NO8X+17)) MENU_COLOR = RED;

      else if(Y >= NO8Y +3 && Y <= NO8Y+8 && X == NO8X+23 ) MENU_COLOR = GREEN; //SYMBOL2
      else if(Y == NO8Y +3 && (X >= NO8X+23 && X <= NO8X+25)) MENU_COLOR = GREEN;
      else if(Y >= NO8Y+7 && Y <= NO8Y+8 && X== NO8X+22) MENU_COLOR = GREEN;

     
      
     
      
      end
      
      3'b001: begin
        
           if((Y == NO5Y-4 || Y == NO5Y-1 || Y == NO5Y+2 || Y == NO5Y+5 || Y == NO5Y+8) && X >= NO5X +19 && X <= NO5X+24) MENU_COLOR = RED; //MICROPHONE
      else if(Y >= NO5Y-3 && Y <= NO5Y+7 && (X == NO5X +18 || X == NO5X+20 || X == NO5X+23 || X == NO5X+25)) MENU_COLOR = RED; //MICROPHONE
      else if((Y == NO5Y+9 || Y == NO5Y+10) && X >= NO5X +21 && X <= NO5X+22) MENU_COLOR = RED; //MICROPHONE
      else if((Y == NO5Y+11) && X >= NO5X +18 && X <= NO5X+25) MENU_COLOR = RED; //MICROPHONE
  
      else if((Y == NO5Y|| Y == NO5Y+3) && X == NO5X) MENU_COLOR = RED; //WAVE 1
      else if((Y == NO5Y+1|| Y == NO5Y+2) && X == NO5X+1) MENU_COLOR = RED; //WAVE 1
     
      else if((Y == NO5Y-1 || Y == NO5Y+4) && X == NO5X+3) MENU_COLOR = RED; //WAVE 2
      else if((Y >= NO5Y && Y <= NO5Y+3) && X == NO5X+4) MENU_COLOR = RED; //WAVE 2
      
      else if((Y == NO5Y-3 || Y == NO5Y+6) && X == NO5X+6) MENU_COLOR = RED; //WAVE 3
      else if((Y == NO5Y-2 || Y == NO5Y+5) && X == NO5X+7) MENU_COLOR = RED; //WAVE 3
      else if((Y >= NO5Y-1 && Y <= NO5Y+4) && X == NO5X+8) MENU_COLOR = RED; //WAVE 3
   
      else if(Y == NO6Y     && X >= NO6X && X <= NO6X+7) MENU_COLOR = GREEN;
      else if(Y == NO6Y + 1 && X >= NO6X && X <= NO6X+7) MENU_COLOR = GREEN;
      else if(Y == NO6Y + 2 && X >= NO6X && X <= NO6X+7) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 3 && X >= NO6X && X <= NO6X+7) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 4 && X >= NO6X && X <= NO6X+7) MENU_COLOR = BLUE;
      else if(Y == NO6Y + 5 && X >= NO6X && X <= NO6X+7) MENU_COLOR = BLUE;
      else if(Y == NO6Y + 6 && X >= NO6X && X <= NO6X+7) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 7 && X >= NO6X && X <= NO6X+7) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 8 && X >= NO6X && X <= NO6X+7) MENU_COLOR = GREEN;
      else if(Y == NO6Y + 9 && X >= NO6X && X <= NO6X+7) MENU_COLOR = GREEN;

      else if(Y == NO7Y && ((X >= NO7X && X <= NO7X+4)||(X >= NO7X+11 && X <= NO7X+15))) MENU_COLOR = RED; //EYES
      
      else if(((Y == NO7Y+6)||(Y==NO7Y+9)) && (X >= NO7X+5 && X <= NO7X+9)) MENU_COLOR = RED; //MOUTH SMALL
      else if((Y >= NO7Y+6 && Y<=NO7Y+9) && (X == NO7X+5 || X == NO7X+9)) MENU_COLOR = RED; 
      
      else if(Y == NO7Y+11 && (X == NO7X+5 || X == NO7X+7 || X == NO7X+9)) MENU_COLOR = RED; //WIND
      else if(Y == NO7Y+12 && (X == NO7X+4 || X == NO7X+7 || X == NO7X+10)) MENU_COLOR = RED; //WIND
      else if(Y == NO7Y+13 && (X == NO7X+3 || X == NO7X+7 || X == NO7X+11)) MENU_COLOR = RED; //WIND


      else if(Y >= NO8Y && Y <= NO8Y+5 && (X == NO8X || X == NO8X+3)) MENU_COLOR = RED; //SYMBOL1
      else if(Y == NO8Y && (X >= NO8X && X <= NO8X+3)) MENU_COLOR = RED;
      else if(Y >= NO8Y+4 && Y <= NO8Y+5 && (X== NO8X-1 || X == NO8X+2)) MENU_COLOR = RED;

      end
      
      3'b010: begin

           if((Y == NO5Y-4 || Y == NO5Y-1 || Y == NO5Y+2 || Y == NO5Y+5 || Y == NO5Y+8) && X >= NO5X +19 && X <= NO5X+24) MENU_COLOR = RED; //MICROPHONE
      else if(Y >= NO5Y-3 && Y <= NO5Y+7 && (X == NO5X +18 || X == NO5X+20 || X == NO5X+23 || X == NO5X+25)) MENU_COLOR = RED; //MICROPHONE
      else if((Y == NO5Y+9 || Y == NO5Y+10) && X >= NO5X +21 && X <= NO5X+22) MENU_COLOR = RED; //MICROPHONE
      else if((Y == NO5Y+11) && X >= NO5X +18 && X <= NO5X+25) MENU_COLOR = RED; //MICROPHONE
     
      else if((Y == NO5Y|| Y == NO5Y+3) && X == NO5X) MENU_COLOR = RED; //WAVE 1
      else if((Y == NO5Y+1|| Y == NO5Y+2) && X == NO5X+1) MENU_COLOR = RED; //WAVE 1
     
      else if((Y == NO5Y-1 || Y == NO5Y+4) && X == NO5X+3) MENU_COLOR = RED; //WAVE 2
      else if((Y >= NO5Y && Y <= NO5Y+3) && X == NO5X+4) MENU_COLOR = RED; //WAVE 2
      
      else if((Y == NO5Y-3 || Y == NO5Y+6) && X == NO5X+6) MENU_COLOR = RED; //WAVE 3
      else if((Y == NO5Y-2 || Y == NO5Y+5) && X == NO5X+7) MENU_COLOR = RED; //WAVE 3
      else if((Y >= NO5Y-1 && Y <= NO5Y+4) && X == NO5X+8) MENU_COLOR = RED; //WAVE 3
      
      else if((Y == NO5Y-6 || Y == NO5Y+9) && X == NO5X+9) MENU_COLOR = RED; //WAVE 4
      else if((Y == NO5Y-5 || Y == NO5Y+8) && X == NO5X+10) MENU_COLOR = RED; //WAVE 4
      else if((Y == NO5Y-4 || Y == NO5Y+7) && X == NO5X+11) MENU_COLOR = RED; //WAVE 4
      else if((Y >= NO5Y-3 && Y <= NO5Y+6) && X == NO5X+12) MENU_COLOR = RED; //WAVE 4




      else if(Y == NO6Y     && X >= NO6X && X <= NO6X+15) MENU_COLOR = GREEN;
      else if(Y == NO6Y + 1 && X >= NO6X && X <= NO6X+15) MENU_COLOR = GREEN;
      else if(Y == NO6Y + 2 && X >= NO6X && X <= NO6X+15) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 3 && X >= NO6X && X <= NO6X+15) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 4 && X >= NO6X && X <= NO6X+15) MENU_COLOR = BLUE;
      else if(Y == NO6Y + 5 && X >= NO6X && X <= NO6X+15) MENU_COLOR = BLUE;
      else if(Y == NO6Y + 6 && X >= NO6X && X <= NO6X+15) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 7 && X >= NO6X && X <= NO6X+15) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 8 && X >= NO6X && X <= NO6X+15) MENU_COLOR = GREEN;
      else if(Y == NO6Y + 9 && X >= NO6X && X <= NO6X+15) MENU_COLOR = GREEN;

      else if(Y == NO7Y && ((X >= NO7X && X <= NO7X+4)||(X >= NO7X+11 && X <= NO7X+15))) MENU_COLOR = RED; //EYES
      
      else if(((Y == NO7Y+6)||(Y==NO7Y+9)) && (X >= NO7X+5 && X <= NO7X+9)) MENU_COLOR = RED; //MOUTH SMALL
      else if((Y >= NO7Y+6 && Y<=NO7Y+9) && (X == NO7X+5 || X == NO7X+9)) MENU_COLOR = RED; 
      
      else if(Y == NO7Y+13 && (X == NO7X+3 || X == NO7X+7 || X == NO7X+11)) MENU_COLOR = RED; //WIND 2
      else if(Y == NO7Y+14 && (X == NO7X+2 || X == NO7X+7 || X == NO7X+12)) MENU_COLOR = RED; //WIND 2
      else if(Y == NO7Y+15 && (X == NO7X+1 ||  X == NO7X+13)) MENU_COLOR = RED; //WIND 2


      else if(Y >= NO8Y-1 && Y <= NO8Y+4 && (X == NO8X || X == NO8X+3)) MENU_COLOR = RED; //SYMBOL1
      else if(Y == NO8Y-1 && (X >= NO8X && X <= NO8X+3)) MENU_COLOR = RED;
      else if(Y >= NO8Y+3 && Y <= NO8Y+4 && (X== NO8X-1 || X == NO8X+2)) MENU_COLOR = RED;
      
      else if(Y >= NO8Y +4 && Y <= NO8Y+9 && X == NO8X+7 ) MENU_COLOR = GREEN; //SYMBOL2
      else if(Y == NO8Y +4 && (X >= NO8X+7 && X <= NO8X+9)) MENU_COLOR = GREEN;
      else if(Y >= NO8Y+8 && Y <= NO8Y+9 && X== NO8X+6) MENU_COLOR = GREEN;

      end
      
      3'b011: begin
           if((Y == NO5Y-4 || Y == NO5Y-1 || Y == NO5Y+2 || Y == NO5Y+5 || Y == NO5Y+8) && X >= NO5X +19 && X <= NO5X+24) MENU_COLOR = RED; //MICROPHONE
      else if(Y >= NO5Y-3 && Y <= NO5Y+7 && (X == NO5X +18 || X == NO5X+20 || X == NO5X+23 || X == NO5X+25)) MENU_COLOR = RED; //MICROPHONE
      else if((Y == NO5Y+9 || Y == NO5Y+10) && X >= NO5X +21 && X <= NO5X+22) MENU_COLOR = RED; //MICROPHONE
      else if((Y == NO5Y+11) && X >= NO5X +18 && X <= NO5X+25) MENU_COLOR = RED; //MICROPHONE
          
      else if(Y == NO6Y     && X >= NO6X && X <= NO6X+23) MENU_COLOR = GREEN;
      else if(Y == NO6Y + 1 && X >= NO6X && X <= NO6X+23) MENU_COLOR = GREEN;
      else if(Y == NO6Y + 2 && X >= NO6X && X <= NO6X+23) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 3 && X >= NO6X && X <= NO6X+23) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 4 && X >= NO6X && X <= NO6X+23) MENU_COLOR = BLUE;
      else if(Y == NO6Y + 5 && X >= NO6X && X <= NO6X+23) MENU_COLOR = BLUE;
      else if(Y == NO6Y + 6 && X >= NO6X && X <= NO6X+23) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 7 && X >= NO6X && X <= NO6X+23) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 8 && X >= NO6X && X <= NO6X+23) MENU_COLOR = GREEN;
      else if(Y == NO6Y + 9 && X >= NO6X && X <= NO6X+23) MENU_COLOR = GREEN;

      else if(Y == NO7Y && ((X >= NO7X && X <= NO7X+4)||(X >= NO7X+11 && X <= NO7X+15))) MENU_COLOR = RED; //EYES
      
      else if(((Y == NO7Y+4)||(Y==NO7Y+11)) && (X >= NO7X+5 && X <= NO7X+10)) MENU_COLOR = RED; //MOUTH BIG
      else if((Y >= NO7Y+5 && Y<=NO7Y+10) && (X == NO7X+4 || X == NO7X+11)) MENU_COLOR = RED; 
      


      else if(Y >= NO8Y+1 && Y <= NO8Y+6 && (X == NO8X || X == NO8X+3)) MENU_COLOR = RED; //SYMBOL1
      else if(Y == NO8Y+1 && (X >= NO8X && X <= NO8X+3)) MENU_COLOR = RED;
      else if(Y >= NO8Y+5 && Y <= NO8Y+6 && (X== NO8X-1 || X == NO8X+2)) MENU_COLOR = RED;
      
      else if(Y >= NO8Y +3 && Y <= NO8Y+8 && X == NO8X+7 ) MENU_COLOR = GREEN; //SYMBOL2
      else if(Y == NO8Y +3 && (X >= NO8X+7 && X <= NO8X+9)) MENU_COLOR = GREEN;
      else if(Y >= NO8Y+7 && Y <= NO8Y+8 && X== NO8X+6) MENU_COLOR = GREEN;

      else if(Y >= NO8Y+2 && Y <= NO8Y+7 && (X == NO8X+15 || X == NO8X+18)) MENU_COLOR = RED; //SYMBOL1
      else if(Y == NO8Y+2 && (X >= NO8X+15 && X <= NO8X+18)) MENU_COLOR = RED;
      else if(Y >= NO8Y+6 && Y <= NO8Y+7 && (X== NO8X+14 || X == NO8X+17)) MENU_COLOR = RED;


      end
      
      3'b100: begin
           if((Y == NO5Y-4 || Y == NO5Y-1 || Y == NO5Y+2 || Y == NO5Y+5 || Y == NO5Y+8) && X >= NO5X +19 && X <= NO5X+24) MENU_COLOR = RED; //MICROPHONE
      else if(Y >= NO5Y-3 && Y <= NO5Y+7 && (X == NO5X +18 || X == NO5X+20 || X == NO5X+23 || X == NO5X+25)) MENU_COLOR = RED; //MICROPHONE
      else if((Y == NO5Y+9 || Y == NO5Y+10) && X >= NO5X +21 && X <= NO5X+22) MENU_COLOR = RED; //MICROPHONE
      else if((Y == NO5Y+11) && X >= NO5X +18 && X <= NO5X+25) MENU_COLOR = RED; //MICROPHONE
      
      else if((Y == NO5Y|| Y == NO5Y+3) && X == NO5X) MENU_COLOR = RED; //WAVE 1
      else if((Y == NO5Y+1|| Y == NO5Y+2) && X == NO5X+1) MENU_COLOR = RED; //WAVE 1

      
      else if(Y == NO6Y     && X >= NO6X && X <= NO6X+31) MENU_COLOR = GREEN;
      else if(Y == NO6Y + 1 && X >= NO6X && X <= NO6X+31) MENU_COLOR = GREEN;
      else if(Y == NO6Y + 2 && X >= NO6X && X <= NO6X+31) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 3 && X >= NO6X && X <= NO6X+31) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 4 && X >= NO6X && X <= NO6X+31) MENU_COLOR = BLUE;
      else if(Y == NO6Y + 5 && X >= NO6X && X <= NO6X+31) MENU_COLOR = BLUE;
      else if(Y == NO6Y + 6 && X >= NO6X && X <= NO6X+31) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 7 && X >= NO6X && X <= NO6X+31) MENU_COLOR = YELLOW;
      else if(Y == NO6Y + 8 && X >= NO6X && X <= NO6X+31) MENU_COLOR = GREEN;
      else if(Y == NO6Y + 9 && X >= NO6X && X <= NO6X+31) MENU_COLOR = GREEN;

      else if(Y == NO7Y && ((X >= NO7X && X <= NO7X+4)||(X >= NO7X+11 && X <= NO7X+15))) MENU_COLOR = RED; //EYES
      
      else if(((Y == NO7Y+6)||(Y==NO7Y+10)) && (X >= NO7X+6 && X <= NO7X+9)) MENU_COLOR = RED; //MOUTH MEDIUM
      else if((Y >= NO7Y+6 && Y<=NO7Y+9) && (X == NO7X+5 || X == NO7X+10)) MENU_COLOR = RED; 

      else if(Y >= NO8Y && Y <= NO8Y+5 && (X == NO8X || X == NO8X+3)) MENU_COLOR = RED; //SYMBOL1
      else if(Y == NO8Y && (X >= NO8X && X <= NO8X+3)) MENU_COLOR = RED;
      else if(Y >= NO8Y+4 && Y <= NO8Y+5 && (X== NO8X-1 || X == NO8X+2)) MENU_COLOR = RED;
      
      else if(Y >= NO8Y +5 && Y <= NO8Y+10 && X == NO8X+7 ) MENU_COLOR = GREEN; //SYMBOL2
      else if(Y == NO8Y +5 && (X >= NO8X+7 && X <= NO8X+9)) MENU_COLOR = GREEN;
      else if(Y >= NO8Y+9 && Y <= NO8Y+10 && X== NO8X+6) MENU_COLOR = GREEN;

      else if(Y >= NO8Y && Y <= NO8Y+5 && (X == NO8X+15 || X == NO8X+18)) MENU_COLOR = RED; //SYMBOL1
      else if(Y == NO8Y && (X >= NO8X+15 && X <= NO8X+18)) MENU_COLOR = RED;
      else if(Y >= NO8Y+4 && Y <= NO8Y+5 && (X== NO8X+14 || X == NO8X+17)) MENU_COLOR = RED;

      else if(Y >= NO8Y +4 && Y <= NO8Y+9 && X == NO8X+23 ) MENU_COLOR = GREEN; //SYMBOL2
      else if(Y == NO8Y +4 && (X >= NO8X+23 && X <= NO8X+25)) MENU_COLOR = GREEN;
      else if(Y >= NO8Y+8 && Y <= NO8Y+9 && X== NO8X+22) MENU_COLOR = GREEN;
      end
      default: begin
                         if((Y == NO5Y-4 || Y == NO5Y-1 || Y == NO5Y+2 || Y == NO5Y+5 || Y == NO5Y+8) && X >= NO5X +19 && X <= NO5X+24) MENU_COLOR = RED; //MICROPHONE
                    else if(Y >= NO5Y-3 && Y <= NO5Y+7 && (X == NO5X +18 || X == NO5X+20 || X == NO5X+23 || X == NO5X+25)) MENU_COLOR = RED; //MICROPHONE
                    else if((Y == NO5Y+9 || Y == NO5Y+10) && X >= NO5X +21 && X <= NO5X+22) MENU_COLOR = RED; //MICROPHONE
                    else if((Y == NO5Y+11) && X >= NO5X +18 && X <= NO5X+25) MENU_COLOR = RED; //MICROPHONE
                    
                    else if((Y == NO5Y|| Y == NO5Y+3) && X == NO5X) MENU_COLOR = RED; //WAVE 1
                    else if((Y == NO5Y+1|| Y == NO5Y+2) && X == NO5X+1) MENU_COLOR = RED; //WAVE 1
                    
                    else if((Y == NO5Y-1 || Y == NO5Y+4) && X == NO5X+3) MENU_COLOR = RED; //WAVE 2
                    else if((Y >= NO5Y && Y <= NO5Y+3) && X == NO5X+4) MENU_COLOR = RED; //WAVE 2
      
      
                    else if(Y == NO6Y     && X >= NO6X && X <= NO6X+39) MENU_COLOR = GREEN;
                    else if(Y == NO6Y + 1 && X >= NO6X && X <= NO6X+39) MENU_COLOR = GREEN;
                    else if(Y == NO6Y + 2 && X >= NO6X && X <= NO6X+39) MENU_COLOR = YELLOW;
                    else if(Y == NO6Y + 3 && X >= NO6X && X <= NO6X+39) MENU_COLOR = YELLOW;
                    else if(Y == NO6Y + 4 && X >= NO6X && X <= NO6X+39) MENU_COLOR = BLUE;
                    else if(Y == NO6Y + 5 && X >= NO6X && X <= NO6X+39) MENU_COLOR = BLUE;
                    else if(Y == NO6Y + 6 && X >= NO6X && X <= NO6X+39) MENU_COLOR = YELLOW;
                    else if(Y == NO6Y + 7 && X >= NO6X && X <= NO6X+39) MENU_COLOR = YELLOW;
                    else if(Y == NO6Y + 8 && X >= NO6X && X <= NO6X+39) MENU_COLOR = GREEN;
                    else if(Y == NO6Y + 9 && X >= NO6X && X <= NO6X+39) MENU_COLOR = GREEN;
                    
                    else if(Y == NO7Y && ((X >= NO7X && X <= NO7X+4)||(X >= NO7X+11 && X <= NO7X+15))) MENU_COLOR = RED; //EYES
                    
                    else if(((Y == NO7Y+6)||(Y==NO7Y+9)) && (X >= NO7X+5 && X <= NO7X+9)) MENU_COLOR = RED; //MOUTH SMALL
                    else if((Y >= NO7Y+6 && Y<=NO7Y+9) && (X == NO7X+5 || X == NO7X+9)) MENU_COLOR = RED; 
                    end
            endcase
     end
endmodule