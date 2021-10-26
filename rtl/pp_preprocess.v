// module: ps_preprocess.v
//
// This module is basically a wrapper for pp_greyscale.
//
// It includes read logic to get data from the camera capture FIFO and
// passthrough logic for RGB display mode.
//
// It funnels the output of pp_greyscale into a synchronous FIFO and
// sets a valid flag on reads based on whether there is available data.
// The FIFO is necessary because the Gaussian module only reads in bursts of
// one row at a time. 
//
`default_nettype none
//
`define MODE_PASSTHROUGH 0
//
module pp_preprocess 
    (
    input  wire         i_clk,   // input clock
    input  wire         i_rstn,  // sync active low reset
    input  wire         i_flush,

    // Mode select
    input  wire         i_mode,  // pretty much greyscale enable

    // Pixel Capture FIFO interface
    output reg          o_rd,    // read enable
    input  wire [11:0]  i_data,  // input data (RGB444)
    input  wire         i_almostempty, 
 
    // Output FIFO interface
    input  wire         i_rd,    // read enable
    output wire [11:0]  o_data,  // output data
    output wire [10:0]  o_fill,  //
    output wire         o_almostempty
    );

// Pixel Capture FIFO read 
    reg  [11:0] din;
    reg         din_valid, nxt_din_valid;
    reg         nxt_rd;
    reg  [9:0]  nxt_rdCounter, rdCounter;

// greyscale signals
    wire        gs_valid;
    wire [11:0] gs_dout;

// Output FIFO
    reg         fifo_wr;
    reg  [11:0] fifo_wdata;
    wire [11:0] fifo_rdata;
    wire        fifo_almostempty;
    wire        fifo_almostfull;
    wire        fifo_empty;

// FSM
    reg STATE, NEXT_STATE;
    localparam STATE_IDLE   = 0,
               STATE_ACTIVE = 1;
    initial STATE = STATE_IDLE;

// greyscale converter
    pp_greyscale 
    gscale_i (
    .i_clk   (i_clk     ),
    .i_rstn  (i_rstn    ),

    .i_valid (din_valid ),
    .i_data  (i_data    ),

    .o_data  (gs_dout   ),
    .o_valid (gs_valid  )
    );

// output FIFO
    fifo_sync 
    #(.DATA_WIDTH        (12),
      .ADDR_WIDTH        (10),
      .ALMOSTFULL_OFFSET (2),
      .ALMOSTEMPTY_OFFSET(1))
    pp_obuf_i (
    .i_clk         (i_clk              ),
    .i_rstn        (i_rstn&&(~i_flush) ),
             
    .i_wr          (fifo_wr            ),
    .i_data        (fifo_wdata         ),
               
    .i_rd          (i_rd               ),
    .o_data        (o_data             ),
    
    .o_fill        (o_fill             ),

    .o_full        (),   
    .o_almostfull  (fifo_almostfull    ),
    .o_empty       (fifo_empty         ),
    .o_almostempty (o_almostempty      )
    );


// FSM next state logic for FIFO reads
//
    always@* begin
        nxt_rd        = 0;
        nxt_din_valid = 0;
        nxt_rdCounter = rdCounter;
        NEXT_STATE    = STATE;

        case(STATE)
            
            STATE_IDLE: begin
                if(!i_almostempty) begin
                    nxt_rd        = 1;
                    nxt_din_valid = 1;
                    NEXT_STATE    = STATE_ACTIVE;
                end
            end

            STATE_ACTIVE: begin
                nxt_rd        = (!i_almostempty);
                nxt_din_valid = (!i_almostempty);
                if(i_almostempty) begin
                    NEXT_STATE = STATE_IDLE;
                end
            end
        endcase
    end

// FSM sync process
//
    always@(posedge i_clk) begin
        if(!i_rstn) begin
            o_rd      <= 0;
            din_valid <= 0;
            rdCounter <= 0;
            STATE     <= STATE_IDLE;
        end    
        else begin    
            o_rd      <= nxt_rd;
            din_valid <= nxt_din_valid;
            rdCounter <= nxt_rdCounter;
            STATE     <= NEXT_STATE;
        end
    end


// write to fifo based on mode
//   
    always@* begin
        if(i_mode == `MODE_PASSTHROUGH) begin
            fifo_wr    = (!fifo_almostfull) ? din_valid : 0;
            fifo_wdata = i_data;
        end
        else begin
            fifo_wr    = (!fifo_almostfull) ? gs_valid : 0;
            fifo_wdata = gs_dout;
        end
    end


endmodule
