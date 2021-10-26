module ps_sobel 
    (
    input  wire        i_clk,     // input clock
    input  wire        i_rstn,    // sync active-low reset
    
    // kernel control interface 
    input  wire [23:0] i_r0_data, // three greyscale pixels from each row
    input  wire [23:0] i_r1_data, 
    input  wire [23:0] i_r2_data,
    input  wire        i_valid,

    input  wire [25:0] i_threshold,

    // output interface
    output reg  [7:0]  o_data,    // 8-bit result 
    output reg         o_valid    // valid flag
    );

    integer i;

//  3x3 kernel
    reg  [7:0]  kernelX [8:0];
    reg  [7:0]  kernelY [8:0]; 

// stage 1: multiply
    wire [71:0] rowdata;
    reg  [15:0] stage1_dataX_reg [8:0];
    reg  [15:0] stage1_dataY_reg [8:0];
    reg         stage1_valid;

    
    reg  [15:0] stage1_dataX [8:0];
    reg  [15:0] stage1_dataY [8:0];
    reg         stage1_reg_valid;      
    

// stage 2: accumulate
    reg  [15:0] stage2_accumulatorX, stage2_accumulatorY;
    reg  [15:0] stage2_dataX, stage2_dataY;
    reg         stage2_valid;

// stage 3: convolve
    reg  [25:0] stage3_dataX_reg, stage3_dataY_reg;
    wire [25:0] stage3_data;
    reg         stage3_valid;


// KERNEL DEFINITION: 3X3 GAUSSIAN BLUR
    initial begin
        kernelX[0] =  1;
        kernelX[1] =  0;
        kernelX[2] = -1;
        kernelX[3] =  2;
        kernelX[4] =  0;
        kernelX[5] = -2;
        kernelX[6] =  1;
        kernelX[7] =  0;
        kernelX[8] = -1;

        kernelY[0] =  1;
        kernelY[1] =  2;
        kernelY[2] =  1;
        kernelY[3] =  0;
        kernelY[4] =  0;
        kernelY[5] =  0;
        kernelY[6] = -1;
        kernelY[7] = -2;
        kernelY[8] = -1;
    end

// PIPELINE STAGE 1 (2 cycles)
// 
    assign rowdata = {i_r0_data, i_r1_data, i_r2_data};

    // multiply pixel data by kernel
    always@(posedge i_clk) begin
        if(!i_rstn) begin
            stage1_valid <= 0;
            for(i=0; i<9; i=i+1) begin
                stage1_dataX_reg[i] <= 0;
            end
            for(i=0; i<9; i=i+1) begin
                stage1_dataY_reg[i] <= 0;
            end
        end
        else begin
            stage1_valid <= i_valid;
            for(i=0; i<9; i=i+1) begin
                stage1_dataX_reg[i] <= $signed(kernelX[i]) * 
                                       $signed({1'b0, rowdata[i*8+:8]});
            end
            for(i=0; i<9; i=i+1) begin
                stage1_dataY_reg[i] <= $signed(kernelY[i]) * 
                                       $signed({1'b0, rowdata[i*8+:8]});
            end
        end
    end

    // another register here for performance
    always@(posedge i_clk) begin
        if(!i_rstn) begin
            stage1_reg_valid <= 0;
            for(i=0; i<9; i=i+1) begin
                stage1_dataX[i] <= 0;
                stage1_dataY[i] <= 0;
            end
        end
        else begin
            stage1_reg_valid <= stage1_valid;
            for(i=0; i<9; i=i+1) begin
                stage1_dataX[i] <= stage1_dataX_reg[i];
            end
            for(i=0; i<9; i=i+1) begin
                stage1_dataY[i] <= stage1_dataY_reg[i];
            end
        end
    end

// PIPELINE STAGE 2 (1 cycle)
//
    // sum all the stage 1 data
    always@* begin
        stage2_accumulatorX = 0;
        stage2_accumulatorY = 0;

        for(i=0;  i<9; i=i+1) begin
            stage2_accumulatorX = $signed(stage2_accumulatorX) +
                                  $signed(stage1_dataX[i]);
        end
        for(i=0;  i<9; i=i+1) begin
            stage2_accumulatorY = $signed(stage2_accumulatorY) +
                                  $signed(stage1_dataY[i]);
        end
    end

    // and register it
    always@(posedge i_clk) begin
        if(!i_rstn) begin
            stage2_valid <= 0;
            stage2_dataX <= 0;
            stage2_dataY <= 0;
        end
        else begin
            stage2_valid <= stage1_reg_valid;
            stage2_dataX <= stage2_accumulatorX;
            stage2_dataY <= stage2_accumulatorY;
        end
    end

// PIPELINE STAGE 3 (1 cycle)
//
    // square X and Y kernel results
    always@(posedge i_clk) begin
        if(!i_rstn) begin
            stage3_dataX_reg <= 0;
            stage3_dataY_reg <= 0;
            stage3_valid     <= 0;
        end
        else begin
            stage3_dataX_reg <= $signed(stage2_dataX) * $signed(stage2_dataX);
            stage3_dataY_reg <= $signed(stage2_dataY) * $signed(stage2_dataY);
            stage3_valid     <= stage2_valid;
        end
    end

    // and sum them
    assign stage3_data = stage3_dataX_reg + stage3_dataY_reg;

// PIPELINE STAGE 4 (1 cycle)
//
    // threshold the summation instead of taking square root
    always@(posedge i_clk) begin
        if(!i_rstn) begin
            o_valid <= 0;
            o_data  <= 0;
        end
        else begin
            o_valid <= stage3_valid;
            o_data  <= (stage3_data > i_threshold) ? 8'hFF:8'h0;
        end
    end


endmodule