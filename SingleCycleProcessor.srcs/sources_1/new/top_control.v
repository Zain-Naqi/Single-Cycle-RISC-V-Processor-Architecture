`timescale 1ns / 1ps

module top_control(
    input [6:0] Opcode,
    input [3:0] Funct,
    output Branch,
    output MemRead,
    output MemToReg,
    output MemWrite,
    output ALUSrc,
    output RegWrite,
    output [3:0] Operation
    );
    
    wire [1:0] ALUOp;
    Control_Unit c1(Opcode,ALUOp,Branch,MemRead,MemToReg,MemWrite,ALUSrc,RegWrite);
    ALU_Control a1(ALUOp, Funct, Operation);
    
endmodule
