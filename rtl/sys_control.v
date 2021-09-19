// sys_control.v
//
// This module acts as an interface between board inputs and
// pipeline control.
//
//
`default_nettype none
//
`define MODE_PASSTHROUGH 0
//
module sys_control
	(
	input  wire       i_clk,
	input  wire       i_rstn,

	input  wire       i_btn_mode,
	input  wire       i_sw_gaussian,

	output reg        o_cfg_start,
	output reg        o_mode,
	output reg        o_gaussian_enable,
	output reg  [7:0] o_status_leds
	);

	reg STATE;
	localparam STATE_CFG    = 0,
	           STATE_ACTIVE = 1;

// Configure camera on startup or reset
	always@(posedge i_clk) begin
		if(!i_rstn) begin
			o_cfg_start <= 0;
			STATE <= 0;
		end
		else begin
			case(STATE)
				STATE_CFG: begin
					o_cfg_start <= 1;
					STATE <= 1;
				end

				STATE_ACTIVE: begin
					o_cfg_start <= 0;
					STATE <= 1;
				end
			endcase
		end
	end


// Toggle mode on button press
	initial o_mode = 0;
	wire    db_btn_mode;
	reg     btn1, btn2;
	wire    db_btn_posedge;

	debounce 
	#(.DB_COUNT(500_000))    // 20ms debounce period
	db_mode_i (
	.i_clk   (i_clk       ),
	.i_input (i_btn_mode  ),
	.o_db    (db_btn_mode )  
	);

	always@(posedge i_clk) begin
		if(!i_rstn) begin
			{btn1, btn2} <= 2'b0;
		end
		else begin
			{btn1, btn2} <= {db_btn_mode, btn1};
		end
	end
	assign db_btn_posedge = ((btn1 == 1) && (btn2 == 0));

	always@(posedge i_clk) begin
		if(!i_rstn) begin
			o_mode <= 0;
		end
		else begin
			if(db_btn_posedge) o_mode <= ~o_mode;
		end
	end

	always@(posedge i_clk) begin
		if(o_mode == `MODE_PASSTHROUGH)
			o_gaussian_enable <= 0;
		else begin
			o_gaussian_enable <= (i_sw_gaussian);
		end
	end

endmodule