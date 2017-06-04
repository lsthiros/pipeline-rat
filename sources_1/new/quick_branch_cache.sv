



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
/* tag and history cell definitions */

/*module TagBlock(
	input  wire clk,
	input  wire [5:0] in_tag,
	input  wire tag_we,
	input  wire rst,
	output logic valid_bit,
	output logic [5:0]tag
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
endmodule*/

module next_location(
	input wire clk,
	input wire rst,
	input wire we,
  input wire [9:0] pc_store, // pc to store on an update
	output logic [9:0] jump_pc
	);

	always @ ( posedge(clk) ) begin
		if( rst ) begin
			jump_pc <= 0;
		end
		else begin
			if( we ) begin
				jump_pc <= pc_store;
			end
			else begin
			jump_pc <= jump_pc;
			end
		end
	end

endmodule

module quick_branch_cache(
  input wire rst,
  input wire clk,
  input wire we,
  input wire [9:0] current_pc,
  input wire [9:0] update_pc,
  input wire [9:0] store_pc,
  output wire [9:0] jump_pc,
  output logic read_hit
    );
	parameter ENTRY_WIDTH = 4;
	parameter ENTRY_DEPTH = 1 << ENTRY_WIDTH;
	wire [ENTRY_DEPTH - 1:0][5:0] ind_tag;
	wire [ENTRY_DEPTH - 1:0] ind_valid_bit;
	wire valid_bit;
	logic [ENTRY_DEPTH - 1:0]ind_pc_write  ;
	logic [ENTRY_DEPTH - 1:0] ind_tag_we;
	logic [ENTRY_DEPTH - 1:0]ind_rst ;
	logic [ENTRY_DEPTH - 1:0][9:0] ind_jump_pc ;
	logic [5:0] out_tag;

	// index and tag assignments
	wire [5:0] current_tag = current_pc[9:4];
	wire [3:0] current_index = current_pc[3:0];
	wire [5:0] update_tag = update_pc[9:4];
	wire [3:0] update_index = update_pc[3:0];

// define tag and history tables
	next_location next_location_table [0:ENTRY_DEPTH - 1] (
		.clk(clk),
		.rst(ind_rst),
		.we(ind_pc_write),
    .pc_store(store_pc),
    .jump_pc(ind_jump_pc)
	);

	TagBlock tagtable [0:ENTRY_DEPTH - 1] (
		.clk(clk),
		.in_tag(update_tag),
		.tag_we(ind_tag_we),
		.rst(rst),
		.valid_bit(ind_valid_bit),
		.tag(ind_tag)
	);




	//sync write section
    logic write_hit;



    generate
        genvar idx;
        for (idx = 0; idx < ENTRY_DEPTH; idx++) begin: CACHE_CONTROL_WIRING
             assign ind_pc_write[integer'(idx)] =  we && integer'(idx) == integer'(update_index);
             assign ind_tag_we[integer'(idx)] = we && integer'(idx) == integer'(update_index);
             assign ind_rst[integer'(idx)] = rst;
        end
    endgenerate

	// async read section

	wire [3:0]read_index = current_index;
	wire [5:0]read_tag = current_tag;

	assign out_tag = ind_tag[integer'(read_index) ];
	assign read_hit = (read_tag == out_tag) && ind_valid_bit[integer'(read_index)];
	assign jump_pc = ind_jump_pc[integer'(read_index)];

endmodule
