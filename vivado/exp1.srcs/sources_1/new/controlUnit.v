`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module controlUnit
(
    input [6:0]inst,
    input ebit,    
    output reg branch, 
    output reg memread,
    output reg mem2reg,
    output reg [1:0]ALUop,
    output reg memwrite,
    output reg ALUsrc,
    output reg regwrite,
    output reg JUMP,
    output reg E,
    output reg auipcBit
    );
    
    
    always@(*)begin
        casex ({inst[6:2], ebit})
            6'b01100_x: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00010001010;   //r
            6'b00000_x: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b01100011010;   //lw
            6'b01000_x: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00000110010;   //sw
            6'b11000_x: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b10001000010;   //beq  
            6'b00100_x: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00000011010;   //I format (arith)  
            6'b11001_x: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00000011110;   //I format (JALR)  
            6'b11011_x: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b10001011110;   //UJ format (JAL)
            6'b11100_1: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00000000000;   //EBREAK,  
            6'b11100_0: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00000000010;   // ECALL, CSR: (csrrw, csrrs, csrrc, csrrwi, csrrci)
            6'b00011_x: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00000000010;   //Fence, fence.i      
            6'b00101_x: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00001001011;   //auipc  
            6'b01101_x: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00001011010;   //lui     
        endcase
        
    end
endmodule
