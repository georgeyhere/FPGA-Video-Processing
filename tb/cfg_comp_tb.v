module cfg_comp_tb();


	reg  clk_75MHz = 0;
	reg  start;
	wire done_1;

	always#(8) clk_75MHz = ~clk_75MHz;

	cfg_interface 
	#(.T_CLK(13) )

	cfg1_i (
	.i_clk   (clk_75MHz     ), // 75 MHz
	.i_rstn  (1'b1          ), // active-low sync reset
	.i_start (start         ),
	.o_done  (done_1        ),

	// i2c pins
	.i_scl   (i_scl         ), 
	.i_sda   (i_sda         ),
	.o_scl   (o_scl         ),
	.o_sda   (o_sda         )
	);
	wire i_scl, i_sda;
	wire o_scl, o_sda;
	wire SCL, SDA;
	pullup(SCL);
	pullup(SDA);
	assign SCL = (o_scl) ? 1'bz : 1'b0;
	assign SDA = (o_sda) ? 1'bz : 1'b0;
	assign i_scl = SCL;
	assign i_sda = SDA;


	wire done_2;
	wire SIOC, SIOD;
	pullup(SIOC);
	pullup(SIOD);
	camera_configure 
	cfg2_i(
	.clk   (clk_75MHz),
	.start (start),
	.sioc  (SIOC),
	.siod  (SIOD),
	.done  (done_2)
	);



	initial begin
		start = 0;
		#100;
		start = 1;
	end

endmodule