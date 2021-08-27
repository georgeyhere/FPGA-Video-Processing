`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2021 03:25:14 PM
// Design Name: 
// Module Name: TMDS_2
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
// open sourced, see google drive for TMDS algorithm flowchart
//////////////////////////////////////////////////////////////////////////////////


module TMDS_encoder2 (
    input            clk,
    input            Reset,
    input            de,
    input      [1:0] ctrl,
    input      [7:0] din,
    output reg [9:0] dout
    );
    
    wire [3:0] Nb1s;
    wire XNOR;
    wire [8:0] q_m;
    reg [3:0] balance_acc;
    wire [3:0] balance;
    wire balance_sign_eq;
    wire invert_q_m;
    wire [3:0] balance_acc_inc;
    wire [3:0] balance_acc_new;
    wire [9:0] TMDS_data;
    wire [9:0] TMDS_code;
    
    assign Nb1s = din[0] + din[1] + din[2] + din[3] + din[4] + din[5] + din[6] + din[7];
    assign XNOR = (Nb1s>4'd4) || (Nb1s==4'd4 && din[0]==1'b0);
    assign q_m = {~XNOR, q_m[6:0] ^ din[7:1] ^ {7{XNOR}}, din[0]};
    
    assign balance = q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7] - 4'd4;
    assign balance_sign_eq = (balance[3] == balance_acc[3]);
    assign invert_q_m = (balance==0 || balance_acc==0) ? ~q_m[8] : balance_sign_eq;
    
    assign balance_acc_inc = balance - ({q_m[8] ^ ~balance_sign_eq} & ~(balance==0 || balance_acc==0));
    assign balance_acc_new = invert_q_m ? balance_acc-balance_acc_inc : balance_acc+balance_acc_inc;
    assign TMDS_data = {invert_q_m, q_m[8], q_m[7:0] ^ {8{invert_q_m}}};
    assign TMDS_code = ctrl[1] ? (ctrl[0] ? 10'b1010101011 : 10'b0101010100) : (ctrl[0] ? 10'b0010101011 : 10'b1101010100);
    
    initial begin
        dout <= 0;
        balance_acc <= 0;
    end
    
    
    always@(posedge clk, posedge Reset) begin
        if(Reset == 1'b1) begin
            dout <= 0;
            balance_acc <= 0;
        end
        else begin
            dout <= de ? TMDS_data : TMDS_code;
            balance_acc <= de ? balance_acc_new:4'h0;
        end
    end

endmodule