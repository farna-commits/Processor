`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module mux_4to1 
#(parameter N=0)
(
    input [ N:0] a,
    input [N:0]b,
    input[N:0] c, 
    input[N:0] d,
    input [N:0]s, 
    output reg [N:0]out 
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