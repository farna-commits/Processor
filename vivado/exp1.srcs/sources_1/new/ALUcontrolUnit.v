`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module ALUcontrolUnit
(
    input [1:0]ALUop, 
    input [2:0]in1,
    input in2,
    input memRead,
    output reg [3:0]ALUsel
);

always@(*)begin
    //I format
//    if(ALUop==2'b00)begin
//        ALUsel = 4'b0000;
//    end
    //branch
    if(ALUop==2'b01)begin
        ALUsel = 4'b0001;
    end
    
    //the rest 
    casex({ALUop,in1,in2, memRead})

        /////////////////////////////////////////////////////////R format///////////////////////////////////////////////
        7'b1000000: ALUsel <= 4'b00_00;   //Add
        7'b1000010: ALUsel <= 4'b00_01;   //Sub
        7'b1011100: ALUsel <= 4'b01_01;   //AND
        7'b1011000: ALUsel <= 4'b01_00;   //OR
        7'b1010000: ALUsel <= 4'b01_11;   //XOR
                 
        //shift  
        7'b1000100: ALUsel <= 4'b10_00;   //SLL 
        7'b1010100: ALUsel <= 4'b10_01;   //SRL
        7'b1010110: ALUsel <= 4'b10_10;   //SRA
                 
        //set on 
        7'b1001000: ALUsel <= 4'b11_01;   //SLT
        7'b1001100: ALUsel <= 4'b11_11;   //SLTU
    /////////////////////////////////////////////////////////R format///////////////////////////////////////////////
        
    /////////////////////////////////////////////////////////I format///////////////////////////////////////////////    
        7'b00110x0: ALUsel <= 4'b01_00;   //OR
        7'b00111x0: ALUsel <= 4'b01_01;   //AND
        7'b00100x0: ALUsel <= 4'b01_11;   //XOR
        7'b00010x1: ALUsel <= 4'b00_00;   //LW
        7'b00010x0: ALUsel <= 4'b11_01;   //SLTI
        7'b00011x0: ALUsel <= 4'b11_11;   //SLTU
    /////////////////////////////////////////////////////////I format///////////////////////////////////////////////
        
    endcase
        

end
endmodule
