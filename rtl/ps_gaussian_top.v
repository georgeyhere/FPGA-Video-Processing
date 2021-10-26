// module: ps_gaussian_top
//
// Wraps ps_kernel_control and ps_gaussian.
//
// Contains passthrough logic for when gaussian filter is disabled.
//
module ps_gaussian_top 
    (
    input  wire        i_clk,    // input clock
    input  wire        i_rstn,   // active low sync reset
    input  wire        i_enable, // filter enable
    input  wire        i_flush,
 
    input  wire [11:0] i_data,   // input data, RGB444 or greyscale[11:4]
    input  wire        i_almostempty, 
    output reg         o_rd,     // 

    input  wire        i_obuf_rd,
    output wire [11:0] o_obuf_data,
    output wire [4:0]  o_obuf_fill,
    output wire        o_obuf_full,
    output wire        o_obuf_almostfull,
    output wire        o_obuf_empty,
    output wire        o_obuf_almostempty
    );

    wire [23:0] r0_data, r1_data, r2_data;
    wire        valid;
    wire        req;
    wire [7:0]  gaussian_dout;
    wire        gaussian_valid;

    reg         nxt_rd;
    reg         nxt_din_valid, din_valid;
    reg  [9:0]  nxt_rdCounter, rdCounter;

    reg  [11:0] obuf_wdata;
    reg         obuf_wr;

    reg         STATE, NEXT_STATE;
    localparam  STATE_IDLE   = 0,
                STATE_ACTIVE = 1;


// FSM next state logic for FIFO reads
//
    always@* begin
        nxt_rd        = 0;
        nxt_din_valid = 0;
        NEXT_STATE    = STATE;

        case(STATE)
            
            STATE_IDLE: begin
                case(i_enable)
                    0: begin
                        if(!i_almostempty) begin
                            nxt_rd        = 1;
                            nxt_din_valid = 1;
                            NEXT_STATE    = STATE_ACTIVE;
                        end
                    end

                    1: begin
                        if(!i_almostempty && req) begin
                            nxt_rd        = 1;
                            nxt_din_valid = 1;
                            NEXT_STATE    = STATE_ACTIVE;
                        end
                    end
                endcase 
            end

            STATE_ACTIVE: begin
                case(i_enable)
                    0: begin
                        nxt_rd        = (!i_almostempty);
                        nxt_din_valid = (!i_almostempty);
                        NEXT_STATE    = (i_almostempty) ? STATE_IDLE : STATE_ACTIVE;
                    end

                    1: begin
                        nxt_rd        = (!i_almostempty && req);
                        nxt_din_valid = (!i_almostempty && req);
                        NEXT_STATE    = (i_almostempty || !req) ? STATE_IDLE : STATE_ACTIVE;
                    end
                endcase
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

    // passthrough logic
    always@* begin
        if(i_enable) begin
            obuf_wdata = {gaussian_dout, 4'b0};
            obuf_wr    = gaussian_valid;
        end
        else begin
            obuf_wdata = i_data;
            obuf_wr    = din_valid;
        end
    end

    ps_kernel_control 
    #(.LINE_LENGTH(640),
      .LINE_COUNT (480),
      .DATA_WIDTH (8))
    gaus_ctrl_i (
    .i_clk     (i_clk              ),
    .i_rstn    (i_rstn&&(~i_flush) ),
  
    .i_data    (i_data[11:4]       ),
    .i_valid   (din_valid          ),
    .o_req     (req                ),
      
    .o_r0_data (r0_data            ),
    .o_r1_data (r1_data            ),
    .o_r2_data (r2_data            ),
    .o_valid   (valid              )
    );

    ps_gaussian 
    gaus_i (
    .i_clk     (i_clk              ),
    .i_rstn    (i_rstn&&(~i_flush) ),

    .i_r0_data (r0_data            ),
    .i_r1_data (r1_data            ),
    .i_r2_data (r2_data            ),
    .i_valid   (valid              ),
    
    .o_data    (gaussian_dout      ),
    .o_valid   (gaussian_valid     )
    );

    fifo_sync 
    #(.DATA_WIDTH        (12),
      .ADDR_WIDTH        (10),
      .ALMOSTFULL_OFFSET (2),
      .ALMOSTEMPTY_OFFSET(1))
    ps_obuf_i (
    .i_clk         (i_clk),
    .i_rstn        (i_rstn&&(~i_flush) ),
            
    .i_wr          (obuf_wr),
    .i_data        (obuf_wdata),
            
    .i_rd          (i_obuf_rd),
    .o_data        (o_obuf_data),
    
    .o_fill        (o_obuf_fill),

    .o_full        (o_obuf_full),
    .o_almostfull  (o_obuf_almostfull),
    .o_empty       (o_obuf_empty),
    .o_almostempty (o_obuf_almostempty)
    );
endmodule