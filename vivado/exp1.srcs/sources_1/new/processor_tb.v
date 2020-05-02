`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module processor_tb();
    reg rst;
    reg en;
    reg push;
    
    //inst
    processor p1(.rst(rst),.push(push));
    
    initial begin
        en=1;
        rst=0;
        #20 
        rst = 1;    
    end
    
    //clk
    initial begin
    push =0;
        repeat(1000) begin
            push=1; 
            #10
            push=0;
            #10;
        end
    end
endmodule
