`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module ALU
#(parameter N =32)
(
    input wire [N-1:0]a,
    input wire [N-1:0]b,
    input wire [4:0]  shamt,
    input wire [3:0]selection,
    output reg [N-1:0]out,
    output wire ZF, CF, VF, SF, NEF, GTEF, LTF, LTUF, GEUF
);
    //internal signals
    wire cout;
    wire [N-1:0]add, op_b;
    wire [N-1:0]sub;
    wire cfa, cfs;
    wire [N-1:0] sh;
    //abs calc
    reg [N-1:0]abs1;
    reg [N-1:0]abs2;
    //inst 
    shifter sh1 (.a(a), .shamt(shamt), .type(selection[1:0]), .r(sh));
    
    //plus/minus
    assign {CF, add} = selection[0] ? (a + op_b + 1'b1) : (a + b);
    assign op_b = (~b);
    //flags
    assign ZF   = (add == 0); //zero
    assign SF   = add[31];    //sign
    assign VF   = (a[31] ^ (op_b[31]) ^ add[31] ^ CF);    //overflow  
    assign NEF  = (~ZF); //bne
    assign GTEF = (add[31] == 1'b0); //bge
    assign LTF  = (add[31] == 1'b1); //blt
    assign LTUF = (abs1 < abs2);
    assign GEUF = (abs1 >= abs2);
    //Control Unit
    always@(*) begin
        out = 0;
        (* parallel_case *)
        case(selection)
            
            //op codes used: 0,1,3,4,5,7,8,9,10,13,15
            //////////////////////////////////////////////R format//////////////////////////////////////////////////////////////       
            4'b00_00 : out  = add;  //add
            4'b00_01 : out  = add;  //sub
            4'b00_11 : out  = b;    //lui
            // logic   
            4'b01_00:  out  = a | b;    //OR
            4'b01_01:  out  = a & b;    //AND
            4'b01_11:  out  = a ^ b;    //XOR
            // shift   
            4'b10_00:  out  =   sh;        //slli
            4'b10_01:  out  =   sh;        //SRLi
            4'b10_10:  out  =   sh;        //srai
             // shift 
            4'b00_10:  out  =   a <<  b;        //sll
            4'b01_10:  out  =   a >>  b;        //SRL
            4'b10_11:  out  =   $signed(a) >>> b;        //sra
            // slt & sltu
            4'b11_01:  out  = {31'b0,(SF != VF)};   //SLT
            4'b11_11:  out  = {31'b0,(~CF)};        //SLTU 
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //////////////////////////////////////////////I format//////////////////////////////////////////////////////////////
            
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        endcase
    end
    
        //abs
        always @(*) begin 
            if (a[31] == 1'b1) begin
                abs1 = -a;
            end else begin
                abs1 = a;
            end
            if (b[31] == 1'b1) begin
                abs2 = -b;
            end else begin
                abs2 = b;
            end
        end

endmodule