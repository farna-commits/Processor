`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module ALU
#(parameter N =32)
(
    input [N-1:0]a,
    input [N-1:0]b,
    input [3:0]selection,
    output reg [N-1:0]out,
    output reg ZF
);
    //internal signals
    wire cout;
    wire [N-1:0]add;
    wire [N-1:0]sub;
    
    
    //inst
    adderUnit a1(.a(a), .b(b), .sum(add), .cout(cout));
    adderUnit a2(.a(a), .b(~b+1), .sum(sub), .cout(cout));
   
    
    //Control Unit
    always@(*) begin
        case(selection)
            4'b0010: out <= add;    //add
            4'b0110: out <= sub;    //sub
            4'b0000: out <= a&b;    //AND
            4'b0001: out <= a|b;    //OR
            default: out <= 0;
        endcase
        if (out==0) begin
            ZF <= 1;
        end else begin
            ZF <= 0;
        end
    
    end

endmodule