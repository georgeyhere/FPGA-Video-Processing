`default_nettype none
//
//
//
module mem_wr
	#(parameter ROWLENGTH  = 640,
	  parameter BRAM_WIDTH = 12,
	  parameter BRAM_DEPTH = 307200)
	(
	input  wire                          i_clk,
	input  wire                          i_rstn,

	// 24MHz to 125MHz input FIFO
	output reg                           o_rd,
	input  wire [11:0]                   i_data,
	input  wire                          i_empty,
	input  wire [11:0]                   i_fill,

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
	reg  [9:0]  pixelcounter, nxt_pixelcounter;

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
		nxt_rd           = 0;
		nxt_wr           = 0;
		nxt_waddr        = o_waddr;
		nxt_pixelcounter = pixelcounter;
		nxt_rowcounter   = rowcounter;
		NEXT_STATE       = STATE;
		//
		case(STATE)
			

			STATE_IDLE: begin
				if(!i_empty) begin
					nxt_rd     = 1;
				    NEXT_STATE = STATE_ACTIVE;
				end
			end

			STATE_ACTIVE: begin
				nxt_rd = (!i_empty);
				nxt_wr = (!i_empty);
				nxt_waddr = (o_waddr == 307199) ? 0:o_waddr + 1;
				nxt_pixelcounter = (pixelcounter == 639) ? 0:pixelcounter+1;
				if(pixelcounter == ROWLENGTH) begin
					nxt_rowcounter = (rowcounter == 480) ? 0:rowcounter+1;
				end
				if(i_empty) begin
					NEXT_STATE = STATE_IDLE;
				end
			end
		endcase
	end

/*
	always@* begin
		nxt_rd           = 0;
		nxt_wr           = 0;
		nxt_waddr        = o_waddr;
		nxt_pixelcounter = pixelcounter;
		nxt_rowcounter   = rowcounter;
		NEXT_STATE       = STATE;

		if(!i_empty) begin
			nxt_rd = 1;
			nxt_wr = 1;
			nxt_waddr = (o_waddr == 307199) ? 0:o_waddr + 1;
			nxt_pixelcounter = (pixelcounter == ROWLENGTH) ? 0:pixelcounter+1;
			if(pixelcounter == ROWLENGTH) begin
				nxt_rowcounter = (rowcounter == 480) ? 0:rowcounter+1;
			end
		end
	end
*/

//
//
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			o_waddr      <= 0;
			o_wr         <= 0;
			o_rd         <= 0;
			pixelcounter <= 0;
			rowcounter   <= 0;
			STATE        <= STATE_IDLE;
		end
		else begin
			o_waddr      <= nxt_waddr;
			o_wr         <= nxt_wr;
			o_rd         <= nxt_rd;
			pixelcounter <= nxt_pixelcounter;
			rowcounter   <= nxt_rowcounter;
			STATE        <= NEXT_STATE;
		end
	end

endmodule