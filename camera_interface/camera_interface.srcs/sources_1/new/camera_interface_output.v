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
input reset_n , //asynchronous active low reset
input FIFO_WRITE_0_wr_en,
input wr_ack_0, 
input FIFO_READ_0_empty, 
input [7:0] FIFO_READ_0_rd_data,
input rd_rst_busy_0, //FIFO reset
input greyscale_ready,
input valid_0, //FIFO output valid
input href, //camera href, href = 1 at start of data transmission
input memory_initialize_done,
input pclk,

output reg byte_convert_valid,
output reg FIFO_READ_0_rd_en,
output reg [7:0] red,
output reg [7:0] green,
output reg [7:0] blue,
output reg read_fail //diagnostic
    );
    
reg [2:0] fsm_state;
reg [2:0] fsm_next_state;
localparam s0_initial = 0;
localparam s1_default = 1;
localparam s2_assign1 = 2;
localparam s3_timer = 3;


reg half_identifier;
reg [3:0] count;

reg [7:0] red_latch;
reg [7:0] green_latch;
reg [7:0] blue_latch;

reg byte_valid;
reg [2:0] byte_counter;
reg frame_counter;

initial begin
    FIFO_READ_0_rd_en <= 0; //resets
    red <= 0;
    green <= 0;
    blue <= 0;
    fsm_state <= s1_default;
    read_fail <= 0;
    half_identifier <= 0;
    byte_convert_valid <= 0;
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
        fsm_state <= s1_default;
        read_fail <= 0;
        half_identifier <= 0;
        byte_convert_valid <= 0;
        red_latch <= 0;
        green_latch <= 0;
        blue_latch <= 0;
        count <= 0;
    end
    else begin
    case(fsm_state) 
    
      
        s1_default: begin
            byte_convert_valid <= 0;
            half_identifier <= 0;
            if((rd_rst_busy_0 == 0) & (href == 1) & (FIFO_READ_0_empty == 0)) begin //only if not busy
                FIFO_READ_0_rd_en <= 1; //initiate read, go to next state
                fsm_state <= s2_assign1;
            end
            else begin
                FIFO_READ_0_rd_en <= 0;
                fsm_state <= s1_default;
            end
        end
        
        
        s2_assign1: begin //only assigns data if FIFO asserts valid flag or still has valid data 
        
            if(valid_0) begin
                if(href == 1) begin
                
                    case (half_identifier)
                    0: begin
                        red_latch [7:3] <= FIFO_READ_0_rd_data [6:2]; //first bit is don't care, then 5 bits of red
                        green_latch [7:6] <= FIFO_READ_0_rd_data [1:0]; //then 2 bits of green
                        //half_identifier <= 1;
                        fsm_state <= s3_timer;
                        fsm_next_state <= s2_assign1;
                        count <= 3;
                        
                    end
                    
                    1: begin
                        red <= red_latch;
                        green [7:6] <= green_latch [7:6];
                        green [5:3] <= FIFO_READ_0_rd_data[7:5]; 
                        blue [7:3] <= FIFO_READ_0_rd_data[4:0];
                        
                        byte_convert_valid <= 1;
                        //half_identifier <= 0;
                        fsm_state <= ((href == 1)&(pclk == 1)) ? s3_timer:s1_default;
                        fsm_next_state <= s2_assign1;
                        count <= 3;
                        
                        
                    end
                   
                    endcase
                end
                else begin //if href == 0 but FIFO is not empty, assign the outputs
                    red <= (FIFO_READ_0_empty == 0) ? red_latch:0;
                    green [7:6] <= (FIFO_READ_0_empty == 0) ? green_latch [7:6]:0;
                    green [5:3] <= (FIFO_READ_0_empty == 0) ? FIFO_READ_0_rd_data[7:5]:0; 
                    blue [7:3] <= (FIFO_READ_0_empty == 0) ? FIFO_READ_0_rd_data[4:0]:0;   
                    fsm_state <= (FIFO_READ_0_empty == 0) ? s3_timer:s1_default; //go to timer if not empty, if href == 0 and fifo is empty go back to default
                    count <= (FIFO_READ_0_empty == 0) ? 9:0; //set count = 3 if needed
                    fsm_next_state <= s1_default;
                     
                end
             end
             else begin
                fsm_state <= s2_assign1;
                half_identifier <= 0;
             end
        end
        
        s3_timer: begin
            fsm_state <= (count == 0) ? fsm_next_state:s3_timer;
            count <= (count == 0) ? 0:(count - 1);
            half_identifier <= (count == 0) ? (~half_identifier):half_identifier;
        end
        
        
    endcase
    end
end
    
    
endmodule
