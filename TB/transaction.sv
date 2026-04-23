`include "uvm_macros.svh"
import uvm_pkg :: *;


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
  rows      inside { 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60 };
  row_width inside { 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60 };
}
 
  // data[] must hold exactly rows*row_width pixels plus the dummy byte at [0]
  constraint data_size_c {
    soft data.size() == rows * row_width + 1;
  }
 
  // Pixel count must be a multiple of 4 for clean 32-bit packing
  constraint align_c {
    soft (rows * row_width) % 4 == 0;
  }
  
  
  function new(string name = "trn");
    super.new(name);
  endfunction
 
  // Build packed_data[] from the data[] array.
  // Called automatically by post_randomize, but can also be called
  // manually after a sequence overwrites data[] or kernel fields.
  function void build_packed_data();
    int num_words;
    num_words = (data.size() - 1) / 4;
    packed_data = new[num_words];
    for (int i = 0; i < num_words; i++) begin
      packed_data[i] = {data[i*4 + 4], data[i*4 + 3], data[i*4 + 2], data[i*4 + 1]};
    end
  endfunction
 
  function void post_randomize();
    build_packed_data();
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