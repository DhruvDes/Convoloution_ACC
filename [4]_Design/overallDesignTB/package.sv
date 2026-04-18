`include "uvm_macros.svh"
 
package tb_pkg;
  import uvm_pkg::*;
 
  // Analysis port imp declarations (must come before scoreboard)
  `uvm_analysis_imp_decl(_wmon)
  `uvm_analysis_imp_decl(_rmon)
 
  // 1. Transaction
  `include "transaction.sv"
 
  // 2. Sequences
  `include "sequenceLib.sv"
 
  // 3. Scoreboard
  `include "scoreBoard.sv"
 
  // 4. Drivers
  `include "writeDriver.sv"
  `include "readDriver.sv"
 
  // 5. Monitors
  `include "writeMonitor.sv"
  `include "readMonitor.sv"
 
  // 6. Agents
  `include "writeAgent.sv"
  `include "readAgent.sv"
 
  // 7. Environment
  `include "env.sv"
 
  // 8. Test
  `include "test.sv"
 
endpackage
 