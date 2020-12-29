`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2020 08:37:23 PM
// Design Name: 
// Module Name: top_tb
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


module test_tb();

reg clk;
reg reset_n = 1;
reg pclk = 0;
reg [7:0] dout_camera;
reg href;
reg M_AXIS_RESULT_0_tready = 1;

wire [31:0] M_AXIS_RESULT_0_tdata;
wire M_AXIS_RESULT_0_tvalid;

parameter CLK_PERIOD = 8; //~125 Mhz
parameter PCLK_PERIOD = 40; //~24 Mhz

test_top UUT (
.clk(clk),
.reset_n(reset_n),
.pclk(pclk),
.dout_camera(dout_camera),
.href(href),
.M_AXIS_RESULT_0_tdata(M_AXIS_RESULT_0_tdata),
.M_AXIS_RESULT_0_tvalid(M_AXIS_RESULT_0_tvalid)
);

always #(CLK_PERIOD/2) begin
    clk = ~clk;
end

always #(PCLK_PERIOD/2) begin
    pclk = ~pclk;
end

initial begin
    
    clk = 0;
    href = 0;
    dout_camera = 8'b0;
    reset_n = 0;
    #80;
    reset_n = 1;
    #360;
    
    @(negedge pclk);
    dout_camera = 8'b00001111; 
    href = 1; 
    
    @(negedge pclk);
        dout_camera = 8'b11110000; //1
        
    @(negedge pclk);
        dout_camera = 8'b11100010; 
        
    @(negedge pclk);
        dout_camera = 8'b11110100; //2
    
    @(negedge pclk);
        dout_camera = 8'b00110110;
    
    @(negedge pclk);
        dout_camera = 8'b10101010; //3
        
    @(negedge pclk);
        dout_camera = 8'b00000001;
        
    @(negedge pclk);
        dout_camera = 8'b00001001; //4
        
    @(negedge pclk);
        dout_camera = 8'b10000100;
        
    @(negedge pclk);
        dout_camera = 8'b01101110; //5
        
    @(negedge pclk);
        dout_camera = 8'b01010100;
        
    @(negedge pclk);    
        dout_camera = 8'b10000000; //6
        
    @(negedge pclk);
        href = 0;
        dout_camera = 8'b0;
    #120;
    @(negedge pclk);
    dout_camera = 8'b00001111; 
    href = 1; 
    
    @(negedge pclk);
        dout_camera = 8'b11110000; //1
        
    @(negedge pclk);
        dout_camera = 8'b11100010; 
        
    @(negedge pclk);
        dout_camera = 8'b11110100; //2
    
    @(negedge pclk);
        dout_camera = 8'b00110110;
    
    @(negedge pclk);
        dout_camera = 8'b10101010; //3
        
    @(negedge pclk);
        dout_camera = 8'b00000001;
        
    @(negedge pclk);
        dout_camera = 8'b00001001; //4
        
    @(negedge pclk);
        dout_camera = 8'b10000100;
        
    @(negedge pclk);
        dout_camera = 8'b01101110; //5
        
    @(negedge pclk);
        dout_camera = 8'b01010100;
        
    @(negedge pclk);    
        dout_camera = 8'b10000000; //6
        
    @(negedge pclk);
        href = 0;
        dout_camera = 8'b0;    
    
        
end
    //dout_camera <= 8'b11110100;
    //#20 href = 0; dout_camera = 8'b11110000; 
    //#20 href = 1; dout_camera = 8'b11110100; 
//end
    
endmodule