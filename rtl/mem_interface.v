`default_nettype none
//
//
module mem_interface
	#(
	parameter ROWLENGTH  = 128,
	parameter DATA_WIDTH = 12,
	parameter BRAM_DEPTH = 16384
	)
	(
	input wire                   i_clk,         // 125 MHz board clock
	input wire                   i_rstn,        // sync active low reset

	// 24MHz to 125MHz input FIFO
	output wire                  o_rd,          // read enable
	input  wire [DATA_WIDTH-1:0] i_rdata,       // read data
	input  wire                  i_almostempty, // almost-empty flag
 
	// 125MHz to 25MHz output FIFO
	output wire                  o_wr,          // write enable
	output wire [DATA_WIDTH-1:0] o_wdata,       // write data
	input  wire                  i_almostfull,  // almost-full flag

	// display request
	input  wire                  i_req          // asserted when display is active
	);

//
// Intermediate Wires
//
	wire [$clog2(BRAM_DEPTH)-1:0] mem_waddr;
	wire [DATA_WIDTH-1:0]         mem_wdata;
	wire                          mem_wr;
	wire [$clog2(BRAM_DEPTH)-1:0] mem_raddr;



//
// Submodule Instantiation
//	
	//
	mem_bram
	#(.BRAM_WIDTH (DATA_WIDTH),
	  .BRAM_DEPTH (BRAM_DEPTH)
	)
	mem_bram_i (
	.i_clk        (i_clk     ),
      
	.i_waddr      (mem_waddr ), // write address
	.i_wdata      (mem_wdata ), // write data
	.i_wr         (mem_wr    ), // write enable
      
	.i_raddr      (mem_raddr ), // read address
	.o_rdata      (o_wdata   )  // read data
	);

	//
	mem_wr 
	#(.ROWLENGTH  (ROWLENGTH),
	  .BRAM_WIDTH (DATA_WIDTH),
	  .BRAM_DEPTH (BRAM_DEPTH)
    )
	mem_wr_i (
	.i_clk        (i_clk         ), 
	.i_rstn       (i_rstn        ), // sync active low reset
     
    // 24_125 MHz FIFO interface
	.o_rd         (o_rd          ), // read enable 
	.i_data       (i_rdata       ), // read data 
	.i_empty      (i_almostempty ), // almost empty flag 
     
	.o_waddr      (mem_waddr     ), // bram write addr
	.o_wdata      (mem_wdata     ), // bram write data
	.o_wr         (mem_wr        )  // bram write enable
	);

	//
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