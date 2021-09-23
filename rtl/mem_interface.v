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

    // Display request
	input  wire                  i_req,        // writes entire memory on assert

	// Input FIFO read interface
	output reg                   o_rd,
	input  wire [DATA_WIDTH-1:0] i_rdata,
	input  wire                  i_almostempty,
 
	// Output FIFO interface
	output reg                   o_wr,         // write enable
	output wire [DATA_WIDTH-1:0] o_wdata,      // write data
	input  wire                  i_almostfull  // almost-full flag
	);


// =============================================================
// 			    Parameters, Registers, and Wires
// =============================================================
	
	reg         WSTATE, NEXT_WSTATE;
	localparam  WSTATE_IDLE   = 0,
                WSTATE_ACTIVE = 1;
    reg         nxt_rd;
	reg  [18:0] nxt_mem_waddr, mem_waddr;
	reg         nxt_mem_wr, mem_wr;
	reg  [9:0]  nxt_wCounter, wCounter;
	//
	//
	reg         RSTATE, NEXT_RSTATE;
	localparam  RSTATE_IDLE   = 0,
	            RSTATE_ACTIVE = 1;
	reg         nxt3_wr, nxt2_wr, nxt_wr;
	reg  [18:0] nxt_mem_raddr, mem_raddr;
	reg         req_q1, req_q2;


// =============================================================
// 			         Submodule Instantiation:
// =============================================================
	mem_bram
	#(.BRAM_DEPTH(BRAM_DEPTH))
	mem_bram_i (
	.i_clk      (i_clk     ),
      
	.i_waddr    (mem_waddr ), // write address
	.i_wdata    (i_rdata   ), // write data
	.i_wr       (mem_wr    ), // write enable
     
	.i_raddr    (mem_raddr ), // read address
	.o_rdata    (o_wdata   )  // read data
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
				nxt_mem_waddr = (mem_waddr == BRAM_DEPTH-1) ? 0:mem_waddr+1;
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

	//---------------------------------------------------
    //                Memory Read FSM:
    //---------------------------------------------------
    always@(posedge i_clk) begin
    	if(!i_rstn || i_flush) 
    		{req_q1, req_q2} <= 2'b0;
    	else        
    		{req_q1, req_q2} <= {i_req, req_q1};
    end

    initial RSTATE = RSTATE_IDLE;
    always@* begin
    	nxt2_wr       = 0;
    	nxt_mem_raddr = mem_raddr;
    	NEXT_RSTATE   = RSTATE;

    	case(RSTATE)

    		RSTATE_IDLE: begin
    			nxt_mem_raddr = 0;
    			NEXT_RSTATE   = (req_q2) ? RSTATE_ACTIVE:RSTATE_IDLE;
    		end

    		RSTATE_ACTIVE: begin
    			if(!i_almostfull) begin
    				nxt_mem_raddr = ((mem_raddr==BRAM_DEPTH-1)||(req_q2)) ? 0:mem_raddr+1;
    				nxt2_wr       = (!req_q2);
    			end
    			NEXT_RSTATE = (mem_raddr==BRAM_DEPTH-1) ? RSTATE_IDLE:RSTATE_ACTIVE;
    		end
    	endcase
    end

    always@(posedge i_clk) begin
    	if(!i_rstn || i_flush) begin
    		o_wr      <= 0;
    		nxt_wr    <= 0;
    		mem_raddr <= 0;
    		RSTATE    <= RSTATE_IDLE;
    	end
    	else begin
    		o_wr      <= nxt_wr;
    		nxt_wr    <= nxt2_wr;
    		mem_raddr <= nxt_mem_raddr;
    		RSTATE    <= NEXT_RSTATE;
    	end
    end

endmodule