`include "defines.v"
module ALUcontrolUnit
(
    input [1:0]ALUop, 
    input [2:0]in1,
    input in2,
    input [6:0]opcode,
    output reg [3:0]ALUsel
);

always@(*)begin
    
    //the rest 
    casex({ALUop,in1,in2, opcode})

        /////////////////////////////////////////////////////////R format///////////////////////////////////////////////
        `ALUCUADD   : ALUsel = `ALU_ADD;   //Add
        `ALUCUSUB   : ALUsel = `ALU_SUB;   //Sub
        `ALUCUAND   : ALUsel = `ALU_AND;   //AND
        `ALUCUOR    : ALUsel = `ALU_OR;   //OR
        `ALUCUXOR   : ALUsel = `ALU_XOR;   //XOR                        
        `ALUCUSLL   : ALUsel = `ALU_SLL;   //SLL 
        `ALUCUSRL   : ALUsel = `ALU_SRL;   //SRL
        `ALUCUSRA   : ALUsel = `ALU_SRA;   //SRA                     
        `ALUCUSLT   : ALUsel = `ALU_SLT;   //SLT
        `ALUCUSLTU  : ALUsel = `ALU_SLTU;   //SLTU
    /////////////////////////////////////////////////////////R format///////////////////////////////////////////////
        
    /////////////////////////////////////////////////////////I format///////////////////////////////////////////////    
        `ALUCUORI  : ALUsel = `ALU_OR;   //OR
        `ALUCUANDI : ALUsel = `ALU_AND;   //AND
        `ALUCUXORI : ALUsel = `ALU_XOR;   //XOR
        `ALUCUSLTI : ALUsel = `ALU_SLT;   //SLTI
        `ALUCUSLTUI: ALUsel = `ALU_SLTU;   //SLTU
        `ALUCUJALR : ALUsel = `ALU_ADD;   //JALR
        `ALUCULW   : ALUsel = `ALU_ADD;   //LW
        `ALUCULH   : ALUsel = `ALU_ADD;   //LH
        `ALUCULB   : ALUsel = `ALU_ADD;   //LB
        `ALUCULHU  : ALUsel = `ALU_ADD;   //LHU
        `ALUCULBU  : ALUsel = `ALU_ADD;   //LBU        
        `ALUCUSLLI : ALUsel = `ALU_SLLI;   //SLLI 
        `ALUCUSRLI : ALUsel = `ALU_SRLI;   //SRLI 
        `ALUCUSRAI : ALUsel = `ALU_SRAI;   //SRAI  
    /////////////////////////////////////////////////////////I format///////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////UJ format///////////////////////////////////////////////
        `ALUCUJAL: ALUsel = `ALU_ADD;   //JAL
    ////////////////////////////////////////////////////////UJ format///////////////////////////////////////////////

    /////////////////////////////////////////////////////////S format///////////////////////////////////////////////
        `ALUCUSW: ALUsel = `ALU_ADD;   //SW
        `ALUCUSH: ALUsel = `ALU_ADD;   //SH
        `ALUCUSB: ALUsel = `ALU_ADD;   //SB
    /////////////////////////////////////////////////////////S format///////////////////////////////////////////////

   /////////////////////////////////////////////////////////SB format///////////////////////////////////////////////
        `ALUCUBEQ : ALUsel = `ALU_SUB;  //BEQ
        `ALUCUBNE : ALUsel = `ALU_SUB;  //BNE     
        `ALUCUBLT : ALUsel = `ALU_SUB;  //BLT 
        `ALUCUBGE : ALUsel = `ALU_SUB;  //BGE   
        `ALUCUBLTU: ALUsel = `ALU_SUB;  //BLTU  
        `ALUCUBGEU: ALUsel = `ALU_SUB;  //BGEU         
   /////////////////////////////////////////////////////////SB format///////////////////////////////////////////////
        `ALUCULUI : ALUsel = `ALU_LUI;   //lui
    endcase
        

end
endmodule
