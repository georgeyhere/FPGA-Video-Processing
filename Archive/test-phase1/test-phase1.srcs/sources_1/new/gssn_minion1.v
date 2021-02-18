`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2021 05:04:56 PM
// Design Name: 
// Module Name: gssn_minion1
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


module gssn_minion1(
input clk,
input reset_n,
input [7:0] pixel_value,
input [16:0] pixel_address,
input pixel_valid,
input minion0_select,
input [10:0] minion0_target,

output [7:0] minion1_out,
output minion1_valid,
output minion1_ready
    );
    
gssn_minion1_input UUT_minion1_A (
.clk(clk),
.reset_n(reset_n),
.pixel_value(pixel_value),
.pixel_address(pixel_address),
.pixel_valid(pixel_valid),
.minion1_select(minion1_select),
.minion1_target(minion1_target),
.rsta_busy_0(rsta_busy_0),
.minion_compute_ready(minion_compute_ready),
.BRAM_PORTA_0_din(BRAM_PORTA_0_din),
.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
.BRAM_PORTA_0_we(BRAM_PORTA_0_we),
.minion0_row(minion0_row)
);    
    
BRAM_gssn_1_wrapper UUT_minion1_B (
.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
.BRAM_PORTA_0_clk(BRAM_PORTA_0_clk),
.BRAM_PORTA_0_din(BRAM_PORTA_0_din),
.BRAM_PORTA_0_we(BRAM_PORTA_0_we),
.BRAM_PORTB_0_addr(BRAM_PORTB_0_addr),
.BRAM_PORTB_0_clk(BRAM_PORTB_0_clk),
.BRAM_PORTB_0_dout(BRAM_PORTB_0_dout),
.BRAM_PORTB_0_en(BRAM_PORTB_0_en),
.BRAM_PORTB_0_rst(BRAM_PORTB_0_rst),
.rsta_busy_0(rsta_busy_0),
.rstb_busy_0(rstb_busy_0)
);    

gssn_minion1_compute UUT_minion1_C (
.clk(clk),
.reset_n(reset_n),
.BRAM_PORTB_0_dout(BRAM_PORTB_0_dout),
.rstb_busy_0(rstb_busy_0),
.minion0_row(minion0_row),
.BRAM_PORTB_0_en(BRAM_PORTB_0_en),
.BRAM_PORTB_0_addr(BRAM_PORTB_0_addr),
.minion_compute_ready(minion_compute_ready),
.gssn_minion1_out(gssn_minion0_out),
.gssn_minion1_valid(gssn_minion0_valid)
);

    
endmodule
