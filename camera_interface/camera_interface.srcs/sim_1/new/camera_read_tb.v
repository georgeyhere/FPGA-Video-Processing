`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2020 06:07:51 PM
// Design Name: 
// Module Name: camera_read_tb
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


module camera_read_tb();

reg clk = 0;
reg reset_n = 1;
reg [7:0] camera_data;
reg FIFO_WRITE_0_full = 0;
reg wr_rst_busy_0 = 0;
reg href = 0;

wire [7:0] FIFO_WRITE_0_wr_data;
wire FIFO_WRITE_0_wr_en;

camera_read UUT(
.clk(clk),
.reset_n(reset_n),
.href(href),
.camera_data(camera_data),
.FIFO_WRITE_0_full(FIFO_WRITE_0_full),
.wr_rst_busy_0(wr_rst_busy_0),
.FIFO_WRITE_0_wr_data(FIFO_WRITE_0_wr_data),
.FIFO_WRITE_0_wr_en(FIFO_WRITE_0_wr_en)
);

always begin
#1 clk = ~clk;
end

initial begin
camera_data = 8'b11110000; 
href = 1;
#4 
camera_data = 8'b11111100;
#4
camera_data = 8'b11110000;
#4
camera_data = 8'b11111100;
#4
camera_data = 8'b11110000;
#4
camera_data = 8'b11111100;
#4
camera_data = 8'b11110000;
#4
camera_data = 8'b11110000;
href = 0;

end
    
endmodule
