// module: ps_linebuffer.v
//
// This is pretty much just a FIFO that outputs three
// words per read. 
//
// Should be synthesized as distributed ram w/ an output
// buffer for better performance -> 1 cycle read latency
//
module ps_linebuffer
    #(
    parameter LINE_LENGTH = 640,
    parameter DATA_WIDTH  = 8
    ) 
    (
    input  wire                    i_clk,
    input  wire                    i_rstn,
            
    // Write Interface            
    input  wire                    i_wr,
    input  wire [DATA_WIDTH-1:0]   i_wdata,
    
    // Read Interface
    input  wire                    i_rd,
    output reg  [3*DATA_WIDTH-1:0] o_rdata
    );

// 
    reg [DATA_WIDTH-1:0] mem [LINE_LENGTH-1:0];
    reg [3*DATA_WIDTH-1:0] rdata;

    reg [$clog2(LINE_LENGTH)-1:0] wptr, rptr;


// infer distributed ram
    always@(posedge i_clk) begin
        if(i_wr) begin
            mem[wptr] <= i_wdata;
        end
    end 

    always@* begin
        rdata = {mem[rptr-1], mem[rptr], mem[rptr+1]};
    end
    
    // output register
    always@(posedge i_clk) begin
        o_rdata <= rdata;
    end

// Write Pointer
    always@(posedge i_clk) begin
        if(!i_rstn) begin
            wptr <= 0;
        end
        else begin
            if(i_wr) begin
                wptr <= (wptr == LINE_LENGTH-1) ? 0 : wptr+1;
            end
        end
    end

// Read Pointer
    always@(posedge i_clk) begin
        if(!i_rstn) begin
            rptr <= 0;
        end
        else begin
            if(i_rd) begin
                rptr <= (rptr == LINE_LENGTH-1) ? 0 : rptr+1;
            end
        end
    end

endmodule

/*
INSTANTIATION TEMPLATE
ps_linebuffer
#(.LINE_LENGTH(640)) 
LINEBUF0_i (
.i_clk   (), 
.i_rstn  (), // sync active low reset
.i_wr    (), // write enable
.i_wdata (), // 8-bit write data
.i_rd    (), // read enable
.o_rdata ()  // 72-bit read data
);
*/