`include "uvm_macros.svh"
import uvm_pkg :: *;
 

 
class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
 
  uvm_analysis_imp_wmon#(trn, scoreboard) wmon_imp;
  uvm_analysis_imp_rmon#(trn, scoreboard) rmon_imp;
 
  trn write_q[$];
  trn read_q[$];
 
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wmon_imp = new("wmon_imp", this);
    rmon_imp = new("rmon_imp", this);
  endfunction
 
  // called by writeMon's analysis port
  function void write_wmon(trn t);
    write_q.push_back(t);
    `uvm_info(get_type_name(), "--- WRITE MONITOR PACKET ---", UVM_FULL)
    // t.print();
  endfunction
 
  // called by readMon's analysis port
  extern function void write_rmon(trn t);  


  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),
      $sformatf("SCOREBOARD SUMMARY: write_q=%0d read_q=%0d",
                write_q.size(), read_q.size()),
      UVM_NONE)
  endfunction
 
endclass
 



function void scoreboard::write_rmon(trn t);
  trn in_trn;
  logic [7:0] matrix[][];
  logic signed [8:0] fk[3][3];
  int out_rows;
  int out_cols; 
  int total_pixels; 
  int num_words;
  logic signed [31:0] sum;
  logic [7:0] clamped;
  logic [7:0] flat_pixels[];
  logic [31:0] expected_packed[];
  logic [7:0] b0, b1, b2, b3;
  int mismatches;

  read_q.push_back(t);

  if (write_q.size() == 0) begin
    `uvm_error(get_type_name(), "No matching input!")
    return;
  end

  in_trn = write_q.pop_front();

  // Rebuild the 2D matrix from the flat data array
  matrix = new[in_trn.rows];
  for (int r = 0; r < in_trn.rows; r++) begin
    matrix[r] = new[in_trn.row_width];
    for (int c = 0; c < in_trn.row_width; c++) begin
      matrix[r][c] = in_trn.data[r * in_trn.row_width + c + 1];  // +1 skips dummy data[0]
    end
  end

  // Debug print
//  for (int r = 0; r < in_trn.rows; r++) begin
//    string line;
//    line = $sformatf("row[%0d]: ", r);
//    for (int c = 0; c < in_trn.row_width; c++)
//      line = {line, $sformatf("%3d ", matrix[r][c])};
//    `uvm_info(get_type_name(), line, UVM_MEDIUM)
//  end


  fk[0][0] = in_trn.k22;  fk[0][1] = in_trn.k21;  fk[0][2] = in_trn.k20;
  fk[1][0] = in_trn.k12;  fk[1][1] = in_trn.k11;  fk[1][2] = in_trn.k10;
  fk[2][0] = in_trn.k02;  fk[2][1] = in_trn.k01;  fk[2][2] = in_trn.k00;

// Output dimensions (valid region, no padding)

  out_rows = in_trn.rows - 2;
  out_cols = in_trn.row_width - 2;
  total_pixels = out_rows * out_cols;
  num_words = (total_pixels + 3) / 4;  // ceil division for 32-bit packing



// Compute convolution and clamp
flat_pixels = new[total_pixels];
for (int r = 0; r < out_rows; r++) begin
  for (int c = 0; c < out_cols; c++) begin
    sum = 0;
    for (int ki = 0; ki < 3; ki++) begin
      for (int kj = 0; kj < 3; kj++) begin
        sum += fk[ki][kj] * $signed({1'b0, matrix[r + ki][c + kj]});
      end
    end

    // Clamp to [0, 255]
    if (sum < 0)        clamped = 8'd0;
    else if (sum > 255) clamped = 8'd255;
    else                clamped = sum[7:0];

    flat_pixels[r * out_cols + c] = clamped;
  end
end

// Pack into 32-bit words (4 bytes per word, same order as DUT output)
expected_packed = new[num_words];
for (int i = 0; i < num_words; i++) begin

  b0 = (i*4 + 0 < total_pixels) ? flat_pixels[i*4 + 0] : 8'h00;
  b1 = (i*4 + 1 < total_pixels) ? flat_pixels[i*4 + 1] : 8'h00;
  b2 = (i*4 + 2 < total_pixels) ? flat_pixels[i*4 + 2] : 8'h00;
  b3 = (i*4 + 3 < total_pixels) ? flat_pixels[i*4 + 3] : 8'h00;
  expected_packed[i] = {b3, b2, b1, b0};
end

// Compare against DUT output
if (expected_packed.size() != t.packed_data.size()) begin
  `uvm_error(get_type_name(),
    $sformatf("Size mismatch: expected %0d words, got %0d",
              expected_packed.size(), t.packed_data.size()))
end else begin
  mismatches = 0;
  for (int i = 0; i < expected_packed.size(); i++) begin
    if (expected_packed[i] !== t.packed_data[i]) begin
      `uvm_error(get_type_name(),
        $sformatf("Word[%0d] mismatch: expected=0x%08h actual=0x%08h",
                  i, expected_packed[i], t.packed_data[i]))
      mismatches++;
    end
  end

  if (mismatches == 0)
    `uvm_info(get_type_name(), "PASS: DUT output matches reference model", UVM_LOW)
  else begin
    `uvm_info(get_type_name(), $sformatf("Write Monitor Packet:\n%s", in_trn.sprint()), UVM_NONE)
    `uvm_info(get_type_name(), $sformatf("Read Monitor Packet:\n%s", t.sprint()), UVM_NONE)
  end
end



endfunction