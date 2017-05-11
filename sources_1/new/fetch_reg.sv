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
    input wire rst,
    input wire [9:0] alt_in,
    input wire branch_taken_in,
    output wire [17:0] instr_out,
    output wire [9:0] addr_out,
    output wire [9:0] alt_out,
    output wire branch_taken_out
    );

    reg [9:0] internal_addr = 0;
    reg [17:0] internal_instr = 0;
    reg [9:0] internal_alt_addr = 0;
    reg internal_branch_taken =0;

    assign instr_out = internal_instr;
    assign addr_out = internal_addr;
    assign alt_out = internal_alt_addr;
    assign branch_taken_out = internal_branch_taken;


    always @ (posedge(clk)) begin
        if (rst) begin
            internal_addr <= 0;
            internal_instr <= 0;
            internal_alt_addr <= 0;
            internal_branch_taken <=0;
        end
        else if (!stall) begin
            internal_addr <= addr;
            internal_instr <= instr;
            internal_alt_addr <= alt_in;
            internal_branch_taken <= branch_taken_in;
        end
    end
endmodule
