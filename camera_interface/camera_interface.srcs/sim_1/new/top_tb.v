`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2020 08:37:23 PM
// Design Name: 
// Module Name: top_tb
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


module top_tb();

reg clk = 0;
reg pclk = 0;
reg reset_n = 1;
reg href;
reg [7:0] dout_camera;
reg greyscale_ready = 1;
wire byte_converted_valid;
wire [7:0] red;
wire [7:0] green;
wire [7:0] blue;
wire read_fail;

parameter CLK_PERIOD = 10;
parameter PCLK_PERIOD = 40;

camera_interface_top UUT(
.clk(clk),
.reset_n(reset_n),
.href(href),
.pclk(pclk),
.dout_camera(dout_camera),
.greyscale_ready(greyscale_ready),
.byte_converted_valid(byte_converted_valid),
.red(red),
.green(green),
.blue(blue),
.read_fail(read_fail)
);

always #(CLK_PERIOD/2) begin
    clk = ~clk;
end

always #(PCLK_PERIOD/2) begin
    pclk = ~pclk;
end

initial begin
    dout_camera = 8'b00000000;
    href = 0;
    //
    @(negedge pclk);
        href = 1;
    @(negedge pclk);
        dout_camera = 8'b11110000; 
    @(negedge pclk);
        dout_camera = 8'b11110000;
    @(negedge pclk);
        dout_camera = 8'b11110100;
    @(negedge pclk);
        dout_camera = 8'b00000000;
    @(negedge pclk);
        href = 0;
        
end
    //dout_camera <= 8'b11110100;
    //#20 href = 0; dout_camera = 8'b11110000; 
    //#20 href = 1; dout_camera = 8'b11110100; 
//end
    
endmodule
