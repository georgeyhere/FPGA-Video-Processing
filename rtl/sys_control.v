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
    input  wire       i_sysclk,
    input  wire       i_rstn,

    input  wire       i_sof,

    input  wire       i_btn_mode,
    input  wire       i_sw_gaussian,
    input  wire       i_sw_sobel,

    input  wire       i_btn_incSobel,
    input  wire       i_btn_decSobel,

    output reg        o_cfg_start,
    output reg        o_mode,
    output reg        o_pipe_flush,

    output reg        o_gaussian_enable,
    output reg        o_sobel_enable,
    output reg [25:0] o_sobel_threshold,
    output reg        o_thresholdBounds
    );

// =============================================================
//              Parameters, Registers, and Wires
// =============================================================
    localparam THRESHOLD_WIDTH = 26;
    localparam THRESHOLD_STEPSIZE = 500;

    reg        STATE;
    localparam STATE_CFG    = 0,
               STATE_ACTIVE = 1;

    wire       db_btn_mode;
    reg        btn1, btn2;
    wire       db_btn_posedge;
    wire       db_btn_incSobel, db_btn_decSobel;
    reg        incSobel_q1, incSobel_q2;
    reg        decSobel_q1, decSobel_q2;
    wire       incSobel_posedge, decSobel_posedge;

    reg        FLUSH_STATE;
    localparam FLUSH_IDLE   = 0, 
               FLUSH_ACTIVE = 1;

    reg        sw_gaussian_q1, sw_gaussian_q2;
    wire       delta_sw_gaussian;

    reg        sw_sobel_q1, sw_sobel_q2;
    wire       delta_sw_sobel;

    debounce 
    #(.DB_COUNT(500_000))    // 20ms debounce period
    db_mode_i (
    .i_clk   (i_sysclk    ),
    .i_input (i_btn_mode  ),
    .o_db    (db_btn_mode )  
    );

    debounce 
    #(.DB_COUNT(500_000))    // 20ms debounce period
    db_incSobel_i (
    .i_clk   (i_sysclk        ),
    .i_input (i_btn_incSobel  ),
    .o_db    (db_btn_incSobel )  
    );

    debounce 
    #(.DB_COUNT(500_000))    // 20ms debounce period
    db_dcSobel_i (
    .i_clk   (i_sysclk        ),
    .i_input (i_btn_decSobel  ),
    .o_db    (db_btn_decSobel )  
    );

// =============================================================
//                        Implementation:
// =============================================================

//
// Configure camera to ROM values on startup or reset
//
    always@(posedge i_sysclk) begin
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

//
// Toggle mode on button press
//
    initial o_mode = 0;
    always@(posedge i_sysclk) begin
        if(!i_rstn) begin
            {btn1, btn2} <= 2'b0;
        end
        else begin
            {btn1, btn2} <= {db_btn_mode, btn1};
        end
    end
    assign db_btn_posedge = ((btn1 == 1) && (btn2 == 0));

    always@(posedge i_sysclk) begin
        if(!i_rstn) begin
            o_mode <= `MODE_PASSTHROUGH;
        end
        else begin
            if(db_btn_posedge) o_mode <= ~o_mode;
        end
    end

//
// Filter enables
//
    always@(posedge i_sysclk) begin
        if(o_mode == `MODE_PASSTHROUGH)
            o_gaussian_enable <= 0;
        else begin
            o_gaussian_enable <= (i_sw_gaussian);
        end
    end
    always@(posedge i_sysclk) begin
        if(o_mode == `MODE_PASSTHROUGH)
            o_sobel_enable <= 0;
        else begin
            o_sobel_enable <= (i_sw_sobel);
        end
    end

// Enable edge detectors
// 
    always@(posedge i_sysclk) begin
        if(!i_rstn) begin
            {sw_gaussian_q1, sw_gaussian_q2} <= 2'b0;
        end
        else begin
            {sw_gaussian_q1, sw_gaussian_q2} <= {i_sw_gaussian, sw_gaussian_q1};
        end
    end
    assign delta_sw_gaussian = (sw_gaussian_q1 != sw_gaussian_q2);

    always@(posedge i_sysclk) begin
        if(!i_rstn) begin
            {sw_sobel_q1, sw_sobel_q2} <= 2'b0;
        end
        else begin
            {sw_sobel_q1, sw_sobel_q2} <= {i_sw_sobel, sw_sobel_q1};
        end
    end
    assign delta_sw_sobel = (sw_sobel_q1 != sw_sobel_q2);

//
// Flush the pipeline if a filter is applied
// -> hold the flush until start of frame
//
    always@(posedge i_sysclk) begin
        if(!i_rstn) begin
            o_pipe_flush <= 0;
            FLUSH_STATE  <= FLUSH_IDLE;
        end
        else begin
            if(o_mode != `MODE_PASSTHROUGH ) begin
                case(FLUSH_STATE)
                    FLUSH_IDLE: begin
                        o_pipe_flush <= 0;
                        FLUSH_STATE  <= (delta_sw_gaussian||delta_sw_sobel) ? FLUSH_ACTIVE:FLUSH_IDLE;
                    end
    
                    FLUSH_ACTIVE: begin
                        o_pipe_flush <= 1;
                        FLUSH_STATE  <= (i_sof) ? FLUSH_IDLE:FLUSH_ACTIVE;
                    end
                endcase
            end
            else o_pipe_flush <= 0;
        end
    end

// Sobel Thresholding Control
//

// Enable edge detectors
// 
    always@(posedge i_sysclk) begin
        if(!i_rstn) begin
            {incSobel_q1, incSobel_q2} <= 2'b0;
        end
        else begin
            {incSobel_q1, incSobel_q2} <= {db_btn_incSobel, incSobel_q1};
        end
    end
    assign incSobel_posedge = (incSobel_q1==1)&&(incSobel_q2==0);

    always@(posedge i_sysclk) begin
        if(!i_rstn) begin
            {decSobel_q1, decSobel_q2} <= 2'b0;
        end
        else begin
            {decSobel_q1, decSobel_q2} <= {db_btn_decSobel, decSobel_q1};
        end
    end
    assign decSobel_posedge = (decSobel_q1==1)&&(decSobel_q2==0);


    always@(posedge i_sysclk) begin
        if(!i_rstn) begin
            o_sobel_threshold <= 10;
        end
        else begin
            if(incSobel_posedge) begin
                if(o_sobel_threshold < 100) begin
                    o_sobel_threshold <= o_sobel_threshold+1;
                    o_thresholdBounds <= 0;
                end
                else begin
                    o_sobel_threshold <= o_sobel_threshold;
                    o_thresholdBounds <= 1;
                end
            end
            else if(decSobel_posedge) begin
                if(o_sobel_threshold > 0) begin
                    o_sobel_threshold <= o_sobel_threshold-1;
                    o_thresholdBounds <= 0;
                end
                else begin
                    o_sobel_threshold <= o_sobel_threshold;
                    o_thresholdBounds <= 1;
                end
            end
        end
    end

endmodule