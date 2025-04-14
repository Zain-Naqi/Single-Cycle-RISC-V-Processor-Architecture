`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2025 11:05:10 PM
// Design Name: 
// Module Name: RISC_V_Processor_tb
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


module RISC_V_Processor_tb();
reg clk;
reg reset;

RISC_V_Processor SingleCycle(clk, reset);

initial
begin
clk = 1;
reset = 1;
#1 reset = 0;
end

always begin 
    #5 clk = ~clk;
end 

endmodule
