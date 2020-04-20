`include "defines.v"

/*******************************************************************
*
* Module: branchGate.v
* Project: Processor
* Author: Osama El Farnawani, farna@aucegypt.edu
* Description: to determine whether a branch will happen or not
*
* Created: 20/4/2020
* Change history: 01/01/17 - Did something
* 10/29/17 - Did something else
*
**********************************************************************/


module branchGate
(
    input zf, nef, gtef, ltf, ltuf, geuf,
    input branch, 
    input [2:0]func3,
    output reg Branching    
);

    always@(*) begin
        Branching = 0;
        if (branch) begin    
            if (zf && (func3 == 3'b000)) begin 
                Branching = 1;
            end else if (nef && (func3 == 3'b001))begin
                Branching = 1;
            end else if (gtef && (func3 == 3'b101))begin
                Branching = 1;
            end else if (ltf && (func3 == 3'b100))begin
                Branching = 1;
            end else if (ltuf && (func3 == 3'b110))begin
                Branching = 1;
            end else if (geuf && (func3 == 3'b111))begin
                Branching = 1;
            end else begin
                Branching = 0;
            end   
        end
    end
endmodule
