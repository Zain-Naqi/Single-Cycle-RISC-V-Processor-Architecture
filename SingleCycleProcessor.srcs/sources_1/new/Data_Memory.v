`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 03:14:35 PM
// Design Name: 
// Module Name: Data_Memory
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


module Data_Memory(
    input [63:0] Mem_Addr,     // Memory address input
    input [63:0] Write_Data,    // Data to write into memory
    input clk,                  // Clock signal for synchronous operations
    input MemWrite,             // Control signal to enable writing to memory
    input MemRead,              // Control signal to enable reading from memory
    output reg [63:0] Read_Data // Output data read from memory
);

reg [7:0] memory [0:1023];
integer i;
initial begin
    for (i = 0; i < 1024; i = i + 1) begin
        memory[i] = i;
    end
end

always @(posedge clk) begin
    if (MemWrite) begin
        memory[Mem_Addr]     <= Write_Data[7:0];
        memory[Mem_Addr+1]   <= Write_Data[15:8];
        memory[Mem_Addr+2]   <= Write_Data[23:16];
        memory[Mem_Addr+3]   <= Write_Data[31:24];
//        memory[Mem_Addr+4]   <= Write_Data[39:32];
//        memory[Mem_Addr+5]   <= Write_Data[47:40];
//        memory[Mem_Addr+6]   <= Write_Data[55:48];
//        memory[Mem_Addr+7]   <= Write_Data[63:56];
    end
end

always @(*) begin
    if (MemRead) begin
//        Read_Data = {memory[Mem_Addr+7], memory[Mem_Addr+6], memory[Mem_Addr+5], memory[Mem_Addr+4],
//                     memory[Mem_Addr+3], memory[Mem_Addr+2], memory[Mem_Addr+1], memory[Mem_Addr]};

        Read_Data = {memory[Mem_Addr+3], memory[Mem_Addr+2], memory[Mem_Addr+1], memory[Mem_Addr]};
    end else begin
        Read_Data = 64'b0;
    end
end

endmodule

