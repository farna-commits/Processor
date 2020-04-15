`timescale 1ns / 1ps


module shifter_nBit
    #(parameter N=32 )
(
input [N-1:0]a,
output [N-1:0]out
);

assign out = {a[N-2:0],1'b0};
endmodule