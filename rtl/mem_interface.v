`default_nettype none
//
//
module mem_interface
	#(
    parameter DATA_WIDTH = 12,
    parameter FILL_WIDTH = 10,
	parameter BRAM_DEPTH = 307200
	)
	(
	input wire                   i_clk,        // 125 MHz board clock
	input wire                   i_rstn,       // sync active low reset
    input wire                   i_flush,      

	// Input interface
	output reg                   o_rd,
	input  wire [DATA_WIDTH-1:0] i_rdata,
	input  wire                  i_almostempty,
 
	// Frame buffer output interface
	input  wire                  i_rclk,
	input  wire [18:0]           i_raddr,
	output wire [DATA_WIDTH-1:0] o_rdata    
	);


// =============================================================
// 			    Parameters, Registers, and Wires
// =============================================================
	
	reg         WSTATE, NEXT_WSTATE;
	localparam  WSTATE_IDLE   = 0,
                WSTATE_ACTIVE = 1;
    reg         nxt_rd;
	reg  [$clog2(BRAM_DEPTH)-1:0] nxt_mem_waddr, mem_waddr;
	reg         nxt_mem_wr, mem_wr;
	reg  [9:0]  nxt_wCounter, wCounter;
	//
	//
	reg         RSTATE, NEXT_RSTATE;
	localparam  RSTATE_IDLE   = 0,
	            RSTATE_ACTIVE = 1;
	reg         nxt3_wr, nxt2_wr, nxt_wr;
	reg  [$clog2(BRAM_DEPTH)-1:0] nxt_mem_raddr, mem_raddr;
	reg         req_q1, req_q2;


// =============================================================
// 			         Submodule Instantiation:
// =============================================================
	mem_bram
	#(.BRAM_DEPTH(BRAM_DEPTH))
	mem_bram_i (
	.i_wclk     (i_clk     ),
    .i_wportEn  (1'b1      ),  
	.i_waddr    (mem_waddr ), // write address
	.i_wdata    (i_rdata   ), // write data
	.i_wr       (mem_wr    ), // write enable
     
    .i_rclk     (i_rclk    ),
    .i_rportEn  (1'b1      ),
	.i_raddr    (i_raddr   ), // read address
	.o_rdata    (o_rdata   )  // read data
	);

// =============================================================
// 			            Implementation:
// =============================================================
	
	//---------------------------------------------------
    //                Memory Write FSM:
    //---------------------------------------------------
	initial WSTATE = WSTATE_IDLE;
	always@* begin
		nxt_rd         = 0;
		nxt_mem_wr     = 0;
		nxt_mem_waddr  = mem_waddr;
		//
		NEXT_WSTATE    = WSTATE;
		//
		case(WSTATE)

			WSTATE_IDLE: begin
				if(!i_almostempty) begin
					nxt_rd      = 1;
					nxt_mem_wr  = 1;
					NEXT_WSTATE = WSTATE_ACTIVE;
				end
			end

			WSTATE_ACTIVE: begin
				nxt_rd        = (!i_almostempty);
				nxt_mem_wr    = (!i_almostempty);
				nxt_mem_waddr = (mem_waddr == 307199) ? 0:mem_waddr+1;
				if(i_almostempty) begin
					NEXT_WSTATE = WSTATE_IDLE;
				end
			end
		endcase
	end

	always@(posedge i_clk) begin
		if(!i_rstn || i_flush) begin
			o_rd      <= 0;
			mem_wr    <= 0;
			mem_waddr <= 0;
			WSTATE    <= WSTATE_IDLE;
		end
		else begin
			o_rd      <= nxt_rd;
			mem_wr    <= nxt_mem_wr;
			mem_waddr <= nxt_mem_waddr;
			WSTATE    <= NEXT_WSTATE;
		end
	end

endmodule