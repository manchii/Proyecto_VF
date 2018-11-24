`include "environment.sv"
class environment_2 extends environment;
    //constructor
  function new(virtual intf_wishbone vif,virtual intf_sdram16 vif_ram);
    super.new(vif,vif_ram);
  endfunction
endclass
