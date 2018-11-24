
`include "environment_2.sv"
`include "transaction.sv"


program test_2(intf_wishbone i_intf_wishbone, intf_sdram16 i_intf_sdrwam16);
  environment_2 env;
  transaction gen1;
  transaction gen2;
  transaction gen3;
  initial begin

  env = new(i_intf_wishbone,i_intf_sdrwam16);

  gen1 = new;
  gen1.randomize() with {queue_len inside {[1:5]};
                           foreach (address[i])
                             address[i] inside {[12'h100:12'h1FF]};};
  gen1.display();


  gen2 = new;
  gen2.randomize() with {queue_len inside {[1:5]};};
  gen2.display();



  gen3 = new;
  gen3.randomize() with {queue_len inside {[1:5]};
                         foreach (address[i])
                           (address[i+1]>>8) != (address[i]>>8);};
  gen3.display();



  env.pre_test();
  test();
  $finish;
  end

  task test();
  $display("-------------------------------------- ");
    $display(" Case-1: Generator 1        ");
  $display("-------------------------------------- ");

    foreach (gen1.address[i]) begin
      env.burst_write(gen1.address[i],gen1.bl[i]);
      env.burst_read();
    end

  $display("-------------------------------------- ");
    $display(" Case-2: Generator 2        ");
  $display("-------------------------------------- ");

    foreach (gen2.address[i]) begin
      env.burst_write(gen2.address[i],gen2.bl[i]);
      env.burst_read();
    end
  env.scb.rand_order = 1;
  $display("-------------------------------------- ");
    $display(" Case-3: Generator 3        ");
  $display("-------------------------------------- ");

    foreach (gen3.address[i]) begin
      env.burst_write(gen3.address[i],gen3.bl[i]);
    end
    foreach (gen3.address[i]) begin
      env.burst_read();
    end


    if(env.scb.ErrCnt == 0)
        $display("STATUS: SDRAM Write/Read TEST PASSED");
    else
        $display("ERROR:  SDRAM Write/Read TEST FAILED");
        $display("###############################");

  endtask

endprogram
