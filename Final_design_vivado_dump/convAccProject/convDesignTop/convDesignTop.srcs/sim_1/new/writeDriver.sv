`include "uvm_macros.svh"
import uvm_pkg :: *;


class writeDrv extends uvm_driver#(trn);
  `uvm_component_utils(writeDrv)

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
  wait(vif.axis_aresetn == 1);
  @(vif.wdrvcb);

  forever begin
   
    seq_item_port.get_next_item(t);
//    `uvm_info(get_type_name(), "Driver reaching write_cfg task", UVM_NONE)
    write_cfg(t);
    stream_matrix(t);
    seq_item_port.item_done();
  end
endtask

task write_cfg(trn t);
  logic [31:0] data [4];
  int i = 0;
  t.print();
  data[0] = 32'({t.rows, t.row_width});
  data[1] = {2'b0, t.k02, t.k01, t.k00};
  data[2] = {2'b0, t.k12, t.k11, t.k10};
  data[3] = {2'b0, t.k22, t.k21, t.k20};

    while(i < 4)begin
        @(vif.wdrvcb);
        if(vif.wdrvcb.s00_axis_tready)begin
//          `uvm_info(get_type_name(), $sformatf("Driving cfg"), UVM_NONE)
            vif.wdrvcb.s00_axis_tdata <= data[i];
            vif.wdrvcb.s00_axis_tlast <= (i == 3) ? 1 : 0;
            vif.wdrvcb.s00_axis_tvalid <= 1;
           
            i++;
        end else begin
         
        end
end
  // Deassert after all beats sent
  @(vif.wdrvcb);
  vif.wdrvcb.s00_axis_tvalid <= 1'b0;
endtask



task stream_matrix(trn t);

foreach (t.packed_data[i]) begin

  @(vif.wdrvcb);
  if(vif.wdrvcb.s00_axis_tready)begin
    `uvm_info(get_type_name(), $sformatf("Driving data"), UVM_NONE)
    vif.wdrvcb.s00_axis_tdata <= t.packed_data[i];
    vif.wdrvcb.s00_axis_tlast <= (i == t.packed_data.size() - 1) ? 1 : 0;
    vif.wdrvcb.s00_axis_tvalid <= 1;


    end else begin

  end


end
  @(vif.wdrvcb);
  vif.wdrvcb.s00_axis_tvalid <= 1'b0;



endtask








endclass

