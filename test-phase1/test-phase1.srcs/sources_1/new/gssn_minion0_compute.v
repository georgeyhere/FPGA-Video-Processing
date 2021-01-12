`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2021 03:04:23 PM
// Design Name: 
// Module Name: gssn_minion0_compute
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module gssn_minion0_compute(
input clk,
input reset_n,
input [7:0] BRAM_PORTB_0_dout, //memory read data
input rstb_busy_0, //memory busy flag
input [10:0] minion0_target, //goal row 
input minion_compute_start,

output reg BRAM_PORTB_0_en,
output reg [13:0]BRAM_PORTB_0_addr,
output reg [127:0] gssn_minion0_out,
output reg gssn_minion0_valid
    );


reg [7:0] count;
    
reg [15:0] target_pixel;
reg [3:0] fsm_next_state;
reg [3:0] fsm_state;
localparam s0_default = 0;    
localparam s1_read1 = 1;
localparam s2_read2 = 2;
localparam s3_read3 = 3;
localparam s4_read4 = 4;
localparam s5_read5 = 5;
localparam s6_read6 = 6;
localparam s7_read7 = 7;
localparam s8_compute = 8;
localparam s0_delay = 9;


reg [7:0] matrix_0; //latches
reg [7:0] matrix_1;
reg [7:0] matrix_2;
reg [7:0] matrix_3;
reg [7:0] matrix_4;
reg [7:0] matrix_5;
reg [7:0] matrix_6;
reg [7:0] matrix_7;
reg [7:0] matrix_8;
    
initial begin 
    BRAM_PORTB_0_en <= 0;
    BRAM_PORTB_0_addr <= 0;
    gssn_minion0_out <= 0;
    gssn_minion0_valid <= 0;
    target_pixel <= 0;

    matrix_0 <= 0;
    matrix_1 <= 1;
    matrix_2 <= 0;
    matrix_3 <= 0;
    matrix_4 <= 0;
    matrix_5 <= 0;
    matrix_6 <= 0;
    matrix_7 <= 0;
    matrix_8 <= 0;
    
    count <= 0;
    fsm_next_state <= 0;
end    

always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin
        BRAM_PORTB_0_en <= 0;
        BRAM_PORTB_0_addr <= 0;
        gssn_minion0_out <= 0;
        gssn_minion0_valid <= 0;
        target_pixel <= 0;
        
        matrix_0 <= 0;
        matrix_1 <= 1;
        matrix_2 <= 0;
        matrix_3 <= 0;
        matrix_4 <= 0;
        matrix_5 <= 0;
        matrix_6 <= 0;
        matrix_7 <= 0;
        matrix_8 <= 0;
        
        count <= 0;
        fsm_next_state <= 0;
    end
    else begin
    
    case(minion0_target)
        
        0: begin //target row 
            case(fsm_state)
        
                s0_default: begin
                    if(minion_compute_start) begin //start signal asserted
                        BRAM_PORTB_0_en <= 1; //enable port
                        BRAM_PORTB_0_addr <= 0; 
                        target_pixel <= 0; //set target pixel to 0, first in the row
                    end
                    else begin //else keep port disabled
                        BRAM_PORTB_0_en <= 0; 
                        BRAM_PORTB_0_addr <= 0;
                        fsm_state <= s0_default;
                    end       
                end
            
                s1_read_middle: begin
                    matrix_4 <= BRAM_PORTB_0_dout / 16;
                    BRAM_PORTB_0_addr <= (target_pixel*8 + 5120); //bottom
                    fsm_state <= s2_read2;
                end
            
                s2_read_bottom: begin
                    matrix_7 <= BRAM_PORTB_0_dout / 8;
                    if(target_pixel == 0) begin //first pixel, row 0
                        BRAM_PORTB_0_addr <= (target_pixel + 1)*8; //right
                        fsm_state <= s4_read_right; //still needs bottom right
                    end
                    else if(target_pixel == 639) begin //last pixel, row 0
                        BRAM_PORTB_0_addr <= (target_pixel - 1)*8; //set left address
                        fsm_state <= s5_read_left;
                    end
                    else begin
                        BRAM_PORTB_0_addr <= (target_pixel + 1)*8; //set right address
                        fsm_state <= s4_read_right;
                    end
                end
            
                s4_read_right: begin
                    matrix_5 <= BRAM_PORTB_0_dout / 8;
                    BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr+5120; //set bottom right address
                    fsm_state <= s6_read_bottom_right;
                end
            
                s5_read_left: begin
                    matrix_3 <= BRAM_PORTB_0_dout / 8;
                    BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr+5120; //set bottom left address
                    fsm_state <= s7_read_bottom_left;
                end
            
                s6_read_bottom_right: begin
                    matrix_8 <= BRAM_PORTB_0_dout / 16;
                    if(target_pixel == 0): begin //if it's the first pixel (4x4) then we are good to compute
                        fsm_state <= compute;
                    end
                    else begin //not the first pixel, need to get left and bottom left for row 0 compute
                        BRAM_PORTB_0_addr <= (target_pixel - 1)*8; //set left address 
                        fsm_state <= s5_read_left; 
                    end               
                end
            
                s7_read_bottom_left: begin
                    matrix_6 <= BRAM_PORTB_0_dout / 16;
                    fsm_state <= compute;
                end
            
                s8_compute: begin
                    BRAM_PORTB_0_en <= 0;
                    if(target_pixel == 0) begin
                        gssn_minion0_out <= matrix_4 + matrix+5 + matrix_7 + matrix_8;
                    end
                    else if(target_pixel == 639) begin
                        gssn_minion0_out <= matrix_4 + matrix_3 + matrix_6 + matrix_7;
                    end
                    else begin
                        gssn_minion0_out <= matrix_3 + matrix_4 + matrix_5 +matrix_6 + matrix_7 + matrix_8;
                    end
                    gssn_minion0_valid <= 1;
                    fsm_state <= s9_delay;
                end
            endcase
        end
        
        639: begin //target last row
            case(fsm_state)
                s0_default: begin
                    if(minion_compute_start) begin //start signal asserted
                        BRAM_PORTB_0_en <= 1; //enable port
                        BRAM_PORTB_0_addr <= 0; 
                        target_pixel <= 0; //set target pixel to 0, first in the row
                    end
                    else begin //else keep port disabled
                        BRAM_PORTB_0_en <= 0; 
                        BRAM_PORTB_0_addr <= 0;
                        fsm_state <= s0_default;
                    end       
                end
            
                s1_read_middle: begin 
                    matrix_4 <= BRAM_PORTB_0_dout / 4;
                    BRAM_PORTB_0_addr <= (target_pixel*8 - 5120); //top
                    fsm_state <= s2_read_top;
                end
            
                s2_read_top: begin //from s1
                    matrix_1 <= BRAM_PORTB_0_dout / 16;
                    if(target_pixel == 0) begin //first pixel, row 0
                        BRAM_PORTB_0_addr <= (target_pixel + 1)*8; //right
                        fsm_state <= s4_read_right; //still needs bottom right
                    end
                    else if(target_pixel == 639) begin //last pixel, row 0
                        BRAM_PORTB_0_addr <= (target_pixel - 1)*8; //set left address
                        fsm_state <= s5_read_left;
                    end
                    else begin
                        BRAM_PORTB_0_addr <= (target_pixel + 1)*8; //set right address
                        fsm_state <= s4_read_right;
                    end
                end
            
                s4_read_right: begin //from s2
                    matrix_5 <= BRAM_PORTB_0_dout / 8;
                    BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr-5120; //set top right address
                    fsm_state <= s6_read_top_right;
                end
            
                s5_read_left: begin //from s2
                    matrix_3 <= BRAM_PORTB_0_dout / 8;
                    BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr-5120; //set top left address
                    fsm_state <= s7_read_top_left;
                end
            
                s6_read_top_right: begin //from s2
                    matrix_2 <= BRAM_PORTB_0_dout / 16;
                    if(target_pixel == 0): begin //if it's the first pixel (4x4) then we are good to compute
                        fsm_state <= compute;
                    end
                    else begin //not the first pixel, need to get left and bottom left for row 0 compute
                        BRAM_PORTB_0_addr <= (target_pixel - 1)*8; //set left address 
                        fsm_state <= s5_read_left; 
                    end               
                end
            
                s7_read_top_left: begin //from s5
                    matrix_0 <= BRAM_PORTB_0_dout / 16;
                    fsm_state <= compute;
                end
            
                s8_compute: begin //from s6 or s7
                    BRAM_PORTB_0_en <= 0;
                    if(target_pixel == 0) begin
                        gssn_minion0_out <= matrix_1 + matrix_2 + matrix_4 + matrix_5;
                    end
                    else if(target_pixel == 639) begin
                        gssn_minion0_out <= matrix_0 + matrix_1 + matrix_3 + matrix_4;
                    end
                    else begin
                        gssn_minion0_out <= matrix_0 + matrix_1 + matrix_2 + matrix_3 + matrix_4 + matrix_5;
                    end
                    gssn_minion0_valid <= 1;
                    fsm_state <= s9_delay;
                end
            endcase
        end
        
        default: begin
        
        
        
        end
    endcase
    end
end
    
    
    
endmodule
