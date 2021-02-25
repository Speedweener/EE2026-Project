`timescale 1ns / 1ps

module sound_freq(input CLK, input [11:0] MIC_IN, output reg [15:0] SOUNDFREQ = 0,
    input [31:0] M, output reg [2:0] FREQ_RANGE = 0);

    reg [31:0] COUNTER = 0;
    reg SOUNDPERIOD = 0;
    reg [12:0] SOUNDCOUNTER = 0;
    reg [31:0] FREQ = 0;
    reg SOUNDRESET = 0;
    

    always @ (posedge CLK) 
    begin
        COUNTER <= COUNTER +1;
        
        SOUNDRESET = 0;
        
        if(MIC_IN > 2175)
            SOUNDPERIOD <= 1;
        else
            SOUNDPERIOD <= 0;
       
        if(COUNTER == M)
        begin
            COUNTER <= 0;
            FREQ = 5 * SOUNDCOUNTER;
            FREQ_RANGE = FREQ < 30 ? 0 : FREQ < 250 ? 1 : FREQ < 350 ? 2 : FREQ < 450 ? 3 : 4;
            SOUNDRESET = 1;
            
            if      (FREQ < 100)  SOUNDFREQ = 16'b0;
            else if (FREQ < 200)  SOUNDFREQ = 16'b1;
            else if (FREQ < 300)  SOUNDFREQ = 16'b11;
            else if (FREQ < 400)  SOUNDFREQ = 16'b111;
            else if (FREQ < 500)  SOUNDFREQ = 16'b1111;
            else if (FREQ < 600)  SOUNDFREQ = 16'b11111;
            else if (FREQ < 700)  SOUNDFREQ = 16'b111111;
            else if (FREQ < 800)  SOUNDFREQ = 16'b1111111;
            else if (FREQ < 900)  SOUNDFREQ = 16'b11111111;
            else if (FREQ < 1000) SOUNDFREQ = 16'b111111111;
            else if (FREQ < 1100) SOUNDFREQ = 16'b1111111111;
            else if (FREQ < 1200) SOUNDFREQ = 16'b11111111111;
            else if (FREQ < 1300) SOUNDFREQ = 16'b111111111111;
            else if (FREQ < 1400) SOUNDFREQ = 16'b1111111111111;
            else if (FREQ < 1500) SOUNDFREQ = 16'b11111111111111;
            else if (FREQ < 1600) SOUNDFREQ = 16'b111111111111111;
            else                  SOUNDFREQ = 16'b1111111111111111;

        end
        


    end
    
    always @ (posedge SOUNDPERIOD, posedge SOUNDRESET)
    begin
        if (SOUNDRESET == 1)
            SOUNDCOUNTER <= 0;
        else 
            SOUNDCOUNTER <= SOUNDCOUNTER + 1;
    end

endmodule