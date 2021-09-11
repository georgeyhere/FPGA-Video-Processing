module display_interface 
	(
	input  wire        i_p_clk,
	input  wire        i_tmds_clk,
	input  wire        i_rstn,

	// FIFO read interface
	output reg         o_rd,
	input  wire [11:0] i_rgb,   // {red, green, blue}
	input  wire        i_empty,

	// Memory Data Request
	output wire        o_req,

	// TMDS out
	output wire [3:0]  o_TMDS_P,
	output wire [3:0]  o_TMDS_N
	);

	reg        nxt_rd;

	wire       vsync, hsync, active;
	wire [9:0] counterX, counterY;
	reg [7:0] red, green, blue;

	reg  [1:0] STATE, NEXT_STATE;
	localparam STATE_INITIAL = 0,
	           STATE_DELAY   = 1,
	           STATE_ACTIVE  = 2;


	// request six clocks prior to SoF
	assign o_req = ((counterX == 794) && (counterY == 524) && (STATE==STATE_ACTIVE)); 

	initial begin
		o_rd  = 0;
		STATE = STATE_INITIAL;
	end

	always@(posedge i_p_clk) begin
		if(!i_rstn) begin
			red   <= 0;
			green <= 0;
			blue  <= 0;
		end
		else begin
			if(active) begin
				red   <= {i_rgb[11:8], {4{1'b0}} };
				green <= {i_rgb[7:4],  {4{1'b0}} }; 
				blue  <= {i_rgb[3:0],  {4{1'b0}} }; 
			end
		end
	end

	always@* begin
		nxt_rd     = 0;
		NEXT_STATE = STATE;
		case(STATE)

			// wait 2 frames for camera configuration on reset/startup
			STATE_INITIAL: begin
				NEXT_STATE = ((counterX == 640) && (counterY == 480)) ? STATE_DELAY:STATE_INITIAL;
			end

			STATE_DELAY: begin
				NEXT_STATE = ((counterX == 640) && (counterY == 480)) ? STATE_ACTIVE:STATE_DELAY;
			end

			// normal operation: begin reading from FIFO at start of frame
			STATE_ACTIVE: begin

				// active part of frame
				if((counterY == 524 || counterY < 480) && (!i_empty)) begin
				
					// read prior to SoF
					if((counterX == 799) && (counterY == 524))
						nxt_rd = 1;

					// read 1 clock prior to SoR
					else if((counterX == 799) && (counterY < 480))
						nxt_rd = 1;

					// stop reading 1 clock prior to EoR
					else if((counterX >= 639) && (counterY < 480))
						nxt_rd = 0;

					// read during active region
					else if(active)
						nxt_rd = 1; 
				end

				// empty the fifo during vertical blanking period
				else begin
					nxt_rd = (!i_empty);
				end
			end

			default: begin
				NEXT_STATE = STATE;
			end
		endcase
	end

	always@(posedge i_p_clk) begin
		if(!i_rstn) begin
			o_rd  <= 0;
			STATE <= STATE_DELAY;
		end
		else begin
			o_rd  <= nxt_rd;
			STATE <= NEXT_STATE;
		end
	end

//
//
	vtc #(
	.COUNTER_WIDTH(10)
	)
	vtc_i (
	.i_clk         (i_p_clk  ), // pixel clock
	.i_rstn        (i_rstn   ), 

	// timing signals
	.o_vsync       (vsync    ),
	.o_hsync       (hsync    ),
	.o_active      (active   ),

	// counter passthrough
	.o_counterX    (counterX ),
	.o_counterY    (counterY )
	);

	HDMI_top HDMI_i (
	.i_p_clk       (i_p_clk    ), // pixel clock
	.i_tmds_clk    (i_tmds_clk ), // 10x pixel clock
	.i_resetn      (i_rstn     ),

	.i_red         (red        ),
	.i_green       (green      ),
	.i_blue        (blue       ),

	// Timing Signals in; from VTC
	.i_vsync       (vsync      ),
	.i_hsync       (hsync      ),
	.i_active_area (active     ),

	// HDMI TMDS out
	.o_TMDS_P      (o_TMDS_P   ),
	.o_TMDS_N      (o_TMDS_N   )
	);

endmodule