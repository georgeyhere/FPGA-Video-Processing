`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2021 06:59:18 PM
// Design Name: 
// Module Name: CamRead_output
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


module CamRead_Output(
    input            Clk_100MHz,
    input            PClk,
    input            Reset,
    input            SystemStart,
    input            href,       // camera href goes high at start of row transmission
    
    input            FIFO_Empty, // FIFO empty flag, active high
    input            FIFO_WrAck, // FIFO write acknowledge, active high
    input      [7:0] FIFO_Dout,
    
    output reg       rd_en,
    output reg [7:0] Red,
    output reg [7:0] Green,
    output reg [7:0] Blue
    );
    
    reg [1:0] FSM_State;
    reg [1:0] FSM_NextState;
    reg [3:0] Counter;
    localparam s0_Idle  = 2'b00;
    localparam s1_Read  = 2'b01;
    localparam s2_Timer = 2'b10;
    
    reg       HalfID;
    reg [7:0] RedLatch;
    reg [7:0] GreenLatch;
    reg [7:0] BlueLatch;
    
    initial begin
    
    end
    
    always@(posedge Clk_100MHz, posedge Reset) begin
        if(Reset == 1'b1) begin
            FSM_State <= s0_Idle;
            FSM_NextState <= s0_Idle;
            Counter <= 0;
        end
        else begin
            case(FSM_State)
            ////////////////////////////////////////////////////////////////
                s0_Idle: begin
                    if(SystemStart) 
                        FSM_State <= (FIFO_WrAck) ? s1_Read : s0_Idle; 
                    else 
                        FSM_State <= s0_Idle;
                end
                
            ////////////////////////////////////////////////////////////////
                s1_Read: begin
                    if(href == 1) begin // href = 1, data transmission ongoing
                        case(HalfID) 
                            0: begin                      // HalfID = 0, currently reading first half of dataframe
                                FSM_State <= s2_Timer;    // go to timer, wait for next write
                                FSM_NextState <= s1_Read;
                                Counter <= 3;
                            end
                        
                            1: begin
                                FSM_State <= (PClk == 0) ? s0_Idle : s2_Timer; // if PClk = 1, then negedge hasn't occured yet
                                FSM_NextState <= s1_Read;                      // no negedge -> no new data, goto timer and come back
                                Counter <= 3;
                            end
                        endcase
                    end
                    else begin  // href = 0, data transmission done but FIFO still contains second half of last pixel
                        FSM_State <= s0_Idle; 
                    end
                end
                
            /////////////////////////////////////////////////////////////////
                s2_Timer: begin
                    FSM_State <= FSM_NextState;
                end
           /////////////////////////////////////////////////////////////////
            endcase
        end
    end
    
    always@(posedge Clk_100MHz, posedge Reset) begin
        if(Reset == 1'b1) begin
            rd_en <= 0;
            HalfID <= 0;
            RedLatch <= 0;
            GreenLatch <= 0;
            BlueLatch <= 0;
            Red <= 0;
            Green <= 0;
            Blue <= 0;
        end
        else begin
            case(FSM_State)
            //////////////////////////////////////////////////////////////// 
                s0_Idle: begin
                    rd_en <= (FIFO_WrAck) ? 1:0;
                    HalfID <= 0;
                end
                
            ////////////////////////////////////////////////////////////////    
                s1_Read: begin
                    if(href == 1) begin // href = 1, row transmission still ongoing
                        case(HalfID)
                            0: begin
                                RedLatch[7:3]   <= FIFO_Dout[6:2];
                                GreenLatch[7:6] <= FIFO_Dout[1:0];
                            end
                        
                            1: begin
                                Red        <= RedLatch;
                                Green[7:6] <= GreenLatch[7:6];
                                Green[7:6] <= FIFO_Dout [7:5];
                                Blue [7:3] <= FIFO_Dout[4:0];
                                HalfID     <= 0;
                            end
                        endcase
                    end
                    else begin  // href = 0, row transmission ended
                    // assign outputs; same as HalfID == 1
                        Red        <= RedLatch;
                        Green[7:6] <= GreenLatch[7:6];
                        Green[7:6] <= FIFO_Dout [7:5];
                        Blue [7:3] <= FIFO_Dout[4:0];
                    end
                end
                
            ////////////////////////////////////////////////////////////////  
                s2_Timer: begin
                    Counter <= (Counter == 0) ? 0 : (Counter - 1'b1);
                end
            ////////////////////////////////////////////////////////////////     
            endcase
        end
    end
endmodule
