`include "uvm_macros.svh"
import uvm_pkg :: *;


class test extends uvm_test;
  `uvm_component_utils(test)

  env envt;

  function new(string name = "test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    envt = env ::type_id :: create("envt", this);
  endfunction

  task run_phase(uvm_phase phase);
        debug_16x16 dbg16x16;
        rand_16x16 rnd16x16;
        rand_28x28 rnd28x28;
        phase.raise_objection(this);

     
        dbg16x16  = debug_16x16 ::type_id::create("dbg16x16");
        rnd16x16  = rand_16x16 ::type_id::create("rnd16x16");
        rnd28x28  = rand_28x28 ::type_id::create("rnd28x28");

            repeat(3)dbg16x16.start(envt.wagent.seqr);
            repeat(3)rnd16x16.start(envt.wagent.seqr);
            repeat(3)rnd28x28.start(envt.wagent.seqr);

        
        #200;

        phase.drop_objection(this);
  endtask

endclass