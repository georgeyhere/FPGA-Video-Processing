`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2021 07:47:01 PM
// Design Name: 
// Module Name: gaussian_read
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


module gaussian_read(
input clk,
input reset_n,
input greyscale_valid,
input vsync,
input gaussian_filter_ready,

output reg [16:0] BRAM_PORTB_0_addr,
output reg BRAM_PORTB_0_en
    );

reg [17:0] address;    
reg [2:0] fsm_state;
localparam s0_idle = 0;
localparam s1_read = 1;
localparam s2_timer = 2;
    
initial begin
    BRAM_PORTB_0_addr <= 0; //resets
    BRAM_PORTB_0_en <= 0;
    fsm_state <= 0;
end    
    
always@(posedge clk, negedge reset_n) begin
    if(reset_n = 1'b0) begin
        BRAM_PORTB_0_addr <= 0; //resets
        BRAM_PORTB_0_en <= 0;
        fsm_state <= 0;
    end
    else begin
        case(fsm_state)
            
            s0_idle: begin
                fsm_state <= (greyscale_valid & gaussian_filter_ready) ? s4_timer:s0_idle; //state transition at
                count <= 40;
                BRAM_PORTB_0_addr <= 0; //resets
                BRAM_PORTB_0_en <= 0;
                address <= 0;
                fsm_next_state <= s1_read;
            end
            
            s1_read: begin
                BRAM_PORTB_0_addr <= address;
                address <= (address == 122872) ? address:(address+8);
                BRAM_PORTB_0_en <= 1;
                fsm_state <= (greyscale_valid == 0) ? s0_idle:s1_read;
            end
            
            s2_timer: begin
                count <= (count == 0) ? 0:(count -1);
                fsm_state <= (count == 0) ? fsm_next_state:s4_timer;
            end
            
        endcase
    end
end    
    
    
endmodule
