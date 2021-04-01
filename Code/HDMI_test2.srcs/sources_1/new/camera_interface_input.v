`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2020 03:03:40 PM
// Design Name: 
// Module Name: camera_interface_input
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


module camera_interface_input(
    input             clk, //100 MHz clock
    input             reset, //asynchronous active high reset 
    input             system_start,
    input             vsync,
    input             pclk, //camera pixel clock 
    input       [7:0] camera_dout, //camera data out
    input             href, //camera output
    input             wr_rst_busy_0,

    output reg        frame_done,
    output reg        FIFO_WRITE_0_wr_en, //FIFO write 
    output reg [7:0]  FIFO_WRITE_0_wr_data
    );

// ===========================================================================
// 			          Parameters, Registers, and Wires
// ===========================================================================
    reg [0:0] fsm_state;
    localparam s0_idle = 0;
    localparam s1_row_active = 1;

// ===========================================================================
//                             Implementation    
// ===========================================================================
    initial begin
        FIFO_WRITE_0_wr_en <= 0; //resets
        FIFO_WRITE_0_wr_data <= 0;
        fsm_state <= s0_idle;
        frame_done <= 0;
    end    

    always@(posedge clk, posedge reset) begin

        if(reset == 1'b1) begin //asynchronous active low reset
            FIFO_WRITE_0_wr_en <= 0;
            FIFO_WRITE_0_wr_data <= 0;
            fsm_state <= s0_idle;
            frame_done <= 0;
        end
    
        else begin
            if(system_start == 0) fsm_state <= s0_idle; //don't do anything until system start signal is asserted
            else begin
                case(fsm_state)
    
                    s0_idle: begin
                        fsm_state <= (!vsync) ? s1_row_active:s0_idle;
                    end
        
                    s1_row_active: begin
                        fsm_state <= (vsync) ? s0_idle:s1_row_active; 
                    end
                endcase
            end
        end
    end   
    
    always@(posedge pclk) begin     // FSM only writes on positive edge of pixel clock
        case(fsm_state) 
        
            s0_idle: begin
                frame_done <= 0;
            end
            
            s1_row_active: begin
                frame_done <= (vsync) ? 1 : 0;
                case(href) //data transmission starts at href = 1
                       0: begin
                            FIFO_WRITE_0_wr_en <= 0; //don't write if camera isn't outputting data
                            FIFO_WRITE_0_wr_data <= 0; 
                       end
                       1: begin
                            FIFO_WRITE_0_wr_en <= (wr_rst_busy_0 == 1) ? 0 : 1; //write enable only on when FIFO not busy
                            FIFO_WRITE_0_wr_data <= camera_dout; //assign output data
                       end
                endcase
            end
        endcase
    end
    

 
endmodule
