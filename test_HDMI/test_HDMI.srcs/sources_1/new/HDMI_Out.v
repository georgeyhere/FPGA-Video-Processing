`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2021 06:14:01 PM
// Design Name: 
// Module Name: HDMI_Out
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


module HDMI_Out(
    input       PClk,
    input       TMDS_Clk,
    input       Reset,
    input [9:0] TMDS_Red,
    input [9:0] TMDS_Green,
    input [9:0] TMDS_Blue,
   
    
    output [3:0] TMDS_P,
    output [3:0] TMDS_N
    );
    
// ===========================================================================
// 			            Parameters, Registers, and Wires
// ===========================================================================   
   
   reg [9:0] SR_TMDS_Red;
   reg [9:0] SR_TMDS_Green;
   reg [9:0] SR_TMDS_Blue;
   reg       shiftEnable;  
   reg [3:0] TMDS_counter;    
   
// ===========================================================================
// 			                      Implementation
// ===========================================================================    
    initial begin
        SR_TMDS_Red <= 0;
        SR_TMDS_Green <= 0;
        SR_TMDS_Blue <= 0;
        shiftEnable <= 0;
        TMDS_counter <= 0;
    end

    always@(posedge TMDS_Clk, posedge Reset) begin    // shift registers synced to 250Mhz TMDS_Clk
        if(Reset == 1'b1) begin
            shiftEnable <= 0;
            SR_TMDS_Red <= 0;
            SR_TMDS_Green <= 0;
            SR_TMDS_Blue <= 0;
            TMDS_counter <= 0;
        end
        else begin
            shiftEnable <= (TMDS_counter == 4'd9);                              // shift after ten bits                        
            
            // these statements will use the old value of shiftEnable
            SR_TMDS_Red <= (shiftEnable) ? TMDS_Red : SR_TMDS_Red[9:1];         // shift out [0] of each SR on each clock
            SR_TMDS_Green <= (shiftEnable) ? TMDS_Green : SR_TMDS_Green[9:1];
            SR_TMDS_Blue <= (shiftEnable) ? TMDS_Blue : SR_TMDS_Blue[9:1];
            
            TMDS_counter <= (TMDS_counter==4'd9) ? 4'd0 : TMDS_counter+4'd1;    // count up
        end
    end
    
// ===========================================================================
// 			               Differential Output Buffers
// =========================================================================== 
    OBUFDS OBUFDS_Red(
    .I(SR_TMDS_Red[0]),
    .O(TMDS_P[0]),
    .OB(TMDS_N[0])
    );
    
    OBUFDS OBUFDS_Green(
    .I(SR_TMDS_Green[0]),
    .O(TMDS_P[1]),
    .OB(TMDS_N[1])
    );
    
    OBUFDS OBUFDS_Blue(
    .I(SR_TMDS_Blue[0]),
    .O(TMDS_P[2]),
    .OB(TMDS_N[2])
    );
    
    OBUFDS OBUFDS_Clk(
    .I(PClk),               // 24-bit color, TMDS_Clk = Pixel Clock
    .O(TMDS_P[3]),
    .OB(TMDS_N[3])
    );
    
endmodule
