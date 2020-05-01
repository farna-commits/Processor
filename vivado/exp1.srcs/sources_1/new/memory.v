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
//mem[0]=8'b000000000000_00000_010_00001_0000011 ;           //lw x1, 300(x0)    x1 = 17
mem[0]= 8'b10000011;
mem[1]= 8'b0_010_0000;
mem[2]= 8'b00101100;
mem[3]= 8'b00000001;
mem[4]= 8'b10000011;
mem[5]= 8'b0_010_0000;
mem[6]= 8'b00101100;
mem[7]= 8'b00000001;

//mem[1]=8'b000000000100_00000_010_00010_0000011 ;           //lw x2, 4(x0)    x2 = 9        
//mem[2]=8'b000000001000_00000_010_00011_0000011 ;           //lw x3, 8(x0)    x3 = -25
//mem[3]=8'b0000000_00010_00001_100_00100_0110011 ;           //XOR x4, x1, x2
//mem[4]=8'b0000000_00010_00001_001_00101_0110011 ;           //sll x5, x1, x2 shift amount of rs2
//mem[5]=8'b0000000_00010_00001_101_00110_0110011 ;           //srl x6, x1, x2 shift amount of rs2
//mem[6]=8'b0100000_00010_00001_101_00111_0110011 ;           //sra x7, x1, x2 shift amount of rs2
//mem[7]=8'b0000000_00010_00001_010_01000_0110011 ;           //slt x8, x1, x2 set x8 as '1' if x1 < x2, else x8=0
//mem[8]=8'b0000000_00011_00001_011_01001_0110011 ;           //sltu x9, x1, x3 set x9 as '1' if x1 < x3, else x9=0


//data 
mem[300] =17;
end
always@ (negedge clk) begin     //make sure of pos or neg clk
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
