`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2020 06:33:42 PM
// Design Name: 
// Module Name: camera_fifo_output
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


module camera_fifo_output(
input clk,
input reset_n,
input FIFO_READ_0_empty,
input [7:0] FIFO_READ_0_rd_data,
input FIFO_WRITE_0_wr_en,
input rd_rst_busy_0,
input greyscaler_ready,

output reg FIFO_READ_0_rd_en,
output reg byte_convert_valid,
output reg [7:0] red,
output reg [7:0] green,
output reg [7:0] blue
    );

    
reg [2:0] fsm_state;
localparam s0_idle = 0;   
localparam s1_read = 1; 
localparam s2_combine1 = 2;    
localparam s3_combine2 = 3;


initial begin //initial state 
    red <= 0; 
    green <= 0;
    blue <= 0;
    byte_convert_valid <= 0; 
    FIFO_READ_0_rd_en <= 0;
end
    
always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin //asynchronous active low reset
        red <= 0; //resets
        green <= 0;
        blue <= 0;
        byte_convert_valid <= 0;
        FIFO_READ_0_rd_en <= 0;
    end
    
    case(fsm_state) 
        
    s0_idle: begin
        FIFO_READ_0_rd_en <= 0;     
        fsm_state <= (FIFO_WRITE_0_wr_en) ? s1_read:s0_idle; //new byte will be written to FIFO next clock
    end
    
    s1_read: begin //initiate FIFO read operation
        FIFO_READ_0_rd_en <= (rd_rst_busy_0 == 0 & greyscaler_ready == 1) ? 1:0;
        fsm_state <= (rd_rst_busy_0 == 0 & greyscaler_ready == 1)? s2_combine1:s0_idle; //don't read from FIFO if busy
    end
    
    s2_combine1: begin //decode the first byte of the pixel
        byte_convert_valid <= 0; //calculating new outputs, toggle done
        red [4:0] <=  FIFO_READ_0_rd_data[6:3];
        green [4:3] <= FIFO_READ_0_rd_data[2:0];    
        fsm_state <= s3_combine2;
    end
    
    s3_combine2: begin //decode the second byte of the pixel
        green [2:0] <= FIFO_READ_0_rd_data[7:5];
        blue [4:0] <= FIFO_READ_0_rd_data[4:0];
        byte_convert_valid <= 1; //done
        fsm_state <= s0_idle;
    end
    
    endcase
end     
    
endmodule
