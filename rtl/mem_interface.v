`default_nettype none
//
//
module mem_interface
	#(
    parameter DATA_WIDTH = 12,
	parameter BRAM_DEPTH = 307200
	)
	(
	input wire                   i_clk,         // 125 MHz board clock
	input wire                   i_rstn,        // sync active low reset

	// preprocess module FIFO interface
	output reg                   o_rd,
	input  wire [DATA_WIDTH-1:0] i_data, 
	input  wire                  i_empty,         
 
	// Output FIFO interface
	output wire                  o_wr,          // write enable
	output wire [DATA_WIDTH-1:0] o_wdata,       // write data
	input  wire                  i_almostfull,  // almost-full flag

	// display request
	input  wire                  i_req          // asserted when display is active
	);

	reg  nxt_rd;
	reg  STATE, NEXT_STATE;
	localparam STATE_IDLE   = 0,
               STATE_ACTIVE = 1;
    initial STATE = STATE_IDLE;

	reg  [$clog2(BRAM_DEPTH)-1:0] nxt_mem_waddr, mem_waddr;
	reg                           nxt_mem_wr, mem_wr;

	wire [$clog2(BRAM_DEPTH)-1:0] mem_raddr;


// read whenever input FIFO isn't empty
	always@* begin
		nxt_rd        = 0;
		nxt_mem_wr    = 0;
		nxt_mem_waddr = mem_waddr;
		NEXT_STATE    = STATE;

		case(STATE)
			
			STATE_IDLE: begin
				if(!i_empty) begin
					nxt_rd        = 1;
					nxt_mem_wr    = 1;
					NEXT_STATE    = STATE_ACTIVE;
				end
			end

			STATE_ACTIVE: begin
				nxt_rd        = (!i_empty);
				nxt_mem_wr    = (!i_empty);
				nxt_mem_waddr = (mem_waddr == BRAM_DEPTH-1) ? 0:mem_waddr+1;
				NEXT_STATE    = (i_empty) ? STATE_IDLE : STATE_ACTIVE;
			end

		endcase
	end

// FSM sync process
//
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			o_rd      <= 0;
			mem_wr    <= 0;
			mem_waddr <= 0;
			STATE     <= STATE_IDLE;
		end
		else begin
			o_rd      <= nxt_rd;
			mem_wr    <= nxt_mem_wr;
			mem_waddr <= nxt_mem_waddr;
			STATE     <= NEXT_STATE;
		end
	end


//
// Submodule Instantiation
//	
	mem_bram
	#(.BRAM_WIDTH (DATA_WIDTH),
	  .BRAM_DEPTH (BRAM_DEPTH)
	)
	mem_bram_i (
	.i_clk        (i_clk     ),
      
	.i_waddr      (mem_waddr ), // write address
	.i_wdata      (i_data    ), // write data
	.i_wr         (mem_wr    ), // write enable
      
	.i_raddr      (mem_raddr ), // read address
	.o_rdata      (o_wdata   )  // read data
	);

	// read logic
	mem_rd 
	#(.BRAM_DEPTH (BRAM_DEPTH)
	 )
	mem_rd_i (
    .i_clk        (i_clk        ), 
    .i_rstn       (i_rstn       ), // sync active low reset
       
    .i_req        (i_req        ), // request from display module (25MHz)
    
    // 125_25 MHz FIFO interface
    .o_wr         (o_wr         ), // write enable 
    .i_almostfull (i_almostfull ), // almost-full flag
    .o_raddr      (mem_raddr    )  // bram read addr
	);

endmodule