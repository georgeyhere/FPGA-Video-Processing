`default_nettype none
//
//
module mem_interface
	#(
    parameter DATA_WIDTH = 12,
	parameter BRAM_DEPTH = 307200
	)
	(
	input wire                   i_clk,         // 125 MHz board clock
	input wire                   i_rstn,        // sync active low reset

	// preprocess module interface
	input  wire                  i_valid,
	input  wire [DATA_WIDTH-1:0] i_data,          
 
	// Output FIFO interface
	output wire                  o_wr,          // write enable
	output wire [DATA_WIDTH-1:0] o_wdata,       // write data
	input  wire                  i_almostfull,  // almost-full flag

	// display request
	input  wire                  i_req          // asserted when display is active
	);


// BRAM write 
	reg  [$clog2(BRAM_DEPTH)-1:0] mem_waddr;
	reg                           mem_wr;

// BRAM read 
	wire [$clog2(BRAM_DEPTH)-1:0] mem_raddr;


// Write Logic
//
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			mem_wr    <= 0;
			mem_waddr <= 0;
		end
		else begin
			if(i_valid) begin
				mem_wr    <= 1;
				mem_waddr <= (mem_waddr == BRAM_DEPTH-1) ? 0:mem_waddr+1;
			end
		end
	end

//
// Submodule Instantiation
//	
	mem_bram
	#(.BRAM_WIDTH (DATA_WIDTH),
	  .BRAM_DEPTH (BRAM_DEPTH)
	)
	mem_bram_i (
	.i_clk        (i_clk     ),
      
	.i_waddr      (mem_waddr ), // write address
	.i_wdata      (i_data    ), // write data
	.i_wr         (mem_wr    ), // write enable
      
	.i_raddr      (mem_raddr ), // read address
	.o_rdata      (o_wdata   )  // read data
	);

	// read logic
	mem_rd 
	#(.BRAM_DEPTH (BRAM_DEPTH)
	 )
	mem_rd_i (
    .i_clk        (i_clk        ), 
    .i_rstn       (i_rstn       ), // sync active low reset
       
    .i_req        (i_req        ), // request from display module (25MHz)
    
    // 125_25 MHz FIFO interface
    .o_wr         (o_wr         ), // write enable 
    .i_almostfull (i_almostfull ), // almost-full flag
    .o_raddr      (mem_raddr    )  // bram read addr
	);

endmodule