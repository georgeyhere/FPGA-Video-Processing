// module: cfg_rom.v
//
// Contains camera configuration. 1 cycle read delay.
// Register values from: 
// -> https://github.com/westonb/OV7670-Verilog/blob/master/src/OV7670_config_rom.v
//     - edited for RGB444 instead of RGB565
//
// Key takeaway is that OV7670 is configured to RGB444 output
// data frame format:  1)  { x, x, x, x, R[0], R[1], R[2], R[3] }
//                     2)  {G[0], G[1], G[2], G[3], B[0], B[1], B[2], B[3]}
`default_nettype none
//
module cfg_rom 
	(
	input  wire        i_clk,
	input  wire        i_rstn,

	input  wire [7:0]  i_addr,
	output reg  [15:0] o_data
	);

	always@(posedge i_clk) begin
		if(!i_rstn) o_data <= 0;
		else begin
			case(i_addr)
				0:  o_data <= 16'h12_80; // reset     
                1:  o_data <= 16'hFF_F0; // delay     1ms, hardcoded in camera_interface
                2:  o_data <= 16'h12_04; // COM7,     set RGB color output
                3:  o_data <= 16'h11_00; // CLKRC     PLL 1x multiplier
                4:  o_data <= 16'h0C_00; // COM3,     default settings
                5:  o_data <= 16'h3E_00; // COM14,    no scaling, normal pclock
                6:  o_data <= 16'h04_00; // COM1,     disable CCIR656
                7:  o_data <= 16'h8c_02; // RGB444,   RGB444, {xR} {GB} sequence
                8:  o_data <= 16'h40_d0; // COM15,    RGB444, full output range
                9:  o_data <= 16'h3a_04; // TSLB      set correct output data sequence (magic)
                10: o_data <= 16'h14_18; // COM9      MAX AGC value x4
                11: o_data <= 16'h4F_B3; // MTX1      all of these are magical matrix coefficients
                12: o_data <= 16'h50_B3; // MTX2
                13: o_data <= 16'h51_00; // MTX3
                14: o_data <= 16'h52_3d; // MTX4
                15: o_data <= 16'h53_A7; // MTX5
                16: o_data <= 16'h54_E4; // MTX6
                17: o_data <= 16'h58_9E; // MTXS
                18: o_data <= 16'h3D_C0; // COM13     sets gamma enable, does not preserve reserved bits, may be wrong?
                19: o_data <= 16'h17_14; // HSTART    start high 8 bits
                20: o_data <= 16'h18_02; // HSTOP     stop high 8 bits //these kill the odd colored line
                21: o_data <= 16'h32_80; // HREF      edge offset
                22: o_data <= 16'h19_03; // VSTART    start high 8 bits
                23: o_data <= 16'h1A_7B; // VSTOP     stop high 8 bits
                24: o_data <= 16'h03_0A; // VREF      vsync edge offset
                25: o_data <= 16'h0F_41; // COM6      reset timings
                26: o_data <= 16'h1E_00; // MVFP      disable mirror / flip //might have magic value of 03
                27: o_data <= 16'h33_0B; // CHLF      //magic value from the internet
                28: o_data <= 16'h3C_78; // COM12     no HREF when VSYNC low
                29: o_data <= 16'h69_00; // GFIX      fix gain control
                30: o_data <= 16'h74_00; // REG74     Digital gain control
                31: o_data <= 16'hB0_84; // RSVD      magic value from the internet *required* for good color
                32: o_data <= 16'hB1_0c; // ABLC1
                33: o_data <= 16'hB2_0e; // RSVD      more magic internet values
                34: o_data <= 16'hB3_80; // THL_ST
                //begin mystery scaling numbers
                35: o_data <= 16'h70_3a; // SCALING_XSC
                36: o_data <= 16'h71_35; // SCALING_YSC
                37: o_data <= 16'h72_11; // SCALING_DCWCTR
                38: o_data <= 16'h73_f0; // SCALING_PCLK_DIV
                //gamma curve values
                39: o_data <= 16'ha2_02; // SCALING_PCLK_DELAY
                40: o_data <= 16'h7a_20; // SLOP
                41: o_data <= 16'h7b_10; // GAM1
                42: o_data <= 16'h7c_1e; // GAM2
                43: o_data <= 16'h7d_35; // GAM3
                44: o_data <= 16'h7e_5a; // GAM4
                45: o_data <= 16'h7f_69; // GAM5
                46: o_data <= 16'h80_76; // GAM6
                47: o_data <= 16'h81_80; // GAM7
                48: o_data <= 16'h82_88; // GAM8
                49: o_data <= 16'h83_8f; // GAM9
                50: o_data <= 16'h84_96; // GAM10
                51: o_data <= 16'h85_a3; // GAM11
                52: o_data <= 16'h86_af; // GAM12
                53: o_data <= 16'h87_c4; // GAM13
                54: o_data <= 16'h88_d7; // GAM14
                //AGC and AEC
                55: o_data <= 16'h89_e8;
                56: o_data <= 16'h13_e0; // COM8, disable AGC / AEC
                57: o_data <= 16'h00_00; // set gain reg to 0 for AGC
                58: o_data <= 16'h10_00; // set ARCJ reg to 0
                59: o_data <= 16'h0d_40; // magic reserved bit for COM4
                60: o_data <= 16'h14_18; // COM9, 4x gain + magic bit
                61: o_data <= 16'ha5_05; // BD50MAX
                62: o_data <= 16'hab_07; // DB60MAX
                63: o_data <= 16'h24_95; // AGC upper limit
                64: o_data <= 16'h25_33; // AGC lower limit
                65: o_data <= 16'h26_e3; // AGC/AEC fast mode op region
                66: o_data <= 16'h9f_78; // HAECC1
                67: o_data <= 16'ha0_68; // HAECC2
                68: o_data <= 16'ha1_03; // magic
                69: o_data <= 16'ha6_d8; // HAECC3
                70: o_data <= 16'ha7_d8; // HAECC4
                71: o_data <= 16'ha8_f0; // HAECC5
                72: o_data <= 16'ha9_90; // HAECC6
                73: o_data <= 16'haa_94; // HAECC7
                74: o_data <= 16'h13_a7; // COM8, enable AGC / AEC
                75: o_data <= 16'h1E_23; // mirror image
                //76: o_data <= 16'h70_80; // test pattern enable x
                //77: o_data <= 16'h71_FF; // test pattern enable y
                76: o_data <= 16'h69_06;
                default: o_data <= 16'hFF_FF;  //mark end of ROM
			endcase
		end
	end


endmodule