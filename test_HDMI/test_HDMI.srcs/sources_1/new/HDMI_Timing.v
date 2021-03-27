`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2021 07:31:03 PM
// Design Name: 
// Module Name: HDMI_Timing
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


module HDMI_Timing(
    input            PClk,
    input            Reset,
    
    output reg [7:0] Red,
    output reg [7:0] Green,
    output reg [7:0] Blue,
    output reg       vsync,
    output reg       hsync,
    output reg       activeArea
    );
    
// ===========================================================================
// 			             Parameters, Registers, and Wires
// ===========================================================================     
    reg [9:0] CounterX;
    reg [9:0] CounterY;
    
    
// ===========================================================================
//                              Implementation    
// ===========================================================================
    // horizonal counter
    always@(posedge PClk, posedge Reset) begin
        if(Reset == 1'b1) begin
            CounterX <= 0;
        end
        else begin
            CounterX <= (CounterX == 10'd799) ?  0:(CounterX + 1);
        end
    end
    
    // vertical counter
    always@(posedge PClk, posedge Reset) begin
        if(Reset == 1'b1) begin
            CounterY <= 0;
        end
        else begin
            if(CounterX==799) 
                CounterY <= (CounterY == 524) ? 0:(CounterY + 1);
            else 
                CounterY <= CounterY;
        end
    end
    
    // activeArea, hsync, vsync
    always@(posedge PClk, posedge Reset) begin
        if(Reset == 1'b1) begin
            activeArea <= 0;
            hsync <= 0;
            vsync <= 0;
        end
        else begin
            activeArea <= (CounterX < 640 ) && (CounterY < 480);
            hsync <= (CounterX >= 656) && (CounterX < 752);
            vsync <= (CounterY >= 490) && (CounterY < 492);
        end
    end
    
    // Test pattern
    wire [7:0] W = {8{CounterX[7:0]==CounterY[7:0]}};
    wire [7:0] A = {8{CounterX[7:5]==3'h2 && CounterY[7:5]==3'h2}};
    always @(posedge PClk) Red <= ({CounterX[5:0] & {6{CounterY[4:3]==~CounterX[4:3]}}, 2'b00} | W) & ~A;
    always @(posedge PClk) Green <= (CounterX[7:0] & {8{CounterY[6]}} | W) & ~A;
    always @(posedge PClk) Blue <= CounterY[7:0] | W | A; 
    
endmodule
