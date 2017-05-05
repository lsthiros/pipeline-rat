`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2017 03:02:32 PM
// Design Name: 
// Module Name: address_cache
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

parameter INDEX_WIDTH = 4;
parameter TAG_SIZE = 10 - INDEX_WIDTH;
parameter CACHE_SIZE = 1 << INDEX_WIDTH;


/* defining row of cache */


/* typedef struct{
	logic valid_bit;
	logic [(TAG_SIZE - 1):0] tag;
	logic [2:0] history;
} cache_row; */

module cache_row(
	input clk,
	input rst,
	input we,
	input branch_taken,
	output logic valid_bit,
	output logic[(TAG_SIZE - 1):0] tag,
	output logic[2:0] history
	);
	
	always @ (posedge(clk)) begin
		if(rst) begin
			history <= 0;
			valid_bit 	<= 0;
		end else begin
			if(we)begin
				history <= {history[1:0],branch_taken};
				valid_bit	<= 1;
			end else
				history <= history;
				valid_bit	<= 1;
			end
	end
	
endmodule		


module address_cache(
    input [9:0] pc,
    input [9:0]update_pc,
    input branch_taken,
    input we,
    input clk,
    input rst,
    input branch_detected,
    output evict,
    output [2:0] history
    );
    
	wire cache_index = pc [(INDEX_WIDTH - 1):0];
	wire tag_input = pc [9:INDEX_WIDTH];
	logic [2:0] ind_history [0:CACHE_SIZE-1];
	logic ind_we [0:CACHE_SIZE-1];
	
	cache_row  cache[0:CACHE_SIZE-1] (
	   .clk          ( clk ),
	   .rst          ( rst ),
	   .we           ( ind_we ),
	   .branch_taken ( branch_taken ),
	   .history      ( ind_history )

	);
	
	assign history = ind_history[integer'(cache_index)][3]; /*TODO: find out what goes here*/
	
	always @ (posedge(clk)) ind_we[integer'(cache_index)] <= we ;/*TODO: find out what goes here*/
    
    
    
    
    
    
    
    
    
endmodule

