//
//
module sys_tb();

	logic i_cam_pclk = 0;
	logic i_sysclk = 0;
	logic i_dispclk = 0;
	logic db_rstn;

	// camera interface
	logic i_cam_vsync;
	logic i_cam_href;
	logic [11:0] i_cam_data;

	// 24MHz to 125MHz FIFO
	logic wr_24_125;
	logic [11:0] wdata_24_125;
	logic full_24_125;

	logic rd_24_125;
	logic [11:0] rdata_24_125;
	logic empty_24_125;
	logic almostempty_24_125;
	logic [7:0] rfill_24_125;

	logic ALMOSTFULL;
	logic ALMOSTEMPTY;
	logic [9:0] RDCOUNT, WRCOUNT;
	logic RDERR, WRERR;

	// 125MHz to 25MHz FIFO
	logic wr_125_25;
	logic [11:0] wdata_125_25;

	//
	logic [11:0] test_data;

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
	#(.DATA_WIDTH  (12),
	  .ADDR_WIDTH  (8),
	  .ALMOSTEMPTY (2))
	fifo_24_125_i(
	// write interface
	.i_wclk         (i_cam_pclk    ), // 24 MHz camera pclk
	.i_wrstn        (db_rstn       ), // active-low async reset
	.i_wr           (wr_24_125     ), // write enable
	.i_wdata        (wdata_24_125  ), // write data
	.o_wfull        (full_24_125   ), // full flag
 	
 	// read interface
	.i_rclk         (i_sysclk      ), // 125 MHz sysclock domain
	.i_rrstn        (db_rstn       ), // active-low async reset
	.i_rd           (rd_24_125     ), // read enable
	.o_rdata        (rdata_24_125  ), // read data
	.o_rempty       (empty_24_125  ), // empty flag
	.o_ralmostempty (almostempty_24_125),
	.o_rfill        (rfill_24_125)
	);


// **** BRAM Buffer (125MHz) ****
//
	mem_interface mem_i(
	.i_clk  (i_sysclk     ),
	.i_rstn (db_rstn      ),

	// read interface: 24MHz to 125MHz FIFO
	.o_rd   (rd_24_125    ),
	.i_data (rdata_24_125 ),
	.i_empty(almostempty_24_125 ),
 
	// write interface: 125MHz to 25MHz FIFO
	.o_wr   (wr_125_25    ),
	.o_data (wdata_125_25 ),
	.i_full (1'b0         )
	);


// Testbench Setup
//
	localparam TESTRUNS  = 2;
	localparam ROWCOUNT  = 480;
	localparam ROWLENGTH = 640;

	// test data 
	logic [11:0] test_queue[$];
	logic [11:0] test_expected;

	// setup clocks
	always#(8)  i_sysclk   = ~i_sysclk;
	always#(21) i_cam_pclk = ~i_cam_pclk;
	always#(20) i_dispclk  = ~i_dispclk;

	// vsync pulse
	task startFrame;
		begin
			i_cam_vsync = 0;
        	@(posedge i_cam_pclk);
        	i_cam_vsync = 1;
        	repeat(3) @(posedge i_cam_pclk);  // mimic vsync pulse
        	i_cam_vsync = 0;
        	repeat(17) @(posedge i_cam_pclk); // mimic vsync back porch
		end
	endtask


//
// Testbench 
//
	initial begin
		db_rstn  = 0;
		i_cam_vsync = 0;
		i_cam_href  = 0;
        i_cam_data  = 0;
        repeat(6) @(negedge i_cam_pclk);
        
        db_rstn  = 1;

        @(posedge i_cam_pclk) i_cam_vsync = 1;
        repeat(3) @(posedge i_cam_pclk);
        @(posedge i_cam_pclk) i_cam_vsync = 0;

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
        	    repeat(5) @(posedge i_cam_pclk); 
        	end
        end
        #1us;
	end


endmodule