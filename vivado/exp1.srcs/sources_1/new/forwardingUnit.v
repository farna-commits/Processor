
/*******************************************************************
*
* Module: forwardingUnit.v
* Project: Processor
* Author: Osama El Farnawani & Hana Asal
* Description: Forwarding Unit to handle data hazards.
*
* Created: 02/05/2020
*
**********************************************************************/
module forwardingUnit
(
    input [4:0] IDEX_RegisterRs1,
    input [4:0] IDEX_RegisterRs2,
    input [4:0] EXMEM_RegisterRd,
    input [4:0] MEMWB_RegisterRd,
    input       EXMEM_RegWrite,         
    input       MEMWB_RegWrite,
    output reg [1:0]forwardA,
    output reg [1:0]forwardB
 );
 
    always@(*) begin
    
        //EX Hazard A
        if ((EXMEM_RegWrite && (EXMEM_RegisterRd != 0) && (EXMEM_RegisterRd == IDEX_RegisterRs1)) && !(MEMWB_RegWrite && (MEMWB_RegisterRd != 0) && (MEMWB_RegisterRd == IDEX_RegisterRs1))) begin        
            forwardA = 2'b10;
        end else begin
            //MEM Hazard A
            if(MEMWB_RegWrite && (MEMWB_RegisterRd != 0) && (MEMWB_RegisterRd == IDEX_RegisterRs1)) begin
                forwardA = 2'b01;    
            end else begin
            //default case
            forwardA = 2'b00;
            end
        end
        //EX Hazard B
        if(EXMEM_RegWrite && (EXMEM_RegisterRd != 0) && (EXMEM_RegisterRd == IDEX_RegisterRs2) && !(MEMWB_RegWrite && (MEMWB_RegisterRd != 0) && (MEMWB_RegisterRd == IDEX_RegisterRs2))) begin        
            forwardB = 2'b10;
        end else begin               
            //MEM Hazard B
            if(MEMWB_RegWrite && (MEMWB_RegisterRd != 0) && (MEMWB_RegisterRd == IDEX_RegisterRs2)) begin
                forwardB = 2'b01;    
            end else begin
                forwardB = 2'b00;
                end
        end                             
    end
 
endmodule
