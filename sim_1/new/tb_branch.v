`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2017 07:35:30 PM
// Design Name: 
// Module Name: tb_branch
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


module tb_branch();
reg C;
reg Z;
reg [3:0] BRANCH_TYPE;
wire BRANCH_TAKEN;
BRANCH_CALCULATOR U0( 
	.C (C),
	.Z (Z),
	.BRANCH_TYPE (BRANCH_TYPE),
	.BRANCH_TAKEN(BRANCH_TAKEN)
);

	initial begin
			Z = 0;
			C = 0;
			BRANCH_TYPE = 0;
	end
	
	always
	#5  C = !C;
	always
	#10 Z = !Z;
	always
	#20 BRANCH_TYPE = BRANCH_TYPE +1;
	
	initial  begin
     $dumpfile ("branch_calc.vcd"); 
     $dumpvars; 
   end 
	
	initial 
	#1000 $finish;
endmodule
