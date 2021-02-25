`timescale 1ns / 1ps

module congrats(input [6:0] X, [5:0] Y, [6:0] X_START, [5:0] Y_START, input CONGRATS_ON, output reg ON = 0);

    parameter [127:0] congratulationstext0 = 128'h7111C4F8601213E1838E223860000000;
    parameter [127:0] congratulationstext1 = 128'h89314420601210818482262890000000;
    parameter [127:0] congratulationstext2 = 128'h95224209012108244812A4408000000;
    parameter [127:0] congratulationstext3 = 128'h7152242090121082439D2A4408000000;
    parameter [127:0] congratulationstext4 = 128'h81522420F0121083C1912A4408000000;
    parameter [127:0] congratulationstext5 = 128'h8991442108112084228A322890000000;
    parameter [127:0] congratulationstext6 = 128'h7111C42109F0C084248E223860000000;

    wire [127:0] CONGRATS;
    
    assign CONGRATS = (Y-Y_START == 0) ? congratulationstext0
                    : (Y-Y_START == 1) ? congratulationstext1
                    : (Y-Y_START == 2) ? congratulationstext2
                    : (Y-Y_START == 3) ? congratulationstext3
                    : (Y-Y_START == 4) ? congratulationstext4
                    : (Y-Y_START == 5) ? congratulationstext5
                    : (Y-Y_START == 6) ? congratulationstext6 : 0;
                    

    always @ (*)
    begin

        if (Y > Y_START - 1 && Y < Y_START + 7 && CONGRATS_ON)
        begin
                      
            if (CONGRATS[X-X_START]) ON = 1;
            else ON = 0;
                
        end
        else ON = 0;

    end

endmodule