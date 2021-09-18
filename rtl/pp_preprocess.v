//
//
//
//
`default_nettype none
//
`define MODE_PASSTHROUGH 0
//
module ps_preprocess 
	(
    input  wire         i_clk,
    input  wire         i_rstn,

    // Mode select
    input  wire         i_mode,   

    // Pixel Capture FIFO interface
    output reg          o_rd,
    input  wire [11:0]  i_data,
    input  wire         i_empty,
 
 	// Output FIFO interface
 	input  wire         i_rd,
    output wire [11:0]  o_data,
    output wire         o_empty      
	);

// Pixel Capture FIFO read 
	reg         din_valid, nxt_din_valid;
	reg         nxt_rd;

// greyscale signals
	wire        gs_valid;
	wire [11:0] gs_dout;

// Output FIFO
	reg         fifo_wr;
	reg  [11:0] fifo_wdata;
	wire        fifo_almostfull;


// FSM
	reg STATE, NEXT_STATE;
	localparam STATE_IDLE   = 0,
               STATE_ACTIVE = 1;
    initial STATE = STATE_IDLE;

// greyscale converter
    ps_greyscale 
	gscale_i (
	.i_clk   (i_clk     ),
	.i_rstn  (i_rstn    ),

	.i_valid (din_valid ),
	.i_data  (i_data    ),

	.o_data  (gs_dout   ),
	.o_valid (gs_valid  )
	);

// output FIFO
	fifo_sync 
	#(.DATA_WIDTH        (12),
	  .ADDR_WIDTH        (9),
	  .ALMOSTFULL_OFFSET (2),
	  .ALMOSTEMPTY_OFFSET(2))
	pp_obuf_i (
	.i_clk         (i_clk           ),
	.i_rstn        (i_rstn          ),
            
	.i_wr          (fifo_wr         ),
	.i_data        (fifo_wdata      ),
            
	.i_rd          (i_rd            ),
	.o_data        (o_data          ),

	.o_full        (),
	.o_almostfull  (fifo_almostfull ),
	.o_empty       (),
	.o_almostempty (o_empty         )
	);


// FSM next state logic for FIFO reads
//
	always@* begin
		nxt_rd        = 0;
		nxt_din_valid = 0;
		NEXT_STATE    = STATE;

		case(STATE)
			
			STATE_IDLE: begin
				if(!i_empty) begin
					nxt_rd        = 1;
					nxt_din_valid = 1;
					NEXT_STATE    = STATE_ACTIVE;
				end
			end

			STATE_ACTIVE: begin
				nxt_rd        = (!i_empty);
				nxt_din_valid = (!i_empty);
				NEXT_STATE    = (i_empty) ? STATE_IDLE : STATE_ACTIVE;
			end

		endcase
	end

// FSM sync process
//
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			o_rd      <= 0;
			din_valid <= 0;
			STATE     <= STATE_IDLE;
		end
		else begin
			o_rd      <= nxt_rd;
			din_valid <= nxt_din_valid;
			STATE     <= NEXT_STATE;
		end
	end


// write to fifo based on mode
//   
    always@* begin
    	if(i_mode == `MODE_PASSTHROUGH) begin
    		fifo_wr    = (!fifo_almostfull) ? din_valid : 0;
    		fifo_wdata = i_data;
    	end
    	else begin
    		fifo_wr    = (!fifo_almostfull) ? gs_valid : 0;
    		fifo_wdata = gs_dout;
    	end
    end


endmodule
