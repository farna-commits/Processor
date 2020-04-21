`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module processor

//------------------------------------------------------------------------------------------------------------------------------------------------------------------//
                                                                            //input/outputs//
(
    input clk,
    input rst,
    input [5:0]switch,
    input push,
    output [6:0]LED_out,
    output [3:0]Anode,
    output reg [15:0]light 
);
    
    parameter N=32;   //no. of bits
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//

    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//
                                                                            //internal signals//

    wire [N-1:0]pcInput;         //PC
    wire [N-1:0]pcOutput;        //PC
    wire [N-1:0]Instruction;     //PC->hagat kteer
    wire [N-1:0]ReadData1;       //RegFile
    wire [N-1:0]ReadData2;       //RegFile
    //Control Unit
    wire Branch;
    wire MemRead;
    wire Mem2Reg;
    wire [1:0]ALUop;
    wire MemWrite;
    wire ALUsrc;
    wire RegWrite;
    wire E;
    wire ebit;
    wire auipcBit;
    //Imm generator
    wire [N-1:0]ImmGeneratorOutput;
    //ALU CONTROL
    wire [3:0]ALUcontrolSelect;
    wire [6:0]opcode;
    //ALU
    wire ALUzeroFlag;
    wire ALUcf;
    wire ALUvf;
    wire ALUsf;
    wire ALUnef, ALUgtef, ALUltf, ALUltuf, ALUgeuf;
    wire branchGateOut;
    wire [N-1:0]ALUResult;
    wire [4:0]  ALUshamt;
    //Data Memory
    wire [N-1:0]DataMem_ReadData;
    //MUX
    wire [N-1:0]RF_MUX_out;
    wire [N-1:0]DM_MUX_out;
    wire [N-1:0]IM_MUX_out;
    wire [N-1:0]Adder_MUX;
    //shifter
    wire [N-1:0]shifterOutput;
    //Adders
    wire [N-1:0]adder1;
    wire [N-1:0]adder2;
    wire dontCareAdder1;
    wire dontCareAdder2;
    //JAL & JALR select
    wire JUMP;
    //driver
    reg [12:0]numDisplayed;
    //enable
    wire en;
    //assginment
    assign en =1;
    assign ebit = Instruction[20];
//------------------------------------------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------------------------------------------//
                                                                            //Instantiations//

    reg_Nbit            PC                                      (.clk(push), .en(en & E), .rst(rst),.D(Adder_MUX), .Q(pcOutput));   //PC
    InstMem             InstructionMemory                       (.addr(pcOutput[`IR_raddr]), .data_out(Instruction));    //inst memory
    regFile             RegisterFile                            (.r1(Instruction[`IR_rs1]), .r2(Instruction[`IR_rs2]),.wr(Instruction[`IR_rd]),.wd(IM_MUX_out),.wen(RegWrite),.clk(push),.rst(rst),.rdata1(ReadData1),.rdata2(ReadData2)); //reg file
    controlUnit         Control_Unit                            (.inst(Instruction[`IR_opcode2]),.branch(Branch),.memread(MemRead),.mem2reg(Mem2Reg),.ALUop(ALUop),.memwrite(MemWrite),.ALUsrc(ALUsrc),.regwrite(RegWrite),.JUMP(JUMP), .E(E), .ebit(ebit), .auipcBit(auipcBit)); //control unit
    ImmGen              immediateGenerator                      (.Imm(ImmGeneratorOutput),.IR(Instruction));    //Imm gen
    ALUcontrolUnit      ALU_Control_Unit                        (.ALUop(ALUop),.in1(Instruction[`IR_funct3]),.in2(Instruction[30]),.ALUsel(ALUcontrolSelect), .opcode(Instruction[`IR_opcode2]));   //aluControl   
    ALU                 ALU1                                    (.a(ReadData1),.b(RF_MUX_out),.selection(ALUcontrolSelect),.out(ALUResult),.ZF(ALUzeroFlag), .shamt(Instruction[`IR_shamt]), .CF(ALUcf), .VF(ALUvf), .SF(ALUsf), .NEF(ALUnef), .GTEF(ALUgtef), .LTF(ALUltf), .LTUF(ALUltuf), .GEUF(ALUgeuf));
    DataMem             DataMemory                              (.clk(push),.MemRead(MemRead),.MemWrite(MemWrite),.addr(ALUResult[`IR_raddr]),.data_in(ReadData2),.data_out(DataMem_ReadData),.func3(Instruction[`IR_funct3]));   //datamemory
    adderUnit           Adder2                                  (.a(pcOutput),.b(shifterOutput),.cout(dontCareAdder2),.sum(adder2));  //adder of imm
    adderUnit           Adder1                                  (.a(pcOutput),.b(4'b0100),.cout(dontCareAdder1),.sum(adder1));        //inc of pc
    //MUXES
    mux_2to1    #(32)   MUX_RF                                  (.a(ImmGeneratorOutput),.b(ReadData2),.s(ALUsrc),.out(RF_MUX_out));   //RF MUX (bet reg file and alu)
    mux_4to1    #(32)   MUX_IM                                  (.a(DM_MUX_out),.b(adder2),.c(adder1),.d(0),.s( (JUMP) ? 2'b10 :((auipcBit) ? 2'b00 : 2'b01) ),.out(IM_MUX_out));  //between inst mem and rf    
    mux_2to1    #(32)   MUX_DataMem                             (.a(DataMem_ReadData),.b(ALUResult),.s(Mem2Reg),.out(DM_MUX_out)); //data memory mux
    mux_4to1    #(32)   MUX_Adder                               (.a(adder2),.b(adder1),.c(ALUResult),.d(0),.s( ((JUMP& Branch) | (branchGateOut)) ? 2'b01 :((JUMP) ?  2'b10:  2'b00) ),.out(Adder_MUX));   //adder mux
    //shifter
    shifter_nBit        shiftLeft1                              (.a(ImmGeneratorOutput), .out(shifterOutput));
    //branch module
    branchGate          b1                                      (.zf(ALUzeroFlag), .nef(ALUnef), .gtef(ALUgtef), .ltf(ALUltf), .ltuf(ALUltuf), .geuf(ALUgeuf), .branch(Branch), .Branching(branchGateOut), .func3(Instruction[`IR_funct3]));
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//
   
                                                                            //Board//
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//((JUMP& Branch) | (ALUzeroFlag & Branch)) ? 2'b01 :((JUMP) ?  2'b10:  2'b00))

    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//
endmodule
