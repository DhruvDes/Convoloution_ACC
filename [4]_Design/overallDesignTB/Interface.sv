interface design_if (input axis_aclk);
  logic        axis_aresetn;

  logic        s00_axis_tready;
  logic [31:0] s00_axis_tdata;
  logic        s00_axis_tlast;
  logic        s00_axis_tvalid;

  logic        m00_axis_tvalid;
  logic [31:0] m00_axis_tdata;
  logic        m00_axis_tlast;
  logic        m00_axis_tready;

  // Write driver: drives data INTO the slave interface
  clocking wdrvcb @(posedge axis_aclk);
    default input #1 output #1;
    output s00_axis_tdata;
    output s00_axis_tlast;
    output s00_axis_tvalid;
    output axis_aresetn;
    input  s00_axis_tready;
  endclocking

  // Write monitor: observes the slave interface
  clocking wmoncb @(posedge axis_aclk);
    default input #1 output #1;
    input s00_axis_tdata;
    input s00_axis_tlast;
    input s00_axis_tvalid;
    input s00_axis_tready;
  endclocking

  // Read driver: drives tready to accept data from master
  clocking rdrvcb @(posedge axis_aclk);
    default input #1 output #1;
    output m00_axis_tready;
    input  m00_axis_tvalid;
    input  m00_axis_tdata;
    input  m00_axis_tlast;
  endclocking

  // Read monitor: observes the master interface
  clocking rmoncb @(posedge axis_aclk);
    default input #1 output #1;
    input m00_axis_tvalid;
    input m00_axis_tdata;
    input m00_axis_tlast;
    input m00_axis_tready;
  endclocking
  
    modport wdrv_mp (clocking wdrvcb);
    modport wmon_mp (clocking wmoncb);
    modport rdrv_mp (clocking rdrvcb);
    modport rmon_mp (clocking rmoncb);

endinterface