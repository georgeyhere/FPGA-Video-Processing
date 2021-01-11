`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2021 03:04:23 PM
// Design Name: 
// Module Name: gssn_minion0_compute
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


module gssn_minion0_compute(
input clk,
input reset_n,
input [7:0] BRAM_PORTB_0_dout, //memory read data
input rstb_busy_0, //memory busy flag
input [10:0] minion0_row, //goal row 

output reg BRAM_PORTB_0_en,
output reg [13:0]BRAM_PORTB_0_addr,
output reg minion_compute_ready,
output reg [7:0] gssn_minion0_out,
output reg gssn_minion0_valid
    );
endmodule
