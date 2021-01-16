`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2021 02:20:29 PM
// Design Name: 
// Module Name: gaussian_minion
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


module gssn_minion0_input(
input clk,
input reset_n,

input [7:0] pixel_value,
input [16:0] pixel_address,  
input pixel_valid,
input minion0_select, //minion #0, address 0x0
input [10:0] minion0_target, //the row the minion will compute
input minion0_ready,
input rsta_busy_0, 

output reg minion_compute_start, //minion internal signal
output reg [7:0] BRAM_PORTA_0_din,
output reg [13:0] BRAM_PORTA_0_addr,
output reg BRAM_PORTA_0_we,
output reg [10:0] minion0_row
    );


reg [10:0] target_latch;    
reg [2:0] fsm_state;
localparam s0_default = 0;
localparam s1_assign = 1;
localparam s2_delay = 2;
localparam s3_delay = 3;

    
initial begin
    BRAM_PORTA_0_din <= 0; //resets
    BRAM_PORTA_0_addr <= 0;
    BRAM_PORTA_0_we <= 0;
    fsm_state <= s0_default;
    target_latch <= 0;
    minion_compute_start <= 0;
end
always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin
        BRAM_PORTA_0_din <= 0; //resets
        BRAM_PORTA_0_addr <= 0;
        BRAM_PORTA_0_we <= 0;
        fsm_state <= s0_default;
        target_latch <= 0;
        minion_compute_start <= 0;
    end
    else begin
        case(fsm_state) 
            s0_default: begin //enable writes if minion is selected and data is valid
                BRAM_PORTA_0_din <= ((pixel_valid == 1)&(minion0_select == 1))? BRAM_PORTA_0_din:0; 
                BRAM_PORTA_0_addr <= ((pixel_valid == 1)&(minion0_select == 1))? BRAM_PORTA_0_addr:0;
                BRAM_PORTA_0_we <= ((pixel_valid == 1)&(minion0_select == 1))? BRAM_PORTA_0_we:0;
                minion_compute_start <= 0;
                target_latch <= minion0_target;
                fsm_state <= ((pixel_valid == 1)&(minion0_select == 1))? s1_assign:s0_default;
            end
            s1_assign: begin //assign data on next clock until data is no longer valid or control moves to a different address
                BRAM_PORTA_0_din <= pixel_value;
                BRAM_PORTA_0_addr <= pixel_address;
                BRAM_PORTA_0_we <= (rsta_busy_0) ? 0:1;
                minion0_row <= target_latch;
                minion_compute_start <= 0;
                fsm_state <= ((pixel_valid == 1)&(minion0_select == 1))? s1_assign:s2_delay; //once data transmission stops, assert compute_start and wait
            end
            s2_delay: begin //just wait until the computation is done
                BRAM_PORTA_0_we <= 0;
                minion_compute_start <= 1;
                fsm_state <= (minion0_ready) ? s0_default:s3_delay;
            end
            
        endcase
    end
end
    
    
endmodule
