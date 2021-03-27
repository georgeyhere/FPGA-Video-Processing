`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2021 10:15:33 PM
// Design Name: 
// Module Name: test_tb
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


module test_tb();

reg clk;
reg reset_n;
reg start_button;
reg pclk;
reg href;
reg vsync;
reg [7:0] camera_dout;


wire configure_start;
wire system_start;
wire sioc;
wire siod;
wire vga_hsync;
wire vga_vsync;
wire [7:0] vga_red;
wire [7:0] vga_green;
wire [7:0] vga_blue;
wire frame_done;

parameter CLK_PERIOD = 8; //125Mhz clock
parameter PCLK_PERIOD = 40; //24Mhz pixel clock


always#(CLK_PERIOD/2) begin
    clk = ~clk;
end

always #(PCLK_PERIOD/2) begin
    pclk = ~pclk;
end

test_top UUT (
.clk(clk),
.reset_n(reset_n),
.start_button(start_button),
.pclk(pclk),
.href(href),
.vsync(vsync),
.camera_dout(camera_dout),
.sioc(sioc),
.siod(siod),
.vga_hsync(vga_hsync),
.vga_vsync(vga_vsync),
.vga_red(vga_red),
.vga_green(vga_green),
.vga_blue(vga_blue),
.frame_done(frame_done)
);

initial begin
    clk <= 0;
    reset_n <= 0;
    start_button <= 0;
    pclk <= 0;
    href <= 0;
    vsync <= 0;
    camera_dout <= 8'b0;
    #100;

    #150
    reset_n <= 1;
    #8;
    start_button <= 1;
    
    
end

    
endmodule
