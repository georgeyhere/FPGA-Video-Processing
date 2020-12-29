`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2020 03:00:20 PM
// Design Name: 
// Module Name: greyscale_input
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


module greyscale_input(
input clk,
input reset_n,

input [7:0] red, //RGB888 data input
input [7:0] green,
input [7:0] blue,

input byte_convert_valid, //byte_convert valid
input M_AXIS_RESULT_0_tvalid, //ip result valid

input S_AXIS_A_0_tready, //AXI protocol ready, data, valid
input S_AXIS_A_1_tready,
input S_AXIS_A_2_tready,

input S_AXIS_B_0_tready,
input S_AXIS_B_1_tready,
input S_AXIS_B_2_tready,

output reg greyscale_ready,

output reg [31:0] S_AXIS_A_0_tdata, //32-bit floating point 
output reg [31:0] S_AXIS_A_1_tdata,
output reg [31:0] S_AXIS_A_2_tdata,

output reg [31:0] S_AXIS_B_0_tdata,
output reg [31:0] S_AXIS_B_1_tdata,
output reg [31:0] S_AXIS_B_2_tdata,

output reg S_AXIS_A_0_tvalid, //32-bit floating point 
output reg S_AXIS_A_1_tvalid,
output reg S_AXIS_A_2_tvalid,

output reg S_AXIS_B_0_tvalid,
output reg S_AXIS_B_1_tvalid,
output reg S_AXIS_B_2_tvalid
    );
    
reg [1:0] fsm_state; //two fsm states
localparam s0_idle = 0;
localparam s1_assign = 1;




initial begin

    S_AXIS_A_0_tdata <= 0;
    S_AXIS_A_1_tdata <= 0;
    S_AXIS_A_2_tdata <= 0;
    
    S_AXIS_B_0_tdata <= 32'b00111110100110011001100110011010; //red multiplier = 0.3, IEE 754 representation
    S_AXIS_B_1_tdata <= 32'b00111111000110011001100110011010; //green multiplier = 0.6, IEE 754 representation
    S_AXIS_B_2_tdata <= 32'b00111101110011001100110011001101; //blue multiplier = 0.1, IEE 754 representation
    
    S_AXIS_A_0_tvalid <= 0;
    S_AXIS_A_1_tvalid <= 0;
    S_AXIS_A_2_tvalid <= 0;
    
    S_AXIS_B_0_tvalid <= 0;
    S_AXIS_B_1_tvalid <= 0;
    S_AXIS_B_2_tvalid <= 0;
    
    fsm_state <= 0;    
    greyscale_ready <= 0;
end    




always@(posedge clk, negedge reset_n) begin

if(reset_n == 1'b0) begin //asynchronous reset (active low)
    S_AXIS_A_0_tdata <= 0; //resets
    S_AXIS_A_1_tdata <= 0;
    S_AXIS_A_2_tdata <= 0;
    
    S_AXIS_B_0_tdata <= 32'b00111110100110011001100110011010; //red multiplier = 0.3, IEE 754 representation
    S_AXIS_B_1_tdata <= 32'b00111111000110011001100110011010; //green multiplier = 0.6, IEE 754 representation
    S_AXIS_B_2_tdata <= 32'b00111101110011001100110011001101; //blue multiplier = 0.1, IEE 754 representation
        
    S_AXIS_A_0_tvalid <= 1;
    S_AXIS_A_1_tvalid <= 1;
    S_AXIS_A_2_tvalid <= 1;
    
    S_AXIS_B_0_tvalid <= 1;
    S_AXIS_B_1_tvalid <= 1;
    S_AXIS_B_2_tvalid <= 1;
    
    greyscale_ready <= 0;
    fsm_state <= s0_idle; //reset to idle state
end
else begin
    
    greyscale_ready <= (byte_convert_valid == 1) ? 1:0;
    S_AXIS_A_0_tdata [7:0] <= red; //rgb will always be integer values
    S_AXIS_A_1_tdata [7:0] <= green; //32-bit fixed point number integer part is in [31:17]
    S_AXIS_A_2_tdata [7:0] <= blue; //we need the first 8 bits, hence [24:17]

    S_AXIS_A_0_tvalid <= (byte_convert_valid == 1) ? 1:0;
    S_AXIS_A_1_tvalid <= (byte_convert_valid == 1) ? 1:0;
    S_AXIS_A_2_tvalid <= (byte_convert_valid == 1) ? 1:0;
    S_AXIS_B_0_tvalid <= (byte_convert_valid == 1) ? 1:0;
    S_AXIS_B_1_tvalid <= (byte_convert_valid == 1) ? 1:0;
    S_AXIS_B_2_tvalid <= (byte_convert_valid == 1) ? 1:0;

 
end


end



    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
endmodule
