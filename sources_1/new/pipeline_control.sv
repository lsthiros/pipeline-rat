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
    input a_read,
    input b_read,
    output imem_addr_mux,
    output fetch_latch_stall,
    output dec_nop,
    output pc_inc,
    output pc_load,
    output pc_reset,
    output pc_mux_override
    );
    
    typedef enum {CHECK, CALL0, CALL1, RAW_EX, BRANCH_MIS0, BRANCH_MIS1, INT0, INT1, RESET0, RESET1, RETURN0, RETURN1, RETURN2} HazardState;
    
    HazardState current_state = CHECK;
    HazardState nextState = CHECK;
    
    wire raw_ex = ((reg_a == reg_ex) && a_read || (reg_b == reg_ex) && b_read) && reg_ex_en;
    wire raw_wb = ((reg_a == reg_wb) && a_read || (reg_b == reg_wb) && b_read) && reg_wb_en;
    wire call_det;
    wire branch_miss;
    wire pc_stall;
    wire mem_stall;
    wire return_det;
    
    assign dec_nop = (branch_taken || current_state == BRANCH_MIS0 || current_state == BRANCH_MIS1)
        || (interrupt || current_state == INT0 || current_state == INT1)
        || (return_det || current_state == RETURN0 || current_state == RETURN1 || current_state == RETURN2)
        || (instr_type == 4'h6 || current_state == CALL0 || current_state == CALL1)
        || (current_state == RESET0 || current_state == RESET1)
        || (current_state == RAW_EX || raw_wb || raw_ex);
    assign pc_stall = (raw_ex || current_state == RAW_EX || raw_wb || return_det);
    assign mem_stall = pc_stall;
    assign fetch_latch_stall = pc_stall; /*was fetch_reg_stall*/
    assign pc_reset = reset;
    assign pc_inc = (!pc_reset && !pc_load && !pc_stall);
    assign pc_load = branch_taken || return_det;
    assign pc_mux_override = 0;
    assign return_det = (instr_type == 4'h7 || instr_type == 4'h8 || instr_type == 4'h9);
    assign branch_miss = (instr_type == 4'h1 || instr_type == 4'h2 || instr_type == 4'h3 || instr_type == 4'h4 || instr_type == 4'h5);
    assign imem_addr_mux = pc_stall;
    
    
    always_comb
    begin
        if (reset) begin
            nextState = RESET0;
        end
        else begin
            if (interrupt) begin
                nextState = INT0;
            end
            else if(current_state == CHECK) begin
                if (raw_ex) begin
                    nextState = RAW_EX;
                end
                else if (instr_type == 4'h6) begin
                    nextState = CALL0;
                end
                else if (branch_taken && !return_det) begin
                    nextState = BRANCH_MIS0;
                end
                else if (return_det) begin
                    nextState = RETURN0;
                end
                else begin
                    nextState = CHECK;
                end
            end
            else if (current_state == BRANCH_MIS0) begin
                nextState = BRANCH_MIS1;
            end
            else if (current_state == RESET0) begin
                nextState = RESET1;
            end
            else if (current_state == INT0) begin
                nextState = INT1;
            end
            else if (current_state == RETURN0) begin
                nextState = RETURN1;
            end
            else if (current_state == CALL0) begin
                nextState = CALL1;
            end
            else begin
                nextState = CHECK;
            end
        end
    end
    
    always_ff @ (posedge clk)
    begin
        current_state <= nextState;
    end

endmodule
