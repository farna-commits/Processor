`include "defines.v"

/*******************************************************************
*
* Module: shifter.v
* Project: Single Cycle RISC-V
* Author: Salma Afifi, salmaafifi98@aucegypt.edu
* Description: This is a shifter for the ALU.
*
* Change history: 16/4/2020 – File Created
*
**********************************************************************/

module shifter
#(parameter N = 32)
(
    input [N-1:0] a,
    input [4:0] shamt,
    input [1:0] type, 
    output reg [N-1:0] r 
);

    wire signed [N-1:0]asigned;
    assign asigned = a;

    always @(*) begin         
        case (type)            
		    2'b01:        r = a >>  shamt; //SLR
            2'b00:        r = a <<  shamt; //SLL
            2'b10:        r = asigned >>> shamt; //SRA
            default:      r = a;        
        endcase            
    end

endmodule
//module shifter
//#(parameter N = 32)
//(
//    input [N-1:0] a,
//    input [N-1:0] b,
//    input [4:0] shamt,
//    input [1:0] type,
//    output reg [N-1:0] r 
//);

//    wire signed [N-1:0]asigned;
//    assign asigned = a;

//    always @(*) begin 
//  //  if (ALUsrc)   begin     
//        case (type)            
//		    2'b01:        r = a >>  shamt; //SLRI
//            2'b00:        r = a <<  shamt; //SLLI
//            2'b10:        r = asigned >>> shamt; //SRAI
//            default:      r = a;        
//        endcase  
////    end else begin 
////     case (type)            
////               2'b01:        r = a >>  b; //SLR
////               2'b00:        r = a <<  b; //SLL
////               2'b10:        r = asigned >>> b; //SRA
////               default:      r = a;        
////           endcase  
////    end           
//    end

//endmodule
