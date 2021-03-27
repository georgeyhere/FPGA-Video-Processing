`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2021 03:17:12 PM
// Design Name: 
// Module Name: test2_top
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
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2021 05:54:58 PM
// Design Name: 
// Module Name: test2_thrugreyscale_tb
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


module test1_top(

input clk,
input reset,
input vsync,
input href,
input pclk,
input [7:0] camera_dout,
input start_button,

output SCCB_C,
output SCCB_D,
output [7:0] greyscale_value,
output greyscale_valid
    );

wire configure_start;
wire system_start;
wire configure_done;
wire greyscale_ready;
wire rgb_valid;
wire [7:0] red;
wire [7:0] green;
wire [7:0] blue;

 
master_control UUT1(
.clk(clk),
.reset_n(reset_n),
.system_start(system_start),
.start_button(start_button),
.configure_done(configure_done),
.configure_start(configure_start),
.system_start(system_start)
);    

camera_configure UUT2(
.clk(pclk), //this one gets a 25Mhz clock
.configure_start(configure_start),
.system_start(system_start),
.reset_n(reset_n),
.sioc(SCCB_C),
.siod(SCCB_D),
.configure_done(configure_done)
);

camera_interface_top UUT3(
.clk(clk),
.reset_n(reset_n),
.system_start(system_start),
.pclk(pclk),
.href(href),
.camera_dout(camera_dout),
.greyscale_ready(greyscale_ready),
.rgb_valid(rgb_valid),
.red(red),
.green(green),
.blue(blue)
);


    
    
    
endmodule
