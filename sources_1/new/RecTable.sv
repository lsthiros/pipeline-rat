`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2017 02:14:28 PM
// Design Name: 
// Module Name: RecTable
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


module RecTable(
    input clk,
    input rst,
    input [2:0] addr,
    input [2:0] wr_addr,
    input update,
    input taken,
    output [1:0] rec
    );
    
    parameter HISTORY_WIDTH = 3;
    parameter HISTORY_DEPTH = 1 << HISTORY_WIDTH;
    
    logic [1:0] recs [0:HISTORY_DEPTH - 1];
    
    always_ff @ (posedge(clk)) begin
        if(rst) begin
            for (int i = 0; i < HISTORY_DEPTH; i++) begin
                recs[i] <= 0;
            end
        end
        else if (update) begin
            if (taken && recs[integer'(wr_addr)] != 2'h3) begin
                recs[integer'(wr_addr)] <= recs[integer'(wr_addr)] + 1;
            end
            else if (!taken && recs[integer'(wr_addr)] != 0) begin
                recs[integer'(wr_addr)] <= recs[integer'(wr_addr)] - 1;
            end
        end
    end
    
    assign rec = recs[integer'(addr)];
endmodule
