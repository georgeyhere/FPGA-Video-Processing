//
//
//
module camera_config_tb ();


	reg clk = 0;
	reg rstn;

	wire i_scl, i_sda;
	wire o_scl, o_sda;
	wire SCL, SDA;

	pullup(SCL);
	pullup(SDA);
	assign SCL = (o_scl) ? 1'bz:1'b0;
	assign SDA = (o_sda) ? 1'bz:1'b0;

	assign i_scl = SCL;
	assign i_sda = SDA;

	camera_config DUT(
	.i_clk  (clk),
	.i_rstn (rstn),
	.i_scl  (i_scl),
	.i_sda  (i_sda),
	.o_scl  (o_scl),
	.o_sda  (o_sda)
	);

	always#5 clk = ~clk;

	initial begin
		$dumpfile("camera_config_tb.vcd");
		$dumpvars(0, camera_config_tb);
	end

	initial begin
		rstn = 0;
		#100;
		rstn = 1;

		#6_000_000;
		$finish;
	end

endmodule