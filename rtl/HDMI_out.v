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


module HDMI_out(
    input        i_p_clk,
    input        i_tmds_clk,
    input        i_resetn,
    
    input  [9:0] i_tmds_red,
    input  [9:0] i_tmds_green,
    input  [9:0] i_tmds_blue,
   
    
    output [3:0] o_TMDS_P,
    output [3:0] o_TMDS_N
    );
    
// ===========================================================================
//                      Parameters, Registers, and Wires
// ===========================================================================   
   
   reg [9:0] SR_tmds_red;
   reg [9:0] SR_tmds_green;
   reg [9:0] SR_tmds_blue;
   reg       shiftEnable;  
   reg [3:0] tmds_counter;    
   
// ===========================================================================
//                                Implementation
// ===========================================================================    
    initial begin
        SR_tmds_red <= 0;
        SR_tmds_green <= 0;
        SR_tmds_blue <= 0;
        shiftEnable <= 0;
        tmds_counter <= 0;
    end

    // shift registers synced to 250Mhz i_tmds_clk
    always@(posedge i_tmds_clk) begin    
        if(!i_resetn) begin
            shiftEnable <= 0;
            SR_tmds_red <= 0;
            SR_tmds_green <= 0;
            SR_tmds_blue <= 0;
            tmds_counter <= 0;
        end
        else begin
            shiftEnable <= (tmds_counter == 4'd9);  // shift after ten bits                        
            
            SR_tmds_red   <= (shiftEnable) ? i_tmds_red   : SR_tmds_red[9:1];         // shift out [0] of each SR on each clock
            SR_tmds_green <= (shiftEnable) ? i_tmds_green : SR_tmds_green[9:1];
            SR_tmds_blue  <= (shiftEnable) ? i_tmds_blue  : SR_tmds_blue[9:1];
            
            tmds_counter <= (tmds_counter == 4'd9) ? 4'd0 : tmds_counter + 1;    // count up
        end
    end
    
// ===========================================================================
//                         Differential Output Buffers
// =========================================================================== 
    OBUFDS OBUFDS_Red(
    .I    (SR_tmds_red[0]),
    .O    (o_TMDS_P[0]),
    .OB   (o_TMDS_N[0])
    );
    
    OBUFDS OBUFDS_Green(
    .I    (SR_tmds_green[0]),
    .O    (o_TMDS_P[1]),
    .OB   (o_TMDS_N[1])
    );
    
    OBUFDS OBUFDS_Blue(
    .I    (SR_tmds_blue[0]),
    .O    (o_TMDS_P[2]),
    .OB   (o_TMDS_N[2])
    );
    
    OBUFDS OBUFDS_Clk(
    .I    (i_p_clk),              
    .O    (o_TMDS_P[3]),
    .OB   (o_TMDS_N[3])
    );
    
endmodule
