`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"
module ALU
#(parameter N =32)
(
    input wire [N-1:0]a,
    input wire [N-1:0]b,
    input wire [4:0]  shamt,
    input wire [3:0]selection,
    output reg [N-1:0]out,
    output wire CF, VF, SF
);

    //internal signals
    wire cout;
    wire [N-1:0]add, op_b, op_b2;
    wire [N-1:0]sub;
    wire cfa, cfs;
    wire [N-1:0] sh;
    //abs calc
    reg [N-1:0]abs1;
    reg [N-1:0]abs2;
    //inst 
    shifter sh1 (.a(a), .shamt(shamt), .type(selection[1:0]), .r(sh));
    
    //plus/minus
    assign {CF, add} = selection[0] ? (a + op_b2 + 1'b1) : (a + b);
    assign op_b = (~b);
    assign op_b2 = (~abs2);
    //flags
    //assign ZF   = (add == 0); //zero
    assign SF   = add[N-1];    //sign
    assign VF   = (a[N-1] ^ (op_b[N-1]) ^ add[N-1] ^ CF);    //overflow  
    //Control Unit
    always@(*) begin
        out = 0;
        (* parallel_case *)
        case(selection)
               
            `ALU_ADD    : out   = add;                      //add
            `ALU_SUB    : out   = add;                      //sub
            `ALU_LUI   : out   = b;                        //lui
            // logic            
            `ALU_OR     :  out  = a | b;                    //OR
            `ALU_AND    :  out  = a & b;                    //AND
            `ALU_XOR    :  out  = a ^ b;                    //XOR
            // shift        
            `ALU_SLLI  :  out  =   sh;                     //slli
            `ALU_SRLI   :  out  =   sh;                     //SRLi
            `ALU_SRAI   :  out  =   sh;                     //srai
             // shift       
            `ALU_SLL    :  out  =   a <<  b;                //sll
            `ALU_SRL    :  out  =   a >>  b;                //SRL
            `ALU_SRA    :  out  =   $signed(a) >>> b;       //sra
            // slt & sltu
            `ALU_SLT    :  out  = {31'b0,(SF != VF)};       //SLT
            `ALU_SLTU   :  out  = {31'b0,(~CF)};            //SLTU 
        endcase
    end
    
        //Getting Absolute Value of inputs
        always @(*) begin 
            if (a[N-1] == 1'b1) begin
                abs1 = -a;
            end else begin
                abs1 = a;
            end
            if (b[N-1] == 1'b1) begin
                abs2 = -b;
            end else begin
                abs2 = b;
            end
        end

endmodule