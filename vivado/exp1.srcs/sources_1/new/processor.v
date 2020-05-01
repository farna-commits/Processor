`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module processor

//------------------------------------------------------------------------------------------------------------------------------------------------------------------//
                                                                            //input/outputs//
(
    //input clk,  //pc clock
    input rst,
    input push  //normal clock
);
    
    parameter N=32;   //no. of bits
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//

    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//
                                                                            //internal signals//
    reg clk;                    //PC clock
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
    wire [9:0]Address_MUX_out;
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

    //pipeline regs inputs 
    wire [95 :0]  IFID_in;
    wire [191 :0] IDEX_in;
    wire [152 :0] EXMEM_in;
    wire [105 :0]  MEMWB_in;        
    //pipeline regs outputs 
    wire [95 :0]  IFID_out;
    wire [191:0]  IDEX_out;
    wire [152:0]  EXMEM_out;
    wire [137 :0]  MEMWB_out;

    //pipeline inputs assigning 
    assign IFID_in  = {adder1,pcOutput,MemOut};
    assign IDEX_in  = {IFID_out[95:64],IFID_out[24:20],IFID_out[6:0],auipcBit,E,JUMP,RegWrite,Mem2Reg,Branch,MemRead,MemWrite,ALUop,ALUsrc,IFID_out[63:32],ReadData1,ReadData2,ImmGeneratorOutput,IFID_out[14:12],IFID_out[30],IFID_out[11:7]}; 
    assign EXMEM_in = {IDEX_out[191:160],IDEX_out[8:6],ALUcf,ALUvf,ALUsf,ALUnef,ALUgtef,ALUltf,ALUltuf,ALUgeuf,IDEX_out[147:140],adder2,ALUzeroFlag,ALUResult,IDEX_out[72:41],IDEX_out[4:0]};//e=108
    assign MEMWB_in = {EXMEM_out[101:70],EXMEM_out[152:121],EXMEM_out[109:105],MemOut,EXMEM_out[68:37],EXMEM_out[4:0]};
//------------------------------------------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------------------------------------------//
                                                                            //Instantiations//

    reg_Nbit            PC                                      (.clk(push), .en(en & MEMWB_out[72]), .rst(rst),.D(Adder_MUX), .Q(pcOutput));   //PC
    //InstMem             InstructionMemory                       (.addr(pcOutput[`IR_raddr]), .data_out(Instruction));    //inst memory
    memory              Memory                                  (.clk(push), .MemRead(EXMEM_out[103]), .MemWrite(EXMEM_out[102]), .addr(Address_MUX_out), .data_in(EXMEM_out[36:5]), .func3(EXMEM_out[120:118]), .data_out(MemOut));
    regFile             RegisterFile                            (.r1(IFID_out[19:15]), .r2(IFID_out[24:20]),.wr(MEMWB_out[4:0]),.wd(IM_MUX_out),.wen(MEMWB_out[70]),.clk(~push),.rst(rst),.rdata1(ReadData1),.rdata2(ReadData2)); //reg file
    controlUnit         Control_Unit                            (.inst(IFID_out[6:0]),.branch(Branch),.memread(MemRead),.mem2reg(Mem2Reg),.ALUop(ALUop),.memwrite(MemWrite),.ALUsrc(ALUsrc),.regwrite(RegWrite),.JUMP(JUMP), .E(E), .ebit(IFID_out[20]), .auipcBit(auipcBit)); //control unit
    ImmGen              immediateGenerator                      (.Imm(ImmGeneratorOutput),.IR(IFID_out[31:0]));    //Imm gen
    ALUcontrolUnit      ALU_Control_Unit                        (.ALUop(IDEX_out[139:138]),.in1(IDEX_out[8:6]),.in2(IDEX_out[5]),.ALUsel(ALUcontrolSelect), .opcode(IDEX_out[154:148]));   //aluControl   
    ALU                 ALU1                                    (.a(IDEX_out[104:73]),.b(RF_MUX_out),.selection(ALUcontrolSelect),.out(ALUResult),.ZF(ALUzeroFlag), .shamt(IFID_out[24:20]), .CF(ALUcf), .VF(ALUvf), .SF(ALUsf), .NEF(ALUnef), .GTEF(ALUgtef), .LTF(ALUltf), .LTUF(ALUltuf), .GEUF(ALUgeuf));
    adderUnit           Adder2                                  (.a(IDEX_out[136:105]),.b(shifterOutput),.cout(dontCareAdder2),.sum(adder2));  //adder of imm
    adderUnit           Adder1                                  (.a(pcOutput),.b(4'b0100),.cout(dontCareAdder1),.sum(adder1));        //inc of pc
    //Pipeline Registers
    reg_Nbit    #(96)   IF_ID                                   (.clk(~push), .en(en), .rst(rst),.D(IFID_in), .Q(IFID_out));   //inst mem(32), PC (32)
    reg_Nbit    #(192)  ID_EX                                   (.clk(push), .en(en), .rst(rst),.D(IDEX_in), .Q(IDEX_out));   //inst[11:7] (5), inst[30,14:12] (4), immGen(32), readd2(32), readd1(32), IF_ID(32),controlU(EX, M,WB)(8)    
    reg_Nbit    #(153)  EX_MEM                                  (.clk(~push), .en(en), .rst(rst),.D(EXMEM_in), .Q(EXMEM_out));   //IDEX (inst[11:7](5)), IDEX(readd2(32)), ALURes(32), ZF(1), addsum(32), M(3), WB(2)
    reg_Nbit    #(138)  MEM_WB                                  (.clk(push), .en(en), .rst(rst),.D(MEMWB_in), .Q(MEMWB_out));   //EXMEM(inst[11:7](5)), EXMEM(alures(32)), readd(32), WB(2)
    //MUXES
    mux_2to1    #(32)   MUX_RF                                  (.a(IDEX_out[40:9]),.b(IDEX_out[72:41]),.s(IDEX_out[137]),.out(RF_MUX_out));   //RF MUX (bet reg file and alu)
    mux_4to1    #(32)   MUX_IM                                  (.a(DM_MUX_out),.b(MEMWB_out[137:106]),.c(MEMWB_out[105:74]),.d(0),.s( (MEMWB_out[71]) ? 2'b10 :((MEMWB_out[73]) ? 2'b00 : 2'b01) ),.out(IM_MUX_out));  //between inst mem and rf    
    mux_2to1    #(32)   MUX_DataMem                             (.a(MEMWB_out[68:37]),.b(MEMWB_out[36:5]),.s(MEMWB_out[69]),.out(DM_MUX_out));   //data memory mux
    mux_4to1    #(32)   MUX_Adder                               (.a(EXMEM_out[101:70]),.b(adder1),.c(EXMEM_out[44:39]),.d(0),.s( ((EXMEM_out[107] & EXMEM_out[104]) | (branchGateOut)) ? 2'b01 :((EXMEM_out[107]) ?  2'b10:  2'b00) ),.out(Adder_MUX));   //adder mux
    mux_2to1    #(10)   MUX_Address                             (.a(EXMEM_out[46:37]),.b((pcOutput[11:2]) << 2),.s(~push),.out(Address_MUX_out));   
    //shifter
    shifter_nBit        shiftLeft1                              (.a(IDEX_out[40:9]), .out(shifterOutput));
    //branch module
    branchGate          b1                                      (.zf(EXMEM_out[69]), .nef(EXMEM_out[114]), .gtef(EXMEM_out[113]), .ltf(EXMEM_out[112]), .ltuf(EXMEM_out[111]), .geuf(EXMEM_out[110]), .branch(EXMEM_out[104]), .Branching(branchGateOut), .func3(EXMEM_out[120:118]));
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//
   
                                                                            //Board//
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//((JUMP& Branch) | (ALUzeroFlag & Branch)) ? 2'b01 :((JUMP) ?  2'b10:  2'b00))

    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//

    //clock divider 
    reg [1:0]counter;
    always @(posedge push) begin 
        if (~rst) begin  
            counter =0;     
        end   
        counter = counter + 1;
        if (counter == 1) begin 
            clk =0 ;
        end else if (counter == 2) begin 
            counter = 0;
            clk =1;
        end else begin 
            clk =1;
        end
    end
endmodule
