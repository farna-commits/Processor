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
     $readmemh("test.mem",mem);
    //data 
    mem[300] = 8'b00000001;
    mem[301] = 8'b00000010;
    mem[302] = 8'b00000000;
    mem[303] = 8'b00000100;
    mem[304] = 8'b00000000;
    mem[305] = 8'b00000101;
    mem[306] = 8'b00000000;
    mem[307] = 8'b00000000;
    mem[308] = 8'b00000000;
end

always@ (posedge clk) begin  
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
