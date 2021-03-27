`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2021 06:25:13 PM
// Design Name: 
// Module Name: test_top
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


module test_top(

    input        Clk,
    input        Reset,
    input        pclk,
    input        href,
    input        vsync,
    input  [7:0] camera_dout,
    input        startButton,
    
    output       xclk,      // ov7670 24Mhz system clock
    output       camResetn, // ov7670 active low reset
    output       camPwdn,   // ov7670 active high power down
    output       sioc,      
    output       siod,
    
    output [3:0] TMDS_P,    // HDMI differential outputs
    output [3:0] TMDS_N
    );
    
    wire SCCB_Clk;
    wire configure_start;
    wire configure_done;
    wire system_start;
    wire frame_done;
    wire rgb_valid;
    wire [7:0] red;
    wire [7:0] green;
    wire [7:0] blue;
    
    
    ClockGen_wrapper UUT0(
        .clk_in1_0(Clk),
        .reset_0(Reset),
        .SCCB_Clk_0(SCCB_Clk),
        .xclk_0(xclk)
    );   
    
    MasterControl UUT1(
        .Clk(Clk),
        .Reset(Reset),
        .startButton(startButton),
        .configure_start(configure_start),
        .configure_done(configure_done),
        .system_start(system_start),
        .camResetn(camResetn),
        .camPwdn(camPwdn)
    );
    
    CamConfigure_top UUT2(
        .SCCB_Clk(SCCB_Clk),
        .reset(Reset),
        .configure_start(configure_start),
        .sioc(sioc),
        .siod(siod),
        .configure_done(configure_done)
    );
    
    CamRead_top UUT3(
        .clk(Clk),
        .reset(Reset),
        .system_start(system_start),
        .pclk(pclk),
        .href(href),
        .vsync(vsync),
        .camera_dout(camera_dout),
        .frame_done(frame_done),
        .red(red),
        .green(green),
        .blue(blue)
    );
    
    HDMI_top UUT4(
        .clk_100MHz(Clk),
        .Reset(Reset),
        .Red(red),
        .Green(green),
        .Blue(blue),
        .TMDS_P(TMDS_P),
        .TMDS_N(TMDS_N)
    );
    
    
endmodule
