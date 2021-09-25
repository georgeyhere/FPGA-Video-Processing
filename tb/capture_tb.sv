//
//
module capture_tb();


// DUT I/O
//
	logic        clk = 0;
	logic        rstn;
	logic        vsync;
	logic        href;
	logic [7:0]  data;

	logic        full = 0;

	logic        o_wr;
	logic [11:0] o_wdata;

	logic [11:0] test_data;

// DUT Instantiation
//
	capture DUT(
    .i_clk   (clk),
    .i_rstn  (rstn),

    .i_vsync (vsync),
    .i_href  (href),
    .i_data  (data),

    .o_wr    (o_wr),
    .o_wdata (o_wdata),
    .i_full  (full),

    .o_sof   ()
	);


// Testbench Setup
//
	localparam TESTRUNS  = 5;
	localparam ROWCOUNT  = 5;
	localparam ROWLENGTH = 10;

	logic [11:0] test_queue[$];
	logic [11:0] test_expected;

	always#(21) clk = ~clk;

	task startFrame;
		begin
			vsync = 0;
        	@(posedge clk);
        	vsync = 1;
        	repeat(3) @(posedge clk);  // mimic vsync pulse
        	vsync = 0;
        	repeat(17) @(posedge clk); // mimic vsync back porch
		end
	endtask

// Testbench 
//
	initial begin
		rstn  = 0;
		vsync = 0;
		href  = 0;
        data  = 0;
        #100;
        
        rstn  = 1;

        @(posedge clk) vsync = 1;
        repeat(3) @(posedge clk);
        @(posedge clk) vsync = 0;

        repeat(17) @(posedge clk);

        // repeat for # of frames
        for(int i=0; i<TESTRUNS; i++) begin 
        	startFrame();

        	// repeat for # of rows per frame
        	for(int j=0; j<ROWCOUNT; j++) begin
        		$display("Frame: %0h, Row: %0h", i,j);

        		// send a row of data
        	    for(int k=0; k<ROWLENGTH; k++) begin
        	    	@(negedge clk) begin
        	    		if(k==0) href = 1;
        	    		//
        	    		if(k%2 == 0) begin
        	    			test_data = $urandom;
        	    			data      = { {4{1'b1}}, test_data[11:8]};
        	    		end
        	    		else begin
        	    			data = test_data[7:0];
        	    			test_queue.push_front(test_data);
        	    		end
        	    	end
        	    end
        	    @(negedge clk) href = 0;  // drop href to signal end of row
        	    repeat(5) @(posedge clk); 
        	end
        end
        #1us
        $finish;
	end

// check that data matches data in
	always@(posedge clk) begin
		if(o_wr) begin
			test_expected = test_queue.pop_back();
			$display("Expected data: %h, Actual data: %h", test_expected, o_wdata);
			assert(o_wdata == test_expected)
			else $error("Checking failed: Expected data = %h, Actual data = %h", test_expected, o_wdata);
		end
	end

endmodule