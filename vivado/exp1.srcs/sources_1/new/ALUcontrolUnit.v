`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module ALUcontrolUnit
(
    input [1:0]ALUop, 
    input [2:0]in1,
    input in2,
    output reg [3:0]ALUsel
);

always@(*)begin
    //Load
    if(ALUop==2'b00)begin
        ALUsel = 4'b0000;
    end
    //branch
    if(ALUop==2'b01)begin
        ALUsel = 4'b0001;
    end
    
    //the rest 
    case({ALUop,in1,in2})

        
        6'b100000: ALUsel <= 4'b00_00;   //Add
        6'b100001: ALUsel <= 4'b00_01;   //Sub
        6'b101110: ALUsel <= 4'b01_01;   //AND
        6'b101100: ALUsel <= 4'b01_00;   //OR
        6'b101000: ALUsel <= 4'b01_11;   //XOR

        //shift 
        6'b100010: ALUsel <= 4'b10_00;   //SLL 
        6'b101010: ALUsel <= 4'b10_01;   //SRL
        6'b101011: ALUsel <= 4'b10_10;   //SRA

        //set on 
        6'b100100: ALUsel <= 4'b11_01;   
        6'b100110: ALUsel <= 4'b11_11;   
    endcase
        

end
endmodule
