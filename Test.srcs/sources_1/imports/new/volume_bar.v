`timescale 1ns / 1ps

module volume_bar(input [6:0] X, [5:0] Y, input BAR_ON, input [47:0] COLOR, 
    input CLK, input SCALE, input [15:0] BAR_LEVEL, input FREEZE, 
    output reg [15:0] VBAR_COLOR = 0, output reg VBAR_OLED = 0, 
    output reg SCALE_OLED = 0, output reg [15:0] SCALE_COLOR = 0);
    
    reg [15:0] FROZEN_BAR = 0;
    reg [6:0] NO1X = 04;  //1600
    reg [5:0] NO1Y = 04;
    reg [6:0] NO2X = 08;
    reg [5:0] NO2Y = 04;
    reg [6:0] NO3X = 12;
    reg [5:0] NO3Y = 04;
    
    reg [6:0] NO4X = 04;  // 1200
    reg [5:0] NO4Y = 16;
    reg [6:0] NO5X = 08;
    reg [5:0] NO5Y = 16;
    reg [6:0] NO6X = 12;
    reg [5:0] NO6Y = 16;
    
    reg [6:0] NO7X = 08;  //800
    reg [5:0] NO7Y = 28;
    reg [6:0] NO8X = 12;
    reg [5:0] NO8Y = 28;
    
    reg [6:0] NO9X = 08;   //400 
    reg [5:0] NO9Y = 40;
    reg [6:0] NO10X = 12;    
    reg [5:0] NO10Y = 40;
    

    parameter [15:0] WHITE  = 16'hFFFF;
    parameter [15:0] GREEN  = 16'h07E0;
    parameter [15:0] YELLOW = 16'hFFE0;
    parameter [15:0] RED    = 16'hF800;
    parameter [15:0] BLACK  = 16'h0000;
    parameter [15:0] BLUE   = 16'h07E0;
    parameter [15:0] PURPLE = 16'hD198;
    parameter [15:0] ORANGE = 16'hFBE0;
    parameter [15:0] CYAN   = 16'h07FD;
    parameter [15:0] PINK   = 16'hFC9C;


    always @ (posedge CLK) FROZEN_BAR = (FREEZE == 1) ? FROZEN_BAR : BAR_LEVEL;

    always @ (*)
    begin
        if(SCALE == 1) 
        begin
            SCALE_OLED = 1;
                
            if(Y >= NO1Y  &&    Y <= NO1Y + 4  && X == NO1X + 2)  SCALE_COLOR = RED;  //ONE
               
            else if(Y == NO2Y &&      X >= NO2X      && X <= NO2X + 2 )  SCALE_COLOR = RED; // SIX
            else if(Y == NO2Y + 2  && X >= NO2X      && X <= NO2X + 2 )  SCALE_COLOR = RED; 
            else if(Y == NO2Y + 4  && X >= NO2X      && X <= NO2X + 2 )  SCALE_COLOR = RED; 
            else if(Y >= NO2Y      && Y <= NO2Y + 4  && X == NO2X)  SCALE_COLOR = RED; 
            else if(Y >= NO2Y + 2  && Y <= NO2Y + 4  && X == NO2X + 2)  SCALE_COLOR = RED;         
                         
            else if(Y == NO3Y &&     ((X >= NO3X &&      X <= NO3X + 2)|| (X >= NO3X + 4 && X <=NO3X + 6)))  SCALE_COLOR = RED; // DOUBLE ZERO
            else if(Y == NO3Y + 4 && ((X >= NO3X &&      X <= NO3X + 2)|| (X >= NO3X + 4 && X <=NO3X + 6)))  SCALE_COLOR = RED; 
            else if(Y >= NO3Y  &&      Y <= NO3Y + 4  && X == NO3X)  SCALE_COLOR = RED; 
            else if(Y >= NO3Y  &&      Y <= NO3Y + 4  && X == NO3X + 2)  SCALE_COLOR = RED; 
            else if(Y >= NO3Y  &&      Y <= NO3Y + 4  && X == NO3X + 4)  SCALE_COLOR = RED; 
            else if(Y >= NO3Y  &&      Y <= NO3Y + 4  && X == NO3X + 6)  SCALE_COLOR = RED; 
            else if(Y == NO3Y + 4 &&   X >= NO3X + 10 && X <= NO3X + 80 )  SCALE_COLOR = RED;  //LINE  
                                         
            else if(Y >= NO4Y  &&    Y <= NO4Y + 4  && X == NO4X + 2)  SCALE_COLOR = CYAN;  //ONE
               
            else if(Y == NO5Y &&     X >= NO5X      && X <= NO5X + 2 )  SCALE_COLOR = CYAN; // TWO
            else if(Y == NO5Y + 2 && X >= NO5X      && X <= NO5X + 2 )  SCALE_COLOR = CYAN; 
            else if(Y == NO5Y + 4 && X >= NO5X      && X <= NO5X + 2 )  SCALE_COLOR = CYAN; 
            else if(Y >= NO5Y + 2 && Y <= NO5Y + 4  && X == NO5X )  SCALE_COLOR = CYAN; 
            else if(Y >= NO5Y  &&    Y <= NO5Y + 2  && X == NO5X + 2)  SCALE_COLOR = CYAN; 
                                     
            else if(Y == NO6Y &&     ((X >= NO6X &&      X <= NO6X + 2)|| (X >= NO6X + 4 && X <=NO6X + 6)))  SCALE_COLOR = CYAN; // DOUBLE ZERO
            else if(Y == NO6Y + 4 && ((X >= NO6X &&      X <= NO6X + 2)|| (X >= NO6X + 4 && X <=NO6X + 6)))  SCALE_COLOR = CYAN; 
            else if(Y >= NO6Y  &&      Y <= NO6Y + 4  && X == NO6X)  SCALE_COLOR = CYAN; 
            else if(Y >= NO6Y  &&      Y <= NO6Y + 4  && X == NO6X + 2)  SCALE_COLOR = CYAN; 
            else if(Y >= NO6Y  &&      Y <= NO6Y + 4  && X == NO6X + 4)  SCALE_COLOR = CYAN; 
            else if(Y >= NO6Y  &&      Y <= NO6Y + 4  && X == NO6X + 6)  SCALE_COLOR = CYAN; 
            else if(Y == NO6Y + 4 &&   X >= NO6X + 10 && X <= NO6X + 80 )  SCALE_COLOR = CYAN;  //LINE               
                
                
            else if(Y == NO7Y &&     X >= NO7X      && X <= NO7X + 2 )  SCALE_COLOR = GREEN; // EIGHT
            else if(Y == NO7Y + 2 && X >= NO7X      && X <= NO7X + 2 )  SCALE_COLOR = GREEN; 
            else if(Y == NO7Y + 4 && X >= NO7X      && X <= NO7X + 2 )  SCALE_COLOR = GREEN; 
            else if(Y >= NO7Y  &&    Y <= NO7Y + 4  && X == NO7X)  SCALE_COLOR = GREEN; 
            else if(Y >= NO7Y  &&    Y <= NO7Y + 4  && X == NO7X + 2)  SCALE_COLOR = GREEN; 
                            
            else if(Y == NO8Y &&     ((X >= NO8X &&      X <= NO8X + 2)|| (X >= NO8X + 4 && X <=NO8X + 6)))  SCALE_COLOR = GREEN; // DOUBLE ZERO
            else if(Y == NO8Y + 4 && ((X >= NO8X &&      X <= NO8X + 2)|| (X >= NO8X + 4 && X <=NO8X + 6)))  SCALE_COLOR = GREEN; 
            else if(Y >= NO8Y  &&      Y <= NO8Y + 4  && X == NO8X)  SCALE_COLOR = GREEN; 
            else if(Y >= NO8Y  &&      Y <= NO8Y + 4  && X == NO8X + 2)  SCALE_COLOR = GREEN; 
            else if(Y >= NO8Y  &&      Y <= NO8Y + 4  && X == NO8X + 4)  SCALE_COLOR = GREEN; 
            else if(Y >= NO8Y  &&      Y <= NO8Y + 4  && X == NO8X + 6)  SCALE_COLOR = GREEN; 
            //else if(Y == NO8Y + 4 &&   X >= NO8X + 14 && X <= NO8X + 84 )  SCALE_COLOR = GREEN;  //LINE
            else if(Y == NO8Y + 4 &&   X >= NO8X + 10 && X <= NO8X + 80 )  SCALE_COLOR = GREEN;  //LINE               
                            
            else if(Y == NO9Y + 2 && X >= NO9X &&      X <= NO9X + 2 )  SCALE_COLOR = YELLOW; // FOUR
            else if(Y >= NO9Y     && Y <= NO9Y + 2  && X == NO9X)  SCALE_COLOR = YELLOW; 
            else if(Y >= NO9Y     && Y <= NO9Y+ 4  &&  X == NO9X + 2)  SCALE_COLOR = YELLOW; 
                            
            else if(Y == NO10Y &&     ((X >= NO10X &&      X <= NO10X + 2)|| (X >= NO10X + 4 && X <=NO10X + 6)))  SCALE_COLOR = YELLOW; // DOUBLE ZERO
            else if(Y == NO10Y + 4 && ((X >= NO10X &&      X <= NO10X + 2)|| (X >= NO10X + 4 && X <=NO10X + 6)))  SCALE_COLOR = YELLOW; 
            else if(Y >= NO10Y  &&      Y <= NO10Y + 4  && X == NO10X)  SCALE_COLOR = YELLOW; 
            else if(Y >= NO10Y  &&      Y <= NO10Y + 4  && X == NO10X + 2)  SCALE_COLOR = YELLOW; 
            else if(Y >= NO10Y  &&      Y <= NO10Y + 4  && X == NO10X + 4)  SCALE_COLOR = YELLOW; 
            else if(Y >= NO10Y  &&      Y <= NO10Y + 4  && X == NO10X + 6)  SCALE_COLOR = YELLOW; 
            //else if(Y == NO10Y + 4 &&   X >= NO10X + 14 && X <= NO10X + 84 )  SCALE_COLOR = YELLOW;  //LINE
            else if(Y == NO10Y + 4 &&   X >= NO10X + 10 && X <= NO10X + 80 )  SCALE_COLOR = YELLOW;  //LINE               
                            
            else SCALE_OLED = 0;//SCALE_COLOR = BLACK;;
        end
        else SCALE_OLED = 0;
   
        
        if (X < 51 && X > 44 && BAR_ON == 0 && Y > 7 && Y < 55)
        begin
            
            VBAR_OLED = 1;
            
            if      (Y >  7 && Y < 10 && FROZEN_BAR[15]) VBAR_COLOR = COLOR [47:32];
            else if (Y > 10 && Y < 13 && FROZEN_BAR[14]) VBAR_COLOR = COLOR [47:32];
            else if (Y > 13 && Y < 16 && FROZEN_BAR[13]) VBAR_COLOR = COLOR [47:32];
            else if (Y > 16 && Y < 19 && FROZEN_BAR[12]) VBAR_COLOR = COLOR [47:32];
            else if (Y > 19 && Y < 22 && FROZEN_BAR[11]) VBAR_COLOR = COLOR [47:32];
            else if (Y > 22 && Y < 25 && FROZEN_BAR[10]) VBAR_COLOR = COLOR [31:16];
            else if (Y > 25 && Y < 28 && FROZEN_BAR [9]) VBAR_COLOR = COLOR [31:16];
            else if (Y > 28 && Y < 31 && FROZEN_BAR [8]) VBAR_COLOR = COLOR [31:16];
            else if (Y > 31 && Y < 34 && FROZEN_BAR [7]) VBAR_COLOR = COLOR [31:16];
            else if (Y > 34 && Y < 37 && FROZEN_BAR [6]) VBAR_COLOR = COLOR [31:16];
            else if (Y > 37 && Y < 40 && FROZEN_BAR [5]) VBAR_COLOR = COLOR [15:0];
            else if (Y > 40 && Y < 43 && FROZEN_BAR [4]) VBAR_COLOR = COLOR [15:0];
            else if (Y > 43 && Y < 46 && FROZEN_BAR [3]) VBAR_COLOR = COLOR [15:0];
            else if (Y > 46 && Y < 49 && FROZEN_BAR [2]) VBAR_COLOR = COLOR [15:0];
            else if (Y > 49 && Y < 52 && FROZEN_BAR [1]) VBAR_COLOR = COLOR [15:0];
            else if (Y > 52 && Y < 55 && FROZEN_BAR [0]) VBAR_COLOR = COLOR [15:0];
            else VBAR_OLED = 0;
            
        end
        else VBAR_OLED = 0;
    end

endmodule
