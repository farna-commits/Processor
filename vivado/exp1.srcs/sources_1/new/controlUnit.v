`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module controlUnit
(
    input [6:0]inst,
    output reg branch, 
    output reg memread,
    output reg mem2reg,
    output reg [1:0]ALUop,
    output reg memwrite,
    output reg ALUsrc,
    output reg regwrite,
    output reg JUMP
    );
    
    
    always@(*)begin
        case (inst[6:2])
            5'b01100: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP} = 9'b000100010;   //r
            5'b00000: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP} = 9'b011000110;   //lw
            5'b01000: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP} = 9'b000001100;   //sw
            5'b11000: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP} = 9'b100010000;   //beq  
            5'b00100: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP} = 9'b000000110;   //I format (arith)  
            5'b11001: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP} = 9'b000000111;   //I format (JALR)  
            5'b11011: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP} = 9'b100010111;   //UJ format (JAL)  

        endcase
        
    end
endmodule
