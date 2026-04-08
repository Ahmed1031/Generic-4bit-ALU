//----------------------------------------------------------------------
// Author : Ahmed Asim Ghouri
// Date : 27/03/2026
// Interface for ALU
//-------------------------------------------------------------------------
interface intf_alu#(parameter WORD_LENGTH = 4)
   (input logic clk,reset);
  
  //declaring the signals
  logic       valid,
  logic       add_i,
  logic       mul_i,
  logic       sub_i,
  logic       div_i,
  logic       and_i,
  logic       or_i,
  logic       xor_i,
  logic [WORD_LENGTH-1:0] a;
  logic [WORD_LENGTH-1:0] b;
  logic [WORD_LENGTH*2-1:0] c;
  
endinterface