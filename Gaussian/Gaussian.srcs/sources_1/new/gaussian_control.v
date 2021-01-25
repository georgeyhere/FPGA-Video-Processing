`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2021 01:46:37 PM
// Design Name: 
// Module Name: memory_write
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
//640*3  = 1920 pixels
//1920 * 8 = 15360 bytes of data
//15360 * 8 = 122880

module gaussian_control(
input clk,
input reset_n,
input vsync,
input [7:0] greyscale_value,
input greyscale_valid,
input minion0_ready,
input minion1_ready,
input minion2_ready,

output reg [16:0] pixel_address, //pixel address
output reg [7:0] pixel_value,
output reg pixel_valid,
output reg minion0_select,
output reg minion1_select,
output reg minion2_select,
output reg [10:0] minion0_target,
output reg [10:0] minion1_target,
output reg [10:0] minion2_target

    );

reg [31:0] count;
reg [10:0] row_count;
reg [16:0] address;
reg [15:0] byte_count;    
reg [2:0] fsm_state;  
localparam s0_default = 0;  
localparam s1_timer = 1;

always@(posedge greyscale_valid) row_count <= row_count + 1;
always@(negedge vsync) row_count <= 0;

initial begin
    pixel_address <= 0;
    pixel_valid <= 0;
    pixel_value <= 0;
    fsm_state <= 0;
    address <= 0;
    byte_count <= 0;
    row_count <= 0;
    count <= 0;
    minion0_target <= 0;
    minion1_target <= 0;
    minion2_target <= 0;
end

    
always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin
        pixel_address <= 0;
        pixel_value <= 0;
        pixel_valid <= 0;
        minion0_select <= 0;
        minion1_select <= 0;
        minion2_select <= 0;
        byte_count <= 0;
        row_count <= 0;
        count <= 0;
        minion0_target <= 0;
        minion1_target <= 0;
        minion2_target <= 0;
    end
    else begin
    
        if(row_count > 0) begin 
            case(greyscale_valid)
                        0: begin
                            pixel_address <= 0;
                            pixel_value <= 0;
                            pixel_valid <= 0;
                        end
                        1: begin //send the data until greyscale_valid is deasserted
                            case(fsm_state) 
                                s0_default: begin
                                    pixel_address <= byte_count * 8;
                                    pixel_value <= greyscale_value;
                                    pixel_valid <= 1;
                                    fsm_state <= s1_timer;
                                    count <= 8;
                                end
                                s1_timer: begin
                                    count <= (count == 0) ? 0:(count-1);
                                    fsm_state <= (count == 0) ? s0_default:s1_timer;
                                    byte_count <= (count == 0) ? (byte_count + 1):byte_count;
                                end
                            endcase
                        end
            endcase
         end
         else begin
            pixel_address <= 0;
            pixel_value <= 0;
            pixel_valid <= 0;
         end
        
        case(row_count) 
        
            0: begin //row_count = 0 means in between frames
                pixel_address <= 0;
                pixel_value <= 0;
                pixel_valid <= 0;
                minion0_select <= 0;
                minion1_select <= 0;
                minion2_select <= 0;
                byte_count <= 0;
            end
            
            1: begin //greyscale_valid has gone high for the first time in the frame
                minion0_select <= 1; //select minion 1
                minion0_target <= 0; //set minion0 to compute row 0
            end
            
            2: begin //greyscale_valid has gone high for the second time in the frame
                minion1_select <= 1; //minion0 is already selected, select minion1 as well
                minion1_target <= 1; //set minion1 to compute row 1
                if(greyscale_valid == 0) begin
                    minion0_select <= 0;
                    minion0_target <= 0;
                end
                else begin
                    minion0_select <= 1;
                    minion0_target <= 1;
                end
            end
            
            3: begin //greyscale_valid has gone high for the third time in the frame
                minion2_select <= 1; //select minion2, all minions currently receiving data
                minion2_target <= 2; //set minion2 to compute row 2
            end
            
            4: begin
                minion0_select <= 0; //minion0 has had three rows now, deselect it 
            end
            
            5: begin
                minion1_select <= 0;
            end
            
            6: begin
                minion2_select <= 0;
            end
            
        endcase
        
    end
end



endmodule
