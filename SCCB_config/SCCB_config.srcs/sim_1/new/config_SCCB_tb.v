`timescale 1ns / 1ns



module SCCB_tb();
    reg clk = 0;
      
    reg [7:0] address;
    reg [7:0] data;
    reg start = 1;
    wire ready;
    
    wire SCCB_C;
    wire SCCB_D;
    
    config_SCCB UUT (
    .clk(clk),
    .address(address),
    .data(data),
    .start(start),
    .ready(ready),
    .SCCB_C(SCCB_C),
    .SCCB_D(SCCB_D)
    );
    
    always
    #20 clk=~clk;
                
endmodule
