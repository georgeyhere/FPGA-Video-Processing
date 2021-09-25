// module: mem_bram.v
//
// This module infers a simple dual-port block RAM with dual clocks.
// -> template from UG901
//
`default_nettype none
//
//
module mem_bram
	#(parameter BRAM_WIDTH = 12,
	  parameter BRAM_DEPTH = 16384)
	(
	input  wire                          i_wclk,
	input  wire                          i_wportEn,
	input  wire [$clog2(BRAM_DEPTH)-1:0] i_waddr,
	input  wire [BRAM_WIDTH-1:0]         i_wdata,
	input  wire                          i_wr,

	input  wire                          i_rclk,
	input  wire                          i_rportEn,
	input  wire [$clog2(BRAM_DEPTH)-1:0] i_raddr,
	output reg  [BRAM_WIDTH-1:0]         o_rdata
	);

	reg [BRAM_WIDTH-1:0] mem [0:BRAM_DEPTH];

	always@(posedge i_wclk) begin
		if(i_wportEn) begin
			if(i_wr) begin
				mem[i_waddr] <= i_wdata;
			end
		end
	end

	always@(posedge i_rclk) begin
		if(i_rportEn) begin
			o_rdata <= mem[i_raddr];
		end
	end
	
endmodule