-- (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:ip:xbip_dsp48_macro:3.0
-- IP Revision: 17

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY xbip_dsp48_macro_v3_0_17;
USE xbip_dsp48_macro_v3_0_17.xbip_dsp48_macro_v3_0_17;

ENTITY greyscale_multiply_xbip_dsp48_macro_2_0 IS
  PORT (
    CLK : IN STD_LOGIC;
    CE : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    P : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END greyscale_multiply_xbip_dsp48_macro_2_0;

ARCHITECTURE greyscale_multiply_xbip_dsp48_macro_2_0_arch OF greyscale_multiply_xbip_dsp48_macro_2_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF greyscale_multiply_xbip_dsp48_macro_2_0_arch: ARCHITECTURE IS "yes";
  COMPONENT xbip_dsp48_macro_v3_0_17 IS
    GENERIC (
      C_VERBOSITY : INTEGER;
      C_MODEL_TYPE : INTEGER;
      C_XDEVICEFAMILY : STRING;
      C_HAS_CE : INTEGER;
      C_HAS_INDEP_CE : INTEGER;
      C_HAS_CED : INTEGER;
      C_HAS_CEA : INTEGER;
      C_HAS_CEB : INTEGER;
      C_HAS_CEC : INTEGER;
      C_HAS_CECONCAT : INTEGER;
      C_HAS_CEM : INTEGER;
      C_HAS_CEP : INTEGER;
      C_HAS_CESEL : INTEGER;
      C_HAS_SCLR : INTEGER;
      C_HAS_INDEP_SCLR : INTEGER;
      C_HAS_SCLRD : INTEGER;
      C_HAS_SCLRA : INTEGER;
      C_HAS_SCLRB : INTEGER;
      C_HAS_SCLRC : INTEGER;
      C_HAS_SCLRM : INTEGER;
      C_HAS_SCLRP : INTEGER;
      C_HAS_SCLRCONCAT : INTEGER;
      C_HAS_SCLRSEL : INTEGER;
      C_HAS_CARRYCASCIN : INTEGER;
      C_HAS_CARRYIN : INTEGER;
      C_HAS_ACIN : INTEGER;
      C_HAS_BCIN : INTEGER;
      C_HAS_PCIN : INTEGER;
      C_HAS_A : INTEGER;
      C_HAS_B : INTEGER;
      C_HAS_D : INTEGER;
      C_HAS_CONCAT : INTEGER;
      C_HAS_C : INTEGER;
      C_A_WIDTH : INTEGER;
      C_B_WIDTH : INTEGER;
      C_C_WIDTH : INTEGER;
      C_D_WIDTH : INTEGER;
      C_CONCAT_WIDTH : INTEGER;
      C_P_MSB : INTEGER;
      C_P_LSB : INTEGER;
      C_SEL_WIDTH : INTEGER;
      C_HAS_ACOUT : INTEGER;
      C_HAS_BCOUT : INTEGER;
      C_HAS_CARRYCASCOUT : INTEGER;
      C_HAS_CARRYOUT : INTEGER;
      C_HAS_PCOUT : INTEGER;
      C_CONSTANT_1 : INTEGER;
      C_LATENCY : INTEGER;
      C_OPMODES : STRING;
      C_REG_CONFIG : STRING;
      C_TEST_CORE : INTEGER
    );
    PORT (
      CLK : IN STD_LOGIC;
      CE : IN STD_LOGIC;
      SCLR : IN STD_LOGIC;
      SEL : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      CARRYCASCIN : IN STD_LOGIC;
      CARRYIN : IN STD_LOGIC;
      PCIN : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
      ACIN : IN STD_LOGIC_VECTOR(29 DOWNTO 0);
      BCIN : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
      A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      C : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
      D : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
      CONCAT : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
      ACOUT : OUT STD_LOGIC_VECTOR(29 DOWNTO 0);
      BCOUT : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
      CARRYOUT : OUT STD_LOGIC;
      CARRYCASCOUT : OUT STD_LOGIC;
      PCOUT : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
      P : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      CED : IN STD_LOGIC;
      CED1 : IN STD_LOGIC;
      CED2 : IN STD_LOGIC;
      CED3 : IN STD_LOGIC;
      CEA : IN STD_LOGIC;
      CEA1 : IN STD_LOGIC;
      CEA2 : IN STD_LOGIC;
      CEA3 : IN STD_LOGIC;
      CEA4 : IN STD_LOGIC;
      CEB : IN STD_LOGIC;
      CEB1 : IN STD_LOGIC;
      CEB2 : IN STD_LOGIC;
      CEB3 : IN STD_LOGIC;
      CEB4 : IN STD_LOGIC;
      CECONCAT : IN STD_LOGIC;
      CECONCAT3 : IN STD_LOGIC;
      CECONCAT4 : IN STD_LOGIC;
      CECONCAT5 : IN STD_LOGIC;
      CEC : IN STD_LOGIC;
      CEC1 : IN STD_LOGIC;
      CEC2 : IN STD_LOGIC;
      CEC3 : IN STD_LOGIC;
      CEC4 : IN STD_LOGIC;
      CEC5 : IN STD_LOGIC;
      CEM : IN STD_LOGIC;
      CEP : IN STD_LOGIC;
      CESEL : IN STD_LOGIC;
      CESEL1 : IN STD_LOGIC;
      CESEL2 : IN STD_LOGIC;
      CESEL3 : IN STD_LOGIC;
      CESEL4 : IN STD_LOGIC;
      CESEL5 : IN STD_LOGIC;
      SCLRD : IN STD_LOGIC;
      SCLRA : IN STD_LOGIC;
      SCLRB : IN STD_LOGIC;
      SCLRCONCAT : IN STD_LOGIC;
      SCLRC : IN STD_LOGIC;
      SCLRM : IN STD_LOGIC;
      SCLRP : IN STD_LOGIC;
      SCLRSEL : IN STD_LOGIC
    );
  END COMPONENT xbip_dsp48_macro_v3_0_17;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF P: SIGNAL IS "XIL_INTERFACENAME p_intf, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency width format long minimum {} maximum {}} value 16} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type generated dependency fractwidth format long minimum {}" & 
" maximum {}} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}}} DATA_WIDTH 16}";
  ATTRIBUTE X_INTERFACE_INFO OF P: SIGNAL IS "xilinx.com:signal:data:1.0 p_intf DATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF B: SIGNAL IS "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef";
  ATTRIBUTE X_INTERFACE_INFO OF B: SIGNAL IS "xilinx.com:signal:data:1.0 b_intf DATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF A: SIGNAL IS "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef";
  ATTRIBUTE X_INTERFACE_INFO OF A: SIGNAL IS "xilinx.com:signal:data:1.0 a_intf DATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF CE: SIGNAL IS "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_LOW";
  ATTRIBUTE X_INTERFACE_INFO OF CE: SIGNAL IS "xilinx.com:signal:clockenable:1.0 ce_intf CE";
  ATTRIBUTE X_INTERFACE_PARAMETER OF CLK: SIGNAL IS "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:pcout_intf:carrycascout_intf:carryout_intf:bcout_intf:acout_intf:concat_intf:d_intf:c_intf:b_intf:a_intf:bcin_intf:acin_intf:pcin_intf:carryin_intf:carrycascin_intf:sel_intf, ASSOCIATED_RESET SCLR:SCLRD:SCLRA:SCLRB:SCLRCONCAT:SCLRC:SCLRM:SCLRP:SCLRSEL, ASSOCIATED_CLKEN CE:CED:CED1:CED2:CED3:CEA:CEA1:CEA2:CEA3:CEA4:CEB:CEB1:CEB2:CEB3:CEB4:CECONCAT:CECONCAT3:CECONCAT4:CECONCAT5:CEC:CEC1:CEC2:CEC3:CEC4:CEC5:CEM:CEP:CESEL:CESEL1:CESEL2:CESEL3:CESEL" & 
"4:CESEL5, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN greyscale_multiply_CLK_0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF CLK: SIGNAL IS "xilinx.com:signal:clock:1.0 clk_intf CLK";
BEGIN
  U0 : xbip_dsp48_macro_v3_0_17
    GENERIC MAP (
      C_VERBOSITY => 0,
      C_MODEL_TYPE => 0,
      C_XDEVICEFAMILY => "artix7",
      C_HAS_CE => 1,
      C_HAS_INDEP_CE => 0,
      C_HAS_CED => 0,
      C_HAS_CEA => 0,
      C_HAS_CEB => 0,
      C_HAS_CEC => 0,
      C_HAS_CECONCAT => 0,
      C_HAS_CEM => 0,
      C_HAS_CEP => 0,
      C_HAS_CESEL => 0,
      C_HAS_SCLR => 0,
      C_HAS_INDEP_SCLR => 0,
      C_HAS_SCLRD => 0,
      C_HAS_SCLRA => 0,
      C_HAS_SCLRB => 0,
      C_HAS_SCLRC => 0,
      C_HAS_SCLRM => 0,
      C_HAS_SCLRP => 0,
      C_HAS_SCLRCONCAT => 0,
      C_HAS_SCLRSEL => 0,
      C_HAS_CARRYCASCIN => 0,
      C_HAS_CARRYIN => 0,
      C_HAS_ACIN => 0,
      C_HAS_BCIN => 0,
      C_HAS_PCIN => 0,
      C_HAS_A => 1,
      C_HAS_B => 1,
      C_HAS_D => 0,
      C_HAS_CONCAT => 0,
      C_HAS_C => 0,
      C_A_WIDTH => 8,
      C_B_WIDTH => 8,
      C_C_WIDTH => 48,
      C_D_WIDTH => 18,
      C_CONCAT_WIDTH => 48,
      C_P_MSB => 15,
      C_P_LSB => 0,
      C_SEL_WIDTH => 0,
      C_HAS_ACOUT => 0,
      C_HAS_BCOUT => 0,
      C_HAS_CARRYCASCOUT => 0,
      C_HAS_CARRYOUT => 0,
      C_HAS_PCOUT => 0,
      C_CONSTANT_1 => 1,
      C_LATENCY => -1,
      C_OPMODES => "000100100000010100000000",
      C_REG_CONFIG => "00000000000011000011000001000100",
      C_TEST_CORE => 0
    )
    PORT MAP (
      CLK => CLK,
      CE => CE,
      SCLR => '0',
      SEL => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      CARRYCASCIN => '0',
      CARRYIN => '0',
      PCIN => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 48)),
      ACIN => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 30)),
      BCIN => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 18)),
      A => A,
      B => B,
      C => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 48)),
      D => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 18)),
      CONCAT => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 48)),
      P => P,
      CED => '1',
      CED1 => '1',
      CED2 => '1',
      CED3 => '1',
      CEA => '1',
      CEA1 => '1',
      CEA2 => '1',
      CEA3 => '1',
      CEA4 => '1',
      CEB => '1',
      CEB1 => '1',
      CEB2 => '1',
      CEB3 => '1',
      CEB4 => '1',
      CECONCAT => '1',
      CECONCAT3 => '1',
      CECONCAT4 => '1',
      CECONCAT5 => '1',
      CEC => '1',
      CEC1 => '1',
      CEC2 => '1',
      CEC3 => '1',
      CEC4 => '1',
      CEC5 => '1',
      CEM => '1',
      CEP => '1',
      CESEL => '1',
      CESEL1 => '1',
      CESEL2 => '1',
      CESEL3 => '1',
      CESEL4 => '1',
      CESEL5 => '1',
      SCLRD => '0',
      SCLRA => '0',
      SCLRB => '0',
      SCLRCONCAT => '0',
      SCLRC => '0',
      SCLRM => '0',
      SCLRP => '0',
      SCLRSEL => '0'
    );
END greyscale_multiply_xbip_dsp48_macro_2_0_arch;
