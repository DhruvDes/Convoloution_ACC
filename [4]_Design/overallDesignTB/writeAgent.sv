`include "uvm_macros.svh"
import uvm_pkg :: *;

class writeAgent extends uvm_agent;
  `uvm_component_utils(writeAgent)

  writeDrv             wdrv;
  writeMon             mon;
  uvm_sequencer#(trn)  seqr;

  function new(string name = "writeAgent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wdrv = writeDrv             :: type_id :: create("wdrv", this);
    mon  = writeMon             :: type_id :: create("mon",  this);
    seqr = uvm_sequencer#(trn)  :: type_id :: create("seqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    wdrv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass