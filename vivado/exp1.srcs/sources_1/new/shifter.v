`include "defines.v"

/*******************************************************************
*
* Module: shifter.v
* Project: Single Cycle RISC-V
* Author: Salma Afifi, salmaafifi98@aucegypt.edu
* Description: This is a shifter for the ALU.
*
* Change history: 16/4/2020 – File Created
*
**********************************************************************/


module shifter
#(parameter N = 32)
(
    input [N-1:0] a,
    input [N-1:0] shamt,
    input [1:0] type, 
    output reg [N-1:0] r 
);

    wire signed [N-1:0]asigned;
    assign asigned = a;

    always @(*) begin         
        case (type)            
		    2'b01:        r = a >>  shamt; //SLR
            2'b00:        r = a <<  shamt; //SLL
            2'b10:        r = asigned >>> shamt; //SRA
            default:      r = a;        
        endcase            
    end

endmodule
