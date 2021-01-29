`timescale 1ns / 1ps
//ROM containing device control register values for OV7670
//Based on code written by user wbraun on Github as well as an eevblog.com comment thread

module config_ROM(

    input clk,
    input reset_n,
    input [7:0] rom_index,
    
    output reg [15:0] dout
    );
    
initial begin
    dout <= 0;
end

always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin
        dout <= 0;
    end
    else begin
        case(rom_index)//feed the config module with register values one at a time: a lot of magic internet numbers here
    
        0: dout <= 16'h12_80; //datasheet recommends resetting the registers first thing
        1: dout <= 16'h03_0A; //VREF       vsync edge offset
        2: dout <= 16'h04_00; //COM1,     disable CCIR656
        3: dout <= 16'h11_01; //enable PLL double clock option
        4: dout <= 16'h12_04; //select rgb output
        5: dout <= 16'h17_14; //HSTART     start high 8 bits
        6: dout <= 16'h18_02; //HSTOP      stop high 8 bits //these kill the odd colored line
        7: dout <= 16'h19_03; //VSTART     start high 8 bits
        8: dout <= 16'h1A_7B; //VSTOP      stop high 8 bits
        9: dout <= 16'h6B_4A; //01001010 - input clock x4, bypass internal regulator, divide by 4 
        10: dout <= 16'h0E_61; //common control 5 - reserved - magic internet numbers
        11: dout <= 16'h0F_4B; //enable HREF at optical black, use electrical black line as BLC signal, disable digital BLC, reset all timing when format changes
        12: dout <= 16'h16_02; //RSVD - reserved - magic internet numbers
        13: dout <= 16'h1E_07; //black sun enable
        14: dout <= 16'h21_02; //ADCCTR1 - reserved - magic internet numbers
        15: dout <= 16'h22_91; //ADCCTR2 - reserved - magic internet numbers
        16: dout <= 16'h29_07; //RSVD - reserved - magic internet numbers
        17:  dout <= 16'h3a_04; //TSLB       set correct output data sequence (magic)
        18: dout <= 16'h33_0B; //CHLF Array Current Control - reserved - magic internet numbers
        19: dout <= 16'h35_0B; //RSVD - reserved - magic internet numbers
        20: dout <= 16'h37_1D; //ADC Control - reserved - magic internet numbers
        21: dout <= 16'h38_71; //ACOM ADC and Analog Common Mode Control - reserved - magic internet numbers
        22: dout <= 16'h39_2A; //ADC offset control - reserved - magic internet numbers
        23: dout <= 16'h3C_78; //COM12 - no HREF when VSYNC is low
        24: dout <= 16'h40_d0; //COM15,     RGB565, full output range
        25: dout <= 16'h4D_40; //reserved - magic internet numbers
        26: dout <= 16'h4E_20; //reserved - magic internet numbers
        27: dout <= 16'h4F_B3; //MTX1 - all of these are magical matrix coefficients
        28: dout <= 16'h50_B3; //MTX2
        29: dout <= 16'h51_00; //MTX3
        30: dout <= 16'h52_3d; //MTX4
        31: dout <= 16'h53_A7; //MTX5
        32: dout <= 16'h54_E4; //MTX6
        33: dout <= 16'h58_9E; //MTXS
        34: dout <= 16'h69_00; //GFIX Fix Gain Control - 1x gain for all channels
        //begin mystery scaling numbers
        35: dout <= 16'h70_3a;
        36: dout <= 16'h71_35;
        37: dout <= 16'h72_11;
        38: dout <= 16'h73_f0;
        39: dout <= 16'ha2_02;
        40: dout <= 16'h74_10; //REG74 - bypass digital gain manual control
        //gamma curve values
        41: dout <= 16'h7a_20;
        42: dout <= 16'h7b_10;
        43: dout <= 16'h7c_1e;
        44: dout <= 16'h7d_35;
        45: dout <= 16'h7e_5a;
        46: dout <= 16'h7f_69;
        47: dout <= 16'h80_76;
        48: dout <= 16'h81_80;
        49: dout <= 16'h82_88;
        50: dout <= 16'h83_8f;
        51: dout <= 16'h84_96;
        52: dout <= 16'h85_a3;
        53: dout <= 16'h86_af;
        54: dout <= 16'h87_c4;
        55: dout <= 16'h88_d7;
        56: dout <= 16'h89_e8;
        57: dout <= 16'h8D_4F; //reserved - magic internet numbers
        58: dout <= 16'h8E_00; //reserved - magic internet numbers
        59: dout <= 16'h8F_00; //reserved - magic internet numbers
        60: dout <= 16'h90_00; //reserved - magic internet numbers
        61: dout <= 16'h91_00; //reserved - magic internet numbers
        62: dout <= 16'h96_00; //reserved - magic internet numbers
        63: dout <= 16'h9A_00; //Histogram-based AEC/AGC control - don't care
        64: dout <= 16'hB0_84; //reserved - magic internet numbers
        65: dout <= 16'hB1_0C; //reserved - magic internet numbers
        66: dout <= 16'hB2_0E; //reserved - magic internet numbers
        67: dout <= 16'hB8_0A; //reserved - magic internet numbers
        default: dout <= 16'hFF_FF; //end of rom
        endcase
    end
end
    
    
    
endmodule
