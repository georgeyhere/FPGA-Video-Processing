module edgeDetection_top 
	(
    input  wire       i_sysclk,
    input  wire       i_rst,

    output wire       o_vsync,
    output wire       o_hsync,
    output wire [3:0] o_red,
    output wire [3:0] o_green,
    output wire [3:0] o_blue
	);

	wire clk_25MHz;
	wire db_rstn;

	clk_wiz_0 dcm_inst
  	(
  	.clk_out1(clk_25MHz),
  	.clk_in1 (i_sysclk)
  	);

	debounce 
	#(.DB_COUNT(500_000))
	db_inst (
	.i_clk   (clk_25MHz),
	.i_input (~i_rst),
	.o_db    (db_rstn)
	);

	vga_top vga_inst (
	.i_clk   (clk_25MHz),
	.i_rstn  (db_rstn),

	.o_vsync (o_vsync),
	.o_hsync (o_hsync),

	.o_red   (o_red),
	.o_green (o_green),
	.o_blue  (o_blue)
	);

endmodule