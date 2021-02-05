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

module camera_configure
    #(
    parameter CLK_FREQ=25000000
    )
    (
    input wire clk,
    input wire start,
    input wire reset_n,
    input wire configure_start,
    output wire sioc,
    output wire siod,
    output wire configure_done
    );
    
    wire [7:0] rom_addr;
    wire [15:0] rom_dout;
    wire [7:0] SCCB_addr;
    wire [7:0] SCCB_data;
    wire SCCB_start;
    wire SCCB_ready;
    
    
    assign sioc = SCCB_SIOC_oe ? 1'b0 : 1'bZ;
    assign siod = SCCB_SIOD_oe ? 1'b0 : 1'bZ;
    
    OV7670_config_rom UUT2A_ROM(
        .clk(clk),
        .reset_n(reset_n),
        .addr(rom_addr),
        .dout(rom_dout)
        );
        
    OV7670_config #(.CLK_FREQ(CLK_FREQ)) UUT2B_CONFIG(
        .clk(clk),
        .reset_n(reset_n),
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
        .clk(clk),
        .reset_n(reset_n),
        .start(SCCB_start),
        .address(SCCB_addr),
        .data(SCCB_data),
        .ready(SCCB_ready),
        .SIOC_oe(SCCB_SIOC_oe),
        .SIOD_oe(SCCB_SIOD_oe)
        );
    
endmodule
