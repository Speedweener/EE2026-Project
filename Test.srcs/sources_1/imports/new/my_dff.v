`timescale 1ns / 1ps

module my_dff(input DFF_CLOCK, D, output reg Q = 0);
    
    always @ (posedge DFF_CLOCK) begin
        Q <= D;
    end

endmodule
