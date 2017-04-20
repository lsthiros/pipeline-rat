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
    input [3:0] instr_type,
    input branch_taken,
    input reset,
    input interrupt,
    output imem_addr_mux,
    output fetch_latch_en,
    output dec_nop,
    output pc_inc,
    output pc_load,
    output pc_reset
    );
    
    typedef enum {CHECK, CALL, RAW_EX, BRANCH_MIS0, BRANCH_MIS1, INT0, INT1, RESET0, RESET1, RETURN0, RETURN1} HazardState;
    
    reg [3:0] current_state;
    HazardState nextState = CHECK;
    
    wire raw_ex = ((reg_a == reg_ex) || (reg_b == reg_ex)) && reg_ex_en;
    wire raw_wb = ((reg_a == reg_wb) || (reg_b == reg_wb)) && reg_wb_en;
    wire call_det;
    wire branch_miss;
    wire pc_stall;
    wire pc_load;
    wire mem_stall;
    wire return_det;
    
    assign dec_nop = (branch_miss || current_state == BRANCH_MIS0 || current_state == BRANCH_MIS1)
        || (interrupt || current_state == INT0 || current_state == INT1)
        || (return_det || current_state == RETURN0 || current_state == RETURN1);
    assign pc_stall = (raw_ex || current_state == RAW_EX || raw_wb);
    assign mem_stall = pc_stall;
    assign pc_reset = reset;
    assign pc_inc = (interrupt && !reset && !branch_taken);
    assign pc_load = branch_taken;
    assign return_det = (instr_type == 4'h7 || instr_type == 4'h8 || instr_type == 4'h9) || instr_type == 4'h6;
    assign branch_miss = (instr_type == 4'h1 || instr_type == 4'h2 || instr_type == 4'h3 || instr_type == 4'h4 || instr_type == 4'h5);
    
    
    
    always_comb
    begin
        if (reset) begin
            nextState <= RESET0;
        end
        if (interrupt) begin
            nextState <= INT0;
        end
        else if(current_state == CHECK) begin
            if (raw_ex) begin
                nextState <= RAW_EX;
            end
            else if (branch_miss) begin
                nextState <= BRANCH_MIS0;
            end
            else if (return_det) begin
                nextState <= RETURN0;
            end
        end
        else if (current_state == BRANCH_MIS0) begin
            nextState <= BRANCH_MIS1;
        end
        else if (current_state == BRANCH_MIS1) begin
            nextState <= CHECK;
        end
        else if (current_state == RAW_EX) begin
            nextState <= CHECK;
        end
        else if (current_state == RESET1) begin
            nextState <= CHECK;
        end
        else if (current_state == INT0) begin
            nextState <= INT1;
        end
        else if (current_state == INT1) begin
            nextState <= CHECK;
        end
        else if (current_state == RETURN0) begin
            nextState <= RETURN1;
        end
        else if (current_state == RETURN1) begin
            nextState <= CHECK;
        end
        else begin
            nextState <= CHECK;
        end
    end
    
    always_ff @ (posedge clk)
    begin
        current_state <= nextState;
    end

endmodule
