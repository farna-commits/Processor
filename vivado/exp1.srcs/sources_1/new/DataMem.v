`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module DataMem
#(parameter N =32)
(
    input clk, 
    input MemRead, 
    input MemWrite,
    input [5:0] addr, 
    input [N-1:0] data_in, 
    input [2:0] func3,
    output reg [31:0] data_out
);
reg [N-1:0] mem [0:63];

initial begin
    mem[0]=32'd17;
    mem[1]=32'd9; 
    mem[2]=32'sb11111111111111111111111111100111;    //-25  
    mem[3]=32'd262144; 
    mem[4]=32'sb11111111111111111111111111100111; 
    mem[5]=32'd503;
    mem[6]=32'sb11111111111111111111111111100111; 
 end 

//reading 
always@ (*) begin
    if (MemRead) begin
        case(func3)
            3'b010: data_out = mem[addr]; //LW
            3'b001: data_out = { {16{mem[addr][15]}},mem[addr][15:0] }; //LH
            3'b101: data_out = { 16'h0000,mem[addr][15:0] }; //LHU
            3'b000: data_out = { {24{mem[addr][7]}},mem[addr][7:0] }; //LB
            3'b100: data_out = { 24'h000000,mem[addr][7:0] }; //LBU
        endcase
        
    end else begin
        data_out = 0;
    end
end

//writing  
always@ (posedge clk) begin
    if (MemWrite) begin
        mem[addr] = data_in;
    end        
end
endmodule
