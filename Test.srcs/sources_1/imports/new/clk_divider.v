`timescale 1ns / 1ps

module clk_divider(input CLOCK, input [31:0] M, output reg MY_CLK = 0);

    reg [31:0] COUNTER = 0;
    
    always @ (posedge CLOCK)
    begin
    COUNTER <= (COUNTER == M) ? 0 : COUNTER + 1;
    MY_CLK <= (COUNTER == 0) ? ~MY_CLK : MY_CLK; 
    end 

endmodule
