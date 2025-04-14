`timescale 1ns / 1ps

module ALU_Control(
    input [1:0] ALUOp,
    input [3:0] Funct,
    output reg [3:0] Operation
    );
    
    always @(*) begin
        case (ALUOp)
            2'b00:  Operation=4'b0010;
            2'b01: Operation=4'b0110;
            2'b10: 
                case(Funct)
                    4'b0000: Operation=4'b0010;
                    4'b1000: Operation=4'b0110;
                    4'b0111: Operation=4'b0000;
                    4'b0110: Operation=4'b0001;
                    4'b0001: Operation=4'b0011; // For slli instruction, we assign a random operation code and add an extra condition in ALU. The last three bits are funct3, and the first is just a random zero assigned by us assuming thhat the inst[30] (or a bit in immediate) will always be zero.
                    default: Operation=4'b0000;
                    endcase
            default: Operation<=4'b0000;
        endcase
    end
endmodule
