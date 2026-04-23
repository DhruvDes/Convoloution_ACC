interface fifoif (input clk);

  logic        arstn;
  logic [31:0] wr_data;
  logic        wr_last;
  logic        wr_en;
  logic [31:0] M_TDATA;
  logic        M_TVALID;
  logic        M_TLAST;
  logic        M_TREADY;
  logic        full;
  logic        empty;
  logic        almost_full;

  clocking drv_cb @(posedge clk);
    default input #1 output #1;
    output wr_data, wr_last, wr_en, arstn;
    input M_TDATA, M_TVALID, M_TLAST, M_TREADY;
    input full, empty, almost_full;
  endclocking

endinterface

class transaction;
  rand int size;
  rand logic [31:0] wr_data[];  // dynamic array

  constraint size_c {
    size inside {[1:256]};
  }

  constraint wr_data_c {
    wr_data.size() == size;
  }
endclass

module tb();
  logic clk = 0;
  always #5 clk = ~clk;

  fifoif vif(clk);

  axis_fifo_m dut(
    .clk(clk),
    .arstn(vif.arstn),
    .wr_data(vif.wr_data),
    .wr_last(vif.wr_last),
    .wr_en(vif.wr_en),
    .M_TDATA(vif.M_TDATA),
    .M_TVALID(vif.M_TVALID),
    .M_TLAST(vif.M_TLAST),
    .M_TREADY(vif.M_TREADY),
    .full(vif.full),
    .empty(vif.empty),
    .almost_full(vif.almost_full)
  );

  transaction t;

  task reset();
  	vif.drv_cb.arstn <= 0;
    repeat(2)@(posedge clk);
    vif.drv_cb.arstn <= 1;

  endtask


  task drive();
    t = new();
    t.randomize();


    foreach (t.wr_data[i]) begin
      vif.drv_cb.wr_data <= t.wr_data[i];
      vif.drv_cb.wr_last <= (i == t.size-1) ? 1 : 0;
      vif.drv_cb.wr_en <= 1;
      @(posedge clk);
    end

  endtask

  
  
endmodule