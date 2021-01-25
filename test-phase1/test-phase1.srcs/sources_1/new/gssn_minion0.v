`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2021 05:04:56 PM
// Design Name: 
// Module Name: gssn_minion0
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


module gssn_minion0( //minion 1
input clk,
input reset_n,
input [7:0] pixel_value,
input [16:0] pixel_address,
input pixel_valid,
input minion0_select,
input [10:0] minion0_target,

output [7:0] gssn_minion0_out,
output gssn_minion0_valid,
output gssn_minion0_ready
    );

wire rsta_busy_0;
wire BRAM_PORTA_0_din;
wire [16:0] BRAM_PORTA_0_addr;
wire BRAM_PORTA_0_we;
wire [10:0] minion0_row;
wire [7:0] BRAM_PORTB_0_dout;
wire BRAM_PORTB_0_en;
wire rstb_busy_0;
wire minion0_ready;

gssn_minion0_input UUT_minion0_A (
.clk(clk),
.reset_n(reset_n),
.pixel_value(pixel_value),
.pixel_address(pixel_address),
.pixel_valid(pixel_valid),
.minion0_select(minion0_select),
.minion0_target(minion0_target),
.minion0_ready(minion0_ready),
.rsta_busy_0(rsta_busy_0),
.minion_compute_start(minion_compute_start),
.BRAM_PORTA_0_din(BRAM_PORTA_0_din),
.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
.BRAM_PORTA_0_we(BRAM_PORTA_0_we),
.minion0_row(minion0_row)
);    
    
gssn_minion0_BRAM_wrapper UUT_minion0_B (
.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
.BRAM_PORTA_0_clk(clk),
.BRAM_PORTA_0_din(BRAM_PORTA_0_din),
.BRAM_PORTA_0_we(BRAM_PORTA_0_we),
.BRAM_PORTB_0_addr(BRAM_PORTB_0_addr),
.BRAM_PORTB_0_clk(clk),
.BRAM_PORTB_0_dout(BRAM_PORTB_0_dout),
.BRAM_PORTB_0_en(BRAM_PORTB_0_en),
.BRAM_PORTB_0_rst(reset_n),
.rsta_busy_0(rsta_busy_0),
.rstb_busy_0(rstb_busy_0)
);    

gssn_minion0_compute UUT_minion0_C (
.clk(clk),
.reset_n(reset_n),
.BRAM_PORTB_0_dout(BRAM_PORTB_0_dout),
.minion0_row(minion0_row),
.minion_compute_start(minion_compute_start),
.minion0_ready(minion0_ready),
.BRAM_PORTB_0_en(BRAM_PORTB_0_en),
.BRAM_PORTB_0_addr(BRAM_PORTB_0_addr),
.gssn_minion0_out(gssn_minion0_out),
.gssn_minion0_valid(gssn_minion0_valid)
);

    
endmodule
