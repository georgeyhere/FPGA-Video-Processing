`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2021 12:56:11 PM
// Design Name: 
// Module Name: master_control
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
//this module controls the phases of operation of the system
//the system has two phases
//phase 1 needs to be executed at runtime 
//  phase 1 initializes the camera configuration module and disables everything else
//phase 2 is executed immediately after camera configuration
//  phase 2 is standard operation, e.g. all modules enabled

module master_control(
input wire clk, //25Mhz clock
input wire reset_n,
input wire start_button,
input wire configure_done,

output reg configure_start,
output reg system_start
    );

reg [33:0] timer_count;
reg [2:0] fsm_state;
reg [2:0] fsm_next_state;

localparam s0_timer = 0;
localparam s1_configure = 1; //two phases of operation
localparam s2_operate = 2;

initial begin
    fsm_state <= s1_configure;
    configure_start <= 0;
    system_start <= 0;
end

always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin
        fsm_state <= s1_configure;
        configure_start <= 0;
        system_start <= 0;
    end
    else begin
        case(fsm_state)
        
            s0_timer: begin
                if(timer_count == 0) begin
                    fsm_state <= fsm_next_state;
                end
                else begin
                    timer_count <= timer_count - 1;
                end
            end
            
            s1_configure: begin
                if(start_button) begin
                    configure_start <= 1;
                    fsm_state <= s0_timer;
                    timer_count <= 5; //hold the start signal for 1 clock for peace of mind
                    fsm_next_state <= s2_operate;
                end
                else begin
                    fsm_state <= s1_configure;
                end
            end
            
            s2_operate: begin
                configure_start <= 0; //we only need to configure the camera once
                system_start <= (configure_done) ? 1:0; //start signal will remain asserted until reset is asserted
            end
        
        endcase
    end
end


endmodule
