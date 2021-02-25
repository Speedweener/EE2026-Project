`timescale 1ns / 1ps

module single_pulse(input DFF_CLOCK, D, output Q);
    
    wire Q0, Q1;
    
    my_dff dff1(DFF_CLOCK, D, Q0);
    my_dff dff2(DFF_CLOCK, Q0, Q1);
    
    assign Q = Q0 & ~Q1;
    
endmodule
