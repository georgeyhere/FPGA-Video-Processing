//
//
module sys_tb();


	reg sysclk = 0;
	reg rst;
	wire xclk;
	wire cam_rstn;
	wire cam_pwdn;

	wire pclk;
	reg vsync;
	reg href;
	reg [7:0] cam_data;

	wire SCL, SDA;
	pullup(SCL);
	pullup(SDA);

	wire [3:0] TMDS_P;
	wire [3:0] TMDS_N;

	always#4 sysclk = ~sysclk;
	assign pclk = xclk;

	sys_top DUT(
	.i_sysclk    (sysclk),
	.i_rst       (rst),
	.o_cam_xclk  (xclk),
	.o_cam_rstn  (cam_rstn),
	.o_cam_pwdn  (cam_pwdn),

	.i_cam_pclk  (pclk),
	.i_cam_vsync (vsync),
	.i_cam_href  (href),
	.i_cam_data  (cam_data),

	.SCL         (SCL),
	.SDA         (SDA),

	.o_TMDS_P    (TMDS_P),
	.o_TMDS_N    (TMDS_N)
	);

	initial begin
		rst = 1;
		#100;
		rst = 0;
	end

endmodule