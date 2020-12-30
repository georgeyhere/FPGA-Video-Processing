
################################################################
# This is a generated script based on design: greyscale_multiply
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source greyscale_multiply_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a50tcsg324-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name greyscale_multiply

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set A_0 [ create_bd_port -dir I -from 7 -to 0 -type data A_0 ]
  set A_1 [ create_bd_port -dir I -from 7 -to 0 -type data A_1 ]
  set A_2 [ create_bd_port -dir I -from 7 -to 0 -type data A_2 ]
  set B_0 [ create_bd_port -dir I -from 7 -to 0 -type data B_0 ]
  set B_1 [ create_bd_port -dir I -from 7 -to 0 -type data B_1 ]
  set B_2 [ create_bd_port -dir I -from 7 -to 0 -type data B_2 ]
  set CE_0 [ create_bd_port -dir I -type ce CE_0 ]
  set CLK_0 [ create_bd_port -dir I -type clk CLK_0 ]
  set P_0 [ create_bd_port -dir O -from 15 -to 0 -type data P_0 ]
  set P_1 [ create_bd_port -dir O -from 15 -to 0 -type data P_1 ]
  set P_2 [ create_bd_port -dir O -from 15 -to 0 -type data P_2 ]

  # Create instance: xbip_dsp48_macro_0, and set properties
  set xbip_dsp48_macro_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xbip_dsp48_macro:3.0 xbip_dsp48_macro_0 ]
  set_property -dict [ list \
   CONFIG.a_width {8} \
   CONFIG.areg_3 {true} \
   CONFIG.areg_4 {true} \
   CONFIG.b_width {8} \
   CONFIG.breg_3 {true} \
   CONFIG.breg_4 {true} \
   CONFIG.creg_3 {false} \
   CONFIG.creg_4 {false} \
   CONFIG.creg_5 {false} \
   CONFIG.has_ce {true} \
   CONFIG.instruction1 {A*B} \
   CONFIG.mreg_5 {true} \
   CONFIG.p_binarywidth {0} \
   CONFIG.p_full_width {16} \
   CONFIG.p_width {16} \
   CONFIG.preg_6 {true} \
 ] $xbip_dsp48_macro_0

  # Create instance: xbip_dsp48_macro_1, and set properties
  set xbip_dsp48_macro_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xbip_dsp48_macro:3.0 xbip_dsp48_macro_1 ]
  set_property -dict [ list \
   CONFIG.a_width {8} \
   CONFIG.areg_3 {true} \
   CONFIG.areg_4 {true} \
   CONFIG.b_width {8} \
   CONFIG.breg_3 {true} \
   CONFIG.breg_4 {true} \
   CONFIG.creg_3 {false} \
   CONFIG.creg_4 {false} \
   CONFIG.creg_5 {false} \
   CONFIG.has_ce {true} \
   CONFIG.instruction1 {A*B} \
   CONFIG.mreg_5 {true} \
   CONFIG.p_binarywidth {0} \
   CONFIG.p_full_width {16} \
   CONFIG.p_width {16} \
   CONFIG.preg_6 {true} \
 ] $xbip_dsp48_macro_1

  # Create instance: xbip_dsp48_macro_2, and set properties
  set xbip_dsp48_macro_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xbip_dsp48_macro:3.0 xbip_dsp48_macro_2 ]
  set_property -dict [ list \
   CONFIG.a_width {8} \
   CONFIG.areg_3 {true} \
   CONFIG.areg_4 {true} \
   CONFIG.b_width {8} \
   CONFIG.breg_3 {true} \
   CONFIG.breg_4 {true} \
   CONFIG.creg_3 {false} \
   CONFIG.creg_4 {false} \
   CONFIG.creg_5 {false} \
   CONFIG.has_ce {true} \
   CONFIG.instruction1 {A*B} \
   CONFIG.mreg_5 {true} \
   CONFIG.p_binarywidth {0} \
   CONFIG.p_full_width {16} \
   CONFIG.p_width {16} \
   CONFIG.preg_6 {true} \
 ] $xbip_dsp48_macro_2

  # Create port connections
  connect_bd_net -net A_0_1 [get_bd_ports A_0] [get_bd_pins xbip_dsp48_macro_0/A]
  connect_bd_net -net A_1_1 [get_bd_ports A_1] [get_bd_pins xbip_dsp48_macro_1/A]
  connect_bd_net -net A_2_1 [get_bd_ports A_2] [get_bd_pins xbip_dsp48_macro_2/A]
  connect_bd_net -net B_0_1 [get_bd_ports B_0] [get_bd_pins xbip_dsp48_macro_0/B]
  connect_bd_net -net B_1_1 [get_bd_ports B_1] [get_bd_pins xbip_dsp48_macro_1/B]
  connect_bd_net -net B_2_1 [get_bd_ports B_2] [get_bd_pins xbip_dsp48_macro_2/B]
  connect_bd_net -net CE_0_1 [get_bd_ports CE_0] [get_bd_pins xbip_dsp48_macro_0/CE] [get_bd_pins xbip_dsp48_macro_1/CE] [get_bd_pins xbip_dsp48_macro_2/CE]
  connect_bd_net -net CLK_0_1 [get_bd_ports CLK_0] [get_bd_pins xbip_dsp48_macro_0/CLK] [get_bd_pins xbip_dsp48_macro_1/CLK] [get_bd_pins xbip_dsp48_macro_2/CLK]
  connect_bd_net -net xbip_dsp48_macro_0_P [get_bd_ports P_0] [get_bd_pins xbip_dsp48_macro_0/P]
  connect_bd_net -net xbip_dsp48_macro_1_P [get_bd_ports P_1] [get_bd_pins xbip_dsp48_macro_1/P]
  connect_bd_net -net xbip_dsp48_macro_2_P [get_bd_ports P_2] [get_bd_pins xbip_dsp48_macro_2/P]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


