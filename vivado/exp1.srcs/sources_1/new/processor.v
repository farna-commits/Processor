`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



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
    wire [31:0]ALUResult;
    wire [4:0]  ALUshamt;
    //Data Memory
    wire [N-1:0]DataMem_ReadData;
    //MUX
    wire [N-1:0]RF_MUX_out;
    wire [N-1:0]DM_MUX_out;
    wire [N-1:0]Adder_MUX;
    wire [1:0] Adder_MUX_select_temp;
    wire [1:0] Adder_MUX_select;
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
    //assign Adder_MUX_select_temp = ((JUMP& Branch) | (ALUzeroFlag & Branch)) ?  2'b01 : Adder_MUX_select ;
<<<<<<< HEAD
    //assign Adder_MUX_select= ((JUMP) ?  2'b10:  2'b00);
=======
    assign Adder_MUX_select= ((JUMP) ?  2'b10:  2'b00);
>>>>>>> staging-master
//------------------------------------------------------------------------------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------------------------------------------------------------------------------//
                                                                            //Instantiations//

    reg_Nbit PC                                 (.clk(push), .en(en), .rst(rst),.D(Adder_MUX), .Q(pcOutput));   //PC
    InstMem InstructionMemory                   (.addr(pcOutput[7:2]), .data_out(Instruction));    //inst memory
    regFile RegisterFile                        (.r1(Instruction[19:15]), .r2(Instruction[24:20]),.wr(Instruction[11:7]),.wd(DM_MUX_out),.wen(RegWrite),.clk(push),.rst(rst),.rdata1(ReadData1),.rdata2(ReadData2)); //reg file
    controlUnit Control_Unit                    (.inst(Instruction[6:0]),.branch(Branch),.memread(MemRead),.mem2reg(Mem2Reg),.ALUop(ALUop),.memwrite(MemWrite),.ALUsrc(ALUsrc),.regwrite(RegWrite),.JUMP(JUMP)); //control unit
    ImmGen  immediateGenerator                  (.Imm(ImmGeneratorOutput),.IR(Instruction));    //Imm gen
    ALUcontrolUnit  ALU_Control_Unit            (.ALUop(ALUop),.in1(Instruction[14:12]),.in2(Instruction[30]),.ALUsel(ALUcontrolSelect), .opcode(Instruction[6:0]));   //aluControl
<<<<<<< HEAD
    ALU ALU1                                    (.a(ReadData1),.b(RF_MUX_out),.selection(ALUcontrolSelect),.out(ALUResult),.ZF(ALUzeroFlag), .shamt(ReadData2), .CF(ALUcf), .VF(ALUvf), .SF(ALUsf));  //ALU (a-b)
=======
    //ALU ALU1                                    (.a(ReadData1),.b(RF_MUX_out),.selection(ALUcontrolSelect),.out(ALUResult),.ZF(ALUzeroFlag), .shamt(Instruction[24:20]), .CF(ALUcf), .VF(ALUvf), .SF(ALUsf), .ALUsrc(ALUsrc));  //ALU (a-b)
     ALU ALU1                                    (.a(ReadData1),.b(RF_MUX_out),.selection(ALUcontrolSelect),.out(ALUResult),.ZF(ALUzeroFlag), .shamt(Instruction[24:20]), .CF(ALUcf), .VF(ALUvf), .SF(ALUsf));
>>>>>>> staging-master
    DataMem DataMemory                          (.clk(push),.MemRead(MemRead),.MemWrite(MemWrite),.addr(ALUResult[7:2]),.data_in(ReadData2),.data_out(DataMem_ReadData),.func3(Instruction[14:12]));   //datamemory
    adderUnit   Adder2                          (.a(pcOutput),.b(shifterOutput),.cout(dontCareAdder2),.sum(adder2));  //adder of imm
    adderUnit   Adder1                          (.a(pcOutput),.b(4'b0100),.cout(dontCareAdder1),.sum(adder1));        //inc of pc
    //MUXES
    mux_2to1    #(31)MUX_RF                     (.a(ImmGeneratorOutput),.b(ReadData2),.s(ALUsrc),.out(RF_MUX_out));   //RF MUX (bet reg file and alu)
    mux_4to1    #(31)MUX_DataMem                (.a(DataMem_ReadData),.b(ALUResult),.c(adder1),.d(0),.s((JUMP) ? 2'b10 :(Mem2Reg)),.out(DM_MUX_out));   //data memory mux
<<<<<<< HEAD
    //mux_4to1    #(31)MUX_Adder                  (.a(adder2),.b(adder1),.c(ALUResult),.d(0),.s((JUMP) ? 2'b10 :(ALUzeroFlag & Branch)),.out(Adder_MUX));   //adder mux
   //mux_4to1    #(31)MUX_Adder                  (.a(adder2),.b(adder1),.c(ALUResult),.d(0),.s(1),.out(Adder_MUX));   //adder mux
    mux_4to1    #(31)MUX_Adder                  (.a(adder2),.b(adder1),.c(ALUResult),.d(0),.s( ((JUMP& Branch) | (ALUzeroFlag & Branch)) ? 2'b01 :((JUMP) ?  2'b10:  2'b00)),.out(Adder_MUX));   //adder mux
=======
    mux_4to1    #(31)MUX_Adder                  (.a(adder2),.b(adder1),.c(ALUResult),.d(0),.s((JUMP) ? 2'b10 :(ALUzeroFlag & Branch)),.out(Adder_MUX));   //adder mux
   // mux_4to1    #(31)MUX_Adder                  (.a(adder2),.b(adder1),.c(ALUResult),.d(0),.s(1),.out(Adder_MUX));   //adder mux
    //mux_4to1    #(31)MUX_Adder                  (.a(adder2),.b(adder1),.c(ALUResult),.d(0),.s(1),.out(Adder_MUX));   //adder mux
>>>>>>> staging-master
    //shifter
    shifter_nBit    shiftLeft1                  (.a(ImmGeneratorOutput), .out(shifterOutput));
    
    //driver
    driver Driver1                              (.clk(clk), .num(numDisplayed),.Anode(Anode),.LED_out(LED_out));

    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//
   
                                                                            //Board//
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//
    //switch 10 , LEDsel in the slides is equiv to switch [1:0]
    always@(*) begin
    
        case (switch[1:0])
            2'b00: light = Instruction[15:0];
            2'b01: light = Instruction[31:16];
            2'b10: light = {Branch,MemRead,Mem2Reg,ALUop,MemWrite, ALUsrc,RegWrite,ALUcontrolSelect, ALUzeroFlag , ALUzeroFlag & Branch,3'b000};               
            default: light = 0;
        endcase
        
        case (switch[5:2])
            0:  numDisplayed        = pcOutput[12:0];
            1:  numDisplayed        = adder1[12:0];
            2:  numDisplayed        = adder2[12:0];
            3:  numDisplayed        = Adder_MUX[12:0];
            4:  numDisplayed        = ReadData1[12:0];
            5:  numDisplayed        = ReadData2[12:0];
            6:  numDisplayed        = DM_MUX_out[12:0];
            7:  numDisplayed        = ImmGeneratorOutput[12:0];
            8:  numDisplayed        = shifterOutput[12:0];
            9:  numDisplayed        = RF_MUX_out[12:0];
            10:  numDisplayed       = ALUResult[12:0];
            11:  numDisplayed       = DataMem_ReadData[12:0];
            default: numDisplayed   = 0;
        endcase
    
    end

//((JUMP& Branch) | (ALUzeroFlag & Branch)) ? 2'b01 :((JUMP) ?  2'b10:  2'b00)


//    always @(*) begin
//        if ((JUMP& Branch) | (ALUzeroFlag & Branch)) begin
         
//            Adder_MUX_select = 2'b01;
//        end else 
//            if(JUMP) begin
//                Adder_MUX_select = 2'b10;            
//            end else begin
//             Adder_MUX_select = 2'b00;            
//        end
//    end

    //------------------------------------------------------------------------------------------------------------------------------------------------------------------//
endmodule
