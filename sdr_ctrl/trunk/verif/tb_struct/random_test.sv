`include "environment.sv"
program test(intf_wishbone i_intf_wishbone, intf_sdram16 i_intf_sdrwam16);

  //declaring environment instance
  environment env;

  initial begin
    //creating environment
    env = new(i_intf_wishbone,i_intf_sdrwam16);
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram
