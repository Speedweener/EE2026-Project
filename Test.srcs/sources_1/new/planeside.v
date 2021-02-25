`timescale 1ns / 1ps

module planeside(input [6:0] X, [5:0] Y, [6:0] X_START, [5:0] Y_START, input SIDEPLANE_ON, output reg ON = 0, output reg [15:0] colour = 0);

    parameter [15:0] WHITE  = 16'hFFFF;
    parameter [15:0] GREEN  = 16'h07E0;
    parameter [15:0] YELLOW = 16'hFFE0;
    parameter [15:0] RED    = 16'hF800;
    parameter [15:0] BLACK  = 16'h0000;

    parameter [16:0] planeside_black0 = 17'b00000001110000111;
    parameter [16:0] planeside_black1 = 17'b00000010001000101;
    parameter [16:0] planeside_black2 = 17'b00000110001100101;
    parameter [16:0] planeside_black3 = 17'b00001100000100101;
    parameter [16:0] planeside_black4 = 17'b00111100000111101;
    parameter [16:0] planeside_black5 = 17'b01000000000000001;
    parameter [16:0] planeside_black6 = 17'b01000000000000001;
    parameter [16:0] planeside_black7 = 17'b01000001001000001;
    parameter [16:0] planeside_black8 = 17'b01000001001000001;
    parameter [16:0] planeside_black9 = 17'b00111111001111101;
    parameter [16:0] planeside_black10 = 17'b00000001001000101;
    parameter [16:0] planeside_black11 = 17'b00000001111000111;

    wire [16:0] planeside_white [0:3];
    assign planeside_white [0] = 17'b00111111111111100;
    assign planeside_white [1] = 17'b00111111111111100;
    assign planeside_white [2] = 17'b00111110000111100;
    assign planeside_white [3] = 17'b00111110000111100;
    
    wire [4:0] planeside_yellow [0:3];
    assign planeside_yellow [0] = 5'b01110;
    assign planeside_yellow [1] = 5'b01110;
    assign planeside_yellow [2] = 5'b11111;
    assign planeside_yellow [3] = 5'b11111;
    
    wire [7:0] planeside_green [0:9];
    assign planeside_green [0] = 8'b00000001;
    assign planeside_green [1] = 8'b00000001;
    assign planeside_green [2] = 8'b00000001;
    assign planeside_green [3] = 8'b00000001;
    assign planeside_green [4] = 8'b00000001;
    assign planeside_green [5] = 8'b00000001;
    assign planeside_green [6] = 8'b11000001;
    assign planeside_green [7] = 8'b11000001;
    assign planeside_green [8] = 8'b11000001;
    assign planeside_green [9] = 8'b11000001;
    
    wire [16:0] planeside_b;
    reg [16:0] planeside_w = 0;
    reg [4:0] planeside_y = 0;
    reg [7:0] planeside_g = 0;
    
    assign planeside_b = (Y - Y_START == 0) ? planeside_black0
                       : (Y - Y_START == 1) ? planeside_black1
                       : (Y - Y_START == 2) ? planeside_black2
                       : (Y - Y_START == 3) ? planeside_black3
                       : (Y - Y_START == 4) ? planeside_black4
                       : (Y - Y_START == 5) ? planeside_black5
                       : (Y - Y_START == 6) ? planeside_black6
                       : (Y - Y_START == 7) ? planeside_black7
                       : (Y - Y_START == 8) ? planeside_black8
                       : (Y - Y_START == 9) ? planeside_black9
                       : (Y - Y_START == 10) ? planeside_black10
                       : (Y - Y_START == 11) ? planeside_black11
                       : 0;
    
    always @ (*)
    begin
        if (SIDEPLANE_ON == 1)
        begin
            if (X > X_START - 1 && X < X_START + 18 && Y > Y_START - 1 && Y < Y_START + 12)
            begin
                planeside_w = (Y - Y_START > 4 && Y - Y_START < 9) ? planeside_white[Y - Y_START - 5] : 0;
                planeside_y = (Y - Y_START > 0 && Y - Y_START < 5 && X - X_START > 5 && X - X_START < 11) ? planeside_yellow[Y - Y_START - 1] : 0;
                planeside_g = (Y - Y_START > 0 && Y - Y_START < 11 && X - X_START > 0 && X - X_START < 9) ? planeside_green[Y - Y_START - 1] : 0;
                
                if (planeside_b[X-X_START]) begin ON = 1; colour = BLACK; end
                else if (planeside_w[X-X_START]) begin ON = 1; colour = WHITE; end
                else if (planeside_y[X-X_START-6]) begin ON = 1; colour = YELLOW; end
                else if (planeside_g[X-X_START-1]) begin ON = 1; colour = GREEN; end
                else if (X - X_START == 16 && (Y - Y_START == 6 || Y - Y_START == 7)) begin ON = 1; colour = RED; end
                else ON = 0;
            end
            else ON = 0;
        end
        else ON = 0;
    end

endmodule
