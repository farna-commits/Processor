`timescale 1ns / 1ps
/*******************************************************************
*
* Module: forwardingUnit2.v
* Project: Processor
* Author: All of us
* Description: Forwarding Unit to handle data hazards.
*
* Created: 11/05/2020
*
**********************************************************************/



module forwardingUnit2
(
    input [4:0] RegisterRs1,
    input [4:0] RegisterRs2,
    input [4:0] EXMEM_RegisterRd,
    input [4:0] MEMWB_RegisterRd,
    input       EXMEM_RegWrite,         
    input       MEMWB_RegWrite,
    output reg [1:0]forwardA2,
    output reg [1:0]forwardB2
);

    always@(*) begin
    
        //EX Hazard A
        if ((EXMEM_RegWrite && (EXMEM_RegisterRd != 0) && (EXMEM_RegisterRd == RegisterRs1)) && !(MEMWB_RegWrite && (MEMWB_RegisterRd != 0) && (MEMWB_RegisterRd == RegisterRs1))) begin        
            forwardA2 = 2'b10;
        end else begin
            //MEM Hazard A
            if(MEMWB_RegWrite && (MEMWB_RegisterRd != 0) && (MEMWB_RegisterRd == RegisterRs1)) begin
                forwardA2 = 2'b01;    
            end else begin
            //default case
            forwardA2 = 2'b00;
            end
        end
        //EX Hazard B
        if(EXMEM_RegWrite && (EXMEM_RegisterRd != 0) && (EXMEM_RegisterRd == RegisterRs2) && !(MEMWB_RegWrite && (MEMWB_RegisterRd != 0) && (MEMWB_RegisterRd == RegisterRs2))) begin        
            forwardB2 = 2'b10;
        end else begin               
            //MEM Hazard B
            if(MEMWB_RegWrite && (MEMWB_RegisterRd != 0) && (MEMWB_RegisterRd == RegisterRs2)) begin
                forwardB2 = 2'b01;    
            end else begin
                forwardB2 = 2'b00;
                end
        end                             
    end
endmodule
