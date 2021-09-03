`default_nettype none
//
//
//
module mem_wr
	#(parameter ROWLENGTH  = 128,
	  parameter BRAM_WIDTH = 12,
	  parameter BRAM_DEPTH = 16384)
	(
	input  wire        i_clk,
	input  wire        i_rstn,

	// 24MHz to 125MHz input FIFO
	output reg         o_rd,
	input  wire [11:0] i_data,
	input  wire        i_empty,
	input  wire [9:0]  i_fill,

	// BRAM interface
	output reg  [$clog2(BRAM_DEPTH)-1:0] o_waddr,
	output wire [11:0]                   o_wdata,
	output reg                           o_wr
	);


	reg                           nxt_rd;

	reg  [$clog2(BRAM_DEPTH)-1:0] nxt_waddr;
	reg                           nxt_wr;
	reg  [11:0]                   nxt_data;

	reg  [9:0]  rowcounter, nxt_rowcounter;

	reg STATE, NEXT_STATE;
	localparam STATE_IDLE   = 0,
	           STATE_ACTIVE = 1;

//
//
	initial begin
		o_wr    = 0;
		o_waddr = 0;
		STATE   = STATE_IDLE;
	end

	assign o_wdata = i_data;

// Next State Logic
//
	always@* begin
		nxt_rd    = 0;
		nxt_wr    = 0;
		nxt_waddr = o_waddr;
		nxt_rowcounter = rowcounter;
		NEXT_STATE = STATE;
		//
		case(STATE)
			// idle state; wait for fifo to be loaded with a row of data
			STATE_IDLE: begin
				if(i_fill == ROWLENGTH-1) NEXT_STATE = STATE_ACTIVE;
				nxt_rowcounter = 0;
			end

			// active state; read from fifo and write to block ram
			STATE_ACTIVE: begin
				if(!i_empty && rowcounter <= ROWLENGTH-1) begin
					nxt_rd    = 1;
					nxt_wr    = 1;
					nxt_waddr = (o_waddr == (BRAM_DEPTH-1)) ? 0 : o_waddr+1;
					nxt_rowcounter = rowcounter + 1;
				end
				if(rowcounter >= ROWLENGTH-1) NEXT_STATE = STATE_IDLE;
			end
		endcase
	end

//
//
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			o_waddr    <= 0;
			o_wr       <= 0;
			o_rd       <= 0;
			rowcounter <= 0;
			STATE      <= STATE_IDLE;
		end
		else begin
			o_waddr    <= nxt_waddr;
			o_wr       <= nxt_wr;
			o_rd       <= nxt_rd;
			rowcounter <= nxt_rowcounter;
			STATE      <= NEXT_STATE;
		end
	end

endmodule