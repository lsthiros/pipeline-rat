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
    input clk,
    input rst,
    input input_interrupt,
    input [7:0] in_port,
    output [7:0] out_port,
    output [7:0] port_id,
    output io_strb
    );
    
    wire interrupt;
    
    wire [9:0] pc_immed_address;
    wire pc_load;
    wire pc_inc;
    wire pc_reset;
    logic [1:0] pc_mux_sel;
    wire [9:0] pc_count;
    
    wire mem_stall;
    
    /* Register should always contain address that is out on memory line */
    reg [9:0] pc_delay = 0;
    
    logic [9:0] rom_address;
    wire [17:0] rom_instr;
    
    wire fetch_reg_stall;
    
    wire [17:0] fetch_instr_out;
    wire [9:0]  fetch_addr_out;
    
    /* Register file interface */
    logic [7:0] reg_data_in;
    wire [4:0] reg_wr_addr;
    wire [7:0] reg_dx_out;
    wire [7:0] reg_dy_out;
    wire reg_wr_en;
    wire [4:0] reg_addr_x;
    wire [4:0] reg_addr_y;
    
    wire dec_pc_ld;
    wire dec_pc_inc;
    wire [1:0] dec_pc_mux_sel;
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
    wire [1:0] cv_pc_mux_sel;
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
    wire [7:0] cv_dx_out;
    wire [7:0] cv_dy_out;
    wire cv_flg_c_set;
    wire cv_flg_c_clr;
    wire cv_flg_c_ld;
    wire cv_flg_z_ld;
    wire cv_flg_ld_sel;
    wire cv_flg_shad_ld;
    wire cv_i_set;
    wire cv_i_clr;
    wire cv_iostrobe;
    wire [7:0] cv_ir;
    wire [3:0] cv_branch_type;
    wire [4:0] cv_wb_addr;
    wire [9:0] cv_dest_addr;
    wire [9:0] cv_pc_out;
    
    wire pipeline_control_int;
    wire pipeline_control_reset;
    wire pipeline_control_nop;
    wire pipeline_control_a_read;
    wire pipeline_control_b_read;
    wire pipeline_control_pc_mux_override;
    
    wire [7:0] sp_data_out;
    
    logic [7:0] scr_addr;
    logic [9:0] scr_data_in;
    wire [9:0] scr_data_out;
    
    wire [7:0] wb_scr;
    wire [7:0] wb_sp;
    
    always_comb begin
        if (pipeline_control_pc_mux_override) begin
            pc_mux_sel = 2'h1;
        end
        else begin
            pc_mux_sel = cv_pc_mux_sel;
        end
    end
    
    PC my_pc (
        .CLK        (clk),
        .PC_INC     (pc_inc),
        .PC_LD    (pc_load),
        .RST        (pc_reset),
        .PC_MUX_SEL (pc_mux_sel),
        .FROM_IMMED (pc_immed_address),
        .FROM_STACK (scr_data_out),
        .PC_COUNT   (pc_count)
    );
    
    /* Handles stall cases for prog rom */
    always_comb begin
        /* TODO: resolve interrupt case for when it happens during delays */
        if (interrupt) begin
            rom_address <= 10'h3F;
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
        .rst      (rst),
        .clk      (clk),
        .instr    (rom_instr),
        .addr     (pc_delay),
        .stall    (fetch_reg_stall),
        .addr_out (fetch_addr_out),
        .instr_out (fetch_instr_out)
    );
    
    assign reg_addr_x = fetch_instr_out[12:8];
    assign reg_addr_y = fetch_instr_out[7:3];
    
    RegisterFile my_reg_file(
        .CLK (clk),
        .ADRX (reg_addr_x),
        .ADRY (reg_addr_y),
        .WR_ADR (reg_wr_addr),
        .DX_OUT (reg_dx_out),
        .DY_OUT (reg_dy_out),
        .D_IN   (reg_data_in),
        .WE     (reg_wr_en)
    );
    
    DECODER my_decoder(
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
        .IO_STRB (dec_iostrobe),
        .BRANCH_TYPE (dec_branch_type),
        .REG_X_READ(pipeline_control_a_read),
        .REG_Y_READ(pipeline_control_b_read)
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
        .in_SCR_DATA_SE(dec_scr_data_sel),   
        .in_SCR_ADDR_SE(dec_scr_addr_sel),
        .in_FLG_C_SET(dec_flg_c_set),   
        .in_FLG_C_CLR(dec_flg_c_clr),   
        .in_FLG_C_LD(dec_flg_c_ld),   
        .in_FLG_Z_LD(dec_flg_z_ld),   
        .in_FLG_LD_SEL(dec_flg_ld_sel),   
        .in_FLG_SHAD_LD(dec_flg_shad_ld),   
        .in_I_SET(dec_i_set),   
        .in_I_CLR(dec_i_clr),   
        .in_IO_STRB(dec_iostrobe),   
        .in_BRANCH_TYPE(dec_branch_type), 
        .in_rst(rst),   
        .interupt(pipeline_control_int), // this might be the interupt from control not instruction             
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
        .out_SCR_DATA_SE(cv_scr_data_sel),   
        .out_SCR_ADDR_SE(cv_scr_addr_sel),
        .out_FLG_C_SET(cv_flg_c_set),   
        .out_FLG_C_CLR(cv_flg_c_clr),   
        .out_FLG_C_LD(cv_flg_c_ld),   
        .out_FLG_Z_LD(cv_flg_z_ld),   
        .out_FLG_LD_SEL(cv_flg_ld_sel),   
        .out_FLG_SHAD_LD(cv_flg_shad_ld),   
        .out_I_SET(cv_i_set),   
        .out_I_CLR(cv_i_clr),   
        .out_IO_STRB(io_strb),   
        .out_BRANCH_TYPE(cv_branch_type),
        
        	// instruction data
        .in_IR(fetch_instr_out[7:0]),
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
        .out_PC (cv_pc_out),
        
        .in_dest_addr(fetch_instr_out[12:3]),
        .out_dest_addr(cv_dest_addr)
    );

    assign port_id = cv_ir;
    assign out_port = cv_dx_out;
    
    wire alu_c;
    wire [7:0] alu_b;
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
        .FLG_Z_LD(cv_flg_z_ld),
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
        .A (cv_dx_out),
        .B (alu_b),
        .CIN (flg_c),
        .C (alu_c),
        .Z (alu_z),
        .RESULT(alu_result)
    );
    
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
        .ADDR(scr_addr),
        .DATA_IN(scr_data_in),
        .DATA_OUT(scr_data_out)
    );
    
    assign pc_immed_address = cv_dest_addr;
    
    SP my_sp(
        .RST(rst),
        .CLK(clk),
        .SP_LD(cv_sp_ld),
        .SP_INCR(cv_sp_incr),
        .SP_DECR(cv_sp_decr),
        .DATA_IN(cv_dx_out),
        .DATA_OUT(sp_data_out)
    );
    
    wire bc_branch_taken;
    BRANCH_CALCULATOR my_branch_calculator(
        .BRANCH_TYPE(cv_branch_type),
        .C(flg_c),
        .Z(flg_z),
        .BRANCH_TAKEN(bc_branch_taken)    
    );
    
    wire [7:0] wb_result;
    wire [7:0] wb_immed_val;
    wire [7:0] wb_in;
    wire [1:0] wb_rf_wr_sel;
    
    writeback_reg my_writeback_reg(
        .rst(rst),
        .clk(clk),
        .in_rf_wr_sel(cv_rf_wr_sel),
        .in_write(cv_rf_wr),
        .in_result(alu_result),
        .in_immed_val(cv_ir),
        .in_reg_addr(cv_wb_addr),
        .in_in(in_port),
        .in_scr(scr_data_out[7:0]),
        .out_result(wb_result),
        .out_immed_val(wb_immed_val),
        .out_in(wb_in),
        .out_rf_wr_sel(wb_rf_wr_sel),
        .out_write(reg_wr_en),
        .out_reg_addr(reg_wr_addr),
        .out_scr(wb_scr),
        .out_sp(wb_sp)
    );
    
    pipeline_control my_pipeline_control(
        .clk(clk),
        .reg_a(reg_addr_x),
        .reg_b(reg_addr_y),
        .reg_wb(reg_wr_addr),
        .reg_wb_en(reg_wr_en),
        .reg_ex(cv_wb_addr),
        .reg_ex_en(cv_rf_wr),
        .instr_type(cv_branch_type),
        .branch_taken(bc_branch_taken),
        .reset(rst),
        .interrupt(input_interrupt),
        .interrupt_flag(flg_i),
        
        .imem_addr_mux(mem_stall),
        .fetch_latch_stall(fetch_reg_stall),
        .dec_nop(pipeline_control_nop),
        .dec_int(pipeline_control_int),
        .pc_inc(pc_inc),
        .pc_load(pc_load),
        .pc_reset(pc_reset),
        .pc_mux_override(pipeline_control_pc_mux_override),
        .a_read(pipeline_control_a_read),
        .b_read(pipeline_control_b_read)
    );
    
    always_comb begin
        case(wb_rf_wr_sel)
            2'h0: reg_data_in <= wb_result;
            2'h1: reg_data_in <= wb_scr;
            2'h2: reg_data_in <= wb_sp;
            default: reg_data_in <= wb_in;
        endcase
    end
    
    always @ (posedge(clk)) begin
        /* When memory is stalled, delay reg should retain value */
        if (!mem_stall) begin
            pc_delay <= pc_count;
        end
    end
    
endmodule


/* write back reg */
module writeback_reg(
    input rst,
    input logic clk,
    input logic in_write,
    input logic [7:0] in_result,
    input logic [7:0] in_immed_val,
    input logic [7:0] in_in,
    input logic [1:0] in_rf_wr_sel,
    input logic [4:0] in_reg_addr,
    input logic [7:0] in_scr,
    input logic [7:0] in_sp,
    output reg       out_write,
    output reg [7:0] out_result,
    output reg [7:0] out_immed_val,
    output reg [7:0] out_in,
    output reg [1:0] out_rf_wr_sel,
    output reg [4:0] out_reg_addr,
    output reg [7:0] out_scr,
    output reg [7:0] out_sp
);

always @ (posedge clk) begin
  if (rst) begin
    out_write      <= 0;    
    out_result     <= 0;    
    out_immed_val  <= 0; 
    out_in         <= 0;       
    out_rf_wr_sel  <= 0;
    out_reg_addr <= 0;
    out_scr <= 0;
    out_sp <= 0;
  end
  else begin
      out_write      <= in_write;    
      out_result     <= in_result;    
      out_immed_val  <= in_immed_val; 
      out_in         <= in_in;       
      out_rf_wr_sel  <= in_rf_wr_sel;
      out_reg_addr <= in_reg_addr;
      out_scr <= in_scr;
      out_sp <= in_sp;
  end
end
  
endmodule
