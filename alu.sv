//----------------------------------------------
//	Author  : Ahmed Asim Ghouri
//  Dated   : 26/03/2026
//  Version : 1.0
//----------------------------------------------
/*
            --------------
 valid ---->|            |
            |			    |
    a -/--->|       	    |
            |   add/mul/sub/div |---/-> c
    b -/--->|            |
   add-/--->|            |
   sub-/--->--------------
               ^      ^ 
               |      |
              clk   reset

*/
module alu
 #(
    parameter WORD_LENGTH = 4
    )
(
  input 	   clk	,
  input 	   reset,
  input  logic [WORD_LENGTH -1 : 0] a,
  input  logic [WORD_LENGTH -1 : 0] b,
  input        valid,
  input        add_i,
  input        mul_i,
  input        sub_i,
  input        div_i,
  input        and_i,
  input        or_i,
  input        xor_i,
  output logic [WORD_LENGTH*2-1 : 0] c); 
  
  reg [7:0] add_tmp_reg, tmp_2c;
  // Define our states
   typedef enum {IDLE, START, ADD, SUB, MUL, DIV, AND_op, OR_op, XOR_op}  alu_state;
   alu_state current_state = IDLE;
   alu_state next_state    = IDLE;
   
  
  //Reset 
  always @(posedge clk) 
  if (reset) begin
     add_tmp_reg <= 0;
     tmp_2c <= 0;
  // add	 
  end else if ((valid) && (add_i)) begin 
      add_tmp_reg <= a + b;
  // Sub //	  
  end else if ((valid) && (sub_i)) begin 
      tmp_2c <= ~b + 8'd1;
  end 	  
      

	
/////////////////////////////////
// current state being updated //
   always @(posedge clk)
     begin
	   if(reset) begin
           current_state <= IDLE;
	     end
	   else begin
           current_state <= next_state;
	   end

     end
/////////////////////////////////////
// State Machine
   always @(*)
     begin
        case (current_state)
          IDLE   :
            begin
               if ((valid) && (add_i)) begin
					   $display("Time=%t, -->> Addition <<--",$time);
                  next_state = ADD;
               //
               end else if ((valid) && (sub_i)) begin
					   $display("Time=%t, -->> Subtraction <<--", $time);
                  next_state = SUB;
			   //	  
			   end else if ((valid) && (mul_i)) begin
					   $display("Time=%t, -->> Multiplication <<--", $time);
                  next_state = MUL;  
               //
               end else if ((valid) && (div_i)) begin
					   $display("Time=%t, -->> Division <<--", $time);
                  next_state = DIV;
			   // AND Op //
               end else if ((valid) && (and_i)) begin
					   $display("Time=%t, -->> bitwise AND <<--", $time);
                  next_state = AND_op;	  
			   // OR Op //
               end else if ((valid) && (or_i)) begin
					   $display("Time=%t, -->> bitwise OR <<--", $time);
                  next_state = OR_op;
               // XOR Op //
               end else if ((valid) && (xor_i)) begin
					   $display("Time=%t, -->> bitwise XOR <<--", $time);
                  next_state = XOR_op;	 				  
               end else begin
			       c <= 8'h00; 
			       next_state = IDLE;
			   end
            end				
			   ////////////////////////////////   
		   
			   
          ADD  :
            begin
                  c <= a + b; 
                  next_state = IDLE;
               end
			   
		  SUB  :
             begin
                  c <= a + tmp_2c; 
                  next_state = IDLE;
               end	   
			   
		  MUL  :
             begin
                  c <= a*b; 
                  next_state = IDLE;
               end	   

          DIV  :
             begin
                  c <= a/b; 
                  next_state = IDLE;
               end	
			   
		  AND_op  :
             begin
                  c <= a&b; 
                  next_state = IDLE;
               end		

          OR_op  :
             begin
                  c <= a|b; 
                  next_state = IDLE;
               end		
          XOR_op  :
             begin
                  c <= a^b; 
                  next_state = IDLE;
               end					   
          default:
			   begin
            next_state = current_state;
				end
        endcase
     end   			   
                 
  

endmodule

//----------------------------------------------------------------------
// Author : Ahmed Asim Ghouri
// Date : 27/03/2026
// Interface for ALU
//-------------------------------------------------------------------------
interface intf_alu#(parameter WORD_LENGTH = 4)
   (input logic clk,reset);
  
  //declaring the signals
  logic       valid;
  logic       add_i;
  logic       mul_i;
  logic       sub_i;
  logic       div_i;
  logic       and_i;
  logic       or_i;
  logic       xor_i;
  logic [WORD_LENGTH-1:0] a;
  logic [WORD_LENGTH-1:0] b;
  logic [WORD_LENGTH*2-1:0] c;
  
endinterface