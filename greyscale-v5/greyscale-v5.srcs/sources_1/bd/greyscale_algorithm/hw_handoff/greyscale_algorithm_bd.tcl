
################################################################
# This is a generated script based on design: greyscale_algorithm
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
# source greyscale_algorithm_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a50tcsg324-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name greyscale_algorithm

# This script was generated for a remote BD. To create a non-remote design,
# change the variable <run_remote_bd_flow> to <0>.

set run_remote_bd_flow 1
if { $run_remote_bd_flow == 1 } {
  # Set the reference directory for source file relative paths (by default 
  # the value is script directory path)
  set origin_dir ./bd

  # Use origin directory path location variable, if specified in the tcl shell
  if { [info exists ::origin_dir_loc] } {
     set origin_dir $::origin_dir_loc
  }

  set str_bd_folder [file normalize ${origin_dir}]
  set str_bd_filepath ${str_bd_folder}/${design_name}/${design_name}.bd

  # Check if remote design exists on disk
  if { [file exists $str_bd_filepath ] == 1 } {
     catch {common::send_msg_id "BD_TCL-110" "ERROR" "The remote BD file path <$str_bd_filepath> already exists!"}
     common::send_msg_id "BD_TCL-008" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0>."
     common::send_msg_id "BD_TCL-009" "INFO" "Also make sure there is no design <$design_name> existing in your current project."

     return 1
  }

  # Check if design exists in memory
  set list_existing_designs [get_bd_designs -quiet $design_name]
  if { $list_existing_designs ne "" } {
     catch {common::send_msg_id "BD_TCL-111" "ERROR" "The design <$design_name> already exists in this project! Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_msg_id "BD_TCL-010" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Check if design exists on disk within project
  set list_existing_designs [get_files -quiet */${design_name}.bd]
  if { $list_existing_designs ne "" } {
     catch {common::send_msg_id "BD_TCL-112" "ERROR" "The design <$design_name> already exists in this project at location:
    $list_existing_designs"}
     catch {common::send_msg_id "BD_TCL-113" "ERROR" "Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_msg_id "BD_TCL-011" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Now can create the remote BD
  # NOTE - usage of <-dir> will create <$str_bd_folder/$design_name/$design_name.bd>
  create_bd_design -dir $str_bd_folder $design_name
} else {

  # Create regular design
  if { [catch {create_bd_design $design_name} errmsg] } {
     common::send_msg_id "BD_TCL-012" "INFO" "Please set a different value to variable <design_name>."

     return 1
  }
}

current_bd_design $design_name

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
  set M_AXIS_RESULT_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RESULT_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {10000000} \
   ] $M_AXIS_RESULT_0

  set S_AXIS_A_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_A_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {10000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS_A_0

  set S_AXIS_A_1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_A_1 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {10000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS_A_1

  set S_AXIS_A_2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_A_2 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {10000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS_A_2

  set S_AXIS_B_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_B_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {10000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS_B_0

  set S_AXIS_B_1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_B_1 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {10000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS_B_1

  set S_AXIS_B_2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_B_2 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {10000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {4} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS_B_2


  # Create ports
  set aclk_0 [ create_bd_port -dir I -type clk -freq_hz 10000000 aclk_0 ]
  set aresetn_0 [ create_bd_port -dir I -type rst aresetn_0 ]

  # Create instance: floating_point_0, and set properties
  set floating_point_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_0 ]
  set_property -dict [ list \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {7} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {Blocking} \
   CONFIG.Has_ARESETn {true} \
   CONFIG.Has_RESULT_TREADY {true} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_0

  # Create instance: floating_point_1, and set properties
  set floating_point_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_1 ]
  set_property -dict [ list \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {7} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {Blocking} \
   CONFIG.Has_ARESETn {true} \
   CONFIG.Has_RESULT_TREADY {true} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_1

  # Create instance: floating_point_2, and set properties
  set floating_point_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_2 ]
  set_property -dict [ list \
   CONFIG.C_Accum_Input_Msb {32} \
   CONFIG.C_Accum_Lsb {-31} \
   CONFIG.C_Accum_Msb {32} \
   CONFIG.C_Latency {7} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {Blocking} \
   CONFIG.Has_ARESETn {true} \
   CONFIG.Has_RESULT_TREADY {true} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {Fixed_to_float} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_2

  # Create instance: floating_point_3, and set properties
  set floating_point_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_3 ]
  set_property -dict [ list \
   CONFIG.C_Latency {1} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_ARESETn {true} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_3

  # Create instance: floating_point_4, and set properties
  set floating_point_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_4 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {1} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_ARESETn {true} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {FMA} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_4

  # Create instance: floating_point_5, and set properties
  set floating_point_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_5 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {1} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Has_ARESETn {true} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {FMA} \
   CONFIG.Result_Precision_Type {Single} \
 ] $floating_point_5

  # Create instance: floating_point_6, and set properties
  set floating_point_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_6 ]
  set_property -dict [ list \
   CONFIG.C_Latency {1} \
   CONFIG.C_Mult_Usage {No_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {32} \
   CONFIG.C_Result_Fraction_Width {0} \
   CONFIG.Has_ARESETn {true} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {Float_to_fixed} \
   CONFIG.Result_Precision_Type {Int32} \
 ] $floating_point_6

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXIS_A_0_1 [get_bd_intf_ports S_AXIS_A_0] [get_bd_intf_pins floating_point_0/S_AXIS_A]
  connect_bd_intf_net -intf_net S_AXIS_A_1_1 [get_bd_intf_ports S_AXIS_A_1] [get_bd_intf_pins floating_point_1/S_AXIS_A]
  connect_bd_intf_net -intf_net S_AXIS_A_2_1 [get_bd_intf_ports S_AXIS_A_2] [get_bd_intf_pins floating_point_2/S_AXIS_A]
  connect_bd_intf_net -intf_net S_AXIS_B_0_1 [get_bd_intf_ports S_AXIS_B_0] [get_bd_intf_pins floating_point_3/S_AXIS_B]
  connect_bd_intf_net -intf_net S_AXIS_B_1_1 [get_bd_intf_ports S_AXIS_B_1] [get_bd_intf_pins floating_point_4/S_AXIS_B]
  connect_bd_intf_net -intf_net S_AXIS_B_2_1 [get_bd_intf_ports S_AXIS_B_2] [get_bd_intf_pins floating_point_5/S_AXIS_B]
  connect_bd_intf_net -intf_net floating_point_0_M_AXIS_RESULT [get_bd_intf_pins floating_point_0/M_AXIS_RESULT] [get_bd_intf_pins floating_point_3/S_AXIS_A]
  connect_bd_intf_net -intf_net floating_point_1_M_AXIS_RESULT [get_bd_intf_pins floating_point_1/M_AXIS_RESULT] [get_bd_intf_pins floating_point_4/S_AXIS_A]
  connect_bd_intf_net -intf_net floating_point_2_M_AXIS_RESULT [get_bd_intf_pins floating_point_2/M_AXIS_RESULT] [get_bd_intf_pins floating_point_5/S_AXIS_A]
  connect_bd_intf_net -intf_net floating_point_3_M_AXIS_RESULT [get_bd_intf_pins floating_point_3/M_AXIS_RESULT] [get_bd_intf_pins floating_point_4/S_AXIS_C]
  connect_bd_intf_net -intf_net floating_point_4_M_AXIS_RESULT [get_bd_intf_pins floating_point_4/M_AXIS_RESULT] [get_bd_intf_pins floating_point_5/S_AXIS_C]
  connect_bd_intf_net -intf_net floating_point_5_M_AXIS_RESULT [get_bd_intf_pins floating_point_5/M_AXIS_RESULT] [get_bd_intf_pins floating_point_6/S_AXIS_A]
  connect_bd_intf_net -intf_net floating_point_6_M_AXIS_RESULT [get_bd_intf_ports M_AXIS_RESULT_0] [get_bd_intf_pins floating_point_6/M_AXIS_RESULT]

  # Create port connections
  connect_bd_net -net aclk_0_1 [get_bd_ports aclk_0] [get_bd_pins floating_point_0/aclk] [get_bd_pins floating_point_1/aclk] [get_bd_pins floating_point_2/aclk] [get_bd_pins floating_point_3/aclk] [get_bd_pins floating_point_4/aclk] [get_bd_pins floating_point_5/aclk] [get_bd_pins floating_point_6/aclk]
  connect_bd_net -net aresetn_0_1 [get_bd_ports aresetn_0] [get_bd_pins floating_point_0/aresetn] [get_bd_pins floating_point_1/aresetn] [get_bd_pins floating_point_2/aresetn] [get_bd_pins floating_point_3/aresetn] [get_bd_pins floating_point_4/aresetn] [get_bd_pins floating_point_5/aresetn] [get_bd_pins floating_point_6/aresetn]

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


