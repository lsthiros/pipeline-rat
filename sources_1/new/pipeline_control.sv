`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2017 02:39:06 PM
// Design Name: 
// Module Name: pipeline_control
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


module pipeline_control(
    input clk,
    input [4:0] reg_a,
    input [4:0] reg_b,
    input [4:0] reg_wb,
    input reg_wb_en,
    input [4:0] reg_ex,
    input reg_ex_en,
    input instr_type,
    input branch_taken,
    input reset,
    output imem_addr_mux,
    output fetch_latch_en,
    output dec_nop,
    output pc_inc,
    output pc_load,
    input pc_reset
    );
    
    typedef enum {CHECK, CALL, RAW_EX, BRANCH_MIS0, BRANCH_MIS1, INT} HazardState;
    
    reg [2:0] current_state;
    HazardState nextState = CHECK;
    
    wire raw_ex = ((reg_a == reg_ex) || (reg_b == reg_ex)) && reg_ex_en;
    wire raw_wb = ((reg_a == reg_wb) || (reg_b == reg_wb)) && reg_wb_en;
    wire call_det = 0;
    wire branch_miss = 0;
    wire pc_stall;
    wire mem_stall;
    
    assign dec_nop = (branch_miss || current_state == BRANCH_MIS0 || current_state == BRANCH_MIS1);
    assign pc_stall = (raw_ex || current_state == RAW_EX || raw_wb);
    assign mem_stall = pc_stall;
    
    
    
    always_comb @ *
    begin
        if(current_state == CHECK) begin
            if (raw_ex) begin
                nextState = RAW_EX;
            end else if (branch_miss) begin
                nextState = BRANCH_MIS0;
            end
        end
        else if (current_state == BRANCH_MIS0) begin
            nextState = BRANCH_MIS1;
        end
        else if (current_state == BRANCH_MIS1) begin
            nextState = CHECK;
        end
        else if (current_state == RAW_EX) begin
            nextState = CHECK;
        end
    end
    
    always_ff @ (posedge clk)
    begin
        current_state <= nextState;
    end

endmodule
