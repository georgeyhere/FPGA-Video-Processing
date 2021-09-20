`default_nettype none
//
//
//
module mem_rd 
	#(
    parameter BRAM_DEPTH = 16384
	)
	(
    input  wire                          i_clk,
    input  wire                          i_rstn,
                          
    input  wire                          i_req,

    output reg                           o_wr,
    input  wire                          i_almostfull,
    output reg  [$clog2(BRAM_DEPTH)-1:0] o_raddr
	);

	reg                          nxt_wr;
	reg [$clog2(BRAM_DEPTH)-1:0] nxt_raddr;

	reg STATE, NEXT_STATE;
	localparam STATE_IDLE   = 0,
	           STATE_ACTIVE = 1;

	initial begin
		o_wr    = 0;
		o_raddr = 0;
		STATE   = STATE_IDLE;
	end

// double flop request signal
	reg q1_req, sync_req;
	always@(posedge i_clk) begin
		if(!i_rstn) {q1_req, sync_req} <= 2'b0;
		else {q1_req, sync_req} <= {i_req, q1_req};
	end

// Next state logic
//
	always@* begin
		nxt_wr     = 0;
		nxt_raddr  = o_raddr;
		NEXT_STATE = STATE;

		case(STATE)

			STATE_IDLE: begin
				nxt_raddr  = 0;
				if(sync_req) begin
					nxt_wr     = 1;
					NEXT_STATE = STATE_ACTIVE;
				end
			end

			STATE_ACTIVE: begin
				if(!i_almostfull) begin
					nxt_raddr = ((o_raddr == BRAM_DEPTH-1) || (sync_req)) ? 0 : o_raddr+1;
					nxt_wr    = (!sync_req);
				end
				NEXT_STATE = (o_raddr == BRAM_DEPTH-1) ? STATE_IDLE : STATE_ACTIVE; 
			end
		endcase
	end

	always@(posedge i_clk) begin
		if(!i_rstn) begin
			o_wr    <= 0;
			o_raddr <= 0;
			STATE   <= STATE_IDLE;
		end
		else begin
			o_wr    <= nxt_wr;
			o_raddr <= nxt_raddr;
			STATE   <= NEXT_STATE;
		end
	end


endmodule