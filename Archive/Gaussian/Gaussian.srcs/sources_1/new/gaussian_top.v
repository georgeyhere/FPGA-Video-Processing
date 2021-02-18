`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2021 07:08:27 PM
// Design Name: 
// Module Name: gaussian_top
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


module gaussian_top(
input clk,
input reset_n,
input greyscale_valid,
input [7:0] greyscale_value,
input [16:0] BRAM_PORTB_0_addr,
input BRAM_PORTB_0_en,
output gaussian_ready,
output [7:0]BRAM_PORTB_0_dout
    );

wire [16:0] BRAM_PORTA_0_addr;
wire [7:0] BRAM_PORTA_0_din;
wire BRAM_PORTA_0_en;
wire BRAM_PORTA_0_we;

 
memory_write UUT3A (
.clk(clk),
.reset_n(reset_n),
.greyscale_value(greyscale_value),
.greyscale_valid(greyscale_valid),
.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
.BRAM_PORTA_0_din(BRAM_PORTA_0_din),
.BRAM_PORTA_0_en(BRAM_PORTA_0_en),
.BRAM_PORTA_0_we(BRAM_PORTA_0_we)
); 

BRAM_2_greyscale_wrapper UUT3B (
.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
.BRAM_PORTA_0_din(BRAM_PORTA_0_din),
.BRAM_PORTA_0_en(BRAM_PORTA_0_en),
.BRAM_PORTA_0_we(BRAM_PORTA_0_we),
.BRAM_PORTB_0_addr(BRAM_PORTB_0_addr),
.BRAM_PORTB_0_dout(BRAM_PORTB_0_dout),
.BRAM_PORTB_0_en(BRAM_PORTB_0_en),
.clka_0(clk)
);
    
    
endmodule
