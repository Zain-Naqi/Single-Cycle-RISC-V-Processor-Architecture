`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 12:30:34 AM
// Design Name: 
// Module Name: Register_File
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


module Register_File(
    input [63:0] WriteData,      // 64-bit input data for writing to a register
    input [4:0] RS1,             // 5-bit address of register 1 (for reading)
    input [4:0] RS2,             // 5-bit address of register 2 (for reading)
    input [4:0] RD,              // 5-bit address of register destination (for writing)
    input RegWrite,              // Control signal for enabling register write
    input clk,                   // Clock signal for synchronizing the write operation
    input reset,                 // Reset signal to clear output registers
    output reg [63:0] ReadData1, // 64-bit output data for the first register read
    output reg [63:0] ReadData2  // 64-bit output data for the second register read
);

    reg [63:0] Registers [31:0];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            Registers[i] = 64'd0 + i;
        end
    end        
        always @(posedge clk) begin
            if (RegWrite) begin
                Registers[RD] <= WriteData;
            end             
        end                
        always @(*) begin
            if (reset) begin
                ReadData1 = 64'd0;
                ReadData2 = 64'd0;
            end
            else begin
                ReadData1 = Registers[RS1];
                ReadData2 = Registers[RS2];
            end
        end                              
endmodule
