//
//
//
module gaussian_tb ();

	reg        clk = 0;
	reg        rstn;

	reg        i_valid;
	reg  [7:0] i_data;
	wire       o_ready;

	wire       o_valid;
	wire [7:0] o_data;

	ps_gaussian_top DUT(
	.i_clk   (clk),
	.i_rstn  (rstn),

	.i_data  (i_data),
	.i_valid (i_valid),
	.o_ready (o_ready),

	.o_data  (o_data),
	.o_valid (o_valid)
	);

	always#(3) clk = ~clk;

//
//
	integer i;
	integer file, file1, file2;
	integer sentSize;
	integer receivedData;

	parameter headerSize = 1080;
	parameter imageSize = 640*480;

// testbench 
	initial begin
		
		sentSize = 0;
		receivedData = 0;
		rstn = 0;
		#100;
		rstn = 1;
		#100;

		file = $fopen("lena_gray.bmp", "rb");
		$display("Input image opened.");

		file1 = $fopen("out_img.bmp","wb");
		$display("Output image opened");

		file2 = $fopen("imageData.h","w");

		// write the image header to file1
		for(i=0; i<headerSize; i=i+1)  begin
			$fscanf(file, "%c", i_data);
			$fwrite(file1, "%c", i_data);
		end

		// scan four  rows of image pixel data
		for(i=0; i<(4*640); i=i+1) begin
			$fscanf(file, "%c", i_data);
			@(posedge clk);
				$fscanf(file, "%c", i_data);
				$fwrite(file2, "%0d,", i_data);
				i_valid <= 1;
		end

		@(posedge clk);
			i_valid <= 0;

			// send the image four lines at a time on interrupt
			while(sentSize < imageSize) begin

				@(posedge o_ready);
					for(i=0; i<4*640; i=i+1) begin
						@(posedge clk);
							$fscanf(file, "%c", i_data);
							$fwrite(file2, "%0d,", i_data);
							i_valid <= 1;
					end

				@(posedge clk);
					i_valid <= 0;
					sentSize = sentSize + 640;
			end

			@(posedge clk);
				i_valid <= 0;

			// insert a dummy line
			@(posedge o_ready);
				for(i=0; i<640; i=i+1) begin
					@(posedge clk);
						i_data <= 0;
						$fwrite(file2, "%0d,", i_data);
						i_valid <= 1;
				end

			@(posedge clk);
				i_valid <= 0;

			// insert a dummy line
			@(posedge o_ready);
				for(i=0; i<640; i=i+1) begin
					@(posedge clk);
					i_data <= 0;
					$fwrite(file2, "%0d,", i_data);
					i_valid <= 1;
				end

			@(posedge clk);
				i_valid <= 0;
				$fclose(file);
				$fclose(file2);
	end

	always@(posedge clk) begin
		if(o_valid) begin
			$fwrite(file1, "%c", o_data);
			receivedData = receivedData + 1;
		end
		if(receivedData == imageSize) begin
			$fclose(file1);
			$finish;
		end
	end

endmodule