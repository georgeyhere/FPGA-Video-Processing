// module: ps_kernel.v
//
//
//
//
module ps_gaussian 
	(
	input  wire        i_clk,
	input  wire        i_rstn,
 
	input  wire [23:0] i_r0_data,
	input  wire [23:0] i_r1_data,
	input  wire [23:0] i_r2_data,
	input  wire        i_valid,

	output reg  [7:0]  o_data,
	output reg         o_valid
	);

	integer i;

//  3x3 kernel
	reg  [7:0]  kernel [8:0];

// stage 1: multiply
    wire [71:0] rowdata;
	reg  [10:0] stage1_data [8:0];
	reg         stage1_valid;

// stage 2: accumulate
	reg  [10:0] stage2_accumulator;
	reg  [10:0] stage2_data;
	reg         stage2_valid;

// stage 3: divide by 16
	reg  [10:0] stage3_data;
	reg         stage3_valid;


// KERNEL DEFINITION: 3X3 GAUSSIAN BLUR
	initial begin
		kernel[0] = 1;
		kernel[1] = 2;
		kernel[2] = 1;
		kernel[3] = 2;
		kernel[4] = 4;
		kernel[5] = 2;
		kernel[6] = 1;
		kernel[7] = 2;
		kernel[8] = 1;
	end

// PIPELINE STAGE 1
// 
	assign rowdata = {i_r0_data, i_r1_data, i_r2_data};
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			stage1_valid <= 0;
			for(i=0; i<9; i=i+1) begin
				stage1_data[i] <= 0;
			end
		end
		else begin
			stage1_valid <= i_valid;
			for(i=0; i<9; i=i+1) begin
				stage1_data[i] <= $signed(kernel[i]) * 
				                  $signed({1'b0, rowdata[i*8+:8]});
			end
		end
	end

// PIPELINE STAGE 2
//
	always@* begin
		stage2_accumulator = 0;
		for(i=0;  i<9; i=i+1) begin
			stage2_accumulator = $signed(stage2_accumulator) +
			                     $signed(stage1_data[i]);
		end
	end

	always@(posedge i_clk) begin
		if(!i_rstn) begin
			stage2_valid <= 0;
			stage2_data  <= 0;
		end
		else begin
			stage2_valid <= stage1_valid;
			stage2_data  <= stage2_accumulator;
		end
	end

// PIPELINE STAGE 3
//
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			o_valid <= 0;
			o_data  <= 0;
		end
		else begin
			o_valid <= stage2_valid;
			o_data  <= stage2_data >> 4; // stage2 is 11 bits, output is 8 bits
		end
	end


endmodule