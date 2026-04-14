class writeMon extends uvm_monitor;
  `uvm_component_utils(writeMon)

  virtual design_if vif;
  uvm_analysis_port#(trn) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    assert((!uvm_config_db#(virtual design_if)::get(this, "", "vif", vif))) else begin
      `uvm_fatal(get_type_name(), "ConfigDB failed to get interface") end
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      trn t;
      t = trn::type_id::create("t");
      @(vif.wmoncb);
      if (vif.wmoncb.s00_axis_tvalid && vif.wmoncb.s00_axis_tready) begin
        // t.s00_axis_tdata = vif.wmoncb.s00_axis_tdata;
        // t.s00_axis_tlast = vif.wmoncb.s00_axis_tlast;
        // t.data.push_back(vif.wmoncb.s00_axis_tdata);
        ap.write(t);
      end
    end
  endtask

endclass