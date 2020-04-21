`define     IR_rs1          19:15
`define     IR_rs2          24:20
`define     IR_rd           11:7
`define     IR_opcode       6:2
`define     IR_opcode2      6:0
`define     IR_funct3       14:12
`define     IR_funct7       31:25
`define     IR_shamt        24:20
`define     IR_csr          31:20
`define     IR_raddr        7:2


`define     OPCODE_Branch   5'b11_000
`define     OPCODE_Load     5'b00_000
`define     OPCODE_Store    5'b01_000
`define     OPCODE_JALR     5'b11_001
`define     OPCODE_JAL      5'b11_011
`define     OPCODE_Arith_I  5'b00_100
`define     OPCODE_Arith_R  5'b01_100
`define     OPCODE_AUIPC    5'b00_101
`define     OPCODE_LUI      5'b01_101
`define     OPCODE_SYSTEM   5'b11_100 
`define     OPCODE_Custom   5'b10_001

`define     F3_ADD          3'b000
`define     F3_SLL          3'b001
`define     F3_SLT          3'b010
`define     F3_SLTU         3'b011
`define     F3_XOR          3'b100
`define     F3_SRL          3'b101
`define     F3_OR           3'b110
`define     F3_AND          3'b111

`define     F3_LW           3'b010
`define     F3_LH           3'b001
`define     F3_LHU          3'b101
`define     F3_LB           3'b000
`define     F3_LBU          3'b100

`define     F3_SW           3'b010
`define     F3_SH           3'b001
`define     F3_SB           3'b000


`define     BR_BEQ          3'b000
`define     BR_BNE          3'b001
`define     BR_BLT          3'b100
`define     BR_BGE          3'b101
`define     BR_BLTU         3'b110
`define     BR_BGEU         3'b111

`define     OPCODE          IR[`IR_opcode]

`define     ALU_ADD         4'b00_00
`define     ALU_SUB         4'b00_01
`define     ALU_LUI         4'b00_11
`define     ALU_OR          4'b01_00
`define     ALU_AND         4'b01_01
`define     ALU_XOR         4'b01_11
`define     ALU_SLLI        4'b10_00
`define     ALU_SRAI        4'b10_10
`define     ALU_SRLI        4'b10_01
`define     ALU_SLL         4'b00_10
`define     ALU_SRL         4'b01_10
`define     ALU_SRA         4'b10_11
`define     ALU_SLTU        4'b11_11
`define     ALU_SLT         4'b11_01

`define     SYS_EC_EB       3'b000
`define     SYS_CSRRW       3'b001
`define     SYS_CSRRS       3'b010
`define     SYS_CSRRC       3'b011
`define     SYS_CSRRWI      3'b101
`define     SYS_CSRRSI      3'b110
`define     SYS_CSRRCI      3'b111

`define     ALUCUADD        13'b10_000_0_0110011
`define     ALUCUSUB        13'b10_000_1_0110011
`define     ALUCUAND        13'b10_111_0_0110011
`define     ALUCUOR         13'b10_110_0_0110011
`define     ALUCUXOR        13'b10_100_0_0110011
`define     ALUCUSLL        13'b10_001_0_0110011
`define     ALUCUSRL        13'b10_101_0_0110011
`define     ALUCUSRA        13'b10_101_1_0110011
`define     ALUCUSLT        13'b10_010_0_0110011
`define     ALUCUSLTU       13'b10_011_0_0110011
`define     ALUCUORI        13'b00_110_x_0010011
`define     ALUCUANDI       13'b00_111_x_0010011
`define     ALUCUXORI       13'b00_100_x_0010011
`define     ALUCUSLTI       13'b00_010_x_0010011
`define     ALUCUSLTUI      13'b00_011_x_0010011
`define     ALUCUJALR       13'b00_000_x_0010011
`define     ALUCULW         13'b00_010_x_0000011
`define     ALUCULH         13'b00_001_x_0000011
`define     ALUCULB         13'b00_000_x_0000011
`define     ALUCULHU        13'b00_101_x_0000011
`define     ALUCULBU        13'b00_100_x_0000011
`define     ALUCUSLLI       13'b00_001_0_0010011
`define     ALUCUSRLI       13'b00_101_0_0010011
`define     ALUCUSRAI       13'b00_101_1_0010011
`define     ALUCUJAL        13'b00_xxx_x_1101111
`define     ALUCUSW         13'b00_010_x_0100011
`define     ALUCUSH         13'b00_001_x_0100011
`define     ALUCUSB         13'b00_000_x_0100011
`define     ALUCUBEQ        13'b01_000_x_1100011
`define     ALUCUBNE        13'b01_001_x_1100011
`define     ALUCUBLT        13'b01_100_x_1100011
`define     ALUCUBGE        13'b01_101_x_1100011
`define     ALUCUBLTU       13'b01_110_x_1100011
`define     ALUCUBGEU       13'b01_111_x_1100011
`define     ALUCULUI        13'bxx_xxx_x_0110111

`define     CU_R            6'b01100_x
`define     CU_LW           6'b00000_x
`define     CU_S            6'b01000_x
`define     CU_SB           6'b11000_x
`define     CU_IARITH       6'b00100_x
`define     CU_IJALR        6'b11001_x
`define     CU_UJJAL        6'b11011_x
`define     CU_EBREAK       6'b11100_1
`define     CU_ECALLCSR     6'b11100_0
`define     CU_FENCE        6'b00011_x
`define     CU_AUIPC        6'b00101_x
`define     CU_LUI          6'b01101_x

