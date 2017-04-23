`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CALPOLY
// Engineer: CHRIS GERDOM
// 
// Create Date: 04/14/2017 05:18:15 PM
// Design Name: RAT PIPELINE
// Module Name: BRANCH_CALCULATOR
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: CALCULATES IF THE BRANCH IS TAKEN GIVEN THE INPUT COMMAND, C AND Z FLAGS
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
/* 
	0 none
	1 BRCC
	2 BRCS
	3 BREQ
	4 BRN
	5 BRNE
	6 CALL
	7 RET
	8 RETID
	9 RETIE
	A
	B 
	C 
	D 
	E
	F  
*/
//////////////////////////////////////////////////////////////////////////////////


module BRANCH_CALCULATOR(
    input wire [3:0] BRANCH_TYPE,
    input wire C,
    input wire Z,
    output  reg BRANCH_TAKEN
    );
    
    always @ ( BRANCH_TYPE or C or Z)
    
        case(BRANCH_TYPE)
   
        4'h0 : BRANCH_TAKEN = 1'b0; //none 
        
		4'h1 : begin // BRCC
                if(C == 1'b0) begin
                    BRANCH_TAKEN = 1'b1;
                end else begin
					BRANCH_TAKEN = 1'b0;
                end
			  end
        4'h2 : begin // BRCS
                if(C == 1'b1) begin
                    BRANCH_TAKEN = 1'b1;
                end else begin
					BRANCH_TAKEN = 1'b0;
                end
			  end
        4'h3 : begin // BREQ
                if(Z == 1'b1) begin
                    BRANCH_TAKEN = 1'b1;
                end else begin
					BRANCH_TAKEN = 1'b0;
                end
			  end
        4'h4 : begin // BRN
                BRANCH_TAKEN = 1'b1;
			  end
        4'h5 : begin // BRNE
                if(Z == 1'b0) begin
                    BRANCH_TAKEN = 1'b1;
                end else begin
					BRANCH_TAKEN = 1'b0;
                end
			  end
        4'h6 : begin // CALL
                BRANCH_TAKEN = 1'b1;
            end
		4'h7 : begin // RET
                BRANCH_TAKEN = 1'b1;
			  end
        4'h8 : begin // RETID
                BRANCH_TAKEN = 1'b1;
			  end
        4'h9 : begin // RETIE
				BRANCH_TAKEN = 1'b1;
			  end
		default : BRANCH_TAKEN =  1'b0; 
		endcase
		
endmodule
