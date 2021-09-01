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
	output wire [BRAM_WIDTH-1:0]         o_rdata
	);

// BRAM
//
	reg [BRAM_WIDTH-1:0] mem [0:BRAM_DEPTH];

	always@(posedge i_clk) begin
		if(i_wr) mem[i_waddr] <= i_wdata;
	end

	assign o_rdata = mem[i_raddr];

endmodule