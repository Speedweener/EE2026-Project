`timescale 1ns / 1ps

module colour_theme(input [1:0] THEME, output [79:0] COLOR_THEME);

    // Define colour
    parameter [15:0] WHITE  = 16'hFFFF;
    parameter [15:0] GREEN  = 16'h07E0;
    parameter [15:0] YELLOW = 16'hFFE0;
    parameter [15:0] RED    = 16'hF800;
    parameter [15:0] BLACK  = 16'h0000;
    parameter [15:0] PURPLE = 16'hD198;
    parameter [15:0] ORANGE = 16'hFBE0;
    parameter [15:0] CYAN   = 16'h07FD;
    parameter [15:0] PINK   = 16'hFC9C;

    // Border colour --> background colour --> top bar --> middle bar --> bottom bar
    assign COLOR_THEME = (THEME == 0) ? {WHITE, BLACK, RED, YELLOW, GREEN}
        : (THEME == 1) ? {PINK, ORANGE, BLACK, PURPLE, CYAN}
        : {CYAN, PINK, GREEN, YELLOW, BLACK};

endmodule
