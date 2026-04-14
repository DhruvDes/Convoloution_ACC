`include "uvm_macros.svh"
//`include "transaction.sv"
//`include "sequenceLib.sv"
//`include "writeDriver.sv"
import uvm_pkg :: *;




class writeAgent extends uvm_agent;
  `uvm_component_utils(writeAgent)  // was writeDriver, must match class name

  function new(string name = "writeAgent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

    writeDrv wdrv;
    uvm_sequencer#(trn) seqr;
    // monitor soon

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    wdrv = writeDrv :: type_id :: create("wdrv", this);
    seqr = uvm_sequencer#(trn) :: type_id :: create("seqr", this);
    
    endfunction
    
    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        wdrv.seq_item_port.connect(seqr.seq_item_export);
        
    endfunction


endclass


