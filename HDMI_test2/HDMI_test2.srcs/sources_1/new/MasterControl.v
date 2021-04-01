`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2021 08:07:38 PM
// Design Name: 
// Module Name: MasterControl
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


module MasterControl(
    input       Clk,
    input       Reset,
    input       StartButton,
    input       ConfigureDone,
    
    output reg  camResetn,       // ov7670 active low reset
    output reg  camPwdn,         // ov7670 active high power down
    output reg  ConfigureStart,
    output reg  SystemStart
    );
    
// ===========================================================================
// 			         Parameters, Registers, and Wires
// ===========================================================================    
    reg [1:0] FSM_State;
    
    localparam s0_idle = 2'b00;
    localparam s1_configure = 2'b01;
    localparam s2_operate = 2'b10;
    
// ===========================================================================
//                              Implementation    
// ===========================================================================    
    initial begin
        ConfigureStart <= 0;
        SystemStart <= 0;
        camResetn <= 0;
        camPwdn <= 0;
    end
    
    always@(posedge Clk, posedge Reset) begin
        if(Reset == 1'b1) begin
            FSM_State <= 0;
            ConfigureStart <= 0;
            SystemStart <= 0;
            camResetn <= 0;
            camPwdn <= 0;
        end
        else begin
            case(FSM_State) 
            
                s0_idle: begin
                    FSM_State <= (StartButton) ? s1_configure:s0_idle;
                end
                
                s1_configure: begin
                    FSM_State <= (ConfigureDone) ? s2_operate:s1_configure;
                end
                
                s2_operate: begin
                    FSM_State <= s2_operate;
                end
            endcase
        end
    end
    
    always@(posedge Clk) begin
        case(FSM_State) 
        
            s0_idle: begin
                ConfigureStart <= (StartButton) ? 1:0;
                SystemStart <= 0;
                camResetn <= 1;                
            end
            
            s1_configure: begin
                ConfigureStart <= 1;
                SystemStart <= 0;
            end
            
            s2_operate: begin
                ConfigureStart <= 0;
                SystemStart <= 1;
            end
        endcase
    end
       
endmodule
