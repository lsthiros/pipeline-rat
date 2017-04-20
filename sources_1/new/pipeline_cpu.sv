`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2017 10:37:54 PM
// Design Name: 
// Module Name: pipeline_cpu
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


module pipeline_cpu(
    input clk
    );
    
    wire interrupt;
    
    wire [9:0] pc_immed_address;
    wire [9:0] pc_stack_address;
    wire pc_load;
    wire pc_inc;
    wire pc_reset;
    wire pc_mux_sel;
    wire pc_count;
    
    wire mem_stall;
    
    /* Register should always contain address that is out on memory line */
    reg [9:0] pc_delay;
    
    logic [9:0] rom_address;
    wire [17:0] rom_instr;
    
    wire fetch_reg_stall;
    
    wire [17:0] fetch_instr_out;
    wire [9:0]  fetch_addr_out;
    
    /* Register file interface */
    wire [7:0] reg_data_in;
    wire [4:0] reg_wr_addr;
    wire [7:0] reg_dx_out;
    wire [7:0] reg_dy_out;
    wire reg_wr_en;
    wire [4:0] reg_addr_x;
    wire [4:0] reg_addr_y;
    
    wire dec_pc_ld;
    wire dec_pc_inc;
    wire dec_pc_mux_sel;
    wire dec_sp_ld;
    wire dec_sp_incr;
    wire dec_sp_decr;
    wire dec_rf_wr;
    wire [1:0] dec_rf_wr_sel;
    wire dec_alu_opy_sel;
    wire [3:0] dec_alu_sel;
    wire dec_scr_we;
    wire dec_scr_data_sel;
    wire [1:0] dec_scr_addr_sel;
    wire dec_flg_c_set;
    wire dec_flg_c_clr;
    wire dec_flg_c_ld;
    wire dec_flg_z_ld;
    wire dec_flg_ld_sel;
    wire dec_flg_shad_ld;
    wire dec_i_set;
    wire dec_i_clr;
    wire dec_iostrobe;
    wire [3:0] dec_branch_type;
    
    wire cv_pc_ld;
    wire cv_pc_inc;
    wire cv_pc_mux_sel;
    wire cv_sp_ld;
    wire cv_sp_incr;
    wire cv_sp_decr;
    wire cv_rf_wr;
    wire [1:0] cv_rf_wr_sel;
    wire cv_alu_opy_sel;
    wire [3:0] cv_alu_sel;
    wire cv_scr_we;
    wire cv_scr_data_sel;
    wire [1:0] cv_scr_addr_sel;
    wire cv_flg_c_set;
    wire cv_flg_c_clr;
    wire cv_flg_c_ld;
    wire cv_flg_z_ld;
    wire cv_flg_ld_sel;
    wire cv_flg_shad_ld;
    wire cv_i_set;
    wire cv_i_clr;
    wire cv_iostrobe;
    wire cv_ir;
    wire [3:0] cv_branch_type;
    
    wire pipeline_control_int;
    wire pipeline_control_reset;
    wire pipeline_control_nop;
    
    wire [7:0] sp_data_out;
    
    PC my_pc (
        .CLK        (clk),
        .PC_INC     (pc_inc),
        .PC_LOAD    (pc_load),
        .RST        (pc_reset),
        .PC_MUX_SEL (pc_mux_sel),
        .FROM_IMMED (pc_immed_address),
        .FROM_STACK (pc_stack_address),
        .PC_COUNT   (pc_count)
    );
    
    /* Handles stall cases for prog rom */
    always_comb begin
        /* TODO: resolve interrupt case for when it happens during delays */
        if (interrupt) begin
            rom_address <= 10'h3FF;
        end
        else if (mem_stall) begin
            rom_address <= pc_delay;
        end
        else begin
            rom_address <= pc_count;
        end
    end
    
    prog_rom my_prog_rom(
        .CLK         (clk),
        .ADDRESS     (rom_address),
        .INSTRUCTION (rom_instr)
    );
    
    fetch_reg my_fetch_reg(
        .clk      (clk),
        .instr    (rom_instr),
        .addr     (pc_delay),
        .stall    (fetch_reg_stall),
        .addr_out (fetch_addr_out),
        .addr_out (fetch_instr_out)
    );
    
    RegisterFile my_reg_file(
        .CLK (clk),
        .ADRX (fetch_instr_out[12:8]),
        .ADRY (fetch_instr_out[7:3]),
        .WR_ADR (reg_wr_adr),
        .DX_OUT (reg_dx_out),
        .DY_OUT (reg_dy_out),
        .D_IN   (reg_data_in),
        .WE     (reg_wr_en)
    );
    
    DECODER my_decoder(
        .CLK (clk),
        .OPCODE_HI_5 (fetch_instr_out[17:13]),
        .OPCODE_LO_2 (fetch_instr_out[1:0]),
        .INT         (pipeline_control_int),
        .RESET       (pipeline_control_reset),
        .PC_LD(dec_pc_ld),
        .PC_INC(dec_pc_inc),
        .PC_MUX_SEL (dec_pc_mux_sel),
        .SP_LD (dec_sp_ld),
        .SP_INCR (dec_sp_incr),
        .SP_DECR (dec_sp_decr),
        .RF_WR(dec_rf_wr),
        .RF_WR_SEL (dec_rf_wr_sel),
        .ALU_OPY_SEL (dec_alu_opy_sel),
        .ALU_SEL (dec_alu_sel),
        .SCR_WE  (dec_scr_we),
        .SCR_DATA_SEL (dec_scr_data_sel),
        .SCR_ADDR_SEL (dec_scr_addr_sel),
        .FLG_C_SET (dec_flg_c_set),
        .FLG_C_CLR (dec_flg_c_clr),
        .FLG_C_LD (dec_flg_c_ld),
        .FLG_Z_LD (dec_flg_z_ld),
        .FLG_LD_SEL (dec_flg_ld_sel),
        .FLG_SHAD_LD (dec_flg_shad_ld),
        .I_SET(dec_i_set),
        .I_CLR(dec_i_clr),
        .IO_STROBE (dec_iostrobe),
        .BRANCH_TYPE (dec_branch_type)
    );
    
    control_vector_reg my_ctr_vect_reg(
        .in_PC_LD(dec_pc_ld),   
        .in_PC_INC(dec_pc_inc),   
        .in_PC_MUX_SEL(dec_pc_mux_sel),
        .in_SP_LD(dec_sp_ld),   
        .in_SP_INCR(dec_sp_incr),   
        .in_SP_DECR(dec_sp_decr),   
        .in_RF_WR(dec_rf_wr),   
        .in_RF_WR_SEL(dec_rf_wr_sel),   
        .in_ALU_OPY_SEL(dec_alu_opy_sel),   
        .in_ALU_SEL(dec_alu_sel),     
        .in_SCR_WE(dec_scr_we),   
        .in_SCR_DATA_SE(dec_scr_data_se),   
        .in_SCR_ADDR_SE(dec_scr_addr_se),
        .in_FLG_C_SET(dec_flg_c_set),   
        .in_FLG_C_CLR(dec_flg_c_clr),   
        .in_FLG_C_LD(dec_flg_c_ld),   
        .in_FLG_Z_LD(dec_flg_z_ld),   
        .in_FLG_LD_SEL(dec_flg_ld_sel),   
        .in_FLG_SHAD_LD(dec_flg_shad_ld),   
        .in_I_SET(dec_i_set),   
        .in_I_CLR(dec_i_clr),   
        .in_IO_STRBE(dec_io_strobe),   
        .in_BRANCH_TYPE(dec_branch_type), 
        .in_rst(dec_rst),   
        .iterupt(pipeline_control_int), // this might be the interupt from control not instruction             
        .clk(clk),                   
        .nop(pipeline_control_nop),
                           
        .out_PC_LD(cv_pc_ld),   
        .out_PC_INC(cv_pc_inc),   
        .out_PC_MUX_SEL(cv_pc_mux_sel),
        .out_SP_LD(cv_sp_ld),   
        .out_SP_INCR(cv_sp_incr),   
        .out_SP_DECR(cv_sp_decr),   
        .out_RF_WR(cv_rf_wr),   
        .out_RF_WR_SEL(cv_rf_wr_sel),   
        .out_ALU_OPY_SEL(cv_alu_opy_sel),   
        .out_ALU_SEL(cv_alu_sel),     
        .out_SCR_WE(cv_scr_we),   
        .out_SCR_DATA_SE(cv_scr_data_se),   
        .out_SCR_ADDR_SE(cv_scr_addr_se),
        .out_FLG_C_SET(cv_flg_c_set),   
        .out_FLG_C_CLR(cv_flg_c_clr),   
        .out_FLG_C_LD(cv_flg_c_ld),   
        .out_FLG_Z_LD(cv_flg_z_ld),   
        .out_FLG_LD_SEL(cv_flg_ld_sel),   
        .out_FLG_SHAD_LD(cv_flg_shad_ld),   
        .out_I_SET(cv_i_set),   
        .out_I_CLR(cv_i_clr),   
        .out_IO_STRBE(cv_io_strobe),   
        .out_BRANCH_TYPE(cv_branch_type), 
        .in_rst(cv_rst),                 
        .clk(clk),                   
        .nop(pipeline_control_nop),
        
        	// instruction data
        .in_IR(fetch_instr_out[6:0]),
        .out_IR (cv_ir),
        // register values
        .in_DX (reg_dx_out),
        .out_DX (cv_dx_out),
        .in_DY (reg_dy_out),
        .out_DY (cv_dy_out),
        // addresses
        .in_WB_ADDR(reg_addr_x),
        .out_WB_ADDR (cv_wb_addr),
        // program counters
        .in_PC (fetch_addr_out),
        .out_PC (cv_pc_out)    
    );
    
    wire alu_c;
    wire alu_b;
    wire alu_z;
    wire [7:0] alu_result;
    
    wire flg_c;
    wire flg_z;
    wire flg_i;
    
    Flags my_flags(
        .CLK(clk),
        .FLG_C_SET(cv_flg_c_set),
        .FLG_C_CLR(cv_flg_c_clr),
        .FLG_C_LD(cv_flg_c_ld),
        .FLG_Z_LD(cv_z_ld),
        .FLG_LD_SEL(cv_flg_ld_sel),
        .FLG_SHAD_LD(cv_flg_shad_ld),
        .C (alu_c),
        .Z (alu_z),
        .C_FLAG (flg_c),
        .Z_FLAG (flg_z)
    );
    
    I_FLAG my_i_flag(
        .CLK(clk),
        .I_SET (cv_i_set),
        .I_CLR (cv_i_clr),
        .I_OUT (flg_i)
    );
    
    assign alu_b = (cv_alu_opy_sel == 1'b1) ? cv_ir : cv_dy_out;
    ALU my_alu(
        .SEL(cv_alu_sel),
        .A (cv_out_dx),
        .B (alu_b),
        .CIN (flg_c),
        .C (alu_c),
        .Z (alu_z),
        .RESULT(alu_result)
    );
    
    logic [7:0] scr_addr;
    logic [9:0] scr_data_in;
    wire [9:0] scr_data_out;
    
    wire [8:0] sp_data_out;
    
    always_comb begin
        case (cv_scr_addr_sel)
            2'h0: scr_addr <= cv_dy_out;
            2'h1: scr_addr <= cv_ir;
            2'h2: scr_addr <= sp_data_out;
            default: scr_addr <= (sp_data_out - 8'b1); // not sure if this works
        endcase
    end
    
    assign scr_data_in = (cv_scr_data_sel) ? cv_pc_out + 10'h1 : cv_dx_out;
    
    SCRATCH_RAM my_scratch_ram(
        .CLK(clk),
        .WE(cv_scr_we),
        .ADDR(cv_scr_addr),
        .DATA_IN(scr_data_in),
        .DATA_OUT(scr_data_out)
    );
    
    assign pc_stack_address = scr_data_out;
    assign pc_immed_address = 0; /* TODO: get actual address from decoder */
    
    SP my_sp(
        .CLK(clk),
        .SP_LD(cv_sp_ld),
        .SP_INC(cv_sp_inc),
        .SP_DECR(cv_sp_decr),
        .DATA_IN(cv_dx_out),
        .DATA_OUT(sp_data_out)
    );
    
    
    always @ (posedge(clk)) begin
        /* When memory is stalled, delay reg should retain value */
        if (!mem_stall) begin
            pc_delay <= pc_count;
        end
    end
    
endmodule


/* write back reg */
module writeback_reg(
    input logic clk,
    input logic in_write,
    input logic [7:0] in_result,
    input logic [7:0] in_immed_val,
    input logic [7:0] in_in,
    input logic [7:0] in_out,
    input logic [1:0] in_rf_wr_sel,
    output logic       out_write,
    output logic [7:0] out_result,
    output logic [7:0] out_immed_val,
    output logic [7:0] out_in,
    output logic [7:0] out_out,
    output logic [1:0] out_rf_wr_sel
);

always @ (posedge clk) begin
  out_write      <= in_write;    
  out_result     <= in_result;    
  out_immed_val  <= in_immed_val; 
  out_in         <= in_in;        
  out_out        <= in_out;       
  out_rf_wr_sel  <= in_rf_wr_sel;
end
  
endmodule
