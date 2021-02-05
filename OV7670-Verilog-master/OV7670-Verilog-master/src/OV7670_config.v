`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2015 02:09:28 PM
// Design Name: 
// Module Name: OV7670_config
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


module OV7670_config
#(
    parameter CLK_FREQ = 25000000
)
(
    input wire clk, //25Mhz clock
    input wire reset_n,
    input wire SCCB_interface_ready,
    input wire [15:0] rom_data,
    input wire configure_start,
    output reg [7:0] rom_addr,
    output reg configure_done,
    output reg [7:0] SCCB_interface_addr,
    output reg [7:0] SCCB_interface_data,
    output reg SCCB_interface_start
    );
    
    initial begin
        rom_addr = 0;
        configure_done = 0;
        SCCB_interface_addr = 0;
        SCCB_interface_data = 0;
        SCCB_interface_start = 0;
    end
    
    localparam FSM_IDLE = 0;
    localparam FSM_SEND_CMD = 1;
    localparam FSM_DONE = 2;
    localparam FSM_TIMER = 3;
    
    reg [2:0] FSM_state = FSM_IDLE;
    reg [2:0] FSM_return_state;
    reg [31:0] timer = 0; 
    
    always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin
        rom_addr <= 0;
        configure_done <= 0;
        SCCB_interface_addr <= 0;
        SCCB_interface_data <= 0;
        SCCB_interface_start <= 0;
        FSM_state <= FSM_IDLE;
    end
        case(FSM_state)
            
            FSM_IDLE: begin 
                FSM_state <= configure_start ? FSM_SEND_CMD : FSM_IDLE;
                rom_addr <= 0;
                configure_done <= configure_start ? 0 : configure_done;
            end
            
            FSM_SEND_CMD: begin 
                case(rom_data)
                    16'hFFFF: begin //end of ROM
                        FSM_state <= FSM_DONE;
                    end
                    
                    16'hFFF0: begin //delay state 
                        timer <= (CLK_FREQ/100); //10 ms delay (1s/ 100 = 0.01s = 10 ms)
                        FSM_state <= FSM_TIMER;
                        FSM_return_state <= FSM_SEND_CMD;
                        rom_addr <= rom_addr + 1;
                    end
                    
                    default: begin //normal rom commands
                        if (SCCB_interface_ready) begin
                            FSM_state <= FSM_TIMER;
                            FSM_return_state <= FSM_SEND_CMD;
                            timer <= 0; //one cycle delay gives ready chance to deassert
                            rom_addr <= rom_addr + 1; //latch
                            SCCB_interface_addr <= rom_data[15:8]; //latch
                            SCCB_interface_data <= rom_data[7:0]; //latch
                            SCCB_interface_start <= 1;
                        end
                        else begin //added else
                            FSM_state <= FSM_SEND_CMD;
                            SCCB_interface_start <= 0;
                        end
                    end
                endcase
            end
                        
            FSM_DONE: begin //signal done 
                FSM_state <= FSM_IDLE;
                configure_done <= 1;
            end
                           
                
            FSM_TIMER: begin //count down and jump to next state
                FSM_state <= (timer == 0) ? FSM_return_state : FSM_TIMER;
                timer <= (timer==0) ? 0 : timer - 1;
                SCCB_interface_start <= 0;
            end
        endcase
    end
endmodule
