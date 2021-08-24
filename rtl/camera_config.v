// module: camera_config.v
//
// This module reads from config_rom and initiates i2c_master writes.
// It operates in the 100 MHz clock domain.
//
`default_nettype none
//
module camera_config 
	(
	input  wire i_clk,  // 100 MHz clock
	input  wire i_rstn, 

	// i2c pins
	input  wire i_scl,
	input  wire i_sda,
	output wire o_scl,
	output wire o_sda
	);

	

// ROM
	reg  [7:0] rom_addr, nxt_rom_addr;
	wire [15:0] rom_data;

// i2c master 
	reg wr, nxt_wr;
	
	reg [7:0] reg_addr, nxt_reg_addr;
	reg [7:0] wdata, nxt_wdata;

	wire busy;

// FSM
	reg [1:0] STATE, NEXT_STATE;
	localparam STATE_OP     = 0,
	           STATE_DONE   = 1,
	           STATE_TIMER  = 2;
	           

	localparam T_CLK       = 10;
	localparam DELAY_VAL   = 1_000_000/T_CLK - 2; // clks for 1ms delay
	localparam TIMER_WIDTH = $clog2(DELAY_VAL);

	reg [TIMER_WIDTH-1:0] timer, nxt_timer;

// **** Initial Values ****
	initial begin
		wr       = 0;
		rom_addr = 0;
		STATE    = STATE_OP;
	end


// **** Next State Logic **** 
// 
	always@* begin
		nxt_rom_addr = rom_addr;

		nxt_wr       = 0;
		
		nxt_reg_addr = reg_addr;
		nxt_wdata    = wdata;

		nxt_timer    = timer;
		NEXT_STATE   = STATE;

		case(STATE)
			
			STATE_OP: begin
				if(!busy) begin
					case(rom_data)

						// delay
						16'hFF_F0: begin
							nxt_rom_addr = rom_addr + 1;
							nxt_timer    = DELAY_VAL;
							NEXT_STATE   = STATE_TIMER;
						end

						// end of ROM
						16'hFF_FF: begin
							NEXT_STATE = STATE_DONE;
						end

						default: begin
							nxt_wr = 1;
							nxt_reg_addr = rom_data[15:8];
							nxt_wdata    = rom_data[7:0];
							nxt_rom_addr = rom_addr + 1;
							nxt_timer    = 1;
							NEXT_STATE   = STATE_TIMER;
						end
					endcase
				end
			end

			STATE_DONE: begin
				// do nothing
			end

			STATE_TIMER: begin
				if(timer == 0) begin
					NEXT_STATE = STATE_OP;
				end
				else begin
					nxt_timer = timer - 1;
				end
			end
		endcase
	end

// 
//
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			rom_addr <= 0;
			wr       <= 0;
			reg_addr <= 0;
			wdata    <= 0;
			timer    <= 0;
			STATE    <= STATE_OP;
		end
		else begin
			rom_addr <= nxt_rom_addr;
			wr       <= nxt_wr;
			reg_addr <= nxt_reg_addr;
			wdata    <= nxt_wdata;
			timer    <= nxt_timer;
			STATE    <= NEXT_STATE;
		end
	end

// **** Submodule Instantiation ****
//
	config_rom config_rom_i (
	.i_clk         (i_clk),
	.i_rstn        (i_rstn),
	.i_addr        (rom_addr),
	.o_data        (rom_data)
	);


	// SCCB is the same as i2c but no ACK/NACK
	i2c_master 
	#(
	.T_CLK (T_CLK)
	) 
	i2c_master_i
	(
    .i_clk         (i_clk),    // 100 MHz clock
    .i_rstn        (i_rstn),   // async active low rst

    // read/write control 
    .i_wr          (wr),       // write enable
    .i_rd          (1'b0),     // read enable (not used)
    .i_slave_addr  (7'h42),    // 7-bit slave device addr
    .i_reg_addr    (reg_addr), // 8-bit register addr
    .i_wdata       (wdata),    // 8-bit write data
      
    // read data out      
    .o_rdata       (),         // 8-bit read data out
   
    // status signals   
    .o_busy        (busy),     // if low; ready to accept new operation
    .o_rdata_valid (),         // indicates o_rdata is valid
    .o_nack_slave  (),         // NACK on slave address frame
    .o_nack_addr   (),         // NACK on register address frame
    .o_nack_data   (),         // NACK on data frame

    // bidirectional i2c pins
    .i_scl         (i_scl),
    .i_sda         (i_sda),
    .o_scl         (o_scl),
    .o_sda         (o_sda)
	);




endmodule