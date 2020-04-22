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
    output reg [N-1:0] data_out
);
reg [N-1:0] mem [0:63];

initial begin
    mem[0]=-2;
    mem[1]=-5; 
    //mem[1]=32'd4294934399;   // 32639 --> 15 (1's) in binary; 127 --> 7 (1's) in binary (using 0 sign extension)
    mem[2]=-25;    //-25  
    mem[3]=32'd262144; 
    mem[4]=-25; 
    mem[5]=32'd503;
    mem[6]=-25; 
 end 

//reading 
always@ (*) begin
    if (MemRead) begin
        case(func3)
            `F3_LW   : data_out = mem[addr]; //LW
            `F3_LH   : data_out = { {16{mem[addr][15]}},mem[addr][15:0] }; //LH
            `F3_LHU  : data_out = { 16'h0000,mem[addr][15:0] }; //LHU
            `F3_LB   : data_out = { {24{mem[addr][7]}},mem[addr][7:0] }; //LB
            `F3_LBU  : data_out = { 24'h000000,mem[addr][7:0] }; //LBU
        endcase
        
    end else begin
        data_out = 0;
    end
end

//writing  
always@ (posedge clk) begin
    if (MemWrite) begin
        case(func3)
            `F3_SW   : mem[addr] = data_in; //SW
            `F3_SH   : mem[addr] = { {16{data_in[15]}},data_in[15:0] }; //SH
            `F3_SB   : mem[addr] = { {24{data_in[7]}},data_in[7:0] }; //SB
        endcase       
     end        

end
endmodule