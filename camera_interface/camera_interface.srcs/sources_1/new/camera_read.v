`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2020 02:11:56 PM
// Design Name: 
// Module Name: camera_read
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

module camera_read_input(
input clk, //logic runs at 96Mhz clock
input reset_n,

input href,
input [7:0] camera_data,

input FIFO_WRITE_0_full,
input wr_rst_busy_0,

output reg [7:0] FIFO_WRITE_0_wr_data,
output reg FIFO_WRITE_0_wr_en
);

reg[2:0] fsm_state;
reg half_identifier;

localparam s0_idle = 0;
localparam s1_assign = 1;
localparam s2_full = 2;

initial begin
    fsm_state <= 0;
    FIFO_WRITE_0_wr_data <= 0;
    FIFO_WRITE_0_wr_en <= 0;
end

always@(posedge clk, negedge reset_n) begin

if(reset_n == 1'b0) begin
    FIFO_WRITE_0_wr_en <= 0; //resets
    FIFO_WRITE_0_wr_data <= camera_data;
    fsm_state <= 0;
end

case(fsm_state) 
    s0_idle: begin
        FIFO_WRITE_0_wr_en <= 0;
        FIFO_WRITE_0_wr_data <= 0;
        half_identifier <= 0;
        fsm_state <= (href) ? s1_assign:s0_idle;
    end
    
    s1_assign: begin
        if(FIFO_WRITE_0_full==1 & wr_rst_busy_0==1) begin //if FIFO is not full and not busy, write as normal
            FIFO_WRITE_0_wr_en <= 1;
            FIFO_WRITE_0_wr_data <= camera_data; 
        end
        else fsm_state <= s0_idle; //if FIFO is full or busy, skip the byte
    end
       
endcase
end



endmodule