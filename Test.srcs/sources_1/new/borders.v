`timescale 1ns / 1ps

module oled_border(input [6:0] X, input [5:0] Y, input BORDER_SIZE, input OFF_BORDER, output BORDER_OLED);

    // input BORDER_SIZE determines no of pixels for the borders

    assign BORDER_OLED = ~OFF_BORDER ? 
        ((BORDER_SIZE == 1'b0 && (X < 1 || X > 94 || Y < 1 || Y > 62)) ? 1 
        : (BORDER_SIZE == 1'b1 && (X < 3 || X > 92 || Y < 3 || Y > 60)) ? 1 : 0)
        : 0;

endmodule