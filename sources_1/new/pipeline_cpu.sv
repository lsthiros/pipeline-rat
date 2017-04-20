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
    
    wire pipeline_control_int;
    wire pipeline_control_reset;
    
    
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
    always_comb @ * begin
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
    
    always @ (posedge(clk)) begin
        /* When memory is stalled, delay reg should retain value */
        if (!mem_stall) begin
            pc_delay <= pc_count;
        end
    end
    
endmodule
