`include "uvm_macros.svh"
import uvm_pkg :: *;

class env extends uvm_env;
  `uvm_component_utils(env)

  writeAgent  wagent;
  readAgent   ragent;
  scoreboard  scbd;

  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wagent = writeAgent::type_id::create("wagent", this);
    ragent = readAgent ::type_id::create("ragent", this);
    scbd   = scoreboard::type_id::create("scbd",   this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    wagent.mon.ap.connect(scbd.wmon_imp);
    ragent.mon.ap.connect(scbd.rmon_imp);
  endfunction

endclass