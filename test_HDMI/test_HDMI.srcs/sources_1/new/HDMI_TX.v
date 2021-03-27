`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2021 10:13:58 AM
// Design Name: 
// Module Name: HDMI_TX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module HDMI_TMDS(
    input       PClk,
    input       Reset,
    input [7:0] Red,
    input [7:0] Green,
    input [7:0] Blue,
    input       vsync,
    input       hsync,
    input       activeArea,     // send hardcoded control signals on channel 0 when activeArea is low
    
    output [9:0] TMDS_Red,
    output [9:0] TMDS_Green,
    output [9:0] TMDS_Blue
    );
    
    TMDS_encoder2 TMDS_CH0(     // Channel 0, Red and Timing
        .clk(PClk),
        .Reset(Reset),
        .de(activeArea),
        .ctrl({vsync,hsync}),       // timing signals encoded only on channel 0
        .din(Red),
        .dout(TMDS_Red)
    );
    
    TMDS_encoder2 TMDS_CH1(    // Channel 1, Green
        .clk(PClk),
        .Reset(Reset),
        .de(activeArea),
        .ctrl(2'b0),
        .din(Green),
        .dout(TMDS_Green)
    );
    
    TMDS_encoder2 TMDS_CH2(    // Channel 2, Blue
        .clk(PClk),
        .Reset(Reset),
        .de(activeArea),
        .ctrl(2'b0),
        .din(Blue),
        .dout(TMDS_Blue)
    );
    
endmodule
