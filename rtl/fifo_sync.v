`default_nettype none
//
//
module fifo_sync
	#(parameter DATA_WIDTH         = 8,
      parameter ADDR_WIDTH         = 9,
      parameter ALMOSTFULL_OFFSET  = 2,
      parameter ALMOSTEMPTY_OFFSET = 2
	  )
	(
    input  wire                   i_clk,
    input  wire                   i_rstn,
                   
    input  wire                   i_wr,
    input  wire [DATA_WIDTH-1:0]  i_data,
                  
    input  wire                   i_rd,
    output reg  [DATA_WIDTH-1:0]  o_data,

    output reg  [ADDR_WIDTH:0]    o_fill,
    
    output wire                   o_full,
    output wire                   o_almostfull,
    output wire                   o_empty,
    output wire                   o_almostempty,
    
    output wire                   o_error
	);

	localparam FIFO_DEPTH = (1<<ADDR_WIDTH);

	reg  [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];
 	wire [DATA_WIDTH-1:0] rdata;
	
	reg  [ADDR_WIDTH-1:0] wptr;             
	reg  [ADDR_WIDTH-1:0] rptr;

// distributed ram
	always@(posedge i_clk) begin
		mem[wptr] <= i_data;
	end
	assign rdata = mem[rptr];
	always@(posedge i_clk) begin // output register
		o_data <= rdata;
	end

// write pointer
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			wptr <= 0;
		end
		else begin
			wptr <= (i_wr) ? wptr+1 : wptr;
		end
	end

// read pointer
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			rptr <= 0;
		end
		else begin
			rptr <= (i_rd) ? rptr+1 : rptr;
		end
	end

// o_fill and status
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			o_fill <= 0;
		end
		else if (i_rd && !i_wr) begin
			o_fill <= o_fill - 1;
		end
		else if (!i_rd && i_wr) begin
			o_fill <= o_fill + 1;
		end
	end

	assign o_full        = (o_fill == FIFO_DEPTH);
	assign o_almostfull  = (o_fill == FIFO_DEPTH-ALMOSTFULL_OFFSET);
	assign o_empty       = (o_fill == 0);
	assign o_almostempty = (o_fill <= ALMOSTEMPTY_OFFSET);
	assign o_error       = ((o_fill == 0) && (i_rd)) ||
	                       ((o_fill == FIFO_DEPTH) && (i_wr));

endmodule // fifo_sync

/*
	fifo_sync 
	#(.DATA_WIDTH        (12),
	  .ADDR_WIDTH        (9),
	  .ALMOSTFULL_OFFSET (2),
	  .ALMOSTEMPTY_OFFSET(2))
	name_i (
	.i_clk         (),
	.i_rstn        (),
            
	.i_wr          (),
	.i_data        (),
            
	.i_rd          (),
	.o_data        (),
    
    .o_fill        (),

	.o_full        (),
	.o_almostfull  (),
	.o_empty       (),
	.o_almostempty ()
	);
*/