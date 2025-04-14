`timescale 1ns / 1ps

module Control_Unit(
    input [6:0] Opcode,           // 7-bit input Opcode representing instruction type
    output reg [1:0] ALUOp,       // 2-bit ALU operation control signal
    output reg Branch,            // Branch control signal
    output reg MemRead,           // Memory Read control signal
    output reg MemtoReg,          // Memory to Register control signal
    output reg MemWrite,          // Memory Write control signal
    output reg ALUSrc,            // ALU Source control signal (use of immediate or register)
    output reg RegWrite           // Register Write control signal
    );
    
    reg [7:0] array;
    
always @(*) begin
    case(Opcode) 
        7'b0110011: array=8'b00100010;
        7'b0000011: array=8'b11110000;
        7'b0100011: array=8'b1X001000; //don't care 2nd bit
        7'b1100011: array=8'b0X000101; //don't care 2nd bit
        7'b0010011: array=8'b10100010; //slli and addi case
        default: array=8'b00000000;
    endcase
    
    ALUSrc<=array[7];
    MemtoReg<=array[6];
    RegWrite<=array[5];
    MemRead<=array[4];
    MemWrite<=array[3];
    Branch<=array[2];
    ALUOp[1]<= array[1];
    ALUOp[0]<= array[0];
end

endmodule
