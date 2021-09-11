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
    output wire [3:0] o_TMDS_N,

    // debug
    output wire       cfg_led
	);

	assign o_cam_rstn = ~i_rst; 
	assign o_cam_pwdn = 1'b0;  


// **** Intermediate Wires ****
//

// DCM
	wire clk_25MHz;
	wire clk_75MHz;
	wire clk_250MHz;

// Debounce
	wire db_rstn;

// Camera Configuration
	wire i_scl, i_sda;
	wire o_scl, o_sda;

// Front Side FIFO: 24MHz to 75MHz 
    // write side
	wire        frontFIFO_wr;
	wire [11:0] frontFIFO_wdata;
	wire        frontFIFO_wfull;

	// read side
	wire        frontFIFO_rd;
	wire [11:0] frontFIFO_rdata;
	wire        frontFIFO_rempty;
	wire        frontFIFO_ralmostempty;
	wire [11:0] frontFIFO_rfill;

// Back Side FIFO: 75MHz to 25MHz 
	// write side
	wire        backFIFO_wrstn;
	wire        backFIFO_wr;
	wire [11:0] backFIFO_wdata;
	wire        backFIFO_wfull;
	wire        backFIFO_walmostfull;
	wire [7:0]  backFIFO_wfill;

	// read side
	wire        backFIFO_rd;
	wire [11:0] backFIFO_rdata;
	wire        backFIFO_rempty;
	wire        backFIFO_ralmostempty;
	wire [7:0]  backFIFO_rfill;

// Display Interface
	wire        req;
	
// **** Debounce Reset button ****
// -> debounced in camera pclk domain (24MHz)
//
	debounce 
	#(.DB_COUNT(100))
	db_inst (
	.i_clk   (i_cam_pclk ),
	.i_input (~i_rst     ),
	.o_db    (db_rstn    )  // 24MHz clock domain debounced reset
	);


// **** Async Reset Synchronizers ****
//
	// 125 MHz
	reg sync_rstn_75, q_rstn_75;
	always@(posedge clk_75MHz or negedge db_rstn) begin
		if(!db_rstn) {sync_rstn_75, q_rstn_75} <= 2'b0;
		else         {sync_rstn_75, q_rstn_75} <= {q_rstn_75, 1'b1};
	end

	// 25 MHz
	reg sync_rstn_25, q_rstn_25;
	always@(posedge clk_25MHz or negedge db_rstn) begin
		if(!db_rstn) {sync_rstn_25, q_rstn_25} <= 2'b0;
		else         {sync_rstn_25, q_rstn_25} <= {q_rstn_25, 1'b1};
	end


//
//
//
	reg STATE;
	reg start = 0;
	always@(posedge clk_75MHz) begin
		if(!db_rstn) begin
			start <= 0;
			STATE <= 0;
		end
		else begin
			case(STATE)
				0: begin
					start <= 1;
					STATE <= 1;
				end

				1: begin
					start <= 0;
					STATE <= 1;
				end
			endcase
		end
	end


// **** Clocking Wizard ****
// 
	clk_wiz_0 dcm_i (
	.clk_in1    (i_sysclk      ), // 125MHz board clock
	.reset      (1'b0          ),
	.clk_24MHz  (o_cam_xclk    ), // camera reference clock output
	.clk_25MHz  (clk_25MHz     ), // display pixel clock
	.clk_75MHz  (clk_75MHz     ),
	.clk_250MHz (clk_250MHz    )  // display TMDS clock
	);


// **** Camera Configuration (125MHz) ****
//

	cfg_interface 
	#(.T_CLK(13) )

	cfg_i (
	.i_clk   (clk_75MHz     ), // 75 MHz
	.i_rstn  (db_rstn       ), // active-low sync reset
	.i_start (start         ),
	.o_done  (cfg_led       ),

	// i2c pins
	.i_scl   (i_scl         ), 
	.i_sda   (i_sda         ),
	.o_scl   (o_scl         ),
	.o_sda   (o_sda         )
	);

	// setup inout pins
	assign SCL = (o_scl) ? 1'bz : 1'b0;
	assign SDA = (o_sda) ? 1'bz : 1'b0;
	assign i_scl = SCL;
	assign i_sda = SDA;

/*
	camera_configure cfg_i(
	.clk   (clk_75MHz),
	.start (start),
	.sioc  (SCL),
	.siod  (SDA),
	.done  (cfg_led)
	);
*/

// **** Pixel Capture (24MHz) ****
//
	capture capture_i (
	.i_pclk  (i_cam_pclk      ), // camera pclk
	.i_rstn  (db_rstn         ), // active-low sync reset

	// Camera Interface
	.i_vsync (i_cam_vsync     ), // vsync from camera
	.i_href  (i_cam_href      ), // href from camera
	.i_data  (i_cam_data      ), // 8-bit data
	
	// 24MHz to 125MHz FIFO Write interface
	.o_wr    (frontFIFO_wr    ), // FIFO write enable
	.o_wdata (frontFIFO_wdata ), // 12-bit RGB data
	.i_full  (frontFIFO_wfull )  // FIFO full flag
	);


// **** CDC FIFO (front-side): 24MHz to 75MHz ****
//

	fifo_async
	#(.DATA_WIDTH         (12),
	  .PTR_WIDTH          (12),
	  .ALMOSTFULL_OFFSET  (2),
	  .ALMOSTEMPTY_OFFSET (2) 
	 )
	frontFIFO_i (
	// write interface
	.i_wclk         (i_cam_pclk        ), // 24 MHz camera pclk
	.i_wrstn        (db_rstn           ), // active-low async reset (24MHz)
	.i_wr           (frontFIFO_wr      ), // write enable
	.i_wdata        (frontFIFO_wdata   ), // write data
	.o_wfull        (frontFIFO_wfull   ), // full flag
	.o_walmostfull  (), // unused
	.o_wfill        (), // unused
 	
 	// read interface
	.i_rclk         (clk_75MHz         ), // 75 MHz clock
	.i_rrstn        (sync_rstn_75      ), // active-low async reset (75 MHz)
	.i_rd           (frontFIFO_rd      ), // read enable
	.o_rdata        (frontFIFO_rdata   ), // read data
	.o_rempty       (frontFIFO_rempty  ), // empty flag
	.o_ralmostempty (frontFIFO_ralmostempty ),
	.o_rfill        (frontFIFO_rfill   )
	);


// **** BRAM Buffer (125MHz) ****
//
	mem_interface 
	#(.ROWLENGTH  (640),
	  .DATA_WIDTH (12),
	  .BRAM_DEPTH (307200) 
	 )
	mem_i(
	.i_clk         (clk_75MHz              ), // 75 MHz board clock
	.i_rstn        (sync_rstn_75           ), // active-low sync reset

	// read interface: 24MHz to 125MHz FIFO
	.o_rd          (frontFIFO_rd           ), // FIFO read enable 
	.i_rdata       (frontFIFO_rdata        ), // FIFO read data 
	.i_almostempty (frontFIFO_ralmostempty ), // almost-empty flag
	.i_fill        (frontFIFO_rfill        ), // FIFO fill level
 
	// write interface: 125MHz to 25MHz FIFO
	.o_wr          (backFIFO_wr            ), // FIFO write enable 
	.o_wdata       (backFIFO_wdata         ), // FIFO write data 
	.i_almostfull  (backFIFO_walmostfull   ), // almost-full flag

	// data request from display interface
	.i_req         (req                    )  
	); 


// **** CDC FIFO: 125MHz to 25MHz ****
//

	fifo_async
	#(.DATA_WIDTH         (12),
	  .PTR_WIDTH          (8),
	  .ALMOSTFULL_OFFSET  (4),
	  .ALMOSTEMPTY_OFFSET (2)  )
	backFIFO_i (
	// write interface
	.i_wclk         (clk_75MHz             ), // 75 MHz sys clock
	.i_wrstn        (sync_rstn_75          ), // active-low async reset
	.i_wr           (backFIFO_wr           ), // write enable
	.i_wdata        (backFIFO_wdata        ), // write data
	.o_wfull        (backFIFO_wfull        ), // full flag
	.o_walmostfull  (backFIFO_walmostfull  ), // almost-full flag
	.o_wfill        (), // unused
 	
 	// read interface
	.i_rclk         (clk_25MHz             ), // 25 MHz display clock 
	.i_rrstn        (sync_rstn_25          ), // active-low async reset
	.i_rd           (backFIFO_rd           ), // read enable
	.o_rdata        (backFIFO_rdata        ), // read data
	.o_rempty       (backFIFO_rempty       ), // empty flag
	.o_ralmostempty (backFIFO_ralmostempty ), // almost-full flag
	.o_rfill        ()  // unused
	);

// **** Display Interface ****
//
	display_interface display_i(
    .i_p_clk    (clk_25MHz       ), // 25 MHz display clock
    .i_tmds_clk (clk_250MHz      ), // 250 MHz TMDS clock
    .i_rstn     (db_rstn         ), // active-low async reset
 
    .o_rd       (backFIFO_rd     ), // FIFO read enable
    .i_rgb      (backFIFO_rdata  ), // FIFO read data
    .i_empty    (backFIFO_rempty ), // FIFO empty flag
   
    .o_req      (req             ), // Request flag to memory interface
      
    .o_TMDS_P   (o_TMDS_P        ), // HDMI outputs
    .o_TMDS_N   (o_TMDS_N        )
	);




endmodule