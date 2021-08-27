//
//
module sys_tb();


	reg sysclk, pclk;
	reg rst;
	wire vsync;
	wire 

	sys_top DUT(
	.i_sysclk    (),
	.i_rst       (),
	.o_cam_xclk  (),
	.o_cam_rstn  (),
	.o_cam_pwdn  (),

	.i_cam_pclk  (),
	.i_cam_vsync (),
	.i_cam_href  (),
	.i_cam_data  (),

	.SCL         (),
	.SDA         (),

	.o_TMDS_P    (),
	.o_TMDS_N    ()
	);

endmodule