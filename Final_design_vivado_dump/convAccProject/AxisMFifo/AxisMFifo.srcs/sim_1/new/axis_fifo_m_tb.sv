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
    output wr_data, wr_last, wr_en, arstn, M_TREADY;
    input M_TDATA, M_TVALID, M_TLAST;
    input full, empty, almost_full;
  endclocking

endinterface

class transaction;
  rand int size;
  rand logic [31:0] wr_data[];  // dynamic array

  constraint size_c {
    size inside {[1:255]};
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
  vif.wr_en   <= 0;
  vif.wr_data <= '0;
  vif.wr_last <= 0;
  vif.arstn   <= 0;
  repeat(2) @(posedge clk);
  vif.arstn   <= 1;
  @(posedge clk);  // one idle cycle after reset deasserts
endtask


task drive();
  t = new();
  t.randomize();
  foreach (t.wr_data[i]) begin
    @(posedge clk);
    vif.wr_data  <= t.wr_data[i];
    vif.wr_last  <= (i == t.size - 1) ? 1 : 0;
    vif.wr_en    <= 1;
  end
  @(posedge clk);
  vif.wr_en   <= 0;
  vif.wr_last <= 0;
endtask
  
  task read();
  int idx = 0;
  int errors = 0;
    $display("%p", t.wr_data);
  vif.drv_cb.M_TREADY <= 1;

  while (idx < t.size) begin
    @(posedge clk);
    if (vif.drv_cb.M_TVALID) begin
      // Check data
      if (vif.drv_cb.M_TDATA !== t.wr_data[idx]) begin
        $error("[%0t] Data mismatch at idx %0d: expected 0x%08h, got 0x%08h",
               $time, idx, t.wr_data[idx], vif.drv_cb.M_TDATA);
        errors++;
      end

      // Check TLAST - should only be high on the last beat
      if (idx == t.size - 1) begin
        if (vif.drv_cb.M_TLAST !== 1)  begin
          $error("[%0t] TLAST expected HIGH on last beat (idx %0d)", $time, idx);
          errors++;
        end
      end else begin
        if (vif.drv_cb.M_TLAST !== 0) begin
          $error("[%0t] TLAST expected LOW at idx %0d", $time, idx);
          errors++;
        end
      end

      idx++;
    end
  end

  vif.drv_cb.M_TREADY <= 0;

  if (errors == 0)
    $display("[%0t] READ PASS: All %0d beats matched.", $time, t.size);
  else
    $display("[%0t] READ FAIL: %0d errors in %0d beats.", $time, errors, t.size);
endtask
  

  
  initial begin 
    reset();

    fork 
    drive();
    read();
    join

    $finish();
  end
  
  initial begin 
    $dumpvars();
    $dumpfile("dump.vcd");
  
  end
  
endmodule