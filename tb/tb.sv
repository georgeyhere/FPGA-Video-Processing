// for commit ec10b6b

module tb();

	logic i_sysclk = 0;
	logic i_rst;

	logic o_cam_xclk;
	logic o_cam_rstn;
	logic o_cam_pwdn;

	logic i_cam_pclk = 0;
	logic i_cam_vsync;
	logic i_cam_href;
	logic [7:0] i_cam_data;

	wire SCL, SDA;
	pullup(SCL);
	pullup(SDA);

	logic [3:0] o_TMDS_P, o_TMDS_N;

	logic [11:0] test_data;

	sys_top DUT(
	.i_sysclk    (i_sysclk),
	.i_rst       (i_rst),
 
	.o_cam_xclk  (o_cam_xclk),
	.o_cam_rstn  (o_cam_rstn),
	.o_cam_pwdn  (o_cam_pwdn),
 
	.i_cam_pclk  (i_cam_pclk),
	.i_cam_vsync (i_cam_vsync),
	.i_cam_href  (i_cam_href),
	.i_cam_data  (i_cam_data),

	.SCL         (SCL),
	.SDA         (SDA),

	.btn_mode    (1'b0),
	.sw_gaussian (1'b0),

	.o_TMDS_P    (o_TMDS_P),
	.o_TMDS_N    (o_TMDS_N)
	);

// Testbench Setup
//
	localparam TESTRUNS  = 5;    // # of frames
	localparam ROWCOUNT  = 480;  // # of rows
	localparam ROWLENGTH = 1280; // # of bytes per line (pixels*2)
	//
	int rows;
	int pixels;

	// test data 
	logic [11:0] test_queue[$];
	logic [11:0] test_expected;

	// setup clocks
	localparam SYSCLK_PERIOD   = 8;
	localparam CAM_PCLK_PERIOD = 20;

	always#(SYSCLK_PERIOD/2)   i_sysclk = ~i_sysclk;
	always#(CAM_PCLK_PERIOD/2) i_cam_pclk = ~i_cam_pclk;


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
		i_rst       = 1;
		i_cam_vsync = 0;
		i_cam_href  = 0;
        i_cam_data  = 0;
        repeat(6) @(negedge i_cam_pclk);
        
        i_rst  = 0;

        repeat(17) @(posedge i_cam_pclk);

        // repeat for # of frames
        for(int i=0; i<TESTRUNS; i++) begin 
        	startFrame();

        	// repeat for # of rows per frame
        	for(rows=1; rows<ROWCOUNT+1; rows++) begin
        		$display("Frame: %0h, Row: %0h", i,rows);

        		// send a row of data
        	    for(pixels=0; pixels<ROWLENGTH; pixels++) begin
        	    	@(negedge i_cam_pclk) begin
        	    		if(pixels==0) i_cam_href = 1;
        	    		//
        	    		if(pixels%2 == 0) begin
        	    			test_data       = rows*(pixels/2);
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

        	repeat(658560) @(negedge i_cam_pclk);
        end
        #2ms;
        $finish;
	end



// check data written to FIFO from capture module
// 
	logic [7:0] t_b1_data;
	logic [7:0] t_i_camdata;
	always@(posedge i_cam_pclk) begin
		if(DUT.cam_i.capture_i.o_wr) begin
			t_b1_data   = $past(i_cam_data,2);
			t_i_camdata = $past(i_cam_data,1);
			assert(DUT.cam_i.capture_i.o_wdata == {t_b1_data[3:0],t_i_camdata})
			else begin
				$error("Capture wdata check failed: Expected data = %b, Actual data = %b", 
		        {t_b1_data[3:0],t_i_camdata}, DUT.cam_i.capture_i.o_wdata);
				$display("t_b1_data: %0b", t_b1_data);
				$display("t_i_camdata: %0b", t_i_camdata);
				$stop;
			end
			/* $display("Capture wdata check: Expected data = %b, Actual data = %b", 
		        {t_b1_data[3:0],t_i_camdata}, DUT.capture_i.o_wdata); */
		end
	end

// check that data written to memory matches data written to FIFO
// 
	logic [11:0] t_ffifo_data[$];
	logic [11:0] t_expected_fiffo_data;

	// load queue on FIFO write
	always@(posedge i_cam_pclk) begin
		if(DUT.cam_i.capture_i.o_wr) begin
			t_ffifo_data.push_front(DUT.cam_i.capture_i.o_wdata);
		end
	end

/*
	// check data written to BRAM is always correct
	always@(posedge i_sysclk) begin
		if(DUT.mem_i.mem_wr) begin
			t_expected_fiffo_data = t_ffifo_data.pop_back();
			assert(DUT.mem_i.o_wdata == t_expected_fiffo_data)
			else begin
				$error("BRAM wdata check failed: Expected data = %b, Actual data = %b", 
		        	   t_expected_fiffo_data, DUT.mem_i.o_wdata);
				$stop;
			end 
		end
	end
*/
	// check that BRAM address always increments
	logic [18:0] t_mem_waddr = DUT.mem_i.mem_waddr;
	always@(posedge i_sysclk) begin
		if(DUT.mem_i.mem_wr) begin
			if($past(t_mem_waddr)!=307199 && $past(t_mem_waddr)>0) begin
				assert(t_mem_waddr == ($past(t_mem_waddr)+1))
				else begin
					$error("BRAM waddr check failed: Expected data = %b, Actual data = %b", 
		        	       ($past(DUT.mem_i.mem_waddr)+1), DUT.mem_i.mem_waddr);
					$stop;
				end 
			end
			else if($past(t_mem_waddr) == 307199) begin
				assert(DUT.mem_i.mem_waddr == 0)
				else begin
					$error("BRAM waddr check failed: Expected data = %b, Actual data = %b", 
		        	       0, DUT.mem_i.mem_waddr);
					$stop;
				end
			end
		end
	end


// check display interface read data
//
	always@(posedge DUT.clk_25MHz) begin
		if((DUT.display_i.active) && (DUT.display_i.STATE == 2)) begin
			test_expected = test_queue.pop_back();
			// $display("Expected data: %h, Actual data: %h", test_expected, display_i.i_rgb);
			assert(DUT.display_i.ibuf_rdata == test_expected)
			else begin
				$error("Checking failed: Expected data = %h, Actual data = %h", test_expected, DUT.display_i.ibuf_rdata);
				$stop;
			end

		end
	end

endmodule