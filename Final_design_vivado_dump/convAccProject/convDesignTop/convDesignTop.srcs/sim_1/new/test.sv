

import uvm_pkg :: *;


class test extends uvm_test;
  `uvm_component_utils(test)

  my_env env;

  function new(string name = "test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = my_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    seq1 sq;
    phase.raise_objection(this);
    sq = seq1::type_id::create("sq");
    sq.start(env.wagent.seqr);
    #200;
    phase.drop_objection(this);
  endtask

endclass