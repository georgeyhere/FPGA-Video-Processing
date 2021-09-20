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
    input wire                   i_flush,

	// input interface
	input  wire                  i_valid,
	input  wire [DATA_WIDTH-1:0] i_data,        
 
	// Output FIFO interface
	output wire                  o_wr,          // write enable
	output wire [DATA_WIDTH-1:0] o_wdata,       // write data
	input  wire                  i_almostfull,  // almost-full flag

	// display request
	input  wire                  i_req          // asserted when display is active
	);

	reg  nxt_rd;
	reg  STATE, NEXT_STATE;
	localparam STATE_IDLE   = 0,
               STATE_ACTIVE = 1;
    initial STATE = STATE_IDLE;

	reg  [18:0] nxt_mem_waddr, mem_waddr;
	reg         nxt_mem_wr, mem_wr;

	wire [18:0] mem_raddr;


// FSM sync process
//
/*
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
			else begin
				mem_wr    <= 0;
				mem_waddr <= mem_waddr;
			end
		end
	end
*/
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			mem_wr    <= 0;
			mem_waddr <= 0;
			STATE     <= STATE_IDLE;
		end
		else begin
			if(i_flush) begin
				mem_wr    <= 0;
				mem_waddr <= 0;
				STATE     <= STATE_IDLE;
			end
			else begin
				case(STATE)
					STATE_IDLE: begin
						mem_waddr <= 0;
						if(i_valid) begin
							mem_wr <= 1;
							STATE  <= STATE_ACTIVE;
						end
						else begin
							mem_wr <= 0;
						end
					end
	
					STATE_ACTIVE: begin
						if(i_valid) begin
							mem_wr <= 1;
							mem_waddr <= (mem_waddr == BRAM_DEPTH-1) ? 0:mem_waddr+1;
						end
						else begin
							mem_wr <= 0;
						end
						STATE <= (mem_waddr == BRAM_DEPTH-1) ? STATE_IDLE:STATE_ACTIVE;			
					end
				endcase
			end
		end
	end

//
// Submodule Instantiation
//	
	mem_bram
	mem_bram_i (
	.clka       (i_clk     ),
	.clkb       (i_clk     ),
      
	.addra      (mem_waddr ), // write address
	.dina       (i_data    ), // write data
	.wea        (mem_wr    ), // write enable
     
	.addrb      (mem_raddr ), // read address
	.doutb      (o_wdata   )  // read data
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