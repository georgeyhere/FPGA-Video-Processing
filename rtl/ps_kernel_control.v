//
//
//
//
//
module ps_kernel_control 
	(
	input wire        i_clk,
	input wire        i_rstn,

	input wire [7:0]  i_data,
	input wire        i_valid,
	output reg        o_ready,

	output reg [23:0] o_r0_data,
	output reg [23:0] o_r1_data,
	output reg [23:0] o_r2_data,
	output reg        o_valid
	);

//
	reg         nxt_ready;
// 
	reg  [3:0]  lineBuffer_wr; // line buffer write enables
	reg  [3:0]  lineBuffer_rd; // line buffer read enables
	wire [23:0] lineBuffer0_rdata;
	wire [23:0] lineBuffer1_rdata;
	wire [23:0] lineBuffer2_rdata;
	wire [23:0] lineBuffer3_rdata;

//
	reg  [9:0]  w_pixelCounter;   // counts pixels written to single buffer
	reg  [1:0]  w_lineBuffer_sel; // keeps track of buffer to write to
	 
 
// 
	reg  [11:0] r_fill;              // total fill level of all buffers
	reg  [9:0]  r_pixelCounter,      // counts pixels read from current buffer
	            nxt_r_pixelCounter; 
 
	reg  [8:0]  r_lineCounter,       // counts # of lines processed
	            nxt_r_lineCounter;
 
    reg         r_lineBuffer_rd_en,     // overall buffer read enable
                nxt_r_lineBuffer_rd_en; 
 
    reg  [2:0]  r_lineBuffer_sel,    // keeps track of 'target' read buffer
                nxt_r_lineBuffer_sel;
 
    reg         RSTATE, NEXT_RSTATE;
    localparam  RSTATE_IDLE   = 0,
                RSTATE_ACTIVE = 1;


//
// LINE BUFFER WRITE LOGIC
//
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			w_pixelCounter <= 0;
		end 
		else begin
			if(i_valid) begin
				w_pixelCounter <= (w_pixelCounter == 640) ? 0:w_pixelCounter+1;
			end
		end
	end

	always@(posedge i_clk) begin
		if(!i_rstn) begin
			w_lineBuffer_sel <= 0;
		end
		else begin
			if( (w_pixelCounter == 640) && (i_valid)) begin
				if(w_lineBuffer_sel == 3) begin
					w_lineBuffer_sel <= 0;
				end
				else begin
					w_lineBuffer_sel <= w_lineBuffer_sel+1;
				end
			end
		end
	end

	always@* begin
		lineBuffer_wr = 0;
		lineBuffer_wr[w_lineBuffer_sel] = i_valid;
	end

//
// LINE BUFFER READ ENABLE LOGIC 
//
	// keep track of total # of pixels in line buffers
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			r_fill <= 0;
		end
		else begin

			// write and not reading
			if(i_valid && !r_lineBuffer_rd_en) begin
				r_fill <= r_fill + 1;
			end

			// not writing and read
			else if(!i_valid && r_lineBuffer_rd_en) begin
				r_fill <= r_fill - 1;
			end
		end
	end



	// read from line buffers only when three lines are full
	always@* begin
		nxt_ready               = o_ready;
		nxt_r_lineBuffer_rd_en  = 0;
		nxt_r_pixelCounter      = r_pixelCounter;
		nxt_r_lineCounter       = r_lineCounter;
		nxt_r_lineBuffer_sel    = r_lineBuffer_sel;
		NEXT_RSTATE             = RSTATE;

		case(RSTATE)

			RSTATE_IDLE: begin
				
				if(r_fill >= 1920) begin
					nxt_ready               = 0;
					nxt_r_lineBuffer_rd_en  = 1;
					NEXT_RSTATE             = RSTATE_ACTIVE;
				end
				else begin
					nxt_ready              = 1;
					nxt_r_lineBuffer_rd_en = 0;
				end
			end

			RSTATE_ACTIVE: begin
				if(r_pixelCounter >= 639) begin
					nxt_ready               = 1;
					nxt_r_lineBuffer_rd_en  = 0;
					nxt_r_pixelCounter      = 0;
					nxt_r_lineCounter       = (r_lineCounter == 479) ?
					                          0:r_lineCounter+1;
					nxt_r_lineBuffer_sel    = (r_lineBuffer_sel == 3) ? 
					                          0:r_lineBuffer_sel+1;
					NEXT_RSTATE             = RSTATE_IDLE;
				end
				else begin
					nxt_ready              = 0;
					nxt_r_lineBuffer_rd_en = 1;
					nxt_r_pixelCounter     = r_pixelCounter + 1;
				end
			end
		endcase
	end

	always@(posedge i_clk) begin
		if(!i_rstn) begin
			o_ready            <= 0;
		 	r_lineBuffer_rd_en <= 0;
		 	r_pixelCounter     <= 0;
		 	r_lineCounter      <= 0;
		 	r_lineBuffer_sel   <= 0;
		 	RSTATE             <= RSTATE_IDLE;
		end 
		else begin
			o_ready            <= nxt_ready;
			r_lineBuffer_rd_en <= nxt_r_lineBuffer_rd_en;
			r_pixelCounter     <= nxt_r_pixelCounter;
			r_lineCounter      <= nxt_r_lineCounter;
			r_lineBuffer_sel   <= nxt_r_lineBuffer_sel;
			RSTATE             <= NEXT_RSTATE;
		end
	end

//
// LINE BUFFER READ SELECT LOGIC
//



	always@* begin
		o_valid       = r_lineBuffer_rd_en;
		lineBuffer_rd = {4{r_lineBuffer_rd_en}};
		o_r0_data     = 0;
		o_r1_data     = 0;
		o_r2_data     = 0;

		if(r_lineCounter == 0) begin
			lineBuffer_rd[2] = 0;
			lineBuffer_rd[3] = 0;
			o_r0_data        = lineBuffer0_rdata;
			o_r1_data        = lineBuffer0_rdata;
			o_r2_data        = lineBuffer1_rdata;
		end

		else begin
			case(r_lineBuffer_sel)

				0: begin
					lineBuffer_rd[2] = 0;
					o_r0_data        = lineBuffer3_rdata;
					o_r1_data        = lineBuffer0_rdata;
					o_r2_data        = lineBuffer1_rdata;
				end
	
				1: begin
					lineBuffer_rd[3] = 0;
					o_r0_data        = lineBuffer0_rdata;
					o_r1_data        = lineBuffer1_rdata;
					o_r2_data        = lineBuffer2_rdata;
				end
	
				2: begin
					lineBuffer_rd[0] = 0;
					o_r0_data        = lineBuffer1_rdata;
					o_r1_data        = lineBuffer2_rdata;
					o_r2_data        = lineBuffer3_rdata;
				end
	
				3: begin
					lineBuffer_rd[1] = 0;
					o_r0_data        = lineBuffer2_rdata;
					o_r1_data        = lineBuffer3_rdata;
					o_r2_data        = lineBuffer0_rdata;
				end
			endcase
		end
	end

//
	ps_linebuffer
	#(.LINE_LENGTH(640)) 
	LINEBUF0_i (
	.i_clk   (i_clk             ), 
	.i_rstn  (i_rstn            ), // sync active low reset
  
	.i_wr    (lineBuffer_wr[0]  ), // write enable
	.i_wdata (i_data            ), // 8-bit write data

	.i_rd    (lineBuffer_rd[0]  ), // read enable
	.o_rdata (lineBuffer0_rdata )  // 72-bit read data
	);

	ps_linebuffer
	#(.LINE_LENGTH(640)) 
	LINEBUF1_i (
	.i_clk   (i_clk             ), 
	.i_rstn  (i_rstn            ), // sync active low reset
  
	.i_wr    (lineBuffer_wr[1]  ), // write enable
	.i_wdata (i_data            ), // 8-bit write data

	.i_rd    (lineBuffer_rd[1]  ), // read enable
	.o_rdata (lineBuffer1_rdata )  // 72-bit read data
	);

	ps_linebuffer
	#(.LINE_LENGTH(640)) 
	LINEBUF2_i (
	.i_clk   (i_clk             ), 
	.i_rstn  (i_rstn            ), // sync active low reset
  
	.i_wr    (lineBuffer_wr[2]  ), // write enable
	.i_wdata (i_data            ), // 8-bit write data

	.i_rd    (lineBuffer_rd[2]  ), // read enable
	.o_rdata (lineBuffer2_rdata )  // 72-bit read data
	);

	ps_linebuffer
	#(.LINE_LENGTH(640)) 
	LINEBUF3_i (
	.i_clk   (i_clk             ), 
	.i_rstn  (i_rstn            ), // sync active low reset
  
	.i_wr    (lineBuffer_wr[3]  ), // write enable
	.i_wdata (i_data            ), // 8-bit write data

	.i_rd    (lineBuffer_rd[3]  ), // read enable
	.o_rdata (lineBuffer3_rdata )  // 72-bit read data
	);

	


endmodule