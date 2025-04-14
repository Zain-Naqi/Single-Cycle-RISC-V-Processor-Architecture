`timescale 1ns / 1ps

module RISC_V_Processor(
    input clk,
    input reset
    );
    //PC Counter
    wire [63:0] PC_In;
    wire [63:0] PC_Out;
    
    Program_Counter a1(clk,reset,PC_In,PC_Out);
    
    //PC + 4
    wire [63:0] PCFour;
    Adder b1(PC_Out, 64'd4, PCFour);
    
    //Instr_Addr
    wire [31:0] Instruction;
    Instruction_Memory c1(PC_Out,Instruction);
    
    //Instruction Parser
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [2:0] funct3;
    wire [3:0] funct7;
//    InstructionParser_task02 d1(Instruction,opcode,rd,funct3,rs1,rs2,funct7);
    Instruction_Parser d1(Instruction, funct3, funct7, rs1, rs2, rd, opcode);
    
    //Control Unit Generation
    wire [3:0] funct; 
    assign funct = {Instruction[30], Instruction[14:12]};
    wire Branch;                // Branch control signal
    wire [2:0] BranchType;
    wire MemRead;               // Memory Read control signal
    wire MemtoReg;              // Memory to Register control signal
    wire MemWrite;              // Memory Write control signal
    wire ALUSrc;                // ALU Source control signal (use of immediate or register)
    wire RegWrite;              // Register Write control signal
    wire [3:0] Operation;
    top_control g1(opcode,funct,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Operation);
    assign BranchType = funct3;
    //Immediate Data Extractor
    wire [63:0] immediate;
//    ImmediateDataGenerator_task03 e1(Instruction,immediate);
    Imm_Data_Extractor e1(Instruction, immediate);
    
    
    //PC + Branch Instruction
    wire [63:0] PCBranch;
    wire [63:0] immediate_left;
    assign immediate_left = immediate << 1;
    Adder f1(PC_Out,immediate_left, PCBranch);
    
    //Register File
    wire [63:0] writeData;
    wire [63:0] ReadData1;
    wire [63:0] ReadData2;
    registerFile h1(writeData,rs1,rs2,rd,RegWrite,clk,reset,ReadData1,ReadData2);
    
    //Mux for ALU INPUTS
    wire [63:0] data_out;
    mux_2x1 i1(ReadData2,immediate,ALUSrc, data_out);
    
    
    //ALU
    wire Cin;
    wire Cout;
    wire Zero;
    wire Less;
    wire [63:0] Result;
    assign Cin = Operation == 4'b0011 ? 1 : 0;
    ALU_64_bit j1(ReadData1, data_out, Cin, Operation, Cout, Zero, Less, Result);
  
    
    //PC Mux Complete
    wire [63:0] pc_final_out;
    wire signal;
//    assign signal = Branch && Zero; 
    assign signal = (BranchType == 3'b000) ? (Branch && Zero) :       // beq
                (BranchType == 3'b001) ? (Branch && !Zero) :      // bne
                (BranchType == 3'b100) ? (Branch && Less) :       // blt
                (BranchType == 3'b101) ? (Branch && !Less) :      // bge
                0;

    mux_2x1 k1(PCFour, PCBranch, signal, pc_final_out); 
    assign PC_In = pc_final_out; 
    
    //DM
    wire [63:0] Read_Data;
    Data_Memory l1(Result,ReadData2,clk,MemWrite,MemRead,Read_Data);
    
    //Final Mux
    wire [63:0] final_mux_data_out;
    mux_2x1 m1(Result,Read_Data,MemtoReg,final_mux_data_out);
    
    assign writeData = final_mux_data_out;
    
    
endmodule
