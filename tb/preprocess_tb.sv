
module preprocess_tb();

	logic i_cam_pclk = 0;
	logic i_sysclk = 0;
	logic rstn;
	logic mode = 0;

	logic cfg_done = 1;

	logic        i_cam_vsync;
	logic        i_cam_href;
	logic [11:0] i_cam_data;

	logic        frontFIFO_wr;
	logic [11:0] frontFIFO_wdata;
	logic        frontFIFO_wfull;

	logic        frontFIFO_rd;
	logic [11:0] frontFIFO_rdata;
	logic        frontFIFO_rempty;
	logic        frontFIFO_ralmostempty;
	logic [9:0]  frontFIFO_rfill;

// Preprocessing
	logic        preprocess_valid;
	logic [11:0] preprocess_dout;
	logic [9:0]  preprocess_fill;

	logic        pp_rd = 0;


// **** Pixel Capture (24MHz) ****
	capture capture_i (
	.i_pclk     (i_cam_pclk      ), // camera pclk
	.i_rstn     (rstn            ), // active-low sync reset
	.i_cfg_done (cfg_done        ), // config module done flag
	.o_status   (), 

	// Camera Interface
	.i_vsync    (i_cam_vsync     ), // vsync from camera
	.i_href     (i_cam_href      ), // href from camera
	.i_data     (i_cam_data      ), // 8-bit data
	
	// 24MHz to 125MHz FIFO Write interface
	.o_wr       (frontFIFO_wr    ), // FIFO write enable
	.o_wdata    (frontFIFO_wdata ), // 12-bit RGB data
	.i_full     (frontFIFO_wfull )  // FIFO full flag
	);


// **** CDC FIFO (front-side): 24MHz to 125MHz ****
	fifo_async
	#(.DATA_WIDTH         (12),
	  .PTR_WIDTH          (10),
	  .ALMOSTFULL_OFFSET  (2),
	  .ALMOSTEMPTY_OFFSET (2) 
	 )
	frontFIFO_i (
	// write interface
	.i_wclk         (i_cam_pclk        ), // 24 MHz camera pclk
	.i_wrstn        (rstn           ), // active-low async reset (24MHz)
	.i_wr           (frontFIFO_wr      ), // write enable
	.i_wdata        (frontFIFO_wdata   ), // write data
	.o_wfull        (frontFIFO_wfull   ), // full flag
	.o_walmostfull  (), // unused
	.o_wfill        (), // unused
 	
 	// read interface
	.i_rclk         (i_sysclk          ), // 125 MHz clock
	.i_rrstn        (sync_rstn_125     ), // active-low async reset 
	.i_rd           (frontFIFO_rd      ), // read enable
	.o_rdata        (frontFIFO_rdata   ), // read data
	.o_rempty       (),
	.o_ralmostempty (),
	.o_rfill        (frontFIFO_rfill) // unused
	);

// **** Preprocessing Module ****
    ps_preprocess 
    preprocess_i (
    .i_clk   (i_sysclk               ), // 125 MHz clock
    .i_rstn  (rstn                   ), // active-low sync reset
    .i_flush (1'b0                   ), 
    .i_mode  (mode                   ), // 0: passthrough, 1:greyscale

    // frontFIFO interface
    .o_rd    (frontFIFO_rd           ), 
    .i_data  (frontFIFO_rdata        ),
    .i_rfill (frontFIFO_rfill        ),

    // data out interface
    .i_rd    (pp_rd                  ), 
    .o_fill  (preprocess_fill        ),
    .o_data  (preprocess_dout        )  // 12-bit dout
    );

// Testbench Setup
//
	localparam TESTRUNS  = 5;    // # of frames
	localparam ROWCOUNT  = 480;  // # of rows
	localparam ROWLENGTH = 1280; // # of bytes per line (pixels*2)

	// test data 
	logic [11:0] test_data;
	logic [11:0] test_queue[$];
	logic [11:0] test_expected;

	// setup clocks
	always#(8)  i_sysclk   = ~i_sysclk;
	always#(21) i_cam_pclk = ~i_cam_pclk;

	// vsync pulse
	task startFrame;
		begin
			i_cam_vsync = 0;
        	@(posedge i_cam_pclk);
        	i_cam_vsync = 1;
        	repeat(4704) @(posedge i_cam_pclk);  // mimic vsync pulse
        	i_cam_vsync = 0;
        	repeat(26656) @(posedge i_cam_pclk); // mimic vsync back porch
		end
	endtask

	//
// Testbench 
//
	initial begin
		rstn  = 0;
		i_cam_vsync = 0;
		i_cam_href  = 0;
        i_cam_data  = 0;
        repeat(6) @(negedge i_cam_pclk);
        
        rstn  = 1;

        repeat(17) @(posedge i_cam_pclk);

        // repeat for # of frames
        for(int i=0; i<TESTRUNS; i++) begin 
        	startFrame();

        	// repeat for # of rows per frame
        	for(int j=0; j<ROWCOUNT; j++) begin
        		$display("Frame: %0h, Row: %0h", i,j);

        		// send a row of data
        	    for(int k=0; k<ROWLENGTH; k++) begin
        	    	@(negedge i_cam_pclk) begin
        	    		if(k==0) i_cam_href = 1;
        	    		//
        	    		if(k%2 == 0) begin
        	    			test_data = $urandom;
        	    			i_cam_data      = { {4{1'b1}}, test_data[11:8]};
        	    		end
        	    		else begin
        	    			i_cam_data = test_data[7:0];
        	    			test_queue.push_front(test_data);
        	    		end
        	    	end
        	    end
        	    @(negedge i_cam_pclk) i_cam_href = 0;  // drop href to signal end of row
        	    repeat(288) @(posedge i_cam_pclk);     // 288 clocks until next href 
        	end
        end
        #2ms;
        $finish;
	end


endmodule