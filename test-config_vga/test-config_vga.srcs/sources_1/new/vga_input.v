`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2021 02:46:39 PM
// Design Name: 
// Module Name: vga_input
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


module vga_input(
input clk,
input reset_n,
input [7:0] red,
input [7:0] green,
input [7:0] blue,
input rgb_valid,

output vga_hsync,
output vga_vsync,
output reg [7:0] vga_red,
output reg [7:0] vga_green,
output reg [7:0] vga_blue
    );

wire [9:0] xCounter, yCounter;
wire activeArea;

vga_timing_generator UUT (
.clk(clk),
.reset_n(reset_n),
.vga_hsync(vga_hsync),
.vga_vsync(vga_vsync),
.activeArea(activeArea),
.xCounter(xCounter),
.yCounter(yCounter)
);    

always@(posedge clk) begin
    if(activeArea) begin
        vga_red <= red;
        vga_green <= green;
        vga_blue <= blue;
    end
    else begin
        vga_red <= 8'b0;
        vga_green <= 8'b0;
        vga_blue <= 8'b0;
    end
end



endmodule
