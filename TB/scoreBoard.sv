`include "uvm_macros.svh"
import uvm_pkg::*;

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  int unsigned t_rows;
  int unsigned t_cols;

  covergroup matrix_size_cg;
    cp_size: coverpoint t_rows {
      bins b16 = {16};
      bins b20 = {20};
      bins b24 = {24};
      bins b28 = {28};
      bins b32 = {32};
      bins b36 = {36};
      bins b40 = {40};
      bins b44 = {44};
      bins b48 = {48};
      bins b52 = {52};
      bins b56 = {56};
      bins b60 = {60};
    }
  endgroup : matrix_size_cg

  uvm_analysis_imp_wmon #(trn, scoreboard) wmon_imp;
  uvm_analysis_imp_rmon #(trn, scoreboard) rmon_imp;

  uvm_event txn_verified_e;

  trn write_q[$];
  trn read_q[$];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    matrix_size_cg = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wmon_imp       = new("wmon_imp", this);
    rmon_imp       = new("rmon_imp", this);
    txn_verified_e = uvm_event_pool::get_global("txn_verified");
  endfunction

  // Called by writeMon's analysis port
  function void write_wmon(trn t);
    if (read_q.size() > 0) begin
      `uvm_warning(get_type_name(), "Write arrived after read - checking now")
      check_transaction(t, read_q.pop_front());
    end else begin
      write_q.push_back(t);
    end
  endfunction

  // Called by readMon's analysis port
  extern function void check_transaction(trn in_trn, trn out_trn);
  function void write_rmon(trn t);
    if (write_q.size() == 0) begin
      `uvm_error(get_type_name(),
                 "write_rmon fired but write_q is empty - read side beat write side to scoreboard")
      read_q.push_back(t);
    end else begin
      check_transaction(write_q.pop_front(), t);
    end
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if (write_q.size() != 0)
      `uvm_error(get_type_name(),
                 $sformatf("%0d unmatched write transactions left in queue",
                           write_q.size()))
    if (read_q.size() != 0)
      `uvm_error(get_type_name(),
                 $sformatf("%0d unmatched read transactions left in queue",
                           read_q.size()))
    `uvm_info(get_type_name(),
              $sformatf("MATRIX SIZE COVERAGE: %.2f%% (%0d / 12 sizes hit)",
                        matrix_size_cg.get_coverage(),
                        $rtoi(matrix_size_cg.get_coverage() * 0.12)),
              UVM_NONE)
  endfunction

endclass


// Shared comparison function - all existing logic from write_rmon moved here unchanged
function void scoreboard::check_transaction(trn in_trn, trn out_trn);
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

  // Rebuild the 2D matrix from the flat data array
  matrix = new[in_trn.rows];
  for (int r = 0; r < in_trn.rows; r++) begin
    matrix[r] = new[in_trn.row_width];
    for (int c = 0; c < in_trn.row_width; c++) begin
      matrix[r][c] = in_trn.data[r*in_trn.row_width+c+1];
    end
  end

  fk[0][0] = in_trn.k22; fk[0][1] = in_trn.k21; fk[0][2] = in_trn.k20;
  fk[1][0] = in_trn.k12; fk[1][1] = in_trn.k11; fk[1][2] = in_trn.k10;
  fk[2][0] = in_trn.k02; fk[2][1] = in_trn.k01; fk[2][2] = in_trn.k00;

  out_rows     = in_trn.rows - 2;
  out_cols     = in_trn.row_width - 2;
  total_pixels = out_rows * out_cols;
  num_words    = (total_pixels + 3) / 4;

  flat_pixels = new[total_pixels];
  for (int r = 0; r < out_rows; r++) begin
    for (int c = 0; c < out_cols; c++) begin
      sum = 0;
      for (int ki = 0; ki < 3; ki++)
        for (int kj = 0; kj < 3; kj++)
          sum += fk[ki][kj] * $signed({1'b0, matrix[r+ki][c+kj]});

      if      (sum < 0)   clamped = 8'd0;
      else if (sum > 255) clamped = 8'd255;
      else                clamped = sum[7:0];

      flat_pixels[r*out_cols+c] = clamped;
    end
  end

  expected_packed = new[num_words];
  for (int i = 0; i < num_words; i++) begin
    b0 = (i*4+0 < total_pixels) ? flat_pixels[i*4+0] : 8'h00;
    b1 = (i*4+1 < total_pixels) ? flat_pixels[i*4+1] : 8'h00;
    b2 = (i*4+2 < total_pixels) ? flat_pixels[i*4+2] : 8'h00;
    b3 = (i*4+3 < total_pixels) ? flat_pixels[i*4+3] : 8'h00;
    expected_packed[i] = {b3, b2, b1, b0};
  end

  if (expected_packed.size() != out_trn.packed_data.size()) begin
    `uvm_error(get_type_name(),
               $sformatf("Size mismatch: expected %0d words, got %0d",
                         expected_packed.size(), out_trn.packed_data.size()))
  end else begin
    mismatches = 0;
    for (int i = 0; i < expected_packed.size(); i++) begin
      if (expected_packed[i] !== out_trn.packed_data[i]) begin
        `uvm_error(get_type_name(),
                   $sformatf("Word[%0d] mismatch: expected=0x%08h actual=0x%08h",
                             i, expected_packed[i], out_trn.packed_data[i]))
        mismatches++;
      end
    end

    if (mismatches == 0) begin
      `uvm_info(get_type_name(), "PASS: DUT output matches reference model", UVM_LOW)
      t_rows = int'(in_trn.rows);
      t_cols = int'(in_trn.row_width);
      txn_verified_e.trigger();
      matrix_size_cg.sample();
    end else begin
      `uvm_info(get_type_name(),
                $sformatf("Write Monitor Packet:\n%s", in_trn.sprint()),  UVM_NONE)
      `uvm_info(get_type_name(),
                $sformatf("Read Monitor Packet:\n%s",  out_trn.sprint()), UVM_NONE)
    end
  end

endfunction