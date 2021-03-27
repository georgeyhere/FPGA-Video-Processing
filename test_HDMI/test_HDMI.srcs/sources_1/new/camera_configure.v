`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2015 10:20:20 AM
// Design Name: 
// Module Name: camera_configure
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
//from https://github.com/westonb/OV7670-Verilog

module CamConfigure_top
    #(
    parameter CLK_FREQ=25000000
    )
    (
    input       SCCB_Clk,
    input       reset,
    input       configure_start,
    
    output      sioc,
    output      siod,
    output      configure_done
    );
    
// ===========================================================================
// 			          Parameters, Registers, and Wires
// ===========================================================================
    wire [7:0]  rom_addr;
    wire [15:0] rom_dout;
    wire [7:0]  SCCB_addr;
    wire [7:0]  SCCB_data;
    wire        SCCB_start;
    wire        SCCB_ready;
    wire        SCCB_SIOC_oe;
    wire        SCCB_SIOD_oe;
 
// ===========================================================================
//                              Implementation    
// ===========================================================================      
    assign sioc = (configure_done) ? 1'bZ : (SCCB_SIOC_oe);
    assign siod = (configure_done) ? 1'bZ : (SCCB_SIOD_oe);
    
    OV7670_config_rom UUT2A_ROM(
        .clk(SCCB_Clk),
        .reset(reset),
        .addr(rom_addr),
        .dout(rom_dout)
        );
        
    OV7670_config #(.CLK_FREQ(CLK_FREQ)) UUT2B_CONFIG(
        .clk(SCCB_Clk),
        .reset(reset),
        .SCCB_interface_ready(SCCB_ready),
        .rom_data(rom_dout),
        .configure_start(configure_start),
        .rom_addr(rom_addr),
        .configure_done(configure_done),
        .SCCB_interface_addr(SCCB_addr),
        .SCCB_interface_data(SCCB_data),
        .SCCB_interface_start(SCCB_start)
        );
    
    SCCB_interface #( .CLK_FREQ(CLK_FREQ)) UUT2C_SCCB(
        .clk(SCCB_Clk),
        .reset(reset),
        .start(SCCB_start),
        .address(SCCB_addr),
        .data(SCCB_data),
        .ready(SCCB_ready),
        .SIOC_oe(SCCB_SIOC_oe),
        .SIOD_oe(SCCB_SIOD_oe)
        );
    
endmodule
