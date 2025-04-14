`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2025 11:00:19 PM
// Design Name: 
// Module Name: RISC_V_Processor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RISC_V_Processor(
    input clk,
    input reset
    );
    
    wire [63:0] PC_In, PC_Out, PC_Adder_Out, 
                PC_Imm_Adder_Out, Imm_Data, Imm_Data_LeftShift,
                WriteData, ReadData1, ReadData2,
                ALU_Input_b, ALU_Result, DM_Output;
    wire [31:0] Instruction;
    wire [6:0] opcode, funct7;
    wire [4:0] rd, rs1, rs2;
    wire [3:0] Operation;
    wire [2:0] funct3;
    wire Branch, MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, RegWrite, zero, Cin, Less;
    
    // PC:
    Program_Counter PC(clk, reset, PC_In, PC_Out);
    // PC Adder (which adds 4):
    Adder Adder_1(PC_Out, 64'd4, PC_Adder_Out);
    // Instruction Memory:
    Instruction_Memory IM(PC_Out, Instruction);
    // Instruction Parser
    Instruction_Parser IP(Instruction, opcode, rd, funct3, rs1, rs2, funct7);
    // Immediate Data Extractor:
    Imm_Data_Extractor IDE(Instruction, Imm_Data);
    // Control Unit:
//    Control_Unit CU(opcode, Branch, MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, RegWrite);
    // ALU Control:
//    ALU_Control AC(ALUOp, {Instruction[30], funct3}, Operation);
    // Control Unit and ALU Control:
    top_control control(opcode, {Instruction[30], funct3}, Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, Operation);
    // Adder that adds immediate value to PC in case of branches:
    assign Imm_Data_LeftShift = Imm_Data << 1;
    Adder Adder_2(PC_Out, Imm_Data_LeftShift, PC_Imm_Adder_Out);
    // Register File:
    Register_File RF(WriteData, rs1, rs2, rd, RegWrite, clk, reset, ReadData1, ReadData2);
    // ALU Mux (Decides between immediate and rs2):
    Mux ALU_Mux(ReadData2, Imm_Data, ALUSrc, ALU_Input_b);
    // ALU:
    ALU_64_bit ALU(ReadData1, ALU_Input_b, Cin, Operation, Cout, zero, Less, ALU_Result);
    // Mux that decides between next instruction or branched instruction:
    Mux PC_Mux(PC_Adder_Out, PC_Imm_Adder_Out, 
    (Branch & Less & funct3 == 3'b100) | (Branch & (zero | !Less) & (funct3 == 3'b000 | funct3 == 3'b101)), 
    PC_In);
    // Data Memory:
    Data_Memory DM(ALU_Result, ReadData2, clk, MemWrite, MemRead, DM_Output);
    // Write Back Mux:
    Mux WB_Mux(ALU_Result, DM_Output, MemToReg, WriteData);
    
endmodule

