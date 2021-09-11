// i2c module for communication w/ ov7670
//
// Timing parameters from i2c datasheet (p48, standard mode)
// -> https://www.nxp.com/docs/en/user-guide/UM10204.pdf
//
// Cross-referenced w/ OV7670 datasheet (p6)
// -> http://web.mit.edu/6.111/www/f2016/tools/OV7670_2006.pdf
//
//
/* - insert this code in top level
	inout SCL, SDA;
	//
    assign SCL = (o_scl) ? 1'bz : 1'b0;
    assign SDA = (o_sda) ? 1'bz : 1'b0;
    assign i_scl = SCL;
    assign i_sda = SDA;
*/
/* **** INSTANTIATION TEMPLATE ****
	i2c_master 
	#(
	.T_CLK (T_CLK)
	) 
	DUT
	(
    .i_clk         (),
    .i_rstn        (), // async active low rst

    // read/write control 
    .i_wr          (), // write enable
    .i_rd          (), // read enable
    .i_slave_addr  (), // 7-bit slave device addr
    .i_reg_addr    (), // 8-bit register addr
    .i_wdata       (), // 8-bit write data

    // read data out
    .o_rdata       (), // 8-bit read data out

    // status signals
    .o_busy        (), // if not busy; ready to accept new operation
    .o_rdata_valid (), // indicates o_rdata is valid
    .o_nack_slave  (), // NACK on slave address frame
    .o_nack_addr   (), // NACK on register address frame
    .o_nack_data   (), // NACK on data frame

    // bidirectional i2c pins
    .i_scl         (),
    .i_sda         (),
    .o_scl         (),
    .o_sda         ()
	);
	
    assign SCL = (o_scl) ? 1'bz : 1'b0;
    assign SDA = (o_sda) ? 1'bz : 1'b0;
    assign i_scl = SCL;
    assign i_sda = SDA;
*/


//
`default_nettype none
//
module cfg_i2c_master#
	(
		parameter T_CLK = 10
	) 
	(
	input  wire       i_clk,         // 100 MHz clock
	input  wire       i_rstn,        // synchronous active low reset
 	
	input  wire       i_wr,
	input  wire       i_rd,

	input  wire [6:0] i_slave_addr,   // 7'h42 for OV7670
	input  wire [7:0] i_reg_addr,     // register address to read/write
	input  wire [7:0] i_wdata,        // write data
	output reg  [7:0] o_rdata,        // read data

	// Status
	output reg        o_busy,         // asserted when a r/w in progress
	output reg        o_rdata_valid,  // read data valid
	output reg        o_nack_slave,   // NACK on slave address
	output reg        o_nack_addr,    // NACK on register address
	output reg        o_nack_data,    // NACK on data byte

	// SCL and SDA pins
	input  wire       i_scl,
	input  wire       i_sda,

	output reg        o_scl, // when asserted, 'releases' the pin
	output reg        o_sda   
);

	

// **** Timing Parameters ****
// 
	localparam T_SU_STA = 4700/T_CLK;  // START condition setup time  
	localparam T_HD_STA = 4000/T_CLK;  // START condition hold time
    localparam T_LOW    = 4700/T_CLK; // SCL low time
	localparam T_HIGH   = 4000/T_CLK;  // SCL high time
	localparam T_HD_DAT = 5000/T_CLK;  // Data-in hold time
    localparam T_SU_DAT = 250/T_CLK;  // Data-in setup time,
    localparam T_SU_STO = 4000/T_CLK;  // STOP condition setup time 

    // timer counter
    localparam TIMER_WIDTH = $clog2(T_LOW);
    reg [TIMER_WIDTH-1:0] timer     = 0;
    reg [TIMER_WIDTH-1:0] nxt_timer = 0;



// **** FSM Registers ****
//
	localparam STATE_INITIAL    = 0,
	           STATE_IDLE       = 1,
	           STATE_START      = 2,
	           STATE_BIT1       = 3,
	           STATE_BIT2       = 4,
	           STATE_BIT3       = 5,
	           STATE_STOP       = 6,
	           STATE_TIMER      = 7; 

	reg [3:0] STATE = STATE_INITIAL;
	reg [3:0] NEXT_STATE;

	reg [3:0] RETURN_STATE;
	reg [3:0] NEXT_RETURN_STATE;


	reg [26:0] sda_txqueue;
	reg [26:0] nxt_sda_txqueue;

	reg [7:0]  read_sr;
	reg [7:0]  nxt_read_sr;

    reg [4:0]  bit_counter;
    reg [4:0]  nxt_bit_counter;
    
    reg        load_r;
    reg        r_wr;
    reg        r_rd;
    reg [6:0]  r_slave_addr;
    reg [7:0]  r_reg_addr;
    reg [7:0]  r_wdata;
     
	reg nxt_scl_o;
	reg nxt_sda_o;

	reg [7:0] nxt_rdata;

	reg nxt_busy;
	reg nxt_rdata_valid;
	reg nxt_nack_slave;
	reg nxt_nack_addr;
	reg nxt_nack_data;

	reg wr_cycle;
	reg nxt_wr_cycle;

	reg repeat_start;
    reg nxt_repeat_start;



// **** Debounce External Inputs ****
// - inputs continuously shifted in
// - must be stable for four clocks
// - adds five cycles of latency but waiting longer is ok
//    -> could use an edge detector to detect changes and 
//       adjust STATE_TIMER delay value accordingly
//
    // shift registers initialized to idle values
    reg [3:0] scl_sr = {4{1'b1}};
    reg [3:0] sda_sr = {4{1'b1}};

    reg scl_db = 1;   // debounced SCL
	reg sda_db = 1;   // debounced SDA

    always@(posedge i_clk or negedge i_rstn) begin
    	if(!i_rstn) begin
    		scl_sr <= {4{1'b1}};
    		sda_sr <= {4{1'b1}};
    		scl_db <= 1;
    		sda_db <= 1;
    	end
    	else begin
    		scl_sr <= {scl_sr[2:0], i_scl};
    		sda_sr <= {sda_sr[2:0], i_sda};

    		if(scl_sr == {4{1'b1}}) 
    			scl_db <= 1;
    		else if (scl_sr == 4'b0)
    			scl_db <= 0;

    		if(sda_sr == {4{1'b1}}) 
    			sda_db <= 1;
    		else if (sda_sr == 4'b0)
    			sda_db <= 0;

    		//scl_db <= (scl_sr == {4{1'b1}});
    		//sda_db <= (sda_sr == {4{1'b1}});
    	end
    end

// **** FSM Next State Logic ****
//
	always@* begin
		nxt_scl_o         = o_scl;          // scl_db is floating by default           
		nxt_sda_o         = o_sda;          // sda_db is floating by default
         
        load_r            = 0;
        nxt_wr_cycle      = wr_cycle;
		nxt_sda_txqueue   = sda_txqueue;
        nxt_read_sr       = read_sr;
        
        nxt_bit_counter   = bit_counter;

        nxt_rdata         = o_rdata;
		nxt_busy          = o_busy;
		nxt_rdata_valid   = o_rdata_valid;
		nxt_nack_slave    = o_nack_slave;
		nxt_nack_addr     = o_nack_addr;
		nxt_nack_data     = o_nack_data;
  
		nxt_timer         = timer;

		NEXT_STATE        = STATE;
		NEXT_RETURN_STATE = RETURN_STATE;

		case(STATE)

			// initial state
			//     -> T_SU_STA (START setup time)
			//
			//     ___
			// SDA 
			//     ___
			// SCL 
			//
			STATE_INITIAL: begin
				nxt_busy          = 1;
				nxt_scl_o         = 1;
				nxt_sda_o         = 1;
				nxt_timer         = T_SU_STA;
				NEXT_STATE        = STATE_TIMER;
				NEXT_RETURN_STATE = STATE_IDLE;
			end
			
		    // idle state; SCL and SDA are high
			STATE_IDLE: begin
				nxt_scl_o      = 1;
				nxt_sda_o      = 1;
				nxt_busy       = 0;
				nxt_nack_slave = 0;
				nxt_nack_addr  = 0;
				nxt_nack_data  = 0;
				if((i_wr || i_rd) && (!o_busy)) begin
					nxt_rdata_valid  = (~i_rd);
					nxt_busy         = 1;
					load_r           = 1;
					nxt_wr_cycle     = 1;
					NEXT_STATE       = STATE_START;
				end
			end

			// START condition; pull SDA low 
			//     -> T_HD_STA (START hold time)
			//     __
			// SDA   \_
			//     ____
			// SCL 
			//
			STATE_START: begin
                nxt_sda_o       = 0;
                nxt_bit_counter = 0;

                // load sda_txqueue with transaction data
                //
				if(i_rd) begin
					// first part of read
					if(wr_cycle) 
						nxt_sda_txqueue = {i_slave_addr, // slave addr         [26:20]     
					                       1'b0,         // write bit          [19]
					                       1'b1,         // release; slave ack [18]
					                       i_reg_addr,   // rd register addr   [17:10]
					                       1'b1,         // release; slave ack [9]
					                       9'b0};        // * not used; repeated start *
					// second part of read
                    else 
                    	nxt_sda_txqueue = {i_slave_addr, // slave addr          [26:20]
					                       1'b1,         // read bit            [19]
					                       1'b1,         // release; slave ack  [18]
					                       8'hff,        // release; read data  [17:10]
					                       1'b1,         // release; master ACK [9]
					                       9'b0};        // * not used; STOP condition *
				end

				// write
				else begin
                    nxt_sda_txqueue = {i_slave_addr, // slave addr         [26:20]
                                       1'b0,         // write bit          [19]
                                       1'b1,         // release; slave ack [18]
                                       i_reg_addr,   // wr register addr   [17:10]
                                       1'b1,         // release; slave ack [9]
                                       i_wdata,      // write data         [8:1]
                                       1'b1};        // release; slave ack [0]
				end

				nxt_timer         = T_HD_STA;
                NEXT_STATE        = (!sda_db) ? STATE_TIMER : STATE_START;
                NEXT_RETURN_STATE = STATE_BIT1;
			end
            
            // Bit Part 1; pull SCL low
            //     -> T_HD_DAT (Data-in Hold Time)
            //     
			// SDA ____
			//     __
			// SCL   \_
			//
            STATE_BIT1: begin
            	nxt_scl_o         = 0;
            	nxt_timer         = T_HD_DAT;
            	NEXT_STATE        = (!scl_db) ? STATE_TIMER : STATE_BIT1;
            	NEXT_RETURN_STATE = STATE_BIT2;
            end

            // Bit Part 2: SDA transaction
            //     -> T_LOW (SCL low time)
            //        __
			// SDA __/__
			//     
			// SCL _____
			//
            STATE_BIT2: begin
            	nxt_sda_o         = sda_txqueue[26]; 
            	// shift in 0; SDA will be low after last bit for STOP condition 
            	nxt_sda_txqueue   = {sda_txqueue[25:0], 1'b0}; 
            	nxt_timer         = T_LOW;
            	NEXT_STATE        = STATE_TIMER;
            	NEXT_RETURN_STATE = STATE_BIT3;
            end

            // Bit Part 3: release SCL high
            //      ____
            // SDA /____
            //        __
            // SCL __/
            //
            STATE_BIT3: begin
            	nxt_scl_o       = 1;
            	nxt_timer       = T_HIGH;

            	if(scl_db) begin
            		nxt_bit_counter = bit_counter + 1;

            		if(bit_counter == 8) begin
            			nxt_nack_slave = sda_db;
            		end
            		else if ((bit_counter == 17) & wr_cycle) begin
            			nxt_nack_addr = sda_db;
            		end
            		else if(bit_counter == 26) begin
            			nxt_nack_data = sda_db;
            		end
            		
            		// for reads:  state transition after second slave ACK
            		// for writes: state transition at end of transmission
            		if( ((bit_counter == 18) & (r_rd)) || (bit_counter == 27)) begin
            			nxt_timer         = T_SU_STO;
            			NEXT_STATE        = STATE_TIMER;
            			NEXT_RETURN_STATE = STATE_STOP;
            		end
            		else begin
            			if((bit_counter != 17) && (r_rd)) begin
            				nxt_read_sr = {read_sr[6:1], sda_db};
            			end
            			nxt_timer         = T_HIGH;
            			NEXT_STATE        = STATE_TIMER;
            			NEXT_RETURN_STATE = STATE_BIT1;
            		end 
            	end
            end

            // Stop Condition 
            //      __
            // SDA X__\__
            //     ______
            // SCL 
            //
            STATE_STOP: begin
            	nxt_sda_o = 1;
            	if(sda_db) begin
            		// reads
            	    if(r_rd) begin
            	    	// read write register address done
            	    	if(wr_cycle) begin
            	    		if(r_rd) begin
            	    			nxt_timer = T_SU_STA - T_SU_STO;
            	    		end
            	    		else begin
            	    			nxt_timer = T_SU_STA;
            	    		end
            	    		NEXT_RETURN_STATE = STATE_START;
            	    	end
            	    	// read received
            	    	else begin
            	    		nxt_rdata         = read_sr;
            	    		nxt_rdata_valid   = 1;
            	    		nxt_timer         = T_SU_STA;
            	    		NEXT_RETURN_STATE = STATE_IDLE;
            	    	end
            	    	nxt_wr_cycle = 0;
            	    	NEXT_STATE   = STATE_TIMER;
            	    end

            	    // writes
            	    else begin
    					nxt_rdata_valid   = 0;
    					nxt_timer         = T_SU_STA;
    					NEXT_STATE        = STATE_TIMER;
    					NEXT_RETURN_STATE = STATE_IDLE;
            	    end
                end
            end

            STATE_TIMER: begin
            	// one cycle latency to enter TIMER state;
            	// one cycle latency exiting TIMER state
            	if(timer <= 2) begin
            		NEXT_STATE = RETURN_STATE;
            	end
            	else begin
            		nxt_timer = (timer == 0) ? 0 : timer-1;
            	end
            end

		endcase 
	end

// **** FSM Registers ****
//
	always@(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			o_rdata       <= 8'h0;
			o_busy        <= 1;
			o_rdata_valid <= 0;
			o_nack_slave  <= 0;
			o_nack_addr   <= 0;
			o_nack_data   <= 0;

			o_scl         <= 1;
			o_sda         <= 1;

			sda_txqueue   <= {27{1'b1}};
			read_sr       <= 8'h0;
			bit_counter   <= 5'h0;

			wr_cycle      <= 0;
			repeat_start  <= 0;

			r_wr          <= 0;
            r_rd          <= 0;
            r_slave_addr  <= 0;
            r_reg_addr    <= 0;
            r_wdata       <= 0;

            timer         <= 0;

			STATE         <= STATE_INITIAL;
			RETURN_STATE  <= STATE_IDLE;
		end
		else begin
			o_rdata       <= nxt_rdata;
			o_busy        <= nxt_busy;
			o_rdata_valid <= nxt_rdata_valid;
			o_nack_slave  <= nxt_nack_slave;
			o_nack_addr   <= nxt_nack_addr;
			o_nack_data   <= nxt_nack_data;

			o_scl         <= nxt_scl_o;
			o_sda         <= nxt_sda_o;

			sda_txqueue   <= nxt_sda_txqueue;
			read_sr       <= nxt_read_sr;
			bit_counter   <= nxt_bit_counter;

			wr_cycle      <= nxt_wr_cycle;
			repeat_start  <= nxt_repeat_start;

			timer         <= nxt_timer;

			if(load_r) begin
				r_wr         <= i_wr;
				r_rd         <= i_rd;
				r_slave_addr <= i_slave_addr;
				r_reg_addr   <= i_reg_addr;
				r_wdata      <= i_wdata;
			end

			STATE         <= NEXT_STATE;
			RETURN_STATE  <= NEXT_RETURN_STATE;
		end
	end



endmodule 
