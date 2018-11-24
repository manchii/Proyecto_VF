/////////////////////////////////////////////////////////
//   Proyecto1. Curso MP6134 Verificacion Funcional    //
//   Archivo: driver.sv                                //
//   Autores: Esteban Martinez                         //
//            Kaleb Alfaro                             //
//            Felipe Dengo                             //
/////////////////////////////////////////////////////////

//gets the packet from generator and drive the transaction paket items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT)

class driver;

  //used to count the number of transactions
  int no_transactions;

  //creating virtual interface handle
  virtual intf_wishbone vif;
  virtual intf_sdram16 vif_ram;
  scoreboard scb;


  //constructor
  function new(virtual intf_wishbone vif, virtual intf_sdram16 vif_ram ,scoreboard scb);
    //getting the interface
    this.vif = vif;
    this.vif_ram = vif_ram;
    //getting the mailbox handles from  environment
    this.scb = scb;
  endfunction

task burst_write;
input [31:0] Address;
input [7:0]  bl;
int i;
begin
//  scb.afifo.push_back(Address);
//  scb.bfifo.push_back(bl);
  queue_ret sample;
  sample.address = Address;
  sample.burst = bl;

  @ (negedge vif.sys_clk);
   $display("Write Address: %x, Burst Size: %d",Address,bl);

   for(i=0; i < bl; i++) begin
      vif.wb_stb_i        = 1;
      vif.wb_cyc_i        = 1;
      vif.wb_we_i         = 1;
      vif.wb_sel_i        = 4'b1111;
      vif.wb_addr_i       = Address[31:2]+i;
      vif.wb_dat_i        = $random & 32'hFFFFFFFF;
     //scb.dfifo.push_back(vif.wb_dat_i);
     sample.data.push_back(vif.wb_dat_i);

      do begin
        @ (posedge vif.sys_clk);
      end while(vif.wb_ack_o == 1'b0);
     @ (negedge vif.sys_clk);

     $display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,vif.wb_addr_i,vif.wb_dat_i);
   end
  scb.push(sample);
   vif.wb_stb_i        = 0;
   vif.wb_cyc_i        = 0;
   vif.wb_we_i         = 'hx;
   vif.wb_sel_i        = 'hx;
   vif.wb_addr_i       = 'hx;
   vif.wb_dat_i        = 'hx;
end
endtask



  //Reset task, Reset the Interface signals to default/initial values
  task reset;
   vif.wb_addr_i      = 0;
   vif.wb_dat_i      = 0;
   vif.wb_sel_i       = 4'h0;
   vif.wb_we_i        = 0;
   vif.wb_stb_i       = 0;
   vif.wb_cyc_i       = 0;

  vif.RESETN    = 1'h1;

 #100
  // Applying reset
  vif.RESETN    = 1'h0;
  #10000;
  // Releasing reset
  vif.RESETN    = 1'h1;
  #1000;
  wait(vif_ram.sdr_init_done == 1);

  #1000;
  endtask


endclass
