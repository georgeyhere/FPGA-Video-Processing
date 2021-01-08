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

module memory_write(
input clk,
input reset_n,
input greyscale_value,
input greyscale_valid,

output reg [16:0] BRAM_PORTA_0_addr, //simple dual-port BRAM - port A is write only
output reg [7:0] BRAM_PORTA_0_din,
output reg BRAM_PORTA_0_en,
output reg BRAM_PORTA_0_we
    );

reg [16:0] address;
reg [31:0] count;    
reg [2:0] fsm_state;  
localparam s0_idle = 0;  
localparam s1_write = 1;
localparam s2_timer = 2;
reg [2:0] fsm_next_state;

initial begin
    BRAM_PORTA_0_addr <= 0;
    BRAM_PORTA_0_we <= 0;
    BRAM_PORTA_0_din <= 0;
    BRAM_PORTA_0_en <= 0;
    fsm_state <= 0;
    address <= 0;
    count <= 0;
    fsm_next_state <= 0;
end
    
always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin
        BRAM_PORTA_0_addr <= 0;
        BRAM_PORTA_0_din <= 0;
        BRAM_PORTA_0_en <= 0;
        BRAM_PORTA_0_we <= 0;
        fsm_state <= 0;
        address <= 0;
        fsm_next_state <= 0;
        count <= 0;
    end
    else begin
        case(fsm_state) 
        
            s0_idle: begin
                fsm_state <= (greyscale_valid == 1) ? s1_write:s0_idle;
                BRAM_PORTA_0_addr <= 0;
                BRAM_PORTA_0_we <= 0;
                BRAM_PORTA_0_din <= 0;
                BRAM_PORTA_0_en <= 0; 
                address <= 0;
                fsm_next_state <= 0;  
                count <= 0;
            end
            
            s1_write: begin
                BRAM_PORTA_0_en <= 1; //enable port
                BRAM_PORTA_0_we <= 1; //enable writes
                BRAM_PORTA_0_addr <= address; //write address 
                BRAM_PORTA_0_din <= greyscale_value; //write greyscale byte
                address <= (address == 122872) ? address:(address+8); 
                fsm_state <= s2_timer;
                count <= 40;
                fsm_next_state <= (address == 40) ? s0_idle:s1_write; 
            end
            
            s2_timer: begin
                count <= (count == 0) ? 0:(count - 1);
                fsm_state <= (count == 0) ? fsm_next_state:s2_timer;
            end
        
        endcase
    
    end
end

endmodule
