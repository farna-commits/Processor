`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module processor_tb();
    reg clk;
    reg rst;
    reg en;
    reg push;
    
    //inst
    processor p1(.clk(clk), .rst(rst),.push(push));
    
    initial begin
        en=1;
        rst=0;
        #20 
        rst = 1;    
    end
    
    //clk
    initial begin
    clk = 0;
    push =0;
        repeat(1000) begin
            clk =1;
            push=1; 
            #10
            clk=0;
            push=0;
            #10;
        end
    end
endmodule
