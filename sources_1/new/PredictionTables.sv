`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/02/2017 02:46:24 PM
// Design Name:
// Module Name: PredictionTables
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


module PredictionTables(
    input wire clk,
    input wire rst,
    input wire we,
    input wire branch_taken,
    input wire [9:0] pc,
    input wire [9:0] old_pc,
    input wire evict,
    input wire [2:0] prev_history,
    input wire [2:0] update_history,
    output wire prediction
    );

    parameter ENTRY_WIDTH = 4;
    parameter ENTRY_DEPTH = 1 << ENTRY_WIDTH;

    wire [3:0] table_index = pc[3:0];
    wire [3:0] update_table_index = old_pc[3:0];

    logic ind_rst [0:ENTRY_DEPTH - 1];
    logic [1:0] ind_prediction [0:ENTRY_DEPTH - 1];
    logic ind_update [0:ENTRY_DEPTH - 1];

    generate
        genvar idx;
        for (idx = 0; idx < ENTRY_DEPTH; idx++) begin
            assign ind_update[integer'(idx)] = (integer'(old_pc) == integer'(idx) && we);
            assign ind_rst[integer'(idx)] = (integer'(table_index) == integer'(idx) && evict || rst);
        end
    endgenerate

    RecTable tables [0:ENTRY_DEPTH - 1] (
        .clk(clk),
        .rst(ind_rst),
        .rec(ind_prediction),
        .update(ind_update),
        .addr(prev_history),
        .wr_addr(update_history),
        .taken(branch_taken)
    );


    assign prediction = ind_prediction[integer'(table_index)][1];
endmodule
