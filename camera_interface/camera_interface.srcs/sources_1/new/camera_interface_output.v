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
input FIFO_WRITE_0_wr_en,
input FIFO_READ_0_empty, 
input [7:0] FIFO_READ_0_rd_data,
input rd_rst_busy_0,
input greyscale_ready,

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
    fsm_next_state <= 0;
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
        fsm_next_state <= 0;
    end
    
    case(fsm_state) 
        
        s0_idle: begin
            FIFO_READ_0_rd_en <= 0; //resets 
            byte_converted_valid <= 0;
            red <= 0;
            green <= 0;
            blue <= 0;
            half_identifier <= 0;
            fsm_state <= (FIFO_WRITE_0_wr_en == 1) ? s1_read : s0_idle;
            fsm_next_state <= 0;
        end
        
        s1_read: begin
            if(rd_rst_busy_0 + FIFO_READ_0_empty) begin //I don't want this to ever be triggered
                fsm_state <= s0_idle; 
                read_fail <= 1; //goal is for this to never toggle, for diagnostic purposes only
            end
            else begin
                FIFO_READ_0_rd_en <= 1; //else initiate read, go to next state
                fsm_state <= (half_identifier) ? s3_assign2 : s2_assign1; //go to next state depending on current data byte
            end
        end
        
        s2_assign1: begin
                                                     //first bit is a don't care
            red [7:3] <=  FIFO_READ_0_rd_data [6:3]; //next is 5 bits of red
            green [7:6] <= FIFO_READ_0_rd_data [2:0]; //then 2 bits of green
            half_identifier <= 1;
            fsm_state <= s1_read;
        end
        
        s3_assign2: begin
            green [4:3] <= FIFO_READ_0_rd_data[7:5]; //no don't care, 3 bits of green
            blue [7:3] <= FIFO_READ_0_rd_data[4:0]; //5 bits of blue
            byte_converted_valid <= 1;
            fsm_state <= (greyscale_ready) ? s3_assign2 : s0_idle; //hold until greyscale doesn't need them anymore
        end
        
    endcase
    
    
    
end
    
    
endmodule
