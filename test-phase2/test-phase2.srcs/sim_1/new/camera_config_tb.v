`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2021 11:31:29 AM
// Design Name: 
// Module Name: camera_config_tb
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


module camera_config_tb();

reg clk;
reg reset_n = 1;

reg config_start;

wire SCCB_C;
wire SCCB_D;
wire config_done;


parameter CLK_PERIOD = 40; //25 Mhz

config_top UUT (
.clk(clk),
.reset_n(reset_n),
.config_start(config_start),
.config_done(config_done),
.SCCB_C(SCCB_C),
.SCCB_D(SCCB_D)
);


always #(CLK_PERIOD/2) begin
    clk = ~clk;
end


initial begin
    clk <= 0;
    reset_n <= 1;
    config_start <= 0;
    #80;
    reset_n <= 0;
    #(2*CLK_PERIOD);
    reset_n <= 1;
    config_start <= 1; 
    #(CLK_PERIOD);
    @(config_done == 0);
        config_start <= 0;
end

endmodule




