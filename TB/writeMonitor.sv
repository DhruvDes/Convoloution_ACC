`include "uvm_macros.svh"
import uvm_pkg :: *;
 
// ----------------------------------------------------------------------------
// writeMon
//   Observes the slave AXIS (input side of convAcc).
//   Beat layout from the driver:
//     beat 0      : { rows, row_width }
//     beat 1      : { 2'b0, k02, k01, k00 }
//     beat 2      : { 2'b0, k12, k11, k10 }
//     beat 3      : { 2'b0, k22, k21, k20 }
//     beat 4..N-1 : packed pixel data (4 bytes per beat), tlast on final beat
//
//   Builds a trn from the observed bus traffic and publishes it on `ap`
//   when tlast is seen.
// ----------------------------------------------------------------------------
class writeMon extends uvm_monitor;
  `uvm_component_utils(writeMon)
 
  virtual design_if vif;
  uvm_analysis_port#(trn) ap;
 
  // local capture state
  protected int          beat_idx;
  protected logic [31:0] captured_words[$];
  protected trn          t;
 
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    // NOTE: original code had `!uvm_config_db...::get(...)` which inverted the
    // success check. The correct form asserts on the get() result directly.
    if (!uvm_config_db#(virtual design_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "ConfigDB failed to get interface")
  endfunction
 
  task run_phase(uvm_phase phase);
    // Wait for reset deassertion before sampling
    wait (vif.axis_aresetn === 1'b1);
    reset_packet();
 
    forever begin
      @(vif.wmoncb);
 
      // Re-arm on reset
      if (vif.axis_aresetn !== 1'b1) begin
        reset_packet();
        wait (vif.axis_aresetn === 1'b1);
        continue;
      end
 
      // Valid handshake?
      if (vif.wmoncb.s00_axis_tvalid && vif.wmoncb.s00_axis_tready) begin
        capture_beat(vif.wmoncb.s00_axis_tdata, vif.wmoncb.s00_axis_tlast);
      end
    end
  endtask
 
  // ------------------------------------------------------------------
  // helpers
  // ------------------------------------------------------------------
  function void reset_packet();
    beat_idx = 0;
    captured_words.delete();
    t = trn::type_id::create("t");
  endfunction
 
  function void capture_beat(logic [31:0] beat, logic last);
    case (beat_idx)
      0: begin
        // {rows[9:0], row_width[5:0]} packed into low 16 bits
        t.row_width = beat[5:0];
        t.rows      = beat[15:6];
      end
      1: begin
        t.k00 = beat[8:0];
        t.k01 = beat[17:9];
        t.k02 = beat[26:18];
      end
      2: begin
        t.k10 = beat[8:0];
        t.k11 = beat[17:9];
        t.k12 = beat[26:18];
      end
      3: begin
        t.k20 = beat[8:0];
        t.k21 = beat[17:9];
        t.k22 = beat[26:18];
      end
      default: begin
        captured_words.push_back(beat);
      end
    endcase
 
    beat_idx++;
 
    // tlast finalises the packet
    if (last) begin
      finalise_and_publish();
      reset_packet();
    end
  endfunction
 
  function void finalise_and_publish();
    int n_words;
    n_words = captured_words.size();
 
    // Reconstruct the byte-stream the same way the driver packed it:
    // packed_data[i] = {data[i*4+4], data[i*4+3], data[i*4+2], data[i*4+1]}
    // i.e. data[1] is in beat[7:0], data[2] in beat[15:8], etc.
    // The driver also prepends a dummy data[0]=0 byte.
    t.packed_data = new[n_words];
    t.data        = new[n_words * 4 + 1];
    t.data[0]     = 8'h00;
 
    foreach (captured_words[i]) begin
      t.packed_data[i] = captured_words[i];
      t.data[i*4 + 1]  = captured_words[i][7:0];
      t.data[i*4 + 2]  = captured_words[i][15:8];
      t.data[i*4 + 3]  = captured_words[i][23:16];
      t.data[i*4 + 4]  = captured_words[i][31:24];
    end
 
    `uvm_info(get_type_name(),
              $sformatf("WRITE packet complete: rows=%0d width=%0d data_words=%0d",
                        t.rows, t.row_width, n_words),
              UVM_HIGH)
    ap.write(t);
  endfunction
 
endclass
 