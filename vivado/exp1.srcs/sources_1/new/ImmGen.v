`include "defines.v"
module ImmGen
#(parameter N =32)
(
    output reg [N-1:0] Imm, 
    input wire [N-1:0] IR
);
    
always @(*) begin
	case (`OPCODE)
		`OPCODE_Arith_I   : 	Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] };
		`OPCODE_Store     :     Imm = { {21{IR[31]}}, IR[30:25], IR[11:8], IR[7] };
		`OPCODE_LUI       :     Imm = { IR[31], IR[30:20], IR[19:12], 12'b0 };
		`OPCODE_AUIPC     :     Imm = { 1'b0,IR[31], IR[30:20], IR[19:12], 11'b0 };    //shift 12 left 
		`OPCODE_JAL       : 	Imm = { {13{IR[31]}}, IR[19:12], IR[20], IR[30:25], IR[24:21]};
		`OPCODE_JALR      : 	Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] };
		`OPCODE_Branch    : 	Imm = { {21{IR[31]}}, IR[7], IR[30:25], IR[11:8]};
		`OPCODE_Load	  :     Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] }; 
		default           : 	Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] }; // IMM_I
	endcase 
end
endmodule
