`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2021 10:13:58 AM
// Design Name: 
// Module Name: HDMI_TX
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


module HDMI_encode(
    input        i_p_clk,
    input        i_resetn,

    // 8-bit RGB in
    input  [7:0] i_red,
    input  [7:0] i_green,
    input  [7:0] i_blue,

    // timing signals
    input        i_vsync,
    input        i_hsync,
    input        i_active_area,     
    
    // 10-bit TMDS-encoded RGB out
    output [9:0] o_tmds_red,
    output [9:0] o_tmds_green,
    output [9:0] o_tmds_blue
    );
    
//
//
//

    // Channel 0, i_red and Timing
    // -> timing signals encoded only on channel 0
    TMDS_encoder2 TMDS_CH0(     
        .clk      (i_p_clk            ),
        .Reset    (~i_resetn          ),
        .de       (i_active_area      ),
        .ctrl     ({i_vsync,i_hsync}  ),       
        .din      (i_red              ),
        .dout     (o_tmds_red         )
    );
    
    // Channel 1, i_green
    TMDS_encoder2 TMDS_CH1(    
        .clk      (i_p_clk            ),
        .Reset    (~i_resetn          ),
        .de       (i_active_area      ),
        .ctrl     (2'b0               ),
        .din      (i_green            ),
        .dout     (o_tmds_green       )
    );
    
    // Channel 2, i_blue
    TMDS_encoder2 TMDS_CH2(    
        .clk      (i_p_clk            ),
        .Reset    (~i_resetn          ),
        .de       (i_active_area      ),
        .ctrl     (2'b0               ),
        .din      (i_blue             ),
        .dout     (o_tmds_blue        )
    );
    
endmodule
