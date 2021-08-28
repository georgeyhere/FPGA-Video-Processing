`default_nettype none
//
module sys_top 
	(
    input  wire       i_sysclk,    // 125 MHz board clock
    input  wire       i_rst,       // active-high board button

    // camera interface
    output wire       o_cam_xclk,  // 24MHz clock to camera from DCM
    output wire       o_cam_rstn,  // camera active low reset
    output wire       o_cam_pwdn,  // camera active high power down 

    input  wire       i_cam_pclk,  // camera generated pixel clock
    input  wire       i_cam_vsync, // camera vsync
    input  wire       i_cam_href,  // camera href
    input  wire [7:0] i_cam_data,  // camera 8-bit data in

    // i2c interface
    inout  wire       SCL,         // bidirectional SCL
    inout  wire       SDA,         // bidirectional SDA

    // HDMI interface
    output wire [3:0] o_TMDS_P,
    output wire [3:0] o_TMDS_N
	);

	assign o_cam_rstn = 1'b1; // doing a SW reset instead, see cfg_rom.v
	assign o_cam_pwdn = 1'b0;  

	// DCM
	wire clk_25MHz;
	wire clk_250MHz;

	// Debounce
	wire db_rstn;

	// Camera Configuration
	wire i_scl, i_sda;
	wire o_scl, o_sda;

	// 24MHz to 125MHz FIFO
	wire        wr_24_125;
	wire [11:0] wdata_24_125;
	wire        full_24_125;
	wire        rd_24_125;
	wire [11:0] rdata_24_125;
	wire        empty_24_125;

	// 125MHz to 25MHz FIFO
	wire        wr_125_25;
	wire [11:0] wdata_125_25;
	wire        full_125_25;
	wire        rd_125_25;
	wire [11:0] rdata_125_25;
	wire        empty_125_25;

	
// **** Debounce Reset button ****
// -> debounced in camera pclk domain (24MHz)
//
	debounce 
	#(.DB_COUNT(500_000))
	db_inst (
	.i_clk   (i_cam_pclk ),
	.i_input (~i_rst     ),
	.o_db    (db_rstn    )
	);


// **** Async Reset Synchronizers ****
//
	// 125 MHz
	reg sync_rstn_125, q_rstn_125;
	always@(posedge i_sysclk or negedge db_rstn) begin
		if(!db_rstn) {sync_rstn_125, q_rstn_125} <= 2'b0;
		else         {sync_rstn_125, q_rstn_125} <= {q_rstn_125, 1'b1};
	end

	// 25 MHz
	reg sync_rstn_25, q_rstn_25;
	always@(posedge clk_25MHz or negedge db_rstn) begin
		if(!db_rstn) {sync_rstn_25, q_rstn_25} <= 2'b0;
		else         {sync_rstn_25, q_rstn_25} <= {q_rstn_25, 1'b1};
	end


// **** Clocking Wizard ****
// 
	clk_wiz_0 dcm_i (
	.clk_in1    (i_sysclk      ), // 125MHz board clock
	.reset      (i_rst         ),
	.clk_24MHz  (o_cam_xclk    ), // camera reference clock output
	.clk_25MHz  (clk_25MHz     ), // display pixel clock
	.clk_250MHz (clk_250MHz    )  // display TMDS clock
	);


// **** Camera Configuration (125MHz) ****
//
	cfg_interface 
	#(.T_CLK(8) )

	cfg_i (
	.i_clk   (i_sysclk ), // 125 MHz
	.i_rstn  (db_rstn  ), // active-low sync reset

	// i2c pins
	.i_scl   (i_scl    ), 
	.i_sda   (i_sda    ),
	.o_scl   (o_scl    ),
	.o_sda   (o_sda    )
	);

	// setup inout pins
	assign SCL = (o_scl) ? 1'bz : 1'b0;
	assign SDA = (o_sda) ? 1'bz : 1'b0;
	assign i_scl = SCL;
	assign i_sda = SDA;

// **** Pixel Capture (24MHz) ****
//
	capture capture_i (
	.i_clk   (i_cam_pclk  ),  // camera pclk
	.i_rstn  (db_rstn     ),  // active-low sync reset

	// Camera Interface
	.i_vsync (i_cam_vsync ),  // vsync from camera
	.i_href  (i_cam_href  ),  // href from camera
	.i_data  (i_cam_data  ),  // 8-bit data

	// 24MHz to 125MHz FIFO Write interface
	.o_wr    (wr_24_125    ), // FIFO write enable
	.o_wdata (wdata_24_125 ), // 12-bit RGB data
	.i_full  (full_24_125  )  // FIFO full flag
	);


// **** CDC FIFO: 24MHz to 125MHz ****
//
	fifo_async
	#(.DATA_WIDTH (12),
	  .ADDR_WIDTH (8))
	fifo_24_125_i(
	// write interface
	.i_wclk   (i_cam_pclk    ), // 24 MHz camera pclk
	.i_wrstn  (db_rstn       ), // active-low async reset
	.i_wr     (wr_24_125     ), // write enable
	.i_wdata  (wdata_24_125  ), // write data
	.o_wfull  (full_24_125   ), // full flag
	.o_wfill  (), // unused
 	
 	// read interface
	.i_rclk   (i_sysclk      ), // 125 MHz sysclock domain
	.i_rrstn  (sync_rstn_125 ), // active-low async reset
	.i_rd     (rd_24_125     ), // read enable
	.o_rdata  (rdata_24_125  ), // read data
	.o_rempty (empty_24_125  ), // empty flag
	.o_rfill  ()  // unused
	);


// **** BRAM Buffer (125MHz) ****
//
	mem_interface mem_i(
	.i_clk  (i_sysclk     ),
	.i_rstn (db_rstn      ),

	// read interface: 24MHz to 125MHz FIFO
	.o_rd   (rd_24_125    ),
	.i_data (rdata_24_125 ),
	.i_empty(empty_24_125 ),
 
	// write interface: 125MHz to 25MHz FIFO
	.o_wr   (wr_125_25    ),
	.o_data (wdata_125_25 ),
	.i_full (full_125_25  )
	);



// **** CDC FIFO: 125MHz to 25MHz ****
//
	fifo_async
	#(.DATA_WIDTH (12),
	  .ADDR_WIDTH (8))
	fifo_125_25_i(
	// write interface
	.i_wclk   (i_sysclk      ), // 125 MHz sysclock domain
	.i_wrstn  (sync_rstn_125 ), // active-low async reset
	.i_wr     (wr_125_25     ), // write enable
	.i_wdata  (wdata_125_25  ), // write data
	.o_wfull  (full_125_25   ), // full flag
	.o_wfill  (), // unused
 	
 	// read interface
	.i_rclk   (clk_25MHz     ), // 25 MHz display clock domain
	.i_rrstn  (sync_rstn_25  ), // active-low async reset
	.i_rd     (rd_125_25     ), // read enable
	.o_rdata  (rdata_125_25  ), // read data
	.o_rempty (empty_125_25  ), // empty flag
	.o_rfill  () // unused
	);

// **** Display Out (25MHz) ****
//
	display_interface display_i (
	.i_p_clk    (clk_25MHz    ), // pixel clock
	.i_tmds_clk (clk_250MHz   ), // TMDS clock 
	.i_rstn     (db_rstn      ), // active-low sync reset

	// fifo read interface
	.o_rd       (rd_125_25    ), // FIFO read enable
	.i_rgb      (rdata_125_25 ), // FIFO read data (RGB444)
	.i_empty    (empty_125_25 ), // FIFO empty flag

	// HDMI TMDS out
	.o_TMDS_P   (o_TMDS_P     ),
	.o_TMDS_N   (o_TMDS_N     )
	);

endmodule