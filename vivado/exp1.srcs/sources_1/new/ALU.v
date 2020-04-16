`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module ALU
#(parameter N =32)
(
    input wire  [N-1:0]a,
    input wire [N-1:0]b,
    input wire [N-1:0]  shamt,
    input wire [3:0]selection,
    output reg [N-1:0]out,
    output wire ZF, CF, VF, SF
);
    //internal signals
    wire cout;
    wire [N-1:0]add;
    wire [N-1:0]sub;
    wire cfa, cfs;
    wire [N-1:0] sh;
   
    //inst 
    shifter sh1 (.a(a), .shamt(shamt), .type(selection[1:0]), .r(sh));
    
    //plus/minus
    assign {CF, add} = selection[0] ? (a + (~b) + 1'b1) : (a + b);
    
    //flags
    assign ZF = (add == 0); //zero
    assign SF = add[31];    //sign
    assign VF = (a[31] ^ (~(b[31])) ^ add[31] ^ CF);    //overflow  
    
    //Control Unit
    always@(*) begin
        out = 0;
        (* parallel_case *)
        case(selection)
            4'b00_00 : out  = add;  //add
            4'b00_01 : out  = add;  //sub
            4'b00_11 : out  = b;    
            // logic   
            4'b01_00:  out  = a | b;    //OR
            4'b01_01:  out  = a & b;    //AND
            4'b01_11:  out  = a ^ b;    //XOR
            // shift   
            4'b10_00:  out  =sh;        //sll
            4'b10_01:  out  =sh;        //SRL
            4'b10_10:  out  =sh;        //sra
            // slt & sltu
            4'b11_01:  out = {31'b0,(SF != VF)};    //SLTU
            4'b11_11:  out = {31'b0,(~CF)};         //SLT
        endcase

    end

endmodule