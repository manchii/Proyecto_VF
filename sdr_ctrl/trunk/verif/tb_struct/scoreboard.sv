//gets the packet from monitor, Generated the expected result and compares with the //actual result recived from Monitor

class scoreboard;
   
//--------------------
// data/address/burst length FIFO
//--------------------
int dfifo[$]; // data fifo
int afifo[$]; // address  fifo
int bfifo[$]; // Burst Length fifo

reg [31:0] ErrCnt;
reg [31:0] StartAddr;  


  //constructor
  function new();
	this.ErrCnt = 0;
  endfunction
  

  
endclass
