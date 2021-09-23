module display_interface 
	(
	input  wire        i_p_clk,
	input  wire        i_tmds_clk,
	input  wire        i_rstn,
	input  wire        i_mode,

	// input FIFO interface
    input  wire        i_wclk,
    input  wire        i_wrstn,
    input  wire        i_wr,
    input  wire [11:0] i_wdata,
    output wire        o_wfull,
    output wire        o_walmostfull,
    output wire [7:0]  o_wfill,

	// Memory Data Request
	output wire        o_req,

	// TMDS out
	output wire [3:0]  o_TMDS_P,
	output wire [3:0]  o_TMDS_N
	);


// =============================================================
// 			    Parameters, Registers, and Wires
// =============================================================
	reg         nxt_ibuf_rd, ibuf_rd;
 	wire [11:0] ibuf_rdata;

	wire        vsync, hsync, active;
	wire [9:0]  counterX, counterY;
	reg  [7:0]  red, green, blue;
 
	reg  [1:0]  STATE, NEXT_STATE;
	localparam  STATE_INITIAL = 0,
	            STATE_DELAY   = 1,
	            STATE_ACTIVE  = 2;


// =============================================================
// 			          Implementation:
// =============================================================

	// request six clocks prior to SoF
	assign o_req = ((counterX == 794) && (counterY == 524) && (STATE==STATE_ACTIVE)); 

	initial begin
		ibuf_rd  = 0;
		STATE = STATE_INITIAL;
	end

	// assign rgb based on mode; rgb or greyscale
	always@* begin
		if(i_mode) begin
			red   = ibuf_rdata[11:4];
			green = ibuf_rdata[11:4];
			blue  = ibuf_rdata[11:4];
		end
		else begin
			red   = {ibuf_rdata[11:8], {4{1'b0}} };
			green = {ibuf_rdata[7:4],  {4{1'b0}} }; 
			blue  = {ibuf_rdata[3:0],  {4{1'b0}} }; 
		end
	end

	// next state combo logic
	always@* begin
		nxt_ibuf_rd     = 0;
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
				nxt_ibuf_rd = ((counterX < 640) && (counterY < 480));
			end
		endcase
	end

	// registered logic
	always@(posedge i_p_clk) begin
		if(!i_rstn) begin
			ibuf_rd  <= 0;
			STATE <= STATE_INITIAL;
		end
		else begin
			ibuf_rd  <= nxt_ibuf_rd;
			STATE <= NEXT_STATE;
		end
	end

//
//
	fifo_async
	#(.DATA_WIDTH         (12),
	  .PTR_WIDTH          (8),
	  .ALMOSTFULL_OFFSET  (9),
	  .ALMOSTEMPTY_OFFSET (2)  )
	disp_ibuf_i (
	// write interface
	.i_wclk         (i_wclk        ), // write clock
	.i_wrstn        (i_wrstn       ), // active-low async reset
	.i_wr           (i_wr          ), // write enable
	.i_wdata        (i_wdata       ), // write data
	.o_wfull        (o_wfull       ), // full flag
	.o_walmostfull  (o_walmostfull ), // almost-full flag
	.o_wfill        (o_wfill       ), // unused
 	
 	// read interface
	.i_rclk         (i_p_clk    ),    // 25 MHz display clock 
	.i_rrstn        (i_rstn     ),    // active-low async reset
	.i_rd           (ibuf_rd    ),    // read enable
	.o_rdata        (ibuf_rdata ),    // read data
	.o_rempty       (), 
	.o_ralmostempty (), 
	.o_rfill        ()  
	);

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