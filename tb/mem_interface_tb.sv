
module mem_interface_tb ();

	logic i_clk, i_rstn;
	logic disp_clk;
	logic i_flush = 0;

	logic i_req;

	logic o_rd;
	logic [11:0] i_rdata;
    logic i_almostempty;

    logic [18:0] i_raddr;
    logic [11:0] o_rdata;

	mem_interface DUT
	(
    .i_clk        (i_clk),
    .i_rstn       (i_rstn),
    .i_flush      (i_flush),
     
    .i_req        (i_req),
     
    .o_rd         (o_rd),
    .i_rdata      (i_rdata),
    .i_almostempty(i_almostempty),

    .i_rclk       (disp_clk),
    .i_raddr      (i_raddr),
    .o_rdata      (o_rdata)
	);

	integer i, j, k;
	logic [11:0] test_queue[$];
	logic [11:0] test_expected;
	logic [18:0] test_counter;
	logic        v_past1_almostfull;
	logic        v_past2_almostfull;

	always#(8) i_clk = ~i_clk;
	always#(20) disp_clk = ~disp_clk;

//
//
	always@(posedge i_clk) begin
		if(o_rd) begin
			i_rdata <= $urandom;
			test_queue.push_front(i_rdata);
		end
	end

	initial begin
		disp_clk = 0;
		i_clk   = 0;
		i_rstn  = 0;
		i_almostempty = 1;	
		i_rdata = 0;	
		i_raddr = 0;
		#100;
		i_rstn  = 1;
		#100;

		// write to entire frame buffer in 10-pixel bursts
		for(i=0; i<30720; i=i+1) begin
			@(posedge i_clk) i_almostempty <= 0;
			repeat(9) @(posedge i_clk);
			@(posedge i_clk) i_almostempty <= 1;
		end

		repeat(5) @(posedge disp_clk);


		// read back the frame buffer and check that data matches
		//@(posedge disp_clk) i_raddr <= i_raddr+1;
		for(i=0; i<307199; i=i+1) begin
			@(posedge disp_clk) begin
				i_raddr <= i_raddr + 1;
			end
			@(negedge disp_clk) begin
			    test_expected = test_queue.pop_back();
			    assert(o_rdata == test_expected)
			    else begin
			    	$error("Output data mismatch: Expected data = %h, Actual data = %h", test_expected, o_rdata);	   
			    	$stop;
			    end
			end
		end

		repeat(5) @(posedge disp_clk);
		$display("Test passed!");
		$finish;
	end

// module never reads from empty input fifo
	property ibuf_rdEmpty_chk;
		@(posedge i_clk) disable iff(!i_rstn)
			(i_almostempty) |=> !o_rd;
	endproperty
	A_ibuf_rdEmpty_chk: assert property(ibuf_rdEmpty_chk);

// every time there is a fifo read, there is a write to memory
	property mem_wr_chk;
		@(posedge i_clk) disable iff(!i_rstn)
			(o_rd) |-> DUT.mem_wr;
	endproperty
	A_mem_wr_chk: assert property(mem_wr_chk);
	
// check that no write addresses are skipped
	logic [18:0] t_prev_waddr;
	always@(posedge i_clk) begin
		if(DUT.mem_wr) t_prev_waddr <= DUT.mem_waddr;
		if(i_rstn) begin
			if(DUT.mem_wr && (t_prev_waddr!=0) && (t_prev_waddr != 307199)) begin
				assert(DUT.mem_waddr == t_prev_waddr+1)
				else $error("Write address skipped!");
			end
		end
	end

// block ram write address should never exceed bounds
	property mem_wraddrBounds_chk;
		@(posedge i_clk) disable iff(!i_rstn)
			DUT.mem_waddr < 307200;
	endproperty
	A_mem_wraddrBounds_chk: assert property(mem_wraddrBounds_chk);

endmodule