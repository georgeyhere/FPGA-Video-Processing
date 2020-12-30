`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2020 03:29:52 PM
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


module greyscale(
input clk,
input reset_n,
input byte_convert_valid,
input [7:0] red,
input [7:0] green,
input [7:0] blue,

output reg [7:0] greyscale_value,
output reg greyscale_valid,
output reg greyscale_ready

//output reg [7:0] A_0,
//output reg [7:0] A_1,
//output reg [7:0] A_2,
//output reg [7:0] B_0,
//output reg [7:0] B_1,
//output reg [7:0] B_2,
//output reg CE_0
    );
reg [3:0] fsm_state;
reg [15:0] red_temp;
reg [15:0] green_temp;
reg [15:0] blue_temp;

initial begin
    greyscale_value <= 0;
    greyscale_valid <= 0;
    greyscale_ready <= 0;
    fsm_state <= 0;
end
    
always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin
        greyscale_value <= 0;
        greyscale_valid <= 0;
        greyscale_ready <= 0;
        fsm_state <= 0;   
    end
    else begin
        case(fsm_state) 
        
        0: begin
            greyscale_valid <= 0;
            fsm_state <= (byte_convert_valid) ? 1:0;
            greyscale_ready <= 1;
            greyscale_value <= 0;
        end
        1: begin
            red_temp <= red * 3;
            green_temp <= green * 6;
            blue_temp <= blue;
            fsm_state <= 2;
            greyscale_ready <= 0;
        end
        2: begin
            greyscale_value <=  (red_temp + green_temp + blue_temp) / 10 ;
            greyscale_valid <= 1;
            fsm_state <= (byte_convert_valid) ? 1:0;
            greyscale_ready <= 1;
            
        end

        endcase
    
    
    end
end
    
    
    
endmodule
