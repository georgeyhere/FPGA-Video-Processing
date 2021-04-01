`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2021 06:38:04 PM
// Design Name: 
// Module Name: CamRead_input
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

// CamRead_input brings in data from OV7670 camera PClk domain 
//      - handles FIFO writes
//      - synchronous to external 25Mhz PClk generated from camera

module CamRead_Input(
    input            PClk,       // 25MHz clock from OV7670, FIFO write clock
    input            Reset,      // asynchronous active high reset
    input            vsync,      // camera vsync output
    input            href,       // camera href output, see OV7670 datasheet
    input      [7:0] Cam_Dout,   // camera pixel data output
    input            FIFO_Full,  // FIFO full flag, active high
    
    output reg [7:0] FIFO_Din,   // FIFO data in 
    output reg       wr_en       // FIFO write enable
    );
    
    reg FSM_State;
    localparam s0_Idle = 1'b0;
    localparam s1_Write = 1'b1;
    
    initial begin
        FIFO_Din <= 0;
        wr_en <= 0;
    end
    
    always@(posedge PClk, posedge Reset) begin
        if(Reset == 1'b1) begin
            FSM_State <= s0_Idle;
        end
        else begin
            case(FSM_State)
            
                s0_Idle: begin 
                    FSM_State <= (!vsync) ? s1_Write : s0_Idle; // go to next state on vsync edge change
                end
                
                s1_Write: begin
                    FSM_State <= vsync ? s0_Idle : s1_Write; // go to next 
                end       
            endcase
        end
    end
    
    always@(posedge PClk, posedge Reset) begin
        if(Reset == 1'b1) begin
            FIFO_Din <= 0;
            wr_en <= 0;
        end
        else begin
            case(FSM_State)
            
                s0_Idle: begin
                    FIFO_Din <= 0;
                    wr_en <= 0;
                end
                
                s1_Write: begin
                    if(href) begin
                        FIFO_Din <= Cam_Dout;
                        wr_en <= (FIFO_Full) ? 1:0;  // Should not be possible for FIFO to be full
                    end
                    else begin
                        FIFO_Din <= FIFO_Din;
                        wr_en <= 0;
                    end
                end
            endcase
        end
    end
    
endmodule
