`include "uvm_macros.svh"
//`include "transaction.sv"
//`include "sequenceLib.sv"
//`include "writeDriver.sv"
//`include "writeAgent.sv"
import uvm_pkg :: *;



class my_env extends uvm_env;
  `uvm_component_utils(my_env)

  writeAgent  wagent;
  // readAgent   ragent;    // when ready
  // scoreboard  scbd;      // when ready

  function new(string name = "my_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wagent = writeAgent::type_id::create("wagent", this);
    // ragent = readAgent::type_id::create("ragent", this);
    // scbd   = scoreboard::type_id::create("scbd", this);
  endfunction

  function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    // wagent.mon.ap.connect(scbd.write_fifo.analysis_export);
    // ragent.mon.ap.connect(scbd.read_fifo.analysis_export);
  endfunction

endclass