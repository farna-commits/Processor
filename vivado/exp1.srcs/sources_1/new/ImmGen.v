`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module ImmGen
(
    output reg [31:0] gen_out, 
    input [31:0] inst
);
    
    
    always@(*) begin
        
        //BEQ
        if(inst[6]) begin
            gen_out[11:0]= {inst[31],inst[7],inst[30:25],inst[11:8]};
        end
        //SW
        if(~inst[6] && inst[5]) begin
            gen_out[11:0]= {inst[31:25],inst[11:7]};
        end
        
        //LW    
        if(~inst[6] && ~inst[5]) begin
            gen_out[11:0]= {inst[31:20]};
        end                
              
        //sign extension
        if(gen_out[11]) begin
            gen_out[31:12] = 20'b11111111111111111111;
        end else begin
            gen_out[31:12] = 5'h00000;
        end
    end
endmodule
