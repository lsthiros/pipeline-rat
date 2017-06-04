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
    input wire clk,
    input wire [4:0] reg_a,
    input wire [4:0] reg_b,
    input wire [4:0] reg_wb,
    input wire reg_wb_en,
    input wire [4:0] reg_ex,
    input wire reg_ex_en,
    input wire [3:0] instr_type,
    input wire branch_miss,
    input wire predicted_branch_taken,
    input wire reset,
    input wire interrupt,
    input wire interrupt_flag,
    input wire a_read,
    input wire b_read,
    input wire [1:0] instr_pc_mux_sel,
    output wire imem_addr_mux,
    output wire fetch_latch_stall,
    output wire dec_nop,
    output wire dec_int,
    output wire pc_inc,
    output wire pc_load,
    output wire pc_reset,
    output logic [2:0] pc_mux_sel
    );
    
    typedef enum {CHECK, CALL0, CALL1, RAW_EX, BRANCH_MIS0, BRANCH_MIS1, INT0, INT1, INT2, RESET0, RESET1, RETURN0, RETURN1,
        PREDICT_BRANCH} HazardState;
    
    HazardState current_state = CHECK;
    HazardState nextState = CHECK;
    reg prediction_loaded = 0;
    
    wire valid_predicted_branch = predicted_branch_taken && current_state != PREDICT_BRANCH && !prediction_loaded;
    
    wire raw_ex = ((reg_a == reg_ex) && a_read || (reg_b == reg_ex) && b_read) && reg_ex_en;
    wire raw_wb = ((reg_a == reg_wb) && a_read || (reg_b == reg_wb) && b_read) && reg_wb_en;
    wire call_det = instr_type == 4'h6;
    wire brn_det;
    wire pc_stall;
    wire return_det;
    
    assign dec_nop = (branch_miss || current_state == BRANCH_MIS0 || current_state == BRANCH_MIS1)
        || (current_state == INT0 || current_state == INT1 || current_state == INT2)
        || (return_det || current_state == RETURN0 || current_state == RETURN1)
        || (call_det || current_state == CALL0 || current_state == CALL1)
        || (current_state == RESET0 || current_state == RESET1)
        || (current_state == RAW_EX || raw_wb || raw_ex)
        || (current_state == PREDICT_BRANCH);
    assign dec_int = (interrupt && interrupt_flag) && (current_state == CHECK);
    assign pc_stall = (((raw_ex || raw_wb) && !valid_predicted_branch) || current_state == RAW_EX || return_det);
    /* This is memory stall... */
    assign imem_addr_mux = pc_stall || valid_predicted_branch;
    assign fetch_latch_stall = pc_stall || valid_predicted_branch; /*was fetch_reg_stall*/
    assign pc_reset = reset;
    assign pc_inc = (!pc_reset && !pc_load && !pc_stall);
    assign pc_load = (valid_predicted_branch || branch_miss || call_det || return_det || current_state == INT0);
    assign return_det = (instr_type == 4'h7 || instr_type == 4'h8 || instr_type == 4'h9);
    
    
    always_comb
    begin
        if (reset) begin
            nextState = RESET0;
        end
        else begin
            if (interrupt && interrupt_flag) begin
                nextState = INT0;
            end
            else if(current_state == CHECK) begin
                if (raw_ex) begin
                    nextState = RAW_EX;
                end
                else if (instr_type == 4'h6) begin
                    nextState = CALL0;
                end
                else if (branch_miss && !return_det) begin
                    nextState = BRANCH_MIS0;
                end
                else if (return_det) begin
                    nextState = RETURN0;
                end
                else if (valid_predicted_branch) begin
                    nextState = PREDICT_BRANCH;
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
            else if (current_state == INT1) begin
                nextState = INT2;
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
        
        if (branch_miss) begin
            pc_mux_sel = 3'h3;
        end
        else if (valid_predicted_branch) begin
            pc_mux_sel = 3'h4;
        end
        else begin
            pc_mux_sel = {1'h0, instr_pc_mux_sel};
        end
    end
    
    always_ff @ (posedge clk)
    begin
        current_state <= nextState;
        if (reset) begin
            prediction_loaded <= 0;
        end
        else if (nextState == RAW_EX) begin
            prediction_loaded <= 1;
        end
        else if (current_state == CHECK) begin
            prediction_loaded <=0;
        end
    end

endmodule
