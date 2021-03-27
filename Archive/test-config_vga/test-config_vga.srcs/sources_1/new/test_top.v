`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2021 02:10:12 PM
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
input clk,
input reset_n,
input start_button, 
input pclk, 
input href, 
input vsync, 
input [7:0] camera_dout,

output sioc,
output siod,
output vga_hsync,
output vga_vsync,
output [7:0] vga_red,
output [7:0] vga_green,
output [7:0] vga_blue,
output frame_done

);

wire configure_done;
wire configure_start;
wire system_start;
wire [7:0] red;
wire [7:0] green; 
wire [7:0] blue;
wire rgb_valid;


master_control UUT1 (
.clk(clk),
.reset_n(reset_n),
.start_button(start_button),
.configure_done(configure_done),
.configure_start(configure_start),
.system_start(system_start)
);

camera_configure UUT2 (
.clk(clk),
.reset_n(reset_n),
.configure_start(configure_start), 
.configure_done(configure_done),
.sioc(sioc),
.siod(siod)
);

camera_interface_top UUT3(
.clk(clk),
.reset_n(reset_n),
.system_start(system_start),
.pclk(pclk),
.href(href),
.vsync(vsync),
.camera_dout(camera_dout),
.frame_done(frame_done),
.red(red),
.green(green),
.blue(blue),
.rgb_valid(rgb_valid)
);

vga_input UUT4(
.clk(clk),
.reset_n(reset_n),
.red(red),
.green(green),
.blue(blue),
.rgb_valid(rgb_valid),
.vga_hsync(vga_hsync),
.vga_vsync(vga_vsync),
.vga_red(vga_red),
.vga_green(vga_green),
.vga_blue(vga_blue)
);


endmodule
