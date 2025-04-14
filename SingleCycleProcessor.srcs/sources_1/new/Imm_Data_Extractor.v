`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 12:16:11 AM
// Design Name: 
// Module Name: Imm_Data_Extractor
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


module Imm_Data_Extractor(
    input [31:0] instruction,
    output reg [63:0] imm_data
);

always@* begin
    if (instruction[6] == 1'b1)
        imm_data[11:0] = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
    else if (instruction[6:5] == 2'b00)
        imm_data[11:0] = instruction[31:20];
    else if (instruction[6:5] == 2'b01)
        imm_data[11:0] = {instruction[31:25], instruction[11:7]};
end

always@* begin
    imm_data[63:12] = {52{imm_data[11]}};
end 
   
endmodule

