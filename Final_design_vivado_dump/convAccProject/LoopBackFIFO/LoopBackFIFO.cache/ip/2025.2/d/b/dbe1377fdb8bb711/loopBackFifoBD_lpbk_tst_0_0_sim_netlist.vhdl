-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
-- Date        : Sat Apr 11 14:43:59 2026
-- Host        : DESKTOP-8NFLPRC running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ loopBackFifoBD_lpbk_tst_0_0_sim_netlist.vhdl
-- Design      : loopBackFifoBD_lpbk_tst_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_axis_fifo_m is
  port (
    m00_axis_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s01_axis_aresetn_0 : out STD_LOGIC;
    skid_valid_reg_0 : out STD_LOGIC;
    \FSM_onehot_br_state_reg[2]\ : out STD_LOGIC;
    rd_ptr0 : out STD_LOGIC;
    \FSM_onehot_br_state_reg[0]\ : out STD_LOGIC;
    s01_axis_aresetn_1 : out STD_LOGIC;
    m00_axis_tlast : out STD_LOGIC;
    s01_axis_aclk : in STD_LOGIC;
    mem_reg_0 : in STD_LOGIC;
    rd_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m00_axis_tready : in STD_LOGIC;
    s01_axis_aresetn : in STD_LOGIC;
    br_data : in STD_LOGIC_VECTOR ( 0 to 0 );
    \FSM_onehot_br_state_reg[1]\ : in STD_LOGIC;
    br_last : in STD_LOGIC;
    CO : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_axis_fifo_m;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_axis_fifo_m is
  signal empty : STD_LOGIC;
  signal empty_carry_i_1_n_0 : STD_LOGIC;
  signal empty_carry_i_2_n_0 : STD_LOGIC;
  signal empty_carry_i_3_n_0 : STD_LOGIC;
  signal empty_carry_i_4_n_0 : STD_LOGIC;
  signal empty_carry_n_1 : STD_LOGIC;
  signal empty_carry_n_2 : STD_LOGIC;
  signal empty_carry_n_3 : STD_LOGIC;
  signal full0 : STD_LOGIC;
  signal \last_pix_in_row__1\ : STD_LOGIC;
  signal last_pix_in_row_carry_i_1_n_0 : STD_LOGIC;
  signal last_pix_in_row_carry_i_2_n_0 : STD_LOGIC;
  signal last_pix_in_row_carry_n_3 : STD_LOGIC;
  signal \last_row__3\ : STD_LOGIC;
  signal last_row_carry_i_1_n_0 : STD_LOGIC;
  signal last_row_carry_i_2_n_0 : STD_LOGIC;
  signal last_row_carry_i_3_n_0 : STD_LOGIC;
  signal last_row_carry_i_4_n_0 : STD_LOGIC;
  signal last_row_carry_n_1 : STD_LOGIC;
  signal last_row_carry_n_2 : STD_LOGIC;
  signal last_row_carry_n_3 : STD_LOGIC;
  signal \mem_reg_i_1__0_n_0\ : STD_LOGIC;
  signal mem_reg_i_4_n_2 : STD_LOGIC;
  signal mem_reg_i_4_n_3 : STD_LOGIC;
  signal mem_reg_i_5_n_0 : STD_LOGIC;
  signal mem_reg_i_6_n_0 : STD_LOGIC;
  signal mem_reg_i_7_n_0 : STD_LOGIC;
  signal \p_0_in__0\ : STD_LOGIC_VECTOR ( 9 to 9 );
  signal \p_0_in__1\ : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \p_0_in__2\ : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal \p_0_in__3\ : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal p_3_in : STD_LOGIC;
  signal \pix_cnt[5]_i_1_n_0\ : STD_LOGIC;
  signal pix_cnt_reg : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal rd_en : STD_LOGIC;
  signal \^rd_ptr0\ : STD_LOGIC;
  signal \rd_ptr[0]_i_1_n_0\ : STD_LOGIC;
  signal \rd_ptr[1]_i_1__0_n_0\ : STD_LOGIC;
  signal \rd_ptr[2]_i_1__0_n_0\ : STD_LOGIC;
  signal \rd_ptr[3]_i_1__0_n_0\ : STD_LOGIC;
  signal \rd_ptr[4]_i_1__0_n_0\ : STD_LOGIC;
  signal \rd_ptr[5]_i_1__0_n_0\ : STD_LOGIC;
  signal \rd_ptr[6]_i_1__0_n_0\ : STD_LOGIC;
  signal \rd_ptr[7]_i_1__0_n_0\ : STD_LOGIC;
  signal \rd_ptr[8]_i_1__0_n_0\ : STD_LOGIC;
  signal \rd_ptr[9]_i_2__0_n_0\ : STD_LOGIC;
  signal rd_ptr_reg : STD_LOGIC_VECTOR ( 9 to 9 );
  signal rd_ptr_reg_rep : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal \row_cnt[9]_i_1_n_0\ : STD_LOGIC;
  signal \row_cnt[9]_i_4_n_0\ : STD_LOGIC;
  signal row_cnt_reg : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \^s01_axis_aresetn_0\ : STD_LOGIC;
  signal skid_last0 : STD_LOGIC;
  signal skid_valid_i_1_n_0 : STD_LOGIC;
  signal \^skid_valid_reg_0\ : STD_LOGIC;
  signal tlast_mem_reg_0_127_0_0_i_2_n_0 : STD_LOGIC;
  signal tlast_mem_reg_0_127_0_0_n_0 : STD_LOGIC;
  signal tlast_mem_reg_0_127_0_0_n_1 : STD_LOGIC;
  signal tlast_mem_reg_128_255_0_0_i_1_n_0 : STD_LOGIC;
  signal tlast_mem_reg_128_255_0_0_n_0 : STD_LOGIC;
  signal tlast_mem_reg_128_255_0_0_n_1 : STD_LOGIC;
  signal tlast_mem_reg_256_383_0_0_i_1_n_0 : STD_LOGIC;
  signal tlast_mem_reg_256_383_0_0_n_0 : STD_LOGIC;
  signal tlast_mem_reg_256_383_0_0_n_1 : STD_LOGIC;
  signal tlast_mem_reg_384_511_0_0_i_1_n_0 : STD_LOGIC;
  signal tlast_mem_reg_384_511_0_0_n_0 : STD_LOGIC;
  signal tlast_mem_reg_384_511_0_0_n_1 : STD_LOGIC;
  signal tlast_stored : STD_LOGIC;
  signal wr_accepted : STD_LOGIC;
  signal wr_accepted0 : STD_LOGIC;
  signal \wr_ptr[9]_i_3__0_n_0\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[0]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[1]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[2]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[3]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[4]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[5]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[6]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[7]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[8]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[9]\ : STD_LOGIC;
  signal NLW_empty_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_last_pix_in_row_carry_CO_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal NLW_last_pix_in_row_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_last_row_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_mem_reg_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_mem_reg_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_mem_reg_i_4_CO_UNCONNECTED : STD_LOGIC_VECTOR ( 3 to 3 );
  signal NLW_mem_reg_i_4_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_onehot_br_state[0]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \FSM_onehot_br_state[1]_i_1\ : label is "soft_lutpair8";
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ : string;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of mem_reg : label is "p0_d32";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ : string;
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of mem_reg : label is "p0_d32";
  attribute METHODOLOGY_DRC_VIOS : string;
  attribute METHODOLOGY_DRC_VIOS of mem_reg : label is "{SYNTH-6 {cell *THIS*}}";
  attribute RTL_RAM_BITS : integer;
  attribute RTL_RAM_BITS of mem_reg : label is 16384;
  attribute RTL_RAM_NAME : string;
  attribute RTL_RAM_NAME of mem_reg : label is "loopBackFifoBD_lpbk_tst_0_0/inst/u_out_fifo/mem_reg";
  attribute RTL_RAM_STYLE : string;
  attribute RTL_RAM_STYLE of mem_reg : label is "block";
  attribute RTL_RAM_TYPE : string;
  attribute RTL_RAM_TYPE of mem_reg : label is "RAM_SDP";
  attribute ram_addr_begin : integer;
  attribute ram_addr_begin of mem_reg : label is 0;
  attribute ram_addr_end : integer;
  attribute ram_addr_end of mem_reg : label is 511;
  attribute ram_offset : integer;
  attribute ram_offset of mem_reg : label is 0;
  attribute ram_slice_begin : integer;
  attribute ram_slice_begin of mem_reg : label is 0;
  attribute ram_slice_end : integer;
  attribute ram_slice_end of mem_reg : label is 31;
  attribute SOFT_HLUTNM of \pix_cnt[1]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \pix_cnt[2]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \pix_cnt[3]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \pix_cnt[4]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \rd_ptr[1]_i_1__0\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \rd_ptr[2]_i_1__0\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \rd_ptr[3]_i_1__0\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \rd_ptr[4]_i_1__0\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \rd_ptr[6]_i_1__0\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \rd_ptr[7]_i_1__0\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \rd_ptr[8]_i_1__0\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \rd_ptr[9]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \row_cnt[1]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \row_cnt[2]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \row_cnt[3]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \row_cnt[4]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \row_cnt[6]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \row_cnt[7]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \row_cnt[8]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \row_cnt[9]_i_3\ : label is "soft_lutpair15";
  attribute METHODOLOGY_DRC_VIOS of tlast_mem_reg_0_127_0_0 : label is "{SYNTH-5 {cell *THIS*}}";
  attribute RTL_RAM_BITS of tlast_mem_reg_0_127_0_0 : label is 512;
  attribute RTL_RAM_NAME of tlast_mem_reg_0_127_0_0 : label is "loopBackFifoBD_lpbk_tst_0_0/inst/u_out_fifo/tlast_mem_reg";
  attribute RTL_RAM_STYLE of tlast_mem_reg_0_127_0_0 : label is "auto";
  attribute RTL_RAM_TYPE of tlast_mem_reg_0_127_0_0 : label is "RAM_TDP";
  attribute ram_addr_begin of tlast_mem_reg_0_127_0_0 : label is 0;
  attribute ram_addr_end of tlast_mem_reg_0_127_0_0 : label is 127;
  attribute ram_offset of tlast_mem_reg_0_127_0_0 : label is 0;
  attribute ram_slice_begin of tlast_mem_reg_0_127_0_0 : label is 0;
  attribute ram_slice_end of tlast_mem_reg_0_127_0_0 : label is 0;
  attribute METHODOLOGY_DRC_VIOS of tlast_mem_reg_128_255_0_0 : label is "{SYNTH-5 {cell *THIS*}}";
  attribute RTL_RAM_BITS of tlast_mem_reg_128_255_0_0 : label is 512;
  attribute RTL_RAM_NAME of tlast_mem_reg_128_255_0_0 : label is "loopBackFifoBD_lpbk_tst_0_0/inst/u_out_fifo/tlast_mem_reg";
  attribute RTL_RAM_STYLE of tlast_mem_reg_128_255_0_0 : label is "auto";
  attribute RTL_RAM_TYPE of tlast_mem_reg_128_255_0_0 : label is "RAM_TDP";
  attribute ram_addr_begin of tlast_mem_reg_128_255_0_0 : label is 128;
  attribute ram_addr_end of tlast_mem_reg_128_255_0_0 : label is 255;
  attribute ram_offset of tlast_mem_reg_128_255_0_0 : label is 0;
  attribute ram_slice_begin of tlast_mem_reg_128_255_0_0 : label is 0;
  attribute ram_slice_end of tlast_mem_reg_128_255_0_0 : label is 0;
  attribute METHODOLOGY_DRC_VIOS of tlast_mem_reg_256_383_0_0 : label is "{SYNTH-5 {cell *THIS*}}";
  attribute RTL_RAM_BITS of tlast_mem_reg_256_383_0_0 : label is 512;
  attribute RTL_RAM_NAME of tlast_mem_reg_256_383_0_0 : label is "loopBackFifoBD_lpbk_tst_0_0/inst/u_out_fifo/tlast_mem_reg";
  attribute RTL_RAM_STYLE of tlast_mem_reg_256_383_0_0 : label is "auto";
  attribute RTL_RAM_TYPE of tlast_mem_reg_256_383_0_0 : label is "RAM_TDP";
  attribute ram_addr_begin of tlast_mem_reg_256_383_0_0 : label is 256;
  attribute ram_addr_end of tlast_mem_reg_256_383_0_0 : label is 383;
  attribute ram_offset of tlast_mem_reg_256_383_0_0 : label is 0;
  attribute ram_slice_begin of tlast_mem_reg_256_383_0_0 : label is 0;
  attribute ram_slice_end of tlast_mem_reg_256_383_0_0 : label is 0;
  attribute METHODOLOGY_DRC_VIOS of tlast_mem_reg_384_511_0_0 : label is "{SYNTH-5 {cell *THIS*}}";
  attribute RTL_RAM_BITS of tlast_mem_reg_384_511_0_0 : label is 512;
  attribute RTL_RAM_NAME of tlast_mem_reg_384_511_0_0 : label is "loopBackFifoBD_lpbk_tst_0_0/inst/u_out_fifo/tlast_mem_reg";
  attribute RTL_RAM_STYLE of tlast_mem_reg_384_511_0_0 : label is "auto";
  attribute RTL_RAM_TYPE of tlast_mem_reg_384_511_0_0 : label is "RAM_TDP";
  attribute ram_addr_begin of tlast_mem_reg_384_511_0_0 : label is 384;
  attribute ram_addr_end of tlast_mem_reg_384_511_0_0 : label is 511;
  attribute ram_offset of tlast_mem_reg_384_511_0_0 : label is 0;
  attribute ram_slice_begin of tlast_mem_reg_384_511_0_0 : label is 0;
  attribute ram_slice_end of tlast_mem_reg_384_511_0_0 : label is 0;
  attribute SOFT_HLUTNM of \wr_ptr[1]_i_1__0\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \wr_ptr[2]_i_1__0\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \wr_ptr[3]_i_1__0\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \wr_ptr[4]_i_1__0\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \wr_ptr[6]_i_1__0\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \wr_ptr[7]_i_1__0\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \wr_ptr[8]_i_1__0\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \wr_ptr[9]_i_2__0\ : label is "soft_lutpair12";
begin
  rd_ptr0 <= \^rd_ptr0\;
  s01_axis_aresetn_0 <= \^s01_axis_aresetn_0\;
  skid_valid_reg_0 <= \^skid_valid_reg_0\;
\FSM_onehot_br_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F0F2FFFF"
    )
        port map (
      I0 => \FSM_onehot_br_state_reg[1]\,
      I1 => \^rd_ptr0\,
      I2 => mem_reg_0,
      I3 => br_data(0),
      I4 => s01_axis_aresetn,
      O => \FSM_onehot_br_state_reg[0]\
    );
\FSM_onehot_br_state[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FE000000"
    )
        port map (
      I0 => \^rd_ptr0\,
      I1 => mem_reg_0,
      I2 => br_data(0),
      I3 => \FSM_onehot_br_state_reg[1]\,
      I4 => s01_axis_aresetn,
      O => \FSM_onehot_br_state_reg[2]\
    );
empty_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => empty,
      CO(2) => empty_carry_n_1,
      CO(1) => empty_carry_n_2,
      CO(0) => empty_carry_n_3,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_empty_carry_O_UNCONNECTED(3 downto 0),
      S(3) => empty_carry_i_1_n_0,
      S(2) => empty_carry_i_2_n_0,
      S(1) => empty_carry_i_3_n_0,
      S(0) => empty_carry_i_4_n_0
    );
empty_carry_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => rd_ptr_reg(9),
      I1 => \wr_ptr_reg_n_0_[9]\,
      O => empty_carry_i_1_n_0
    );
empty_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[7]\,
      I1 => rd_ptr_reg_rep(7),
      I2 => \wr_ptr_reg_n_0_[6]\,
      I3 => rd_ptr_reg_rep(6),
      I4 => rd_ptr_reg_rep(8),
      I5 => \wr_ptr_reg_n_0_[8]\,
      O => empty_carry_i_2_n_0
    );
empty_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[4]\,
      I1 => rd_ptr_reg_rep(4),
      I2 => \wr_ptr_reg_n_0_[3]\,
      I3 => rd_ptr_reg_rep(3),
      I4 => rd_ptr_reg_rep(5),
      I5 => \wr_ptr_reg_n_0_[5]\,
      O => empty_carry_i_3_n_0
    );
empty_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[1]\,
      I1 => rd_ptr_reg_rep(1),
      I2 => \wr_ptr_reg_n_0_[0]\,
      I3 => rd_ptr_reg_rep(0),
      I4 => rd_ptr_reg_rep(2),
      I5 => \wr_ptr_reg_n_0_[2]\,
      O => empty_carry_i_4_n_0
    );
last_pix_in_row_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3 downto 2) => NLW_last_pix_in_row_carry_CO_UNCONNECTED(3 downto 2),
      CO(1) => \last_pix_in_row__1\,
      CO(0) => last_pix_in_row_carry_n_3,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_last_pix_in_row_carry_O_UNCONNECTED(3 downto 0),
      S(3 downto 2) => B"00",
      S(1) => last_pix_in_row_carry_i_1_n_0,
      S(0) => last_pix_in_row_carry_i_2_n_0
    );
last_pix_in_row_carry_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"10"
    )
        port map (
      I0 => pix_cnt_reg(5),
      I1 => pix_cnt_reg(4),
      I2 => pix_cnt_reg(3),
      O => last_pix_in_row_carry_i_1_n_0
    );
last_pix_in_row_carry_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => pix_cnt_reg(2),
      I1 => pix_cnt_reg(1),
      I2 => pix_cnt_reg(0),
      O => last_pix_in_row_carry_i_2_n_0
    );
last_row_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \last_row__3\,
      CO(2) => last_row_carry_n_1,
      CO(1) => last_row_carry_n_2,
      CO(0) => last_row_carry_n_3,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_last_row_carry_O_UNCONNECTED(3 downto 0),
      S(3) => last_row_carry_i_1_n_0,
      S(2) => last_row_carry_i_2_n_0,
      S(1) => last_row_carry_i_3_n_0,
      S(0) => last_row_carry_i_4_n_0
    );
last_row_carry_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => row_cnt_reg(9),
      O => last_row_carry_i_1_n_0
    );
last_row_carry_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"01"
    )
        port map (
      I0 => row_cnt_reg(8),
      I1 => row_cnt_reg(7),
      I2 => row_cnt_reg(6),
      O => last_row_carry_i_2_n_0
    );
last_row_carry_i_3: unisim.vcomponents.LUT3
    generic map(
      INIT => X"01"
    )
        port map (
      I0 => row_cnt_reg(5),
      I1 => row_cnt_reg(4),
      I2 => row_cnt_reg(3),
      O => last_row_carry_i_3_n_0
    );
last_row_carry_i_4: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => row_cnt_reg(2),
      I1 => row_cnt_reg(1),
      I2 => row_cnt_reg(0),
      O => last_row_carry_i_4_n_0
    );
mem_reg: unisim.vcomponents.RAMB18E1
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      INIT_A => X"00000",
      INIT_B => X"00000",
      RAM_MODE => "SDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 36,
      READ_WIDTH_B => 0,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"00000",
      SRVAL_B => X"00000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "READ_FIRST",
      WRITE_WIDTH_A => 0,
      WRITE_WIDTH_B => 36
    )
        port map (
      ADDRARDADDR(13 downto 5) => rd_ptr_reg_rep(8 downto 0),
      ADDRARDADDR(4 downto 0) => B"11111",
      ADDRBWRADDR(13) => \wr_ptr_reg_n_0_[8]\,
      ADDRBWRADDR(12) => \wr_ptr_reg_n_0_[7]\,
      ADDRBWRADDR(11) => \wr_ptr_reg_n_0_[6]\,
      ADDRBWRADDR(10) => \wr_ptr_reg_n_0_[5]\,
      ADDRBWRADDR(9) => \wr_ptr_reg_n_0_[4]\,
      ADDRBWRADDR(8) => \wr_ptr_reg_n_0_[3]\,
      ADDRBWRADDR(7) => \wr_ptr_reg_n_0_[2]\,
      ADDRBWRADDR(6) => \wr_ptr_reg_n_0_[1]\,
      ADDRBWRADDR(5) => \wr_ptr_reg_n_0_[0]\,
      ADDRBWRADDR(4 downto 0) => B"11111",
      CLKARDCLK => s01_axis_aclk,
      CLKBWRCLK => s01_axis_aclk,
      DIADI(15 downto 0) => rd_data(15 downto 0),
      DIBDI(15 downto 0) => rd_data(31 downto 16),
      DIPADIP(1 downto 0) => B"11",
      DIPBDIP(1 downto 0) => B"11",
      DOADO(15 downto 0) => m00_axis_tdata(15 downto 0),
      DOBDO(15 downto 0) => m00_axis_tdata(31 downto 16),
      DOPADOP(1 downto 0) => NLW_mem_reg_DOPADOP_UNCONNECTED(1 downto 0),
      DOPBDOP(1 downto 0) => NLW_mem_reg_DOPBDOP_UNCONNECTED(1 downto 0),
      ENARDEN => \mem_reg_i_1__0_n_0\,
      ENBWREN => mem_reg_0,
      REGCEAREGCE => '0',
      REGCEB => '0',
      RSTRAMARSTRAM => \^s01_axis_aresetn_0\,
      RSTRAMB => '0',
      RSTREGARSTREG => '0',
      RSTREGB => '0',
      WEA(1 downto 0) => B"00",
      WEBWE(3) => wr_accepted0,
      WEBWE(2) => wr_accepted0,
      WEBWE(1) => wr_accepted0,
      WEBWE(0) => wr_accepted0
    );
mem_reg_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000082AA0000"
    )
        port map (
      I0 => s01_axis_aresetn,
      I1 => \wr_ptr_reg_n_0_[9]\,
      I2 => rd_ptr_reg(9),
      I3 => full0,
      I4 => \FSM_onehot_br_state_reg[1]\,
      I5 => CO(0),
      O => s01_axis_aresetn_1
    );
\mem_reg_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"23FF"
    )
        port map (
      I0 => m00_axis_tready,
      I1 => empty,
      I2 => \^skid_valid_reg_0\,
      I3 => s01_axis_aresetn,
      O => \mem_reg_i_1__0_n_0\
    );
mem_reg_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s01_axis_aresetn,
      O => \^s01_axis_aresetn_0\
    );
mem_reg_i_3: unisim.vcomponents.LUT3
    generic map(
      INIT => X"D7"
    )
        port map (
      I0 => full0,
      I1 => rd_ptr_reg(9),
      I2 => \wr_ptr_reg_n_0_[9]\,
      O => wr_accepted0
    );
mem_reg_i_4: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => NLW_mem_reg_i_4_CO_UNCONNECTED(3),
      CO(2) => full0,
      CO(1) => mem_reg_i_4_n_2,
      CO(0) => mem_reg_i_4_n_3,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_mem_reg_i_4_O_UNCONNECTED(3 downto 0),
      S(3) => '0',
      S(2) => mem_reg_i_5_n_0,
      S(1) => mem_reg_i_6_n_0,
      S(0) => mem_reg_i_7_n_0
    );
mem_reg_i_5: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[7]\,
      I1 => rd_ptr_reg_rep(7),
      I2 => \wr_ptr_reg_n_0_[6]\,
      I3 => rd_ptr_reg_rep(6),
      I4 => rd_ptr_reg_rep(8),
      I5 => \wr_ptr_reg_n_0_[8]\,
      O => mem_reg_i_5_n_0
    );
mem_reg_i_6: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[4]\,
      I1 => rd_ptr_reg_rep(4),
      I2 => \wr_ptr_reg_n_0_[3]\,
      I3 => rd_ptr_reg_rep(3),
      I4 => rd_ptr_reg_rep(5),
      I5 => \wr_ptr_reg_n_0_[5]\,
      O => mem_reg_i_6_n_0
    );
mem_reg_i_7: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[1]\,
      I1 => rd_ptr_reg_rep(1),
      I2 => \wr_ptr_reg_n_0_[0]\,
      I3 => rd_ptr_reg_rep(0),
      I4 => rd_ptr_reg_rep(2),
      I5 => \wr_ptr_reg_n_0_[2]\,
      O => mem_reg_i_7_n_0
    );
\pix_cnt[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => pix_cnt_reg(0),
      O => \p_0_in__2\(0)
    );
\pix_cnt[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => pix_cnt_reg(0),
      I1 => pix_cnt_reg(1),
      O => \p_0_in__2\(1)
    );
\pix_cnt[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => pix_cnt_reg(0),
      I1 => pix_cnt_reg(1),
      I2 => pix_cnt_reg(2),
      O => \p_0_in__2\(2)
    );
\pix_cnt[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => pix_cnt_reg(1),
      I1 => pix_cnt_reg(0),
      I2 => pix_cnt_reg(2),
      I3 => pix_cnt_reg(3),
      O => \p_0_in__2\(3)
    );
\pix_cnt[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFF8000"
    )
        port map (
      I0 => pix_cnt_reg(2),
      I1 => pix_cnt_reg(0),
      I2 => pix_cnt_reg(1),
      I3 => pix_cnt_reg(3),
      I4 => pix_cnt_reg(4),
      O => \p_0_in__2\(4)
    );
\pix_cnt[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9F000000FFFFFFFF"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[9]\,
      I1 => rd_ptr_reg(9),
      I2 => full0,
      I3 => \last_pix_in_row__1\,
      I4 => mem_reg_0,
      I5 => s01_axis_aresetn,
      O => \pix_cnt[5]_i_1_n_0\
    );
\pix_cnt[5]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFF80000000"
    )
        port map (
      I0 => pix_cnt_reg(3),
      I1 => pix_cnt_reg(1),
      I2 => pix_cnt_reg(0),
      I3 => pix_cnt_reg(2),
      I4 => pix_cnt_reg(4),
      I5 => pix_cnt_reg(5),
      O => \p_0_in__2\(5)
    );
\pix_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__2\(0),
      Q => pix_cnt_reg(0),
      R => \pix_cnt[5]_i_1_n_0\
    );
\pix_cnt_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__2\(1),
      Q => pix_cnt_reg(1),
      R => \pix_cnt[5]_i_1_n_0\
    );
\pix_cnt_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__2\(2),
      Q => pix_cnt_reg(2),
      R => \pix_cnt[5]_i_1_n_0\
    );
\pix_cnt_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__2\(3),
      Q => pix_cnt_reg(3),
      R => \pix_cnt[5]_i_1_n_0\
    );
\pix_cnt_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__2\(4),
      Q => pix_cnt_reg(4),
      R => \pix_cnt[5]_i_1_n_0\
    );
\pix_cnt_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__2\(5),
      Q => pix_cnt_reg(5),
      R => \pix_cnt[5]_i_1_n_0\
    );
\rd_ptr[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => rd_ptr_reg_rep(0),
      O => \rd_ptr[0]_i_1_n_0\
    );
\rd_ptr[1]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => rd_ptr_reg_rep(0),
      I1 => rd_ptr_reg_rep(1),
      O => \rd_ptr[1]_i_1__0_n_0\
    );
\rd_ptr[2]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => rd_ptr_reg_rep(0),
      I1 => rd_ptr_reg_rep(1),
      I2 => rd_ptr_reg_rep(2),
      O => \rd_ptr[2]_i_1__0_n_0\
    );
\rd_ptr[3]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => rd_ptr_reg_rep(1),
      I1 => rd_ptr_reg_rep(0),
      I2 => rd_ptr_reg_rep(2),
      I3 => rd_ptr_reg_rep(3),
      O => \rd_ptr[3]_i_1__0_n_0\
    );
\rd_ptr[4]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFF8000"
    )
        port map (
      I0 => rd_ptr_reg_rep(2),
      I1 => rd_ptr_reg_rep(0),
      I2 => rd_ptr_reg_rep(1),
      I3 => rd_ptr_reg_rep(3),
      I4 => rd_ptr_reg_rep(4),
      O => \rd_ptr[4]_i_1__0_n_0\
    );
\rd_ptr[5]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFF80000000"
    )
        port map (
      I0 => rd_ptr_reg_rep(3),
      I1 => rd_ptr_reg_rep(1),
      I2 => rd_ptr_reg_rep(0),
      I3 => rd_ptr_reg_rep(2),
      I4 => rd_ptr_reg_rep(4),
      I5 => rd_ptr_reg_rep(5),
      O => \rd_ptr[5]_i_1__0_n_0\
    );
\rd_ptr[6]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \rd_ptr[9]_i_2__0_n_0\,
      I1 => rd_ptr_reg_rep(6),
      O => \rd_ptr[6]_i_1__0_n_0\
    );
\rd_ptr[7]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \rd_ptr[9]_i_2__0_n_0\,
      I1 => rd_ptr_reg_rep(6),
      I2 => rd_ptr_reg_rep(7),
      O => \rd_ptr[7]_i_1__0_n_0\
    );
\rd_ptr[8]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => rd_ptr_reg_rep(6),
      I1 => \rd_ptr[9]_i_2__0_n_0\,
      I2 => rd_ptr_reg_rep(7),
      I3 => rd_ptr_reg_rep(8),
      O => \rd_ptr[8]_i_1__0_n_0\
    );
\rd_ptr[9]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFF8000"
    )
        port map (
      I0 => rd_ptr_reg_rep(7),
      I1 => \rd_ptr[9]_i_2__0_n_0\,
      I2 => rd_ptr_reg_rep(6),
      I3 => rd_ptr_reg_rep(8),
      I4 => rd_ptr_reg(9),
      O => \p_0_in__0\(9)
    );
\rd_ptr[9]_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => rd_ptr_reg_rep(5),
      I1 => rd_ptr_reg_rep(3),
      I2 => rd_ptr_reg_rep(1),
      I3 => rd_ptr_reg_rep(0),
      I4 => rd_ptr_reg_rep(2),
      I5 => rd_ptr_reg_rep(4),
      O => \rd_ptr[9]_i_2__0_n_0\
    );
\rd_ptr_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_en,
      D => \rd_ptr[0]_i_1_n_0\,
      Q => rd_ptr_reg_rep(0),
      R => \^s01_axis_aresetn_0\
    );
\rd_ptr_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_en,
      D => \rd_ptr[1]_i_1__0_n_0\,
      Q => rd_ptr_reg_rep(1),
      R => \^s01_axis_aresetn_0\
    );
\rd_ptr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_en,
      D => \rd_ptr[2]_i_1__0_n_0\,
      Q => rd_ptr_reg_rep(2),
      R => \^s01_axis_aresetn_0\
    );
\rd_ptr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_en,
      D => \rd_ptr[3]_i_1__0_n_0\,
      Q => rd_ptr_reg_rep(3),
      R => \^s01_axis_aresetn_0\
    );
\rd_ptr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_en,
      D => \rd_ptr[4]_i_1__0_n_0\,
      Q => rd_ptr_reg_rep(4),
      R => \^s01_axis_aresetn_0\
    );
\rd_ptr_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_en,
      D => \rd_ptr[5]_i_1__0_n_0\,
      Q => rd_ptr_reg_rep(5),
      R => \^s01_axis_aresetn_0\
    );
\rd_ptr_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_en,
      D => \rd_ptr[6]_i_1__0_n_0\,
      Q => rd_ptr_reg_rep(6),
      R => \^s01_axis_aresetn_0\
    );
\rd_ptr_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_en,
      D => \rd_ptr[7]_i_1__0_n_0\,
      Q => rd_ptr_reg_rep(7),
      R => \^s01_axis_aresetn_0\
    );
\rd_ptr_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_en,
      D => \rd_ptr[8]_i_1__0_n_0\,
      Q => rd_ptr_reg_rep(8),
      R => \^s01_axis_aresetn_0\
    );
\rd_ptr_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_en,
      D => \p_0_in__0\(9),
      Q => rd_ptr_reg(9),
      R => \^s01_axis_aresetn_0\
    );
\rd_ptr_rep[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"44040444"
    )
        port map (
      I0 => CO(0),
      I1 => \FSM_onehot_br_state_reg[1]\,
      I2 => full0,
      I3 => rd_ptr_reg(9),
      I4 => \wr_ptr_reg_n_0_[9]\,
      O => \^rd_ptr0\
    );
\row_cnt[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => row_cnt_reg(0),
      O => \p_0_in__3\(0)
    );
\row_cnt[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => row_cnt_reg(0),
      I1 => row_cnt_reg(1),
      O => \p_0_in__3\(1)
    );
\row_cnt[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => row_cnt_reg(0),
      I1 => row_cnt_reg(1),
      I2 => row_cnt_reg(2),
      O => \p_0_in__3\(2)
    );
\row_cnt[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => row_cnt_reg(1),
      I1 => row_cnt_reg(0),
      I2 => row_cnt_reg(2),
      I3 => row_cnt_reg(3),
      O => \p_0_in__3\(3)
    );
\row_cnt[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFF8000"
    )
        port map (
      I0 => row_cnt_reg(2),
      I1 => row_cnt_reg(0),
      I2 => row_cnt_reg(1),
      I3 => row_cnt_reg(3),
      I4 => row_cnt_reg(4),
      O => \p_0_in__3\(4)
    );
\row_cnt[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFF80000000"
    )
        port map (
      I0 => row_cnt_reg(3),
      I1 => row_cnt_reg(1),
      I2 => row_cnt_reg(0),
      I3 => row_cnt_reg(2),
      I4 => row_cnt_reg(4),
      I5 => row_cnt_reg(5),
      O => \p_0_in__3\(5)
    );
\row_cnt[6]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \row_cnt[9]_i_4_n_0\,
      I1 => row_cnt_reg(6),
      O => \p_0_in__3\(6)
    );
\row_cnt[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \row_cnt[9]_i_4_n_0\,
      I1 => row_cnt_reg(6),
      I2 => row_cnt_reg(7),
      O => \p_0_in__3\(7)
    );
\row_cnt[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => row_cnt_reg(6),
      I1 => \row_cnt[9]_i_4_n_0\,
      I2 => row_cnt_reg(7),
      I3 => row_cnt_reg(8),
      O => \p_0_in__3\(8)
    );
\row_cnt[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8F"
    )
        port map (
      I0 => \last_row__3\,
      I1 => p_3_in,
      I2 => s01_axis_aresetn,
      O => \row_cnt[9]_i_1_n_0\
    );
\row_cnt[9]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"88080888"
    )
        port map (
      I0 => mem_reg_0,
      I1 => \last_pix_in_row__1\,
      I2 => full0,
      I3 => rd_ptr_reg(9),
      I4 => \wr_ptr_reg_n_0_[9]\,
      O => p_3_in
    );
\row_cnt[9]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFF8000"
    )
        port map (
      I0 => row_cnt_reg(7),
      I1 => \row_cnt[9]_i_4_n_0\,
      I2 => row_cnt_reg(6),
      I3 => row_cnt_reg(8),
      I4 => row_cnt_reg(9),
      O => \p_0_in__3\(9)
    );
\row_cnt[9]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => row_cnt_reg(5),
      I1 => row_cnt_reg(3),
      I2 => row_cnt_reg(1),
      I3 => row_cnt_reg(0),
      I4 => row_cnt_reg(2),
      I5 => row_cnt_reg(4),
      O => \row_cnt[9]_i_4_n_0\
    );
\row_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => p_3_in,
      D => \p_0_in__3\(0),
      Q => row_cnt_reg(0),
      R => \row_cnt[9]_i_1_n_0\
    );
\row_cnt_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => p_3_in,
      D => \p_0_in__3\(1),
      Q => row_cnt_reg(1),
      R => \row_cnt[9]_i_1_n_0\
    );
\row_cnt_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => p_3_in,
      D => \p_0_in__3\(2),
      Q => row_cnt_reg(2),
      R => \row_cnt[9]_i_1_n_0\
    );
\row_cnt_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => p_3_in,
      D => \p_0_in__3\(3),
      Q => row_cnt_reg(3),
      R => \row_cnt[9]_i_1_n_0\
    );
\row_cnt_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => p_3_in,
      D => \p_0_in__3\(4),
      Q => row_cnt_reg(4),
      R => \row_cnt[9]_i_1_n_0\
    );
\row_cnt_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => p_3_in,
      D => \p_0_in__3\(5),
      Q => row_cnt_reg(5),
      R => \row_cnt[9]_i_1_n_0\
    );
\row_cnt_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => p_3_in,
      D => \p_0_in__3\(6),
      Q => row_cnt_reg(6),
      R => \row_cnt[9]_i_1_n_0\
    );
\row_cnt_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => p_3_in,
      D => \p_0_in__3\(7),
      Q => row_cnt_reg(7),
      R => \row_cnt[9]_i_1_n_0\
    );
\row_cnt_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => p_3_in,
      D => \p_0_in__3\(8),
      Q => row_cnt_reg(8),
      R => \row_cnt[9]_i_1_n_0\
    );
\row_cnt_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => p_3_in,
      D => \p_0_in__3\(9),
      Q => row_cnt_reg(9),
      R => \row_cnt[9]_i_1_n_0\
    );
skid_last_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"31"
    )
        port map (
      I0 => \^skid_valid_reg_0\,
      I1 => empty,
      I2 => m00_axis_tready,
      O => rd_en
    );
skid_last_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => tlast_mem_reg_384_511_0_0_n_0,
      I1 => tlast_mem_reg_256_383_0_0_n_0,
      I2 => rd_ptr_reg_rep(8),
      I3 => tlast_mem_reg_128_255_0_0_n_0,
      I4 => rd_ptr_reg_rep(7),
      I5 => tlast_mem_reg_0_127_0_0_n_0,
      O => skid_last0
    );
skid_last_reg: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_en,
      D => skid_last0,
      Q => m00_axis_tlast,
      R => \^s01_axis_aresetn_0\
    );
skid_valid_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3B00"
    )
        port map (
      I0 => \^skid_valid_reg_0\,
      I1 => empty,
      I2 => m00_axis_tready,
      I3 => s01_axis_aresetn,
      O => skid_valid_i_1_n_0
    );
skid_valid_reg: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => '1',
      D => skid_valid_i_1_n_0,
      Q => \^skid_valid_reg_0\,
      R => '0'
    );
tlast_mem_reg_0_127_0_0: unisim.vcomponents.RAM128X1D
     port map (
      A(6) => \wr_ptr_reg_n_0_[6]\,
      A(5) => \wr_ptr_reg_n_0_[5]\,
      A(4) => \wr_ptr_reg_n_0_[4]\,
      A(3) => \wr_ptr_reg_n_0_[3]\,
      A(2) => \wr_ptr_reg_n_0_[2]\,
      A(1) => \wr_ptr_reg_n_0_[1]\,
      A(0) => \wr_ptr_reg_n_0_[0]\,
      D => tlast_stored,
      DPO => tlast_mem_reg_0_127_0_0_n_0,
      DPRA(6 downto 0) => rd_ptr_reg_rep(6 downto 0),
      SPO => tlast_mem_reg_0_127_0_0_n_1,
      WCLK => s01_axis_aclk,
      WE => tlast_mem_reg_0_127_0_0_i_2_n_0
    );
tlast_mem_reg_0_127_0_0_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"C8"
    )
        port map (
      I0 => p_3_in,
      I1 => \last_row__3\,
      I2 => br_last,
      O => tlast_stored
    );
tlast_mem_reg_0_127_0_0_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000009F00"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[9]\,
      I1 => rd_ptr_reg(9),
      I2 => full0,
      I3 => mem_reg_0,
      I4 => \wr_ptr_reg_n_0_[7]\,
      I5 => \wr_ptr_reg_n_0_[8]\,
      O => tlast_mem_reg_0_127_0_0_i_2_n_0
    );
tlast_mem_reg_128_255_0_0: unisim.vcomponents.RAM128X1D
     port map (
      A(6) => \wr_ptr_reg_n_0_[6]\,
      A(5) => \wr_ptr_reg_n_0_[5]\,
      A(4) => \wr_ptr_reg_n_0_[4]\,
      A(3) => \wr_ptr_reg_n_0_[3]\,
      A(2) => \wr_ptr_reg_n_0_[2]\,
      A(1) => \wr_ptr_reg_n_0_[1]\,
      A(0) => \wr_ptr_reg_n_0_[0]\,
      D => tlast_stored,
      DPO => tlast_mem_reg_128_255_0_0_n_0,
      DPRA(6 downto 0) => rd_ptr_reg_rep(6 downto 0),
      SPO => tlast_mem_reg_128_255_0_0_n_1,
      WCLK => s01_axis_aclk,
      WE => tlast_mem_reg_128_255_0_0_i_1_n_0
    );
tlast_mem_reg_128_255_0_0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4040004000404040"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[8]\,
      I1 => \wr_ptr_reg_n_0_[7]\,
      I2 => mem_reg_0,
      I3 => full0,
      I4 => rd_ptr_reg(9),
      I5 => \wr_ptr_reg_n_0_[9]\,
      O => tlast_mem_reg_128_255_0_0_i_1_n_0
    );
tlast_mem_reg_256_383_0_0: unisim.vcomponents.RAM128X1D
     port map (
      A(6) => \wr_ptr_reg_n_0_[6]\,
      A(5) => \wr_ptr_reg_n_0_[5]\,
      A(4) => \wr_ptr_reg_n_0_[4]\,
      A(3) => \wr_ptr_reg_n_0_[3]\,
      A(2) => \wr_ptr_reg_n_0_[2]\,
      A(1) => \wr_ptr_reg_n_0_[1]\,
      A(0) => \wr_ptr_reg_n_0_[0]\,
      D => tlast_stored,
      DPO => tlast_mem_reg_256_383_0_0_n_0,
      DPRA(6 downto 0) => rd_ptr_reg_rep(6 downto 0),
      SPO => tlast_mem_reg_256_383_0_0_n_1,
      WCLK => s01_axis_aclk,
      WE => tlast_mem_reg_256_383_0_0_i_1_n_0
    );
tlast_mem_reg_256_383_0_0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4040004000404040"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[7]\,
      I1 => \wr_ptr_reg_n_0_[8]\,
      I2 => mem_reg_0,
      I3 => full0,
      I4 => rd_ptr_reg(9),
      I5 => \wr_ptr_reg_n_0_[9]\,
      O => tlast_mem_reg_256_383_0_0_i_1_n_0
    );
tlast_mem_reg_384_511_0_0: unisim.vcomponents.RAM128X1D
     port map (
      A(6) => \wr_ptr_reg_n_0_[6]\,
      A(5) => \wr_ptr_reg_n_0_[5]\,
      A(4) => \wr_ptr_reg_n_0_[4]\,
      A(3) => \wr_ptr_reg_n_0_[3]\,
      A(2) => \wr_ptr_reg_n_0_[2]\,
      A(1) => \wr_ptr_reg_n_0_[1]\,
      A(0) => \wr_ptr_reg_n_0_[0]\,
      D => tlast_stored,
      DPO => tlast_mem_reg_384_511_0_0_n_0,
      DPRA(6 downto 0) => rd_ptr_reg_rep(6 downto 0),
      SPO => tlast_mem_reg_384_511_0_0_n_1,
      WCLK => s01_axis_aclk,
      WE => tlast_mem_reg_384_511_0_0_i_1_n_0
    );
tlast_mem_reg_384_511_0_0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9F00000000000000"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[9]\,
      I1 => rd_ptr_reg(9),
      I2 => full0,
      I3 => mem_reg_0,
      I4 => \wr_ptr_reg_n_0_[7]\,
      I5 => \wr_ptr_reg_n_0_[8]\,
      O => tlast_mem_reg_384_511_0_0_i_1_n_0
    );
\wr_ptr[0]_i_1__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[0]\,
      O => \p_0_in__1\(0)
    );
\wr_ptr[1]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[0]\,
      I1 => \wr_ptr_reg_n_0_[1]\,
      O => \p_0_in__1\(1)
    );
\wr_ptr[2]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[0]\,
      I1 => \wr_ptr_reg_n_0_[1]\,
      I2 => \wr_ptr_reg_n_0_[2]\,
      O => \p_0_in__1\(2)
    );
\wr_ptr[3]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[1]\,
      I1 => \wr_ptr_reg_n_0_[0]\,
      I2 => \wr_ptr_reg_n_0_[2]\,
      I3 => \wr_ptr_reg_n_0_[3]\,
      O => \p_0_in__1\(3)
    );
\wr_ptr[4]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFF8000"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[2]\,
      I1 => \wr_ptr_reg_n_0_[0]\,
      I2 => \wr_ptr_reg_n_0_[1]\,
      I3 => \wr_ptr_reg_n_0_[3]\,
      I4 => \wr_ptr_reg_n_0_[4]\,
      O => \p_0_in__1\(4)
    );
\wr_ptr[5]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFF80000000"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[3]\,
      I1 => \wr_ptr_reg_n_0_[1]\,
      I2 => \wr_ptr_reg_n_0_[0]\,
      I3 => \wr_ptr_reg_n_0_[2]\,
      I4 => \wr_ptr_reg_n_0_[4]\,
      I5 => \wr_ptr_reg_n_0_[5]\,
      O => \p_0_in__1\(5)
    );
\wr_ptr[6]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \wr_ptr[9]_i_3__0_n_0\,
      I1 => \wr_ptr_reg_n_0_[6]\,
      O => \p_0_in__1\(6)
    );
\wr_ptr[7]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \wr_ptr[9]_i_3__0_n_0\,
      I1 => \wr_ptr_reg_n_0_[6]\,
      I2 => \wr_ptr_reg_n_0_[7]\,
      O => \p_0_in__1\(7)
    );
\wr_ptr[8]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[6]\,
      I1 => \wr_ptr[9]_i_3__0_n_0\,
      I2 => \wr_ptr_reg_n_0_[7]\,
      I3 => \wr_ptr_reg_n_0_[8]\,
      O => \p_0_in__1\(8)
    );
\wr_ptr[9]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A22A"
    )
        port map (
      I0 => mem_reg_0,
      I1 => full0,
      I2 => rd_ptr_reg(9),
      I3 => \wr_ptr_reg_n_0_[9]\,
      O => wr_accepted
    );
\wr_ptr[9]_i_2__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFF8000"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[7]\,
      I1 => \wr_ptr[9]_i_3__0_n_0\,
      I2 => \wr_ptr_reg_n_0_[6]\,
      I3 => \wr_ptr_reg_n_0_[8]\,
      I4 => \wr_ptr_reg_n_0_[9]\,
      O => \p_0_in__1\(9)
    );
\wr_ptr[9]_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[5]\,
      I1 => \wr_ptr_reg_n_0_[3]\,
      I2 => \wr_ptr_reg_n_0_[1]\,
      I3 => \wr_ptr_reg_n_0_[0]\,
      I4 => \wr_ptr_reg_n_0_[2]\,
      I5 => \wr_ptr_reg_n_0_[4]\,
      O => \wr_ptr[9]_i_3__0_n_0\
    );
\wr_ptr_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__1\(0),
      Q => \wr_ptr_reg_n_0_[0]\,
      R => \^s01_axis_aresetn_0\
    );
\wr_ptr_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__1\(1),
      Q => \wr_ptr_reg_n_0_[1]\,
      R => \^s01_axis_aresetn_0\
    );
\wr_ptr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__1\(2),
      Q => \wr_ptr_reg_n_0_[2]\,
      R => \^s01_axis_aresetn_0\
    );
\wr_ptr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__1\(3),
      Q => \wr_ptr_reg_n_0_[3]\,
      R => \^s01_axis_aresetn_0\
    );
\wr_ptr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__1\(4),
      Q => \wr_ptr_reg_n_0_[4]\,
      R => \^s01_axis_aresetn_0\
    );
\wr_ptr_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__1\(5),
      Q => \wr_ptr_reg_n_0_[5]\,
      R => \^s01_axis_aresetn_0\
    );
\wr_ptr_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__1\(6),
      Q => \wr_ptr_reg_n_0_[6]\,
      R => \^s01_axis_aresetn_0\
    );
\wr_ptr_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__1\(7),
      Q => \wr_ptr_reg_n_0_[7]\,
      R => \^s01_axis_aresetn_0\
    );
\wr_ptr_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__1\(8),
      Q => \wr_ptr_reg_n_0_[8]\,
      R => \^s01_axis_aresetn_0\
    );
\wr_ptr_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_accepted,
      D => \p_0_in__1\(9),
      Q => \wr_ptr_reg_n_0_[9]\,
      R => \^s01_axis_aresetn_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_axis_fifo_s is
  port (
    rd_data : out STD_LOGIC_VECTOR ( 31 downto 0 );
    WEBWE : out STD_LOGIC_VECTOR ( 0 to 0 );
    rd_last : out STD_LOGIC;
    CO : out STD_LOGIC_VECTOR ( 0 to 0 );
    \wr_ptr_reg[9]_0\ : in STD_LOGIC;
    rd_ptr0 : in STD_LOGIC;
    s01_axis_aclk : in STD_LOGIC;
    mem_reg_0 : in STD_LOGIC;
    s01_axis_tvalid : in STD_LOGIC;
    br_data : in STD_LOGIC_VECTOR ( 0 to 0 );
    s01_axis_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s01_axis_tlast : in STD_LOGIC;
    s01_axis_aresetn : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_axis_fifo_s;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_axis_fifo_s is
  signal \^webwe\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \empty_carry_i_1__0_n_0\ : STD_LOGIC;
  signal \empty_carry_i_2__0_n_0\ : STD_LOGIC;
  signal \empty_carry_i_3__0_n_0\ : STD_LOGIC;
  signal \empty_carry_i_4__0_n_0\ : STD_LOGIC;
  signal empty_carry_n_1 : STD_LOGIC;
  signal empty_carry_n_2 : STD_LOGIC;
  signal empty_carry_n_3 : STD_LOGIC;
  signal full0 : STD_LOGIC;
  signal p_0_in : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal p_1_in : STD_LOGIC;
  signal \rd_ptr[0]_i_1__0_n_0\ : STD_LOGIC;
  signal \rd_ptr[1]_i_1_n_0\ : STD_LOGIC;
  signal \rd_ptr[2]_i_1_n_0\ : STD_LOGIC;
  signal \rd_ptr[3]_i_1_n_0\ : STD_LOGIC;
  signal \rd_ptr[4]_i_1_n_0\ : STD_LOGIC;
  signal \rd_ptr[5]_i_1_n_0\ : STD_LOGIC;
  signal \rd_ptr[6]_i_1_n_0\ : STD_LOGIC;
  signal \rd_ptr[6]_i_2_n_0\ : STD_LOGIC;
  signal \rd_ptr[7]_i_1_n_0\ : STD_LOGIC;
  signal \rd_ptr[8]_i_1_n_0\ : STD_LOGIC;
  signal \rd_ptr[9]_i_1__0_n_0\ : STD_LOGIC;
  signal \rd_ptr[9]_i_2_n_0\ : STD_LOGIC;
  signal rd_ptr_reg : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal rd_ptr_reg_rep : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \rd_ptr_rep[0]_i_2_n_0\ : STD_LOGIC;
  signal s01_axis_tready_INST_0_i_1_n_2 : STD_LOGIC;
  signal s01_axis_tready_INST_0_i_1_n_3 : STD_LOGIC;
  signal s01_axis_tready_INST_0_i_2_n_0 : STD_LOGIC;
  signal s01_axis_tready_INST_0_i_3_n_0 : STD_LOGIC;
  signal s01_axis_tready_INST_0_i_4_n_0 : STD_LOGIC;
  signal wr_en : STD_LOGIC;
  signal \wr_ptr[9]_i_3_n_0\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[0]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[1]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[2]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[3]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[4]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[5]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[6]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[7]\ : STD_LOGIC;
  signal \wr_ptr_reg_n_0_[8]\ : STD_LOGIC;
  signal NLW_empty_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_mem_reg_DOPADOP_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_mem_reg_DOPBDOP_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_s01_axis_tready_INST_0_i_1_CO_UNCONNECTED : STD_LOGIC_VECTOR ( 3 to 3 );
  signal NLW_s01_axis_tready_INST_0_i_1_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ : string;
  attribute \MEM.PORTA.DATA_BIT_LAYOUT\ of mem_reg : label is "p1_d32";
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ : string;
  attribute \MEM.PORTB.DATA_BIT_LAYOUT\ of mem_reg : label is "p1_d32";
  attribute METHODOLOGY_DRC_VIOS : string;
  attribute METHODOLOGY_DRC_VIOS of mem_reg : label is "";
  attribute RTL_RAM_BITS : integer;
  attribute RTL_RAM_BITS of mem_reg : label is 16896;
  attribute RTL_RAM_NAME : string;
  attribute RTL_RAM_NAME of mem_reg : label is "loopBackFifoBD_lpbk_tst_0_0/inst/u_in_fifo/mem_reg";
  attribute RTL_RAM_STYLE : string;
  attribute RTL_RAM_STYLE of mem_reg : label is "block";
  attribute RTL_RAM_TYPE : string;
  attribute RTL_RAM_TYPE of mem_reg : label is "RAM_SDP";
  attribute ram_addr_begin : integer;
  attribute ram_addr_begin of mem_reg : label is 0;
  attribute ram_addr_end : integer;
  attribute ram_addr_end of mem_reg : label is 511;
  attribute ram_offset : integer;
  attribute ram_offset of mem_reg : label is 0;
  attribute ram_slice_begin : integer;
  attribute ram_slice_begin of mem_reg : label is 0;
  attribute ram_slice_end : integer;
  attribute ram_slice_end of mem_reg : label is 32;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \rd_ptr[1]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \rd_ptr[2]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \rd_ptr[3]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \rd_ptr[4]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \rd_ptr[6]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \rd_ptr[7]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \rd_ptr[8]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \rd_ptr[9]_i_2\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \wr_ptr[1]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \wr_ptr[2]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \wr_ptr[3]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \wr_ptr[4]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \wr_ptr[6]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \wr_ptr[7]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \wr_ptr[8]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \wr_ptr[9]_i_2\ : label is "soft_lutpair2";
begin
  WEBWE(0) <= \^webwe\(0);
empty_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => CO(0),
      CO(2) => empty_carry_n_1,
      CO(1) => empty_carry_n_2,
      CO(0) => empty_carry_n_3,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_empty_carry_O_UNCONNECTED(3 downto 0),
      S(3) => \empty_carry_i_1__0_n_0\,
      S(2) => \empty_carry_i_2__0_n_0\,
      S(1) => \empty_carry_i_3__0_n_0\,
      S(0) => \empty_carry_i_4__0_n_0\
    );
\empty_carry_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => rd_ptr_reg(9),
      I1 => p_1_in,
      O => \empty_carry_i_1__0_n_0\
    );
\empty_carry_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[7]\,
      I1 => rd_ptr_reg(7),
      I2 => \wr_ptr_reg_n_0_[6]\,
      I3 => rd_ptr_reg(6),
      I4 => rd_ptr_reg(8),
      I5 => \wr_ptr_reg_n_0_[8]\,
      O => \empty_carry_i_2__0_n_0\
    );
\empty_carry_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[4]\,
      I1 => rd_ptr_reg(4),
      I2 => \wr_ptr_reg_n_0_[3]\,
      I3 => rd_ptr_reg(3),
      I4 => rd_ptr_reg(5),
      I5 => \wr_ptr_reg_n_0_[5]\,
      O => \empty_carry_i_3__0_n_0\
    );
\empty_carry_i_4__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[1]\,
      I1 => rd_ptr_reg(1),
      I2 => \wr_ptr_reg_n_0_[0]\,
      I3 => rd_ptr_reg(0),
      I4 => rd_ptr_reg(2),
      I5 => \wr_ptr_reg_n_0_[2]\,
      O => \empty_carry_i_4__0_n_0\
    );
mem_reg: unisim.vcomponents.RAMB18E1
    generic map(
      DOA_REG => 1,
      DOB_REG => 1,
      INIT_A => X"00000",
      INIT_B => X"00000",
      RAM_MODE => "SDP",
      RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
      READ_WIDTH_A => 36,
      READ_WIDTH_B => 0,
      RSTREG_PRIORITY_A => "RSTREG",
      RSTREG_PRIORITY_B => "RSTREG",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "7SERIES",
      SRVAL_A => X"00000",
      SRVAL_B => X"00000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "READ_FIRST",
      WRITE_WIDTH_A => 0,
      WRITE_WIDTH_B => 36
    )
        port map (
      ADDRARDADDR(13 downto 6) => rd_ptr_reg(8 downto 1),
      ADDRARDADDR(5) => rd_ptr_reg_rep(0),
      ADDRARDADDR(4 downto 0) => B"11111",
      ADDRBWRADDR(13) => \wr_ptr_reg_n_0_[8]\,
      ADDRBWRADDR(12) => \wr_ptr_reg_n_0_[7]\,
      ADDRBWRADDR(11) => \wr_ptr_reg_n_0_[6]\,
      ADDRBWRADDR(10) => \wr_ptr_reg_n_0_[5]\,
      ADDRBWRADDR(9) => \wr_ptr_reg_n_0_[4]\,
      ADDRBWRADDR(8) => \wr_ptr_reg_n_0_[3]\,
      ADDRBWRADDR(7) => \wr_ptr_reg_n_0_[2]\,
      ADDRBWRADDR(6) => \wr_ptr_reg_n_0_[1]\,
      ADDRBWRADDR(5) => \wr_ptr_reg_n_0_[0]\,
      ADDRBWRADDR(4 downto 0) => B"11111",
      CLKARDCLK => s01_axis_aclk,
      CLKBWRCLK => s01_axis_aclk,
      DIADI(15 downto 0) => s01_axis_tdata(15 downto 0),
      DIBDI(15 downto 0) => s01_axis_tdata(31 downto 16),
      DIPADIP(1) => '1',
      DIPADIP(0) => s01_axis_tlast,
      DIPBDIP(1 downto 0) => B"11",
      DOADO(15 downto 0) => rd_data(15 downto 0),
      DOBDO(15 downto 0) => rd_data(31 downto 16),
      DOPADOP(1 downto 0) => NLW_mem_reg_DOPADOP_UNCONNECTED(1 downto 0),
      DOPBDOP(1 downto 0) => NLW_mem_reg_DOPBDOP_UNCONNECTED(1 downto 0),
      ENARDEN => mem_reg_0,
      ENBWREN => s01_axis_tvalid,
      REGCEAREGCE => br_data(0),
      REGCEB => '0',
      RSTRAMARSTRAM => '0',
      RSTRAMB => '0',
      RSTREGARSTREG => \wr_ptr_reg[9]_0\,
      RSTREGB => '0',
      WEA(1 downto 0) => B"00",
      WEBWE(3) => \^webwe\(0),
      WEBWE(2) => \^webwe\(0),
      WEBWE(1) => \^webwe\(0),
      WEBWE(0) => \^webwe\(0)
    );
rd_last_reg: unisim.vcomponents.FDSE
     port map (
      C => s01_axis_aclk,
      CE => rd_ptr0,
      D => '0',
      Q => rd_last,
      S => \wr_ptr_reg[9]_0\
    );
\rd_ptr[0]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"60"
    )
        port map (
      I0 => rd_ptr_reg(0),
      I1 => rd_ptr0,
      I2 => s01_axis_aresetn,
      O => \rd_ptr[0]_i_1__0_n_0\
    );
\rd_ptr[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => rd_ptr_reg(0),
      I1 => rd_ptr_reg(1),
      O => \rd_ptr[1]_i_1_n_0\
    );
\rd_ptr[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => rd_ptr_reg(0),
      I1 => rd_ptr_reg(1),
      I2 => rd_ptr_reg(2),
      O => \rd_ptr[2]_i_1_n_0\
    );
\rd_ptr[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => rd_ptr_reg(1),
      I1 => rd_ptr_reg(0),
      I2 => rd_ptr_reg(2),
      I3 => rd_ptr_reg(3),
      O => \rd_ptr[3]_i_1_n_0\
    );
\rd_ptr[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFF8000"
    )
        port map (
      I0 => rd_ptr_reg(2),
      I1 => rd_ptr_reg(0),
      I2 => rd_ptr_reg(1),
      I3 => rd_ptr_reg(3),
      I4 => rd_ptr_reg(4),
      O => \rd_ptr[4]_i_1_n_0\
    );
\rd_ptr[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFF80000000"
    )
        port map (
      I0 => rd_ptr_reg(3),
      I1 => rd_ptr_reg(1),
      I2 => rd_ptr_reg(0),
      I3 => rd_ptr_reg(2),
      I4 => rd_ptr_reg(4),
      I5 => rd_ptr_reg(5),
      O => \rd_ptr[5]_i_1_n_0\
    );
\rd_ptr[6]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \rd_ptr[6]_i_2_n_0\,
      I1 => rd_ptr_reg(6),
      O => \rd_ptr[6]_i_1_n_0\
    );
\rd_ptr[6]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => rd_ptr_reg(5),
      I1 => rd_ptr_reg(3),
      I2 => rd_ptr_reg(1),
      I3 => rd_ptr_reg(0),
      I4 => rd_ptr_reg(2),
      I5 => rd_ptr_reg(4),
      O => \rd_ptr[6]_i_2_n_0\
    );
\rd_ptr[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \rd_ptr[6]_i_2_n_0\,
      I1 => rd_ptr_reg(6),
      I2 => rd_ptr_reg(7),
      O => \rd_ptr[7]_i_1_n_0\
    );
\rd_ptr[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => rd_ptr_reg(6),
      I1 => \rd_ptr[6]_i_2_n_0\,
      I2 => rd_ptr_reg(7),
      I3 => rd_ptr_reg(8),
      O => \rd_ptr[8]_i_1_n_0\
    );
\rd_ptr[9]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAA0000"
    )
        port map (
      I0 => rd_ptr_reg(9),
      I1 => \rd_ptr[9]_i_2_n_0\,
      I2 => rd_ptr_reg(8),
      I3 => rd_ptr0,
      I4 => s01_axis_aresetn,
      O => \rd_ptr[9]_i_1__0_n_0\
    );
\rd_ptr[9]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => rd_ptr_reg(7),
      I1 => \rd_ptr[6]_i_2_n_0\,
      I2 => rd_ptr_reg(6),
      O => \rd_ptr[9]_i_2_n_0\
    );
\rd_ptr_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => '1',
      D => \rd_ptr[0]_i_1__0_n_0\,
      Q => rd_ptr_reg(0),
      R => '0'
    );
\rd_ptr_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_ptr0,
      D => \rd_ptr[1]_i_1_n_0\,
      Q => rd_ptr_reg(1),
      R => \wr_ptr_reg[9]_0\
    );
\rd_ptr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_ptr0,
      D => \rd_ptr[2]_i_1_n_0\,
      Q => rd_ptr_reg(2),
      R => \wr_ptr_reg[9]_0\
    );
\rd_ptr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_ptr0,
      D => \rd_ptr[3]_i_1_n_0\,
      Q => rd_ptr_reg(3),
      R => \wr_ptr_reg[9]_0\
    );
\rd_ptr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_ptr0,
      D => \rd_ptr[4]_i_1_n_0\,
      Q => rd_ptr_reg(4),
      R => \wr_ptr_reg[9]_0\
    );
\rd_ptr_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_ptr0,
      D => \rd_ptr[5]_i_1_n_0\,
      Q => rd_ptr_reg(5),
      R => \wr_ptr_reg[9]_0\
    );
\rd_ptr_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_ptr0,
      D => \rd_ptr[6]_i_1_n_0\,
      Q => rd_ptr_reg(6),
      R => \wr_ptr_reg[9]_0\
    );
\rd_ptr_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_ptr0,
      D => \rd_ptr[7]_i_1_n_0\,
      Q => rd_ptr_reg(7),
      R => \wr_ptr_reg[9]_0\
    );
\rd_ptr_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_ptr0,
      D => \rd_ptr[8]_i_1_n_0\,
      Q => rd_ptr_reg(8),
      R => \wr_ptr_reg[9]_0\
    );
\rd_ptr_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => '1',
      D => \rd_ptr[9]_i_1__0_n_0\,
      Q => rd_ptr_reg(9),
      R => '0'
    );
\rd_ptr_reg_rep[0]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => rd_ptr0,
      D => \rd_ptr_rep[0]_i_2_n_0\,
      Q => rd_ptr_reg_rep(0),
      R => \wr_ptr_reg[9]_0\
    );
\rd_ptr_rep[0]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => rd_ptr_reg(0),
      O => \rd_ptr_rep[0]_i_2_n_0\
    );
s01_axis_tready_INST_0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"9F"
    )
        port map (
      I0 => p_1_in,
      I1 => rd_ptr_reg(9),
      I2 => full0,
      O => \^webwe\(0)
    );
s01_axis_tready_INST_0_i_1: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => NLW_s01_axis_tready_INST_0_i_1_CO_UNCONNECTED(3),
      CO(2) => full0,
      CO(1) => s01_axis_tready_INST_0_i_1_n_2,
      CO(0) => s01_axis_tready_INST_0_i_1_n_3,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_s01_axis_tready_INST_0_i_1_O_UNCONNECTED(3 downto 0),
      S(3) => '0',
      S(2) => s01_axis_tready_INST_0_i_2_n_0,
      S(1) => s01_axis_tready_INST_0_i_3_n_0,
      S(0) => s01_axis_tready_INST_0_i_4_n_0
    );
s01_axis_tready_INST_0_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[7]\,
      I1 => rd_ptr_reg(7),
      I2 => \wr_ptr_reg_n_0_[6]\,
      I3 => rd_ptr_reg(6),
      I4 => rd_ptr_reg(8),
      I5 => \wr_ptr_reg_n_0_[8]\,
      O => s01_axis_tready_INST_0_i_2_n_0
    );
s01_axis_tready_INST_0_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[4]\,
      I1 => rd_ptr_reg(4),
      I2 => \wr_ptr_reg_n_0_[3]\,
      I3 => rd_ptr_reg(3),
      I4 => rd_ptr_reg(5),
      I5 => \wr_ptr_reg_n_0_[5]\,
      O => s01_axis_tready_INST_0_i_3_n_0
    );
s01_axis_tready_INST_0_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[1]\,
      I1 => rd_ptr_reg(1),
      I2 => \wr_ptr_reg_n_0_[0]\,
      I3 => rd_ptr_reg(0),
      I4 => rd_ptr_reg(2),
      I5 => \wr_ptr_reg_n_0_[2]\,
      O => s01_axis_tready_INST_0_i_4_n_0
    );
\wr_ptr[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[0]\,
      O => p_0_in(0)
    );
\wr_ptr[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[0]\,
      I1 => \wr_ptr_reg_n_0_[1]\,
      O => p_0_in(1)
    );
\wr_ptr[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[0]\,
      I1 => \wr_ptr_reg_n_0_[1]\,
      I2 => \wr_ptr_reg_n_0_[2]\,
      O => p_0_in(2)
    );
\wr_ptr[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[1]\,
      I1 => \wr_ptr_reg_n_0_[0]\,
      I2 => \wr_ptr_reg_n_0_[2]\,
      I3 => \wr_ptr_reg_n_0_[3]\,
      O => p_0_in(3)
    );
\wr_ptr[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFF8000"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[2]\,
      I1 => \wr_ptr_reg_n_0_[0]\,
      I2 => \wr_ptr_reg_n_0_[1]\,
      I3 => \wr_ptr_reg_n_0_[3]\,
      I4 => \wr_ptr_reg_n_0_[4]\,
      O => p_0_in(4)
    );
\wr_ptr[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFF80000000"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[3]\,
      I1 => \wr_ptr_reg_n_0_[1]\,
      I2 => \wr_ptr_reg_n_0_[0]\,
      I3 => \wr_ptr_reg_n_0_[2]\,
      I4 => \wr_ptr_reg_n_0_[4]\,
      I5 => \wr_ptr_reg_n_0_[5]\,
      O => p_0_in(5)
    );
\wr_ptr[6]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \wr_ptr[9]_i_3_n_0\,
      I1 => \wr_ptr_reg_n_0_[6]\,
      O => p_0_in(6)
    );
\wr_ptr[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \wr_ptr[9]_i_3_n_0\,
      I1 => \wr_ptr_reg_n_0_[6]\,
      I2 => \wr_ptr_reg_n_0_[7]\,
      O => p_0_in(7)
    );
\wr_ptr[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[6]\,
      I1 => \wr_ptr[9]_i_3_n_0\,
      I2 => \wr_ptr_reg_n_0_[7]\,
      I3 => \wr_ptr_reg_n_0_[8]\,
      O => p_0_in(8)
    );
\wr_ptr[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A22A"
    )
        port map (
      I0 => s01_axis_tvalid,
      I1 => full0,
      I2 => rd_ptr_reg(9),
      I3 => p_1_in,
      O => wr_en
    );
\wr_ptr[9]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFF8000"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[7]\,
      I1 => \wr_ptr[9]_i_3_n_0\,
      I2 => \wr_ptr_reg_n_0_[6]\,
      I3 => \wr_ptr_reg_n_0_[8]\,
      I4 => p_1_in,
      O => p_0_in(9)
    );
\wr_ptr[9]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => \wr_ptr_reg_n_0_[5]\,
      I1 => \wr_ptr_reg_n_0_[3]\,
      I2 => \wr_ptr_reg_n_0_[1]\,
      I3 => \wr_ptr_reg_n_0_[0]\,
      I4 => \wr_ptr_reg_n_0_[2]\,
      I5 => \wr_ptr_reg_n_0_[4]\,
      O => \wr_ptr[9]_i_3_n_0\
    );
\wr_ptr_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_en,
      D => p_0_in(0),
      Q => \wr_ptr_reg_n_0_[0]\,
      R => \wr_ptr_reg[9]_0\
    );
\wr_ptr_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_en,
      D => p_0_in(1),
      Q => \wr_ptr_reg_n_0_[1]\,
      R => \wr_ptr_reg[9]_0\
    );
\wr_ptr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_en,
      D => p_0_in(2),
      Q => \wr_ptr_reg_n_0_[2]\,
      R => \wr_ptr_reg[9]_0\
    );
\wr_ptr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_en,
      D => p_0_in(3),
      Q => \wr_ptr_reg_n_0_[3]\,
      R => \wr_ptr_reg[9]_0\
    );
\wr_ptr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_en,
      D => p_0_in(4),
      Q => \wr_ptr_reg_n_0_[4]\,
      R => \wr_ptr_reg[9]_0\
    );
\wr_ptr_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_en,
      D => p_0_in(5),
      Q => \wr_ptr_reg_n_0_[5]\,
      R => \wr_ptr_reg[9]_0\
    );
\wr_ptr_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_en,
      D => p_0_in(6),
      Q => \wr_ptr_reg_n_0_[6]\,
      R => \wr_ptr_reg[9]_0\
    );
\wr_ptr_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_en,
      D => p_0_in(7),
      Q => \wr_ptr_reg_n_0_[7]\,
      R => \wr_ptr_reg[9]_0\
    );
\wr_ptr_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_en,
      D => p_0_in(8),
      Q => \wr_ptr_reg_n_0_[8]\,
      R => \wr_ptr_reg[9]_0\
    );
\wr_ptr_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => wr_en,
      D => p_0_in(9),
      Q => p_1_in,
      R => \wr_ptr_reg[9]_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_lpbk_tst is
  port (
    skid_valid_reg : out STD_LOGIC;
    m00_axis_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m00_axis_tlast : out STD_LOGIC;
    WEBWE : out STD_LOGIC_VECTOR ( 0 to 0 );
    m00_axis_tready : in STD_LOGIC;
    s01_axis_aresetn : in STD_LOGIC;
    s01_axis_aclk : in STD_LOGIC;
    s01_axis_tvalid : in STD_LOGIC;
    s01_axis_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s01_axis_tlast : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_lpbk_tst;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_lpbk_tst is
  signal \FSM_onehot_br_state[2]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_br_state_reg_n_0_[0]\ : STD_LOGIC;
  signal \FSM_onehot_br_state_reg_n_0_[2]\ : STD_LOGIC;
  signal br_data : STD_LOGIC_VECTOR ( 0 to 0 );
  signal br_last : STD_LOGIC;
  signal in_empty : STD_LOGIC;
  signal rd_data : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal rd_last : STD_LOGIC;
  signal rd_ptr0 : STD_LOGIC;
  signal u_out_fifo_n_32 : STD_LOGIC;
  signal u_out_fifo_n_34 : STD_LOGIC;
  signal u_out_fifo_n_36 : STD_LOGIC;
  signal u_out_fifo_n_37 : STD_LOGIC;
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_onehot_br_state_reg[0]\ : label is "BR_IDLE:001,BR_PENDING:010,BR_WRITE:100,";
  attribute FSM_ENCODED_STATES of \FSM_onehot_br_state_reg[1]\ : label is "BR_IDLE:001,BR_PENDING:010,BR_WRITE:100,";
  attribute FSM_ENCODED_STATES of \FSM_onehot_br_state_reg[2]\ : label is "BR_IDLE:001,BR_PENDING:010,BR_WRITE:100,";
begin
\FSM_onehot_br_state[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => br_data(0),
      I1 => s01_axis_aresetn,
      O => \FSM_onehot_br_state[2]_i_1_n_0\
    );
\FSM_onehot_br_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => s01_axis_aclk,
      CE => '1',
      D => u_out_fifo_n_36,
      Q => \FSM_onehot_br_state_reg_n_0_[0]\,
      R => '0'
    );
\FSM_onehot_br_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s01_axis_aclk,
      CE => '1',
      D => u_out_fifo_n_34,
      Q => br_data(0),
      R => '0'
    );
\FSM_onehot_br_state_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s01_axis_aclk,
      CE => '1',
      D => \FSM_onehot_br_state[2]_i_1_n_0\,
      Q => \FSM_onehot_br_state_reg_n_0_[2]\,
      R => '0'
    );
br_last_reg: unisim.vcomponents.FDRE
     port map (
      C => s01_axis_aclk,
      CE => br_data(0),
      D => rd_last,
      Q => br_last,
      R => u_out_fifo_n_32
    );
u_in_fifo: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_axis_fifo_s
     port map (
      CO(0) => in_empty,
      WEBWE(0) => WEBWE(0),
      br_data(0) => br_data(0),
      mem_reg_0 => u_out_fifo_n_37,
      rd_data(31 downto 0) => rd_data(31 downto 0),
      rd_last => rd_last,
      rd_ptr0 => rd_ptr0,
      s01_axis_aclk => s01_axis_aclk,
      s01_axis_aresetn => s01_axis_aresetn,
      s01_axis_tdata(31 downto 0) => s01_axis_tdata(31 downto 0),
      s01_axis_tlast => s01_axis_tlast,
      s01_axis_tvalid => s01_axis_tvalid,
      \wr_ptr_reg[9]_0\ => u_out_fifo_n_32
    );
u_out_fifo: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_axis_fifo_m
     port map (
      CO(0) => in_empty,
      \FSM_onehot_br_state_reg[0]\ => u_out_fifo_n_36,
      \FSM_onehot_br_state_reg[1]\ => \FSM_onehot_br_state_reg_n_0_[0]\,
      \FSM_onehot_br_state_reg[2]\ => u_out_fifo_n_34,
      br_data(0) => br_data(0),
      br_last => br_last,
      m00_axis_tdata(31 downto 0) => m00_axis_tdata(31 downto 0),
      m00_axis_tlast => m00_axis_tlast,
      m00_axis_tready => m00_axis_tready,
      mem_reg_0 => \FSM_onehot_br_state_reg_n_0_[2]\,
      rd_data(31 downto 0) => rd_data(31 downto 0),
      rd_ptr0 => rd_ptr0,
      s01_axis_aclk => s01_axis_aclk,
      s01_axis_aresetn => s01_axis_aresetn,
      s01_axis_aresetn_0 => u_out_fifo_n_32,
      s01_axis_aresetn_1 => u_out_fifo_n_37,
      skid_valid_reg_0 => skid_valid_reg
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  port (
    s01_axis_aclk : in STD_LOGIC;
    s01_axis_aresetn : in STD_LOGIC;
    s01_axis_tready : out STD_LOGIC;
    s01_axis_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s01_axis_tstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s01_axis_tlast : in STD_LOGIC;
    s01_axis_tvalid : in STD_LOGIC;
    m00_axis_aclk : in STD_LOGIC;
    m00_axis_aresetn : in STD_LOGIC;
    m00_axis_tvalid : out STD_LOGIC;
    m00_axis_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m00_axis_tstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m00_axis_tlast : out STD_LOGIC;
    m00_axis_tready : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "loopBackFifoBD_lpbk_tst_0_0,lpbk_tst,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "package_project";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "lpbk_tst,Vivado 2025.2";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  signal \<const1>\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of m00_axis_aclk : signal is "xilinx.com:signal:clock:1.0 m00_axis_aclk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of m00_axis_aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of m00_axis_aclk : signal is "XIL_INTERFACENAME m00_axis_aclk, ASSOCIATED_BUSIF m00_axis, ASSOCIATED_RESET m00_axis_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN loopBackFifoBD_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m00_axis_aresetn : signal is "xilinx.com:signal:reset:1.0 m00_axis_aresetn RST";
  attribute X_INTERFACE_MODE of m00_axis_aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of m00_axis_aresetn : signal is "XIL_INTERFACENAME m00_axis_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m00_axis_tlast : signal is "xilinx.com:interface:axis:1.0 m00_axis TLAST";
  attribute X_INTERFACE_INFO of m00_axis_tready : signal is "xilinx.com:interface:axis:1.0 m00_axis TREADY";
  attribute X_INTERFACE_INFO of m00_axis_tvalid : signal is "xilinx.com:interface:axis:1.0 m00_axis TVALID";
  attribute X_INTERFACE_MODE of m00_axis_tvalid : signal is "master";
  attribute X_INTERFACE_PARAMETER of m00_axis_tvalid : signal is "XIL_INTERFACENAME m00_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 1, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN loopBackFifoBD_processing_system7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s01_axis_aclk : signal is "xilinx.com:signal:clock:1.0 s01_axis_aclk CLK";
  attribute X_INTERFACE_MODE of s01_axis_aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s01_axis_aclk : signal is "XIL_INTERFACENAME s01_axis_aclk, ASSOCIATED_BUSIF s01_axis, ASSOCIATED_RESET s01_axis_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN loopBackFifoBD_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s01_axis_aresetn : signal is "xilinx.com:signal:reset:1.0 s01_axis_aresetn RST";
  attribute X_INTERFACE_MODE of s01_axis_aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s01_axis_aresetn : signal is "XIL_INTERFACENAME s01_axis_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s01_axis_tlast : signal is "xilinx.com:interface:axis:1.0 s01_axis TLAST";
  attribute X_INTERFACE_INFO of s01_axis_tready : signal is "xilinx.com:interface:axis:1.0 s01_axis TREADY";
  attribute X_INTERFACE_MODE of s01_axis_tready : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s01_axis_tready : signal is "XIL_INTERFACENAME s01_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN loopBackFifoBD_processing_system7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s01_axis_tvalid : signal is "xilinx.com:interface:axis:1.0 s01_axis TVALID";
  attribute X_INTERFACE_INFO of m00_axis_tdata : signal is "xilinx.com:interface:axis:1.0 m00_axis TDATA";
  attribute X_INTERFACE_INFO of m00_axis_tstrb : signal is "xilinx.com:interface:axis:1.0 m00_axis TSTRB";
  attribute X_INTERFACE_INFO of s01_axis_tdata : signal is "xilinx.com:interface:axis:1.0 s01_axis TDATA";
  attribute X_INTERFACE_INFO of s01_axis_tstrb : signal is "xilinx.com:interface:axis:1.0 s01_axis TSTRB";
begin
  m00_axis_tstrb(3) <= \<const1>\;
  m00_axis_tstrb(2) <= \<const1>\;
  m00_axis_tstrb(1) <= \<const1>\;
  m00_axis_tstrb(0) <= \<const1>\;
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_lpbk_tst
     port map (
      WEBWE(0) => s01_axis_tready,
      m00_axis_tdata(31 downto 0) => m00_axis_tdata(31 downto 0),
      m00_axis_tlast => m00_axis_tlast,
      m00_axis_tready => m00_axis_tready,
      s01_axis_aclk => s01_axis_aclk,
      s01_axis_aresetn => s01_axis_aresetn,
      s01_axis_tdata(31 downto 0) => s01_axis_tdata(31 downto 0),
      s01_axis_tlast => s01_axis_tlast,
      s01_axis_tvalid => s01_axis_tvalid,
      skid_valid_reg => m00_axis_tvalid
    );
end STRUCTURE;
