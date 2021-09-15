// module: mem_bram.v
//
// This module infers a simple common-clock dual-port block RAM.
// -> template from UG901
//
`default_nettype none
//
//
module mem_bram
	#(parameter BRAM_WIDTH = 12,
	  parameter BRAM_DEPTH = 16384)
	(
	input  wire                          i_clk,
	input  wire [$clog2(BRAM_DEPTH)-1:0] i_waddr,
	input  wire [BRAM_WIDTH-1:0]         i_wdata,
	input  wire                          i_wr,

	input  wire [$clog2(BRAM_DEPTH)-1:0] i_raddr,
	output reg  [BRAM_WIDTH-1:0]         o_rdata
	);

	reg [BRAM_WIDTH-1:0] mem [0:BRAM_DEPTH];
	reg [BRAM_WIDTH-1:0] dout;

	always@(posedge i_clk) begin
		if(i_wr) mem[i_waddr] <= i_wdata;
	end

	always@(posedge i_clk) begin
		dout <= mem[i_raddr];
	end

	// output register
	always@(posedge i_clk) begin
		o_rdata <= dout;
	end

endmodule