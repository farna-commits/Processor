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
    output reg regwrite
   
    );
    
    
    always@(*)begin
        case (inst[6:2])
            5'b01100: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite} = 8'b00010001;   //r
            5'b00000: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite} = 8'b01100011;   //lw
            5'b01000: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite} = 8'b00000110;   //sw
            5'b11000: {branch,memread,mem2reg,ALUop[1:0],memwrite,ALUsrc,regwrite} = 8'b10001000;   //beq       
        endcase
        
    end
endmodule
