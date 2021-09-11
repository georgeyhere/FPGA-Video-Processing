// capture.v
//
// This module captures incoming pixel data and is synchronous to the
// 24 MHz clock generated by the XCLK pin of the OV7670 camera.
//
// The OV7670 outputs 30FPS in VGA.
//
module capture 
	(
	input  wire        i_pclk,  // 24 MHz; sourced from OV7670 camera
	//input  wire        i_xclk,  // 24 MHz; sourced from clocking wizard
	input  wire        i_rstn,  // synchronous active low reset

	// OV7670 camera interface
	input  wire        i_vsync, // active-high, indicates start of frame
	input  wire        i_href,  // active-high, indicates row data transmission
	input  wire [7:0]  i_data,  // pixel data from camera
 
	// FIFO write interface
	output reg         o_wr,    // fifo write enable
	output reg  [11:0] o_wdata, // fifo write data; {red, green, blue}
	input  wire        i_full   // fifo full flag
	);

	reg        nxt_wr;
	reg [11:0] nxt_wdata;
	reg [7:0]  byte1_data, nxt_byte1_data;

	reg        pixel_half, nxt_pixel_half;

	reg [4:0]  framecounter, nxt_framecounter;

	reg [1:0]  STATE, NEXT_STATE;
	localparam STATE_IDLE   = 0,
	           STATE_ACTIVE = 1,
	           STATE_DBG    = 2;


// **** Next State Logic ****
//
	always@* begin
		nxt_wr           = 0;
		nxt_wdata        = o_wdata;
		nxt_byte1_data   = byte1_data;
		nxt_pixel_half   = pixel_half;

		nxt_framecounter = framecounter;

		NEXT_STATE       = STATE;

		case(STATE)

			// camera not outputting 
			STATE_IDLE: begin
				nxt_wr         = 0;
				nxt_pixel_half = 0;
				// nxt_framecounter = 0;
				NEXT_STATE = (!i_vsync) ? STATE_ACTIVE : STATE_IDLE;
			end

			// camera outputting display data
			STATE_ACTIVE: begin
				if(i_href) begin
					nxt_pixel_half = ~nxt_pixel_half;

					// RGB444: Second Byte (green, blue)
					if(pixel_half) begin
						nxt_wr         = 1;
						nxt_wdata      = {byte1_data[3:0], i_data};
						// nxt_wdata = {byte1_data[7:4], byte1_data[2:0], i_data[7], i_data[4:1]};
					end

					// RGB444: First Byte (red)
					else begin
						nxt_wr              = 0;
						nxt_byte1_data[3:0] = i_data[3:0];
						// nxt_byte1_data = i_data;
					end          
				end
				if(i_vsync) begin
					nxt_framecounter = framecounter + 1;
					//NEXT_STATE = (framecounter == 0) ? STATE_DBG : STATE_IDLE;
				end
				NEXT_STATE = (i_vsync) ? STATE_IDLE : STATE_ACTIVE;
			end

			STATE_DBG: begin
				nxt_wr = 0;
			end

		endcase
	end

	always@(posedge i_pclk) begin
		if(!i_rstn) begin
			o_wr         <= 0;
			o_wdata      <= 0;
			byte1_data   <= 0;
			pixel_half   <= 0;
			framecounter <= 0;
			STATE        <= STATE_IDLE;
		end
		else begin
			o_wr         <= nxt_wr;
			o_wdata      <= nxt_wdata;
			byte1_data   <= nxt_byte1_data;
			pixel_half   <= nxt_pixel_half;
			framecounter <= nxt_framecounter;
			STATE        <= NEXT_STATE;
		end
	end

endmodule