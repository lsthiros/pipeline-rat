`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Christopher Gerdom
//
// Create Date: 04/18/2017 09:09:28 PM
// Design Name:
// Module Name: control_vector_reg
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

//interface control_vector;
//	logic PC_LD        ;
//	logic PC_INC       ;
//	logic PC_MUX_SEL   ;
//	logic SP_LD        ;
//	logic SP_INCR      ;
//	logic SP_DECR      ;
//	logic RF_WR        ;
//	logic RF_WR_SEL    ;
//	logic ALU_OPY_SEL  ;
//	logic ALU_SEL      ;
//	logic SCR_WE       ;
//	logic SCR_DATA_SE  ;
//	logic SCR_ADDR_SE  ;
//	logic FLG_C_SET    ;
//	logic FLG_C_CLR    ;
//	logic FLG_C_LD     ;
//	logic FLG_Z_LD     ;
//	logic FLG_LD_SEL   ;
//	logic FLG_SHAD_LD  ;
//	logic I_SET        ;
//	logic I_CLR        ;
//	logic IO_STRB      ;
//	logic BRANCH_TYPE  ;
//	logic rst          ;

//endinterface:control_vector

module control_vector_reg(

    output logic out_PC_LD        ,
    output logic out_PC_INC       ,
    output logic[1:0] out_PC_MUX_SEL   ,
    output logic out_SP_LD        ,
    output logic out_SP_INCR      ,
    output logic out_SP_DECR      ,
    output logic out_RF_WR        ,
    output logic[1:0] out_RF_WR_SEL    ,
    output logic out_ALU_OPY_SEL  ,
    output logic[3:0] out_ALU_SEL      ,
    output logic out_SCR_WE       ,
    output logic out_SCR_DATA_SE  ,
    output logic[1:0] out_SCR_ADDR_SE  ,
    output logic out_FLG_C_SET    ,
    output logic out_FLG_C_CLR    ,
    output logic out_FLG_C_LD     ,
    output logic out_FLG_Z_LD     ,
    output logic out_FLG_LD_SEL   ,
    output logic out_FLG_SHAD_LD  ,
    output logic out_I_SET        ,
    output logic out_I_CLR        ,
    output logic out_IO_STRB      ,
    output logic[3:0] out_BRANCH_TYPE  ,
    output logic out_rst          ,
    output logic [9:0] out_dest_addr,

    input logic in_PC_LD        ,
    input logic in_PC_INC       ,
    input logic[1:0] in_PC_MUX_SEL   ,
    input logic in_SP_LD        ,
    input logic in_SP_INCR      ,
    input logic in_SP_DECR      ,
    input logic in_RF_WR        ,
    input logic[1:0] in_RF_WR_SEL    ,
    input logic in_ALU_OPY_SEL  ,
    input logic[3:0] in_ALU_SEL      ,
    input logic in_SCR_WE       ,
    input logic in_SCR_DATA_SE  ,
    input logic [1:0] in_SCR_ADDR_SE  ,
    input logic in_FLG_C_SET    ,
    input logic in_FLG_C_CLR    ,
    input logic in_FLG_C_LD     ,
    input logic in_FLG_Z_LD     ,
    input logic in_FLG_LD_SEL   ,
    input logic in_FLG_SHAD_LD  ,
    input logic in_I_SET        ,
    input logic in_I_CLR        ,
    input logic in_IO_STRB      ,
    input logic[3:0] in_BRANCH_TYPE  ,
    input logic in_rst          ,
    input logic [9:0] in_dest_addr,
	input logic interupt,
	input logic clk,
	input logic nop,

	// instruction data
	input  logic[7:0] in_IR,
	output logic[7:0] out_IR,
	// register values
	input logic[7:0] in_DX,
	output logic[7:0] out_DX,
	input logic[7:0] in_DY,
	output logic[7:0] out_DY,
	// addresses
	input logic[4:0] in_WB_ADDR,
	output logic[4:0] out_WB_ADDR,
	// program counters
	input logic[9:0] in_PC,
	output logic[9:0] out_PC,
	// branch prediction
	output logic [9:0] alt_out,
	input logic [9:0] alt_in,

	input logic branch_taken_in,
	output logic branch_taken_out
);


// act as a register and give the inputs to the outputs when clocked
always @ (posedge clk) begin
	out_IR <= in_IR;
	out_DX <= in_DX;
	out_DY <= in_DY;
	out_WB_ADDR <= in_WB_ADDR;
	out_PC <= in_PC;
	out_dest_addr <= in_dest_addr;

if (in_rst) begin
    out_PC_LD       <= 0;
    out_PC_INC      <= 0;
    out_PC_MUX_SEL  <= 0;
    out_SP_LD       <= 0;
    out_SP_INCR     <= 0;
    out_SP_DECR     <= 0;
    out_RF_WR       <= 0;
    out_RF_WR_SEL   <= 0;
    out_ALU_OPY_SEL <= 0;
    out_ALU_SEL     <= 0;
    out_SCR_WE      <= 0;
    out_SCR_DATA_SE <= 0;
    out_SCR_ADDR_SE <= 0;
    out_FLG_C_SET   <= 0;
    out_FLG_C_CLR   <= 0;
    out_FLG_C_LD    <= 0;
    out_FLG_Z_LD    <= 0;
    out_FLG_LD_SEL  <= 0;
    out_FLG_SHAD_LD <= 0;
    out_I_SET       <= 0;
    out_I_CLR       <= 0;
    out_IO_STRB     <= 0;
    out_BRANCH_TYPE <= 0;
		branch_taken_out<= 0;
		alt_out 				<= 0;
end
else if(interupt == 1'b1) begin
	out_PC_LD       <= 1;
	out_PC_INC      <= 0;
	out_PC_MUX_SEL  <= 2'h2;
	out_SP_LD       <= 0;
	out_SP_INCR     <= 0;
	out_SP_DECR     <= 1;
	out_RF_WR       <= 0;
	out_RF_WR_SEL   <= 0;
	out_ALU_OPY_SEL <= 0;
	out_ALU_SEL     <= 0;
	out_SCR_WE      <= 1;
	out_SCR_DATA_SE <= 1;
	out_SCR_ADDR_SE <= 2'b11;
	out_FLG_C_SET   <= 0;
	out_FLG_C_CLR   <= 0;
	out_FLG_C_LD    <= 0;
	out_FLG_Z_LD    <= 0;
	out_FLG_LD_SEL  <= 0;
	out_FLG_SHAD_LD <= 1;
	out_I_SET       <= 0;
	out_I_CLR       <= 1;
	out_IO_STRB     <= 0;
	out_BRANCH_TYPE <= 0;
	out_rst         <= 0;
	out_PC <= in_PC - 1;
	branch_taken_out<= 0;	//TODO: make this the right case for interupt
	alt_out 				<= 0;
// When nop
end else if(nop == 1'b0) begin
	out_PC_LD       <= in_PC_LD        ;
    out_PC_INC      <= in_PC_INC       ;
    out_PC_MUX_SEL  <= in_PC_MUX_SEL   ;
    out_SP_LD       <= in_SP_LD        ;
    out_SP_INCR     <= in_SP_INCR      ;
    out_SP_DECR     <= in_SP_DECR      ;
    out_RF_WR       <= in_RF_WR        ;
    out_RF_WR_SEL   <= in_RF_WR_SEL    ;
    out_ALU_OPY_SEL <= in_ALU_OPY_SEL  ;
    out_ALU_SEL     <= in_ALU_SEL      ;
    out_SCR_WE      <= in_SCR_WE       ;
    out_SCR_DATA_SE <= in_SCR_DATA_SE  ;
    out_SCR_ADDR_SE <= in_SCR_ADDR_SE  ;
    out_FLG_C_SET   <= in_FLG_C_SET    ;
    out_FLG_C_CLR   <= in_FLG_C_CLR    ;
    out_FLG_C_LD    <= in_FLG_C_LD     ;
    out_FLG_Z_LD    <= in_FLG_Z_LD     ;
    out_FLG_LD_SEL  <= in_FLG_LD_SEL   ;
    out_FLG_SHAD_LD <= in_FLG_SHAD_LD  ;
    out_I_SET       <= in_I_SET        ;
    out_I_CLR       <= in_I_CLR        ;
    out_IO_STRB     <= in_IO_STRB      ;
    out_BRANCH_TYPE <= in_BRANCH_TYPE  ;
    out_rst         <= in_rst          ;
		branch_taken_out<= branch_taken_in;
		alt_out 				<= alt_in;
end else begin
	out_PC_LD       <= 0;
	out_PC_INC      <= 0;
	out_PC_MUX_SEL  <= 0;
	out_SP_LD       <= 0;
	out_SP_INCR     <= 0;
	out_SP_DECR     <= 0;
	out_RF_WR       <= 0;
	out_RF_WR_SEL   <= 2'b00;
	out_ALU_OPY_SEL <= 0;
	out_ALU_SEL     <= 4'b0000;
	out_SCR_WE      <= 0;
	out_SCR_DATA_SE <= 0;
	out_SCR_ADDR_SE <= 2'b00;
	out_FLG_C_SET   <= 0;
	out_FLG_C_CLR   <= 0;
	out_FLG_C_LD    <= 0;
	out_FLG_Z_LD    <= 0;
	out_FLG_LD_SEL  <= 0;
	out_FLG_SHAD_LD <= 0;
	out_I_SET       <= 0;
	out_I_CLR       <= 0;
	out_IO_STRB     <= 0;
	out_BRANCH_TYPE <= 4'b0000;
	out_rst         <= 0;
	branch_taken_out<= 0;
	alt_out 				<= 0;

end
end

endmodule
