# RISCV-32 Processor 
For Computer Architicure course. 
# Consists of three Milestones: 
- MS1: Single Cycle processor supports 47 instructions of all types. 
- MS2: Pipelined processor with 3 stages (IF/ID, EX/MEM, WB each in a clock cycle) supporting 47 instructions and handles data hazards. 
- MS3: Tested the pipeline with a 51 instructions program. Added Bonus requirement which handles branching at decoding stage instead of memory stage. 

# Limitations 
- Interrupts and exceptions aren't handled. 
- Ecall, FENCE, CSR instructions are considred as NOPs. 
- No Branch Predictor available. 
