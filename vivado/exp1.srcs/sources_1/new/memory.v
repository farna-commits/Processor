`timescale 1ns / 1ps
/*******************************************************************
*
* Module: memory.v
* Project: Processor
* Author: Salma Afifi & Hana Asal
* Description: Single Memory for both data and instructions
*
* Created: 27/4/2020
* Change history: 2/05/2020 - All of us: changed selection of MUX,
                              added instructions and data.
*
**********************************************************************/


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
    
reg [7:0] mem [0:1023];
    
wire [N-1:0] data_out1;      //Instruction read 
reg [N-1:0] data_out2;      //Data read
mux_2to1  #(32)   MUX_data  (.a(data_out2),.b(data_out1),.s(~clk),.out(data_out));

    initial begin
        //Instructions:     
        //lw x1, 300(x0)    x1 = 17
        mem[0]= 8'b1_0000011;
        mem[1]= 8'b0_010_0000;
        mem[2]= 8'b1100_0000;
        mem[3]= 8'b00010010;
        //lw x2, 304(x0)    x2 = 19
        mem[4]= 8'b0_0000011;
        mem[5]= 8'b0_010_0001;
        mem[6]= 8'b0000_0000;
        mem[7]= 8'b00010011;
        //xor x3,x1,x2      x3 = 2
        mem[20]= 8'b1_0110011;
        mem[21]= 8'b1_100_0001;
        mem[22]= 8'b0010_0000;
        mem[23]= 8'b0000000_0;           
        //sw x2, 308(x0)    x2 = 19
        mem[28]= 8'b0_0100011;
        mem[29]= 8'b0_010_1010;
        mem[30]= 8'b0010_0000;
        mem[31]= 8'b0001001_0;         
        //lui x5,4          x5 = 16384
        mem[32]= 8'b1_0110111;
        mem[33]= 8'b0100_0010;
        mem[34]= 8'b00000000;
        mem[35]= 8'b00000000;   
        //lw x6, 308(x0)    x6 = 19
        mem[36]= 8'b0_0000011;
        mem[37]= 8'b0_010_0011;
        mem[38]= 8'b1000_0000;
        mem[39]= 8'b00010011;         
        //addi x7, x6, -4         //note: x6 still empty not loaded from prior instruction, so it'll have -4     
        mem[40]= 8'b1_0010011;
        mem[41]= 8'b0_000_0011;
        mem[42]= 8'b1100_0011;
        mem[43]= 8'b11111111;    
        //beq x6, x2, 16    x6=x2, so branch
        mem[44]= 8'b_0_1100011;
        mem[45]= 8'b0_000_0000;
        mem[46]= 8'b0110_0001;
        mem[47]= 8'b0_000001_0;                       
        //jal x4, 8         x4 = 116
        mem[112]= 8'b0_1101111;
        mem[113]= 8'b0000_0010;
        mem[114]= 8'b00000000;
        mem[115]= 8'b00000010;
//data 
//17
mem[300] = 8'b00010001;
mem[301] = 8'b00000000;
mem[302] = 8'b00000000;
mem[303] = 8'b00000000;

//19
mem[304] = 8'b00010011;
mem[305] = 8'b00000000;
mem[306] = 8'b00000000;
mem[307] = 8'b00000000;

//addr 308 for sw of x2

//19
mem[312] = 8'b00010011;
mem[313] = 8'b00000000;
mem[314] = 8'b00000000;
mem[315] = 8'b00000000;

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
