`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2020 07:00:36 PM
// Design Name: 
// Module Name: greyscale_tb
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


module greyscale_tb();

reg clk = 0;
reg pclk = 0;
reg reset_n = 1;

reg [7:0] red = 8'b00011100; //test values
reg [7:0] green = 8'b00000111;
reg [7:0] blue = 8'b00011100;

reg byte_convert_valid;

wire [23:0] greyscale_pixel;
wire greyscale_valid;
wire greyscale_ready;

parameter CLK_PERIOD = 8; //~120 Mhz
parameter PCLK_PERIOD = 40; //24 MHz

greyscale_input UUT (
.clk(clk),
.reset_n(reset_n),
.red(red),
.green(green),
.blue(blue),
.byte_convert_valid(byte_convert_valid),
.greyscale_pixel(greyscale_pixel),
.greyscale_valid(greyscale_valid),
.greyscale_ready(greyscale_ready)
);

always#(CLK_PERIOD/2) begin
    clk = ~clk;
end
always#(PCLK_PERIOD / 2) begin
    pclk = ~pclk;
end


initial begin
byte_convert_valid = 0;
reset_n = 0;
#120;
reset_n = 1;
#80;
@(negedge pclk)
    byte_convert_valid = 1;
    red = 8'b00011100;
    green = 8'b00000111;
    blue = 8'b00011100;
@(negedge pclk)
@(negedge pclk)
    red = 8'b00000111;
    green = 8'b00011100;
    blue = 8'b00000111;
#120;
end

    
endmodule
