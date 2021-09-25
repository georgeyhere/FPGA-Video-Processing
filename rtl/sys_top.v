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

    // controls
    input  wire       btn_mode,
    input  wire       sw_gaussian,

    // status
    output wire       led_cfg
	);


// =============================================================
// 			    Parameters, Registers, and Wires
// =============================================================
// DCM
	wire        clk_25MHz;
	wire        clk_250MHz;
	wire        clk_PS;

// Debounce
	wire        db_rstn;

// System Control
	wire        cfg_start;
	wire        sys_mode;
	wire        gaussian_enable;
	wire        pipe_flush;

// Camera Block
	wire        i_scl, i_sda;
	wire        o_scl, o_sda;
	wire        sof;
	wire        cam_obuf_rd;
	wire [11:0] cam_obuf_rdata;
	wire        cam_obuf_almostempty;
	wire        cfg_done;


// Display Interface
	wire [18:0] framebuf_raddr;
	wire [11:0] framebuf_rdata;

// =============================================================
// 			          Implementation:
// =============================================================
	assign o_cam_rstn = 1'b1; // sw reset instead
	assign o_cam_pwdn = 1'b0;  
	assign led_cfg    = cfg_done;
	
// **** Debounce Reset button ****
// -> debounced in camera pclk domain (24MHz)
	debounce 
	//#(.DB_COUNT(476190))    // 20ms debounce period
	#(.DB_COUNT(1))    // 20ms debounce period
	db_inst (
	.i_clk   (i_cam_pclk ),
	.i_input (~i_rst     ),
	.o_db    (db_rstn    )  // 24MHz clock domain debounced reset
	);


// **** Async Reset Synchronizers ****
	// 125 MHz
	reg sync_rstn_PS, q_rstn_PS;
	always@(posedge i_sysclk or negedge db_rstn) begin
		if(!db_rstn) {sync_rstn_PS, q_rstn_PS} <= 2'b0;
		else         {sync_rstn_PS, q_rstn_PS} <= {q_rstn_PS, 1'b1};
	end

	// 25 MHz
	reg sync_rstn_25, q_rstn_25;
	always@(posedge clk_25MHz or negedge db_rstn) begin
		if(!db_rstn) {sync_rstn_25, q_rstn_25} <= 2'b0;
		else         {sync_rstn_25, q_rstn_25} <= {q_rstn_25, 1'b1};
	end


// =============================================================
// 			          Submodule Instantiation:
// =============================================================
	//---------------------------------------------------
	//                 Clocking Wizard:
	//---------------------------------------------------
	clk_wiz_0 
	dcm_i (
		.clk_in1    (i_sysclk      ), // 125MHz board clock
		.reset      (1'b0          ),
		.clk_24MHz  (o_cam_xclk    ), // camera reference clock output
		.clk_25MHz  (clk_25MHz     ), // display pixel clock
		.clk_250MHz (clk_250MHz    ), // display TMDS clock
		.clk_PS     (clk_PS        )  // processing system clock
	);

	//---------------------------------------------------
    //                 System Control:
    //---------------------------------------------------
	sys_control 
	ctrl_i (
		.i_sysclk          (i_sysclk        ), // 125MHz clock
		.i_rstn            (sync_rstn_PS    ), // active-low sync reset
	
		.i_sof             (sof             ),
	
		.i_btn_mode        (btn_mode        ), // board button 
		.i_sw_gaussian     (sw_gaussian     ),
	
		.o_cfg_start       (cfg_start       ), // config module start
		.o_gaussian_enable (gaussian_enable ),
		.o_mode            (sys_mode        ),
		.o_pipe_flush      (pipe_flush      ),
	
		.o_status_leds     ()                   
	);
	
	//---------------------------------------------------
    //                 Camera Block:
    //---------------------------------------------------
	assign SCL = (o_scl) ? 1'bz : 1'b0;
	assign SDA = (o_sda) ? 1'bz : 1'b0;
	assign i_scl = SCL;
	assign i_sda = SDA;

	cam_top 
	#(.T_CFG_CLK(8))
	cam_i (
	.i_cfg_clk          (i_sysclk        ),
	.i_rstn             (sync_rstn_PS    ),
    
    // OV7670 external inputs    
	.i_cam_pclk         (i_cam_pclk      ),
	.i_cam_vsync        (i_cam_vsync     ),
	.i_cam_href         (i_cam_href      ),
	.i_cam_data         (i_cam_data      ),

	// i2c bidirectional pins
	.i_scl              (i_scl           ),
	.i_sda              (i_sda           ),
	.o_scl              (o_scl           ),
	.o_sda              (o_sda           ),

	// Controls
	.i_cfg_init         (cfg_start       ),
	.o_cfg_done         (cfg_done        ),

	// output buffer read interface
	.i_obuf_rclk        (i_sysclk        ),
	.i_obuf_rstn        (sync_rstn_PS    ),
	.i_obuf_rd          (cam_obuf_rd     ),
	.o_obuf_data        (cam_obuf_rdata  ),
	.o_obuf_empty       (),  
	.o_obuf_almostempty (cam_obuf_almostempty ),  
	.o_obuf_fill        ()

	);

    //---------------------------------------------------
    //                 Memory Interface:
    //---------------------------------------------------
	mem_interface 
	#(.DATA_WIDTH (12),
	  .BRAM_DEPTH (307200) 
	 )
	mem_i(
	.i_clk         (i_sysclk               ), // 125 MHz board clock
	.i_rstn        (sync_rstn_PS           ), // active-low sync reset
	.i_flush       (pipe_flush             ),

	// Input FIFO read interface
	.o_rd          (cam_obuf_rd            ),
	.i_rdata       (cam_obuf_rdata         ),
	.i_almostempty (cam_obuf_almostempty   ),


	// frame buffer read interface
	.i_rclk        (clk_25MHz              ),
	.i_raddr       (framebuf_raddr         ),
	.o_rdata       (framebuf_rdata         )
	); 


	//---------------------------------------------------
    //                 Display Interface:
    //---------------------------------------------------
	display_interface 
	display_i(
    .i_p_clk       (clk_25MHz       ), // 25 MHz display clock
    .i_tmds_clk    (clk_250MHz      ), // 250 MHz TMDS clock
    .i_rstn        (db_rstn         ), 
    .i_mode        (sys_mode        ), // mode; color or greyscale
 	
 	// frame buffer read interface
   	.o_raddr       (framebuf_raddr  ),
   	.i_rdata       (framebuf_rdata  ),

    // TMDS out   
    .o_TMDS_P      (o_TMDS_P        ), // HDMI outputs
    .o_TMDS_N      (o_TMDS_N        )
	);

endmodule