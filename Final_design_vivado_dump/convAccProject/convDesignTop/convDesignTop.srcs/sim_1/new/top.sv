`include "uvm_macros.svh"
import uvm_pkg :: *;

`uvm_analysis_imp_decl(_wmon)
`uvm_analysis_imp_decl(_rmon)

`include "Interface.sv"
`include "transaction.sv"
`include "sequenceLib.sv"
`include "writeDriver.sv"
`include "writeMonitor.sv"
`include "writeAgent.sv"
`include "env.sv"
`include "test.sv"

module tb();

  logic clk;

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Interface instance
  design_if vif(clk);

  // DUT connection (when ready)
  // your_dut dut(
  //   .axis_aclk(clk),
  //   .s00_axis_tdata(vif.s00_axis_tdata),
  //   ...
  // );

convAcc DUT(
  .axis_aclk(clk),
  .axis_aresetn(vif.axis_aresetn),

  .s00_axis_tdata(vif.s00_axis_tdata),
  .s00_axis_tlast(vif.s00_axis_tlast),  
  .s00_axis_tvalid(vif.s00_axis_tvalid),
  .s00_axis_tready(vif.s00_axis_tready),

  .m00_axis_tdata(vif.m00_axis_tdata),
  .m00_axis_tlast(vif.m00_axis_tlast),
  .m00_axis_tvalid(vif.m00_axis_tvalid),
  .m00_axis_tready(vif.m00_axis_tready)

);

  initial begin
    vif.axis_aresetn = 0;
    repeat(3) @(posedge clk);
    vif.axis_aresetn = 1;
  end


  initial begin
    uvm_config_db#(virtual design_if)::set(null, "*", "vif", vif);
    run_test("test");
  end

endmodule






