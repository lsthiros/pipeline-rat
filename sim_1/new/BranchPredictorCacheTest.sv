`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2017 07:23:47 PM
// Design Name: 
// Module Name: BranchPredictorCacheTest
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


module BranchPredictorCacheTest(
    );
    
    reg clk = 1'b1;
    reg rst = 0;
    reg [9:0] pc = 0;
    reg [9:0] update_pc = 0;
    reg we = 0;
    reg branch_taken = 0;
    wire read_hit;
    wire [2:0] update_history;
    wire [2:0] read_history;
    wire evict;
    
    cache myCache(
        .rst(rst),
        .clk(clk),
        .we(we),
        .branch_taken(branch_taken),
        .pc(pc),
        .update_pc(update_pc),
        .read_history(read_history),
        .read_hit(read_hit),
        .update_history(update_history),
        .evict(evict)
    );
        
    
    always begin #1
        clk <= ~clk;
    end
    
    initial begin
        #1
        rst = 1;
        #2
        rst = 0;
        #2
        we = 1;
        pc = 10'h4;
        branch_taken = 1;
        #2
        we = 0;
        #2
        we = 1;
        #2
        we = 0;
        #3000;
    end
endmodule
