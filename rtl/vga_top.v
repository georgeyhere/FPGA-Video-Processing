module vga_top 
	(
	input wire        i_clk,
	input wire        i_rstn,

	//input wire [15:0] i_data,

	output wire       o_vsync,
	output wire       o_hsync,
	output wire [3:0] o_red,
	output wire [3:0] o_green,
	output wire [3:0] o_blue
	);

	wire active;
	wire [9:0] counterX;
	wire [9:0] counterY;


	vtc vtc_inst(
	.i_clk      (i_clk),
	.i_rstn     (i_rstn),
	.o_vsync    (o_vsync),
	.o_hsync    (o_hsync),
	.o_active   (active),
	.o_counterX (counterX),
	.o_counterY (counterY)
	);



	assign o_red   = counterY[3] | (counterX == 256);
	assign o_green = (counterX[5] ^ counterY[6]) | (counterX == 256);
	assign o_blue  = counterX[4] | (counterX == 256);

endmodule // vga_top