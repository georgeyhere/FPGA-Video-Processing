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
 
	input  wire [11:0] i_data,   // input data, RGB444 or greyscale[11:4]
	input  wire        i_valid,  // input valid flag
	output wire        o_req,    // request flag; asserted when ready for more data

	output reg  [11:0] o_data,   // 12-bit for passthrough, gaussian is [7:0]
	output reg         o_valid   // output valid flag
	);

	wire [23:0] r0_data, r1_data, r2_data;
	wire        valid;
	wire [7:0]  gaussian_dout;
	wire        gaussian_valid;

	// passthrough logic
	always@* begin
		if(i_enable) begin
			o_data  = {4'b0, gaussian_dout};
			o_valid = gaussian_valid;
		end
		else begin
			o_data  = i_data;
			o_valid = i_valid;
		end
	end

	ps_kernel_control 
	gaus_ctrl_i (
	.i_clk     (i_clk        ),
	.i_rstn    (i_rstn       ),
  
	.i_data    (i_data[11:4] ),
	.i_valid   (i_valid      ),
	.o_req     (o_req        ),

	.o_r0_data (r0_data      ),
	.o_r1_data (r1_data      ),
	.o_r2_data (r2_data      ),
	.o_valid   (valid        )
	);

	ps_gaussian 
	gaus_i (
	.i_clk     (i_clk          ),
	.i_rstn    (i_rstn         ),

	.i_r0_data (r0_data        ),
	.i_r1_data (r1_data        ),
	.i_r2_data (r2_data        ),
	.i_valid   (valid          ),

	.o_data    (gaussian_dout  ),
	.o_valid   (gaussian_valid )
	);

endmodule