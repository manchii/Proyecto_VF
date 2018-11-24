/////////////////////////////////////////////////////////
//   Proyecto1. Curso MP6134 Verificacion Funcional    //
//   Archivo: transaction.sv                           //
//   Autores: Esteban Martinez                         //
//            Kaleb Alfaro                             //
//            Felipe Dengo                             //
/////////////////////////////////////////////////////////
class transaction;
  //declaring the transaction items
  rand bit [11:0] address[$];
  rand bit [7:0] bl[$];
//  rand bit [6:0] data[$];
  rand int queue_len;

  function void display();
    foreach (address[i])
      $display("%d Address: %x, Burst Size: %d",i,address[i],bl[i]);
  endfunction

  constraint len {address.size() == queue_len; bl.size() == queue_len;};
  constraint bl_limits {foreach (bl[i]) bl[i] inside {[1:8]};};
  constraint alignment {foreach (address[i]) address[i][1:0] == 0;};

endclass
