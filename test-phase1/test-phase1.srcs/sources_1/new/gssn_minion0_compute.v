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
input [10:0] minion0_row, //goal row 
input minion_compute_start,

output reg gssn_minion0_ready,
output reg BRAM_PORTB_0_en,
output reg [13:0]BRAM_PORTB_0_addr,
output reg [7:0] gssn_minion0_out,
output reg gssn_minion0_valid
    );

    
reg [15:0] target_pixel;
reg [3:0] fsm_state;
localparam s0_default = 0;    
localparam s1_read = 1;
localparam s2_read = 2;
localparam s3_read = 3;
localparam s4_read = 4;
localparam s5_read = 5;
localparam s6_read = 6;
localparam s7_read = 7;
localparam s8_read = 8;
localparam s9_read = 9;
localparam s10_compute = 10;
localparam s11_delay = 11;

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
    gssn_minion0_ready <= 0;

    matrix_0 <= 0;
    matrix_1 <= 1;
    matrix_2 <= 0;
    matrix_3 <= 0;
    matrix_4 <= 0;
    matrix_5 <= 0;
    matrix_6 <= 0;
    matrix_7 <= 0;
    matrix_8 <= 0;
   
end    

always@(posedge clk, negedge reset_n) begin
    if(reset_n == 1'b0) begin
        BRAM_PORTB_0_en <= 0;
        BRAM_PORTB_0_addr <= 0;
        gssn_minion0_out <= 0;
        gssn_minion0_valid <= 0;
        target_pixel <= 0;
        gssn_minion0_ready <= 0;
        
        matrix_0 <= 0;
        matrix_1 <= 0;
        matrix_2 <= 0;
        matrix_3 <= 0;
        matrix_4 <= 0;
        matrix_5 <= 0;
        matrix_6 <= 0;
        matrix_7 <= 0;
        matrix_8 <= 0;      
    end
    else begin
    
    case(minion0_row)
 
        default: begin //default: 3x3 kernel for all pixels except 0 and 639
            case(fsm_state)
                s0_default: begin
                    if(minion_compute_start) begin //start signal asserted
                        BRAM_PORTB_0_en <= 1; //enable port
                        BRAM_PORTB_0_addr <= (target_pixel * 8); //set next read to middle top
                        fsm_state <= s1_read;
                        gssn_minion0_ready <= 0;
                    end
                    else begin //else keep port disabled
                        BRAM_PORTB_0_en <= 0;
                        BRAM_PORTB_0_addr <= 0;
                        gssn_minion0_out <= 0;
                        gssn_minion0_valid <= 0;
                        target_pixel <= 0;
                        gssn_minion0_ready <= 1;
        
                        matrix_0 <= 0;
                        matrix_1 <= 0;
                        matrix_2 <= 0;
                        matrix_3 <= 0;
                        matrix_4 <= 0;
                        matrix_5 <= 0;
                        matrix_6 <= 0;
                        matrix_7 <= 0;
                        matrix_8 <= 0;      
                    end       
                end
            
                s1_read: begin  //set next read to kernel 4
                    matrix_1 <= BRAM_PORTB_0_dout / 8; //assign top of kernel
                    BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr+5120; //set next read to middle 
                end
                
                s2_read: begin
                    matrix_4 <= BRAM_PORTB_0_dout / 4; //assign middle kernel
                    BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr+5120; //set next read to middle bottom
                    fsm_state <= s3_read;
                end

                s3_read: begin
                    matrix_7 <= BRAM_PORTB_0_dout / 8; //assign bottom kernel
                    case(target_pixel)
                        default: begin
                            BRAM_PORTB_0_addr <= (target_pixel - 1)*8; //set next read to top left
                            fsm_state <= s4_read;
                        end
                        0: begin
                            BRAM_PORTB_0_addr <= (target_pixel + 1) * 8; //set next read to top right
                            fsm_state <= s4_read;
                        end
                    endcase
                end
                
                s4_read: begin
                    case(target_pixel)
                        default: begin
                            matrix_0 <= BRAM_PORTB_0_dout / 16; //assign left top left kernel
                            BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr + 5120; //set next read to left 
                            fsm_state <= s5_read;
                        end
                        0: begin
                            matrix_2 <= BRAM_PORTB_0_dout /16; //assign top right kernel
                            BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr - 5120; //set next read to right
                            fsm_state <= s5_read;
                        end
                    endcase
                end
                
                s5_read: begin
                    case(target_pixel)
                        default: begin
                            matrix_3 <= BRAM_PORTB_0_dout / 8; //assign left kernel
                            BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr + 5120; //set next read to bottom left
                            fsm_state <= s6_read;
                        end
                        0: begin
                            matrix_5 <= BRAM_PORTB_0_dout / 8; //assign right kernel
                            BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr - 5120; //set next read to bottom right
                            fsm_state <= s6_read;
                        end
                    endcase
                end
                
                s6_read: begin
                    case(target_pixel)
                        default: begin
                            matrix_6 <= BRAM_PORTB_0_dout / 16; //assign bottom left kernel
                            BRAM_PORTB_0_addr <= (target_pixel + 1)*8; //set next read to top right
                            fsm_state <= (target_pixel == 639) ? s10_compute:s7_read;
                        end
                        0: begin
                            matrix_8 <= BRAM_PORTB_0_dout / 16; //assign bottom right kernel
                            fsm_state <= s10_compute; //six byes latched for compute
                        end
                    endcase
                end
                
                s7_read: begin
                    case(target_pixel)
                        default: begin
                            matrix_2 <= BRAM_PORTB_0_dout / 16; //assign top right kernel
                            BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr+5120; //set next read to right
                            fsm_state <= s8_read;
                        end
                    endcase
                end
                
                s8_read: begin
                    case(target_pixel)
                        default: begin
                            matrix_5 <= BRAM_PORTB_0_dout / 8; //assign right kernel
                            BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr+5120; //set next read to bottom right
                            fsm_state <= s9_read;
                        end
                    endcase
                end
                
                s9_read: begin
                    matrix_8 <= BRAM_PORTB_0_dout / 16; //assign bottom right
                    fsm_state <= s10_compute; //9 bytes latched, go to compute
                end
                
                s10_compute: begin
                    gssn_minion0_valid <= 1;
                    gssn_minion0_out <= matrix_0 + matrix_1 + matrix_2 + matrix_3 + matrix_4 + matrix_5 + matrix_6 + matrix_7 + matrix_8;
                    fsm_state <= s11_delay;
                end
                
                s11_delay: begin
                   fsm_state <= s0_default;
                   target_pixel <= target_pixel + 1;
                end
                
            endcase
        
        
        end
        
        0: begin //target row 0, first row
            case(fsm_state)
                s0_default: begin
                    matrix_0 <= 0; //reset latches 
                    matrix_1 <= 0;
                    matrix_2 <= 0;
                    matrix_3 <= 0;
                    matrix_4 <= 0;
                    matrix_5 <= 0;
                    matrix_6 <= 0;
                    matrix_7 <= 0;
                    matrix_8 <= 0;    
                    if(minion_compute_start) begin //start signal asserted
                        BRAM_PORTB_0_en <= 1; //enable port
                        BRAM_PORTB_0_addr <= (target_pixel * 8); //set next read to middle 
                        fsm_state <= s1_read;
                        gssn_minion0_ready <= 0;
                    end
                    else begin //else keep port disabled
                        BRAM_PORTB_0_en <= 0;
                        BRAM_PORTB_0_addr <= 0;
                        gssn_minion0_out <= 0;
                        gssn_minion0_valid <= 0;
                        target_pixel <= 0;
                        gssn_minion0_ready <= 1;     
                    end       
                end
            
                s1_read: begin  //set next read to kernel 4
                    matrix_4 <= BRAM_PORTB_0_dout / 8; //assign middle of kernel
                    BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr+5120; //set next read to bottom 
                end
                
                s2_read: begin
                    matrix_7 <= BRAM_PORTB_0_dout / 8; //assign bottom
                    fsm_state <= s3_read;
                    case(target_pixel)
                        0: begin
                            BRAM_PORTB_0_addr <= (target_pixel + 1) * 8; //set next read to right
                        end 
                        
                        default: begin
                            BRAM_PORTB_0_addr <= (target_pixel - 1)*8; //set next read to left
                        end                      
                    endcase
                end

                s3_read: begin
                    fsm_state <= s4_read;
                    case(target_pixel)
                        0: begin
                            matrix_5 <= BRAM_PORTB_0_dout /16; //assign right kernel
                            BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr + 5120; //set next read to bottom right
                        end
                        default: begin
                            matrix_3 <= BRAM_PORTB_0_dout / 8; //assign left kernel
                            BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr + 5120; //set next read to bottom left 
                        end
                    endcase
                end
                
                s4_read: begin
                    case(target_pixel)
                        0: begin
                            matrix_8 <= BRAM_PORTB_0_dout / 16; //assign bottom right kernel
                            fsm_state <= s10_compute; //have 4 bytes, compute
                        end
                        default: begin
                            matrix_6 <= BRAM_PORTB_0_dout / 16; //assign bottom left kernel
                            BRAM_PORTB_0_addr <= (target_pixel + 1) * 8; //set next read to right 
                            fsm_state <= s5_read; 
                        end
                    endcase
                end
                
                s5_read: begin
                    case(target_pixel)
                        default: begin
                            matrix_5 <= BRAM_PORTB_0_dout / 8; //assign right kernel
                            BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr + 5120; //set next read to bottom right
                            fsm_state <= s6_read;
                        end
                    endcase
                end
                
                s6_read: begin
                    case(target_pixel)
                        default: begin
                            matrix_8 <= BRAM_PORTB_0_dout / 16; //assign bottom right kernel
                            fsm_state <= s10_compute;
                        end 
                    endcase
                end
                    
                s10_compute: begin
                    gssn_minion0_valid <= 1;
                    gssn_minion0_out <= matrix_0 + matrix_1 + matrix_2 + matrix_3 + matrix_4 + matrix_5 + matrix_6 + matrix_7 + matrix_8;
                    fsm_state <= s11_delay;
                end
                
                s11_delay: begin
                   fsm_state <= s0_default;
                   target_pixel <= target_pixel + 1;
                end
            endcase
        end
        
        639: begin //target row 639, last row
            case(fsm_state)
                s0_default: begin
                    matrix_0 <= 0; //reset latches 
                    matrix_1 <= 0;
                    matrix_2 <= 0;
                    matrix_3 <= 0;
                    matrix_4 <= 0;
                    matrix_5 <= 0;
                    matrix_6 <= 0;
                    matrix_7 <= 0;
                    matrix_8 <= 0;    
                    if(minion_compute_start) begin //start signal asserted
                        BRAM_PORTB_0_en <= 1; //enable port
                        BRAM_PORTB_0_addr <= (target_pixel * 8); //set next read to top 
                        fsm_state <= s1_read;
                        gssn_minion0_ready <= 0;
                    end
                    else begin //else keep port disabled
                        BRAM_PORTB_0_en <= 0;
                        BRAM_PORTB_0_addr <= 0;
                        gssn_minion0_out <= 0;
                        gssn_minion0_valid <= 0;
                        target_pixel <= 0;
                        gssn_minion0_ready <= 1;     
                    end       
                end
            
                s1_read: begin  //set next read to kernel 4
                    matrix_1 <= BRAM_PORTB_0_dout / 8; //assign top of kernel
                    BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr+5120; //set next read to middle 
                end
                
                s2_read: begin
                    matrix_4 <= BRAM_PORTB_0_dout / 8; //assign middle
                    fsm_state <= s3_read;
                    case(target_pixel)
                        0: begin
                            BRAM_PORTB_0_addr <= (target_pixel + 1) * 8; //set next read to top right
                        end 
                        
                        default: begin
                            BRAM_PORTB_0_addr <= (target_pixel - 1)*8; //set next read to top left
                        end                      
                    endcase
                end

                s3_read: begin
                    fsm_state <= s4_read;
                    case(target_pixel)
                        0: begin
                            matrix_2 <= BRAM_PORTB_0_dout / 16; //assign top right kernel
                            BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr + 5120; //set next read to right
                        end
                        default: begin
                            matrix_3 <= BRAM_PORTB_0_dout / 8; //assign left kernel
                            BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr + 5120; //set next read to left 
                        end
                    endcase
                end
                
                s4_read: begin
                    case(target_pixel)
                        0: begin
                            matrix_5 <= BRAM_PORTB_0_dout / 16; //assign right kernel
                            fsm_state <= s10_compute; //have 4 bytes, compute
                        end
                        default: begin
                            matrix_3 <= BRAM_PORTB_0_dout / 16; //assign left kernel
                            BRAM_PORTB_0_addr <= (target_pixel + 1) * 8; //set next read to top right 
                            fsm_state <= (target_pixel == 639)? s10_compute:s5_read; 
                        end
                    endcase
                end
                
                s5_read: begin
                    case(target_pixel)
                        default: begin
                            matrix_2 <= BRAM_PORTB_0_dout / 8; //assign top right kernel
                            BRAM_PORTB_0_addr <= BRAM_PORTB_0_addr + 5120; //set next read to right
                            fsm_state <= s6_read;
                        end
                    endcase
                end
                
                s6_read: begin
                    case(target_pixel)
                        default: begin
                            matrix_8 <= BRAM_PORTB_0_dout / 16; //assign right kernel
                            fsm_state <= s10_compute;
                        end 
                    endcase
                end
                    
                s10_compute: begin
                    gssn_minion0_valid <= 1;
                    gssn_minion0_out <= matrix_0 + matrix_1 + matrix_2 + matrix_3 + matrix_4 + matrix_5 + matrix_6 + matrix_7 + matrix_8;
                    fsm_state <= s11_delay;
                end
                
                s11_delay: begin
                   fsm_state <= s0_default;
                   target_pixel <= target_pixel + 1;
                end         
            endcase
        end
        
        
        
    endcase
    end
end
    
    
    
endmodule
