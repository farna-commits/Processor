`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module DataMem
(
    input clk, 
input MemRead, 
input MemWrite,
input [5:0] addr, 
input [31:0] data_in, 
output reg [31:0] data_out
);
reg [31:0] mem [0:63];

initial begin
 mem[0]=32'd17;
 mem[1]=32'd9; 
 mem[2]=32'd25;
 
 mem[4]=32'd1;
 mem[5]=32'd1;
 mem[6]=32'd0;
 mem[7]=32'd5;
 end 


//reading 
always@ (*) begin
if (MemRead) begin
   data_out = mem[addr]; 
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
