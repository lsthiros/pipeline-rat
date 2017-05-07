`timescale 1ns / 1ps
`default_nettype none
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





module TagBlock(
	input  wire clk,
	input  wire [5:0] in_tag,
	input  wire tag_we,
	input  wire rst,
	output logic valid_bit,
	output logic [5:0]  tag
	);

	always @ (posedge(clk)) begin
		if(rst) begin
			tag <= 0;
			valid_bit <= 0;
		end else begin
			tag <= (tag_we)? in_tag : tag;
			valid_bit <= (tag_we)? 1 : valid_bit;
		end
	end
endmodule

module HisBlock(
	input wire clk,
	input wire rst,
	input wire we,
	input wire branch_taken,
	output logic [2:0] history
	);

	always @ ( posedge(clk) ) begin
		if( rst ) begin
			history <= {1'b0,1'b0,branch_taken};
		end
		else begin
			if( we ) begin
				history <= {history[1:0],branch_taken};
			end
			else begin
			history <= history;
			end
		end
	end

endmodule


module cache(
	input wire rst,
	input wire clk,
	input wire we,
	input wire branch_taken,
	input wire [9:0] pc,
	input wire [9:0]	update_pc,
	output logic [2:0] history,
	output logic read_hit
	);
	parameter ENTRY_WIDTH = 4;
	parameter ENTRY_DEPTH = 1 << ENTRY_WIDTH;
	wire [5:0] ind_tag[0:ENTRY_DEPTH - 1];
	wire ind_valid_bit[0:ENTRY_DEPTH - 1];
	wire [5:0] in_tag = pc[9:4];
	wire [3:0] index = update_pc[3:0];
	wire valid_bit;
	logic ind_history_write  [0:ENTRY_DEPTH - 1];
	logic ind_tag_we[0:ENTRY_DEPTH - 1];
	logic ind_rst [0:ENTRY_DEPTH - 1];
	logic [2:0] ind_history [0:ENTRY_DEPTH - 1];
	logic [5:0] out_tag;

	TagBlock tagtable [0:ENTRY_DEPTH - 1] (
		.clk(clk),
		.in_tag(in_tag),
		.tag_we(ind_tag_we),
		.rst(rst),
		.valid_bit(ind_valid_bit),
		.tag(ind_tag)
	);

	HisBlock histable [0:ENTRY_DEPTH - 1] (
		.clk(clk),
		.rst(ind_rst),
		.we(ind_history_write),
		.branch_taken(~rst && branch_taken),
		.history(ind_history)
	);


	//sync write section
    logic write_hit;

	assign out_tag = ind_tag[integer'(index) ];
	assign write_hit = (in_tag == out_tag) && ind_valid_bit[integer'(index)];

	always @ ( posedge(clk) ) begin
		if (write_hit && we) begin	// chache hit
			ind_history_write[integer'(index) ] <= 1;
			ind_tag_we [integer'(index) ]<= 1;
			ind_rst[integer'(index) ] <= 0;
		end
		else begin
			if (~write_hit && we) begin  // cache miss
				ind_history_write[integer'(index) ] <= 0;
				ind_tag_we [integer'(index) ]<= 1;
				ind_rst [integer'(index) ] <= (index - 1);
			end
			else begin	// no cache write
				ind_history_write[integer'(index) ] <= 0;
				ind_tag_we[integer'(index) ] <= 0;
				ind_rst [integer'(index) ]<= 0;
			end
		end
	end


	// read section
	wire read_index = pc[3:0];
	assign read_hit = (in_tag == out_tag) && ind_valid_bit[integer'(index)];
	assign history = ind_history[integer'(read_index)];






endmodule
