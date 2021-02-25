`timescale 1ns / 1ps

module max_sound(input CLK, input [11:0] MIC_IN, 
    input [31:0] M, output reg [11:0] MAXSOUND = 0);

    reg [31:0] COUNTER = 0;

    always @ (posedge CLK) 
    begin
        COUNTER <= COUNTER +1;
        
        if(MIC_IN > MAXSOUND)
            MAXSOUND <= MIC_IN;
       
        if(COUNTER==M)
        begin
            COUNTER <= 1;
            MAXSOUND <= 0;
        end
    end

endmodule
