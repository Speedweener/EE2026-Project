`timescale 1ns / 1ps

module explosion(input [6:0] X, [5:0] Y, [6:0] X_START, [5:0] Y_START, input EXPLOSION_ON, output reg ON = 0, output reg [15:0] colour = 0);

    parameter [15:0] YELLOW = 16'hFFE0;
    parameter [15:0] RED    = 16'hF800;
    parameter [15:0] ORANGE = 16'hFBE0;
    parameter [15:0] WHITE  = 16'hFFFF;

    wire [2:0] explosion_white [0:2];
    assign explosion_white [0] = 3'b110;
    assign explosion_white [1] = 3'b111;
    assign explosion_white [2] = 3'b100;

    wire [4:0] explosion_orange [0:5];
    assign explosion_orange [0] = 5'b00100;
    assign explosion_orange [1] = 5'b11110;
    assign explosion_orange [2] = 5'b10011;
    assign explosion_orange [3] = 5'b10001;
    assign explosion_orange [4] = 5'b10111;
    assign explosion_orange [5] = 5'b01000;

    wire [12:0] explosion_yellow [0:9];
    assign explosion_yellow [0] = 13'b0000000100000;
    assign explosion_yellow [1] = 13'b0000001111000;
    assign explosion_yellow [2] = 13'b0000111011100;
    assign explosion_yellow [3] = 13'b0101100001100;
    assign explosion_yellow [4] = 13'b0111100000100;
    assign explosion_yellow [5] = 13'b0001100000110;
    assign explosion_yellow [6] = 13'b0000100000100;
    assign explosion_yellow [7] = 13'b0000110111000;
    assign explosion_yellow [8] = 13'b0000011100000;
    assign explosion_yellow [9] = 13'b0000001000000;

    wire [12:0] explosion_red [0:11];
    assign explosion_red [0] = 13'b0000001111100;
    assign explosion_red [1] = 13'b0000011011110;
    assign explosion_red [2] = 13'b0001110000110;
    assign explosion_red [3] = 13'b1111000000010;
    assign explosion_red [4] = 13'b1010000000010;
    assign explosion_red [5] = 13'b1000000000011;
    assign explosion_red [6] = 13'b0110000000001;
    assign explosion_red [7] = 13'b0011000000011;
    assign explosion_red [8] = 13'b0001000000110;
    assign explosion_red [9] = 13'b0001100011100;
    assign explosion_red [10] = 13'b0000110110100;
    assign explosion_red [11] = 13'b0000011100000;

    reg [2:0] explosion_w = 0;
    reg [4:0] explosion_o = 0;
    reg [12:0] explosion_y = 0;
    reg [12:0] explosion_r = 0;

    always @ (*)
    begin

        if (EXPLOSION_ON == 1)
        begin
            if (X > X_START - 1 && X < X_START + 13 && Y > Y_START - 1 && Y < Y_START + 12)
            begin
                explosion_w = (X - X_START > 3 && X - X_START < 7 && Y - Y_START > 4 && Y - Y_START < 8) ? explosion_white[Y - Y_START - 5] : 0;
                explosion_o = (X - X_START > 2 && X - X_START < 8 && Y - Y_START > 2 && Y - Y_START < 9) ? explosion_orange[Y - Y_START - 3] : 0;
                explosion_y = (Y - Y_START > 0 && Y - Y_START < 11) ? explosion_yellow[Y - Y_START - 1] : 0;
                explosion_r = explosion_red[Y - Y_START];
              
                
                if (explosion_w[X-X_START-4]) begin ON = 1; colour = WHITE; end
                else if (explosion_o[X-X_START-3]) begin ON = 1; colour = ORANGE; end
                else if (explosion_y[X-X_START-1]) begin ON = 1; colour = YELLOW; end
                else if (explosion_r[X-X_START]) begin ON = 1; colour = RED; end
                else ON = 0;
            end
            else ON = 0;
        end
        else ON = 0;

    end

endmodule