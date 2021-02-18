`timescale 1ns / 1ps


module OV7670_config_tb();

    reg clk=0;
    reg start = 1;
    reg SCCB_interface_ready;
    reg [15:0] rom_data = 16'hFF_00;
    
    wire [7:0] rom_counter;
    wire done;
    wire [7:0] SCCB_address;
    wire [7:0] SCCB_data;
    wire SCCB_start;
    
    config_control UUT(
    .clk(clk),
    .start(start),
    .SCCB_interface_ready(SCCB_interface_ready),
    .rom_data(rom_data),
    .rom_counter(rom_counter),
    .done(done),
    .SCCB_address(SCCB_address),
    .SCCB_data(SCCB_data),
    .SCCB_start(SCCB_start)
    );
    
    always
    #20 clk = ~clk;
    
endmodule
