`timescale 1ns / 1ps

module game_over(input [6:0] X, [5:0] Y, [6:0] X_START, [5:0] Y_START, input GAMEOVER_ON, output reg ON = 0);

    wire [59:0] gameovertext [0:6];
    assign gameovertext [0] = 60'h73E44707C22060E;
    assign gameovertext [1] = 60'h902445004220602;
    assign gameovertext [2] = 60'h902288804550901;
    assign gameovertext [3] = 60'h73E28887C55091D;
    assign gameovertext [4] = 60'h302288804550F11;
    assign gameovertext [5] = 60'h50210500488908A;
    assign gameovertext [6] = 60'h93E10707C88908E;

    reg [59:0] GAMEOVER = 0;

    always @ (*)
    begin

        if (X > X_START - 1 && X < X_START + 60 && Y > Y_START - 1 && Y < Y_START + 7 && GAMEOVER_ON)
        begin
            GAMEOVER = gameovertext[Y - Y_START];
                
            if (GAMEOVER[X-X_START]) ON = 1;
            else ON = 0;
                
        end
        else ON = 0;

    end

endmodule