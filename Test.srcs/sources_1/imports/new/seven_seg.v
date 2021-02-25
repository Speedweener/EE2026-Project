`timescale 1ns / 1ps

module seven_seg(input CLK, input [7:0] SEGVALUE1, input [7:0] SEGVALUE2, input [7:0] SEGSPEED, 
    output reg [11:0] SEG = 12'b111111111111);

    reg [1:0] INTERVAL = 0;

    always @ (posedge CLK) begin
        INTERVAL<= INTERVAL+1;
        case(INTERVAL)
               2'b00:
                begin 
                SEG[11:8]  <= 4'b1110;
                SEG[7:0]   <= SEGVALUE1;
                end
               2'b01:
                begin 
                SEG[11:8]  <= 4'b1101;
                SEG[7:0]   <= SEGVALUE2;
                end
               2'b10:
                begin 
                SEG[11:8]  <= 4'b0111;
                SEG[7:0]   <= SEGSPEED;

                end
               2'b11:
                begin 
                SEG[11:8]  <= 4'b1111;
                end
        endcase
    end



endmodule
