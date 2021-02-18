`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2021 03:27:33 PM
// Design Name: 
// Module Name: UUT2A_ROM_tb
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


module UUT2A_ROM_tb();

reg clk;
reg reset_n;
reg [7:0] addr;
wire [15:0] dout;

parameter CLK_PERIOD = 8;

always#(CLK_PERIOD/2) begin
    clk= ~clk;
end


OV7670_config_rom UUT(
.clk(clk),
.reset_n(reset_n),
.addr(addr),
.dout(dout)
);

initial begin
    clk <= 0;
    reset_n <= 0;
    addr <= 8'h0;
    #100;
    reset_n <= 1;
    #8;
    addr <= 8'h1;
    #16;
    addr <= 8'h2;
    
    
end
 
endmodule
