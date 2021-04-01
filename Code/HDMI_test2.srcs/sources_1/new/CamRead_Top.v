`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2021 07:56:29 PM
// Design Name: 
// Module Name: CamRead_Top
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


module CamRead_Top(
    input           PClk,
    input           Clk_100MHz,
    input           Reset,
    input           vsync,
    input           href,
    input [7:0]     CamDout,
    input           SystemStart,
    
    output [7:0]    Red,
    output [7:0]    Green,
    output [7:0]    Blue
    );

// ===========================================================================
// 			          Parameters, Registers, and Wires
// ===========================================================================
    wire FIFO_Full;
    wire FIFO_WrAck;
    wire [7:0] FIFO_Din;
    wire wr_en;
    wire FIFO_Empty;
    wire [7:0] FIFO_Dout;
    wire rd_en;

// ===========================================================================
// 			              Module Instantiations
// ===========================================================================    
    CamRead_Input UUTa(
    .PClk(PClk),
    .Reset(Reset),
    .vsync(vsync),
    .href(href),
    .Cam_Dout(CamDout),
    .FIFO_Full(FIFO_Full),
    .FIFO_Din(FIFO_Din),
    .wr_en(wr_en)
    );
    
    CamRead_FIFO_wrapper UUTb(
    .FIFO_READ_0_empty(FIFO_Empty),
    .FIFO_READ_0_rd_data(FIFO_Dout),
    .FIFO_READ_0_rd_en(rd_en),
    .rd_clk_0(Clk_100MHz),
    .FIFO_WRITE_0_full(FIFO_Full),
    .FIFO_WRITE_0_wr_data(FIFO_Din),
    .FIFO_WRITE_0_wr_en(wr_en),
    .wr_ack_0(FIFO_WrAck),
    .wr_clk_0(PClk)
    );
    
    CamRead_Output UUTc(
    .Clk_100MHz(Clk_100MHz),
    .PClk(PClk),
    .Reset(Reset),
    .SystemStart(SystemStart),
    .href(href),
    .FIFO_Empty(FIFO_Empty),
    .FIFO_WrAck(FIFO_WrAck),
    .FIFO_Dout(FIFO_Dout),
    .rd_en(rd_en),
    .Red(Red),
    .Green(Green),
    .Blue(Blue)
    );
    
endmodule
