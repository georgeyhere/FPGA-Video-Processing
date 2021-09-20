// module: ps_gaussian_top
//
// Wraps ps_kernel_control and ps_gaussian.
//
// Contains passthrough logic for when gaussian filter is disabled.
//
module ps_gaussian_top 
	(
	input  wire        i_clk,    // input clock
	input  wire        i_rstn,   // active low sync reset
	input  wire        i_enable, // filter enable
	input  wire        i_flush,
 
	input  wire [11:0] i_data,   // input data, RGB444 or greyscale[11:4]
	input  wire        i_empty, 
	output reg         o_rd,     // 

	output reg  [11:0] o_data,   // 12-bit for passthrough, gaussian is [7:0]
	output reg         o_valid   // output valid flag
	);

	wire [23:0] r0_data, r1_data, r2_data;
	wire        valid;
	wire        req;
	wire [7:0]  gaussian_dout;
	wire        gaussian_valid;

	reg         nxt_rd;
	reg         nxt_din_valid, din_valid;

	reg         STATE, NEXT_STATE;
	localparam  STATE_IDLE   = 0,
	            STATE_ACTIVE = 1;


// FSM next state logic for FIFO reads
//
	always@* begin
		nxt_rd        = 0;
		nxt_din_valid = 0;
		NEXT_STATE    = STATE;

		case(STATE)
			
			STATE_IDLE: begin
				case(i_enable)
					0: begin
						if(!i_empty) begin
							nxt_rd        = 1;
							nxt_din_valid = 1;
							NEXT_STATE    = STATE_ACTIVE;
						end
					end

					1: begin
						if(!i_empty && req) begin
							nxt_rd        = 1;
							nxt_din_valid = 1;
							NEXT_STATE    = STATE_ACTIVE;
						end
					end
				endcase	
			end

			STATE_ACTIVE: begin
				case(i_enable)
					0: begin
						nxt_rd        = (!i_empty);
						nxt_din_valid = (!i_empty);
						NEXT_STATE    = (i_empty) ? STATE_IDLE : STATE_ACTIVE;
					end

					1: begin
						nxt_rd        = (!i_empty && req);
						nxt_din_valid = (!i_empty && req);
						NEXT_STATE    = (i_empty || !req) ? STATE_IDLE : STATE_ACTIVE;
					end
				endcase
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





	// passthrough logic
	always@* begin
		if(i_enable) begin
			o_data  = {gaussian_dout, 4'b0};
			o_valid = gaussian_valid;
		end
		else begin
			o_data  = i_data;
			o_valid = din_valid;
		end
	end

	ps_kernel_control 
	gaus_ctrl_i (
	.i_clk     (i_clk              ),
	.i_rstn    (i_rstn&&(~i_flush) ),
  
	.i_data    (i_data[11:4]       ),
	.i_valid   (din_valid          ),
	.o_req     (req                ),
      
	.o_r0_data (r0_data            ),
	.o_r1_data (r1_data            ),
	.o_r2_data (r2_data            ),
	.o_valid   (valid              )
	);

	ps_gaussian 
	gaus_i (
	.i_clk     (i_clk              ),
	.i_rstn    (i_rstn&&(~i_flush) ),

	.i_r0_data (r0_data            ),
	.i_r1_data (r1_data            ),
	.i_r2_data (r2_data            ),
	.i_valid   (valid              ),
    
	.o_data    (gaussian_dout      ),
	.o_valid   (gaussian_valid     )
	);

endmodule