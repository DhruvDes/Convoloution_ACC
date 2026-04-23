`include "uvm_macros.svh"
import uvm_pkg :: *;


class test extends uvm_test;
  `uvm_component_utils(test)

  env envt;
    int unsigned   iter = 0;
    int unsigned   max_iters = 500;
    real           cov;
    bit            hit_20, hit_40, hit_60, hit_80, hit_90;

  function new(string name = "test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    envt = env ::type_id :: create("envt", this);
  endfunction

  task run_phase(uvm_phase phase);
        debug_16x16 dbg16x16;
        rand_16x16 rnd16x16;
        rand_28x28 rnd28x28;
        random_testing rndtst;
        phase.raise_objection(this);
    
        
        dbg16x16  = debug_16x16 ::type_id::create("dbg16x16");
        rnd16x16  = rand_16x16 ::type_id::create("rnd16x16");
        rnd28x28  = rand_28x28 ::type_id::create("rnd28x28");
        rndtst    = random_testing :: type_id :: create("rndtst");  

//              dbg16x16.start(envt.wagent.seqr);
//              rnd16x16.start(envt.wagent.seqr);
//              rnd28x28.start(envt.wagent.seqr);
//            repeat(3)rndtst.start(envt.wagent.seqr);
       
        while (envt.scbd.matrix_size_cg.get_coverage() < 100.0 && iter < max_iters) begin
            rndtst = random_testing::type_id::create($sformatf("rndtst_%0d", iter));
            rndtst.start(envt.wagent.seqr);
            iter++;
        
            cov = envt.scbd.matrix_size_cg.get_coverage();
            if (!hit_20 && cov >= 20) begin hit_20 = 1; `uvm_info(get_type_name(), $sformatf("Coverage >= 20%%: %.2f%% after %0d txns", cov, iter), UVM_NONE) end
            if (!hit_40 && cov >= 40) begin hit_40 = 1; `uvm_info(get_type_name(), $sformatf("Coverage >= 40%%: %.2f%% after %0d txns", cov, iter), UVM_NONE) end
            if (!hit_60 && cov >= 60) begin hit_60 = 1; `uvm_info(get_type_name(), $sformatf("Coverage >= 60%%: %.2f%% after %0d txns", cov, iter), UVM_NONE) end
            if (!hit_80 && cov >= 80) begin hit_80 = 1; `uvm_info(get_type_name(), $sformatf("Coverage >= 80%%: %.2f%% after %0d txns", cov, iter), UVM_NONE) end
            if (!hit_90 && cov >= 90) begin hit_90 = 1; `uvm_info(get_type_name(), $sformatf("Coverage >= 90%%: %.2f%% after %0d txns", cov, iter), UVM_NONE) end
          end
        
          `uvm_info(get_type_name(),
                    $sformatf("Final coverage: %.2f%% after %0d transactions",
                              envt.scbd.matrix_size_cg.get_coverage(), iter),
                    UVM_NONE)
        

        
  

        phase.drop_objection(this);
  endtask

endclass