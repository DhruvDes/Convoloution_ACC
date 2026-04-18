`include "uvm_macros.svh"
import uvm_pkg :: *;

class debug_16x16 extends uvm_sequence#(trn);
  `uvm_object_utils(debug_16x16)
 
  function new(string name = "debug_16x16");
    super.new(name);
  endfunction
 
  task body();
    trn t;
    t = trn::type_id::create("t");
    
    start_item(t);
    assert(t.randomize() with {
      rows      == 16;
      row_width == 16;
    });
 
   
    t.k00 = 1; t.k01 = 0; t.k02 = 1;
    t.k10 = 2; t.k11 = 0; t.k12 = 2;
    t.k20 = 1; t.k21 = 0; t.k22 = 1;
 

    for (int i = 1; i < t.data.size(); i++)
      t.data[i] = i[7:0];  
 
   
    t.build_packed_data();
 
    finish_item(t);
  endtask
endclass



class rand_16x16 extends uvm_sequence#(trn);
  `uvm_object_utils(rand_16x16)

  function new(string name = "rand_16x16");
    super.new(name);
  endfunction

  task body();
    trn t;
    t = trn::type_id::create("t");
    
    start_item(t);
    assert(t.randomize() with {
      rows      == 16;
      row_width == 16;
    });

    finish_item(t);
  endtask
endclass



class rand_28x28 extends uvm_sequence#(trn);
  `uvm_object_utils(rand_28x28)

  function new(string name = "rand_28x28");
    super.new(name);
  endfunction

  task body();
    trn t;
    t = trn::type_id::create("t");
    
    start_item(t);
    assert(t.randomize() with {
      rows      == 28;
      row_width == 28;
    });

    finish_item(t);
  endtask
endclass