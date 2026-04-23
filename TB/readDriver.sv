`include "uvm_macros.svh"
import uvm_pkg :: *;


class readDrv extends uvm_driver#(trn);
  `uvm_component_utils(readDrv)

  virtual design_if vif;  // not "virtual interface design_if"
  trn t;
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_config_db#(virtual design_if)::get(this, "", "vif", vif)) else begin
      `uvm_fatal(get_type_name(), "ConfigDB failed to get interface") 
      end
  endfunction

task run_phase(uvm_phase phase);
  vif.rdrvcb.m00_axis_tready <= 0;
  wait(vif.axis_aresetn == 1);
  @(vif.rdrvcb);

  forever begin
    vif.rdrvcb.m00_axis_tready <= 1;

    @(vif.rdrvcb);
    if (vif.rdrvcb.m00_axis_tvalid) begin
      `uvm_info(get_type_name(), $sformatf("Read data: 0x%0h", vif.rdrvcb.m00_axis_tdata), UVM_HIGH)
      if (vif.rdrvcb.m00_axis_tlast) begin
        `uvm_info(get_type_name(), "tlast received", UVM_HIGH)
        // Optionally deassert tready briefly between packets:
        // vif.rdrvcb.m00_axis_tready <= 0;
        // @(vif.rdrvcb);
      end
    end
  end
endtask




endclass
