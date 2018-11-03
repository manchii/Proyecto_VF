/////////////////////////////////////////////////////////
//   Proyecto1. Curso MP6134 Verificacion Funcional    //
//   Archivo: monitor.sv                               //
//   Autores: Esteban Martinez                         //
//            Kaleb Alfaro                             //
//            Felipe Dengo                             //
/////////////////////////////////////////////////////////


//Samples the interface signals, captures into transaction packet and send the packet to scoreboard.

class monitor;

  //creating virtual interface handle
  virtual intf_wishbone vif;
  virtual intf_sdram16 vif_ram;
  scoreboard scb;




  //constructor
  function new(virtual intf_wishbone vif,virtual intf_sdram16 vif_ram ,scoreboard scb);
    //getting the interface
    this.vif = vif;
    this.vif_ram = vif_ram;
    //getting the mailbox handles from  environment
    this.scb = scb;
  endfunction


  //Samples the interface signal and send the sample packet to scoreboard
task burst_read;
reg [31:0] Address;
reg [7:0]  bl;

int i,j;
reg [31:0]   exp_data;
begin

   Address = scb.afifo.pop_front();
   bl      = scb.bfifo.pop_front();
  $display("asdasdasdas %x",bl);
  @ (negedge vif.sys_clk);

      for(j=0; j < bl; j++) begin
         vif.wb_stb_i        = 1;
         vif.wb_cyc_i        = 1;
         vif
        .wb_we_i         = 0;
         vif.wb_addr_i       = Address[31:2]+j;

         exp_data        = scb.dfifo.pop_front(); // Exptected Read Data
         do begin
           @ (posedge vif.sys_clk);
         end while(vif.wb_ack_o == 1'b0);
        if(vif.wb_dat_o !== exp_data) begin
          $display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",j,vif.wb_addr_i,vif.wb_dat_o,exp_data);
             scb.ErrCnt = scb.ErrCnt+1;
         end else begin
           $display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",j,vif.wb_addr_i,vif.wb_dat_o);
         end
        @ (negedge vif_ram.sdram_clk);
      end
   vif.wb_stb_i        = 0;
   vif.wb_cyc_i        = 0;
   vif.wb_we_i         = 'hx;
   vif.wb_addr_i       = 'hx;

end
endtask

endclass
