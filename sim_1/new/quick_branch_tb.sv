`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2017 07:08:31 PM
// Design Name: 
// Module Name: quick_branch_tb
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


module quick_branch_tb(

    );
    reg clk = 0;
    reg rst = 0;
    reg we = 0;
    reg [9:0] current_pc = 0;
    reg [9:0] update_pc = 0;
    reg [9:0] store_pc = 0;
    wire [9:0] jump_pc;
    wire read_hit;
     quick_branch_cache uut1(
      
      
       .rst(rst),
       .clk(clk),
       .we(we),
       .current_pc(current_pc),
       .update_pc(update_pc),
       .store_pc(store_pc),
       .jump_pc(jump_pc),
       .read_hit(read_hit)
        );
        
       always
        #50 clk = !clk;
       always
        #100 current_pc = current_pc +1;         
    initial  begin
         $dumpfile ("quick_branch_tb.vcd"); 
         $dumpvars; 
       end 
        
        initial begin
        rst = 1;
        update_pc = 10;
        store_pc = 20;
        we = 0;
        #100 
         rst = 0;
         we = 1;
        #100
        we = 0;
    
        #2000 $finish;
        end
endmodule
