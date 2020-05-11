`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module processor

//------------------------------------------------------------------------------------------------------------------------------------------------------------------//
                                                                            //input/outputs//
(
    input rst,
    input clk  
);
    
    parameter N=32;   //no. of bits
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//

    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//
                                                                            //internal signals//
    wire [N-1:0]pcInput;         //PC
    wire [N-1:0]pcOutput;        //PC
    wire [N-1:0]Instruction; 
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
    wire [9:0]Address_MUX_out;
    wire [N-1:0]ForwardUp_MUX;
    wire [N-1:0]ForwardDown_MUX;
    wire [N-1:0]ForwardUp_MUX2;
    wire [N-1:0]ForwardDown_MUX2;
    wire [8:0] Control_MUX_out;
    wire [8:0] Control_Signals;
    //shifter
    wire [N-1:0]shifterOutput;
    //Adders
    wire [N-1:0]adder1;
    wire [N-1:0]adder2;
    wire dontCareAdder1;
    wire dontCareAdder2;
    //JAL & JALR select
    wire JUMP;
    //Memory
    wire [N-1:0] MemOut;
    //enable
    wire en;
    //assginment
    assign en =1;
    assign ebit = Instruction[20];
    assign Control_Signals = {JUMP,RegWrite,Mem2Reg,Branch,MemRead,MemWrite,ALUop,ALUsrc};
    //pipeline regs inputs 
    wire [95 :0]  IFID_in;
    wire [233 :0] IDEX_in;
    wire [152 :0] EXMEM_in;
    wire [137 :0]  MEMWB_in;        
    //pipeline regs outputs 
    wire [95 :0]  IFID_out;
    wire [233:0]  IDEX_out;
    wire [152:0]  EXMEM_out;
    wire [137 :0]  MEMWB_out;

    //Comparator Outputs
    wire [N-1:0] jalRout;
    wire stall;

    //pipeline inputs assigning 
    assign IFID_in  = {adder1,pcOutput,MemOut};
    assign IDEX_in  = {adder2,IFID_out[24:20]/*rs2*/,IFID_out[19:15]/*rs1*/,IFID_out[95:64],IFID_out[24:20],IFID_out[6:0],auipcBit ,E,Control_MUX_out, IFID_out[63:32],ReadData1,ReadData2,ImmGeneratorOutput,IFID_out[14:12],IFID_out[30],IFID_out[11:7]}; 
    assign EXMEM_in = {IDEX_out[191:160],IDEX_out[8:6],ALUcf,ALUvf,ALUsf,1'b0,1'b0,1'b0,1'b0,1'b0,IDEX_out[147:140],IDEX_out[233:202],1'b0,ALUResult,ForwardDown_MUX,IDEX_out[4:0]};//e=108
    assign MEMWB_in = {EXMEM_out[101:70],EXMEM_out[152:121],EXMEM_out[109:105],MemOut,EXMEM_out[68:37],EXMEM_out[4:0]};

    //forwarding signals
    wire [1:0] forwardA;
    wire [1:0] forwardB;
    wire [1:0] forwardA2;
    wire [1:0] forwardB2;


//------------------------------------------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------------------------------------------//
                                                                            //Instantiations//

    reg_Nbit            PC                                      (.clk(clk), .en(en & MEMWB_out[72] & (~stall) ), .rst(rst),.D(Adder_MUX), .Q(pcOutput));   
    memory              Memory                                  (.clk(clk), .MemRead(EXMEM_out[103]), .MemWrite(EXMEM_out[102]), .addr(Address_MUX_out), .data_in(EXMEM_out[36:5]), .func3(EXMEM_out[120:118]), .data_out(MemOut));
    regFile             RegisterFile                            (.r1(IFID_out[19:15]), .r2(IFID_out[24:20]),.wr(MEMWB_out[4:0]),.wd(IM_MUX_out),.wen(MEMWB_out[70]),.clk(~clk),.rst(rst),.rdata1(ReadData1),.rdata2(ReadData2));
    controlUnit         Control_Unit                            (.inst(IFID_out[6:0]),.branch(Branch),.memread(MemRead),.mem2reg(Mem2Reg),.ALUop(ALUop),.memwrite(MemWrite),.ALUsrc(ALUsrc),.regwrite(RegWrite),.JUMP(JUMP), .ebreak_flag(E), .ebit(IFID_out[20]), .auipcBit(auipcBit)); 
    ImmGen              immediateGenerator                      (.Imm(ImmGeneratorOutput),.IR(IFID_out[31:0]));    
    ALUcontrolUnit      ALU_Control_Unit                        (.ALUop(IDEX_out[139:138]),.in1(IDEX_out[8:6]),.in2(IDEX_out[5]),.ALUsel(ALUcontrolSelect), .opcode(IDEX_out[154:148]));    
    ALU                 ALU1                                    (.a(ForwardUp_MUX),.b(RF_MUX_out),.selection(ALUcontrolSelect),.out(ALUResult), .shamt(IFID_out[24:20]), .CF(ALUcf), .VF(ALUvf), .SF(ALUsf));
    adderUnit           Adder2                                  (.a(IFID_out[63:32]),.b(shifterOutput),.cout(dontCareAdder2),.sum(adder2));  
    adderUnit           Adder1                                  (.a(pcOutput),.b(4'b0100),.cout(dontCareAdder1),.sum(adder1));    
    BranchControlUnit   B1                                      (.a(ForwardUp_MUX2), .b(ForwardDown_MUX2), .selection({ALUop,IFID_out[14:12],IFID_out[30],IFID_out[6:0]}), .ZF(ALUzeroFlag),.NEF(ALUnef), .GTEF(ALUgtef), .LTF(ALUltf), .LTUF(ALUltuf), .GEUF(ALUgeuf), .op1(IFID_out[6:2]), .op2(IDEX_out[154:150]), .LoadRd(IDEX_out[4:0]), .BranchSrc1(IFID_out[19:15]), .BranchSrc2(IFID_out[24:20]),.offset (ImmGeneratorOutput),.jalRout(jalRout),.stall(stall));
    //Pipeline Registers
    reg_Nbit    #(96)   IF_ID                                   (.clk(~clk), .en(en), .rst(rst),.D(IFID_in), .Q(IFID_out));   
    reg_Nbit    #(234)  ID_EX                                   (.clk(clk), .en(en), .rst(rst),.D(IDEX_in), .Q(IDEX_out));  
    reg_Nbit    #(153)  EX_MEM                                  (.clk(~clk), .en(en), .rst(rst),.D(EXMEM_in), .Q(EXMEM_out));
    reg_Nbit    #(138)  MEM_WB                                  (.clk(clk), .en(en), .rst(rst),.D(MEMWB_in), .Q(MEMWB_out));   
    //forwarding unit 
    forwardingUnit      fu                                      (.IDEX_RegisterRs1(IDEX_out[196:192]),.IDEX_RegisterRs2(IDEX_out[201:197]),.EXMEM_RegisterRd(EXMEM_out[4:0]),.MEMWB_RegisterRd(MEMWB_out[4:0]),.EXMEM_RegWrite(EXMEM_out[106]),.MEMWB_RegWrite((MEMWB_out[70])),.forwardA(forwardA),.forwardB(forwardB));  
    forwardingUnit2     fu2                                     (.RegisterRs1(IFID_out[19:15]),.RegisterRs2(IFID_out[24:20]),.EXMEM_RegisterRd(EXMEM_out[4:0]),.MEMWB_RegisterRd(MEMWB_out[4:0]),.EXMEM_RegWrite(EXMEM_out[106]),.MEMWB_RegWrite((MEMWB_out[70])),.forwardA2(forwardA2),.forwardB2(forwardB2));      
    //MUXES
    mux_2to1    #(32)   MUX_RF                                  (.a(IDEX_out[40:9]/*ImmGenOut*/),.b(ForwardDown_MUX),.s(IDEX_out[137]),.out(RF_MUX_out));  
    mux_4to1    #(32)   MUX_IM                                  (.a(DM_MUX_out),.b(MEMWB_out[137:106]),.c(MEMWB_out[105:74]),.d(0),.s( (MEMWB_out[71]) ? 2'b10 :((MEMWB_out[73]) ? 2'b00 : 2'b01) ),.out(IM_MUX_out));    
    mux_2to1    #(32)   MUX_DataMem                             (.a(MEMWB_out[68:37]),.b(MEMWB_out[36:5]),.s(MEMWB_out[69]),.out(DM_MUX_out));   
    mux_4to1    #(32)   MUX_Adder                               (.a(adder2),.b(adder1),.c(jalRout),.d(0),.s( ((JUMP & Branch) | (branchGateOut)) ? 2'b01 :(JUMP) ?  2'b10:  2'b00),.out(Adder_MUX));   
    mux_2to1    #(10)   MUX_Address                             (.a(EXMEM_out[46:37]),.b((pcOutput[11:2]) << 2),.s(~clk),.out(Address_MUX_out));  
    mux_4to1    #(32)   MUX_ForwardUp                           (.a(DM_MUX_out), .b(IDEX_out[104:73]), .c(EXMEM_out[68:37]), .d(2'b00), .s(forwardA), .out(ForwardUp_MUX)); 
    mux_4to1    #(32)   MUX_ForwardDown                         (.a(DM_MUX_out), .b(IDEX_out[72:41]), .c(EXMEM_out[68:37]), .d(2'b00), .s(forwardB), .out(ForwardDown_MUX));
    mux_4to1    #(32)   MUX_ForwardUp2                          (.a(DM_MUX_out), .b(ReadData1), .c(EXMEM_out[68:37]), .d(2'b00), .s(forwardA2), .out(ForwardUp_MUX2)); 
    mux_4to1    #(32)   MUX_ForwardDown2                        (.a(DM_MUX_out), .b(ReadData2), .c(EXMEM_out[68:37]), .d(2'b00), .s(forwardB2), .out(ForwardDown_MUX2));
    mux_2to1    #(9)    MUX_Control                             (.a(9'b0),.b(Control_Signals),.s(stall),.out(Control_MUX_out));
    //shifter
    shifter_nBit        shiftLeft1                              (.a(ImmGeneratorOutput), .out(shifterOutput));
    //branch module
    branchGate          b1                                      (.zf(ALUzeroFlag), .nef(ALUnef), .gtef(ALUgtef), .ltf(ALUltf), .ltuf(ALUltuf), .geuf(ALUgeuf), .branch(Branch), .Branching(branchGateOut), .func3(IFID_out[14:12]));
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//
   
endmodule
