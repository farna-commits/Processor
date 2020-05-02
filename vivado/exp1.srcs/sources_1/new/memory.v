`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2020 04:58:08 PM
// Design Name: 
// Module Name: memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module memory
#(parameter N =32)
(
    input clk, 
    input MemRead, 
    input MemWrite,
    input [9:0] addr,
    input [N-1:0] data_in,
    input [2:0] func3,
    output [N-1:0] data_out
);
    
reg [7:0] mem [0:1024];
    
wire [N-1:0] data_out1;      //Instruction read 
reg [N-1:0] data_out2;      //Data read
mux_2to1  #(32)   MUX_data  (.a(data_out2),.b(data_out1),.s(~clk),.out(data_out));

    initial begin
        //lw x1, 300(x0)    x1 = 19
        mem[0]= 8'b1_0000011;
        mem[1]= 8'b0_010_0000;
        mem[2]= 8'b0000_0000;
        mem[3]= 8'b00010011;
        //lw x2, 304(x0)    x2 = 17
        mem[4]= 8'b0_0000011;
        mem[5]= 8'b0_010_0001;
        mem[6]= 8'b1100_0000;
        mem[7]= 8'b00010010;
        //NOP
        mem[8]= 8'b0_0110011;
        mem[9]= 8'b0_000_0000;
        mem[10]= 8'b0000_0000;
        mem[11]= 8'b00000000;
        //NOP
        mem[12]= 8'b0_0110011;
        mem[13]= 8'b0_000_0000;
        mem[14]= 8'b0000_0000;
        mem[15]= 8'b00000000;
        //NOP
        mem[16]= 8'b0_0110011;
        mem[17]= 8'b0_000_0000;
        mem[18]= 8'b0000_0000;
        mem[19]= 8'b00000000;
        //xor x3,x1,x2
        mem[20]= 8'b1_0110011;
        mem[21]= 8'b1_100_0001;
        mem[22]= 8'b0010_0000;
        mem[23]= 8'b0000000_0;
        //NOP
        mem[24]= 8'b0_0110011;
        mem[25]= 8'b0_000_0000;
        mem[26]= 8'b0000_0000;
        mem[27]= 8'b00000000;
        //NOP
        mem[28]= 8'b0_0110011;
        mem[29]= 8'b0_000_0000;
        mem[30]= 8'b0000_0000;
        mem[31]= 8'b00000000;
        //NOP
        mem[32]= 8'b0_0110011;
        mem[33]= 8'b0_000_0000;
        mem[34]= 8'b0000_0000;
        mem[35]= 8'b00000000;
        //beq x1, x2, 16
        // mem[36]= 8'b_0_1100011;
        // mem[37]= 8'b0_000_0000;
        // mem[38]= 8'b0001_0001;
        // mem[39]= 8'b0_000001_0;
        //mem[17]=32'b0000000_00010_00000_010_01100_0100011;                   
        //sw x2, 308(x0)
        mem[36]= 8'b0_0100011;
        mem[37]= 8'b0_010_1010;
        mem[38]= 8'b0010_0000;
        mem[39]= 8'b0001001_0;         
        //NOP
        mem[40]= 8'b0_0110011;
        mem[41]= 8'b0_000_0000;
        mem[42]= 8'b0000_0000;
        mem[43]= 8'b00000000;
        //NOP
        mem[44]= 8'b0_0110011;
        mem[45]= 8'b0_000_0000;
        mem[46]= 8'b0000_0000;
        mem[47]= 8'b00000000;
        //NOP
        mem[48]= 8'b0_0110011;
        mem[49]= 8'b0_000_0000;
        mem[50]= 8'b0000_0000;
        mem[51]= 8'b00000000;
        //jal x4, 8
        // mem[52]= 8'b0_1101111;
        // mem[53]= 8'b0000_0010;
        // mem[54]= 8'b00000000;
        // mem[55]= 8'b00000010;
        //NOP
        mem[52]= 8'b0_0110011;
        mem[53]= 8'b0_000_0000;
        mem[54]= 8'b0000_0000;
        mem[55]= 8'b00000000;
        //NOP
        mem[56]= 8'b0_0110011;
        mem[57]= 8'b0_000_0000;
        mem[58]= 8'b0000_0000;
        mem[59]= 8'b00000000;
        //NOP
        mem[60]= 8'b0_0110011;
        mem[61]= 8'b0_000_0000;
        mem[62]= 8'b0000_0000;
        mem[63]= 8'b00000000;    
        //lui x5,4
        mem[64]= 8'b1_0110111;
        mem[65]= 8'b0100_0010;
        mem[66]= 8'b00000000;
        mem[67]= 8'b00000000;                     
//mem[1]=8'b000000000100_00000_010_00010_0000011 ;           //lw x2, 4(x0)    x2 = 9        
//mem[2]=8'b000000001000_00000_010_00011_0000011 ;           //lw x3, 8(x0)    x3 = -25
//mem[3]=8'b0000000_00010_00001_100_00100_0110011 ;           //XOR x4, x1, x2
//mem[4]=8'b0000000_00010_00001_001_00101_0110011 ;           //sll x5, x1, x2 shift amount of rs2
//mem[5]=8'b0000000_00010_00001_101_00110_0110011 ;           //srl x6, x1, x2 shift amount of rs2
//mem[6]=8'b0100000_00010_00001_101_00111_0110011 ;           //sra x7, x1, x2 shift amount of rs2
//mem[7]=8'b0000000_00010_00001_010_01000_0110011 ;           //slt x8, x1, x2 set x8 as '1' if x1 < x2, else x8=0
//mem[8]=8'b0000000_00011_00001_011_01001_0110011 ;           //sltu x9, x1, x3 set x9 as '1' if x1 < x3, else x9=0


//data 
mem[300] = 8'b00010011;
mem[301] = 8'b00000000;
mem[302] = 8'b00000000;
mem[303] = 8'b00000000;

mem[304] = 8'b00010011;
mem[305] = 8'b00000000;
mem[306] = 8'b00000000;
mem[307] = 8'b00000000;


end
always@ (posedge clk) begin     //make sure of pos or neg clk
    if (MemWrite) begin
        case(func3)
            `F3_SW   : {mem[addr+3],mem[addr+2], mem[addr+1], mem[addr]} = data_in; //SW
            `F3_SH   : {mem[addr+1], mem[addr]} = { {16{data_in[15]}},data_in[15:0] }; //SH
            `F3_SB   : mem[addr] = { {24{data_in[7]}},data_in[7:0] }; //SB
        endcase       
     end        
end

always@ (*) begin
    if (MemRead) begin
        case(func3)
            `F3_LW   : data_out2 = {mem[addr+3],mem[addr+2], mem[addr+1], mem[addr]}; //LW
            `F3_LH   : data_out2 = { {16{mem[addr+1][7]}},mem[addr+1], mem[addr]}; //LH
            `F3_LHU  : data_out2 = { 16'h0000,mem[addr+1], mem[addr] }; //LHU
            `F3_LB   : data_out2 = { {24{mem[addr][7]}},mem[addr] }; //LB
            `F3_LBU  : data_out2 = { 24'h000000,mem[addr] }; //LBU
        endcase        
    end else begin
        data_out2 = 0;
    end
end

assign data_out1 = {mem[addr+3],mem[addr+2], mem[addr+1], mem[addr]};

endmodule
