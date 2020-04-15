`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module fullAdder
(
    input a,
input b,
input cin,
output  sum,
output  cout
);

assign {cout,sum} = a+b+cin;
endmodule

