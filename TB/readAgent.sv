`include "uvm_macros.svh"
import uvm_pkg :: *;

class readAgent extends uvm_agent;
  `uvm_component_utils(readAgent)

  readDrv              rdrv;
  readMon              mon;
  uvm_sequencer#(trn)  seqr;

  function new(string name = "readAgent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rdrv = readDrv              :: type_id :: create("rdrv", this);
    mon  = readMon              :: type_id :: create("mon",  this);
    seqr = uvm_sequencer#(trn)  :: type_id :: create("seqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rdrv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass