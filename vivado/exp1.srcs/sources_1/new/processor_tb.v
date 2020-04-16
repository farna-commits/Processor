`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module processor_tb();
    reg clk;
    reg rst;
    reg en;
    reg push;
    wire [6:0]LED_out;
    wire [3:0]Anode;
    wire [15:0]light;
    
    //inst
    processor p1(.clk(clk), .rst(rst),.push(push),.switch(6'h00),.LED_out(LED_out), .Anode(Anode), .light(light));
    
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
