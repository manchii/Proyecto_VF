/////////////////////////////////////////////////////////
//   Proyecto1. Curso MP6134 Verificacion Funcional    //
//   Archivo: environment.sv                           //
//   Autores: Esteban Martinez                         //
//            Kaleb Alfaro                             //
//            Felipe Dengo                             //
/////////////////////////////////////////////////////////



//`include "scoreboard.sv"
//`include "driver.sv"
//`include "monitor.sv"


class environment;

  //generator and driver instance
/*
  generator 	gen;
*/
  driver    	driv;

  monitor   	mon;

  scoreboard	scb;


  //virtual interface
  virtual intf_wishbone vif;

  virtual intf_sdram16 vif_ram;



  //constructor
  function new(virtual intf_wishbone vif,virtual intf_sdram16 vif_ram);
    //get the interface from test
    this.vif = vif;
    this.vif_ram = vif_ram;

    //creating the mailbox (Same handle will be shared across generator and driver)

    this.scb  = new();
    this.driv = new(vif,vif_ram,this.scb);

    this.mon  = new(vif,vif_ram,this.scb);


  endfunction

  //

  task pre_test();
    driv.reset();
  endtask

  task burst_write;
    input [31:0] Address;
    input [7:0] bl;
    begin
      this.driv.burst_write(Address,bl);
    end
  endtask

  task burst_read;
    begin
      this.mon.burst_read();
    end
  endtask


endclass
