// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Sat Apr 11 14:43:59 2026
// Host        : DESKTOP-8NFLPRC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               d:/Myproj/GitHub/convAccProject/LoopBackFIFO/LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ip/loopBackFifoBD_lpbk_tst_0_0/loopBackFifoBD_lpbk_tst_0_0_sim_netlist.v
// Design      : loopBackFifoBD_lpbk_tst_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "loopBackFifoBD_lpbk_tst_0_0,lpbk_tst,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "package_project" *) 
(* X_CORE_INFO = "lpbk_tst,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module loopBackFifoBD_lpbk_tst_0_0
   (s01_axis_aclk,
    s01_axis_aresetn,
    s01_axis_tready,
    s01_axis_tdata,
    s01_axis_tstrb,
    s01_axis_tlast,
    s01_axis_tvalid,
    m00_axis_aclk,
    m00_axis_aresetn,
    m00_axis_tvalid,
    m00_axis_tdata,
    m00_axis_tstrb,
    m00_axis_tlast,
    m00_axis_tready);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s01_axis_aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s01_axis_aclk, ASSOCIATED_BUSIF s01_axis, ASSOCIATED_RESET s01_axis_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN loopBackFifoBD_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input s01_axis_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s01_axis_aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s01_axis_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s01_axis_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s01_axis TREADY" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s01_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN loopBackFifoBD_processing_system7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0" *) output s01_axis_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s01_axis TDATA" *) input [31:0]s01_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s01_axis TSTRB" *) input [3:0]s01_axis_tstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s01_axis TLAST" *) input s01_axis_tlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s01_axis TVALID" *) input s01_axis_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 m00_axis_aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m00_axis_aclk, ASSOCIATED_BUSIF m00_axis, ASSOCIATED_RESET m00_axis_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN loopBackFifoBD_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input m00_axis_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 m00_axis_aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m00_axis_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input m00_axis_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m00_axis TVALID" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m00_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN loopBackFifoBD_processing_system7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0" *) output m00_axis_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m00_axis TDATA" *) output [31:0]m00_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m00_axis TSTRB" *) output [3:0]m00_axis_tstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m00_axis TLAST" *) output m00_axis_tlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m00_axis TREADY" *) input m00_axis_tready;

  wire \<const1> ;
  wire [31:0]m00_axis_tdata;
  wire m00_axis_tlast;
  wire m00_axis_tready;
  wire m00_axis_tvalid;
  wire s01_axis_aclk;
  wire s01_axis_aresetn;
  wire [31:0]s01_axis_tdata;
  wire s01_axis_tlast;
  wire s01_axis_tready;
  wire s01_axis_tvalid;

  assign m00_axis_tstrb[3] = \<const1> ;
  assign m00_axis_tstrb[2] = \<const1> ;
  assign m00_axis_tstrb[1] = \<const1> ;
  assign m00_axis_tstrb[0] = \<const1> ;
  VCC VCC
       (.P(\<const1> ));
  loopBackFifoBD_lpbk_tst_0_0_lpbk_tst inst
       (.WEBWE(s01_axis_tready),
        .m00_axis_tdata(m00_axis_tdata),
        .m00_axis_tlast(m00_axis_tlast),
        .m00_axis_tready(m00_axis_tready),
        .s01_axis_aclk(s01_axis_aclk),
        .s01_axis_aresetn(s01_axis_aresetn),
        .s01_axis_tdata(s01_axis_tdata),
        .s01_axis_tlast(s01_axis_tlast),
        .s01_axis_tvalid(s01_axis_tvalid),
        .skid_valid_reg(m00_axis_tvalid));
endmodule

(* ORIG_REF_NAME = "axis_fifo_m" *) 
module loopBackFifoBD_lpbk_tst_0_0_axis_fifo_m
   (m00_axis_tdata,
    s01_axis_aresetn_0,
    skid_valid_reg_0,
    \FSM_onehot_br_state_reg[2] ,
    rd_ptr0,
    \FSM_onehot_br_state_reg[0] ,
    s01_axis_aresetn_1,
    m00_axis_tlast,
    s01_axis_aclk,
    mem_reg_0,
    rd_data,
    m00_axis_tready,
    s01_axis_aresetn,
    br_data,
    \FSM_onehot_br_state_reg[1] ,
    br_last,
    CO);
  output [31:0]m00_axis_tdata;
  output s01_axis_aresetn_0;
  output skid_valid_reg_0;
  output \FSM_onehot_br_state_reg[2] ;
  output rd_ptr0;
  output \FSM_onehot_br_state_reg[0] ;
  output s01_axis_aresetn_1;
  output m00_axis_tlast;
  input s01_axis_aclk;
  input mem_reg_0;
  input [31:0]rd_data;
  input m00_axis_tready;
  input s01_axis_aresetn;
  input [0:0]br_data;
  input \FSM_onehot_br_state_reg[1] ;
  input br_last;
  input [0:0]CO;

  wire [0:0]CO;
  wire \FSM_onehot_br_state_reg[0] ;
  wire \FSM_onehot_br_state_reg[1] ;
  wire \FSM_onehot_br_state_reg[2] ;
  wire [0:0]br_data;
  wire br_last;
  wire empty;
  wire empty_carry_i_1_n_0;
  wire empty_carry_i_2_n_0;
  wire empty_carry_i_3_n_0;
  wire empty_carry_i_4_n_0;
  wire empty_carry_n_1;
  wire empty_carry_n_2;
  wire empty_carry_n_3;
  wire full0;
  wire last_pix_in_row__1;
  wire last_pix_in_row_carry_i_1_n_0;
  wire last_pix_in_row_carry_i_2_n_0;
  wire last_pix_in_row_carry_n_3;
  wire last_row__3;
  wire last_row_carry_i_1_n_0;
  wire last_row_carry_i_2_n_0;
  wire last_row_carry_i_3_n_0;
  wire last_row_carry_i_4_n_0;
  wire last_row_carry_n_1;
  wire last_row_carry_n_2;
  wire last_row_carry_n_3;
  wire [31:0]m00_axis_tdata;
  wire m00_axis_tlast;
  wire m00_axis_tready;
  wire mem_reg_0;
  wire mem_reg_i_1__0_n_0;
  wire mem_reg_i_4_n_2;
  wire mem_reg_i_4_n_3;
  wire mem_reg_i_5_n_0;
  wire mem_reg_i_6_n_0;
  wire mem_reg_i_7_n_0;
  wire [9:9]p_0_in__0;
  wire [9:0]p_0_in__1;
  wire [5:0]p_0_in__2;
  wire [9:0]p_0_in__3;
  wire p_3_in;
  wire \pix_cnt[5]_i_1_n_0 ;
  wire [5:0]pix_cnt_reg;
  wire [31:0]rd_data;
  wire rd_en;
  wire rd_ptr0;
  wire \rd_ptr[0]_i_1_n_0 ;
  wire \rd_ptr[1]_i_1__0_n_0 ;
  wire \rd_ptr[2]_i_1__0_n_0 ;
  wire \rd_ptr[3]_i_1__0_n_0 ;
  wire \rd_ptr[4]_i_1__0_n_0 ;
  wire \rd_ptr[5]_i_1__0_n_0 ;
  wire \rd_ptr[6]_i_1__0_n_0 ;
  wire \rd_ptr[7]_i_1__0_n_0 ;
  wire \rd_ptr[8]_i_1__0_n_0 ;
  wire \rd_ptr[9]_i_2__0_n_0 ;
  wire [9:9]rd_ptr_reg;
  wire [8:0]rd_ptr_reg_rep;
  wire \row_cnt[9]_i_1_n_0 ;
  wire \row_cnt[9]_i_4_n_0 ;
  wire [9:0]row_cnt_reg;
  wire s01_axis_aclk;
  wire s01_axis_aresetn;
  wire s01_axis_aresetn_0;
  wire s01_axis_aresetn_1;
  wire skid_last0;
  wire skid_valid_i_1_n_0;
  wire skid_valid_reg_0;
  wire tlast_mem_reg_0_127_0_0_i_2_n_0;
  wire tlast_mem_reg_0_127_0_0_n_0;
  wire tlast_mem_reg_0_127_0_0_n_1;
  wire tlast_mem_reg_128_255_0_0_i_1_n_0;
  wire tlast_mem_reg_128_255_0_0_n_0;
  wire tlast_mem_reg_128_255_0_0_n_1;
  wire tlast_mem_reg_256_383_0_0_i_1_n_0;
  wire tlast_mem_reg_256_383_0_0_n_0;
  wire tlast_mem_reg_256_383_0_0_n_1;
  wire tlast_mem_reg_384_511_0_0_i_1_n_0;
  wire tlast_mem_reg_384_511_0_0_n_0;
  wire tlast_mem_reg_384_511_0_0_n_1;
  wire tlast_stored;
  wire wr_accepted;
  wire wr_accepted0;
  wire \wr_ptr[9]_i_3__0_n_0 ;
  wire \wr_ptr_reg_n_0_[0] ;
  wire \wr_ptr_reg_n_0_[1] ;
  wire \wr_ptr_reg_n_0_[2] ;
  wire \wr_ptr_reg_n_0_[3] ;
  wire \wr_ptr_reg_n_0_[4] ;
  wire \wr_ptr_reg_n_0_[5] ;
  wire \wr_ptr_reg_n_0_[6] ;
  wire \wr_ptr_reg_n_0_[7] ;
  wire \wr_ptr_reg_n_0_[8] ;
  wire \wr_ptr_reg_n_0_[9] ;
  wire [3:0]NLW_empty_carry_O_UNCONNECTED;
  wire [3:2]NLW_last_pix_in_row_carry_CO_UNCONNECTED;
  wire [3:0]NLW_last_pix_in_row_carry_O_UNCONNECTED;
  wire [3:0]NLW_last_row_carry_O_UNCONNECTED;
  wire [1:0]NLW_mem_reg_DOPADOP_UNCONNECTED;
  wire [1:0]NLW_mem_reg_DOPBDOP_UNCONNECTED;
  wire [3:3]NLW_mem_reg_i_4_CO_UNCONNECTED;
  wire [3:0]NLW_mem_reg_i_4_O_UNCONNECTED;

  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'hF0F2FFFF)) 
    \FSM_onehot_br_state[0]_i_1 
       (.I0(\FSM_onehot_br_state_reg[1] ),
        .I1(rd_ptr0),
        .I2(mem_reg_0),
        .I3(br_data),
        .I4(s01_axis_aresetn),
        .O(\FSM_onehot_br_state_reg[0] ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'hFE000000)) 
    \FSM_onehot_br_state[1]_i_1 
       (.I0(rd_ptr0),
        .I1(mem_reg_0),
        .I2(br_data),
        .I3(\FSM_onehot_br_state_reg[1] ),
        .I4(s01_axis_aresetn),
        .O(\FSM_onehot_br_state_reg[2] ));
  CARRY4 empty_carry
       (.CI(1'b0),
        .CO({empty,empty_carry_n_1,empty_carry_n_2,empty_carry_n_3}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_empty_carry_O_UNCONNECTED[3:0]),
        .S({empty_carry_i_1_n_0,empty_carry_i_2_n_0,empty_carry_i_3_n_0,empty_carry_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    empty_carry_i_1
       (.I0(rd_ptr_reg),
        .I1(\wr_ptr_reg_n_0_[9] ),
        .O(empty_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    empty_carry_i_2
       (.I0(\wr_ptr_reg_n_0_[7] ),
        .I1(rd_ptr_reg_rep[7]),
        .I2(\wr_ptr_reg_n_0_[6] ),
        .I3(rd_ptr_reg_rep[6]),
        .I4(rd_ptr_reg_rep[8]),
        .I5(\wr_ptr_reg_n_0_[8] ),
        .O(empty_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    empty_carry_i_3
       (.I0(\wr_ptr_reg_n_0_[4] ),
        .I1(rd_ptr_reg_rep[4]),
        .I2(\wr_ptr_reg_n_0_[3] ),
        .I3(rd_ptr_reg_rep[3]),
        .I4(rd_ptr_reg_rep[5]),
        .I5(\wr_ptr_reg_n_0_[5] ),
        .O(empty_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    empty_carry_i_4
       (.I0(\wr_ptr_reg_n_0_[1] ),
        .I1(rd_ptr_reg_rep[1]),
        .I2(\wr_ptr_reg_n_0_[0] ),
        .I3(rd_ptr_reg_rep[0]),
        .I4(rd_ptr_reg_rep[2]),
        .I5(\wr_ptr_reg_n_0_[2] ),
        .O(empty_carry_i_4_n_0));
  CARRY4 last_pix_in_row_carry
       (.CI(1'b0),
        .CO({NLW_last_pix_in_row_carry_CO_UNCONNECTED[3:2],last_pix_in_row__1,last_pix_in_row_carry_n_3}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_last_pix_in_row_carry_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,last_pix_in_row_carry_i_1_n_0,last_pix_in_row_carry_i_2_n_0}));
  LUT3 #(
    .INIT(8'h10)) 
    last_pix_in_row_carry_i_1
       (.I0(pix_cnt_reg[5]),
        .I1(pix_cnt_reg[4]),
        .I2(pix_cnt_reg[3]),
        .O(last_pix_in_row_carry_i_1_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    last_pix_in_row_carry_i_2
       (.I0(pix_cnt_reg[2]),
        .I1(pix_cnt_reg[1]),
        .I2(pix_cnt_reg[0]),
        .O(last_pix_in_row_carry_i_2_n_0));
  CARRY4 last_row_carry
       (.CI(1'b0),
        .CO({last_row__3,last_row_carry_n_1,last_row_carry_n_2,last_row_carry_n_3}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_last_row_carry_O_UNCONNECTED[3:0]),
        .S({last_row_carry_i_1_n_0,last_row_carry_i_2_n_0,last_row_carry_i_3_n_0,last_row_carry_i_4_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    last_row_carry_i_1
       (.I0(row_cnt_reg[9]),
        .O(last_row_carry_i_1_n_0));
  LUT3 #(
    .INIT(8'h01)) 
    last_row_carry_i_2
       (.I0(row_cnt_reg[8]),
        .I1(row_cnt_reg[7]),
        .I2(row_cnt_reg[6]),
        .O(last_row_carry_i_2_n_0));
  LUT3 #(
    .INIT(8'h01)) 
    last_row_carry_i_3
       (.I0(row_cnt_reg[5]),
        .I1(row_cnt_reg[4]),
        .I2(row_cnt_reg[3]),
        .O(last_row_carry_i_3_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    last_row_carry_i_4
       (.I0(row_cnt_reg[2]),
        .I1(row_cnt_reg[1]),
        .I2(row_cnt_reg[0]),
        .O(last_row_carry_i_4_n_0));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d32" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d32" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "16384" *) 
  (* RTL_RAM_NAME = "loopBackFifoBD_lpbk_tst_0_0/inst/u_out_fifo/mem_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "511" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "31" *) 
  RAMB18E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .INIT_A(18'h00000),
    .INIT_B(18'h00000),
    .RAM_MODE("SDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(36),
    .READ_WIDTH_B(0),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(18'h00000),
    .SRVAL_B(18'h00000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("READ_FIRST"),
    .WRITE_WIDTH_A(0),
    .WRITE_WIDTH_B(36)) 
    mem_reg
       (.ADDRARDADDR({rd_ptr_reg_rep,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({\wr_ptr_reg_n_0_[8] ,\wr_ptr_reg_n_0_[7] ,\wr_ptr_reg_n_0_[6] ,\wr_ptr_reg_n_0_[5] ,\wr_ptr_reg_n_0_[4] ,\wr_ptr_reg_n_0_[3] ,\wr_ptr_reg_n_0_[2] ,\wr_ptr_reg_n_0_[1] ,\wr_ptr_reg_n_0_[0] ,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CLKARDCLK(s01_axis_aclk),
        .CLKBWRCLK(s01_axis_aclk),
        .DIADI(rd_data[15:0]),
        .DIBDI(rd_data[31:16]),
        .DIPADIP({1'b1,1'b1}),
        .DIPBDIP({1'b1,1'b1}),
        .DOADO(m00_axis_tdata[15:0]),
        .DOBDO(m00_axis_tdata[31:16]),
        .DOPADOP(NLW_mem_reg_DOPADOP_UNCONNECTED[1:0]),
        .DOPBDOP(NLW_mem_reg_DOPBDOP_UNCONNECTED[1:0]),
        .ENARDEN(mem_reg_i_1__0_n_0),
        .ENBWREN(mem_reg_0),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(s01_axis_aresetn_0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .WEA({1'b0,1'b0}),
        .WEBWE({wr_accepted0,wr_accepted0,wr_accepted0,wr_accepted0}));
  LUT6 #(
    .INIT(64'h0000000082AA0000)) 
    mem_reg_i_1
       (.I0(s01_axis_aresetn),
        .I1(\wr_ptr_reg_n_0_[9] ),
        .I2(rd_ptr_reg),
        .I3(full0),
        .I4(\FSM_onehot_br_state_reg[1] ),
        .I5(CO),
        .O(s01_axis_aresetn_1));
  LUT4 #(
    .INIT(16'h23FF)) 
    mem_reg_i_1__0
       (.I0(m00_axis_tready),
        .I1(empty),
        .I2(skid_valid_reg_0),
        .I3(s01_axis_aresetn),
        .O(mem_reg_i_1__0_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    mem_reg_i_2
       (.I0(s01_axis_aresetn),
        .O(s01_axis_aresetn_0));
  LUT3 #(
    .INIT(8'hD7)) 
    mem_reg_i_3
       (.I0(full0),
        .I1(rd_ptr_reg),
        .I2(\wr_ptr_reg_n_0_[9] ),
        .O(wr_accepted0));
  CARRY4 mem_reg_i_4
       (.CI(1'b0),
        .CO({NLW_mem_reg_i_4_CO_UNCONNECTED[3],full0,mem_reg_i_4_n_2,mem_reg_i_4_n_3}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_mem_reg_i_4_O_UNCONNECTED[3:0]),
        .S({1'b0,mem_reg_i_5_n_0,mem_reg_i_6_n_0,mem_reg_i_7_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    mem_reg_i_5
       (.I0(\wr_ptr_reg_n_0_[7] ),
        .I1(rd_ptr_reg_rep[7]),
        .I2(\wr_ptr_reg_n_0_[6] ),
        .I3(rd_ptr_reg_rep[6]),
        .I4(rd_ptr_reg_rep[8]),
        .I5(\wr_ptr_reg_n_0_[8] ),
        .O(mem_reg_i_5_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    mem_reg_i_6
       (.I0(\wr_ptr_reg_n_0_[4] ),
        .I1(rd_ptr_reg_rep[4]),
        .I2(\wr_ptr_reg_n_0_[3] ),
        .I3(rd_ptr_reg_rep[3]),
        .I4(rd_ptr_reg_rep[5]),
        .I5(\wr_ptr_reg_n_0_[5] ),
        .O(mem_reg_i_6_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    mem_reg_i_7
       (.I0(\wr_ptr_reg_n_0_[1] ),
        .I1(rd_ptr_reg_rep[1]),
        .I2(\wr_ptr_reg_n_0_[0] ),
        .I3(rd_ptr_reg_rep[0]),
        .I4(rd_ptr_reg_rep[2]),
        .I5(\wr_ptr_reg_n_0_[2] ),
        .O(mem_reg_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    \pix_cnt[0]_i_1 
       (.I0(pix_cnt_reg[0]),
        .O(p_0_in__2[0]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \pix_cnt[1]_i_1 
       (.I0(pix_cnt_reg[0]),
        .I1(pix_cnt_reg[1]),
        .O(p_0_in__2[1]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \pix_cnt[2]_i_1 
       (.I0(pix_cnt_reg[0]),
        .I1(pix_cnt_reg[1]),
        .I2(pix_cnt_reg[2]),
        .O(p_0_in__2[2]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \pix_cnt[3]_i_1 
       (.I0(pix_cnt_reg[1]),
        .I1(pix_cnt_reg[0]),
        .I2(pix_cnt_reg[2]),
        .I3(pix_cnt_reg[3]),
        .O(p_0_in__2[3]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \pix_cnt[4]_i_1 
       (.I0(pix_cnt_reg[2]),
        .I1(pix_cnt_reg[0]),
        .I2(pix_cnt_reg[1]),
        .I3(pix_cnt_reg[3]),
        .I4(pix_cnt_reg[4]),
        .O(p_0_in__2[4]));
  LUT6 #(
    .INIT(64'h9F000000FFFFFFFF)) 
    \pix_cnt[5]_i_1 
       (.I0(\wr_ptr_reg_n_0_[9] ),
        .I1(rd_ptr_reg),
        .I2(full0),
        .I3(last_pix_in_row__1),
        .I4(mem_reg_0),
        .I5(s01_axis_aresetn),
        .O(\pix_cnt[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \pix_cnt[5]_i_2 
       (.I0(pix_cnt_reg[3]),
        .I1(pix_cnt_reg[1]),
        .I2(pix_cnt_reg[0]),
        .I3(pix_cnt_reg[2]),
        .I4(pix_cnt_reg[4]),
        .I5(pix_cnt_reg[5]),
        .O(p_0_in__2[5]));
  FDRE \pix_cnt_reg[0] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__2[0]),
        .Q(pix_cnt_reg[0]),
        .R(\pix_cnt[5]_i_1_n_0 ));
  FDRE \pix_cnt_reg[1] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__2[1]),
        .Q(pix_cnt_reg[1]),
        .R(\pix_cnt[5]_i_1_n_0 ));
  FDRE \pix_cnt_reg[2] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__2[2]),
        .Q(pix_cnt_reg[2]),
        .R(\pix_cnt[5]_i_1_n_0 ));
  FDRE \pix_cnt_reg[3] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__2[3]),
        .Q(pix_cnt_reg[3]),
        .R(\pix_cnt[5]_i_1_n_0 ));
  FDRE \pix_cnt_reg[4] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__2[4]),
        .Q(pix_cnt_reg[4]),
        .R(\pix_cnt[5]_i_1_n_0 ));
  FDRE \pix_cnt_reg[5] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__2[5]),
        .Q(pix_cnt_reg[5]),
        .R(\pix_cnt[5]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \rd_ptr[0]_i_1 
       (.I0(rd_ptr_reg_rep[0]),
        .O(\rd_ptr[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_ptr[1]_i_1__0 
       (.I0(rd_ptr_reg_rep[0]),
        .I1(rd_ptr_reg_rep[1]),
        .O(\rd_ptr[1]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \rd_ptr[2]_i_1__0 
       (.I0(rd_ptr_reg_rep[0]),
        .I1(rd_ptr_reg_rep[1]),
        .I2(rd_ptr_reg_rep[2]),
        .O(\rd_ptr[2]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \rd_ptr[3]_i_1__0 
       (.I0(rd_ptr_reg_rep[1]),
        .I1(rd_ptr_reg_rep[0]),
        .I2(rd_ptr_reg_rep[2]),
        .I3(rd_ptr_reg_rep[3]),
        .O(\rd_ptr[3]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \rd_ptr[4]_i_1__0 
       (.I0(rd_ptr_reg_rep[2]),
        .I1(rd_ptr_reg_rep[0]),
        .I2(rd_ptr_reg_rep[1]),
        .I3(rd_ptr_reg_rep[3]),
        .I4(rd_ptr_reg_rep[4]),
        .O(\rd_ptr[4]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \rd_ptr[5]_i_1__0 
       (.I0(rd_ptr_reg_rep[3]),
        .I1(rd_ptr_reg_rep[1]),
        .I2(rd_ptr_reg_rep[0]),
        .I3(rd_ptr_reg_rep[2]),
        .I4(rd_ptr_reg_rep[4]),
        .I5(rd_ptr_reg_rep[5]),
        .O(\rd_ptr[5]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_ptr[6]_i_1__0 
       (.I0(\rd_ptr[9]_i_2__0_n_0 ),
        .I1(rd_ptr_reg_rep[6]),
        .O(\rd_ptr[6]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \rd_ptr[7]_i_1__0 
       (.I0(\rd_ptr[9]_i_2__0_n_0 ),
        .I1(rd_ptr_reg_rep[6]),
        .I2(rd_ptr_reg_rep[7]),
        .O(\rd_ptr[7]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \rd_ptr[8]_i_1__0 
       (.I0(rd_ptr_reg_rep[6]),
        .I1(\rd_ptr[9]_i_2__0_n_0 ),
        .I2(rd_ptr_reg_rep[7]),
        .I3(rd_ptr_reg_rep[8]),
        .O(\rd_ptr[8]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \rd_ptr[9]_i_1 
       (.I0(rd_ptr_reg_rep[7]),
        .I1(\rd_ptr[9]_i_2__0_n_0 ),
        .I2(rd_ptr_reg_rep[6]),
        .I3(rd_ptr_reg_rep[8]),
        .I4(rd_ptr_reg),
        .O(p_0_in__0));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \rd_ptr[9]_i_2__0 
       (.I0(rd_ptr_reg_rep[5]),
        .I1(rd_ptr_reg_rep[3]),
        .I2(rd_ptr_reg_rep[1]),
        .I3(rd_ptr_reg_rep[0]),
        .I4(rd_ptr_reg_rep[2]),
        .I5(rd_ptr_reg_rep[4]),
        .O(\rd_ptr[9]_i_2__0_n_0 ));
  FDRE \rd_ptr_reg[0] 
       (.C(s01_axis_aclk),
        .CE(rd_en),
        .D(\rd_ptr[0]_i_1_n_0 ),
        .Q(rd_ptr_reg_rep[0]),
        .R(s01_axis_aresetn_0));
  FDRE \rd_ptr_reg[1] 
       (.C(s01_axis_aclk),
        .CE(rd_en),
        .D(\rd_ptr[1]_i_1__0_n_0 ),
        .Q(rd_ptr_reg_rep[1]),
        .R(s01_axis_aresetn_0));
  FDRE \rd_ptr_reg[2] 
       (.C(s01_axis_aclk),
        .CE(rd_en),
        .D(\rd_ptr[2]_i_1__0_n_0 ),
        .Q(rd_ptr_reg_rep[2]),
        .R(s01_axis_aresetn_0));
  FDRE \rd_ptr_reg[3] 
       (.C(s01_axis_aclk),
        .CE(rd_en),
        .D(\rd_ptr[3]_i_1__0_n_0 ),
        .Q(rd_ptr_reg_rep[3]),
        .R(s01_axis_aresetn_0));
  FDRE \rd_ptr_reg[4] 
       (.C(s01_axis_aclk),
        .CE(rd_en),
        .D(\rd_ptr[4]_i_1__0_n_0 ),
        .Q(rd_ptr_reg_rep[4]),
        .R(s01_axis_aresetn_0));
  FDRE \rd_ptr_reg[5] 
       (.C(s01_axis_aclk),
        .CE(rd_en),
        .D(\rd_ptr[5]_i_1__0_n_0 ),
        .Q(rd_ptr_reg_rep[5]),
        .R(s01_axis_aresetn_0));
  FDRE \rd_ptr_reg[6] 
       (.C(s01_axis_aclk),
        .CE(rd_en),
        .D(\rd_ptr[6]_i_1__0_n_0 ),
        .Q(rd_ptr_reg_rep[6]),
        .R(s01_axis_aresetn_0));
  FDRE \rd_ptr_reg[7] 
       (.C(s01_axis_aclk),
        .CE(rd_en),
        .D(\rd_ptr[7]_i_1__0_n_0 ),
        .Q(rd_ptr_reg_rep[7]),
        .R(s01_axis_aresetn_0));
  FDRE \rd_ptr_reg[8] 
       (.C(s01_axis_aclk),
        .CE(rd_en),
        .D(\rd_ptr[8]_i_1__0_n_0 ),
        .Q(rd_ptr_reg_rep[8]),
        .R(s01_axis_aresetn_0));
  FDRE \rd_ptr_reg[9] 
       (.C(s01_axis_aclk),
        .CE(rd_en),
        .D(p_0_in__0),
        .Q(rd_ptr_reg),
        .R(s01_axis_aresetn_0));
  LUT5 #(
    .INIT(32'h44040444)) 
    \rd_ptr_rep[0]_i_1 
       (.I0(CO),
        .I1(\FSM_onehot_br_state_reg[1] ),
        .I2(full0),
        .I3(rd_ptr_reg),
        .I4(\wr_ptr_reg_n_0_[9] ),
        .O(rd_ptr0));
  LUT1 #(
    .INIT(2'h1)) 
    \row_cnt[0]_i_1 
       (.I0(row_cnt_reg[0]),
        .O(p_0_in__3[0]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \row_cnt[1]_i_1 
       (.I0(row_cnt_reg[0]),
        .I1(row_cnt_reg[1]),
        .O(p_0_in__3[1]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \row_cnt[2]_i_1 
       (.I0(row_cnt_reg[0]),
        .I1(row_cnt_reg[1]),
        .I2(row_cnt_reg[2]),
        .O(p_0_in__3[2]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \row_cnt[3]_i_1 
       (.I0(row_cnt_reg[1]),
        .I1(row_cnt_reg[0]),
        .I2(row_cnt_reg[2]),
        .I3(row_cnt_reg[3]),
        .O(p_0_in__3[3]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \row_cnt[4]_i_1 
       (.I0(row_cnt_reg[2]),
        .I1(row_cnt_reg[0]),
        .I2(row_cnt_reg[1]),
        .I3(row_cnt_reg[3]),
        .I4(row_cnt_reg[4]),
        .O(p_0_in__3[4]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \row_cnt[5]_i_1 
       (.I0(row_cnt_reg[3]),
        .I1(row_cnt_reg[1]),
        .I2(row_cnt_reg[0]),
        .I3(row_cnt_reg[2]),
        .I4(row_cnt_reg[4]),
        .I5(row_cnt_reg[5]),
        .O(p_0_in__3[5]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \row_cnt[6]_i_1 
       (.I0(\row_cnt[9]_i_4_n_0 ),
        .I1(row_cnt_reg[6]),
        .O(p_0_in__3[6]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \row_cnt[7]_i_1 
       (.I0(\row_cnt[9]_i_4_n_0 ),
        .I1(row_cnt_reg[6]),
        .I2(row_cnt_reg[7]),
        .O(p_0_in__3[7]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \row_cnt[8]_i_1 
       (.I0(row_cnt_reg[6]),
        .I1(\row_cnt[9]_i_4_n_0 ),
        .I2(row_cnt_reg[7]),
        .I3(row_cnt_reg[8]),
        .O(p_0_in__3[8]));
  LUT3 #(
    .INIT(8'h8F)) 
    \row_cnt[9]_i_1 
       (.I0(last_row__3),
        .I1(p_3_in),
        .I2(s01_axis_aresetn),
        .O(\row_cnt[9]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h88080888)) 
    \row_cnt[9]_i_2 
       (.I0(mem_reg_0),
        .I1(last_pix_in_row__1),
        .I2(full0),
        .I3(rd_ptr_reg),
        .I4(\wr_ptr_reg_n_0_[9] ),
        .O(p_3_in));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \row_cnt[9]_i_3 
       (.I0(row_cnt_reg[7]),
        .I1(\row_cnt[9]_i_4_n_0 ),
        .I2(row_cnt_reg[6]),
        .I3(row_cnt_reg[8]),
        .I4(row_cnt_reg[9]),
        .O(p_0_in__3[9]));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \row_cnt[9]_i_4 
       (.I0(row_cnt_reg[5]),
        .I1(row_cnt_reg[3]),
        .I2(row_cnt_reg[1]),
        .I3(row_cnt_reg[0]),
        .I4(row_cnt_reg[2]),
        .I5(row_cnt_reg[4]),
        .O(\row_cnt[9]_i_4_n_0 ));
  FDRE \row_cnt_reg[0] 
       (.C(s01_axis_aclk),
        .CE(p_3_in),
        .D(p_0_in__3[0]),
        .Q(row_cnt_reg[0]),
        .R(\row_cnt[9]_i_1_n_0 ));
  FDRE \row_cnt_reg[1] 
       (.C(s01_axis_aclk),
        .CE(p_3_in),
        .D(p_0_in__3[1]),
        .Q(row_cnt_reg[1]),
        .R(\row_cnt[9]_i_1_n_0 ));
  FDRE \row_cnt_reg[2] 
       (.C(s01_axis_aclk),
        .CE(p_3_in),
        .D(p_0_in__3[2]),
        .Q(row_cnt_reg[2]),
        .R(\row_cnt[9]_i_1_n_0 ));
  FDRE \row_cnt_reg[3] 
       (.C(s01_axis_aclk),
        .CE(p_3_in),
        .D(p_0_in__3[3]),
        .Q(row_cnt_reg[3]),
        .R(\row_cnt[9]_i_1_n_0 ));
  FDRE \row_cnt_reg[4] 
       (.C(s01_axis_aclk),
        .CE(p_3_in),
        .D(p_0_in__3[4]),
        .Q(row_cnt_reg[4]),
        .R(\row_cnt[9]_i_1_n_0 ));
  FDRE \row_cnt_reg[5] 
       (.C(s01_axis_aclk),
        .CE(p_3_in),
        .D(p_0_in__3[5]),
        .Q(row_cnt_reg[5]),
        .R(\row_cnt[9]_i_1_n_0 ));
  FDRE \row_cnt_reg[6] 
       (.C(s01_axis_aclk),
        .CE(p_3_in),
        .D(p_0_in__3[6]),
        .Q(row_cnt_reg[6]),
        .R(\row_cnt[9]_i_1_n_0 ));
  FDRE \row_cnt_reg[7] 
       (.C(s01_axis_aclk),
        .CE(p_3_in),
        .D(p_0_in__3[7]),
        .Q(row_cnt_reg[7]),
        .R(\row_cnt[9]_i_1_n_0 ));
  FDRE \row_cnt_reg[8] 
       (.C(s01_axis_aclk),
        .CE(p_3_in),
        .D(p_0_in__3[8]),
        .Q(row_cnt_reg[8]),
        .R(\row_cnt[9]_i_1_n_0 ));
  FDRE \row_cnt_reg[9] 
       (.C(s01_axis_aclk),
        .CE(p_3_in),
        .D(p_0_in__3[9]),
        .Q(row_cnt_reg[9]),
        .R(\row_cnt[9]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h31)) 
    skid_last_i_1
       (.I0(skid_valid_reg_0),
        .I1(empty),
        .I2(m00_axis_tready),
        .O(rd_en));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    skid_last_i_2
       (.I0(tlast_mem_reg_384_511_0_0_n_0),
        .I1(tlast_mem_reg_256_383_0_0_n_0),
        .I2(rd_ptr_reg_rep[8]),
        .I3(tlast_mem_reg_128_255_0_0_n_0),
        .I4(rd_ptr_reg_rep[7]),
        .I5(tlast_mem_reg_0_127_0_0_n_0),
        .O(skid_last0));
  FDRE skid_last_reg
       (.C(s01_axis_aclk),
        .CE(rd_en),
        .D(skid_last0),
        .Q(m00_axis_tlast),
        .R(s01_axis_aresetn_0));
  LUT4 #(
    .INIT(16'h3B00)) 
    skid_valid_i_1
       (.I0(skid_valid_reg_0),
        .I1(empty),
        .I2(m00_axis_tready),
        .I3(s01_axis_aresetn),
        .O(skid_valid_i_1_n_0));
  FDRE skid_valid_reg
       (.C(s01_axis_aclk),
        .CE(1'b1),
        .D(skid_valid_i_1_n_0),
        .Q(skid_valid_reg_0),
        .R(1'b0));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-5 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "512" *) 
  (* RTL_RAM_NAME = "loopBackFifoBD_lpbk_tst_0_0/inst/u_out_fifo/tlast_mem_reg" *) 
  (* RTL_RAM_STYLE = "auto" *) 
  (* RTL_RAM_TYPE = "RAM_TDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "127" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "0" *) 
  RAM128X1D tlast_mem_reg_0_127_0_0
       (.A({\wr_ptr_reg_n_0_[6] ,\wr_ptr_reg_n_0_[5] ,\wr_ptr_reg_n_0_[4] ,\wr_ptr_reg_n_0_[3] ,\wr_ptr_reg_n_0_[2] ,\wr_ptr_reg_n_0_[1] ,\wr_ptr_reg_n_0_[0] }),
        .D(tlast_stored),
        .DPO(tlast_mem_reg_0_127_0_0_n_0),
        .DPRA(rd_ptr_reg_rep[6:0]),
        .SPO(tlast_mem_reg_0_127_0_0_n_1),
        .WCLK(s01_axis_aclk),
        .WE(tlast_mem_reg_0_127_0_0_i_2_n_0));
  LUT3 #(
    .INIT(8'hC8)) 
    tlast_mem_reg_0_127_0_0_i_1
       (.I0(p_3_in),
        .I1(last_row__3),
        .I2(br_last),
        .O(tlast_stored));
  LUT6 #(
    .INIT(64'h0000000000009F00)) 
    tlast_mem_reg_0_127_0_0_i_2
       (.I0(\wr_ptr_reg_n_0_[9] ),
        .I1(rd_ptr_reg),
        .I2(full0),
        .I3(mem_reg_0),
        .I4(\wr_ptr_reg_n_0_[7] ),
        .I5(\wr_ptr_reg_n_0_[8] ),
        .O(tlast_mem_reg_0_127_0_0_i_2_n_0));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-5 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "512" *) 
  (* RTL_RAM_NAME = "loopBackFifoBD_lpbk_tst_0_0/inst/u_out_fifo/tlast_mem_reg" *) 
  (* RTL_RAM_STYLE = "auto" *) 
  (* RTL_RAM_TYPE = "RAM_TDP" *) 
  (* ram_addr_begin = "128" *) 
  (* ram_addr_end = "255" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "0" *) 
  RAM128X1D tlast_mem_reg_128_255_0_0
       (.A({\wr_ptr_reg_n_0_[6] ,\wr_ptr_reg_n_0_[5] ,\wr_ptr_reg_n_0_[4] ,\wr_ptr_reg_n_0_[3] ,\wr_ptr_reg_n_0_[2] ,\wr_ptr_reg_n_0_[1] ,\wr_ptr_reg_n_0_[0] }),
        .D(tlast_stored),
        .DPO(tlast_mem_reg_128_255_0_0_n_0),
        .DPRA(rd_ptr_reg_rep[6:0]),
        .SPO(tlast_mem_reg_128_255_0_0_n_1),
        .WCLK(s01_axis_aclk),
        .WE(tlast_mem_reg_128_255_0_0_i_1_n_0));
  LUT6 #(
    .INIT(64'h4040004000404040)) 
    tlast_mem_reg_128_255_0_0_i_1
       (.I0(\wr_ptr_reg_n_0_[8] ),
        .I1(\wr_ptr_reg_n_0_[7] ),
        .I2(mem_reg_0),
        .I3(full0),
        .I4(rd_ptr_reg),
        .I5(\wr_ptr_reg_n_0_[9] ),
        .O(tlast_mem_reg_128_255_0_0_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-5 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "512" *) 
  (* RTL_RAM_NAME = "loopBackFifoBD_lpbk_tst_0_0/inst/u_out_fifo/tlast_mem_reg" *) 
  (* RTL_RAM_STYLE = "auto" *) 
  (* RTL_RAM_TYPE = "RAM_TDP" *) 
  (* ram_addr_begin = "256" *) 
  (* ram_addr_end = "383" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "0" *) 
  RAM128X1D tlast_mem_reg_256_383_0_0
       (.A({\wr_ptr_reg_n_0_[6] ,\wr_ptr_reg_n_0_[5] ,\wr_ptr_reg_n_0_[4] ,\wr_ptr_reg_n_0_[3] ,\wr_ptr_reg_n_0_[2] ,\wr_ptr_reg_n_0_[1] ,\wr_ptr_reg_n_0_[0] }),
        .D(tlast_stored),
        .DPO(tlast_mem_reg_256_383_0_0_n_0),
        .DPRA(rd_ptr_reg_rep[6:0]),
        .SPO(tlast_mem_reg_256_383_0_0_n_1),
        .WCLK(s01_axis_aclk),
        .WE(tlast_mem_reg_256_383_0_0_i_1_n_0));
  LUT6 #(
    .INIT(64'h4040004000404040)) 
    tlast_mem_reg_256_383_0_0_i_1
       (.I0(\wr_ptr_reg_n_0_[7] ),
        .I1(\wr_ptr_reg_n_0_[8] ),
        .I2(mem_reg_0),
        .I3(full0),
        .I4(rd_ptr_reg),
        .I5(\wr_ptr_reg_n_0_[9] ),
        .O(tlast_mem_reg_256_383_0_0_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-5 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "512" *) 
  (* RTL_RAM_NAME = "loopBackFifoBD_lpbk_tst_0_0/inst/u_out_fifo/tlast_mem_reg" *) 
  (* RTL_RAM_STYLE = "auto" *) 
  (* RTL_RAM_TYPE = "RAM_TDP" *) 
  (* ram_addr_begin = "384" *) 
  (* ram_addr_end = "511" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "0" *) 
  RAM128X1D tlast_mem_reg_384_511_0_0
       (.A({\wr_ptr_reg_n_0_[6] ,\wr_ptr_reg_n_0_[5] ,\wr_ptr_reg_n_0_[4] ,\wr_ptr_reg_n_0_[3] ,\wr_ptr_reg_n_0_[2] ,\wr_ptr_reg_n_0_[1] ,\wr_ptr_reg_n_0_[0] }),
        .D(tlast_stored),
        .DPO(tlast_mem_reg_384_511_0_0_n_0),
        .DPRA(rd_ptr_reg_rep[6:0]),
        .SPO(tlast_mem_reg_384_511_0_0_n_1),
        .WCLK(s01_axis_aclk),
        .WE(tlast_mem_reg_384_511_0_0_i_1_n_0));
  LUT6 #(
    .INIT(64'h9F00000000000000)) 
    tlast_mem_reg_384_511_0_0_i_1
       (.I0(\wr_ptr_reg_n_0_[9] ),
        .I1(rd_ptr_reg),
        .I2(full0),
        .I3(mem_reg_0),
        .I4(\wr_ptr_reg_n_0_[7] ),
        .I5(\wr_ptr_reg_n_0_[8] ),
        .O(tlast_mem_reg_384_511_0_0_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    \wr_ptr[0]_i_1__0 
       (.I0(\wr_ptr_reg_n_0_[0] ),
        .O(p_0_in__1[0]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_ptr[1]_i_1__0 
       (.I0(\wr_ptr_reg_n_0_[0] ),
        .I1(\wr_ptr_reg_n_0_[1] ),
        .O(p_0_in__1[1]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \wr_ptr[2]_i_1__0 
       (.I0(\wr_ptr_reg_n_0_[0] ),
        .I1(\wr_ptr_reg_n_0_[1] ),
        .I2(\wr_ptr_reg_n_0_[2] ),
        .O(p_0_in__1[2]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \wr_ptr[3]_i_1__0 
       (.I0(\wr_ptr_reg_n_0_[1] ),
        .I1(\wr_ptr_reg_n_0_[0] ),
        .I2(\wr_ptr_reg_n_0_[2] ),
        .I3(\wr_ptr_reg_n_0_[3] ),
        .O(p_0_in__1[3]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \wr_ptr[4]_i_1__0 
       (.I0(\wr_ptr_reg_n_0_[2] ),
        .I1(\wr_ptr_reg_n_0_[0] ),
        .I2(\wr_ptr_reg_n_0_[1] ),
        .I3(\wr_ptr_reg_n_0_[3] ),
        .I4(\wr_ptr_reg_n_0_[4] ),
        .O(p_0_in__1[4]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \wr_ptr[5]_i_1__0 
       (.I0(\wr_ptr_reg_n_0_[3] ),
        .I1(\wr_ptr_reg_n_0_[1] ),
        .I2(\wr_ptr_reg_n_0_[0] ),
        .I3(\wr_ptr_reg_n_0_[2] ),
        .I4(\wr_ptr_reg_n_0_[4] ),
        .I5(\wr_ptr_reg_n_0_[5] ),
        .O(p_0_in__1[5]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_ptr[6]_i_1__0 
       (.I0(\wr_ptr[9]_i_3__0_n_0 ),
        .I1(\wr_ptr_reg_n_0_[6] ),
        .O(p_0_in__1[6]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \wr_ptr[7]_i_1__0 
       (.I0(\wr_ptr[9]_i_3__0_n_0 ),
        .I1(\wr_ptr_reg_n_0_[6] ),
        .I2(\wr_ptr_reg_n_0_[7] ),
        .O(p_0_in__1[7]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \wr_ptr[8]_i_1__0 
       (.I0(\wr_ptr_reg_n_0_[6] ),
        .I1(\wr_ptr[9]_i_3__0_n_0 ),
        .I2(\wr_ptr_reg_n_0_[7] ),
        .I3(\wr_ptr_reg_n_0_[8] ),
        .O(p_0_in__1[8]));
  LUT4 #(
    .INIT(16'hA22A)) 
    \wr_ptr[9]_i_1__0 
       (.I0(mem_reg_0),
        .I1(full0),
        .I2(rd_ptr_reg),
        .I3(\wr_ptr_reg_n_0_[9] ),
        .O(wr_accepted));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \wr_ptr[9]_i_2__0 
       (.I0(\wr_ptr_reg_n_0_[7] ),
        .I1(\wr_ptr[9]_i_3__0_n_0 ),
        .I2(\wr_ptr_reg_n_0_[6] ),
        .I3(\wr_ptr_reg_n_0_[8] ),
        .I4(\wr_ptr_reg_n_0_[9] ),
        .O(p_0_in__1[9]));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \wr_ptr[9]_i_3__0 
       (.I0(\wr_ptr_reg_n_0_[5] ),
        .I1(\wr_ptr_reg_n_0_[3] ),
        .I2(\wr_ptr_reg_n_0_[1] ),
        .I3(\wr_ptr_reg_n_0_[0] ),
        .I4(\wr_ptr_reg_n_0_[2] ),
        .I5(\wr_ptr_reg_n_0_[4] ),
        .O(\wr_ptr[9]_i_3__0_n_0 ));
  FDRE \wr_ptr_reg[0] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__1[0]),
        .Q(\wr_ptr_reg_n_0_[0] ),
        .R(s01_axis_aresetn_0));
  FDRE \wr_ptr_reg[1] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__1[1]),
        .Q(\wr_ptr_reg_n_0_[1] ),
        .R(s01_axis_aresetn_0));
  FDRE \wr_ptr_reg[2] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__1[2]),
        .Q(\wr_ptr_reg_n_0_[2] ),
        .R(s01_axis_aresetn_0));
  FDRE \wr_ptr_reg[3] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__1[3]),
        .Q(\wr_ptr_reg_n_0_[3] ),
        .R(s01_axis_aresetn_0));
  FDRE \wr_ptr_reg[4] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__1[4]),
        .Q(\wr_ptr_reg_n_0_[4] ),
        .R(s01_axis_aresetn_0));
  FDRE \wr_ptr_reg[5] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__1[5]),
        .Q(\wr_ptr_reg_n_0_[5] ),
        .R(s01_axis_aresetn_0));
  FDRE \wr_ptr_reg[6] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__1[6]),
        .Q(\wr_ptr_reg_n_0_[6] ),
        .R(s01_axis_aresetn_0));
  FDRE \wr_ptr_reg[7] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__1[7]),
        .Q(\wr_ptr_reg_n_0_[7] ),
        .R(s01_axis_aresetn_0));
  FDRE \wr_ptr_reg[8] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__1[8]),
        .Q(\wr_ptr_reg_n_0_[8] ),
        .R(s01_axis_aresetn_0));
  FDRE \wr_ptr_reg[9] 
       (.C(s01_axis_aclk),
        .CE(wr_accepted),
        .D(p_0_in__1[9]),
        .Q(\wr_ptr_reg_n_0_[9] ),
        .R(s01_axis_aresetn_0));
endmodule

(* ORIG_REF_NAME = "axis_fifo_s" *) 
module loopBackFifoBD_lpbk_tst_0_0_axis_fifo_s
   (rd_data,
    WEBWE,
    rd_last,
    CO,
    \wr_ptr_reg[9]_0 ,
    rd_ptr0,
    s01_axis_aclk,
    mem_reg_0,
    s01_axis_tvalid,
    br_data,
    s01_axis_tdata,
    s01_axis_tlast,
    s01_axis_aresetn);
  output [31:0]rd_data;
  output [0:0]WEBWE;
  output rd_last;
  output [0:0]CO;
  input \wr_ptr_reg[9]_0 ;
  input rd_ptr0;
  input s01_axis_aclk;
  input mem_reg_0;
  input s01_axis_tvalid;
  input [0:0]br_data;
  input [31:0]s01_axis_tdata;
  input s01_axis_tlast;
  input s01_axis_aresetn;

  wire [0:0]CO;
  wire [0:0]WEBWE;
  wire [0:0]br_data;
  wire empty_carry_i_1__0_n_0;
  wire empty_carry_i_2__0_n_0;
  wire empty_carry_i_3__0_n_0;
  wire empty_carry_i_4__0_n_0;
  wire empty_carry_n_1;
  wire empty_carry_n_2;
  wire empty_carry_n_3;
  wire full0;
  wire mem_reg_0;
  wire [9:0]p_0_in;
  wire p_1_in;
  wire [31:0]rd_data;
  wire rd_last;
  wire rd_ptr0;
  wire \rd_ptr[0]_i_1__0_n_0 ;
  wire \rd_ptr[1]_i_1_n_0 ;
  wire \rd_ptr[2]_i_1_n_0 ;
  wire \rd_ptr[3]_i_1_n_0 ;
  wire \rd_ptr[4]_i_1_n_0 ;
  wire \rd_ptr[5]_i_1_n_0 ;
  wire \rd_ptr[6]_i_1_n_0 ;
  wire \rd_ptr[6]_i_2_n_0 ;
  wire \rd_ptr[7]_i_1_n_0 ;
  wire \rd_ptr[8]_i_1_n_0 ;
  wire \rd_ptr[9]_i_1__0_n_0 ;
  wire \rd_ptr[9]_i_2_n_0 ;
  wire [9:0]rd_ptr_reg;
  wire [0:0]rd_ptr_reg_rep;
  wire \rd_ptr_rep[0]_i_2_n_0 ;
  wire s01_axis_aclk;
  wire s01_axis_aresetn;
  wire [31:0]s01_axis_tdata;
  wire s01_axis_tlast;
  wire s01_axis_tready_INST_0_i_1_n_2;
  wire s01_axis_tready_INST_0_i_1_n_3;
  wire s01_axis_tready_INST_0_i_2_n_0;
  wire s01_axis_tready_INST_0_i_3_n_0;
  wire s01_axis_tready_INST_0_i_4_n_0;
  wire s01_axis_tvalid;
  wire wr_en;
  wire \wr_ptr[9]_i_3_n_0 ;
  wire \wr_ptr_reg[9]_0 ;
  wire \wr_ptr_reg_n_0_[0] ;
  wire \wr_ptr_reg_n_0_[1] ;
  wire \wr_ptr_reg_n_0_[2] ;
  wire \wr_ptr_reg_n_0_[3] ;
  wire \wr_ptr_reg_n_0_[4] ;
  wire \wr_ptr_reg_n_0_[5] ;
  wire \wr_ptr_reg_n_0_[6] ;
  wire \wr_ptr_reg_n_0_[7] ;
  wire \wr_ptr_reg_n_0_[8] ;
  wire [3:0]NLW_empty_carry_O_UNCONNECTED;
  wire [1:0]NLW_mem_reg_DOPADOP_UNCONNECTED;
  wire [1:0]NLW_mem_reg_DOPBDOP_UNCONNECTED;
  wire [3:3]NLW_s01_axis_tready_INST_0_i_1_CO_UNCONNECTED;
  wire [3:0]NLW_s01_axis_tready_INST_0_i_1_O_UNCONNECTED;

  CARRY4 empty_carry
       (.CI(1'b0),
        .CO({CO,empty_carry_n_1,empty_carry_n_2,empty_carry_n_3}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_empty_carry_O_UNCONNECTED[3:0]),
        .S({empty_carry_i_1__0_n_0,empty_carry_i_2__0_n_0,empty_carry_i_3__0_n_0,empty_carry_i_4__0_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    empty_carry_i_1__0
       (.I0(rd_ptr_reg[9]),
        .I1(p_1_in),
        .O(empty_carry_i_1__0_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    empty_carry_i_2__0
       (.I0(\wr_ptr_reg_n_0_[7] ),
        .I1(rd_ptr_reg[7]),
        .I2(\wr_ptr_reg_n_0_[6] ),
        .I3(rd_ptr_reg[6]),
        .I4(rd_ptr_reg[8]),
        .I5(\wr_ptr_reg_n_0_[8] ),
        .O(empty_carry_i_2__0_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    empty_carry_i_3__0
       (.I0(\wr_ptr_reg_n_0_[4] ),
        .I1(rd_ptr_reg[4]),
        .I2(\wr_ptr_reg_n_0_[3] ),
        .I3(rd_ptr_reg[3]),
        .I4(rd_ptr_reg[5]),
        .I5(\wr_ptr_reg_n_0_[5] ),
        .O(empty_carry_i_3__0_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    empty_carry_i_4__0
       (.I0(\wr_ptr_reg_n_0_[1] ),
        .I1(rd_ptr_reg[1]),
        .I2(\wr_ptr_reg_n_0_[0] ),
        .I3(rd_ptr_reg[0]),
        .I4(rd_ptr_reg[2]),
        .I5(\wr_ptr_reg_n_0_[2] ),
        .O(empty_carry_i_4__0_n_0));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p1_d32" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p1_d32" *) 
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "16896" *) 
  (* RTL_RAM_NAME = "loopBackFifoBD_lpbk_tst_0_0/inst/u_in_fifo/mem_reg" *) 
  (* RTL_RAM_STYLE = "block" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "511" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "32" *) 
  RAMB18E1 #(
    .DOA_REG(1),
    .DOB_REG(1),
    .INIT_A(18'h00000),
    .INIT_B(18'h00000),
    .RAM_MODE("SDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(36),
    .READ_WIDTH_B(0),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(18'h00000),
    .SRVAL_B(18'h00000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("READ_FIRST"),
    .WRITE_WIDTH_A(0),
    .WRITE_WIDTH_B(36)) 
    mem_reg
       (.ADDRARDADDR({rd_ptr_reg[8:1],rd_ptr_reg_rep,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({\wr_ptr_reg_n_0_[8] ,\wr_ptr_reg_n_0_[7] ,\wr_ptr_reg_n_0_[6] ,\wr_ptr_reg_n_0_[5] ,\wr_ptr_reg_n_0_[4] ,\wr_ptr_reg_n_0_[3] ,\wr_ptr_reg_n_0_[2] ,\wr_ptr_reg_n_0_[1] ,\wr_ptr_reg_n_0_[0] ,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CLKARDCLK(s01_axis_aclk),
        .CLKBWRCLK(s01_axis_aclk),
        .DIADI(s01_axis_tdata[15:0]),
        .DIBDI(s01_axis_tdata[31:16]),
        .DIPADIP({1'b1,s01_axis_tlast}),
        .DIPBDIP({1'b1,1'b1}),
        .DOADO(rd_data[15:0]),
        .DOBDO(rd_data[31:16]),
        .DOPADOP(NLW_mem_reg_DOPADOP_UNCONNECTED[1:0]),
        .DOPBDOP(NLW_mem_reg_DOPBDOP_UNCONNECTED[1:0]),
        .ENARDEN(mem_reg_0),
        .ENBWREN(s01_axis_tvalid),
        .REGCEAREGCE(br_data),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(\wr_ptr_reg[9]_0 ),
        .RSTREGB(1'b0),
        .WEA({1'b0,1'b0}),
        .WEBWE({WEBWE,WEBWE,WEBWE,WEBWE}));
  FDSE rd_last_reg
       (.C(s01_axis_aclk),
        .CE(rd_ptr0),
        .D(1'b0),
        .Q(rd_last),
        .S(\wr_ptr_reg[9]_0 ));
  LUT3 #(
    .INIT(8'h60)) 
    \rd_ptr[0]_i_1__0 
       (.I0(rd_ptr_reg[0]),
        .I1(rd_ptr0),
        .I2(s01_axis_aresetn),
        .O(\rd_ptr[0]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_ptr[1]_i_1 
       (.I0(rd_ptr_reg[0]),
        .I1(rd_ptr_reg[1]),
        .O(\rd_ptr[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \rd_ptr[2]_i_1 
       (.I0(rd_ptr_reg[0]),
        .I1(rd_ptr_reg[1]),
        .I2(rd_ptr_reg[2]),
        .O(\rd_ptr[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \rd_ptr[3]_i_1 
       (.I0(rd_ptr_reg[1]),
        .I1(rd_ptr_reg[0]),
        .I2(rd_ptr_reg[2]),
        .I3(rd_ptr_reg[3]),
        .O(\rd_ptr[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \rd_ptr[4]_i_1 
       (.I0(rd_ptr_reg[2]),
        .I1(rd_ptr_reg[0]),
        .I2(rd_ptr_reg[1]),
        .I3(rd_ptr_reg[3]),
        .I4(rd_ptr_reg[4]),
        .O(\rd_ptr[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \rd_ptr[5]_i_1 
       (.I0(rd_ptr_reg[3]),
        .I1(rd_ptr_reg[1]),
        .I2(rd_ptr_reg[0]),
        .I3(rd_ptr_reg[2]),
        .I4(rd_ptr_reg[4]),
        .I5(rd_ptr_reg[5]),
        .O(\rd_ptr[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_ptr[6]_i_1 
       (.I0(\rd_ptr[6]_i_2_n_0 ),
        .I1(rd_ptr_reg[6]),
        .O(\rd_ptr[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \rd_ptr[6]_i_2 
       (.I0(rd_ptr_reg[5]),
        .I1(rd_ptr_reg[3]),
        .I2(rd_ptr_reg[1]),
        .I3(rd_ptr_reg[0]),
        .I4(rd_ptr_reg[2]),
        .I5(rd_ptr_reg[4]),
        .O(\rd_ptr[6]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \rd_ptr[7]_i_1 
       (.I0(\rd_ptr[6]_i_2_n_0 ),
        .I1(rd_ptr_reg[6]),
        .I2(rd_ptr_reg[7]),
        .O(\rd_ptr[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \rd_ptr[8]_i_1 
       (.I0(rd_ptr_reg[6]),
        .I1(\rd_ptr[6]_i_2_n_0 ),
        .I2(rd_ptr_reg[7]),
        .I3(rd_ptr_reg[8]),
        .O(\rd_ptr[8]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h6AAA0000)) 
    \rd_ptr[9]_i_1__0 
       (.I0(rd_ptr_reg[9]),
        .I1(\rd_ptr[9]_i_2_n_0 ),
        .I2(rd_ptr_reg[8]),
        .I3(rd_ptr0),
        .I4(s01_axis_aresetn),
        .O(\rd_ptr[9]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \rd_ptr[9]_i_2 
       (.I0(rd_ptr_reg[7]),
        .I1(\rd_ptr[6]_i_2_n_0 ),
        .I2(rd_ptr_reg[6]),
        .O(\rd_ptr[9]_i_2_n_0 ));
  FDRE \rd_ptr_reg[0] 
       (.C(s01_axis_aclk),
        .CE(1'b1),
        .D(\rd_ptr[0]_i_1__0_n_0 ),
        .Q(rd_ptr_reg[0]),
        .R(1'b0));
  FDRE \rd_ptr_reg[1] 
       (.C(s01_axis_aclk),
        .CE(rd_ptr0),
        .D(\rd_ptr[1]_i_1_n_0 ),
        .Q(rd_ptr_reg[1]),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \rd_ptr_reg[2] 
       (.C(s01_axis_aclk),
        .CE(rd_ptr0),
        .D(\rd_ptr[2]_i_1_n_0 ),
        .Q(rd_ptr_reg[2]),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \rd_ptr_reg[3] 
       (.C(s01_axis_aclk),
        .CE(rd_ptr0),
        .D(\rd_ptr[3]_i_1_n_0 ),
        .Q(rd_ptr_reg[3]),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \rd_ptr_reg[4] 
       (.C(s01_axis_aclk),
        .CE(rd_ptr0),
        .D(\rd_ptr[4]_i_1_n_0 ),
        .Q(rd_ptr_reg[4]),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \rd_ptr_reg[5] 
       (.C(s01_axis_aclk),
        .CE(rd_ptr0),
        .D(\rd_ptr[5]_i_1_n_0 ),
        .Q(rd_ptr_reg[5]),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \rd_ptr_reg[6] 
       (.C(s01_axis_aclk),
        .CE(rd_ptr0),
        .D(\rd_ptr[6]_i_1_n_0 ),
        .Q(rd_ptr_reg[6]),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \rd_ptr_reg[7] 
       (.C(s01_axis_aclk),
        .CE(rd_ptr0),
        .D(\rd_ptr[7]_i_1_n_0 ),
        .Q(rd_ptr_reg[7]),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \rd_ptr_reg[8] 
       (.C(s01_axis_aclk),
        .CE(rd_ptr0),
        .D(\rd_ptr[8]_i_1_n_0 ),
        .Q(rd_ptr_reg[8]),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \rd_ptr_reg[9] 
       (.C(s01_axis_aclk),
        .CE(1'b1),
        .D(\rd_ptr[9]_i_1__0_n_0 ),
        .Q(rd_ptr_reg[9]),
        .R(1'b0));
  FDRE \rd_ptr_reg_rep[0] 
       (.C(s01_axis_aclk),
        .CE(rd_ptr0),
        .D(\rd_ptr_rep[0]_i_2_n_0 ),
        .Q(rd_ptr_reg_rep),
        .R(\wr_ptr_reg[9]_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \rd_ptr_rep[0]_i_2 
       (.I0(rd_ptr_reg[0]),
        .O(\rd_ptr_rep[0]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h9F)) 
    s01_axis_tready_INST_0
       (.I0(p_1_in),
        .I1(rd_ptr_reg[9]),
        .I2(full0),
        .O(WEBWE));
  CARRY4 s01_axis_tready_INST_0_i_1
       (.CI(1'b0),
        .CO({NLW_s01_axis_tready_INST_0_i_1_CO_UNCONNECTED[3],full0,s01_axis_tready_INST_0_i_1_n_2,s01_axis_tready_INST_0_i_1_n_3}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_s01_axis_tready_INST_0_i_1_O_UNCONNECTED[3:0]),
        .S({1'b0,s01_axis_tready_INST_0_i_2_n_0,s01_axis_tready_INST_0_i_3_n_0,s01_axis_tready_INST_0_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    s01_axis_tready_INST_0_i_2
       (.I0(\wr_ptr_reg_n_0_[7] ),
        .I1(rd_ptr_reg[7]),
        .I2(\wr_ptr_reg_n_0_[6] ),
        .I3(rd_ptr_reg[6]),
        .I4(rd_ptr_reg[8]),
        .I5(\wr_ptr_reg_n_0_[8] ),
        .O(s01_axis_tready_INST_0_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    s01_axis_tready_INST_0_i_3
       (.I0(\wr_ptr_reg_n_0_[4] ),
        .I1(rd_ptr_reg[4]),
        .I2(\wr_ptr_reg_n_0_[3] ),
        .I3(rd_ptr_reg[3]),
        .I4(rd_ptr_reg[5]),
        .I5(\wr_ptr_reg_n_0_[5] ),
        .O(s01_axis_tready_INST_0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    s01_axis_tready_INST_0_i_4
       (.I0(\wr_ptr_reg_n_0_[1] ),
        .I1(rd_ptr_reg[1]),
        .I2(\wr_ptr_reg_n_0_[0] ),
        .I3(rd_ptr_reg[0]),
        .I4(rd_ptr_reg[2]),
        .I5(\wr_ptr_reg_n_0_[2] ),
        .O(s01_axis_tready_INST_0_i_4_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    \wr_ptr[0]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0] ),
        .O(p_0_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_ptr[1]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0] ),
        .I1(\wr_ptr_reg_n_0_[1] ),
        .O(p_0_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \wr_ptr[2]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0] ),
        .I1(\wr_ptr_reg_n_0_[1] ),
        .I2(\wr_ptr_reg_n_0_[2] ),
        .O(p_0_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \wr_ptr[3]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1] ),
        .I1(\wr_ptr_reg_n_0_[0] ),
        .I2(\wr_ptr_reg_n_0_[2] ),
        .I3(\wr_ptr_reg_n_0_[3] ),
        .O(p_0_in[3]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \wr_ptr[4]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2] ),
        .I1(\wr_ptr_reg_n_0_[0] ),
        .I2(\wr_ptr_reg_n_0_[1] ),
        .I3(\wr_ptr_reg_n_0_[3] ),
        .I4(\wr_ptr_reg_n_0_[4] ),
        .O(p_0_in[4]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \wr_ptr[5]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3] ),
        .I1(\wr_ptr_reg_n_0_[1] ),
        .I2(\wr_ptr_reg_n_0_[0] ),
        .I3(\wr_ptr_reg_n_0_[2] ),
        .I4(\wr_ptr_reg_n_0_[4] ),
        .I5(\wr_ptr_reg_n_0_[5] ),
        .O(p_0_in[5]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_ptr[6]_i_1 
       (.I0(\wr_ptr[9]_i_3_n_0 ),
        .I1(\wr_ptr_reg_n_0_[6] ),
        .O(p_0_in[6]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \wr_ptr[7]_i_1 
       (.I0(\wr_ptr[9]_i_3_n_0 ),
        .I1(\wr_ptr_reg_n_0_[6] ),
        .I2(\wr_ptr_reg_n_0_[7] ),
        .O(p_0_in[7]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \wr_ptr[8]_i_1 
       (.I0(\wr_ptr_reg_n_0_[6] ),
        .I1(\wr_ptr[9]_i_3_n_0 ),
        .I2(\wr_ptr_reg_n_0_[7] ),
        .I3(\wr_ptr_reg_n_0_[8] ),
        .O(p_0_in[8]));
  LUT4 #(
    .INIT(16'hA22A)) 
    \wr_ptr[9]_i_1 
       (.I0(s01_axis_tvalid),
        .I1(full0),
        .I2(rd_ptr_reg[9]),
        .I3(p_1_in),
        .O(wr_en));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \wr_ptr[9]_i_2 
       (.I0(\wr_ptr_reg_n_0_[7] ),
        .I1(\wr_ptr[9]_i_3_n_0 ),
        .I2(\wr_ptr_reg_n_0_[6] ),
        .I3(\wr_ptr_reg_n_0_[8] ),
        .I4(p_1_in),
        .O(p_0_in[9]));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \wr_ptr[9]_i_3 
       (.I0(\wr_ptr_reg_n_0_[5] ),
        .I1(\wr_ptr_reg_n_0_[3] ),
        .I2(\wr_ptr_reg_n_0_[1] ),
        .I3(\wr_ptr_reg_n_0_[0] ),
        .I4(\wr_ptr_reg_n_0_[2] ),
        .I5(\wr_ptr_reg_n_0_[4] ),
        .O(\wr_ptr[9]_i_3_n_0 ));
  FDRE \wr_ptr_reg[0] 
       (.C(s01_axis_aclk),
        .CE(wr_en),
        .D(p_0_in[0]),
        .Q(\wr_ptr_reg_n_0_[0] ),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \wr_ptr_reg[1] 
       (.C(s01_axis_aclk),
        .CE(wr_en),
        .D(p_0_in[1]),
        .Q(\wr_ptr_reg_n_0_[1] ),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \wr_ptr_reg[2] 
       (.C(s01_axis_aclk),
        .CE(wr_en),
        .D(p_0_in[2]),
        .Q(\wr_ptr_reg_n_0_[2] ),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \wr_ptr_reg[3] 
       (.C(s01_axis_aclk),
        .CE(wr_en),
        .D(p_0_in[3]),
        .Q(\wr_ptr_reg_n_0_[3] ),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \wr_ptr_reg[4] 
       (.C(s01_axis_aclk),
        .CE(wr_en),
        .D(p_0_in[4]),
        .Q(\wr_ptr_reg_n_0_[4] ),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \wr_ptr_reg[5] 
       (.C(s01_axis_aclk),
        .CE(wr_en),
        .D(p_0_in[5]),
        .Q(\wr_ptr_reg_n_0_[5] ),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \wr_ptr_reg[6] 
       (.C(s01_axis_aclk),
        .CE(wr_en),
        .D(p_0_in[6]),
        .Q(\wr_ptr_reg_n_0_[6] ),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \wr_ptr_reg[7] 
       (.C(s01_axis_aclk),
        .CE(wr_en),
        .D(p_0_in[7]),
        .Q(\wr_ptr_reg_n_0_[7] ),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \wr_ptr_reg[8] 
       (.C(s01_axis_aclk),
        .CE(wr_en),
        .D(p_0_in[8]),
        .Q(\wr_ptr_reg_n_0_[8] ),
        .R(\wr_ptr_reg[9]_0 ));
  FDRE \wr_ptr_reg[9] 
       (.C(s01_axis_aclk),
        .CE(wr_en),
        .D(p_0_in[9]),
        .Q(p_1_in),
        .R(\wr_ptr_reg[9]_0 ));
endmodule

(* ORIG_REF_NAME = "lpbk_tst" *) 
module loopBackFifoBD_lpbk_tst_0_0_lpbk_tst
   (skid_valid_reg,
    m00_axis_tdata,
    m00_axis_tlast,
    WEBWE,
    m00_axis_tready,
    s01_axis_aresetn,
    s01_axis_aclk,
    s01_axis_tvalid,
    s01_axis_tdata,
    s01_axis_tlast);
  output skid_valid_reg;
  output [31:0]m00_axis_tdata;
  output m00_axis_tlast;
  output [0:0]WEBWE;
  input m00_axis_tready;
  input s01_axis_aresetn;
  input s01_axis_aclk;
  input s01_axis_tvalid;
  input [31:0]s01_axis_tdata;
  input s01_axis_tlast;

  wire \FSM_onehot_br_state[2]_i_1_n_0 ;
  wire \FSM_onehot_br_state_reg_n_0_[0] ;
  wire \FSM_onehot_br_state_reg_n_0_[2] ;
  wire [0:0]WEBWE;
  wire [0:0]br_data;
  wire br_last;
  wire in_empty;
  wire [31:0]m00_axis_tdata;
  wire m00_axis_tlast;
  wire m00_axis_tready;
  wire [31:0]rd_data;
  wire rd_last;
  wire rd_ptr0;
  wire s01_axis_aclk;
  wire s01_axis_aresetn;
  wire [31:0]s01_axis_tdata;
  wire s01_axis_tlast;
  wire s01_axis_tvalid;
  wire skid_valid_reg;
  wire u_out_fifo_n_32;
  wire u_out_fifo_n_34;
  wire u_out_fifo_n_36;
  wire u_out_fifo_n_37;

  LUT2 #(
    .INIT(4'h8)) 
    \FSM_onehot_br_state[2]_i_1 
       (.I0(br_data),
        .I1(s01_axis_aresetn),
        .O(\FSM_onehot_br_state[2]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "BR_IDLE:001,BR_PENDING:010,BR_WRITE:100," *) 
  FDRE #(
    .INIT(1'b1)) 
    \FSM_onehot_br_state_reg[0] 
       (.C(s01_axis_aclk),
        .CE(1'b1),
        .D(u_out_fifo_n_36),
        .Q(\FSM_onehot_br_state_reg_n_0_[0] ),
        .R(1'b0));
  (* FSM_ENCODED_STATES = "BR_IDLE:001,BR_PENDING:010,BR_WRITE:100," *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_br_state_reg[1] 
       (.C(s01_axis_aclk),
        .CE(1'b1),
        .D(u_out_fifo_n_34),
        .Q(br_data),
        .R(1'b0));
  (* FSM_ENCODED_STATES = "BR_IDLE:001,BR_PENDING:010,BR_WRITE:100," *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_br_state_reg[2] 
       (.C(s01_axis_aclk),
        .CE(1'b1),
        .D(\FSM_onehot_br_state[2]_i_1_n_0 ),
        .Q(\FSM_onehot_br_state_reg_n_0_[2] ),
        .R(1'b0));
  FDRE br_last_reg
       (.C(s01_axis_aclk),
        .CE(br_data),
        .D(rd_last),
        .Q(br_last),
        .R(u_out_fifo_n_32));
  loopBackFifoBD_lpbk_tst_0_0_axis_fifo_s u_in_fifo
       (.CO(in_empty),
        .WEBWE(WEBWE),
        .br_data(br_data),
        .mem_reg_0(u_out_fifo_n_37),
        .rd_data(rd_data),
        .rd_last(rd_last),
        .rd_ptr0(rd_ptr0),
        .s01_axis_aclk(s01_axis_aclk),
        .s01_axis_aresetn(s01_axis_aresetn),
        .s01_axis_tdata(s01_axis_tdata),
        .s01_axis_tlast(s01_axis_tlast),
        .s01_axis_tvalid(s01_axis_tvalid),
        .\wr_ptr_reg[9]_0 (u_out_fifo_n_32));
  loopBackFifoBD_lpbk_tst_0_0_axis_fifo_m u_out_fifo
       (.CO(in_empty),
        .\FSM_onehot_br_state_reg[0] (u_out_fifo_n_36),
        .\FSM_onehot_br_state_reg[1] (\FSM_onehot_br_state_reg_n_0_[0] ),
        .\FSM_onehot_br_state_reg[2] (u_out_fifo_n_34),
        .br_data(br_data),
        .br_last(br_last),
        .m00_axis_tdata(m00_axis_tdata),
        .m00_axis_tlast(m00_axis_tlast),
        .m00_axis_tready(m00_axis_tready),
        .mem_reg_0(\FSM_onehot_br_state_reg_n_0_[2] ),
        .rd_data(rd_data),
        .rd_ptr0(rd_ptr0),
        .s01_axis_aclk(s01_axis_aclk),
        .s01_axis_aresetn(s01_axis_aresetn),
        .s01_axis_aresetn_0(u_out_fifo_n_32),
        .s01_axis_aresetn_1(u_out_fifo_n_37),
        .skid_valid_reg_0(skid_valid_reg));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
