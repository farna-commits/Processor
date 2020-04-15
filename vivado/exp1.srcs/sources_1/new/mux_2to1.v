`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



module mux_2to1
    #(parameter N=0)
(
input [N:0]a,
input [N:0]b,
input s,
output reg [N:0]out      
);

always@(*) begin
if(s) begin
    out = a;
end

else begin
    out = b;
end
end 

endmodule