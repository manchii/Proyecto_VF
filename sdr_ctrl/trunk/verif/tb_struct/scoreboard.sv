/////////////////////////////////////////////////////////
//   Proyecto1. Curso MP6134 Verificacion Funcional    //
//   Archivo: scoreboard.sv                            //
//   Autores: Esteban Martinez                         //
//            Kaleb Alfaro                             //
//            Felipe Dengo                             //
/////////////////////////////////////////////////////////


//gets the packet from monitor, Generated the expected result and compares with the //actual result recived from Monitor
typedef struct { int data[$], address, burst; } queue_ret ;

class scoreboard;
   
//--------------------
// data/address/burst length FIFO
//--------------------
int dfifo[$]; // data fifo
int afifo[$]; // address  fifo
int bfifo[$]; // Burst Length fifo
  
queue_ret qfifo[$];
  
reg [31:0] ErrCnt;
reg [31:0] StartAddr;  

bit rand_order;

  //constructor
  function new();
	this.ErrCnt = 0;
    this.rand_order=0;
  endfunction
  

  function push(queue_ret sample);
    qfifo.push_back(sample);
  endfunction
  
  function queue_ret pop();
    int indx,i;
    std::randomize(indx)
    with {indx >= 0; indx < qfifo.size();};
    $display("pop %d, size %d",indx, qfifo.size());
    if(this.rand_order) begin 
      pop = qfifo[indx];
      qfifo.delete(indx);
    end
    else begin
      pop = qfifo.pop_front();
    end
  endfunction  
  
endclass
