`timescale 1ns / 1ps

module ALU_64_bit(
    input [63:0] a,         // Operand A
    input [63:0] b,         // Operand B
    input Cin,              // Carry-in (not used here, but kept for extensibility)
    input [3:0] ALUOp,      // ALU Operation Code
    output reg Cout,        // Carry-out (not used in this example)
    output ZERO,            // ZERO flag
    output reg Less,        // Less-than flag
    output reg [63:0] Result// ALU Result
    );

    always @(*) begin
        case (ALUOp)
            4'b0000: Result = a & b;                  // AND
            4'b0001: Result = a | b;                  // OR
            4'b0010: Result = a + b;                  // ADD
            4'b0110: Result = a - b;                  // SUB
            4'b0111: Result = (a < b) ? 64'd1 : 64'd0; // SLT (Set Less Than)
            4'b1100: Result = ~(a | b);               // NOR
            4'b0011: Result = a << b;
            default: Result = 64'd0;
        endcase

        Less = (a < b) ? 1'b1 : 1'b0;
        Cout = 1'b0; // not calculated here, but you can implement if needed
    end

    assign ZERO = (Result == 64'd0) ? 1'b1 : 1'b0;

endmodule

