`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2021 07:52:18 PM
// Design Name: 
// Module Name: HDMI_top
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


module HDMI_top(
    input        clk_100MHz, //  100 Mhz clock
    input        Reset,
    input [7:0]  Red,
    input [7:0]  Green,
    input [7:0]  Blue,
         
    output [3:0] TMDS_P,
    output [3:0] TMDS_N
    );
    
    wire       PClk;
    wire [9:0] TMDS_Red;
    wire [9:0] TMDS_Green;
    wire [9:0] TMDS_Blue;
    wire       vsync;
    wire       hsync;
    wire       activeArea;
    wire       TMDS_Clk;
    
    HDMI_ClockGen CLKGEN(
    .clk_100MHz(clk_100MHz),
    .reset_rtl_0(Reset),
    .PClk_0(PClk),
    .TMDS_Clk_0(TMDS_Clk)
    );
    
    HDMI_Timing UUT1(
    .PClk(PClk),
    .Reset(Reset),
    .vsync(vsync),
    .hsync(hsync),
    .activeArea(activeArea)
    );
    
    HDMI_TMDS UUT2(
    .PClk(PClk),
    .Reset(Reset),
    .Red(Red),
    .Green(Green),
    .Blue(Blue),
    .vsync(vsync),
    .hsync(hsync),
    .activeArea(activeArea),
    .TMDS_Red(TMDS_Red),
    .TMDS_Green(TMDS_Green),
    .TMDS_Blue(TMDS_Blue)
    );
    
    HDMI_Out UUT3(
    .PClk(PClk),
    .TMDS_Clk(TMDS_Clk),
    .Reset(Reset),
    .TMDS_Red(TMDS_Red),
    .TMDS_Green(TMDS_Green),
    .TMDS_Blue(TMDS_Blue),
    .TMDS_P(TMDS_P),
    .TMDS_N(TMDS_N)
    );
    
    
endmodule
