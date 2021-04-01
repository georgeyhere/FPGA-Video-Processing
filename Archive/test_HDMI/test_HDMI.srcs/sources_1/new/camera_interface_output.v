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
    input       clk,//100Mhz clock
    input       reset, //asynchronous active low reset
    input       system_start,
    input       wr_ack_0, 
    input       FIFO_READ_0_empty, 
    input [7:0] FIFO_READ_0_rd_data,
    input       rd_rst_busy_0, //FIFO reset
    input       greyscale_ready,
    input       valid_0, //FIFO output valid
    input       href, //camera href, href = 1 at start of data transmission
    input       pclk,

    output reg       FIFO_READ_0_rd_en,
    output reg [7:0] red,
    output reg [7:0] green,
    output reg [7:0] blue
    );
 
// ===========================================================================
// 			           Parameters, Registers, and Wires
// ===========================================================================   
    reg [2:0] fsm_state;
    reg [2:0] fsm_next_state;

    localparam s0_default = 3'b000;
    localparam s1_assign  = 3'b010;
    localparam s2_timer   = 3'b100;

    reg half_identifier; //identifies current byte 
    reg [3:0] count; //timer register

    reg [7:0] red_latch; //used to store data from previous data byte in two-frame transmission
    reg [7:0] green_latch;
    reg [7:0] blue_latch;
    
// ===========================================================================
//                              Implementation    
// ===========================================================================
    initial begin
        FIFO_READ_0_rd_en <= 0; //resets
        red <= 0;
        green <= 0;
        blue <= 0;
        fsm_state <= s0_default;
        half_identifier <= 0;
        red_latch <= 0;
        green_latch <= 0;
        blue_latch <= 0;
        count <= 0;
    end 

    always@(posedge clk, posedge reset) begin
        if(reset == 1'b1) begin //asynchronous active low reset
            FIFO_READ_0_rd_en <= 0; //resets 
            red <= 0;
            green <= 0;
            blue <= 0;
            fsm_state <= s0_default;
            half_identifier <= 0;
            red_latch <= 0;
            green_latch <= 0;
            blue_latch <= 0;
            count <= 0;
        end
       
        else begin
            case(fsm_state)  
        
                s0_default: begin
                    if(wr_ack_0 == 1) begin //only if not busy
                        FIFO_READ_0_rd_en <= 1; //initiate read, go to next state
                        fsm_state <= (system_start) ? s1_assign:s0_default;
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
                                    fsm_state <= s2_timer;
                                    fsm_next_state <= s1_assign;
                                    count <= 3;
                                end
                    
                                1: begin
                                    fsm_state <= ((href == 1)&(pclk == 1)) ? s2_timer:s0_default; //data transmission occurs only on negedge of pclk, don't transition until posedge
                                    fsm_next_state <= s1_assign;
                                    count <= 3;   
                                end
                            endcase
                        end
                        else begin //if href == 0 but FIFO is not empty, assign the outputs
                            fsm_next_state <= s0_default;
                            if(FIFO_READ_0_empty == 0) begin
                                fsm_state <= s2_timer;
                                count <= 9;  
                            end
                            else begin
                                fsm_state <= s0_default;
                            end
                        end
                    end
                    else begin
                        fsm_state <= s1_assign;
                    end
                end
        
                s2_timer: begin
                    fsm_state <= (count == 0) ? fsm_next_state:s2_timer; 
                end    
        
            endcase
       end
    end


    always@(posedge clk) begin
        case(fsm_state) 
            
            s0_default: begin
                half_identifier <= 0;
                count <= 0;
                FIFO_READ_0_rd_en <= (wr_ack_0 == 1) ? 1:0;
            end   
            
            s1_assign: begin //only assigns data if FIFO asserts valid flag or still has valid data 
                if(valid_0) begin
                    if(href == 1) begin
                        case (half_identifier)
                            0: begin
                                red_latch [7:3] <= FIFO_READ_0_rd_data [6:2]; //first bit is don't care, then 5 bits of red
                                green_latch [7:6] <= FIFO_READ_0_rd_data [1:0]; //then 2 bits of green
                                half_identifier <= 1;
                             end
                    
                            1: begin
                                red <= red_latch;
                                green [7:6] <= green_latch [7:6];
                                green [5:3] <= FIFO_READ_0_rd_data[7:5]; 
                                blue [7:3] <= FIFO_READ_0_rd_data[4:0];
                                half_identifier <= 0;
                            end                   
                        endcase
                    end
                    else begin //if href == 0 but FIFO is not empty, assign the outputs
                        if(FIFO_READ_0_empty == 0) begin
                            red <= red_latch;
                            green [7:6] <= green_latch [7:6];
                            green [5:3] <= FIFO_READ_0_rd_data[7:5];
                            blue [7:3] <= FIFO_READ_0_rd_data[4:0]; 
                        end
                        else begin
                            red <= 0;
                            green [7:6] <= 0;
                            green [5:3] <= 0;
                            blue [7:3] <= 0;
                        end
                   end
                end
                else begin
                    half_identifier <= 0;
                end
            end
            
            s2_timer: begin
                count <= (count == 0) ? 0:(count - 1);
                half_identifier <= (count == 0) ? (~half_identifier):half_identifier;
            end  
                       
        endcase
    end
    
    
endmodule
