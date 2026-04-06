`timescale 1ns / 1ps

module tb_alu;

  // Parameters
  parameter WORD_LENGTH = 4;

  // DUT Signals
  logic clk;
  logic tb_rst;
  logic [WORD_LENGTH-1:0] tb_a;
  logic [WORD_LENGTH-1:0] tb_b;
  logic tb_valid;
  logic tb_add;
  logic tb_mul;
  logic tb_sub;
  logic tb_div;
  logic tb_and;
  logic tb_or;
  logic tb_xor;
  logic tb_shf_L_a;
  logic tb_shf_L_b;
  logic [WORD_LENGTH*2-1:0] tb_c;

  // Clock generation: 10ns period = 100MHz
  always #5 clk = ~clk;

  // Instantiate DUT
  alu #(
    .WORD_LENGTH(WORD_LENGTH)
  ) dut (
    .clk(clk),
    .reset(tb_rst),
    .a(tb_a),
    .b(tb_b),
    .valid(tb_valid),
    .add_i(tb_add),
	.mul_i(tb_mul),
	.sub_i(tb_sub),
	.div_i(tb_div),
	.and_i(tb_and),
	.or_i(tb_or),
	.xor_i(tb_xor),
	.shf_L_a(tb_shf_L_a),
	.shf_L_b(tb_shf_L_b),
	.c(tb_c)
  );
  
  // Tasks //
  task initialization_state();
    $display("Time=%t, -->> Starting ALU Testbench <<--",$time);
    clk = 0;
    tb_rst = 1;
    tb_valid = 0;
    tb_add = 0;
	tb_mul = 0;
	tb_sub = 0;
	tb_div = 0;
	tb_and = 0;
	tb_or  = 0;
	tb_xor = 0;
	tb_shf_L_a  = 0;
	tb_shf_L_b = 0;
 endtask	
 //////////////////
 task add_op();
    $display("Time = %t, << out of Reset ALU >>",$time);
    #50;
	$display("Time = %t, << ADD op of ALU >>",$time);
    tb_valid = 1;
	tb_add = 1;
	tb_a = 4'd2; // Example data
	tb_b = 4'd3; // Examp5le data
	#15;
	$display("-- Adding : %d + %d = %d --",tb_a, tb_b, tb_c);
    tb_valid = 0;
	tb_add = 0;
 endtask	
 //////////////////
 task sub_op();
    $display("Time = %t, << SUB op of ALU >>",$time);
    tb_valid = 1;
	tb_sub = 1;
	tb_a = 4'd4; // Example data
	tb_b = 4'd3; // Example data
    #15;
	$display("-- Subtracting : %d - %d = %d --",tb_a, tb_b, tb_c);
    tb_valid = 0;
	tb_sub = 0;
 endtask	
 //////////////////
 task div_op();
    $display("Time = %t, << DIV op of ALU >>",$time);
    tb_valid = 1;
	tb_div = 1;
	tb_a = 4'd12; // Example data
	tb_b = 4'd4; // Example data
    #15;
	$display("-- dividing : %d / %d = %d --",tb_a, tb_b, tb_c);
    tb_valid = 0;
	tb_div = 0;
 endtask	
 //////////////////
 task mul_op();
    $display("Time = %t, << MUL op of ALU >>",$time);
    tb_valid = 1;
	tb_mul = 1;
	tb_a = 4'd3; // Example data
	tb_b = 4'd5; // Example data
    #15;
	$display("-- Multiplying : %d * %d = %d --",tb_a, tb_b, tb_c);
    tb_valid = 0;
	tb_mul = 0;
 endtask	
 ////////////////
 task and_op();
    $display("Time = %t, << AND op of ALU >>",$time);
    tb_valid = 1;
	tb_and = 1;
	tb_a = 4'd7; // Example data
	tb_b = 4'd2; // Example data
    #15;
	$display("-- Bitwise AND : %b and %b = %b --",tb_a, tb_b, tb_c);
    tb_valid = 0;
	tb_and = 0;
 endtask	
 ////////////////
 task or_op();
    $display("Time = %t, << OR op of ALU >>",$time);
    tb_valid = 1;
	tb_or = 1;
	tb_a = 4'd10; // Example data
	tb_b = 4'd7; // Example data
    #15;
	$display("-- Bitwise OR : %b OR %b = %b --",tb_a, tb_b, tb_c);
    tb_valid = 0;
	tb_or = 0;
 endtask	
 ////////////////
 task xor_op();
    $display("Time = %t, << XOR op of ALU >>",$time);
    tb_valid = 1;
	tb_xor = 1;
	tb_a = 4'd12; // Example data
	tb_b = 4'd11; // Example data
    #15;
	$display("-- Bitwise XOR : %b XOR %b = %b --",tb_a, tb_b, tb_c);
    tb_valid = 0;
	tb_xor = 0;
 endtask	
 ///////////////////
 task shft_left_a_op();
   $display("Time = %t, << Shift left of a >>",$time);
   tb_valid = 1;
	tb_shf_L_a = 1;
	tb_a = 4'd2; // Example data
	#15;
	$display("-- Shifting 1bit Left of %b = %b --",tb_a,tb_c);
   tb_valid = 0;
	tb_shf_L_a = 0;
 endtask	
 //////////////////
 task shft_left_b_op();
   $display("Time = %t, << Shift left of b >>",$time);
   tb_valid = 1;
	tb_shf_L_b = 1;
	tb_b = 4'd5; // Example data
	#15;
	$display("-- Shifting 1bit Left of %b = %b --",tb_b,tb_c);
   tb_valid = 0;
	tb_shf_L_b = 0;
 endtask	
  
  
   // Test sequence
  initial begin
    initialization_state();
    wait(!tb_rst);
	add_op();
	#50;
	sub_op();
	#50;
	mul_op();
	#20;
	div_op();
	#20;
	and_op();
	#20;
	or_op();
	#20;
	xor_op();
	#20;
	shft_left_a_op();
	#20;
	shft_left_b_op();
	#200;
    $display("-- Testing ALU complete --");
    $finish;
  end
  
  // Reset //
  //reset Generation
  initial begin
    tb_rst = 1;
	 $display("Time=%t, << Reseting ALU >>",$time);
    #5 tb_rst =0;
  end

endmodule