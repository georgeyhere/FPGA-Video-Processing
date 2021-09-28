
module ps_kernel_control_tb();


    logic        clk;
    logic        rstn;

    logic [7:0]  i_data;
    logic        i_valid;
    logic        o_req;

    logic [23:0] o_r0_data;
    logic [23:0] o_r1_data;
    logic [23:0] o_r2_data;
    logic        o_valid;

	ps_kernel_control DUT
	(
    .i_clk     (clk),
    .i_rstn    (rstn),
  
    .i_data    (i_data),
    .i_valid   (i_valid),
    .o_req     (o_req),

    .o_r0_data (o_r0_data),
    .o_r1_data (o_r1_data),
    .o_r2_data (o_r2_data),
    .o_valid   (o_valid)
	);

    always#(6) clk = ~clk;


//
	integer     test_counter = 0;
	integer     i,j,k;
    logic [7:0] test_queue1 [$];
    logic [7:0] test_queue2 [$];
    logic [7:0] test_queue3 [$];

    logic [23:0] test0_expected;
    logic [7:0]  test0_data1, test0_data2, test0_data3;

    logic [23:0] test1_expected;
    logic [7:0]  test1_data1, test1_data2, test1_data3;

    logic [23:0] test2_expected;
    logic [7:0]  test2_data1, test2_data2, test2_data3;

//	
	task checkOutput_r0;
		input [7:0] queue [$];
		begin
			for(j=0; j<640; j=j+1) begin 
			    @(negedge clk) begin
		        	// special case: first pixel in row
		        	if(j==0) begin
                	       test0_data1 = queue.pop_back();
                	       test0_data2 = queue.pop_back();
                	       test0_data3 = queue.pop_back();
                	       test0_expected = {test0_data2, test0_data2, test0_data3};
                	       assert(o_r0_data == test0_expected)
                	       else begin
                	       	$error("Output data mismatch: Expected data = %h, Actual data = %h", test0_expected, o_r0_data);
                	       	$stop;
                	       end
		        	end
		    
		        	// special case: second pixel in row
		        	else if(j==1) begin
                	       test0_expected = {test0_data1, test0_data2, test0_data3};
                	       assert(o_r0_data == test0_expected)
                	       else begin
                	       	$error("Output data mismatch: Expected data = %h, Actual data = %h", test0_expected, o_r0_data);
                	       	$stop;
                	       end
		        	end
                	   
                	// special case: last pixel in row
		        	else if(j==639) begin
                	       test0_expected = {test0_data2, test0_data3, test0_data3};
                	       assert(o_r0_data == test0_expected)
                	       else begin
                	       	$error("Output data mismatch: Expected data = %h, Actual data = %h", test0_expected, o_r0_data);
                	       	$stop;
                	       end
		        	end
		    
		        	// default
		        	else begin
		        		test0_data1 = test0_data2;
		        		test0_data2 = test0_data3;
		        		test0_data3 = queue.pop_back();
		        		test0_expected = {test0_data1, test0_data2, test0_data3};
		        		assert(o_r0_data == test0_expected)
                	       else begin
                	       	$error("Output data mismatch: Expected data = %h, Actual data = %h", test1_expected, o_r0_data);
                	       	$stop;
                	       end
		        	end
		        end
    	    end
		end
	endtask

	task checkOutput_r1;
		input [7:0] queue [$];
		begin
			for(k=0; k<640; k=k+1) begin 
			    @(negedge clk) begin
		        	// special case: first pixel in row
		        	if(k==0) begin
                	       test1_data1 = queue.pop_back();
                	       test1_data2 = queue.pop_back();
                	       test1_data3 = queue.pop_back();
                	       test1_expected = {test1_data2, test1_data2, test1_data3};
                	       assert(o_r1_data == test1_expected)
                	       else begin
                	       	$error("Output1 data mismatch: Expected data = %h, Actual data = %h", test1_expected, o_r1_data);
                	       	$stop;
                	       end
		        	end
		    
		        	// special case: second pixel in row
		        	else if(k==1) begin
                	       test1_expected = {test1_data1, test1_data2, test1_data3};
                	       assert(o_r1_data == test1_expected)
                	       else begin
                	       	$error("Output1 data mismatch: Expected data = %h, Actual data = %h", test1_expected, o_r1_data);
                	       	$stop;
                	       end
		        	end
                	   
                	// special case: last pixel in row
		        	else if(k==639) begin
                	       test1_expected = {test1_data2, test1_data3, test1_data3};
                	       assert(o_r1_data == test1_expected)
                	       else begin
                	       	$error("Output1 data mismatch: Expected data = %h, Actual data = %h", test1_expected, o_r1_data);
                	       	$stop;
                	       end
		        	end
		    
		        	// default
		        	else begin
		        		test1_data1 = test1_data2;
		        		test1_data2 = test1_data3;
		        		test1_data3 = queue.pop_back();
		        		test1_expected = {test1_data1, test1_data2, test1_data3};
		        		assert(o_r1_data == test1_expected)
                	       else begin
                	       	$error("Output1 data mismatch: Expected data = %h, Actual data = %h", test1_expected, o_r1_data);
                	       	$stop;
                	       end
		        	end
		        end
    	    end
		end
	endtask

	task checkOutput_r2;
		input [7:0] queue [$];
		begin
			for(i=0; i<640; i=i+1) begin 
			    @(negedge clk) begin
		        	// special case: first pixel in row
		        	if(i==0) begin
                	       test2_data1 = queue.pop_back();
                	       test2_data2 = queue.pop_back();
                	       test2_data3 = queue.pop_back();
                	       test2_expected = {test2_data2, test2_data2, test2_data3};
                	       assert(o_r2_data == test2_expected)
                	       else begin
                	       	$error("Output2 data mismatch: Expected data = %h, Actual data = %h", test2_expected, o_r2_data);
                	       	$stop;
                	       end
		        	end
		    
		        	// special case: second pixel in row
		        	else if(i==1) begin
                	       test2_expected = {test2_data1, test2_data2, test2_data3};
                	       assert(o_r2_data == test2_expected)
                	       else begin
                	       	$error("Output2 data mismatch: Expected data = %h, Actual data = %h", test2_expected, o_r2_data);
                	       	$stop;
                	       end
		        	end
                	   
                	// special case: last pixel in row
		        	else if(i==639) begin
                	       test2_expected = {test2_data2, test2_data3, test2_data3};
                	       assert(o_r2_data == test2_expected)
                	       else begin
                	       	$error("Output2 data mismatch: Expected data = %h, Actual data = %h", test2_expected, o_r2_data);
                	       	$stop;
                	       end
		        	end
		    
		        	// default
		        	else begin
		        		test2_data1 = test2_data2;
		        		test2_data2 = test2_data3;
		        		test2_data3 = queue.pop_back();
		        		test2_expected = {test2_data1, test2_data2, test2_data3};
		        		assert(o_r2_data == test2_expected)
                	       else begin
                	       	$error("Output2 data mismatch: Expected data = %h, Actual data = %h", test2_expected, o_r2_data);
                	       	$stop;
                	       end
		        	end
		        end
    	    end
		end
	endtask


//    

    // provide data on request 
    always@(posedge clk) begin
    	if(o_req) begin
    		i_valid <= 1;
    		i_data  <= $urandom;

            if(test_counter < 1920) test_counter = test_counter+1;
            else test_counter = 0;

            if(test_counter <= 640) begin
            	test_queue1.push_front(i_data);
            end
            else if(test_counter <= 1280) begin
            	test_queue2.push_front(i_data);
            end
            else if(test_counter <= 1920) begin
                test_queue3.push_front(i_data);
            end
    	end
    	else begin
    		i_valid <= 0;
    		i_data  <= 0;
    	end
    end

    always@(posedge o_valid) begin

  		fork
  			// thread 1
			checkOutput_r0(test_queue1);

			// thread 2
			begin
				for(i=0; i<640; i=i+1) begin
					@(negedge clk) begin
						assert(o_r1_data == test0_expected)
						else begin
							$error("Output1 data mismatch: Expected data = %h, Actual data = %h", test0_expected, o_r1_data);
            	    	    $stop;
						end
					end
				end
			end

			// thread 3
			checkOutput_r2(test_queue2);
		join
    end

    initial begin
    	clk      = 0;
    	rstn     = 0;
    	i_data   = 0;
    	i_valid  = 0;
    	#100;
    	rstn = 1;
    end

endmodule 