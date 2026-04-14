`include "uvm_macros.svh"
//`include "transaction.sv"
import uvm_pkg :: *;

class seq1 extends uvm_sequence#(trn);
  `uvm_object_utils(seq1)

  function new(string name = "seq1");
    super.new(name);
  endfunction

  task body();
    trn t;
    t = trn::type_id::create("t");
    
    start_item(t);
    assert(t.randomize());

    // Sobel Gx kernel (horizontal edge detection)
    //  -1  0  +1
    //  -2  0  +2
    //  -1  0  +1
    t.k00 = -1; t.k01 = 0; t.k02 = 1;
    t.k10 = -2; t.k11 = 0; t.k12 = 2;
    t.k20 = -1; t.k21 = 0; t.k22 = 1;
    
 
    
    finish_item(t);
  endtask

endclass