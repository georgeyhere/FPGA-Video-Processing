`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2020 01:40:33 PM
// Design Name: 
// Module Name: config_ROM_tb
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


module config_ROM_tb();
    
    
reg clk = 0;
reg [7:0] rom_index= 8'b0;

wire [15:0] dout;
    
config_ROM UUT(
.clk(clk),
.rom_index(rom_index),
.dout(dout)
);

always begin
#1 clk =~clk;  rom_index = rom_index +1;
end
    
endmodule
