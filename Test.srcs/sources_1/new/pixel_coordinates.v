`timescale 1ns / 1ps

module pixel_coord(input [12:0] PIXEL_INDEX,output [6:0] X, [5:0] Y);

    assign X = PIXEL_INDEX % 96;
    assign Y = PIXEL_INDEX / 96;

endmodule