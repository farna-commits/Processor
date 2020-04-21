/*******************************************************************
*
* Module: branchGate.v
* Project: Processor
* Author: Hana Asal, hana_asal@aucegypt.edu
* Description: 4 to 1 MUX
*
* Created: 19/4/2020
**********************************************************************/
module mux_4to1 
#(parameter N=0)
(
    input [N-1:0] a,
    input [N-1:0]b,
    input[N-1:0] c, 
    input[N-1:0] d,
    input [N-1:0]s, 
    output reg [N-1:0]out 
 );
 always @(*)
    begin
        if(s == 2'b00)
        begin
          out=b;
        end else if (s == 2'b01) begin 
            out=a;
        end else if (s == 2'b10) begin 
             out=c;
        end else if (s == 2'b11) begin 
             out=d;
        end      
    end
endmodule