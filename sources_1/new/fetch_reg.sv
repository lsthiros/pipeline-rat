`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2017 02:56:36 PM
// Design Name: 
// Module Name: fetch_reg
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


module fetch_reg(
    input wire clk,
    input wire [17:0] instr,
    input wire [9:0] addr,
    input wire stall,
    output wire [17:0] instr_out,
    output wire [9:0] addr_out
    );
    
    reg [9:0] internal_addr;
    reg [17:0] internal_instr;
    
    always @ (posedge(clk)) begin
        if (!stall) begin
            internal_addr <= addr;
            internal_instr <= instr;
        end
    end
endmodule
