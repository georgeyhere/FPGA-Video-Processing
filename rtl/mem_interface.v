`default_nettype none
//
//
//
module mem_interface
	(
	input  wire        i_clk,
	input  wire        i_rstn,

	// 24MHz to 125MHz input FIFO
	output reg         o_rd,
	input  wire [11:0] i_data,
	input  wire        i_empty,

	// 125MHz to 25MHz output FIFO
	output reg         o_wr,
	output reg  [11:0] o_data,
	input  wire        i_full
	);

	localparam BRAM_DEPTH = 307200;

	reg         empty;
	reg         nxt_rd;
	reg  [18:0] addra, nxt_addra;
	reg  [11:0] dina, nxt_dina;
	reg         wea, nxt_wea;

	reg  [18:0] addrb, nxt_addrb;
	wire [11:0] doutb;

	reg         nxt_wr;
	reg  [11:0] nxt_data;

	initial begin
		o_rd = 0;
		o_wr = 0;
	end

	always@* begin
		nxt_rd    = 0;
		nxt_dina  = dina;
		nxt_wea   = 0;
		nxt_addra = addra;
		//
		if(!i_empty) begin
			nxt_rd    = 1;
			nxt_dina  = i_data;
			nxt_wea   = 1;
			nxt_addra = (addra == (BRAM_DEPTH-1)) ? 0 : addra+1;
		end
	end

	always@* begin
		nxt_wr    = 0;
		nxt_data  = o_data;
		nxt_addrb = addrb;
		//
		if(!i_full) begin
			nxt_wr    = 1;
			nxt_data  = doutb;
			nxt_addrb = (addrb == (BRAM_DEPTH-1)) ? 0 : addrb+1;
		end
	end

	always@(posedge i_clk) begin
		if(!i_rstn) begin
			addra  <= 0;
			dina   <= 0;
			addrb  <= 0;
			o_rd   <= 0;
			o_wr   <= 0;
			o_data <= 0;
		end
		else begin
			addra  <= nxt_addra;
			dina   <= nxt_dina;
			wea    <= nxt_wea;
			addrb  <= nxt_addrb;
			o_rd   <= nxt_rd;
			o_wr   <= nxt_wr;
			o_data <= nxt_data;
		end
	end

// BRAM
//
    framebuffer fb_i (
    // write port
    .addra (addra  ),
    .clka  (i_clk  ),
    .dina  (dina   ),
    .wea   (wea    ),

    // read port
    .addrb (addrb  ),
    .clkb  (i_clk  ),
    .doutb (doutb  )
    );

endmodule