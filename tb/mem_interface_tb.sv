
module mem_interface_tb ();

	logic i_clk, i_rstn;
	logic i_flush = 0;

	logic i_req;

	logic o_rd;
	logic [11:0] i_rdata;
    logic [9:0] i_rfill;

    logic o_wr;
    logic [11:0] o_wdata;
    logic i_almostfull;

	mem_interface DUT
	(
    .i_clk        (i_clk),
    .i_rstn       (i_rstn),
    .i_flush      (i_flush),
     
    .i_req        (i_req),
     
    .o_rd         (o_rd),
    .i_rdata      (i_rdata),
    .i_rfill      (i_rfill),

    .o_wr         (o_wr),
    .o_wdata      (o_wdata),
    .i_almostfull (i_almostfull)
	);

	integer i;
	logic [11:0] test_queue[$];
	logic [11:0] test_expected;
	logic [18:0] test_counter;
	logic        v_past1_almostfull;
	logic        v_past2_almostfull;
	logic        v_past3_almostfull;

	always#(8) i_clk = ~i_clk;

	always@(posedge i_clk) begin
		if(!i_rstn) begin
			i_rfill <= 640;
			i_rdata <= 640;
			test_counter <= 0;
		end
		else if(o_rd) begin
			i_rfill <= i_rfill - 1;
			i_rdata <= i_rdata - 1;
			test_queue.push_front(i_rdata);
			test_counter <= test_counter+1;
		end
	end

	initial begin
		i_clk   = 0;
		i_rstn  = 0;
		i_req   = 0;
		i_rfill = 0;	
		i_rdata = 0;
		i_almostfull = 0;	
		#100;
		i_rstn  = 1;

		repeat(1000) @(posedge i_clk);

		@(posedge i_clk) i_req <= 1;
		for(i=0; i<650; i=i+1) begin
			@(posedge i_clk) begin
				if(i==0) i_req <= 0;
				//
				if(i<=30 && i>=25) begin
					i_almostfull <= 1;
				end
				else if(i>30) begin
					i_almostfull <= (i%2==0) ? ~i_almostfull:i_almostfull;
				end
				v_past1_almostfull <= i_almostfull;
				v_past2_almostfull <= v_past1_almostfull;
				v_past3_almostfull <= v_past2_almostfull;

				if(o_wr) begin

				// check we aren't writing to a full fifo
					assert(!v_past3_almostfull)
					else begin
						$error("Writing to full FIFO:");
						$stop;
					end

				// check the data written to output fifo 
					test_expected = test_queue.pop_back();
					$display("Expected data: %d, Actual data: %d", 
						      test_expected, o_wdata);

					assert(o_wdata == test_expected)
					else begin
						$error("Data mismatch!");
						$stop;
					end
				end
			end
		end
		$stop;
	end

endmodule