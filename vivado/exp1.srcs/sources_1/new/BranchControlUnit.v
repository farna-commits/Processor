`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: BranchControlUnit.v
* Project: Processor
* Author: All of us
* Description: Branch brought to the ID stage and for fixing hazards
*
* Created: 11/05/2020
*
**********************************************************************/


module BranchControlUnit
#(parameter N = 32)
(
    input wire [4:0]op1,
    input wire [4:0]op2, 
    input wire [4:0]LoadRd,
    input wire [4:0]BranchSrc1, 
    input wire [4:0]BranchSrc2,
    input wire [N-1:0]a,
    input wire [N-1:0]b,
    input wire [N-1:0]offset,
    input wire [12:0]selection,    
    output reg ZF, NEF, GTEF, LTF, LTUF, GEUF,
    output reg [N-1:0]jalRout,
    output reg stall
);

    //internal 
    wire [N-1:0]sub, op_b;
    assign op_b = (~b);
    //abs calc
    reg [N-1:0]abs1;
    reg [N-1:0]abs2;
    //a-b
    assign sub = (a + op_b + 1'b1);

    //branching 
    always@(*) begin     
        if ((selection == `BEQ1) || (selection == `BEQ2)) begin 
            ZF   = (sub == 0); //zero
            NEF  = (~ZF); //bne
            GTEF = (sub[N-1] == 1'b0); //bge
            LTF  = (sub[N-1] == 1'b1); //blt
            LTUF = (abs1 < abs2);
            GEUF = (abs1 >= abs2);
        end else begin 
            ZF   = 0;
            NEF  = 0;
            GTEF = 0;
            LTF  = 0;
            LTUF = 0;
            GEUF = 0;
        end
    end

    //jalr
    always @(*) begin 
        if ((selection == `JALR1) || (selection == `JALR2)) begin 
            jalRout = a + offset;
        end
    end

    //hazard
    always @(*) begin 
      //stall = 0;
        if ( ((op1 == `OPCODE_Branch) || (op1 == `OPCODE_JALR)) && ((op2 == `OPCODE_Load)) ) begin
            if ( (BranchSrc1 == LoadRd) || (BranchSrc2 == LoadRd) ) begin
                stall =1;            
            end else begin 
                stall =0;
            end
        end else begin
            stall =0;
        end
    end
    //Getting Absolute Value of inputs
    always @(*) begin 
        if (a[N-1] == 1'b1) begin
            abs1 = -a;
        end else begin
            abs1 = a;
        end
        if (b[N-1] == 1'b1) begin
            abs2 = -b;
        end else begin
            abs2 = b;
        end
    end

endmodule
