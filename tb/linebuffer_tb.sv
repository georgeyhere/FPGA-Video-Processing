//
//
module linebuffer_tb();

	logic clk = 0;
	logic rstn;

	logic wr;
	logic [7:0] wdata;

	logic rd;
	logic [23:0] rdata;

	ps_linebuffer 
	#(.LINE_LENGTH(640))
	DUT(
	.i_clk   (clk),
	.i_rstn  (rstn),

	.i_wr    (wr),
	.i_wdata (wdata),
	
	.i_rd    (rd),
	.o_rdata (rdata)
	);

// Testbench Setup
//
	logic [7:0] test_data1, test_data2, test_data3;

	logic [7:0] test_queue[$];
	logic [23:0] test_expected;
	integer i;

	always#(6) clk = ~clk;

//
	always@(posedge clk) begin
		if(wr) begin
			test_queue.push_front(wdata);
		end
	end

	initial begin
		rstn  = 0;
		wr    = 0;
		wdata = 0;
		rd    = 0;
		#100;
		@(posedge clk) rstn <= 1;
        
		// fill the linebuffer
		$display("Writing data to linebuffer.");
		for(i=0; i<640; i=i+1) begin
			@(posedge clk) begin
				wr    <= 1;
				wdata <= $urandom;
			end
		end
		@(posedge clk) wr <= 0;

		// read back data
		$display("Reading data from linebuffer.");
		@(posedge clk) rd <= 1;
		for(i=0; i<640; i=i+1) begin
			@(posedge clk) begin
				rd <= (i<639);
			end
			@(negedge clk) begin

				// special case: first pixel in row
				if(i==0) begin
                    test_data1 = test_queue.pop_back();
                    test_data2 = test_queue.pop_back();
                    test_data3 = test_queue.pop_back();
                    test_expected[15:0] = {test_data1, test_data2};
                    assert(rdata[15:0] == test_expected[15:0])
                    else begin
                    	$error("Output data mismatch: Expected data = %h, Actual data = %h", test_expected, rdata);
                    	$stop;
                    end
				end

				// special case: second pixel in row
				else if(i==1) begin
                    test_expected = {test_data1, test_data2, test_data3};
                    assert(rdata == test_expected)
                    else begin
                    	$error("Output data mismatch: Expected data = %h, Actual data = %h", test_expected, rdata);
                    	$stop;
                    end
				end
                
                // special case: last pixel in row
				else if(i==639) begin
                    test_expected[23:8] = {test_data2, test_data3};
                    assert(rdata[23:8] == test_expected[23:8])
                    else begin
                    	$error("Output data mismatch: Expected data = %h, Actual data = %h", test_expected, rdata);
                    	$stop;
                    end
				end

				// default
				else begin
					test_data1 = test_data2;
					test_data2 = test_data3;
					test_data3 = test_queue.pop_back();
					test_expected = {test_data1, test_data2, test_data3};
					assert(rdata == test_expected)
                    else begin
                    	$error("Output data mismatch: Expected data = %h, Actual data = %h", test_expected, rdata);
                    	$stop;
                    end
				end
			end
		end
        repeat(5) @(posedge clk);
        $display("Linebuffer read/write tests passed!");
        $stop;
	end


endmodule