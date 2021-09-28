//
//
module pp_preprocess_tb();

	logic        i_clk;
	logic        i_rstn;
	logic        i_flush;
	logic        i_mode;

	logic        o_rd;
	logic [11:0] i_data;
	logic        i_almostempty;

	logic        i_rd;
	logic [11:0] o_data;
	logic [10:0] o_fill;
	logic        o_almostempty;
	logic        o_valid;

	pp_preprocess DUT(
    .i_clk         (i_clk),
    .i_rstn        (i_rstn),
    .i_flush       (i_flush),
    .i_mode        (i_mode),
 
    .o_rd          (o_rd),
    .i_data        (i_data),
    .i_almostempty (i_almostempty),
 
    .i_rd          (i_rd),
    .o_data        (o_data),
    .o_fill        (o_fill),
    .o_almostempty (o_almostempty),
    .o_valid       (o_valid)
	);

	integer i;
	logic [11:0] test_queue[$];
	logic [11:0] test_expected;
	logic [11:0] test_input;

	always#(4) i_clk = ~i_clk;

	// mimic 250 total words available from input fifo in 5 word bursts
	task inputData; 
		begin
			for(i=0; i<50; i=i+1) begin
				@(posedge i_clk) i_almostempty <= 0;
				repeat(4) @(posedge i_clk);
				@(posedge i_clk) i_almostempty <= 1;
			end
		end
	endtask

	logic [7:0] r,g,b;
	function bit [11:0] convertGrey;
		input  [11:0] i_rgb;
		begin
			r = {i_rgb[11:8],4'b0};
			g = {i_rgb[7:4], 4'b0};
			b = {i_rgb[3:0], 4'b0};

			convertGrey = {((r>>2) + (r>>5) + (r>>6) +
                          (g>>1) + (g>>4) + (g>>5) + 
                          (b>>3)),
			              4'b0 };
		end
	endfunction

	// whenever there is a fifo read, generate random data; store in a queue
	always@(posedge i_clk) begin
		if(o_rd) begin
			i_data <= $urandom;
			test_queue.push_front(i_data);
		end
	end

	initial begin
		i_clk         = 0;
		i_rstn        = 0;
		i_flush       = 0;
		i_mode        = 0;  // initialize in passthrough mode
		i_data        = $urandom;
		i_almostempty = 1;
		i_rd          = 0;
		#100;
		i_rstn = 1;

	// test passthrough mode
		// -> input data in 5 pixel bursts
		//test_queue.push_front(i_data); // FIFO has first word fallthrough
		inputData();
		repeat(5) @(posedge i_clk);

		// -> read the data from the output buffer, check that it matches
		@(posedge i_clk) i_rd <= 1;
		for(i=0; i<250; i=i+1) begin
			@(posedge i_clk) begin
				i_rd <= (i<249);
			end
			@(negedge i_clk) begin
				if(o_valid) begin
					test_expected = test_queue.pop_back();
					assert(o_data == test_expected)
					else begin
						$display("Output data mismatch: \n Expected data = %h, Actual data = %h \n",  
							      test_expected, o_data);	   
					    $stop;
					end
				end
			end
		end
		@(posedge i_clk) i_rd <= 0;
		assert(test_queue.size() == 0)
		else begin
			$display("Not all inputs read!");
			$stop;
		end
		$display("Passthrough Mode Readback Test Passed.");
		repeat(5) @(posedge i_clk);

	//
	// test grayscale conversion mode
	//
		$display("Starting Greyscale Conversion Test");
		@(posedge i_clk) i_mode <= 1;

		// -> input data in 5 pixel bursts
		inputData();

		// -> read the data from the output buffer, check that it matches
		@(posedge i_clk) i_rd <= 1;
		for(i=0; i<250; i=i+1) begin
			@(posedge i_clk) begin
				i_rd <= (i<249);
			end
			@(negedge i_clk) begin
				if(o_valid) begin
					test_input    = test_queue.pop_back();
					test_expected = convertGrey(test_input);
					assert(o_data == test_expected)
					else begin
						$display("Output data mismatch: \nExpected data = %h, Actual data = %h \n", 
							      test_expected, o_data);	   
					    $stop;
					end
				end
			end
		end
		@(posedge i_clk) i_rd <= 0;
		assert(test_queue.size() == 0)
		else begin
			$display("Not all inputs read!");
			$stop;
		end
		$display("Greyscale Mode Readback Test Passed.");
		repeat(5) @(posedge i_clk);
		$stop;
	end

//
// Asserts
//

// check that module never reads from empty input fifo
	property ibuf_rdEmpty_chk;
		@(posedge i_clk) disable iff(!i_rstn)
			(i_almostempty) |=> !o_rd;
	endproperty
	A_ibuf_rdEmpty_chk: assert property(ibuf_rdEmpty_chk)
		else $stop;
	
// check that din_valid is asserted on each input fifo read	
	property dinvalid_chk;
		@(posedge i_clk) disable iff(!i_rstn)
			(o_rd) |-> DUT.din_valid;
	endproperty
	A_mem_wr_chk: assert property(dinvalid_chk)
		else $stop;

// check that o_valid issued one clock after read is issued
	property ovalid_chk1;
		@(posedge i_clk) 
			(i_rd) |=> o_valid;
	endproperty
	A_ovalid_chk1: assert property(ovalid_chk1)
		else $stop;


// check that o_valid never issued if fifo is empty
	property ovalid_chk2;
		@(posedge i_clk) 
			(o_fill == 0) |=> !o_valid;
	endproperty
	A_ovalid_chk2: assert property(ovalid_chk2)
		else $stop;

endmodule