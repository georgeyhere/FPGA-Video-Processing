`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2021 08:08:56 PM
// Design Name: 
// Module Name: The_Top
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


module The_Top(
    input           Clk_100MHz,
    input           Reset,
    input           StartButton,
    
    input           PClk,
    input           href,
    input           vsync,
    input [7:0]     CamDout,
    
    output          xclk,
    output          camResetn,
    output          camPwdn,
    output          sioc,
    output          siod,
    output [7:0]    Red,
    output [7:0]    Green,
    output [7:0]    Blue
    );
    
    wire ConfigureDone;
    wire ConfigureStart;
    wire SystemStart;
    
    MasterControl UUT1(
    .Clk(Clk_100MHz),
    .Reset(Reset),
    .StartButton(StartButton),
    .ConfigureDone(ConfigureDone),
    .camResetn(camResetn),
    .camPwdn(camPwdn),
    .ConfigureStart(ConfigureStart),
    .SystemStart(SystemStart)
    );
    
    CamConfigure_Top UUT2(
    .SCCB_Clk(SCCB_Clk),
    .reset(Reset),
    .ConfigureStart(ConfigureStart),
    .sioc(sioc),
    .siod(siod),
    .ConfigureDone(ConfigureDone)
    );
    
    CamRead_Top UUT3(
    .PClk(PClk),
    .Clk_100MHz(Clk_100MHz),
    .Reset(Reset),
    .vsync(vsync),
    .href(href),
    .CamDout(CamDout),
    .SystemStart(SystemStart),
    .Red(Red),
    .Green(Green),
    .Blue(Blue)
    );
    
endmodule
