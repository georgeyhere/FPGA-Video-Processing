// module: ps_greyscale.v
//
// This module performs preprocessing as necessary depending on operating
// mode of the system.
//
// This module muxes between two outputs.
// -> in color mode, it acts as a passthrough for RGB data.
// -> in process mode, it applies the greyscale algorithm to the RGB data.
//
// The greyscale algorithm utilizes the luminosity method, which weighs
// each color component for a more accurate result. 
//         y = 0.299*R + 0.587*G + 0.114*B
//
// Verilog does not support decimal points in numbers, single-precision
// fixed-point multiplication is rather expensive.
//
// The algorithm is adapted to use bit-shifts instead, see docs/notes.txt:
// -> y = [(R>>2) + (R>>5) + (R>>6)] + [(G>>1) + (G>>4) + (G>>5)] + (B>>3)
//
// This version of the algorithm is shown to have a negligible error, see
// docs/greyscale.m
//
`default_nettype none
//
module pp_greyscale 
    (
    input  wire        i_clk,
    input  wire        i_rstn,

    // data in interface
    input  wire        i_valid,
    input  wire [11:0] i_data,

    // Output interface
    output reg  [11:0] o_data,
    output reg         o_valid
    );

    wire [7:0] r = {i_data[11:8], 4'b0};
    wire [7:0] g = {i_data[7:4],  4'b0};
    wire [7:0] b = {i_data[3:0],  4'b0};

    initial o_valid = 0;

    always@(posedge i_clk) begin
        if(!i_rstn) begin
            o_data  <= 0;
            o_valid <= 0;
        end
        else if(i_valid) begin
            o_valid <= 1;
            /*
            o_data  <= {((r>>2) + (r>>5) + (r>>6) +
                         (g>>1) + (g>>4) + (g>>5) + 
                         (b>>3)),
                         4'b0 // bottom 4 bits padded with 0s
                       };
            */
            o_data <= (r>>2)+(r>>5)+(r>>6)+(g>>1)+(g>>4)+(g>>5)+(b>>3);
        end 
        else begin
            o_valid <= 0;
            o_data  <= 0;
        end
    end

endmodule
