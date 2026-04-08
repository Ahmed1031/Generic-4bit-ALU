// alu package file //
package alu_pkg; 

//----Transaction Class----
class transaction;
  
  //declaring the transaction items
  rand bit [3:0] a;
  rand bit [3:0] b;
       bit [6:0] c;
  rand bit add_i;	   
  function void display(string name);
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
    $display("- a = %0d, b = %0d",a,b);
    $display("- c = %0d",c);
    $display("-------------------------");
	$display("-- ADD = %b --",add_i);
  endfunction
endclass
//---------------------------------------//

//-----------Driver Class------------------
class driver;
  
  //used to count the number of transactions
  int no_transactions;
  
  //creating virtual interface handle
  virtual intf_alu#(.WORD_LENGTH(4)) vif;
  
  //creating mailbox handle
  mailbox gen2driv;
  
  //constructor
  function new(virtual intf_alu vif,mailbox gen2driv);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
    this.gen2driv = gen2driv;
  endfunction
  
  //Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait(vif.reset);
    $display("[ DRIVER ] ----- Reset Started -----");
    vif.a <= 0;
    vif.b <= 0;
    vif.valid <= 0;
	vif.add_i <= 0;
	vif.mul_i <= 0;
	vif.sub_i <= 0;
	vif.div_i <= 0;
	vif.and_i <= 0;
	vif.or_i  <= 0;
	vif.xor_i <= 0;
    wait(!vif.reset);
    $display("[ DRIVER ] ----- Reset Ended   -----");
  endtask
  
  //drivers the transaction items to interface signals
  task main;
    forever begin
      transaction trans;
      gen2driv.get(trans);
      @(posedge vif.clk);
      vif.valid <= 1;
	  //vif.add_i <= 1;
      vif.a     <= trans.a;
      vif.b     <= trans.b;
      @(posedge vif.clk);
      vif.valid <= 0;
	  //vif.add_i <= 0;
      trans.c   = vif.c;
      @(posedge vif.clk);
      trans.display("[ Driver ]");
      no_transactions++;
    end
  endtask
  
endclass
//---------------------------------------//

//----Generator Class------------------
class generator;
  
  //declaring transaction class 
  rand transaction trans;
  
  //repeat count, to specify number of items to generate
  int  repeat_count;
  
  //mailbox, to generate and send the packet to driver
  mailbox gen2driv;
  
  //event, to indicate the end of transaction generation
  event ended;
  
  //constructor
  function new(mailbox gen2driv);
    //getting the mailbox handle from env, in order to share the transaction packet between the generator and driver, the same mailbox is shared between both.
    this.gen2driv = gen2driv;
  endfunction
  
  //main task, generates(create and randomizes) the repeat_count number of transaction packets and puts into mailbox
  task main();
    repeat(repeat_count) begin
    trans = new();
    if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");
      trans.display("[ Generator ]");
      gen2driv.put(trans);
    end
    -> ended; //triggering indicatesthe end of generation
  endtask
  
endclass
//---------------------------------------//

//----Environment Class------------------
class environment;
  
  //generator and driver instance
  generator gen;
  driver    driv;
  
  //mailbox handle's
  mailbox gen2driv;
  
  //virtual interface
  virtual intf_alu#(.WORD_LENGTH(4)) vif;
  
  //constructor
  function new(virtual intf_alu vif);
    //get the interface from test
    this.vif = vif;
    
    //creating the mailbox (Same handle will be shared across generator and driver)
    gen2driv = new();
    
    //creating generator and driver
    gen  = new(gen2driv);
    driv = new(vif,gen2driv);
  endfunction
  
  //
  task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork 
    gen.main();
    driv.main();
    join_any
  endtask
  
  task post_test();
    wait(gen.ended.triggered);
    wait(gen.repeat_count == driv.no_transactions);
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask
  
endclass
//---------------------------------------//
endpackage