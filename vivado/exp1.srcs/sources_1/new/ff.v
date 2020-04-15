`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module ff
(
    input D,
    input rst,
    input clk,
    output reg Q
);

always@(posedge clk or negedge rst) begin
    if(!rst) begin
        Q <= 0;
    end
    else begin
        Q <= D;
    end
end
endmodule
