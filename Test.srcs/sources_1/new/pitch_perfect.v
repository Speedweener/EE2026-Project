`timescale 1ns / 1ps

module pitch_perfect(input [6:0] X, [5:0] Y, input GAME_ON, input CLK, input [2:0] FREQ_RANGE, 
    input BORDER_OLED, input [15:0] BORDER_COLOR, output [15:0] GAME3);

    parameter [15:0] CYAN   = 16'h07FD;
    parameter [15:0] PURPLE = 16'hD198;
    parameter [15:0] RED    = 16'hF800;

    wire [6:0] S_PLANE_X;
    wire [5:0] S_PLANE_Y;
    wire CONGRATS_OLED, EXPLOSION_OLED, GAMEOVER_OLED, S_PLANE_OLED;
    wire [15:0] EXPLOSION_COLOUR;
    wire [15:0] S_PLANE_COLOUR;
    wire [15:0] T_PLANE_COLOUR;
    wire T_PLANE_OLED, BARRIER_OLED;
    wire S_PLANE_ON, GAMEOVER_ON, EXPLOSION_ON, CONGRATS_ON;
    wire [5:0] GAMEOVER_Y;
    wire [6:0] CONGRATS_X;

    assign GAME3 = BORDER_OLED ? BORDER_COLOR : CONGRATS_OLED ? RED : EXPLOSION_OLED ? EXPLOSION_COLOUR 
        : T_PLANE_OLED ? T_PLANE_COLOUR : S_PLANE_OLED ? S_PLANE_COLOUR 
        : GAMEOVER_OLED ? RED : BARRIER_OLED ? PURPLE : CYAN;


    game3_cont game(.X(X), .Y(Y), .GAME_ON(GAME_ON), .CLK(CLK), .FREQ_RANGE(FREQ_RANGE),
        .S_PLANE_X(S_PLANE_X), .S_PLANE_Y(S_PLANE_Y),
        .BARRIER_OLED(BARRIER_OLED), .S_PLANE_ON(S_PLANE_ON), .T_PLANE_OLED(T_PLANE_OLED), 
        .GAMEOVER_ON(GAMEOVER_ON), .CONGRATS_ON(CONGRATS_ON), .EXPLOSION_ON(EXPLOSION_ON),
        .T_PLANE_COLOUR(T_PLANE_COLOUR), .GAMEOVER_Y(GAMEOVER_Y), .CONGRATS_X(CONGRATS_X));

    planeside planeside(.X(X), .Y(Y), .X_START(S_PLANE_X), .Y_START(S_PLANE_Y), .SIDEPLANE_ON(S_PLANE_ON), .ON(S_PLANE_OLED), .colour(S_PLANE_COLOUR));
        
    game_over displaygameover(.X(X), .Y(Y), .X_START(25), .Y_START(GAMEOVER_Y), .GAMEOVER_ON(GAMEOVER_ON), .ON(GAMEOVER_OLED));
            
    explosion displayexplosion(.X(X), .Y(Y), .X_START(S_PLANE_X), .Y_START(S_PLANE_Y), .EXPLOSION_ON(EXPLOSION_ON), .ON(EXPLOSION_OLED), .colour(EXPLOSION_COLOUR));
            
    congrats displaycongrats( .X(X), .Y(Y), .X_START(CONGRATS_X), .Y_START(20), .CONGRATS_ON(CONGRATS_ON), .ON(CONGRATS_OLED));

endmodule
