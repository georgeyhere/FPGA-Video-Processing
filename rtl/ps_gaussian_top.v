//
//
//
module ps_gaussian_top 
	(
	input  wire       i_clk,
	input  wire       i_rstn,
	input  wire       i_enable,
 
	input  wire [7:0] i_data,
	input  wire       i_valid,
	output wire       o_ready,

	output reg  [7:0] o_data,
	output reg        o_valid
	);

	wire [23:0] r0_data, r1_data, r2_data;
	wire        valid;
	wire [7:0]  gaussian_dout;
	wire        gaussian_valid;

	always@* begin
		if(i_enable) begin
			o_data  = gaussian_dout;
			o_valid = gaussian_valid;
		end
		else begin
			o_data  = i_data;
			o_valid = i_valid;
		end
	end

	ps_kernel_control 
	gaus_ctrl_i (
	.i_clk     (i_clk),
	.i_rstn    (i_rstn),
  
	.i_data    (i_data),
	.i_valid   (i_valid),
	.o_ready   (o_ready),

	.o_r0_data (r0_data),
	.o_r1_data (r1_data),
	.o_r2_data (r2_data),
	.o_valid   (valid)
	);

	ps_gaussian 
	gaus_i (
	.i_clk     (i_clk),
	.i_rstn    (i_rstn),

	.i_r0_data (r0_data),
	.i_r1_data (r1_data),
	.i_r2_data (r2_data),
	.i_valid   (valid),

	.o_data    (gaussian_dout),
	.o_valid   (gaussian_valid)
	);



endmodule