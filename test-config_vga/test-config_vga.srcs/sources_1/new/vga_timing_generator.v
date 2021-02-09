`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2021 02:24:54 PM
// Design Name: 
// Module Name: vga_timing_generator
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


module vga_timing_generator(
input clk,
input reset_n,

output vga_hsync,
output vga_vsync,
output reg activeArea,
output reg [9:0] xCounter, //counts number of pixels in x axis 
output reg [9:0] yCounter //counts # of columns
    );
    
reg hsync; //these registers store hsync/vsync values, will be inverted for negative logic
reg vsync;

wire Xmaxed = (xCounter == 800); //800x525
wire Ymaxed = (yCounter == 525);       

assign vga_hsync = ~hsync;
assign vga_vsync = ~vsync;

initial begin 
    hsync <= 0;
    vsync <= 0;
    xCounter <= 0;
    yCounter <= 0;
    activeArea <= 0;
end
    
always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin
        hsync <= 0;
        vsync <= 0;
        xCounter <= 0;
        yCounter <= 0;
        activeArea <= 0;
    end
    else begin
        //656 is the duration of visible area + front porch
        //752 is the duration of visible area + front porch + sync pulse
        hsync <= (xCounter > (656) && (xCounter < (752)));
        
        //490 is the duration of visible area + front porch
        //492 is the duration of visible area + front porch + sync pulse
        vsync <= (yCounter > (490) && (yCounter < (492)));
        
        activeArea <= (xCounter < 640) && (yCounter < 480); //goes high when pixels should be sent
    end
end
    
    
endmodule
