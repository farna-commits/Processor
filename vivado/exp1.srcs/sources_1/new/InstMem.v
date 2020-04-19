`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module InstMem
(
    input [5:0] addr, 
    output [31:0] data_out
);
 reg [31:0] mem [0:63];
 
 //init rom 
 initial begin 
        mem[0]=32'b000000000000_00000_010_00001_0000011 ;           //lw x1, 0(x0)    x1 = 17
        mem[1]=32'b000000000100_00000_010_00010_0000011 ;           //lw x2, 4(x0)    x2 = 9        
        mem[2]=32'b000000001000_00000_010_00011_0000011 ;           //lw x3, 8(x0)    x3 = -25
        mem[3]=32'b0000000_00010_00001_100_00100_0110011 ;           //XOR x4, x1, x2
        mem[4]=32'b0000000_00010_00001_001_00101_0110011 ;           //sll x5, x1, x2 shift amount of rs2
        mem[5]=32'b0000000_00010_00001_101_00110_0110011 ;           //srl x6, x1, x2 shift amount of rs2
        mem[6]=32'b0100000_00010_00001_101_00111_0110011 ;           //sra x7, x1, x2 shift amount of rs2
        mem[7]=32'b0000000_00010_00001_010_01000_0110011 ;           //slt x8, x1, x2 set x8 as '1' if x1 < x2, else x8=0
        mem[8]=32'b0000000_00011_00001_011_01001_0110011 ;           //sltu x9, x1, x3 set x9 as '1' if x1 < x3, else x9=0
        
        
        mem[9] = 32'b000000000100_00001_000_01010_0010011 ;           //addi x10, x1, 4
        mem[10]=32'b111111111100_00001_000_01011_0010011 ;           //addi x11, x1, -4
        mem[11]=32'b000000000100_00001_111_01100_0010011 ;           //and x12, x1, 4
        mem[12]=32'b000000000100_00001_110_01101_0010011 ;           //or x13, x1, 4
        mem[13]=32'b000000000100_00001_100_01110_0010011 ;           //xor x14, x1, 4
        mem[14]=32'b000000100000_00001_010_01111_0010011 ;           //slti x15, x1, 32
        mem[15]=32'b111111100000_00001_010_10000_0010011 ;           //slti x16, x1, -32
        mem[16]=32'b111111100000_00001_011_10001_0010011 ;           //sltiu x17, x1, -32
//        mem[17]=32'b000000001100_00000_001_10010_0000011 ;           //lh x18, 12(x0)  
//        mem[18]=32'b000000010000_00000_101_10011_0000011 ;           //lhu x19, 16(x0)
//        mem[19]=32'b000000010100_00000_000_11000_0000011 ;           //lb x20, 24(x0)
//        mem[20]=32'b000000011000_00000_100_11001_0000011 ;           //lbu x21, 28(x0)  

        mem[17]=32'b000000000001_00001_001_10010_0010011 ;           //slli x18, x1, 1
        mem[18]=32'b000000000001_00001_101_10011_0010011 ;           //srli x19, x1, 1
       // mem[19]=32'b000000000001_00001_101_10011_0010011 ;           //srai x19, x1, 1
        
          
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//        //HANA'S INST MEM
//            mem[17]=32'b0000000_00010_00000_010_01100_0100011;           //sw x1, 12(x0)
//            mem[18]=32'b000000001100_00000_010_10010_0000011 ;           //lw x18, 12(x0)
            
//            mem[19]=32'b000000001000_00000_000_10101_1100111;           //jalr x21, x0, 8
//            //mem[19]=32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 4
//         //mem[19]=32'b00000010000000000000_10101_1100111;              //jal x21, 8
            
//            mem[20]=32'b0000000_00010_00000_001_01100_0100011;           //sh x1, 12(x0)
//            mem[21]=32'b000000001100_00000_010_10011_0000011 ;           //lw x19, 12(x0)
//            mem[22]=32'b0000000_00010_00000_000_01100_0100011;           //sb x1, 12(x0)
//            mem[23]=32'b000000001100_00000_010_10100_0000011 ;           //lw x20, 12(x0)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//    mem[0]32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
//    mem[1]=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
//    mem[2]=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
//    mem[3]=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
//    mem[4]=32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 4
//    mem[5]=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
//    mem[6]=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
//    mem[7]=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
//    mem[8]=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
//    mem[9]=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
//    mem[10]=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
//    mem[11]=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
//    mem[12]=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1 
//    //new code 
//    mem[13]=32'b000000010000_00000_010_00001_0000011 ; //lw x1, 16(x0) 
//    mem[14]=32'b000000010100_00000_010_00010_0000011 ; //lw x2, 20(x0) 
//    mem[15]=32'b000000011000_00000_010_00011_0000011 ; //lw x3, 24(x0) 
//    mem[16]=32'b000000011100_00000_010_00100_0000011 ; //lw x4, 28(x0) 
//    mem[17]=32'b0000000_00001_00011_000_00011_0110011 ; //add x3, x3, x1
//    mem[18]=32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 4
//    mem[19]=32'b1_111111_00001_00001_000_1100_1_1100011; //beq x1, x2, -8  
 end
assign data_out = mem[addr];
endmodule
