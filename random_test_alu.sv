//-------------------------------------------------------------------------
//						www.verificationguide.com
//-------------------------------------------------------------------------
import alu_pkg::*;
program random_test(intf_alu i_intf);
  
  //declaring environment instance
  environment env;
  
  initial begin
    //creating environment
    env = new(i_intf);
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.repeat_count = 7;
    
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram