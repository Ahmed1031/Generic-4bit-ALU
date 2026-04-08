//-------------------------------------------------------------------------
//				www.verificationguide.com   testbench.sv
//-------------------------------------------------------------------------
//tbench_top or testbench top, this is the top most file, in which DUT(Design Under Test) and Verification environment are connected. 
//-------------------------------------------------------------------------

import alu_pkg::environment;

//including all classes
//`include "intf_alu.sv"

//-------------------------[NOTE]---------------------------------
//Particular testcase can be run by uncommenting, and commenting the rest
`include "random_test_alu.sv"
//`include "directed_test.sv"
//----------------------------------------------------------------

module tbench_alu_top;
  
  //clock and reset signal declaration
  bit clk;
  bit reset;
  
  //clock generation
  always #5 clk = ~clk;
  
  //reset Generation
  initial begin
    reset = 1;
    #5 reset =0;
  end
  
  
  //creatinng instance of interface, inorder to connect DUT and testcase
  intf_alu i_intf(clk,reset);
  
  //Testcase instance, interface handle is passed to test as an argument
  //test t1(i_intf);
  
  //DUT instance, interface signals are connected to the DUT ports
  alu DUT (
    .clk(i_intf.clk),
    .reset(i_intf.reset),
    .a(i_intf.a),
    .b(i_intf.b),
    .valid(i_intf.valid),
    .add_i(i_intf.add_i),
    .mul_i(i_intf.mul_i),
    .sub_i(i_intf.sub_i),
    .div_i(i_intf.div_i),
    .and_i(i_intf.and_i),
    .or_i(i_intf.or_i),
    .xor_i(i_intf.xor_i),
    .c(i_intf.c)
   );
   
  // run tests 
  environment env;
 
  initial begin
       env = new(i_intf);
       env.gen.repeat_count = 20;
       env.run();
  end  
  
  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule