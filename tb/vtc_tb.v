module vtc_tb();


	reg clk = 0;
	reg i_rstn = 0;

	wire vsync, hsync, active;

	wire [9:0] counterX, counterY;


	localparam CLK_PERIOD = 40;
	always#(CLK_PERIOD/2) clk <= ~clk;

	vtc DUT(
	.i_clk      (clk),
	.i_rstn     (rstn),
	.o_vsync    (vsync),
	.o_hsync    (hsync),
	.o_active   (active),
	.o_counterX (counterX),
	.o_counterY (counterY)
	);

	initial begin
		$dumpfile("vtc.vcd");
		$dumpvars(0, vtc_tb);
	end

	initial begin
		#100;
		i_rstn = 1;

		repeat(900) begin
			@(posedge clk);
		end

		$finish;
	end

endmodule // vtc_tb