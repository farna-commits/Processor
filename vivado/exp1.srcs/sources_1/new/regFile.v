`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



module regFile
#(parameter N=32)
(
    input [4:0]r1,
    input [4:0]r2,
    input [4:0]wr,
    input [N-1:0]wd,
    input wen,
    input clk,
    input rst,
    
    output [N-1:0]rdata1,
    output [N-1:0]rdata2
);

//2d array
wire [N-1:0] Registers[0:31];   //32 registers in the file of N bits

wire [N-1:0]cond;

assign Registers[0] = 0;
//generate block
genvar i;
generate
    for(i=1;i<=N-1;i=i+1) begin
        assign cond[i] = (wen && (i==wr)) ? 1'b1 : 1'b0;
        reg_Nbit rm1(.clk(clk), .en(cond[i]), .D(wd), .Q(Registers[i]), .rst(rst)); //enable if enable AND register we are at is i        
    end
endgenerate

//MUX to choose 2 registers at a time
assign rdata1=Registers[r1];
assign rdata2=Registers[r2];
endmodule
