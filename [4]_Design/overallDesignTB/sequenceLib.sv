`include "uvm_macros.svh"
import uvm_pkg :: *;

class base_seq extends uvm_sequence#(trn);
  `uvm_object_utils(base_seq)

  uvm_event txn_verified;

  function new(string name = "base_seq");
    super.new(name);
  endfunction

  task pre_start();
    txn_verified = uvm_event_pool::get_global("txn_verified");
    txn_verified.reset();   // start clean, no stale trigger
  endtask

  task send_item(trn t);
    uvm_test_done.raise_objection(this, "sending transaction");
    start_item(t);
    finish_item(t);                  // driver consumes -> DUT processes
    txn_verified.wait_trigger();     // scoreboard signals when verified
    uvm_test_done.drop_objection(this, "transaction verified");
  endtask
endclass





class debug_16x16 extends  base_seq;
  `uvm_object_utils(debug_16x16)
 
  function new(string name = "debug_16x16");
    super.new(name);
  endfunction

  task body();
    trn t;
    t = trn::type_id::create("t");
    
 
    assert(t.randomize() with {
      rows      == 16;
      row_width == 16;
    });
 
   
    t.k00 = 0; t.k01 = 0; t.k02 = 0;
    t.k10 = 0; t.k11 = 1; t.k12 = 0;
    t.k20 = 0; t.k21 = 0; t.k22 = 0;
 

    for (int i = 1; i < t.data.size(); i++)
      t.data[i] = i[7:0];  
 
   
    t.build_packed_data();
 
    send_item(t);
  endtask
endclass



class rand_16x16 extends  base_seq;
  `uvm_object_utils(rand_16x16)

  function new(string name = "rand_16x16");
    super.new(name);
  endfunction

  task body();
    trn t;
    t = trn::type_id::create("t");
    
    assert(t.randomize() with {
      rows      == 16;
      row_width == 16;
    });

    
    send_item(t);
  endtask
endclass



class rand_28x28 extends base_seq;
  `uvm_object_utils(rand_28x28)

  function new(string name = "rand_28x28");
    super.new(name);
  endfunction

  task body();
    trn t;
    t = trn::type_id::create("t");
        assert(t.randomize() with {
      rows      == 28;
      row_width == 28;
    });
    send_item(t);



  endtask
endclass



class random_testing extends  base_seq;
  `uvm_object_utils(random_testing)

  function new(string name = "randon_testing");
    super.new(name);
  endfunction

  task body();
    trn t;
    t = trn::type_id::create("t");
    assert(t.randomize());
    send_item(t);
    
 
  endtask
  
endclass