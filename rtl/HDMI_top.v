//
//
/*
	**** INSTANTIATION TEMPLATE ****
	
HDMI_top HDMI_i (
.i_p_clk       (), // pixel clock
.i_tmds_clk    (), // 10x pixel clock
.i_resetn      (), // sync active low reset

// 24-bit RGB
.i_rgb         (), // r[7:0], g[15:8], b[23:16]
 
// VTC   
.i_vsync       (),
.i_hsync       (),
.i_active_area (),

// HDMI interface
.o_TMDS_P      (),
.o_TMDS_N      ()
);

*/
module HDMI_top 
	(
	input  wire        i_p_clk,
	input  wire        i_tmds_clk,
	input  wire        i_resetn,
  
	input  wire [7:0]  i_red,
	input  wire [7:0]  i_green,
	input  wire [7:0]  i_blue,
  
	input  wire        i_vsync,
	input  wire        i_hsync,
	input  wire        i_active_area,
 
	output wire [3:0]  o_TMDS_P,
	output wire [3:0]  o_TMDS_N
	);


	wire [9:0] channel_zero;
	wire [9:0] channel_one;
	wire [9:0] channel_two;

	HDMI_encode encode_i (
	.i_p_clk        (i_p_clk       ),
	.i_resetn       (i_resetn      ),
         
	.i_red          (i_red         ),
	.i_green        (i_green       ),
	.i_blue         (i_blue        ),
         
	.i_vsync        (i_vsync       ),
	.i_hsync        (i_hsync       ),
	.i_active_area  (i_active_area ),

	.o_tmds_red     (channel_zero  ),
	.o_tmds_green   (channel_one   ),
	.o_tmds_blue    (channel_two   )
	);

	HDMI_out out_i (
	.i_p_clk        (i_p_clk       ),
	.i_tmds_clk     (i_tmds_clk    ),
	.i_resetn       (i_resetn      ),

	.i_tmds_red     (channel_zero  ),
	.i_tmds_green   (channel_one   ),
	.i_tmds_blue    (channel_two   ),

	.o_TMDS_P       (o_TMDS_P      ),
	.o_TMDS_N       (o_TMDS_N      )
	);


endmodule