`include "uvm_macros.svh"
import uvm_pkg :: *;


class readMon extends uvm_monitor;
  `uvm_component_utils(readMon)

  virtual design_if vif;
  uvm_analysis_port#(trn) ap;

  protected logic [31:0] captured_words[$];
  protected trn          t;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    if (!uvm_config_db#(virtual design_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "ConfigDB failed to get interface")
  endfunction

  task run_phase(uvm_phase phase);
    wait (vif.axis_aresetn === 1'b1);
    reset_packet();

    forever begin
      @(vif.rmoncb);

      if (vif.axis_aresetn !== 1'b1) begin
        reset_packet();
        wait (vif.axis_aresetn === 1'b1);
        continue;
      end

      // Sample only when both valid and ready are high (real handshake)
      if (vif.rmoncb.m00_axis_tvalid && vif.rmoncb.m00_axis_tready) begin
        captured_words.push_back(vif.rmoncb.m00_axis_tdata);

        if (vif.rmoncb.m00_axis_tlast) begin
          finalise_and_publish();
          reset_packet();
        end
      end
    end
  endtask

  function void reset_packet();
    captured_words.delete();
    t = trn::type_id::create("t");
  endfunction

  function void finalise_and_publish();
    t.packed_data = new[captured_words.size()];
    foreach (captured_words[i])
      t.packed_data[i] = captured_words[i];

    `uvm_info(get_type_name(),
              $sformatf("READ packet complete: %0d output words", captured_words.size()),
              UVM_HIGH)
    ap.write(t);
  endfunction

endclass