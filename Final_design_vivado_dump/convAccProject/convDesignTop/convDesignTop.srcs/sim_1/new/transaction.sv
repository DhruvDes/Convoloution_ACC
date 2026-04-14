`include "uvm_macros.svh"
import uvm_pkg::*;

class trn extends uvm_sequence_item;
  rand logic [7:0] data[];
  logic [31:0] packed_data[];  // not rand, built in post_randomize
  rand logic [9:0] rows;
  rand logic [5:0] row_width;
  rand logic signed [8:0] k00;
  rand logic signed [8:0] k01;
  rand logic signed [8:0] k02;
  rand logic signed [8:0] k10;
  rand logic signed [8:0] k11;
  rand logic signed [8:0] k12;
  rand logic signed [8:0] k20;
  rand logic signed [8:0] k21;
  rand logic signed [8:0] k22;

  constraint dim_c {
    rows == 16;
    row_width == 16;
  }

  // Data size must be multiple of 4 for clean 32-bit packing
  constraint align_c {
    (rows * row_width) % 4 == 0;
  }

  function new(string name = "trn");
    super.new(name);
  endfunction

function void post_randomize();
  int num_words;
  data = new[rows * row_width + 1];
  data[0] = 0;
  // Temporary: set known pattern to verify packing
  for (int i = 1; i < data.size(); i++)
    data[i] = i[7:0];  // data[1]=01, data[2]=02, data[3]=03, etc.

  num_words = (data.size() - 1) / 4;
  packed_data = new[num_words];
  for (int i = 0; i < num_words; i++) begin
    packed_data[i] = {data[i*4 + 4], data[i*4 + 3], data[i*4 + 2], data[i*4 + 1]};
  end
endfunction

  `uvm_object_utils_begin(trn)
    `uvm_field_int(row_width, UVM_NONE)
    `uvm_field_int(rows, UVM_NONE)
    `uvm_field_int(k00, UVM_NONE)
    `uvm_field_int(k01, UVM_NONE)
    `uvm_field_int(k02, UVM_NONE)
    `uvm_field_int(k10, UVM_NONE)
    `uvm_field_int(k11, UVM_NONE)
    `uvm_field_int(k12, UVM_NONE)
    `uvm_field_int(k20, UVM_NONE)
    `uvm_field_int(k21, UVM_NONE)
    `uvm_field_int(k22, UVM_NONE)
    `uvm_field_array_int(data, UVM_NONE)
    `uvm_field_array_int(packed_data, UVM_NONE)
  `uvm_object_utils_end

endclass