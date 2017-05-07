`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2017 06:24:49 PM
// Design Name: 
// Module Name: BranchPredictor
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


module BranchPredictor(
    input wire clk,
    input wire rst,
    input wire [9:0] pc,
    input wire [9:0] update_pc,
    input wire branch_taken,
    input wire update_entry,
    input wire we,
    output wire prediction
    );
    
    wire evict;
    wire [2:0] update_history;
    wire [2:0] read_history;
    wire read_hit;
    wire table_prediction;
    
    cache myCache(
    .clk(clk),
    .rst(rst),
    .we(we),
    .branch_taken(branch_taken),
    .pc(pc),
    .update_pc(update_pc),
    .read_history(read_history),
    .read_hit(read_hit),
    .update_history(update_history),
    .evict(evict)
    );
    
    PredictionTables myTables(
        .clk(clk),
        .rst(rst),
        .we(we),
        .branch_taken(branch_taken),
        .pc(pc),
        .old_pc(update_pc),
        .evict(evict),
        .prev_history(read_history),
        .update_history(update_history),
        .prediction(table_prediction)
    );
    
    assign prediction = table_prediction && ~evict;
endmodule
