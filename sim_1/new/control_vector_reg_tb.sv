`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2017 09:50:23 PM
// Design Name: 
// Module Name: control_vector_reg_tb
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


module control_vector_reg_tb(

    );

reg clk				;
reg nop				;
// input control vector
reg	in_PC_LD      	; 
reg	in_PC_INC     	; 
reg	in_PC_MUX_SEL 	; 
reg	in_SP_LD      	; 
reg	in_SP_INCR    	; 
reg	in_SP_DECR    	; 
reg	in_RF_WR      	; 
reg	in_RF_WR_SEL  	; 
reg	in_ALU_OPY_SEL	; 
reg	in_ALU_SEL    	; 
reg	in_SCR_WE     	; 
reg	in_SCR_DATA_SE	; 
reg	in_SCR_ADDR_SE	; 
reg	in_FLG_C_SET  	; 
reg	in_FLG_C_CLR  	; 
reg	in_FLG_C_LD   	; 
reg	in_FLG_Z_LD   	; 
reg	in_FLG_LD_SEL 	; 
reg	in_FLG_SHAD_LD	; 
reg	in_I_SET      	; 
reg	in_I_CLR      	; 
reg	in_IO_STRB    	; 
reg	in_BRANCH_TYPE	; 
reg	in_rst        	; 
// output control vector
wire out_PC_LD      	; 
wire out_PC_INC     	; 
wire out_PC_MUX_SEL 	; 
wire out_SP_LD      	; 
wire out_SP_INCR    	; 
wire out_SP_DECR    	; 
wire out_RF_WR      	; 
wire out_RF_WR_SEL  	; 
wire out_ALU_OPY_SEL	; 
wire out_ALU_SEL    	; 
wire out_SCR_WE     	; 
wire out_SCR_DATA_SE	; 
wire out_SCR_ADDR_SE	; 
wire out_FLG_C_SET  	; 
wire out_FLG_C_CLR  	; 
wire out_FLG_C_LD   	; 
wire out_FLG_Z_LD   	; 
wire out_FLG_LD_SEL 	; 
wire out_FLG_SHAD_LD	; 
wire out_I_SET      	; 
wire out_I_CLR      	; 
wire out_IO_STRB    	; 
wire out_BRANCH_TYPE	; 
wire out_rst        	; 







control_vector_reg U0(
	.clk(clk),
	.nop(nop),
	.in_PC_LD        (in_PC_LD      ),
    .in_PC_INC       (in_PC_INC     ),
    .in_PC_MUX_SEL   (in_PC_MUX_SEL ),
    .in_SP_LD        (in_SP_LD      ),
    .in_SP_INCR      (in_SP_INCR    ),
    .in_SP_DECR      (in_SP_DECR    ),
    .in_RF_WR        (in_RF_WR      ),
    .in_RF_WR_SEL    (in_RF_WR_SEL  ),
    .in_ALU_OPY_SEL  (in_ALU_OPY_SEL),
    .in_ALU_SEL      (in_ALU_SEL    ),
    .in_SCR_WE       (in_SCR_WE     ),
    .in_SCR_DATA_SE  (in_SCR_DATA_SE),
    .in_SCR_ADDR_SE  (in_SCR_ADDR_SE),
    .in_FLG_C_SET    (in_FLG_C_SET  ),
    .in_FLG_C_CLR    (in_FLG_C_CLR  ),
    .in_FLG_C_LD     (in_FLG_C_LD   ),
    .in_FLG_Z_LD     (in_FLG_Z_LD   ),
    .in_FLG_LD_SEL   (in_FLG_LD_SEL ),
    .in_FLG_SHAD_LD  (in_FLG_SHAD_LD),
    .in_I_SET        (in_I_SET      ),
    .in_I_CLR        (in_I_CLR      ),
    .in_IO_STRB      (in_IO_STRB    ),
    .in_BRANCH_TYPE  (in_BRANCH_TYPE),
    .in_rst          (in_rst        ),

	.out_PC_LD        (out_PC_LD      ),
    .out_PC_INC       (out_PC_INC     ),
    .out_PC_MUX_SEL   (out_PC_MUX_SEL ),
    .out_SP_LD        (out_SP_LD      ),
    .out_SP_INCR      (out_SP_INCR    ),
    .out_SP_DECR      (out_SP_DECR    ),
    .out_RF_WR        (out_RF_WR      ),
    .out_RF_WR_SEL    (out_RF_WR_SEL  ),
    .out_ALU_OPY_SEL  (out_ALU_OPY_SEL),
    .out_ALU_SEL      (out_ALU_SEL    ),
    .out_SCR_WE       (out_SCR_WE     ),
    .out_SCR_DATA_SE  (out_SCR_DATA_SE),
    .out_SCR_ADDR_SE  (out_SCR_ADDR_SE),
    .out_FLG_C_SET    (out_FLG_C_SET  ),
    .out_FLG_C_CLR    (out_FLG_C_CLR  ),
    .out_FLG_C_LD     (out_FLG_C_LD   ),
    .out_FLG_Z_LD     (out_FLG_Z_LD   ),
    .out_FLG_LD_SEL   (out_FLG_LD_SEL ),
    .out_FLG_SHAD_LD  (out_FLG_SHAD_LD),
    .out_I_SET        (out_I_SET      ),
    .out_I_CLR        (out_I_CLR      ),
    .out_IO_STRB      (out_IO_STRB    ),
    .out_BRANCH_TYPE  (out_BRANCH_TYPE),
    .out_rst          (out_rst        )

);

initial begin
	clk = 0;
	nop = 0;
	in_PC_LD       = 0;
	in_PC_INC      = 0;
	in_PC_MUX_SEL  = 0;
	in_SP_LD       = 0;
	in_SP_INCR     = 0;
	in_SP_DECR     = 0;
	in_RF_WR       = 0;
	in_RF_WR_SEL   = 0;
	in_ALU_OPY_SEL = 0;
	in_ALU_SEL     = 0;
	in_SCR_WE      = 0;
	in_SCR_DATA_SE = 0;
	in_SCR_ADDR_SE = 0;
	in_FLG_C_SET   = 0;
	in_FLG_C_CLR   = 0;
	in_FLG_C_LD    = 0;
	in_FLG_Z_LD    = 0;
	in_FLG_LD_SEL  = 0;
	in_FLG_SHAD_LD = 0;
	in_I_SET       = 0;
	in_I_CLR       = 0;
	in_IO_STRB     = 0;
	in_BRANCH_TYPE = 0;
	in_rst         = 0;
	
end

	always
	#5 clk = !clk;
	always
	#10 nop = !nop;

initial  begin
     $dumpfile ("branch_calc.vcd"); 
     $dumpvars; 
   end 
	
	initial begin
		#20 in_PC_LD       = 1;
		    in_PC_INC      = 0;
		    in_PC_MUX_SEL  = 1;
		    in_SP_LD       = 0;
		    in_SP_INCR     = 1;
		    in_SP_DECR     = 0;
		    in_RF_WR       = 1;
		    in_RF_WR_SEL   = 0;
		    in_ALU_OPY_SEL = 1;
		    in_ALU_SEL     = 0;
		    in_SCR_WE      = 1;
		    in_SCR_DATA_SE = 0;
		    in_SCR_ADDR_SE = 1;
		    in_FLG_C_SET   = 0;
		    in_FLG_C_CLR   = 1;
		    in_FLG_C_LD    = 0;
		    in_FLG_Z_LD    = 1;
		    in_FLG_LD_SEL  = 0;
		    in_FLG_SHAD_LD = 1;
		    in_I_SET       = 0;
		    in_I_CLR       = 1;
		    in_IO_STRB     = 0;
		    in_BRANCH_TYPE = 1;
		    in_rst         = 0;
		
		#20 in_PC_LD       = 1;
		    in_PC_INC      = 0;
		    in_PC_MUX_SEL  = 1;
		    in_SP_LD       = 0;
		    in_SP_INCR     = 1;
		    in_SP_DECR     = 0;
		    in_RF_WR       = 1;
		    in_RF_WR_SEL   = 0;
		    in_ALU_OPY_SEL = 1;
		    in_ALU_SEL     = 0;
		    in_SCR_WE      = 1;
		    in_SCR_DATA_SE = 0;
		    in_SCR_ADDR_SE = 1;
		    in_FLG_C_SET   = 0;
		    in_FLG_C_CLR   = 1;
		    in_FLG_C_LD    = 0;
		    in_FLG_Z_LD    = 1;
		    in_FLG_LD_SEL  = 0;
		    in_FLG_SHAD_LD = 1;
		    in_I_SET       = 0;
		    in_I_CLR       = 1;
		    in_IO_STRB     = 0;
		    in_BRANCH_TYPE = 1;
		    in_rst         = 0;


	#1000 $finish;
	end
endmodule
