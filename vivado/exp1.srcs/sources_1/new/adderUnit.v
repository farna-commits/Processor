`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



module adderUnit
#(parameter N =32)
(
    input [N-1:0]a,
    input [N-1:0]b,
    output [N-1:0]sum,
    output cout
);


//internal signals
    wire [N:0]c;    
    genvar i;    
    assign c[0] = 0;

//generate block 
generate 
    for(i=0;i<=N-1;i=i+1) begin
        fullAdder u1(a[i],b[i],c[i],sum[i],c[i+1]);    //instintiate sereval times
    end 
endgenerate

//final carry out 
assign cout = c[N];

endmodule
