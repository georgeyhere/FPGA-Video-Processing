`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2020 04:29:29 PM
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
reg reset_n = 1;

reg [7:0] red = 8'b00011100; //test values
reg [7:0] green = 8'b00000111;
reg [7:0] blue = 8'b00011100;

reg byte_convert_valid;

reg M_AXIS_RESULT_0_tready = 1;
wire [31:0] M_AXIS_RESULT_0_tdata;
wire M_AXIS_RESULT_0_tvalid;

parameter CLK_PERIOD = 8; //~125 Mhz

greyscale_top UUT (
.clk(clk),
.reset_n(reset_n),
.red(red),
.green(green),
.blue(blue),
.byte_convert_valid(byte_convert_valid),
.M_AXIS_RESULT_0_tready(M_AXIS_RESULT_0_tready),
.M_AXIS_RESULT_0_tdata(M_AXIS_RESULT_0_tdata),
.M_AXIS_RESULT_0_tvalid(M_AXIS_RESULT_0_tvalid)
);

always#(CLK_PERIOD/2) begin
    clk = ~clk;
end


initial begin
byte_convert_valid = 0;
reset_n = 0;
#120;
reset_n = 1;
#80;
byte_convert_valid = 1;
#120;
end

    
endmodule
