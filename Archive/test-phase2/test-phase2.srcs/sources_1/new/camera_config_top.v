`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2021 10:51:01 AM
// Design Name: 
// Module Name: config_top
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


module config_top(

input clk,
input config_start,
input reset_n,

output config_done,
output SCCB_C,
output SCCB_D
);

wire [15:0] dout;
wire [7:0] rom_counter;
wire [7:0] SCCB_address;
wire [7:0] SCCB_data;
wire SCCB_start;


config_control UUT1a (
.clk(clk),
.reset_n(reset_n),
.start(config_start), // !
.SCCB_interface_ready(SCCB_interface_ready),
.rom_data(dout), // !
.rom_counter(rom_counter),
.done(config_done), // !
.SCCB_address(SCCB_address),
.SCCB_data(SCCB_data),
.SCCB_start(SCCB_start)
);

config_ROM UUT1b (
.clk(clk),
.reset_n(reset_n),
.rom_index(rom_counter), // !
.dout(dout)
);

config_SCCB UUT1c(
.clk(clk),
.reset_n(reset_n),
.SCCB_start(SCCB_start),
.SCCB_address(SCCB_address),
.SCCB_data(SCCB_data),
.SCCB_interface_ready(SCCB_interface_ready),
.SCCB_C(SCCB_C),
.SCCB_D(SCCB_D)
);

    
endmodule
