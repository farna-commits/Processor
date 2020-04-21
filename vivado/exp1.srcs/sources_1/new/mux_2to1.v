`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



module mux_2to1
#(parameter N=0)
(
    input [N-1:0]a,
    input [N-1:0]b,
    input s,
    output reg [N-1:0]out      
);

//s=1 pass a, else b
always@(*) begin
    if(s) begin
        out = a;
    end

    else begin
        out = b;
    end
end 

endmodule