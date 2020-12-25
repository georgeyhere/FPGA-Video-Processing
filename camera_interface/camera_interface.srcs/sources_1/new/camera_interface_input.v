`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2020 03:03:40 PM
// Design Name: 
// Module Name: camera_interface_input
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


module camera_interface_input(
input clk, //96 MHz clock
input reset_n, //asynchronous active low reset 
input pclk, //camera pixel clock 
input [7:0] dout_camera, //camera data out
input href, //camera output
input FIFO_WRITE_0_full, //FIFO statuses
input wr_rst_busy_0,

output reg FIFO_WRITE_0_wr_en, //FIFO write 
output reg [7:0] FIFO_WRITE_0_wr_data
    );
    
reg [1:0] fsm_state; 
localparam s0_idle = 0;
localparam s1_assign = 1;

initial begin
    fsm_state <= s0_idle; //resets
    FIFO_WRITE_0_wr_en <= 0;
    FIFO_WRITE_0_wr_data <= 0;
end    

always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin //asynchronous active low reset
        fsm_state <= s0_idle; //resets
        FIFO_WRITE_0_wr_en <= 0;
        FIFO_WRITE_0_wr_data <= 0;
    end
    else begin
    case(fsm_state) 
    
    s0_idle: begin
        FIFO_WRITE_0_wr_en <= 0; //don't write if camera isn't outputting data
        FIFO_WRITE_0_wr_data <= 0; 
        fsm_state <= (href == 1)? s1_assign : s0_idle; //start writing when href goes high
    end
    
    s1_assign: begin
        FIFO_WRITE_0_wr_en <= (pclk==0) ? 1:0; //write enable only on pclk negative edge
        FIFO_WRITE_0_wr_data <= dout_camera; //assign output data
        fsm_state <= (href == 0) ? s0_idle : s1_assign; //data is only sent when href is high
    end
    
    endcase
    end
end
    
    
endmodule
