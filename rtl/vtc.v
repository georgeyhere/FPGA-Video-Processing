// Video Timing Control (VTC) module
// this module generates hsync and vsync signals for 640x480 resolution
//
// timings are parameterized but make sure pixel clock is correct!
//

module vtc 
	(
	input wire i_clk,  
	input wire i_rstn,

	// display timing
	output wire o_vsync,
	output wire o_hsync,
	output wire o_active,

	// counter passthrough
	output wire [9:0] o_counterX,
	output wire [9:0] o_counterY
	);

	// total frame size
	localparam RES_WIDTH  = 800;
	localparam RES_HEIGHT = 525;

	// active area
	localparam ACTIVE_X   = 640;
    localparam ACTIVE_Y   = 480;

	// hsync pulse width, back porch, front porch
	localparam HSYNC_WIDTH = 96;
	localparam HSYNC_BP    = 48;
	localparam HSYNC_FP    = 16;

	// vsync pulse width, back porch, front porch
	localparam VSYNC_WIDTH = 2;
	localparam VSYNC_BP    = 33;
	localparam VSYNC_FP    = 16;

	// horizontal and vertical counters
	//localparam COUNTER_X_WIDTH = $clog2(RES_WIDTH);	
	//localparam COUNTER_Y_WIDTH = $clog2(RES_HEIGHT);
	reg [9:0] counterX;
	reg [9:0] counterY;


	initial begin
		counterX = 0;
		counterY = 0;
	end

//
//
//
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			counterX <= 0;
		end
		else begin
			counterX <= (counterX == RES_WIDTH-1) ? 0 : counterX + 1;
		end
	end

	always@(posedge i_clk) begin
		if(!i_rstn) begin
			counterY <= 0;
		end
		else begin
			if(counterX == RES_WIDTH-1) begin
				counterY <= (counterY == RES_HEIGHT-1) ? 0 : counterY + 1;
			end
		end
	end

//
//
//
    assign o_hsync  = ((counterX >= ACTIVE_X + HSYNC_FP) && 
    	               (counterX <  ACTIVE_X + HSYNC_FP + HSYNC_WIDTH));
 
    assign o_vsync  = ((counterY >= ACTIVE_Y + VSYNC_FP) &&
    	              (counterY  <  ACTIVE_Y + VSYNC_FP + VSYNC_WIDTH));

    assign o_active = ((counterX >= 0) && (counterX < ACTIVE_X) &&
    	               (counterY >= 0) && (counterY < ACTIVE_Y));

    assign o_counterX = counterX;
    assign o_counterY = counterY;

endmodule // vtc