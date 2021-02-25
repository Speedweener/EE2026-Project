`timescale 1ns / 1ps

module led_audio(input CLK, input SOUNDSWITCH, input [11:0] MIC_IN, input [11:0] MAXSOUND,
    output reg [7:0] SEGVALUE1 = 0, output reg [7:0] SEGVALUE2 = 0, output reg [15:0] MICLED = 0);

    parameter ZERO =  8'b11000000;
    parameter ONE  =  8'b11111001;
    parameter TWO  =  8'b10100100;
    parameter THREE =  8'b10110000;
    parameter FOUR =  8'b10011001;
    parameter FIVE =  8'b10010010;
    parameter SIX =  8'b10000010;
    parameter SEVEN =  8'b11111000;
    parameter EIGHT =  8'b10000000;
    parameter NINE =  8'b10010000;

    always @ (posedge CLK) 
    begin
        if(SOUNDSWITCH)
           MICLED =  {4'b0000,  MIC_IN [11:0]};
        else if(MAXSOUND<2047)
            begin
            MICLED =  16'b0000000000000000;
            SEGVALUE1 <= ZERO;
            SEGVALUE2 <= ZERO;
            end
        else if(MAXSOUND<2250)
            begin
            MICLED =  16'b0000000000000001;
            SEGVALUE1 <= ONE;
            SEGVALUE2 <= ZERO;
            end
        else if(MAXSOUND<2303)
            begin
            MICLED =  16'b0000000000000011;
            SEGVALUE1 <= TWO;
            SEGVALUE2 <= ZERO;
            end
        else if(MAXSOUND<2431)
            begin
            MICLED =  16'b0000000000000111;
            SEGVALUE1 <= THREE;
            SEGVALUE2 <= ZERO;
            end
        else if(MAXSOUND<2559)
            begin
            MICLED =  16'b0000000000001111;
            SEGVALUE1 <= FOUR;
            SEGVALUE2 <= ZERO;
           end
        else if(MAXSOUND<2687)
            begin
            MICLED =  16'b0000000000011111;
            SEGVALUE1 <= FIVE;
            SEGVALUE2 <= ZERO;
            end
        else if(MAXSOUND<2815)
            begin
            MICLED =  16'b0000000000111111;
            SEGVALUE1 <= SIX;
            SEGVALUE2 <= ZERO;
            end
        else if(MAXSOUND<2943)
            begin
            MICLED =  16'b0000000001111111;
            SEGVALUE1 <= SEVEN;
            SEGVALUE2 <= ZERO;
            end
        else if(MAXSOUND<3071)
            begin
            MICLED =  16'b0000000011111111;
            SEGVALUE1 <= EIGHT;
            SEGVALUE2 <= ZERO;
            end
        else if(MAXSOUND<3199)
            begin
            MICLED =  16'b0000000111111111;
            SEGVALUE1 <= NINE;
            SEGVALUE2 <= ZERO;
            end
        else if(MAXSOUND<3327)
            begin
            MICLED =  16'b0000001111111111;
            SEGVALUE1 <= ZERO;
            SEGVALUE2 <= ONE;
            end
        else if(MAXSOUND<3455)
            begin
            MICLED =  16'b0000011111111111;
            SEGVALUE1 <= ONE;
            SEGVALUE2 <= ONE;
            end
        else if(MAXSOUND<3583)
            begin
            MICLED =  16'b0000111111111111;
            SEGVALUE1 <= TWO;
            SEGVALUE2 <= ONE;
            end
        else if(MAXSOUND<3711)
            begin
            MICLED =  16'b0001111111111111;
            SEGVALUE1 <= THREE;
            SEGVALUE2 <= ONE;
            end
        else if(MAXSOUND<3839)
            begin
            MICLED =  16'b0011111111111111;
            SEGVALUE1 <= FOUR;
            SEGVALUE2 <= ONE;
            end
        else if(MAXSOUND<3967)
            begin
            MICLED =  16'b0111111111111111;
            SEGVALUE1 <= FIVE;
            SEGVALUE2 <= ONE;
            end
        else 
            begin
            MICLED =  16'b1111111111111111;
            SEGVALUE1 <= SIX;
            SEGVALUE2 <= ONE;
            end

        
    end

endmodule
