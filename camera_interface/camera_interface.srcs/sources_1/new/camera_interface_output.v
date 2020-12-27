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
localparam s3_assign2 = 3;


reg half_identifier;

reg [7:0] red_latch;
reg [7:0] green_latch;
reg [7:0] blue_latch;

initial begin
    FIFO_READ_0_rd_en <= 0; //resets
    red <= 0;
    green <= 0;
    blue <= 0;
    fsm_state <= s0_initial;
    read_fail <= 0;
    half_identifier <= 0;
    byte_convert_valid <= 0;
    red_latch <= 0;
    green_latch <= 0;
    blue_latch <= 0;
end 

always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin //asynchronous active low reset
        FIFO_READ_0_rd_en <= 0; //resets 
        red <= 0;
        green <= 0;
        blue <= 0;
        fsm_state <= s0_initial;
        read_fail <= 0;
        half_identifier <= 0;
        byte_convert_valid <= 0;
        red_latch <= 0;
        green_latch <= 0;
        blue_latch <= 0;
    end
    else begin
    case(fsm_state) 
    
        s0_initial: begin
            FIFO_READ_0_rd_en <= (valid_0) ? 0:1;
            fsm_state <= (valid_0) ? s1_default : s0_initial;
        end
       
        s1_default: begin
            if(FIFO_WRITE_0_wr_en == 1) begin //start read operation on new write 
                if(rd_rst_busy_0 == 0) begin //only if not busy
                    FIFO_READ_0_rd_en <= (memory_initialize_done == 1) ? 1:0; //initiate read, go to next state
                    if(memory_initialize_done == 0) fsm_state <= s1_default; //initial memory reset, don't process the data
                    else fsm_state <= (half_identifier) ? s3_assign2 : s2_assign1; //go to next state depending on current data byte
                end
                else begin
                    FIFO_READ_0_rd_en <= 0;
                    fsm_state <= s1_default;
                end
            end
        end
        
        
        s2_assign1: begin //only assigns data if FIFO asserts valid flag
            if(valid_0) begin
                red_latch [7:3] <= FIFO_READ_0_rd_data [6:1]; //first bit is don't care, then 5 bits of red
                green_latch [7:6] <= FIFO_READ_0_rd_data [1:0]; //then 2 bits of green
                half_identifier <= 1;
                fsm_state <= s1_default;
            end
            else fsm_state <= s2_assign1;    
        end
        
        s3_assign2: begin //needs work
        
            if(valid_0) begin //normal operation
                case(half_identifier) //check half_identifier to see if this is an old data frame
                
                0: begin //greyscale still needs the old data
                    red <= red_latch; //assign latched data
                    green <= green_latch;
                    blue <= blue_latch;
                    byte_convert_valid <= 1; //data is valid even if input changes
                    fsm_state <= (greyscale_ready == 1) ? s3_assign2 : s1_default; //want to hold latched values until calculation starts
                end
                
                1: begin //assign outputs, reset half_identifier for next frame
                    red <= red_latch;
                    green [7:5] <= green_latch [7:5]; //assign first half of green output 
                    green [4:3] <= FIFO_READ_0_rd_data[7:5]; //assign green output  
                    blue [7:3] <= FIFO_READ_0_rd_data[4:0]; //assign blue output 
                    green_latch [7:6] <= green [7:6]; //latch green from last byte 
                    green_latch [5:3] <= FIFO_READ_0_rd_data[7:5]; //latch green from current byte
                    blue_latch [7:3] <= FIFO_READ_0_rd_data[4:0]; //latch blue from current byte 
                    
                    half_identifier <= 0; //reset half modifier, don't want to reassign latched data until next dataframe
                    byte_convert_valid <= 1; 
                    fsm_state <= (greyscale_ready == 1) ? s3_assign2 : s1_default; //want to hold latched values until calculation starts
                end
                
            endcase
            end
            
            else begin //no valid input data
                byte_convert_valid <= 0; 
                fsm_state <= s3_assign2; 
            end
            
        end
    endcase
    end
end
    
    
endmodule
