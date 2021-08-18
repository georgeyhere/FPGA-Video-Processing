// debounce module
// -> 100 MHz
// -> applies 20 ms debounce to input
//

module debounce 
	(
    input  wire i_clk,
    input  wire i_input, // input to be debounced

    output reg  o_db     // debounced
	);

	// debounce period in clock periods
	parameter DB_COUNT = 2_000_000;

	reg [31:0] counter;

	reg        r_input1;
	reg        r_input2;

	initial begin
		r_input1 = 0;
		r_input2 = 0;
		o_db     = 0;
		counter  = 0;
	end

//
// double flop the input
//
	always@(posedge i_clk) begin
		r_input1 <= i_input;
		r_input2 <= r_input1;
	end

//
// debounce logic
//
	always@(posedge i_clk) begin
		if(r_input2 != o_db && counter < DB_COUNT) begin
			counter <= counter + 1;
		end
		else if(counter == DB_COUNT) begin
			o_db    <= r_input2;
			counter <= 0;
		end
		else begin
			counter <= 0;
		end
	end

endmodule // debounce