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
input clk,//120Mhz clock
input reset_n , //asynchronous active low reset
input wr_ack_0, 
input FIFO_READ_0_empty, 
input [7:0] FIFO_READ_0_rd_data,
input rd_rst_busy_0, //FIFO reset
input greyscale_ready,
input valid_0, //FIFO output valid
input href, //camera href, href = 1 at start of data transmission
input pclk,

output reg rgb_valid,
output reg FIFO_READ_0_rd_en,
output reg [7:0] red,
output reg [7:0] green,
output reg [7:0] blue
    );
    
reg [2:0] fsm_state;
reg [2:0] fsm_next_state;

localparam s0_default = 0;
localparam s1_assign = 1;
localparam s2_timer = 2;


reg half_identifier; //identifies current byte 
reg [3:0] count; //timer register

reg [7:0] red_latch; //used to store data from previous data byte in two-frame transmission
reg [7:0] green_latch;
reg [7:0] blue_latch;

initial begin
    FIFO_READ_0_rd_en <= 0; //resets
    red <= 0;
    green <= 0;
    blue <= 0;
    fsm_state <= s0_default;
    half_identifier <= 0;
    rgb_valid <= 0;
    red_latch <= 0;
    green_latch <= 0;
    blue_latch <= 0;
    count <= 0;
end 

always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin //asynchronous active low reset
        FIFO_READ_0_rd_en <= 0; //resets 
        red <= 0;
        green <= 0;
        blue <= 0;
        fsm_state <= s0_default;
        half_identifier <= 0;
        rgb_valid <= 0;
        red_latch <= 0;
        green_latch <= 0;
        blue_latch <= 0;
        count <= 0;
    end
    else begin
    
    case(fsm_state)  
        
        s0_default: begin
            rgb_valid <= 0;
            half_identifier <= 0;
            count <= 0;
            if(wr_ack_0 == 1) begin //only if not busy
                FIFO_READ_0_rd_en <= 1; //initiate read, go to next state
                fsm_state <= s1_assign;
            end
            else begin
                FIFO_READ_0_rd_en <= 0;
                fsm_state <= s0_default;
            end
        end
    
        s1_assign: begin //only assigns data if FIFO asserts valid flag or still has valid data 
        
            if(valid_0) begin
                if(href == 1) begin
                
                    case (half_identifier)
                    0: begin
                        red_latch [7:3] <= FIFO_READ_0_rd_data [6:2]; //first bit is don't care, then 5 bits of red
                        green_latch [7:6] <= FIFO_READ_0_rd_data [1:0]; //then 2 bits of green
                        //half_identifier <= 1;
                        fsm_state <= s2_timer;
                        fsm_next_state <= s1_assign;
                        count <= 3;
                    end
                    
                    1: begin
                        red <= red_latch;
                        green [7:6] <= green_latch [7:6];
                        green [5:3] <= FIFO_READ_0_rd_data[7:5]; 
                        blue [7:3] <= FIFO_READ_0_rd_data[4:0];
                        
                        rgb_valid <= 1;
                        //half_identifier <= 0;
                        fsm_state <= ((href == 1)&(pclk == 1)) ? s2_timer:s0_default;
                        fsm_next_state <= s1_assign;
                        count <= 3;   
                    end
                   
                    endcase
                end
                else begin //if href == 0 but FIFO is not empty, assign the outputs
                    fsm_next_state <= s0_default;
                    if(FIFO_READ_0_empty == 0) begin
                        red <= red_latch;
                        green [7:6] <= green_latch [7:6];
                        green [5:3] <= FIFO_READ_0_rd_data[7:5];
                        blue [7:3] <= FIFO_READ_0_rd_data[4:0];
                        fsm_state <= s2_timer;
                        count <= 9;
                        
                    end
                    else begin
                        red <= 0;
                        green [7:6] <= 0;
                        green [5:3] <= 0;
                        blue [7:3] <= 0;
                        fsm_state <= s0_default;
                    end
                    //red <= (FIFO_READ_0_empty == 0) ? red_latch:0;
                    //green [7:6] <= (FIFO_READ_0_empty == 0) ? green_latch [7:6]:0;
                    //green [5:3] <= (FIFO_READ_0_empty == 0) ? FIFO_READ_0_rd_data[7:5]:0; 
                    //blue [7:3] <= (FIFO_READ_0_empty == 0) ? FIFO_READ_0_rd_data[4:0]:0;   
                    //fsm_state <= (FIFO_READ_0_empty == 0) ? s2_timer:s0_default; //go to timer if not empty, if href == 0 and fifo is empty go back to default
                    //count <= (FIFO_READ_0_empty == 0) ? 9:0; //set count = 3 if needed
                    //fsm_next_state <= s0_default; 
                end
             end
             else begin
                fsm_state <= s1_assign;
                half_identifier <= 0;
             end
        end
        
        s2_timer: begin
            fsm_state <= (count == 0) ? fsm_next_state:s2_timer;
            count <= (count == 0) ? 0:(count - 1);
            half_identifier <= (count == 0) ? (~half_identifier):half_identifier;
        end    
        
    endcase
    end
end
    
    
endmodule
