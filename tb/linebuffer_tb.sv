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
	logic [23:0] test_data;
	logic [23:0] test_queue[$];
	logic [23:0] test_expected;

	always#(6) clk = ~clk;

//
	initial begin
		rstn  = 0;
		wr    = 0;
		wdata = 0;
		rd    = 0;
		#100;
		@(posedge clk) rstn <= 1;

		for(int i=1; i<641; i++) begin
			@(posedge clk) begin
				wr    <= 1;
				wdata <= wdata + 1;
			end
		end
		@(posedge clk) wr <= 0;

		repeat(5) @(posedge clk);
	
		for(int i=1; i<=640; i++) begin
			@(posedge clk) begin
				rd <= 1;

				if(i%3 == 0) begin
					test_expected = test_expected;
				end
				else if(i%2 == 0) begin
					test_expected = test_expected;
				end 
				else begin
					test_expected = test_queue.pop_back();
					$display("Expected data: %h, Actual data: %h", test_expected, rdata);
				end
			end
		end

		@(posedge clk) rd <= 0;
	end


endmodule