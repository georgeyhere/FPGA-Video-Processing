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
input reset_n, //asynchronous active low reset
input byte_convert_valid, //valid for RGB from UUT1C
input [7:0] red, //RGB values from UUT1C
input [7:0] green,
input [7:0] blue,

output reg [7:0] greyscale_value, //result
output reg greyscale_valid, //result valid flag
output reg greyscale_ready //ready signal

//output reg [7:0] A_0,
//output reg [7:0] A_1,
//output reg [7:0] A_2,
//output reg [7:0] B_0,
//output reg [7:0] B_1,
//output reg [7:0] B_2,
//output reg CE_0
    );
reg [2:0] fsm_state;
localparam s0_calculate = 0;
localparam s1_assign = 1;
localparam s2_timer = 2;


reg [3:0] count;
reg [15:0] red_temp;
reg [15:0] green_temp;
reg [15:0] blue_temp;

initial begin
    greyscale_value <= 0; //resets
    greyscale_valid <= 0;
    greyscale_ready <= 0;
    fsm_state <= s0_calculate;
    count <= 0;
end
    
always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin
        greyscale_value <= 0; //resets
        greyscale_valid <= 0;
        greyscale_ready <= 0;
        fsm_state <= s0_calculate;
        count <= 0;   
    end
    else begin
        case(fsm_state) 
       
        s0_calculate: begin 
            red_temp <= red * 3;
            green_temp <= green * 6;
            blue_temp <= blue;
            fsm_state <= (byte_convert_valid) ? s1_assign:s0_calculate;
            greyscale_ready <= (byte_convert_valid) ? 0:1;
            greyscale_valid <= (byte_convert_valid) ? greyscale_valid:0; //no result, bring valid low
            
        end
        s1_assign: begin
            greyscale_value <=  (red_temp + green_temp + blue_temp) / 10 ;
            greyscale_valid <= 1;
            //fsm_state <= (byte_convert_valid) ? s1_calculate:s0_idle;
            greyscale_ready <= 1;
            fsm_state <= s2_timer;
            count <= 7;
        end
        s2_timer:begin
            count <= (count == 0) ? 0:(count-1);
            if(count == 0) fsm_state <= s0_calculate;
            else fsm_state <= s2_timer;
            
        end

        endcase
    
    
    end
end
    
    
    
endmodule
