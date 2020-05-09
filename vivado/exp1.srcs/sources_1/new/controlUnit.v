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
    output reg ebreak_flag,
    output reg auipcBit
    );
    
    initial begin 
        ebreak_flag = 1;
    end
    
    always@(*)begin     
        if (~E) begin 
            ebreak_flag = 0;
        end
    end
    reg E;     
    always@(*)begin
        casex ({inst[6:2], ebit})
            `CU_R           : {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00010001010;   //r
            `CU_LW          : {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b01100011010;   //lw
            `CU_S           : {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00000110010;   //S
            `CU_SB          : {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b10001000010;   //SB  
            `CU_IARITH      : {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00000011010;   //I format (arith)  
            `CU_IJALR       : {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00000011110;   //I format (JALR)  
            `CU_UJJAL       : {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b10001011110;   //UJ format (JAL)
            `CU_EBREAK      : {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00000000000;   //EBREAK,  
            `CU_ECALLCSR    : {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00000000010;   // ECALL, CSR: (csrrw, csrrs, csrrc, csrrwi, csrrci)
            `CU_FENCE       : {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00000000010;   //Fence, fence.i      
            `CU_AUIPC       : {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00001001011;   //auipc  
            `CU_LUI         : {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite,JUMP,E,auipcBit} = 11'b00001011010;   //lui     
        endcase
        
    end
endmodule
