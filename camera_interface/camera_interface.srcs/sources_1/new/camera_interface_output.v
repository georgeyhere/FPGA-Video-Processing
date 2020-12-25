`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2020 03:20:14 PM
// Design Name: 
// Module Name: camera_interface_output
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


module camera_interface_output(
input clk,//96Mhz clock
input reset_n, //asynchronous active low reset
input wr_ack_0,
input FIFO_READ_0_empty, 
input [7:0] FIFO_READ_0_rd_data,
input rd_rst_busy_0,
input greyscale_ready,
input valid_0,

output reg FIFO_READ_0_rd_en,
output reg byte_converted_valid,
output reg [7:0] red,
output reg [7:0] green,
output reg [7:0] blue,
output reg read_fail
    );
    
reg [2:0] fsm_state;
reg [2:0] fsm_next_state;
localparam s0_idle = 0;
localparam s1_read = 1;
localparam s2_assign1 = 2;
localparam s3_assign2 = 3;

reg half_identifier;

initial begin
    FIFO_READ_0_rd_en <= 0; //resets
    byte_converted_valid <= 0;
    red <= 0;
    green <= 0;
    blue <= 0;
    fsm_state <= s0_idle;
    read_fail <= 0;
    half_identifier <= 0;
end 

always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin //asynchronous active low reset
        FIFO_READ_0_rd_en <= 0; //resets 
        byte_converted_valid <= 0;
        red <= 0;
        green <= 0;
        blue <= 0;
        fsm_state <= s0_idle;
        read_fail <= 0;
        half_identifier <= 0;
    end
    else begin
    case(fsm_state) 
        
        s0_idle: begin
            FIFO_READ_0_rd_en <= 0; //resets 
            byte_converted_valid <= 0;
            red <= 0;
            green <= 0;
            blue <= 0;
            half_identifier <= 0;
            fsm_state <= (wr_ack_0 == 1) ? s1_read : s0_idle;
            read_fail <= 0;
        end
        
        s1_read: begin
            if(rd_rst_busy_0 == 0) begin 
                FIFO_READ_0_rd_en <= 1; //initiate read, go to next state
                fsm_state <= (half_identifier) ? s3_assign2 : s2_assign1; //go to next state depending on current data byte
            end
            else begin //prevent reading from busy FIFO
                fsm_state <= s0_idle; //go back to idle
                read_fail <= 1; //for diagnostic purposes only
            end
        end
        
        s2_assign1: begin //only assigns data if FIFO asserts valid flag
                                                                     //first bit is a don't care
            red [7:3] <=  (valid_0) ? FIFO_READ_0_rd_data [6:3] : 0; //next is 5 bits of red
            green [7:6] <= (valid_0) ? FIFO_READ_0_rd_data [2:0] : 0; //then 2 bits of green
            half_identifier <= (valid_0) ? 1 : 0;
            fsm_state <= (valid_0) ? s1_read:s2_assign1;
        end
        
        s3_assign2: begin //needs work
            green [4:3] <= (valid_0) ? FIFO_READ_0_rd_data[7:5] : 0; //no don't care, 3 bits of green
            blue [7:3] <= (valid_0) ? FIFO_READ_0_rd_data[4:0] : 0; //5 bits of blue
            byte_converted_valid <= (valid_0)? 1:0;
            fsm_state <= (greyscale_ready) ? s3_assign2 : s0_idle; //hold until greyscale doesn't need them anymore
        end
        
    endcase
    end
    
    
end
    
    
endmodule
