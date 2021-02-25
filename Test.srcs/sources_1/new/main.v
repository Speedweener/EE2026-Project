`timescale 1ns / 1ps

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY (Delete where applicable): MONDAY P.M
//
//  STUDENT A NAME: KWEK ZHAN HAO
//  STUDENT A MATRICULATION NUMBER: A0206238J
//
//  STUDENT B NAME: TEY XING RONG
//  STUDENT B MATRICULATION NUMBER: A0201708N
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module main (
    // FOR SOUND
    input  J_MIC3_Pin3,             // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,             // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,             // Connect to this signal from Audio_Capture.v
    input LEDSWITCH, // Turns off and on the LEDs (AUDIO)
    input SOUNDSWITCH, SPEED1,SPEED2,SPEED3,// Alters microphone settings
    output [15:0] LED,              // FOR LED
    output [11:0] SEG,              // FOR 7SEG
    
    input FREQ_BAR,                 // Bar on OLED displays sound frequency range
        
    output  RGB_CS, RGB_SDIN, RGB_SCLK, RGB_D_CN, RGB_RESN, RGB_VCCEN, RGB_PMODEN,  // FOR OLED
    
    input BTN, btnU, btnD, btnL, btnR,      // Reset button for OLED
    input CLK100MHZ,                        // BASYS CLOCK
    
    input OFF_BORDER,               // Activate to switch off the border
    input BORDER_SIZE,              // Controls the border size
    input BAR_ON,                   // Deactivate to on the volume bar
    
    input [1:0] THEME,              // To select between 3 themes for oled
    input FREEZE                    // To freeze the OLED Display
    );
    
    parameter ONE  =  8'b11111001;
    parameter TWO  =  8'b10100100;
    parameter THREE =  8'b10110000;


    parameter [15:0] MENULED = 16'b1010101010101010;

    wire CLK6P25MHZ;
    wire CLK20KHZ;
    wire CLK400HZ;
    wire CLK20HZ;
    wire CLK5HZ;
    wire CLKREFRESH;

    // for debouncing pushbutton
    wire CLK_DEBOUNCE;
    
    // Audio data from mic
    wire [11:0] MIC_IN;
    
    // Audio Stuff
//    wire [11:0] COUNTER;
    wire [11:0] MAXSOUND;
    wire [7:0] SEGVALUE1;
    wire [7:0] SEGVALUE2;
    wire [7:0] SEGSPEED;

    // OLED stuff
    wire [15:0] OLED_DATA;
    wire RESET;
    wire FRAME_BEGIN;
    wire [12:0] PIXEL_INDEX;
    wire SENDING_PIXELS;
    wire SAMPLE_PIXEL;

    // Carries colours for colour theme of Oled Display
    wire [79:0] COLOR_THEME;
        
    // Pushbutton single pulse signals
    wire MID, UP, DOWN, LEFT, RIGHT;
    
    // X, Y coordinates of PIXEL_INDEX of OLED
    wire [6:0] X;       // 0 to 95
    wire [5:0] Y;       // 0 to 63
    
    // Indicates if current PIXEL_INDEX is in the border
    wire BORDER_OLED;
    // Indicates if current PIXEL_INDEX is in the volume bar
    wire VBAR_OLED;
    wire SCALE_OLED;
        
    // Indicates the colour of the current part of the volume bar
    wire [15:0] VBAR_COLOR;
    wire [15:0] SCALE_COLOR;

    // To test for freezing. Will later be replaced by audio data.
    // Determines the height of the volume bar. Assign audio data here.
    wire [15:0] BAR_LEVEL;
    
    // For frequency detection
    wire [2:0] FREQ_RANGE;
    wire [15:0] SOUNDFREQ;
    
    wire [15:0] MENU_COLOR;
    
    wire [2:0] MODE;

    wire [15:0] MIC_OLED;
    wire [15:0] MICLED;
    wire [15:0] GAME1; 
    wire [15:0] GAME1LED;
    wire [15:0] GAME2; 
    wire [15:0] GAME2LED;
    wire [15:0] GAME3; 
    wire [15:0] GAME3LED;
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    clk_divider clk_20khz(CLK100MHZ, 2499, CLK20KHZ);
     clk_divider clk_5hz(CLK100MHZ, 9999999, CLK5HZ);            //MICROPHONE
    clk_divider clk_400hz(CLK100MHZ,124999, CLK400HZ);          //MICROPHONE
    clk_divider clk_6p25mhz(CLK100MHZ, 7, CLK6P25MHZ);
    clk_divider debounce(CLK100MHZ, 999999, CLK_DEBOUNCE);      // 50Hz
    clk_divider clk_20hz(CLK100MHZ, 2499999, CLK20HZ);
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    Audio_Capture audio(.CLK(CLK100MHZ), .cs(CLK20KHZ), 
        .MISO(J_MIC3_Pin3),             // J_MIC3_Pin3, serial mic input
        .clk_samp(J_MIC3_Pin1),         // J_MIC3_Pin1
        .sclk(J_MIC3_Pin4),             // J_MIC3_Pin4, MIC3 serial clock
        .sample(MIC_IN)                 // 12-bit audio sample data
        );
    
    // Gets the max amplitude of the sound detected on the mic with frequency of 20KHz, which resets every 0.2s
    
    max_sound maxsound(.CLK(CLK20KHZ), .MIC_IN(MIC_IN), .M(4000), .MAXSOUND(MAXSOUND));
    
   // Based on chosen CLKREFRESH rate, updates the LEDs and 7 segment display according to sound level
   // as indicated by MAXSOUND. This also effects the bars on OLED display
    assign CLKREFRESH = (SPEED1) ? CLK5HZ : (SPEED2) ? CLK400HZ : (SPEED3) ? CLK20KHZ : CLK5HZ;
    
    led_audio led(.CLK(CLKREFRESH), .SOUNDSWITCH(SOUNDSWITCH), .MIC_IN(MIC_IN), .MAXSOUND(MAXSOUND), 
        .SEGVALUE1(SEGVALUE1), .SEGVALUE2(SEGVALUE2), .MICLED(MICLED));

    // Displays the max sound in the range of 0 to 16 on the 7 seg display, as well as chosen refresh rate
  assign SEGSPEED = (SPEED1) ? ONE : (SPEED2) ? TWO : (SPEED3) ? THREE : ONE;
    seven_seg max_sound_seg(.CLK(CLK400HZ), .SEGVALUE1(SEGVALUE1), .SEGVALUE2(SEGVALUE2), .SEGSPEED(SEGSPEED),.SEG(SEG));
    
    // The volume bar will mirror the LED array
    assign BAR_LEVEL = (FREQ_BAR == 1) ? SOUNDFREQ : MICLED;
    
    // detects frequency and frequency range
    sound_freq(.CLK(CLK20KHZ), .MIC_IN(MIC_IN), .M(3999), .FREQ_RANGE(FREQ_RANGE), .SOUNDFREQ(SOUNDFREQ));
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Creates the X and Y coordinates of the pixel index
    pixel_coord coordinates(PIXEL_INDEX, X, Y);
    
    // Controls the activation, colour and size of the border
    oled_border border(X, Y, BORDER_SIZE, OFF_BORDER, BORDER_OLED);
    
    // Controls the activation and colour of the volume bar
   volume_bar vol(.X(X), .Y(Y), .BAR_ON(BAR_ON), .COLOR(COLOR_THEME[47:0]), .CLK(CLK100MHZ), .SCALE(FREQ_BAR),
    .BAR_LEVEL(BAR_LEVEL), .FREEZE(FREEZE), .VBAR_COLOR(VBAR_COLOR), .VBAR_OLED(VBAR_OLED), .SCALE_OLED(SCALE_OLED), .SCALE_COLOR(SCALE_COLOR));
    
    // Controls the colour theme of the OLED Display
    colour_theme theme_select(THEME, COLOR_THEME);
    
    assign MIC_OLED = BORDER_OLED ? COLOR_THEME [79:64] : VBAR_OLED ? VBAR_COLOR : SCALE_OLED ? SCALE_COLOR : COLOR_THEME [63:48];
    
    Oled_Display oled(.clk(CLK6P25MHZ), .reset(RESET), 
    .frame_begin(FRAME_BEGIN), .sending_pixels(SENDING_PIXELS), .pixel_data(OLED_DATA),
        .sample_pixel(SAMPLE_PIXEL), .pixel_index(PIXEL_INDEX), 
        .cs(RGB_CS), .sdin(RGB_SDIN), .sclk(RGB_SCLK), 
        .d_cn(RGB_D_CN), .resn(RGB_RESN), .vccen(RGB_VCCEN),
        .pmoden(RGB_PMODEN), .teststate()
        );
   
    // Debounces the pushbutton controlling MID
    assign RESET = (MODE == 1) ? MID : 0;
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    menu menu(.X(X), .Y(Y), .UP(UP), .DOWN(DOWN), .LEFT(LEFT), .RIGHT(RIGHT), .MID(MID), .CLK_5HZ(CLK5HZ),
              .CLK_DEBOUNCE(CLK_DEBOUNCE), .MODE(MODE), .MENU_COLOR(MENU_COLOR));
   
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    single_pulse mid(CLK_DEBOUNCE, BTN, MID);
    single_pulse up(CLK_DEBOUNCE, btnU, UP);
    single_pulse down(CLK_DEBOUNCE, btnD, DOWN);
    single_pulse left(CLK_DEBOUNCE, btnL, LEFT);
    single_pulse right(CLK_DEBOUNCE, btnR, RIGHT);

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    kamehameha game1(.X(X), .Y(Y), .MAXSOUND(MAXSOUND), .CLK(CLK100MHZ), .MID(MID), .CLK_DEBOUNCE(CLK_DEBOUNCE),
        .BAR_COLOR(GAME1), .LED(GAME1LED));
        
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
    windblow game2(.X(X), .Y(Y), .MAXSOUND(MAXSOUND), .CLK(CLK100MHZ), .MID(MID), .CLK_DEBOUNCE(CLK_DEBOUNCE),
        .BAR_COLOR(GAME2), .LED(GAME2LED));
  
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      
    
    pitch_perfect game3(.X(X), .Y(Y), .GAME_ON((MODE==4)), .CLK(CLK20HZ), .FREQ_RANGE(FREQ_RANGE),
                 .BORDER_OLED(BORDER_OLED), .BORDER_COLOR(COLOR_THEME [79:64]), .GAME3(GAME3));
              
              assign GAME3LED = BAR_LEVEL;
              
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    assign OLED_DATA = (MODE==0) ? MENU_COLOR :  (MODE==1) ? MIC_OLED :   
        (MODE==2) ?  GAME1 : (MODE==3)  ? GAME2 : (MODE==4) ? GAME3 : 0;
    assign LED = LEDSWITCH ? 0 : (MODE==0) ? MENULED :  (MODE==1) ? MICLED :   
        (MODE==2) ?  GAME1LED : (MODE==3)  ? GAME2LED : (MODE==4) ? GAME3LED : 0;

endmodule