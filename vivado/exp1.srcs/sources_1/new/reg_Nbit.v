`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



module reg_Nbit
#(parameter N=32)
(
    input clk,
    input en,
    input rst,
    input [N-1:0]D,
    output  [N-1:0]Q
);
 
wire [N-1:0] tempout;
wire [N-1:0] tempin;

//generate block 
genvar i;
generate 
    for(i=0;i<=N-1;i=i+1) begin
        mux_2to1   m1(.s(en), .a(D[i]), .b(tempin[i]), .out(tempout[i])); //mux
        ff         ff1(.clk(clk), .rst(rst), .D(tempout[i]), .Q(tempin[i])); //ff
    end 
endgenerate


assign Q = tempin;
endmodule