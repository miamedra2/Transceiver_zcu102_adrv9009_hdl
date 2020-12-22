
################################################################
# This is a generated script based on design: system
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
set scripts_vivado_version 2018.3
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
# source system_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# sync_bits, ad_bus_mux, ad_bus_mux, ad_bus_mux, ad_bus_mux, sync_bits, ad_bus_mux, ad_bus_mux, ad_bus_mux, ad_bus_mux, util_pulse_gen

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu9eg-ffvb1156-2-e
   set_property BOARD_PART xilinx.com:zcu102:part0:3.2 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name system

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


# Hierarchical cell: tx_fir_interpolator
proc create_hier_cell_tx_fir_interpolator { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_tx_fir_interpolator() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I aclk
  create_bd_pin -dir I active
  create_bd_pin -dir I dac_enable_0
  create_bd_pin -dir I dac_enable_1
  create_bd_pin -dir I dac_enable_2
  create_bd_pin -dir I dac_enable_3
  create_bd_pin -dir I dac_valid_0
  create_bd_pin -dir I dac_valid_1
  create_bd_pin -dir I dac_valid_2
  create_bd_pin -dir I dac_valid_3
  create_bd_pin -dir I -from 31 -to 0 data_in_0
  create_bd_pin -dir I -from 31 -to 0 data_in_1
  create_bd_pin -dir I -from 31 -to 0 data_in_2
  create_bd_pin -dir I -from 31 -to 0 data_in_3
  create_bd_pin -dir O -from 31 -to 0 data_out_0
  create_bd_pin -dir O -from 31 -to 0 data_out_1
  create_bd_pin -dir O -from 31 -to 0 data_out_2
  create_bd_pin -dir O -from 31 -to 0 data_out_3
  create_bd_pin -dir O enable_out_0
  create_bd_pin -dir O enable_out_1
  create_bd_pin -dir O enable_out_2
  create_bd_pin -dir O enable_out_3
  create_bd_pin -dir I load_config
  create_bd_pin -dir I -type rst out_resetn
  create_bd_pin -dir I -from 31 -to 0 pulse_width
  create_bd_pin -dir O valid_out_0
  create_bd_pin -dir O valid_out_1
  create_bd_pin -dir O valid_out_2
  create_bd_pin -dir O valid_out_3

  # Create instance: cdc_sync_active, and set properties
  set block_name sync_bits
  set block_cell_name cdc_sync_active
  if { [catch {set cdc_sync_active [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $cdc_sync_active eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: fir_interpolation_0, and set properties
  set fir_interpolation_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_interpolation_0 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {122.88} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.Coefficient_File {../../../../imports/hdl/library/util_fir_int/coefile_int.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {9} \
   CONFIG.Data_Fractional_Bits {15} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Interpolation} \
   CONFIG.Interpolation_Rate {8} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.Sample_Frequency {15.36} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_interpolation_0

  # Create instance: fir_interpolation_1, and set properties
  set fir_interpolation_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_interpolation_1 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {122.88} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.Coefficient_File {../../../../imports/hdl/library/util_fir_int/coefile_int.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {9} \
   CONFIG.Data_Fractional_Bits {15} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Interpolation} \
   CONFIG.Interpolation_Rate {8} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.Sample_Frequency {15.36} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_interpolation_1

  # Create instance: fir_interpolation_2, and set properties
  set fir_interpolation_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_interpolation_2 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {122.88} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.Coefficient_File {../../../../imports/hdl/library/util_fir_int/coefile_int.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {9} \
   CONFIG.Data_Fractional_Bits {15} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Interpolation} \
   CONFIG.Interpolation_Rate {8} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.Sample_Frequency {15.36} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_interpolation_2

  # Create instance: fir_interpolation_3, and set properties
  set fir_interpolation_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_interpolation_3 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {122.88} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.Coefficient_File {../../../../imports/hdl/library/util_fir_int/coefile_int.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {9} \
   CONFIG.Data_Fractional_Bits {15} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Interpolation} \
   CONFIG.Interpolation_Rate {8} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {2} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.Sample_Frequency {15.36} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_interpolation_3

  # Create instance: logic_and_0, and set properties
  set logic_and_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 logic_and_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $logic_and_0

  # Create instance: logic_and_1, and set properties
  set logic_and_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 logic_and_1 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $logic_and_1

  # Create instance: logic_and_2, and set properties
  set logic_and_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 logic_and_2 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $logic_and_2

  # Create instance: logic_and_3, and set properties
  set logic_and_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 logic_and_3 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $logic_and_3

  # Create instance: out_mux_0, and set properties
  set block_name ad_bus_mux
  set block_cell_name out_mux_0
  if { [catch {set out_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $out_mux_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
 ] $out_mux_0

  # Create instance: out_mux_1, and set properties
  set block_name ad_bus_mux
  set block_cell_name out_mux_1
  if { [catch {set out_mux_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $out_mux_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
 ] $out_mux_1

  # Create instance: out_mux_2, and set properties
  set block_name ad_bus_mux
  set block_cell_name out_mux_2
  if { [catch {set out_mux_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $out_mux_2 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
 ] $out_mux_2

  # Create instance: out_mux_3, and set properties
  set block_name ad_bus_mux
  set block_cell_name out_mux_3
  if { [catch {set out_mux_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $out_mux_3 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
 ] $out_mux_3

  # Create instance: rate_gen, and set properties
  set block_name util_pulse_gen
  set block_cell_name rate_gen
  if { [catch {set rate_gen [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $rate_gen eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.PULSE_PERIOD {7} \
   CONFIG.PULSE_WIDTH {1} \
 ] $rate_gen

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins cdc_sync_active/out_clk] [get_bd_pins fir_interpolation_0/aclk] [get_bd_pins fir_interpolation_1/aclk] [get_bd_pins fir_interpolation_2/aclk] [get_bd_pins fir_interpolation_3/aclk] [get_bd_pins rate_gen/clk]
  connect_bd_net -net active_1 [get_bd_pins active] [get_bd_pins cdc_sync_active/in_bits]
  connect_bd_net -net cdc_sync_active_out_bits [get_bd_pins cdc_sync_active/out_bits] [get_bd_pins out_mux_0/select_path] [get_bd_pins out_mux_1/select_path] [get_bd_pins out_mux_2/select_path] [get_bd_pins out_mux_3/select_path] [get_bd_pins rate_gen/rstn]
  connect_bd_net -net dac_enable_0_1 [get_bd_pins dac_enable_0] [get_bd_pins out_mux_0/enable_in_0] [get_bd_pins out_mux_0/enable_in_1]
  connect_bd_net -net dac_enable_1_1 [get_bd_pins dac_enable_1] [get_bd_pins out_mux_1/enable_in_0] [get_bd_pins out_mux_1/enable_in_1]
  connect_bd_net -net dac_enable_2_1 [get_bd_pins dac_enable_2] [get_bd_pins out_mux_2/enable_in_0] [get_bd_pins out_mux_2/enable_in_1]
  connect_bd_net -net dac_enable_3_1 [get_bd_pins dac_enable_3] [get_bd_pins out_mux_3/enable_in_0] [get_bd_pins out_mux_3/enable_in_1]
  connect_bd_net -net dac_valid_0_1 [get_bd_pins dac_valid_0] [get_bd_pins logic_and_0/Op2] [get_bd_pins out_mux_0/valid_in_0]
  connect_bd_net -net dac_valid_1_1 [get_bd_pins dac_valid_1] [get_bd_pins logic_and_1/Op2] [get_bd_pins out_mux_1/valid_in_0]
  connect_bd_net -net dac_valid_2_1 [get_bd_pins dac_valid_2] [get_bd_pins logic_and_2/Op2] [get_bd_pins out_mux_2/valid_in_0]
  connect_bd_net -net dac_valid_3_1 [get_bd_pins dac_valid_3] [get_bd_pins logic_and_3/Op2] [get_bd_pins out_mux_3/valid_in_0]
  connect_bd_net -net data_in_0_1 [get_bd_pins data_in_0] [get_bd_pins fir_interpolation_0/s_axis_data_tdata] [get_bd_pins out_mux_0/data_in_0]
  connect_bd_net -net data_in_1_1 [get_bd_pins data_in_1] [get_bd_pins fir_interpolation_1/s_axis_data_tdata] [get_bd_pins out_mux_1/data_in_0]
  connect_bd_net -net data_in_2_1 [get_bd_pins data_in_2] [get_bd_pins fir_interpolation_2/s_axis_data_tdata] [get_bd_pins out_mux_2/data_in_0]
  connect_bd_net -net data_in_3_1 [get_bd_pins data_in_3] [get_bd_pins fir_interpolation_3/s_axis_data_tdata] [get_bd_pins out_mux_3/data_in_0]
  connect_bd_net -net fir_interpolation_0_m_axis_data_tdata [get_bd_pins fir_interpolation_0/m_axis_data_tdata] [get_bd_pins out_mux_0/data_in_1]
  connect_bd_net -net fir_interpolation_1_m_axis_data_tdata [get_bd_pins fir_interpolation_1/m_axis_data_tdata] [get_bd_pins out_mux_1/data_in_1]
  connect_bd_net -net fir_interpolation_2_m_axis_data_tdata [get_bd_pins fir_interpolation_2/m_axis_data_tdata] [get_bd_pins out_mux_2/data_in_1]
  connect_bd_net -net fir_interpolation_3_m_axis_data_tdata [get_bd_pins fir_interpolation_3/m_axis_data_tdata] [get_bd_pins out_mux_3/data_in_1]
  connect_bd_net -net load_config_1 [get_bd_pins load_config] [get_bd_pins rate_gen/load_config]
  connect_bd_net -net logic_and_0_Res [get_bd_pins fir_interpolation_0/s_axis_data_tvalid] [get_bd_pins logic_and_0/Res]
  connect_bd_net -net logic_and_1_Res [get_bd_pins fir_interpolation_1/s_axis_data_tvalid] [get_bd_pins logic_and_1/Res]
  connect_bd_net -net logic_and_2_Res [get_bd_pins fir_interpolation_2/s_axis_data_tvalid] [get_bd_pins logic_and_2/Res]
  connect_bd_net -net logic_and_3_Res [get_bd_pins fir_interpolation_3/s_axis_data_tvalid] [get_bd_pins logic_and_3/Res]
  connect_bd_net -net out_mux_0_data_out [get_bd_pins data_out_0] [get_bd_pins out_mux_0/data_out]
  connect_bd_net -net out_mux_0_enable_out [get_bd_pins enable_out_0] [get_bd_pins out_mux_0/enable_out]
  connect_bd_net -net out_mux_0_valid_out [get_bd_pins valid_out_0] [get_bd_pins out_mux_0/valid_out]
  connect_bd_net -net out_mux_1_data_out [get_bd_pins data_out_1] [get_bd_pins out_mux_1/data_out]
  connect_bd_net -net out_mux_1_enable_out [get_bd_pins enable_out_1] [get_bd_pins out_mux_1/enable_out]
  connect_bd_net -net out_mux_1_valid_out [get_bd_pins valid_out_1] [get_bd_pins out_mux_1/valid_out]
  connect_bd_net -net out_mux_2_data_out [get_bd_pins data_out_2] [get_bd_pins out_mux_2/data_out]
  connect_bd_net -net out_mux_2_enable_out [get_bd_pins enable_out_2] [get_bd_pins out_mux_2/enable_out]
  connect_bd_net -net out_mux_2_valid_out [get_bd_pins valid_out_2] [get_bd_pins out_mux_2/valid_out]
  connect_bd_net -net out_mux_3_data_out [get_bd_pins data_out_3] [get_bd_pins out_mux_3/data_out]
  connect_bd_net -net out_mux_3_enable_out [get_bd_pins enable_out_3] [get_bd_pins out_mux_3/enable_out]
  connect_bd_net -net out_mux_3_valid_out [get_bd_pins valid_out_3] [get_bd_pins out_mux_3/valid_out]
  connect_bd_net -net out_resetn_1 [get_bd_pins out_resetn] [get_bd_pins cdc_sync_active/out_resetn]
  connect_bd_net -net pulse_width_1 [get_bd_pins pulse_width] [get_bd_pins rate_gen/pulse_period] [get_bd_pins rate_gen/pulse_width]
  connect_bd_net -net rate_gen_pulse [get_bd_pins logic_and_0/Op1] [get_bd_pins logic_and_1/Op1] [get_bd_pins logic_and_2/Op1] [get_bd_pins logic_and_3/Op1] [get_bd_pins out_mux_0/valid_in_1] [get_bd_pins out_mux_1/valid_in_1] [get_bd_pins out_mux_2/valid_in_1] [get_bd_pins out_mux_3/valid_in_1] [get_bd_pins rate_gen/pulse]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: tx_adrv9009_tpl_core
proc create_hier_cell_tx_adrv9009_tpl_core { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_tx_adrv9009_tpl_core() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 link
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 dac_data_0
  create_bd_pin -dir I -from 31 -to 0 dac_data_1
  create_bd_pin -dir I -from 31 -to 0 dac_data_2
  create_bd_pin -dir I -from 31 -to 0 dac_data_3
  create_bd_pin -dir I dac_dunf
  create_bd_pin -dir O -from 0 -to 0 dac_enable_0
  create_bd_pin -dir O -from 0 -to 0 dac_enable_1
  create_bd_pin -dir O -from 0 -to 0 dac_enable_2
  create_bd_pin -dir O -from 0 -to 0 dac_enable_3
  create_bd_pin -dir O -from 0 -to 0 dac_valid_0
  create_bd_pin -dir O -from 0 -to 0 dac_valid_1
  create_bd_pin -dir O -from 0 -to 0 dac_valid_2
  create_bd_pin -dir O -from 0 -to 0 dac_valid_3
  create_bd_pin -dir I -type clk link_clk
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: data_concat, and set properties
  set data_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 data_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $data_concat

  # Create instance: enable_slice_0, and set properties
  set enable_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {4} \
 ] $enable_slice_0

  # Create instance: enable_slice_1, and set properties
  set enable_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {4} \
 ] $enable_slice_1

  # Create instance: enable_slice_2, and set properties
  set enable_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {4} \
 ] $enable_slice_2

  # Create instance: enable_slice_3, and set properties
  set enable_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {4} \
 ] $enable_slice_3

  # Create instance: tpl_core, and set properties
  set tpl_core [ create_bd_cell -type ip -vlnv analog.com:user:ad_ip_jesd204_tpl_dac:1.0 tpl_core ]
  set_property -dict [ list \
   CONFIG.BITS_PER_SAMPLE {16} \
   CONFIG.CONVERTER_RESOLUTION {16} \
   CONFIG.NUM_CHANNELS {4} \
   CONFIG.NUM_LANES {4} \
   CONFIG.OCTETS_PER_BEAT {4} \
   CONFIG.SAMPLES_PER_FRAME {1} \
 ] $tpl_core

  # Create instance: valid_slice_0, and set properties
  set valid_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 valid_slice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {4} \
 ] $valid_slice_0

  # Create instance: valid_slice_1, and set properties
  set valid_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 valid_slice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {4} \
 ] $valid_slice_1

  # Create instance: valid_slice_2, and set properties
  set valid_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 valid_slice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {4} \
 ] $valid_slice_2

  # Create instance: valid_slice_3, and set properties
  set valid_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 valid_slice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {4} \
 ] $valid_slice_3

  # Create interface connections
  connect_bd_intf_net -intf_net s_axi_1 [get_bd_intf_pins s_axi] [get_bd_intf_pins tpl_core/s_axi]
  connect_bd_intf_net -intf_net tpl_core_link [get_bd_intf_pins link] [get_bd_intf_pins tpl_core/link]

  # Create port connections
  connect_bd_net -net dac_data_0_1 [get_bd_pins dac_data_0] [get_bd_pins data_concat/In0]
  connect_bd_net -net dac_data_1_1 [get_bd_pins dac_data_1] [get_bd_pins data_concat/In1]
  connect_bd_net -net dac_data_2_1 [get_bd_pins dac_data_2] [get_bd_pins data_concat/In2]
  connect_bd_net -net dac_data_3_1 [get_bd_pins dac_data_3] [get_bd_pins data_concat/In3]
  connect_bd_net -net dac_dunf_1 [get_bd_pins dac_dunf] [get_bd_pins tpl_core/dac_dunf]
  connect_bd_net -net data_concat_dout [get_bd_pins data_concat/dout] [get_bd_pins tpl_core/dac_ddata]
  connect_bd_net -net enable_slice_0_Dout [get_bd_pins dac_enable_0] [get_bd_pins enable_slice_0/Dout]
  connect_bd_net -net enable_slice_1_Dout [get_bd_pins dac_enable_1] [get_bd_pins enable_slice_1/Dout]
  connect_bd_net -net enable_slice_2_Dout [get_bd_pins dac_enable_2] [get_bd_pins enable_slice_2/Dout]
  connect_bd_net -net enable_slice_3_Dout [get_bd_pins dac_enable_3] [get_bd_pins enable_slice_3/Dout]
  connect_bd_net -net link_clk_1 [get_bd_pins link_clk] [get_bd_pins tpl_core/link_clk]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins tpl_core/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins tpl_core/s_axi_aresetn]
  connect_bd_net -net tpl_core_dac_valid [get_bd_pins tpl_core/dac_valid] [get_bd_pins valid_slice_0/Din] [get_bd_pins valid_slice_1/Din] [get_bd_pins valid_slice_2/Din] [get_bd_pins valid_slice_3/Din]
  connect_bd_net -net tpl_core_enable [get_bd_pins enable_slice_0/Din] [get_bd_pins enable_slice_1/Din] [get_bd_pins enable_slice_2/Din] [get_bd_pins enable_slice_3/Din] [get_bd_pins tpl_core/enable]
  connect_bd_net -net valid_slice_0_Dout [get_bd_pins dac_valid_0] [get_bd_pins valid_slice_0/Dout]
  connect_bd_net -net valid_slice_1_Dout [get_bd_pins dac_valid_1] [get_bd_pins valid_slice_1/Dout]
  connect_bd_net -net valid_slice_2_Dout [get_bd_pins dac_valid_2] [get_bd_pins valid_slice_2/Dout]
  connect_bd_net -net valid_slice_3_Dout [get_bd_pins dac_valid_3] [get_bd_pins valid_slice_3/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: rx_os_adrv9009_tpl_core
proc create_hier_cell_rx_os_adrv9009_tpl_core { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_rx_os_adrv9009_tpl_core() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  # Create pins
  create_bd_pin -dir O -from 15 -to 0 adc_data_0
  create_bd_pin -dir O -from 15 -to 0 adc_data_1
  create_bd_pin -dir O -from 15 -to 0 adc_data_2
  create_bd_pin -dir O -from 15 -to 0 adc_data_3
  create_bd_pin -dir I adc_dovf
  create_bd_pin -dir O -from 0 -to 0 adc_enable_0
  create_bd_pin -dir O -from 0 -to 0 adc_enable_1
  create_bd_pin -dir O -from 0 -to 0 adc_enable_2
  create_bd_pin -dir O -from 0 -to 0 adc_enable_3
  create_bd_pin -dir O -from 0 -to 0 adc_valid_0
  create_bd_pin -dir O -from 0 -to 0 adc_valid_1
  create_bd_pin -dir O -from 0 -to 0 adc_valid_2
  create_bd_pin -dir O -from 0 -to 0 adc_valid_3
  create_bd_pin -dir I -type clk link_clk
  create_bd_pin -dir I -from 63 -to 0 link_data
  create_bd_pin -dir I -from 3 -to 0 link_sof
  create_bd_pin -dir I link_valid
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: data_slice_0, and set properties
  set data_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {64} \
 ] $data_slice_0

  # Create instance: data_slice_1, and set properties
  set data_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {16} \
   CONFIG.DIN_WIDTH {64} \
 ] $data_slice_1

  # Create instance: data_slice_2, and set properties
  set data_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {47} \
   CONFIG.DIN_TO {32} \
   CONFIG.DIN_WIDTH {64} \
 ] $data_slice_2

  # Create instance: data_slice_3, and set properties
  set data_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {63} \
   CONFIG.DIN_TO {48} \
   CONFIG.DIN_WIDTH {64} \
 ] $data_slice_3

  # Create instance: enable_slice_0, and set properties
  set enable_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {4} \
 ] $enable_slice_0

  # Create instance: enable_slice_1, and set properties
  set enable_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {4} \
 ] $enable_slice_1

  # Create instance: enable_slice_2, and set properties
  set enable_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {4} \
 ] $enable_slice_2

  # Create instance: enable_slice_3, and set properties
  set enable_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {4} \
 ] $enable_slice_3

  # Create instance: tpl_core, and set properties
  set tpl_core [ create_bd_cell -type ip -vlnv analog.com:user:ad_ip_jesd204_tpl_adc:1.0 tpl_core ]
  set_property -dict [ list \
   CONFIG.BITS_PER_SAMPLE {16} \
   CONFIG.CONVERTER_RESOLUTION {16} \
   CONFIG.NUM_CHANNELS {4} \
   CONFIG.NUM_LANES {2} \
   CONFIG.OCTETS_PER_BEAT {4} \
   CONFIG.SAMPLES_PER_FRAME {1} \
 ] $tpl_core

  # Create instance: valid_slice_0, and set properties
  set valid_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 valid_slice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {4} \
 ] $valid_slice_0

  # Create instance: valid_slice_1, and set properties
  set valid_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 valid_slice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {4} \
 ] $valid_slice_1

  # Create instance: valid_slice_2, and set properties
  set valid_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 valid_slice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {4} \
 ] $valid_slice_2

  # Create instance: valid_slice_3, and set properties
  set valid_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 valid_slice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {4} \
 ] $valid_slice_3

  # Create interface connections
  connect_bd_intf_net -intf_net s_axi_1 [get_bd_intf_pins s_axi] [get_bd_intf_pins tpl_core/s_axi]

  # Create port connections
  connect_bd_net -net adc_dovf_1 [get_bd_pins adc_dovf] [get_bd_pins tpl_core/adc_dovf]
  connect_bd_net -net data_slice_0_Dout [get_bd_pins adc_data_0] [get_bd_pins data_slice_0/Dout]
  connect_bd_net -net data_slice_1_Dout [get_bd_pins adc_data_1] [get_bd_pins data_slice_1/Dout]
  connect_bd_net -net data_slice_2_Dout [get_bd_pins adc_data_2] [get_bd_pins data_slice_2/Dout]
  connect_bd_net -net data_slice_3_Dout [get_bd_pins adc_data_3] [get_bd_pins data_slice_3/Dout]
  connect_bd_net -net enable_slice_0_Dout [get_bd_pins adc_enable_0] [get_bd_pins enable_slice_0/Dout]
  connect_bd_net -net enable_slice_1_Dout [get_bd_pins adc_enable_1] [get_bd_pins enable_slice_1/Dout]
  connect_bd_net -net enable_slice_2_Dout [get_bd_pins adc_enable_2] [get_bd_pins enable_slice_2/Dout]
  connect_bd_net -net enable_slice_3_Dout [get_bd_pins adc_enable_3] [get_bd_pins enable_slice_3/Dout]
  connect_bd_net -net link_clk_1 [get_bd_pins link_clk] [get_bd_pins tpl_core/link_clk]
  connect_bd_net -net link_data_1 [get_bd_pins link_data] [get_bd_pins tpl_core/link_data]
  connect_bd_net -net link_sof_1 [get_bd_pins link_sof] [get_bd_pins tpl_core/link_sof]
  connect_bd_net -net link_valid_1 [get_bd_pins link_valid] [get_bd_pins tpl_core/link_valid]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins tpl_core/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins tpl_core/s_axi_aresetn]
  connect_bd_net -net tpl_core_adc_data [get_bd_pins data_slice_0/Din] [get_bd_pins data_slice_1/Din] [get_bd_pins data_slice_2/Din] [get_bd_pins data_slice_3/Din] [get_bd_pins tpl_core/adc_data]
  connect_bd_net -net tpl_core_adc_valid [get_bd_pins tpl_core/adc_valid] [get_bd_pins valid_slice_0/Din] [get_bd_pins valid_slice_1/Din] [get_bd_pins valid_slice_2/Din] [get_bd_pins valid_slice_3/Din]
  connect_bd_net -net tpl_core_enable [get_bd_pins enable_slice_0/Din] [get_bd_pins enable_slice_1/Din] [get_bd_pins enable_slice_2/Din] [get_bd_pins enable_slice_3/Din] [get_bd_pins tpl_core/enable]
  connect_bd_net -net valid_slice_0_Dout [get_bd_pins adc_valid_0] [get_bd_pins valid_slice_0/Dout]
  connect_bd_net -net valid_slice_1_Dout [get_bd_pins adc_valid_1] [get_bd_pins valid_slice_1/Dout]
  connect_bd_net -net valid_slice_2_Dout [get_bd_pins adc_valid_2] [get_bd_pins valid_slice_2/Dout]
  connect_bd_net -net valid_slice_3_Dout [get_bd_pins adc_valid_3] [get_bd_pins valid_slice_3/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: rx_fir_decimator
proc create_hier_cell_rx_fir_decimator { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_rx_fir_decimator() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I aclk
  create_bd_pin -dir I active
  create_bd_pin -dir I -from 15 -to 0 data_in_0
  create_bd_pin -dir I -from 15 -to 0 data_in_1
  create_bd_pin -dir I -from 15 -to 0 data_in_2
  create_bd_pin -dir I -from 15 -to 0 data_in_3
  create_bd_pin -dir O -from 15 -to 0 data_out_0
  create_bd_pin -dir O -from 15 -to 0 data_out_1
  create_bd_pin -dir O -from 15 -to 0 data_out_2
  create_bd_pin -dir O -from 15 -to 0 data_out_3
  create_bd_pin -dir I enable_in_0
  create_bd_pin -dir I enable_in_1
  create_bd_pin -dir I enable_in_2
  create_bd_pin -dir I enable_in_3
  create_bd_pin -dir O enable_out_0
  create_bd_pin -dir O enable_out_1
  create_bd_pin -dir O enable_out_2
  create_bd_pin -dir O enable_out_3
  create_bd_pin -dir I -type rst out_resetn
  create_bd_pin -dir I valid_in_0
  create_bd_pin -dir I valid_in_1
  create_bd_pin -dir I valid_in_2
  create_bd_pin -dir I valid_in_3
  create_bd_pin -dir O valid_out_0
  create_bd_pin -dir O valid_out_1
  create_bd_pin -dir O valid_out_2
  create_bd_pin -dir O valid_out_3

  # Create instance: cdc_sync_active, and set properties
  set block_name sync_bits
  set block_cell_name cdc_sync_active
  if { [catch {set cdc_sync_active [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $cdc_sync_active eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: fir_decimation_0, and set properties
  set fir_decimation_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_decimation_0 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {122.88} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.Coefficient_File {../../../../imports/hdl/library/util_fir_int/coefile_int.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {9} \
   CONFIG.Data_Fractional_Bits {15} \
   CONFIG.Decimation_Rate {8} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Decimation} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {1} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.Sample_Frequency {122.88} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_decimation_0

  # Create instance: fir_decimation_1, and set properties
  set fir_decimation_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_decimation_1 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {122.88} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.Coefficient_File {../../../../imports/hdl/library/util_fir_int/coefile_int.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {9} \
   CONFIG.Data_Fractional_Bits {15} \
   CONFIG.Decimation_Rate {8} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Decimation} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {1} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.Sample_Frequency {122.88} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_decimation_1

  # Create instance: fir_decimation_2, and set properties
  set fir_decimation_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_decimation_2 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {122.88} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.Coefficient_File {../../../../imports/hdl/library/util_fir_int/coefile_int.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {9} \
   CONFIG.Data_Fractional_Bits {15} \
   CONFIG.Decimation_Rate {8} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Decimation} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {1} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.Sample_Frequency {122.88} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_decimation_2

  # Create instance: fir_decimation_3, and set properties
  set fir_decimation_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_decimation_3 ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {122.88} \
   CONFIG.CoefficientSource {COE_File} \
   CONFIG.Coefficient_File {../../../../imports/hdl/library/util_fir_int/coefile_int.coe} \
   CONFIG.Coefficient_Fractional_Bits {0} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {9} \
   CONFIG.Data_Fractional_Bits {15} \
   CONFIG.Decimation_Rate {8} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Decimation} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {1} \
   CONFIG.Output_Rounding_Mode {Symmetric_Rounding_to_Zero} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Integer_Coefficients} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.Sample_Frequency {122.88} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_decimation_3

  # Create instance: out_mux_0, and set properties
  set block_name ad_bus_mux
  set block_cell_name out_mux_0
  if { [catch {set out_mux_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $out_mux_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH {16} \
 ] $out_mux_0

  # Create instance: out_mux_1, and set properties
  set block_name ad_bus_mux
  set block_cell_name out_mux_1
  if { [catch {set out_mux_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $out_mux_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH {16} \
 ] $out_mux_1

  # Create instance: out_mux_2, and set properties
  set block_name ad_bus_mux
  set block_cell_name out_mux_2
  if { [catch {set out_mux_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $out_mux_2 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH {16} \
 ] $out_mux_2

  # Create instance: out_mux_3, and set properties
  set block_name ad_bus_mux
  set block_cell_name out_mux_3
  if { [catch {set out_mux_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $out_mux_3 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.DATA_WIDTH {16} \
 ] $out_mux_3

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins cdc_sync_active/out_clk] [get_bd_pins fir_decimation_0/aclk] [get_bd_pins fir_decimation_1/aclk] [get_bd_pins fir_decimation_2/aclk] [get_bd_pins fir_decimation_3/aclk]
  connect_bd_net -net active_1 [get_bd_pins active] [get_bd_pins cdc_sync_active/in_bits]
  connect_bd_net -net cdc_sync_active_out_bits [get_bd_pins cdc_sync_active/out_bits] [get_bd_pins out_mux_0/select_path] [get_bd_pins out_mux_1/select_path] [get_bd_pins out_mux_2/select_path] [get_bd_pins out_mux_3/select_path]
  connect_bd_net -net data_in_0_1 [get_bd_pins data_in_0] [get_bd_pins fir_decimation_0/s_axis_data_tdata] [get_bd_pins out_mux_0/data_in_0]
  connect_bd_net -net data_in_1_1 [get_bd_pins data_in_1] [get_bd_pins fir_decimation_1/s_axis_data_tdata] [get_bd_pins out_mux_1/data_in_0]
  connect_bd_net -net data_in_2_1 [get_bd_pins data_in_2] [get_bd_pins fir_decimation_2/s_axis_data_tdata] [get_bd_pins out_mux_2/data_in_0]
  connect_bd_net -net data_in_3_1 [get_bd_pins data_in_3] [get_bd_pins fir_decimation_3/s_axis_data_tdata] [get_bd_pins out_mux_3/data_in_0]
  connect_bd_net -net enable_in_0_1 [get_bd_pins enable_in_0] [get_bd_pins out_mux_0/enable_in_0] [get_bd_pins out_mux_0/enable_in_1]
  connect_bd_net -net enable_in_1_1 [get_bd_pins enable_in_1] [get_bd_pins out_mux_1/enable_in_0] [get_bd_pins out_mux_1/enable_in_1]
  connect_bd_net -net enable_in_2_1 [get_bd_pins enable_in_2] [get_bd_pins out_mux_2/enable_in_0] [get_bd_pins out_mux_2/enable_in_1]
  connect_bd_net -net enable_in_3_1 [get_bd_pins enable_in_3] [get_bd_pins out_mux_3/enable_in_0] [get_bd_pins out_mux_3/enable_in_1]
  connect_bd_net -net fir_decimation_0_m_axis_data_tdata [get_bd_pins fir_decimation_0/m_axis_data_tdata] [get_bd_pins out_mux_0/data_in_1]
  connect_bd_net -net fir_decimation_0_m_axis_data_tvalid [get_bd_pins fir_decimation_0/m_axis_data_tvalid] [get_bd_pins out_mux_0/valid_in_1]
  connect_bd_net -net fir_decimation_1_m_axis_data_tdata [get_bd_pins fir_decimation_1/m_axis_data_tdata] [get_bd_pins out_mux_1/data_in_1]
  connect_bd_net -net fir_decimation_1_m_axis_data_tvalid [get_bd_pins fir_decimation_1/m_axis_data_tvalid] [get_bd_pins out_mux_1/valid_in_1]
  connect_bd_net -net fir_decimation_2_m_axis_data_tdata [get_bd_pins fir_decimation_2/m_axis_data_tdata] [get_bd_pins out_mux_2/data_in_1]
  connect_bd_net -net fir_decimation_2_m_axis_data_tvalid [get_bd_pins fir_decimation_2/m_axis_data_tvalid] [get_bd_pins out_mux_2/valid_in_1]
  connect_bd_net -net fir_decimation_3_m_axis_data_tdata [get_bd_pins fir_decimation_3/m_axis_data_tdata] [get_bd_pins out_mux_3/data_in_1]
  connect_bd_net -net fir_decimation_3_m_axis_data_tvalid [get_bd_pins fir_decimation_3/m_axis_data_tvalid] [get_bd_pins out_mux_3/valid_in_1]
  connect_bd_net -net out_mux_0_data_out [get_bd_pins data_out_0] [get_bd_pins out_mux_0/data_out]
  connect_bd_net -net out_mux_0_enable_out [get_bd_pins enable_out_0] [get_bd_pins out_mux_0/enable_out]
  connect_bd_net -net out_mux_0_valid_out [get_bd_pins valid_out_0] [get_bd_pins out_mux_0/valid_out]
  connect_bd_net -net out_mux_1_data_out [get_bd_pins data_out_1] [get_bd_pins out_mux_1/data_out]
  connect_bd_net -net out_mux_1_enable_out [get_bd_pins enable_out_1] [get_bd_pins out_mux_1/enable_out]
  connect_bd_net -net out_mux_1_valid_out [get_bd_pins valid_out_1] [get_bd_pins out_mux_1/valid_out]
  connect_bd_net -net out_mux_2_data_out [get_bd_pins data_out_2] [get_bd_pins out_mux_2/data_out]
  connect_bd_net -net out_mux_2_enable_out [get_bd_pins enable_out_2] [get_bd_pins out_mux_2/enable_out]
  connect_bd_net -net out_mux_2_valid_out [get_bd_pins valid_out_2] [get_bd_pins out_mux_2/valid_out]
  connect_bd_net -net out_mux_3_data_out [get_bd_pins data_out_3] [get_bd_pins out_mux_3/data_out]
  connect_bd_net -net out_mux_3_enable_out [get_bd_pins enable_out_3] [get_bd_pins out_mux_3/enable_out]
  connect_bd_net -net out_mux_3_valid_out [get_bd_pins valid_out_3] [get_bd_pins out_mux_3/valid_out]
  connect_bd_net -net out_resetn_1 [get_bd_pins out_resetn] [get_bd_pins cdc_sync_active/out_resetn]
  connect_bd_net -net valid_in_0_1 [get_bd_pins valid_in_0] [get_bd_pins fir_decimation_0/s_axis_data_tvalid] [get_bd_pins out_mux_0/valid_in_0]
  connect_bd_net -net valid_in_1_1 [get_bd_pins valid_in_1] [get_bd_pins fir_decimation_1/s_axis_data_tvalid] [get_bd_pins out_mux_1/valid_in_0]
  connect_bd_net -net valid_in_2_1 [get_bd_pins valid_in_2] [get_bd_pins fir_decimation_2/s_axis_data_tvalid] [get_bd_pins out_mux_2/valid_in_0]
  connect_bd_net -net valid_in_3_1 [get_bd_pins valid_in_3] [get_bd_pins fir_decimation_3/s_axis_data_tvalid] [get_bd_pins out_mux_3/valid_in_0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: rx_adrv9009_tpl_core
proc create_hier_cell_rx_adrv9009_tpl_core { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_rx_adrv9009_tpl_core() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  # Create pins
  create_bd_pin -dir O -from 15 -to 0 adc_data_0
  create_bd_pin -dir O -from 15 -to 0 adc_data_1
  create_bd_pin -dir O -from 15 -to 0 adc_data_2
  create_bd_pin -dir O -from 15 -to 0 adc_data_3
  create_bd_pin -dir I adc_dovf
  create_bd_pin -dir O -from 0 -to 0 adc_enable_0
  create_bd_pin -dir O -from 0 -to 0 adc_enable_1
  create_bd_pin -dir O -from 0 -to 0 adc_enable_2
  create_bd_pin -dir O -from 0 -to 0 adc_enable_3
  create_bd_pin -dir O -from 0 -to 0 adc_valid_0
  create_bd_pin -dir O -from 0 -to 0 adc_valid_1
  create_bd_pin -dir O -from 0 -to 0 adc_valid_2
  create_bd_pin -dir O -from 0 -to 0 adc_valid_3
  create_bd_pin -dir I -type clk link_clk
  create_bd_pin -dir I -from 63 -to 0 link_data
  create_bd_pin -dir I -from 3 -to 0 link_sof
  create_bd_pin -dir I link_valid
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: data_slice_0, and set properties
  set data_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {64} \
 ] $data_slice_0

  # Create instance: data_slice_1, and set properties
  set data_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {16} \
   CONFIG.DIN_WIDTH {64} \
 ] $data_slice_1

  # Create instance: data_slice_2, and set properties
  set data_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {47} \
   CONFIG.DIN_TO {32} \
   CONFIG.DIN_WIDTH {64} \
 ] $data_slice_2

  # Create instance: data_slice_3, and set properties
  set data_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 data_slice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {63} \
   CONFIG.DIN_TO {48} \
   CONFIG.DIN_WIDTH {64} \
 ] $data_slice_3

  # Create instance: enable_slice_0, and set properties
  set enable_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {4} \
 ] $enable_slice_0

  # Create instance: enable_slice_1, and set properties
  set enable_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {4} \
 ] $enable_slice_1

  # Create instance: enable_slice_2, and set properties
  set enable_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {4} \
 ] $enable_slice_2

  # Create instance: enable_slice_3, and set properties
  set enable_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 enable_slice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {4} \
 ] $enable_slice_3

  # Create instance: tpl_core, and set properties
  set tpl_core [ create_bd_cell -type ip -vlnv analog.com:user:ad_ip_jesd204_tpl_adc:1.0 tpl_core ]
  set_property -dict [ list \
   CONFIG.BITS_PER_SAMPLE {16} \
   CONFIG.CONVERTER_RESOLUTION {16} \
   CONFIG.NUM_CHANNELS {4} \
   CONFIG.NUM_LANES {2} \
   CONFIG.OCTETS_PER_BEAT {4} \
   CONFIG.SAMPLES_PER_FRAME {1} \
 ] $tpl_core

  # Create instance: valid_slice_0, and set properties
  set valid_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 valid_slice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {4} \
 ] $valid_slice_0

  # Create instance: valid_slice_1, and set properties
  set valid_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 valid_slice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {4} \
 ] $valid_slice_1

  # Create instance: valid_slice_2, and set properties
  set valid_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 valid_slice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {4} \
 ] $valid_slice_2

  # Create instance: valid_slice_3, and set properties
  set valid_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 valid_slice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {4} \
 ] $valid_slice_3

  # Create interface connections
  connect_bd_intf_net -intf_net s_axi_1 [get_bd_intf_pins s_axi] [get_bd_intf_pins tpl_core/s_axi]

  # Create port connections
  connect_bd_net -net adc_dovf_1 [get_bd_pins adc_dovf] [get_bd_pins tpl_core/adc_dovf]
  connect_bd_net -net data_slice_0_Dout [get_bd_pins adc_data_0] [get_bd_pins data_slice_0/Dout]
  connect_bd_net -net data_slice_1_Dout [get_bd_pins adc_data_1] [get_bd_pins data_slice_1/Dout]
  connect_bd_net -net data_slice_2_Dout [get_bd_pins adc_data_2] [get_bd_pins data_slice_2/Dout]
  connect_bd_net -net data_slice_3_Dout [get_bd_pins adc_data_3] [get_bd_pins data_slice_3/Dout]
  connect_bd_net -net enable_slice_0_Dout [get_bd_pins adc_enable_0] [get_bd_pins enable_slice_0/Dout]
  connect_bd_net -net enable_slice_1_Dout [get_bd_pins adc_enable_1] [get_bd_pins enable_slice_1/Dout]
  connect_bd_net -net enable_slice_2_Dout [get_bd_pins adc_enable_2] [get_bd_pins enable_slice_2/Dout]
  connect_bd_net -net enable_slice_3_Dout [get_bd_pins adc_enable_3] [get_bd_pins enable_slice_3/Dout]
  connect_bd_net -net link_clk_1 [get_bd_pins link_clk] [get_bd_pins tpl_core/link_clk]
  connect_bd_net -net link_data_1 [get_bd_pins link_data] [get_bd_pins tpl_core/link_data]
  connect_bd_net -net link_sof_1 [get_bd_pins link_sof] [get_bd_pins tpl_core/link_sof]
  connect_bd_net -net link_valid_1 [get_bd_pins link_valid] [get_bd_pins tpl_core/link_valid]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins tpl_core/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins tpl_core/s_axi_aresetn]
  connect_bd_net -net tpl_core_adc_data [get_bd_pins data_slice_0/Din] [get_bd_pins data_slice_1/Din] [get_bd_pins data_slice_2/Din] [get_bd_pins data_slice_3/Din] [get_bd_pins tpl_core/adc_data]
  connect_bd_net -net tpl_core_adc_valid [get_bd_pins tpl_core/adc_valid] [get_bd_pins valid_slice_0/Din] [get_bd_pins valid_slice_1/Din] [get_bd_pins valid_slice_2/Din] [get_bd_pins valid_slice_3/Din]
  connect_bd_net -net tpl_core_enable [get_bd_pins enable_slice_0/Din] [get_bd_pins enable_slice_1/Din] [get_bd_pins enable_slice_2/Din] [get_bd_pins enable_slice_3/Din] [get_bd_pins tpl_core/enable]
  connect_bd_net -net valid_slice_0_Dout [get_bd_pins adc_valid_0] [get_bd_pins valid_slice_0/Dout]
  connect_bd_net -net valid_slice_1_Dout [get_bd_pins adc_valid_1] [get_bd_pins valid_slice_1/Dout]
  connect_bd_net -net valid_slice_2_Dout [get_bd_pins adc_valid_2] [get_bd_pins valid_slice_2/Dout]
  connect_bd_net -net valid_slice_3_Dout [get_bd_pins adc_valid_3] [get_bd_pins valid_slice_3/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: axi_adrv9009_tx_jesd
proc create_hier_cell_axi_adrv9009_tx_jesd { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_axi_adrv9009_tx_jesd() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 tx_data
  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 tx_phy0
  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 tx_phy1
  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 tx_phy2
  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_jesd204:jesd204_tx_bus_rtl:1.0 tx_phy3

  # Create pins
  create_bd_pin -dir I -type clk device_clk
  create_bd_pin -dir O -type intr irq
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I -from 0 -to 0 sync
  create_bd_pin -dir I sysref

  # Create instance: tx, and set properties
  set tx [ create_bd_cell -type ip -vlnv analog.com:user:jesd204_tx:1.0 tx ]
  set_property -dict [ list \
   CONFIG.NUM_LANES {4} \
   CONFIG.NUM_LINKS {1} \
 ] $tx

  # Create instance: tx_axi, and set properties
  set tx_axi [ create_bd_cell -type ip -vlnv analog.com:user:axi_jesd204_tx:1.0 tx_axi ]
  set_property -dict [ list \
   CONFIG.NUM_LANES {4} \
   CONFIG.NUM_LINKS {1} \
 ] $tx_axi

  # Create interface connections
  connect_bd_intf_net -intf_net s_axi_1 [get_bd_intf_pins s_axi] [get_bd_intf_pins tx_axi/s_axi]
  connect_bd_intf_net -intf_net tx_axi_tx_cfg [get_bd_intf_pins tx/tx_cfg] [get_bd_intf_pins tx_axi/tx_cfg]
  connect_bd_intf_net -intf_net tx_axi_tx_ctrl [get_bd_intf_pins tx/tx_ctrl] [get_bd_intf_pins tx_axi/tx_ctrl]
  connect_bd_intf_net -intf_net tx_data_1 [get_bd_intf_pins tx_data] [get_bd_intf_pins tx/tx_data]
  connect_bd_intf_net -intf_net tx_tx_event [get_bd_intf_pins tx/tx_event] [get_bd_intf_pins tx_axi/tx_event]
  connect_bd_intf_net -intf_net tx_tx_ilas_config [get_bd_intf_pins tx/tx_ilas_config] [get_bd_intf_pins tx_axi/tx_ilas_config]
  connect_bd_intf_net -intf_net tx_tx_phy0 [get_bd_intf_pins tx_phy0] [get_bd_intf_pins tx/tx_phy0]
  connect_bd_intf_net -intf_net tx_tx_phy1 [get_bd_intf_pins tx_phy1] [get_bd_intf_pins tx/tx_phy1]
  connect_bd_intf_net -intf_net tx_tx_phy2 [get_bd_intf_pins tx_phy2] [get_bd_intf_pins tx/tx_phy2]
  connect_bd_intf_net -intf_net tx_tx_phy3 [get_bd_intf_pins tx_phy3] [get_bd_intf_pins tx/tx_phy3]
  connect_bd_intf_net -intf_net tx_tx_status [get_bd_intf_pins tx/tx_status] [get_bd_intf_pins tx_axi/tx_status]

  # Create port connections
  connect_bd_net -net device_clk_1 [get_bd_pins device_clk] [get_bd_pins tx/clk] [get_bd_pins tx_axi/core_clk]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins tx_axi/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins tx_axi/s_axi_aresetn]
  connect_bd_net -net sync_1 [get_bd_pins sync] [get_bd_pins tx/sync]
  connect_bd_net -net sysref_1 [get_bd_pins sysref] [get_bd_pins tx/sysref]
  connect_bd_net -net tx_axi_core_reset [get_bd_pins tx/reset] [get_bd_pins tx_axi/core_reset]
  connect_bd_net -net tx_axi_irq [get_bd_pins irq] [get_bd_pins tx_axi/irq]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: axi_adrv9009_rx_os_jesd
proc create_hier_cell_axi_adrv9009_rx_os_jesd { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_axi_adrv9009_rx_os_jesd() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy0
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  # Create pins
  create_bd_pin -dir I -type clk device_clk
  create_bd_pin -dir O -type intr irq
  create_bd_pin -dir O phy_en_char_align
  create_bd_pin -dir O -from 63 -to 0 rx_data_tdata
  create_bd_pin -dir O rx_data_tvalid
  create_bd_pin -dir O -from 3 -to 0 rx_eof
  create_bd_pin -dir O -from 3 -to 0 rx_sof
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O -from 0 -to 0 sync
  create_bd_pin -dir I sysref

  # Create instance: rx, and set properties
  set rx [ create_bd_cell -type ip -vlnv analog.com:user:jesd204_rx:1.0 rx ]
  set_property -dict [ list \
   CONFIG.NUM_LANES {2} \
   CONFIG.NUM_LINKS {1} \
 ] $rx

  # Create instance: rx_axi, and set properties
  set rx_axi [ create_bd_cell -type ip -vlnv analog.com:user:axi_jesd204_rx:1.0 rx_axi ]
  set_property -dict [ list \
   CONFIG.NUM_LANES {2} \
   CONFIG.NUM_LINKS {1} \
 ] $rx_axi

  # Create interface connections
  connect_bd_intf_net -intf_net rx_axi_rx_cfg [get_bd_intf_pins rx/rx_cfg] [get_bd_intf_pins rx_axi/rx_cfg]
  connect_bd_intf_net -intf_net rx_phy0_1 [get_bd_intf_pins rx_phy0] [get_bd_intf_pins rx/rx_phy0]
  connect_bd_intf_net -intf_net rx_phy1_1 [get_bd_intf_pins rx_phy1] [get_bd_intf_pins rx/rx_phy1]
  connect_bd_intf_net -intf_net rx_rx_event [get_bd_intf_pins rx/rx_event] [get_bd_intf_pins rx_axi/rx_event]
  connect_bd_intf_net -intf_net rx_rx_ilas_config [get_bd_intf_pins rx/rx_ilas_config] [get_bd_intf_pins rx_axi/rx_ilas_config]
  connect_bd_intf_net -intf_net rx_rx_status [get_bd_intf_pins rx/rx_status] [get_bd_intf_pins rx_axi/rx_status]
  connect_bd_intf_net -intf_net s_axi_1 [get_bd_intf_pins s_axi] [get_bd_intf_pins rx_axi/s_axi]

  # Create port connections
  connect_bd_net -net device_clk_1 [get_bd_pins device_clk] [get_bd_pins rx/clk] [get_bd_pins rx_axi/core_clk]
  connect_bd_net -net rx_axi_core_reset [get_bd_pins rx/reset] [get_bd_pins rx_axi/core_reset]
  connect_bd_net -net rx_axi_irq [get_bd_pins irq] [get_bd_pins rx_axi/irq]
  connect_bd_net -net rx_phy_en_char_align [get_bd_pins phy_en_char_align] [get_bd_pins rx/phy_en_char_align]
  connect_bd_net -net rx_rx_data [get_bd_pins rx_data_tdata] [get_bd_pins rx/rx_data]
  connect_bd_net -net rx_rx_eof [get_bd_pins rx_eof] [get_bd_pins rx/rx_eof]
  connect_bd_net -net rx_rx_sof [get_bd_pins rx_sof] [get_bd_pins rx/rx_sof]
  connect_bd_net -net rx_rx_valid [get_bd_pins rx_data_tvalid] [get_bd_pins rx/rx_valid]
  connect_bd_net -net rx_sync [get_bd_pins sync] [get_bd_pins rx/sync]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins rx_axi/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins rx_axi/s_axi_aresetn]
  connect_bd_net -net sysref_1 [get_bd_pins sysref] [get_bd_pins rx/sysref]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: axi_adrv9009_rx_jesd
proc create_hier_cell_axi_adrv9009_rx_jesd { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_axi_adrv9009_rx_jesd() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy0
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0 rx_phy1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  # Create pins
  create_bd_pin -dir I -type clk device_clk
  create_bd_pin -dir O -type intr irq
  create_bd_pin -dir O phy_en_char_align
  create_bd_pin -dir O -from 63 -to 0 rx_data_tdata
  create_bd_pin -dir O rx_data_tvalid
  create_bd_pin -dir O -from 3 -to 0 rx_eof
  create_bd_pin -dir O -from 3 -to 0 rx_sof
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O -from 0 -to 0 sync
  create_bd_pin -dir I sysref

  # Create instance: rx, and set properties
  set rx [ create_bd_cell -type ip -vlnv analog.com:user:jesd204_rx:1.0 rx ]
  set_property -dict [ list \
   CONFIG.NUM_LANES {2} \
   CONFIG.NUM_LINKS {1} \
 ] $rx

  # Create instance: rx_axi, and set properties
  set rx_axi [ create_bd_cell -type ip -vlnv analog.com:user:axi_jesd204_rx:1.0 rx_axi ]
  set_property -dict [ list \
   CONFIG.NUM_LANES {2} \
   CONFIG.NUM_LINKS {1} \
 ] $rx_axi

  # Create interface connections
  connect_bd_intf_net -intf_net rx_axi_rx_cfg [get_bd_intf_pins rx/rx_cfg] [get_bd_intf_pins rx_axi/rx_cfg]
  connect_bd_intf_net -intf_net rx_phy0_1 [get_bd_intf_pins rx_phy0] [get_bd_intf_pins rx/rx_phy0]
  connect_bd_intf_net -intf_net rx_phy1_1 [get_bd_intf_pins rx_phy1] [get_bd_intf_pins rx/rx_phy1]
  connect_bd_intf_net -intf_net rx_rx_event [get_bd_intf_pins rx/rx_event] [get_bd_intf_pins rx_axi/rx_event]
  connect_bd_intf_net -intf_net rx_rx_ilas_config [get_bd_intf_pins rx/rx_ilas_config] [get_bd_intf_pins rx_axi/rx_ilas_config]
  connect_bd_intf_net -intf_net rx_rx_status [get_bd_intf_pins rx/rx_status] [get_bd_intf_pins rx_axi/rx_status]
  connect_bd_intf_net -intf_net s_axi_1 [get_bd_intf_pins s_axi] [get_bd_intf_pins rx_axi/s_axi]

  # Create port connections
  connect_bd_net -net device_clk_1 [get_bd_pins device_clk] [get_bd_pins rx/clk] [get_bd_pins rx_axi/core_clk]
  connect_bd_net -net rx_axi_core_reset [get_bd_pins rx/reset] [get_bd_pins rx_axi/core_reset]
  connect_bd_net -net rx_axi_irq [get_bd_pins irq] [get_bd_pins rx_axi/irq]
  connect_bd_net -net rx_phy_en_char_align [get_bd_pins phy_en_char_align] [get_bd_pins rx/phy_en_char_align]
  connect_bd_net -net rx_rx_data [get_bd_pins rx_data_tdata] [get_bd_pins rx/rx_data]
  connect_bd_net -net rx_rx_eof [get_bd_pins rx_eof] [get_bd_pins rx/rx_eof]
  connect_bd_net -net rx_rx_sof [get_bd_pins rx_sof] [get_bd_pins rx/rx_sof]
  connect_bd_net -net rx_rx_valid [get_bd_pins rx_data_tvalid] [get_bd_pins rx/rx_valid]
  connect_bd_net -net rx_sync [get_bd_pins sync] [get_bd_pins rx/sync]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins rx_axi/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins rx_axi/s_axi_aresetn]
  connect_bd_net -net sysref_1 [get_bd_pins sysref] [get_bd_pins rx/sysref]

  # Restore current instance
  current_bd_instance $oldCurInst
}


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
  set axi_drp [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_drp ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $axi_drp
  set axi_regs [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_regs ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $axi_regs
  set axi_rx_bram [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_rx_bram ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   ] $axi_rx_bram
  set axi_tx_bram [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_tx_bram ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   ] $axi_tx_bram

  # Create ports
  set adc_fir_filter_active [ create_bd_port -dir I adc_fir_filter_active ]
  set axi_clk [ create_bd_port -dir O -type clk axi_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {axi_regs:axi_rx_bram:axi_tx_bram:axi_drp} \
 ] $axi_clk
  set axi_rst_n [ create_bd_port -dir O -from 0 -to 0 -type rst axi_rst_n ]
  set dac_fifo_bypass [ create_bd_port -dir I dac_fifo_bypass ]
  set dac_fir_filter_active [ create_bd_port -dir I dac_fir_filter_active ]
  set gpio_i [ create_bd_port -dir I -from 94 -to 0 gpio_i ]
  set gpio_o [ create_bd_port -dir O -from 94 -to 0 gpio_o ]
  set gpio_t [ create_bd_port -dir O -from 94 -to 0 gpio_t ]
  set rx_data_0_n [ create_bd_port -dir I rx_data_0_n ]
  set rx_data_0_p [ create_bd_port -dir I rx_data_0_p ]
  set rx_data_1_n [ create_bd_port -dir I rx_data_1_n ]
  set rx_data_1_p [ create_bd_port -dir I rx_data_1_p ]
  set rx_data_2_n [ create_bd_port -dir I rx_data_2_n ]
  set rx_data_2_p [ create_bd_port -dir I rx_data_2_p ]
  set rx_data_3_n [ create_bd_port -dir I rx_data_3_n ]
  set rx_data_3_p [ create_bd_port -dir I rx_data_3_p ]
  set rx_ref_clk_0 [ create_bd_port -dir I rx_ref_clk_0 ]
  set rx_ref_clk_2 [ create_bd_port -dir I rx_ref_clk_2 ]
  set rx_sync_0 [ create_bd_port -dir O -from 0 -to 0 rx_sync_0 ]
  set rx_sync_2 [ create_bd_port -dir O -from 0 -to 0 rx_sync_2 ]
  set rx_sysref_0 [ create_bd_port -dir I rx_sysref_0 ]
  set rx_sysref_2 [ create_bd_port -dir I rx_sysref_2 ]
  set spi0_csn [ create_bd_port -dir O -from 2 -to 0 spi0_csn ]
  set spi0_miso [ create_bd_port -dir I spi0_miso ]
  set spi0_mosi [ create_bd_port -dir O spi0_mosi ]
  set spi0_sclk [ create_bd_port -dir O spi0_sclk ]
  set spi1_csn [ create_bd_port -dir O -from 2 -to 0 spi1_csn ]
  set spi1_miso [ create_bd_port -dir I spi1_miso ]
  set spi1_mosi [ create_bd_port -dir O spi1_mosi ]
  set spi1_sclk [ create_bd_port -dir O spi1_sclk ]
  set tx_data_0_n [ create_bd_port -dir O tx_data_0_n ]
  set tx_data_0_p [ create_bd_port -dir O tx_data_0_p ]
  set tx_data_1_n [ create_bd_port -dir O tx_data_1_n ]
  set tx_data_1_p [ create_bd_port -dir O tx_data_1_p ]
  set tx_data_2_n [ create_bd_port -dir O tx_data_2_n ]
  set tx_data_2_p [ create_bd_port -dir O tx_data_2_p ]
  set tx_data_3_n [ create_bd_port -dir O tx_data_3_n ]
  set tx_data_3_p [ create_bd_port -dir O tx_data_3_p ]
  set tx_ref_clk_0 [ create_bd_port -dir I tx_ref_clk_0 ]
  set tx_sync_0 [ create_bd_port -dir I -from 0 -to 0 tx_sync_0 ]
  set tx_sysref_0 [ create_bd_port -dir I tx_sysref_0 ]

  # Create instance: GND_1, and set properties
  set GND_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 GND_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {1} \
 ] $GND_1

  # Create instance: GND_32, and set properties
  set GND_32 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 GND_32 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $GND_32

  # Create instance: VCC_1, and set properties
  set VCC_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 VCC_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
   CONFIG.CONST_WIDTH {1} \
 ] $VCC_1

  # Create instance: adrv9009_rx_device_clk_rstgen, and set properties
  set adrv9009_rx_device_clk_rstgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 adrv9009_rx_device_clk_rstgen ]

  # Create instance: adrv9009_rx_os_device_clk_rstgen, and set properties
  set adrv9009_rx_os_device_clk_rstgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 adrv9009_rx_os_device_clk_rstgen ]

  # Create instance: adrv9009_tx_device_clk_rstgen, and set properties
  set adrv9009_tx_device_clk_rstgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 adrv9009_tx_device_clk_rstgen ]

  # Create instance: axi_adrv9009_dacfifo, and set properties
  set axi_adrv9009_dacfifo [ create_bd_cell -type ip -vlnv analog.com:user:util_dacfifo:1.0 axi_adrv9009_dacfifo ]
  set_property -dict [ list \
   CONFIG.ADDRESS_WIDTH {17} \
   CONFIG.DATA_WIDTH {128} \
 ] $axi_adrv9009_dacfifo

  # Create instance: axi_adrv9009_rx_clkgen, and set properties
  set axi_adrv9009_rx_clkgen [ create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_adrv9009_rx_clkgen ]
  set_property -dict [ list \
   CONFIG.CLK0_DIV {4} \
   CONFIG.CLKIN_PERIOD {4} \
   CONFIG.ID {2} \
   CONFIG.VCO_DIV {1} \
   CONFIG.VCO_MUL {4} \
 ] $axi_adrv9009_rx_clkgen

  # Create instance: axi_adrv9009_rx_dma, and set properties
  set axi_adrv9009_rx_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_adrv9009_rx_dma ]
  set_property -dict [ list \
   CONFIG.ASYNC_CLK_DEST_REQ {true} \
   CONFIG.ASYNC_CLK_REQ_SRC {true} \
   CONFIG.ASYNC_CLK_SRC_DEST {true} \
   CONFIG.AXI_SLICE_DEST {true} \
   CONFIG.AXI_SLICE_SRC {true} \
   CONFIG.CYCLIC {false} \
   CONFIG.DMA_2D_TRANSFER {false} \
   CONFIG.DMA_DATA_WIDTH_DEST {128} \
   CONFIG.DMA_DATA_WIDTH_SRC {64} \
   CONFIG.DMA_TYPE_DEST {0} \
   CONFIG.DMA_TYPE_SRC {2} \
   CONFIG.FIFO_SIZE {32} \
   CONFIG.MAX_BYTES_PER_BURST {256} \
   CONFIG.SYNC_TRANSFER_START {true} \
 ] $axi_adrv9009_rx_dma

  # Create instance: axi_adrv9009_rx_jesd
  create_hier_cell_axi_adrv9009_rx_jesd [current_bd_instance .] axi_adrv9009_rx_jesd

  # Create instance: axi_adrv9009_rx_os_clkgen, and set properties
  set axi_adrv9009_rx_os_clkgen [ create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_adrv9009_rx_os_clkgen ]
  set_property -dict [ list \
   CONFIG.CLK0_DIV {4} \
   CONFIG.CLKIN_PERIOD {4} \
   CONFIG.ID {2} \
   CONFIG.VCO_DIV {1} \
   CONFIG.VCO_MUL {4} \
 ] $axi_adrv9009_rx_os_clkgen

  # Create instance: axi_adrv9009_rx_os_dma, and set properties
  set axi_adrv9009_rx_os_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_adrv9009_rx_os_dma ]
  set_property -dict [ list \
   CONFIG.ASYNC_CLK_DEST_REQ {true} \
   CONFIG.ASYNC_CLK_REQ_SRC {true} \
   CONFIG.ASYNC_CLK_SRC_DEST {true} \
   CONFIG.AXI_SLICE_DEST {true} \
   CONFIG.AXI_SLICE_SRC {true} \
   CONFIG.CYCLIC {false} \
   CONFIG.DMA_2D_TRANSFER {false} \
   CONFIG.DMA_DATA_WIDTH_DEST {128} \
   CONFIG.DMA_DATA_WIDTH_SRC {64} \
   CONFIG.DMA_TYPE_DEST {0} \
   CONFIG.DMA_TYPE_SRC {2} \
   CONFIG.FIFO_SIZE {32} \
   CONFIG.MAX_BYTES_PER_BURST {256} \
   CONFIG.SYNC_TRANSFER_START {true} \
 ] $axi_adrv9009_rx_os_dma

  # Create instance: axi_adrv9009_rx_os_jesd
  create_hier_cell_axi_adrv9009_rx_os_jesd [current_bd_instance .] axi_adrv9009_rx_os_jesd

  # Create instance: axi_adrv9009_rx_os_xcvr, and set properties
  set axi_adrv9009_rx_os_xcvr [ create_bd_cell -type ip -vlnv analog.com:user:axi_adxcvr:1.0 axi_adrv9009_rx_os_xcvr ]
  set_property -dict [ list \
   CONFIG.NUM_OF_LANES {2} \
   CONFIG.OUT_CLK_SEL {"011"} \
   CONFIG.QPLL_ENABLE {0} \
   CONFIG.SYS_CLK_SEL {00} \
   CONFIG.TX_OR_RX_N {0} \
 ] $axi_adrv9009_rx_os_xcvr

  # Create instance: axi_adrv9009_rx_xcvr, and set properties
  set axi_adrv9009_rx_xcvr [ create_bd_cell -type ip -vlnv analog.com:user:axi_adxcvr:1.0 axi_adrv9009_rx_xcvr ]
  set_property -dict [ list \
   CONFIG.NUM_OF_LANES {2} \
   CONFIG.OUT_CLK_SEL {"011"} \
   CONFIG.QPLL_ENABLE {0} \
   CONFIG.SYS_CLK_SEL {00} \
   CONFIG.TX_OR_RX_N {0} \
 ] $axi_adrv9009_rx_xcvr

  # Create instance: axi_adrv9009_tx_clkgen, and set properties
  set axi_adrv9009_tx_clkgen [ create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_adrv9009_tx_clkgen ]
  set_property -dict [ list \
   CONFIG.CLK0_DIV {4} \
   CONFIG.CLKIN_PERIOD {4} \
   CONFIG.ID {2} \
   CONFIG.VCO_DIV {1} \
   CONFIG.VCO_MUL {4} \
 ] $axi_adrv9009_tx_clkgen

  # Create instance: axi_adrv9009_tx_dma, and set properties
  set axi_adrv9009_tx_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_adrv9009_tx_dma ]
  set_property -dict [ list \
   CONFIG.ASYNC_CLK_DEST_REQ {true} \
   CONFIG.ASYNC_CLK_REQ_SRC {true} \
   CONFIG.ASYNC_CLK_SRC_DEST {true} \
   CONFIG.AXI_SLICE_DEST {true} \
   CONFIG.AXI_SLICE_SRC {true} \
   CONFIG.CYCLIC {true} \
   CONFIG.DMA_2D_TRANSFER {false} \
   CONFIG.DMA_DATA_WIDTH_DEST {128} \
   CONFIG.DMA_DATA_WIDTH_SRC {128} \
   CONFIG.DMA_TYPE_DEST {1} \
   CONFIG.DMA_TYPE_SRC {0} \
   CONFIG.FIFO_SIZE {32} \
   CONFIG.MAX_BYTES_PER_BURST {256} \
 ] $axi_adrv9009_tx_dma

  # Create instance: axi_adrv9009_tx_jesd
  create_hier_cell_axi_adrv9009_tx_jesd [current_bd_instance .] axi_adrv9009_tx_jesd

  # Create instance: axi_adrv9009_tx_xcvr, and set properties
  set axi_adrv9009_tx_xcvr [ create_bd_cell -type ip -vlnv analog.com:user:axi_adxcvr:1.0 axi_adrv9009_tx_xcvr ]
  set_property -dict [ list \
   CONFIG.NUM_OF_LANES {4} \
   CONFIG.OUT_CLK_SEL {"011"} \
   CONFIG.QPLL_ENABLE {1} \
   CONFIG.SYS_CLK_SEL {"11"} \
   CONFIG.TX_OR_RX_N {1} \
 ] $axi_adrv9009_tx_xcvr

  # Create instance: axi_cpu_interconnect, and set properties
  set axi_cpu_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_cpu_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {17} \
 ] $axi_cpu_interconnect

  # Create instance: axi_hp0_interconnect, and set properties
  set axi_hp0_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_hp0_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
 ] $axi_hp0_interconnect

  # Create instance: axi_hp1_interconnect, and set properties
  set axi_hp1_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_hp1_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $axi_hp1_interconnect

  # Create instance: axi_hp2_interconnect, and set properties
  set axi_hp2_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_hp2_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $axi_hp2_interconnect

  # Create instance: axi_hp3_interconnect, and set properties
  set axi_hp3_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_hp3_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $axi_hp3_interconnect

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {2} \
 ] $axi_interconnect_0

  # Create instance: axi_sysid_0, and set properties
  set axi_sysid_0 [ create_bd_cell -type ip -vlnv analog.com:user:axi_sysid:1.0 axi_sysid_0 ]
  set_property -dict [ list \
   CONFIG.ROM_ADDR_BITS {9} \
 ] $axi_sysid_0

  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0 ]

  # Create instance: logic_or, and set properties
  set logic_or [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 logic_or ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {1} \
 ] $logic_or

  # Create instance: rom_sys_0, and set properties
  set rom_sys_0 [ create_bd_cell -type ip -vlnv analog.com:user:sysid_rom:1.0 rom_sys_0 ]
  set_property -dict [ list \
   CONFIG.PATH_TO_FILE {c:/github/hdl/projects/adrv9009/zcu102/mem_init_sys.txt} \
   CONFIG.ROM_ADDR_BITS {9} \
 ] $rom_sys_0

  # Create instance: rx_adrv9009_tpl_core
  create_hier_cell_rx_adrv9009_tpl_core [current_bd_instance .] rx_adrv9009_tpl_core

  # Create instance: rx_fir_decimator
  create_hier_cell_rx_fir_decimator [current_bd_instance .] rx_fir_decimator

  # Create instance: rx_os_adrv9009_tpl_core
  create_hier_cell_rx_os_adrv9009_tpl_core [current_bd_instance .] rx_os_adrv9009_tpl_core

  # Create instance: spi0_csn_concat, and set properties
  set spi0_csn_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 spi0_csn_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $spi0_csn_concat

  # Create instance: spi1_csn_concat, and set properties
  set spi1_csn_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 spi1_csn_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $spi1_csn_concat

  # Create instance: sys_250m_rstgen, and set properties
  set sys_250m_rstgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_250m_rstgen ]
  set_property -dict [ list \
   CONFIG.C_EXT_RST_WIDTH {1} \
 ] $sys_250m_rstgen

  # Create instance: sys_500m_rstgen, and set properties
  set sys_500m_rstgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_500m_rstgen ]
  set_property -dict [ list \
   CONFIG.C_EXT_RST_WIDTH {1} \
 ] $sys_500m_rstgen

  # Create instance: sys_concat_intc_0, and set properties
  set sys_concat_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sys_concat_intc_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {8} \
 ] $sys_concat_intc_0

  # Create instance: sys_concat_intc_1, and set properties
  set sys_concat_intc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 sys_concat_intc_1 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {8} \
 ] $sys_concat_intc_1

  # Create instance: sys_ps8, and set properties
  set sys_ps8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.2 sys_ps8 ]
  set_property -dict [ list \
   CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_3_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_DDR_RAM_HIGHADDR {0xFFFFFFFF} \
   CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
   CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
   CONFIG.PSU_MIO_0_DIRECTION {out} \
   CONFIG.PSU_MIO_0_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_10_DIRECTION {inout} \
   CONFIG.PSU_MIO_11_DIRECTION {inout} \
   CONFIG.PSU_MIO_12_DIRECTION {out} \
   CONFIG.PSU_MIO_12_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_13_DIRECTION {inout} \
   CONFIG.PSU_MIO_13_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_14_DIRECTION {inout} \
   CONFIG.PSU_MIO_15_DIRECTION {inout} \
   CONFIG.PSU_MIO_16_DIRECTION {inout} \
   CONFIG.PSU_MIO_17_DIRECTION {inout} \
   CONFIG.PSU_MIO_18_DIRECTION {in} \
   CONFIG.PSU_MIO_18_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_18_SLEW {slow} \
   CONFIG.PSU_MIO_19_DIRECTION {out} \
   CONFIG.PSU_MIO_19_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_1_DIRECTION {inout} \
   CONFIG.PSU_MIO_20_DIRECTION {out} \
   CONFIG.PSU_MIO_20_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_21_DIRECTION {in} \
   CONFIG.PSU_MIO_21_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_21_SLEW {slow} \
   CONFIG.PSU_MIO_22_DIRECTION {inout} \
   CONFIG.PSU_MIO_23_DIRECTION {inout} \
   CONFIG.PSU_MIO_24_DIRECTION {out} \
   CONFIG.PSU_MIO_24_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_25_DIRECTION {in} \
   CONFIG.PSU_MIO_25_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_25_SLEW {slow} \
   CONFIG.PSU_MIO_26_DIRECTION {inout} \
   CONFIG.PSU_MIO_27_DIRECTION {out} \
   CONFIG.PSU_MIO_27_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_28_DIRECTION {in} \
   CONFIG.PSU_MIO_28_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_28_SLEW {slow} \
   CONFIG.PSU_MIO_29_DIRECTION {out} \
   CONFIG.PSU_MIO_29_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_2_DIRECTION {inout} \
   CONFIG.PSU_MIO_30_DIRECTION {in} \
   CONFIG.PSU_MIO_30_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_30_SLEW {slow} \
   CONFIG.PSU_MIO_31_DIRECTION {out} \
   CONFIG.PSU_MIO_31_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_32_DIRECTION {out} \
   CONFIG.PSU_MIO_32_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_33_DIRECTION {out} \
   CONFIG.PSU_MIO_33_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_34_DIRECTION {out} \
   CONFIG.PSU_MIO_34_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_35_DIRECTION {out} \
   CONFIG.PSU_MIO_35_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_36_DIRECTION {out} \
   CONFIG.PSU_MIO_36_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_37_DIRECTION {out} \
   CONFIG.PSU_MIO_37_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_38_DIRECTION {inout} \
   CONFIG.PSU_MIO_39_DIRECTION {inout} \
   CONFIG.PSU_MIO_3_DIRECTION {inout} \
   CONFIG.PSU_MIO_40_DIRECTION {inout} \
   CONFIG.PSU_MIO_41_DIRECTION {inout} \
   CONFIG.PSU_MIO_42_DIRECTION {inout} \
   CONFIG.PSU_MIO_43_DIRECTION {inout} \
   CONFIG.PSU_MIO_44_DIRECTION {in} \
   CONFIG.PSU_MIO_44_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_44_SLEW {slow} \
   CONFIG.PSU_MIO_45_DIRECTION {in} \
   CONFIG.PSU_MIO_45_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_45_SLEW {slow} \
   CONFIG.PSU_MIO_46_DIRECTION {inout} \
   CONFIG.PSU_MIO_47_DIRECTION {inout} \
   CONFIG.PSU_MIO_48_DIRECTION {inout} \
   CONFIG.PSU_MIO_49_DIRECTION {inout} \
   CONFIG.PSU_MIO_4_DIRECTION {inout} \
   CONFIG.PSU_MIO_50_DIRECTION {inout} \
   CONFIG.PSU_MIO_51_DIRECTION {out} \
   CONFIG.PSU_MIO_51_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_52_DIRECTION {in} \
   CONFIG.PSU_MIO_52_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_52_SLEW {slow} \
   CONFIG.PSU_MIO_53_DIRECTION {in} \
   CONFIG.PSU_MIO_53_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_53_SLEW {slow} \
   CONFIG.PSU_MIO_54_DIRECTION {inout} \
   CONFIG.PSU_MIO_55_DIRECTION {in} \
   CONFIG.PSU_MIO_55_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_55_SLEW {slow} \
   CONFIG.PSU_MIO_56_DIRECTION {inout} \
   CONFIG.PSU_MIO_57_DIRECTION {inout} \
   CONFIG.PSU_MIO_58_DIRECTION {out} \
   CONFIG.PSU_MIO_58_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_59_DIRECTION {inout} \
   CONFIG.PSU_MIO_5_DIRECTION {out} \
   CONFIG.PSU_MIO_5_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_60_DIRECTION {inout} \
   CONFIG.PSU_MIO_61_DIRECTION {inout} \
   CONFIG.PSU_MIO_62_DIRECTION {inout} \
   CONFIG.PSU_MIO_63_DIRECTION {inout} \
   CONFIG.PSU_MIO_64_DIRECTION {out} \
   CONFIG.PSU_MIO_64_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_65_DIRECTION {out} \
   CONFIG.PSU_MIO_65_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_66_DIRECTION {out} \
   CONFIG.PSU_MIO_66_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_67_DIRECTION {out} \
   CONFIG.PSU_MIO_67_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_68_DIRECTION {out} \
   CONFIG.PSU_MIO_68_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_69_DIRECTION {out} \
   CONFIG.PSU_MIO_69_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_6_DIRECTION {out} \
   CONFIG.PSU_MIO_6_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_70_DIRECTION {in} \
   CONFIG.PSU_MIO_70_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_70_SLEW {slow} \
   CONFIG.PSU_MIO_71_DIRECTION {in} \
   CONFIG.PSU_MIO_71_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_71_SLEW {slow} \
   CONFIG.PSU_MIO_72_DIRECTION {in} \
   CONFIG.PSU_MIO_72_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_72_SLEW {slow} \
   CONFIG.PSU_MIO_73_DIRECTION {in} \
   CONFIG.PSU_MIO_73_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_73_SLEW {slow} \
   CONFIG.PSU_MIO_74_DIRECTION {in} \
   CONFIG.PSU_MIO_74_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_74_SLEW {slow} \
   CONFIG.PSU_MIO_75_DIRECTION {in} \
   CONFIG.PSU_MIO_75_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_75_SLEW {slow} \
   CONFIG.PSU_MIO_76_DIRECTION {out} \
   CONFIG.PSU_MIO_76_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_77_DIRECTION {inout} \
   CONFIG.PSU_MIO_7_DIRECTION {out} \
   CONFIG.PSU_MIO_7_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_8_DIRECTION {inout} \
   CONFIG.PSU_MIO_9_DIRECTION {inout} \
   CONFIG.PSU_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Feedback Clk#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO0 MIO#I2C 0#I2C 0#I2C 1#I2C 1#UART 0#UART 0#UART 1#UART 1#GPIO0 MIO#GPIO0 MIO#CAN 1#CAN 1#GPIO1 MIO#DPAUX#DPAUX#DPAUX#DPAUX#PCIE#PMU GPO 0#PMU GPO 1#PMU GPO 2#PMU GPO 3#PMU GPO 4#PMU GPO 5#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#MDIO 3#MDIO 3} \
   CONFIG.PSU_MIO_TREE_SIGNALS {sclk_out#miso_mo1#mo2#mo3#mosi_mi0#n_ss_out#clk_for_lpbk#n_ss_out_upper#mo_upper[0]#mo_upper[1]#mo_upper[2]#mo_upper[3]#sclk_out_upper#gpio0[13]#scl_out#sda_out#scl_out#sda_out#rxd#txd#txd#rxd#gpio0[22]#gpio0[23]#phy_tx#phy_rx#gpio1[26]#dp_aux_data_out#dp_hot_plug_detect#dp_aux_data_oe#dp_aux_data_in#reset_n#gpo[0]#gpo[1]#gpo[2]#gpo[3]#gpo[4]#gpo[5]#gpio1[38]#sdio1_data_out[4]#sdio1_data_out[5]#sdio1_data_out[6]#sdio1_data_out[7]#gpio1[43]#sdio1_wp#sdio1_cd_n#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem3_mdc#gem3_mdio_out} \
   CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {8} \
   CONFIG.PSU__ACT_DDR_FREQ_MHZ {1066.560059} \
   CONFIG.PSU__CAN1__GRP_CLK__ENABLE {0} \
   CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__CAN1__PERIPHERAL__IO {MIO 24 .. 25} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1199.880127} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__APLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__APLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {249.975021} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {249.975021} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {533.280029} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1067} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {599.940063} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {64} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__DPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__DPLL_TO_LPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {24.997503} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {16} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {26.664003} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {299.970032} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {599.940063} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {499.950043} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__ACT_FREQMHZ {249.975021} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__ACT_FREQMHZ {249.975021} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {99.990005} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {533.280029} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {533.33} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__VPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__VPLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {499.950043} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {49.995003} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR0 {30} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__ACT_FREQMHZ {99.990005} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {499.950043} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {249.975021} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1499.850098} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {124.987511} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {249.975021} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {99.990005} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {99.990005} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__IOPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__IOPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {249.975021} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {99.990005} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {499.950043} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.481262} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {99.990005} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {249.975021} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__ACT_FREQMHZ {499.950043} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {124.987511} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__RPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.481262} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__ACT_FREQMHZ {99.990013} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__ACT_FREQMHZ {99.990013} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {99.990005} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {99.990005} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {99.990005} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {249.975021} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {19.998001} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR0 {25} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR1 {3} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
   CONFIG.PSU__CSUPMU__PERIPHERAL__VALID {1} \
   CONFIG.PSU__DDRC__ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__BANK_ADDR_COUNT {2} \
   CONFIG.PSU__DDRC__BG_ADDR_COUNT {2} \
   CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
   CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
   CONFIG.PSU__DDRC__CL {15} \
   CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
   CONFIG.PSU__DDRC__COL_ADDR_COUNT {10} \
   CONFIG.PSU__DDRC__COMPONENTS {UDIMM} \
   CONFIG.PSU__DDRC__CWL {14} \
   CONFIG.PSU__DDRC__DDR3L_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
   CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
   CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
   CONFIG.PSU__DDRC__DEEP_PWR_DOWN_EN {0} \
   CONFIG.PSU__DDRC__DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PSU__DDRC__DIMM_ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
   CONFIG.PSU__DDRC__DQMAP_0_3 {0} \
   CONFIG.PSU__DDRC__DQMAP_12_15 {0} \
   CONFIG.PSU__DDRC__DQMAP_16_19 {0} \
   CONFIG.PSU__DDRC__DQMAP_20_23 {0} \
   CONFIG.PSU__DDRC__DQMAP_24_27 {0} \
   CONFIG.PSU__DDRC__DQMAP_28_31 {0} \
   CONFIG.PSU__DDRC__DQMAP_32_35 {0} \
   CONFIG.PSU__DDRC__DQMAP_36_39 {0} \
   CONFIG.PSU__DDRC__DQMAP_40_43 {0} \
   CONFIG.PSU__DDRC__DQMAP_44_47 {0} \
   CONFIG.PSU__DDRC__DQMAP_48_51 {0} \
   CONFIG.PSU__DDRC__DQMAP_4_7 {0} \
   CONFIG.PSU__DDRC__DQMAP_52_55 {0} \
   CONFIG.PSU__DDRC__DQMAP_56_59 {0} \
   CONFIG.PSU__DDRC__DQMAP_60_63 {0} \
   CONFIG.PSU__DDRC__DQMAP_64_67 {0} \
   CONFIG.PSU__DDRC__DQMAP_68_71 {0} \
   CONFIG.PSU__DDRC__DQMAP_8_11 {0} \
   CONFIG.PSU__DDRC__DRAM_WIDTH {8 Bits} \
   CONFIG.PSU__DDRC__ECC {Disabled} \
   CONFIG.PSU__DDRC__ENABLE_LP4_HAS_ECC_COMP {0} \
   CONFIG.PSU__DDRC__ENABLE_LP4_SLOWBOOT {0} \
   CONFIG.PSU__DDRC__FGRM {1X} \
   CONFIG.PSU__DDRC__LPDDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LPDDR4_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LP_ASR {manual normal} \
   CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
   CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
   CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
   CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
   CONFIG.PSU__DDRC__RANK_ADDR_COUNT {0} \
   CONFIG.PSU__DDRC__ROW_ADDR_COUNT {15} \
   CONFIG.PSU__DDRC__SB_TARGET {15-15-15} \
   CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
   CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
   CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
   CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
   CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
   CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
   CONFIG.PSU__DDRC__T_FAW {30.0} \
   CONFIG.PSU__DDRC__T_RAS_MIN {33} \
   CONFIG.PSU__DDRC__T_RC {47.06} \
   CONFIG.PSU__DDRC__T_RCD {15} \
   CONFIG.PSU__DDRC__T_RP {15} \
   CONFIG.PSU__DDRC__VENDOR_PART {OTHERS} \
   CONFIG.PSU__DDRC__VREF {1} \
   CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1} \
   CONFIG.PSU__DDR__INTERFACE__FREQMHZ {533.500} \
   CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {0} \
   CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DLL__ISUSED {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
   CONFIG.PSU__DP__LANE_SEL {Single Lower} \
   CONFIG.PSU__DP__REF_CLK_FREQ {27} \
   CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk3} \
   CONFIG.PSU__ENET3__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} \
   CONFIG.PSU__ENET3__GRP_MDIO__IO {MIO 76 .. 77} \
   CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75} \
   CONFIG.PSU__ENET3__PTP__ENABLE {0} \
   CONFIG.PSU__ENET3__TSU__ENABLE {0} \
   CONFIG.PSU__FPDMASTERS_COHERENCY {0} \
   CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {99.990005} \
   CONFIG.PSU__FPD_SLCR__WDT1__FREQMHZ {99.990005} \
   CONFIG.PSU__FPD_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__FPGA_PL0_ENABLE {1} \
   CONFIG.PSU__FPGA_PL1_ENABLE {1} \
   CONFIG.PSU__FPGA_PL2_ENABLE {1} \
   CONFIG.PSU__GEM3_COHERENCY {0} \
   CONFIG.PSU__GEM__TSU__ENABLE {0} \
   CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
   CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
   CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO_EMIO_WIDTH {95} \
   CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {95} \
   CONFIG.PSU__GT__LINK_SPEED {HBR} \
   CONFIG.PSU__GT__PRE_EMPH_LVL_4 {0} \
   CONFIG.PSU__GT__VLT_SWNG_LVL_4 {0} \
   CONFIG.PSU__HIGH_ADDRESS__ENABLE {1} \
   CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 14 .. 15} \
   CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 16 .. 17} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC0__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {99.990005} \
   CONFIG.PSU__IOU_SLCR__WDT0__FREQMHZ {99.990005} \
   CONFIG.PSU__IOU_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__LPD_SLCR__CSUPMU__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__LPD_SLCR__CSUPMU__FREQMHZ {100.000000} \
   CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP1__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
   CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
   CONFIG.PSU__PCIE__BAR0_64BIT {0} \
   CONFIG.PSU__PCIE__BAR0_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR0_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR0_VAL {0x0} \
   CONFIG.PSU__PCIE__BAR1_64BIT {0} \
   CONFIG.PSU__PCIE__BAR1_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR1_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR1_VAL {0x0} \
   CONFIG.PSU__PCIE__BAR2_64BIT {0} \
   CONFIG.PSU__PCIE__BAR2_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR2_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR2_VAL {0x0} \
   CONFIG.PSU__PCIE__BAR3_64BIT {0} \
   CONFIG.PSU__PCIE__BAR3_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR3_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR3_VAL {0x0} \
   CONFIG.PSU__PCIE__BAR4_64BIT {0} \
   CONFIG.PSU__PCIE__BAR4_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR4_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR4_VAL {0x0} \
   CONFIG.PSU__PCIE__BAR5_64BIT {0} \
   CONFIG.PSU__PCIE__BAR5_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR5_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR5_VAL {0x0} \
   CONFIG.PSU__PCIE__CLASS_CODE_BASE {0x06} \
   CONFIG.PSU__PCIE__CLASS_CODE_INTERFACE {0x0} \
   CONFIG.PSU__PCIE__CLASS_CODE_SUB {0x4} \
   CONFIG.PSU__PCIE__CLASS_CODE_VALUE {0x60400} \
   CONFIG.PSU__PCIE__CRS_SW_VISIBILITY {1} \
   CONFIG.PSU__PCIE__DEVICE_ID {0xD021} \
   CONFIG.PSU__PCIE__DEVICE_PORT_TYPE {Root Port} \
   CONFIG.PSU__PCIE__EROM_ENABLE {0} \
   CONFIG.PSU__PCIE__EROM_VAL {0x0} \
   CONFIG.PSU__PCIE__LANE0__ENABLE {1} \
   CONFIG.PSU__PCIE__LANE0__IO {GT Lane0} \
   CONFIG.PSU__PCIE__LANE1__ENABLE {0} \
   CONFIG.PSU__PCIE__LANE2__ENABLE {0} \
   CONFIG.PSU__PCIE__LANE3__ENABLE {0} \
   CONFIG.PSU__PCIE__LINK_SPEED {5.0 Gb/s} \
   CONFIG.PSU__PCIE__MAXIMUM_LINK_WIDTH {x1} \
   CONFIG.PSU__PCIE__MAX_PAYLOAD_SIZE {256 bytes} \
   CONFIG.PSU__PCIE__MSIX_BAR_INDICATOR {} \
   CONFIG.PSU__PCIE__MSIX_CAPABILITY {0} \
   CONFIG.PSU__PCIE__MSIX_PBA_BAR_INDICATOR {} \
   CONFIG.PSU__PCIE__MSIX_PBA_OFFSET {0} \
   CONFIG.PSU__PCIE__MSIX_TABLE_OFFSET {0} \
   CONFIG.PSU__PCIE__MSIX_TABLE_SIZE {0} \
   CONFIG.PSU__PCIE__MSI_64BIT_ADDR_CAPABLE {0} \
   CONFIG.PSU__PCIE__MSI_CAPABILITY {0} \
   CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__PCIE__PERIPHERAL__ENDPOINT_ENABLE {0} \
   CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_ENABLE {1} \
   CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_IO {MIO 31} \
   CONFIG.PSU__PCIE__REF_CLK_FREQ {100} \
   CONFIG.PSU__PCIE__REF_CLK_SEL {Ref Clk0} \
   CONFIG.PSU__PCIE__RESET__POLARITY {Active Low} \
   CONFIG.PSU__PCIE__REVISION_ID {0x0} \
   CONFIG.PSU__PCIE__SUBSYSTEM_ID {0x7} \
   CONFIG.PSU__PCIE__SUBSYSTEM_VENDOR_ID {0x10EE} \
   CONFIG.PSU__PCIE__VENDOR_ID {0x10EE} \
   CONFIG.PSU__PL_CLK0_BUF {TRUE} \
   CONFIG.PSU__PL_CLK1_BUF {TRUE} \
   CONFIG.PSU__PL_CLK2_BUF {TRUE} \
   CONFIG.PSU__PMU_COHERENCY {0} \
   CONFIG.PSU__PMU__AIBACK__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPI__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPO__ENABLE {0} \
   CONFIG.PSU__PMU__GPI0__ENABLE {0} \
   CONFIG.PSU__PMU__GPI1__ENABLE {0} \
   CONFIG.PSU__PMU__GPI2__ENABLE {0} \
   CONFIG.PSU__PMU__GPI3__ENABLE {0} \
   CONFIG.PSU__PMU__GPI4__ENABLE {0} \
   CONFIG.PSU__PMU__GPI5__ENABLE {0} \
   CONFIG.PSU__PMU__GPO0__ENABLE {1} \
   CONFIG.PSU__PMU__GPO0__IO {MIO 32} \
   CONFIG.PSU__PMU__GPO1__ENABLE {1} \
   CONFIG.PSU__PMU__GPO1__IO {MIO 33} \
   CONFIG.PSU__PMU__GPO2__ENABLE {1} \
   CONFIG.PSU__PMU__GPO2__IO {MIO 34} \
   CONFIG.PSU__PMU__GPO2__POLARITY {high} \
   CONFIG.PSU__PMU__GPO3__ENABLE {1} \
   CONFIG.PSU__PMU__GPO3__IO {MIO 35} \
   CONFIG.PSU__PMU__GPO3__POLARITY {low} \
   CONFIG.PSU__PMU__GPO4__ENABLE {1} \
   CONFIG.PSU__PMU__GPO4__IO {MIO 36} \
   CONFIG.PSU__PMU__GPO4__POLARITY {low} \
   CONFIG.PSU__PMU__GPO5__ENABLE {1} \
   CONFIG.PSU__PMU__GPO5__IO {MIO 37} \
   CONFIG.PSU__PMU__GPO5__POLARITY {low} \
   CONFIG.PSU__PMU__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__PMU__PLERROR__ENABLE {0} \
   CONFIG.PSU__PRESET_APPLIED {1} \
   CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;1|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;1|S_AXI_HP2_FPD:NA;1|S_AXI_HP1_FPD:NA;1|S_AXI_HP0_FPD:NA;1|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;0|SATA1:NonSecure;1|SATA0:NonSecure;1|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;1|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;1|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;1|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
   CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;1|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;1|LPD;TTC2;FF130000;FF13FFFF;1|LPD;TTC1;FF120000;FF12FFFF;1|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;1|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;1|LPD;SPI0;FF040000;FF04FFFF;1|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;1|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|FPD;RCPU_GIC;F9000000;F900FFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;1|FPD;PCIE_LOW;E0000000;EFFFFFFF;1|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;1|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;1|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;1|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;1|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;1|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_GPV;FD700000;FD7FFFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display Port;FD4A0000;FD4AFFFF;1|FPD;DPDMA;FD4C0000;FD4CFFFF;1|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;87FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;0|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|FPD;CCI_GPV;FD6E0000;FD6EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;1|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1} \
   CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.330} \
   CONFIG.PSU__QSPI_COHERENCY {0} \
   CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {1} \
   CONFIG.PSU__QSPI__GRP_FBCLK__IO {MIO 6} \
   CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
   CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 12} \
   CONFIG.PSU__QSPI__PERIPHERAL__MODE {Dual Parallel} \
   CONFIG.PSU__SATA__LANE0__ENABLE {0} \
   CONFIG.PSU__SATA__LANE1__ENABLE {1} \
   CONFIG.PSU__SATA__LANE1__IO {GT Lane3} \
   CONFIG.PSU__SATA__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SATA__REF_CLK_FREQ {125} \
   CONFIG.PSU__SATA__REF_CLK_SEL {Ref Clk1} \
   CONFIG.PSU__SAXIGP2__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP3__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP4__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP5__DATA_WIDTH {128} \
   CONFIG.PSU__SD1_COHERENCY {0} \
   CONFIG.PSU__SD1__DATA_TRANSFER_MODE {8Bit} \
   CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
   CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
   CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
   CONFIG.PSU__SD1__GRP_WP__ENABLE {1} \
   CONFIG.PSU__SD1__GRP_WP__IO {MIO 44} \
   CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 39 .. 51} \
   CONFIG.PSU__SD1__RESET__ENABLE {0} \
   CONFIG.PSU__SD1__SLOT_TYPE {SD 3.0} \
   CONFIG.PSU__SPI0__GRP_SS0__ENABLE {1} \
   CONFIG.PSU__SPI0__GRP_SS0__IO {EMIO} \
   CONFIG.PSU__SPI0__GRP_SS1__ENABLE {1} \
   CONFIG.PSU__SPI0__GRP_SS1__IO {EMIO} \
   CONFIG.PSU__SPI0__GRP_SS2__ENABLE {1} \
   CONFIG.PSU__SPI0__GRP_SS2__IO {EMIO} \
   CONFIG.PSU__SPI0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SPI0__PERIPHERAL__IO {EMIO} \
   CONFIG.PSU__SPI1__GRP_SS0__ENABLE {1} \
   CONFIG.PSU__SPI1__GRP_SS0__IO {EMIO} \
   CONFIG.PSU__SPI1__GRP_SS1__ENABLE {1} \
   CONFIG.PSU__SPI1__GRP_SS1__IO {EMIO} \
   CONFIG.PSU__SPI1__GRP_SS2__ENABLE {1} \
   CONFIG.PSU__SPI1__GRP_SS2__IO {EMIO} \
   CONFIG.PSU__SPI1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SPI1__PERIPHERAL__IO {EMIO} \
   CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
   CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
   CONFIG.PSU__TSU__BUFG_PORT_PAIR {0} \
   CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__UART0__BAUD_RATE {115200} \
   CONFIG.PSU__UART0__MODEM__ENABLE {0} \
   CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19} \
   CONFIG.PSU__UART1__BAUD_RATE {115200} \
   CONFIG.PSU__UART1__MODEM__ENABLE {0} \
   CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 20 .. 21} \
   CONFIG.PSU__USB0_COHERENCY {0} \
   CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
   CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
   CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk2} \
   CONFIG.PSU__USB0__RESET__ENABLE {0} \
   CONFIG.PSU__USB1__RESET__ENABLE {0} \
   CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
   CONFIG.PSU__USB__RESET__MODE {Boot Pin} \
   CONFIG.PSU__USB__RESET__POLARITY {Active Low} \
   CONFIG.PSU__USE__IRQ0 {1} \
   CONFIG.PSU__USE__IRQ1 {1} \
   CONFIG.PSU__USE__M_AXI_GP0 {0} \
   CONFIG.PSU__USE__M_AXI_GP1 {0} \
   CONFIG.PSU__USE__M_AXI_GP2 {1} \
   CONFIG.PSU__USE__S_AXI_GP2 {1} \
   CONFIG.PSU__USE__S_AXI_GP3 {1} \
   CONFIG.PSU__USE__S_AXI_GP4 {1} \
   CONFIG.PSU__USE__S_AXI_GP5 {1} \
   CONFIG.SUBPRESET1 {Custom} \
 ] $sys_ps8

  # Create instance: sys_rstgen, and set properties
  set sys_rstgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rstgen ]
  set_property -dict [ list \
   CONFIG.C_EXT_RST_WIDTH {1} \
 ] $sys_rstgen

  # Create instance: tx_adrv9009_tpl_core
  create_hier_cell_tx_adrv9009_tpl_core [current_bd_instance .] tx_adrv9009_tpl_core

  # Create instance: tx_fir_interpolator
  create_hier_cell_tx_fir_interpolator [current_bd_instance .] tx_fir_interpolator

  # Create instance: util_adrv9009_rx_cpack, and set properties
  set util_adrv9009_rx_cpack [ create_bd_cell -type ip -vlnv analog.com:user:util_cpack2:1.0 util_adrv9009_rx_cpack ]
  set_property -dict [ list \
   CONFIG.NUM_OF_CHANNELS {4} \
   CONFIG.SAMPLES_PER_CHANNEL {1} \
   CONFIG.SAMPLE_DATA_WIDTH {16} \
 ] $util_adrv9009_rx_cpack

  # Create instance: util_adrv9009_rx_os_cpack, and set properties
  set util_adrv9009_rx_os_cpack [ create_bd_cell -type ip -vlnv analog.com:user:util_cpack2:1.0 util_adrv9009_rx_os_cpack ]
  set_property -dict [ list \
   CONFIG.NUM_OF_CHANNELS {4} \
   CONFIG.SAMPLES_PER_CHANNEL {1} \
   CONFIG.SAMPLE_DATA_WIDTH {16} \
 ] $util_adrv9009_rx_os_cpack

  # Create instance: util_adrv9009_tx_upack, and set properties
  set util_adrv9009_tx_upack [ create_bd_cell -type ip -vlnv analog.com:user:util_upack2:1.0 util_adrv9009_tx_upack ]
  set_property -dict [ list \
   CONFIG.NUM_OF_CHANNELS {4} \
   CONFIG.SAMPLES_PER_CHANNEL {2} \
   CONFIG.SAMPLE_DATA_WIDTH {16} \
 ] $util_adrv9009_tx_upack

  # Create instance: util_adrv9009_xcvr, and set properties
  set util_adrv9009_xcvr [ create_bd_cell -type ip -vlnv analog.com:user:util_adxcvr:1.0 util_adrv9009_xcvr ]
  set_property -dict [ list \
   CONFIG.CPLL_FBDIV {4} \
   CONFIG.CPLL_FBDIV_4_5 {5} \
   CONFIG.QPLL_FBDIV {"0001010000"} \
   CONFIG.QPLL_REFCLK_DIV {1} \
   CONFIG.RX_CDR_CFG {0x0b000023ff10400020} \
   CONFIG.RX_CLK25_DIV {10} \
   CONFIG.RX_NUM_OF_LANES {4} \
   CONFIG.RX_PMA_CFG {0x001E7080} \
   CONFIG.TX_CLK25_DIV {10} \
   CONFIG.TX_NUM_OF_LANES {4} \
   CONFIG.TX_OUT_DIV {1} \
 ] $util_adrv9009_xcvr

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_cpu_interconnect/S00_AXI] [get_bd_intf_pins sys_ps8/M_AXI_HPM0_LPD]
  connect_bd_intf_net -intf_net axi_adrv9009_rx_dma_m_dest_axi [get_bd_intf_pins axi_adrv9009_rx_dma/m_dest_axi] [get_bd_intf_pins axi_hp2_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_adrv9009_rx_os_dma_m_dest_axi [get_bd_intf_pins axi_adrv9009_rx_os_dma/m_dest_axi] [get_bd_intf_pins axi_hp1_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_adrv9009_rx_os_xcvr_m_axi [get_bd_intf_pins axi_adrv9009_rx_os_xcvr/m_axi] [get_bd_intf_pins axi_hp0_interconnect/S01_AXI]
  connect_bd_intf_net -intf_net axi_adrv9009_rx_os_xcvr_up_ch_0 [get_bd_intf_pins axi_adrv9009_rx_os_xcvr/up_ch_0] [get_bd_intf_pins util_adrv9009_xcvr/up_rx_2]
  connect_bd_intf_net -intf_net axi_adrv9009_rx_os_xcvr_up_ch_1 [get_bd_intf_pins axi_adrv9009_rx_os_xcvr/up_ch_1] [get_bd_intf_pins util_adrv9009_xcvr/up_rx_3]
  connect_bd_intf_net -intf_net axi_adrv9009_rx_os_xcvr_up_es_0 [get_bd_intf_pins axi_adrv9009_rx_os_xcvr/up_es_0] [get_bd_intf_pins util_adrv9009_xcvr/up_es_2]
  connect_bd_intf_net -intf_net axi_adrv9009_rx_os_xcvr_up_es_1 [get_bd_intf_pins axi_adrv9009_rx_os_xcvr/up_es_1] [get_bd_intf_pins util_adrv9009_xcvr/up_es_3]
  connect_bd_intf_net -intf_net axi_adrv9009_rx_xcvr_m_axi [get_bd_intf_pins axi_adrv9009_rx_xcvr/m_axi] [get_bd_intf_pins axi_hp0_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_adrv9009_rx_xcvr_up_ch_0 [get_bd_intf_pins axi_adrv9009_rx_xcvr/up_ch_0] [get_bd_intf_pins util_adrv9009_xcvr/up_rx_0]
  connect_bd_intf_net -intf_net axi_adrv9009_rx_xcvr_up_ch_1 [get_bd_intf_pins axi_adrv9009_rx_xcvr/up_ch_1] [get_bd_intf_pins util_adrv9009_xcvr/up_rx_1]
  connect_bd_intf_net -intf_net axi_adrv9009_rx_xcvr_up_es_0 [get_bd_intf_pins axi_adrv9009_rx_xcvr/up_es_0] [get_bd_intf_pins util_adrv9009_xcvr/up_es_0]
  connect_bd_intf_net -intf_net axi_adrv9009_rx_xcvr_up_es_1 [get_bd_intf_pins axi_adrv9009_rx_xcvr/up_es_1] [get_bd_intf_pins util_adrv9009_xcvr/up_es_1]
  connect_bd_intf_net -intf_net axi_adrv9009_tx_dma_m_src_axi [get_bd_intf_pins axi_adrv9009_tx_dma/m_src_axi] [get_bd_intf_pins axi_hp3_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_adrv9009_tx_jesd_tx_phy0 [get_bd_intf_pins axi_adrv9009_tx_jesd/tx_phy0] [get_bd_intf_pins util_adrv9009_xcvr/tx_0]
  connect_bd_intf_net -intf_net axi_adrv9009_tx_jesd_tx_phy1 [get_bd_intf_pins axi_adrv9009_tx_jesd/tx_phy1] [get_bd_intf_pins util_adrv9009_xcvr/tx_3]
  connect_bd_intf_net -intf_net axi_adrv9009_tx_jesd_tx_phy2 [get_bd_intf_pins axi_adrv9009_tx_jesd/tx_phy2] [get_bd_intf_pins util_adrv9009_xcvr/tx_2]
  connect_bd_intf_net -intf_net axi_adrv9009_tx_jesd_tx_phy3 [get_bd_intf_pins axi_adrv9009_tx_jesd/tx_phy3] [get_bd_intf_pins util_adrv9009_xcvr/tx_1]
  connect_bd_intf_net -intf_net axi_adrv9009_tx_xcvr_up_ch_0 [get_bd_intf_pins axi_adrv9009_tx_xcvr/up_ch_0] [get_bd_intf_pins util_adrv9009_xcvr/up_tx_0]
  connect_bd_intf_net -intf_net axi_adrv9009_tx_xcvr_up_ch_1 [get_bd_intf_pins axi_adrv9009_tx_xcvr/up_ch_1] [get_bd_intf_pins util_adrv9009_xcvr/up_tx_3]
  connect_bd_intf_net -intf_net axi_adrv9009_tx_xcvr_up_ch_2 [get_bd_intf_pins axi_adrv9009_tx_xcvr/up_ch_2] [get_bd_intf_pins util_adrv9009_xcvr/up_tx_2]
  connect_bd_intf_net -intf_net axi_adrv9009_tx_xcvr_up_ch_3 [get_bd_intf_pins axi_adrv9009_tx_xcvr/up_ch_3] [get_bd_intf_pins util_adrv9009_xcvr/up_tx_1]
  connect_bd_intf_net -intf_net axi_adrv9009_tx_xcvr_up_cm_0 [get_bd_intf_pins axi_adrv9009_tx_xcvr/up_cm_0] [get_bd_intf_pins util_adrv9009_xcvr/up_cm_0]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M00_AXI [get_bd_intf_pins axi_cpu_interconnect/M00_AXI] [get_bd_intf_pins axi_sysid_0/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M01_AXI [get_bd_intf_pins axi_cpu_interconnect/M01_AXI] [get_bd_intf_pins rx_adrv9009_tpl_core/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M02_AXI [get_bd_intf_pins axi_cpu_interconnect/M02_AXI] [get_bd_intf_pins tx_adrv9009_tpl_core/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M03_AXI [get_bd_intf_pins axi_cpu_interconnect/M03_AXI] [get_bd_intf_pins rx_os_adrv9009_tpl_core/s_axi]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M04_AXI [get_bd_intf_pins axi_adrv9009_tx_xcvr/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M04_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M05_AXI [get_bd_intf_pins axi_adrv9009_tx_clkgen/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M05_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M06_AXI [get_bd_intf_pins axi_adrv9009_tx_jesd/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M06_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M07_AXI [get_bd_intf_pins axi_adrv9009_tx_dma/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M07_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M08_AXI [get_bd_intf_pins axi_adrv9009_rx_xcvr/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M08_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M09_AXI [get_bd_intf_pins axi_adrv9009_rx_clkgen/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M09_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M10_AXI [get_bd_intf_pins axi_adrv9009_rx_jesd/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M10_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M11_AXI [get_bd_intf_pins axi_adrv9009_rx_dma/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M11_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M12_AXI [get_bd_intf_pins axi_adrv9009_rx_os_xcvr/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M12_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M13_AXI [get_bd_intf_pins axi_adrv9009_rx_os_clkgen/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M13_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M14_AXI [get_bd_intf_pins axi_adrv9009_rx_os_jesd/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M14_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M15_AXI [get_bd_intf_pins axi_adrv9009_rx_os_dma/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M15_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_M16_AXI [get_bd_intf_pins axi_cpu_interconnect/M16_AXI] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_hp0_interconnect_M00_AXI [get_bd_intf_pins axi_hp0_interconnect/M00_AXI] [get_bd_intf_pins sys_ps8/S_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net axi_hp1_interconnect_M00_AXI [get_bd_intf_pins axi_hp1_interconnect/M00_AXI] [get_bd_intf_pins sys_ps8/S_AXI_HP1_FPD]
  connect_bd_intf_net -intf_net axi_hp2_interconnect_M00_AXI [get_bd_intf_pins axi_hp2_interconnect/M00_AXI] [get_bd_intf_pins sys_ps8/S_AXI_HP2_FPD]
  connect_bd_intf_net -intf_net axi_hp3_interconnect_M00_AXI [get_bd_intf_pins axi_hp3_interconnect/M00_AXI] [get_bd_intf_pins sys_ps8/S_AXI_HP3_FPD]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_ports axi_regs] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_ports axi_tx_bram] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_ports axi_rx_bram] [get_bd_intf_pins axi_interconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_ports axi_drp] [get_bd_intf_pins axi_interconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net jtag_axi_0_M_AXI [get_bd_intf_pins axi_interconnect_0/S01_AXI] [get_bd_intf_pins jtag_axi_0/M_AXI]
  connect_bd_intf_net -intf_net tx_data_1 [get_bd_intf_pins axi_adrv9009_tx_jesd/tx_data] [get_bd_intf_pins tx_adrv9009_tpl_core/link]
  connect_bd_intf_net -intf_net util_adrv9009_rx_cpack_packed_fifo_wr [get_bd_intf_pins axi_adrv9009_rx_dma/fifo_wr] [get_bd_intf_pins util_adrv9009_rx_cpack/packed_fifo_wr]
  connect_bd_intf_net -intf_net util_adrv9009_rx_os_cpack_packed_fifo_wr [get_bd_intf_pins axi_adrv9009_rx_os_dma/fifo_wr] [get_bd_intf_pins util_adrv9009_rx_os_cpack/packed_fifo_wr]
  connect_bd_intf_net -intf_net util_adrv9009_xcvr_rx_0 [get_bd_intf_pins axi_adrv9009_rx_jesd/rx_phy0] [get_bd_intf_pins util_adrv9009_xcvr/rx_0]
  connect_bd_intf_net -intf_net util_adrv9009_xcvr_rx_1 [get_bd_intf_pins axi_adrv9009_rx_jesd/rx_phy1] [get_bd_intf_pins util_adrv9009_xcvr/rx_1]
  connect_bd_intf_net -intf_net util_adrv9009_xcvr_rx_2 [get_bd_intf_pins axi_adrv9009_rx_os_jesd/rx_phy0] [get_bd_intf_pins util_adrv9009_xcvr/rx_2]
  connect_bd_intf_net -intf_net util_adrv9009_xcvr_rx_3 [get_bd_intf_pins axi_adrv9009_rx_os_jesd/rx_phy1] [get_bd_intf_pins util_adrv9009_xcvr/rx_3]

  # Create port connections
  connect_bd_net -net GND_1_dout [get_bd_pins GND_1/dout] [get_bd_pins sys_concat_intc_0/In0] [get_bd_pins sys_concat_intc_0/In1] [get_bd_pins sys_concat_intc_0/In2] [get_bd_pins sys_concat_intc_0/In3] [get_bd_pins sys_concat_intc_0/In4] [get_bd_pins sys_concat_intc_0/In5] [get_bd_pins sys_concat_intc_0/In6] [get_bd_pins sys_concat_intc_0/In7] [get_bd_pins sys_concat_intc_1/In6] [get_bd_pins sys_concat_intc_1/In7] [get_bd_pins sys_ps8/emio_spi0_s_i] [get_bd_pins sys_ps8/emio_spi0_sclk_i] [get_bd_pins sys_ps8/emio_spi1_s_i] [get_bd_pins sys_ps8/emio_spi1_sclk_i] [get_bd_pins tx_fir_interpolator/load_config]
  connect_bd_net -net GND_32_dout [get_bd_pins GND_32/dout] [get_bd_pins tx_fir_interpolator/pulse_width]
  connect_bd_net -net VCC_1_dout [get_bd_pins VCC_1/dout] [get_bd_pins rx_fir_decimator/out_resetn] [get_bd_pins sys_ps8/emio_spi0_ss_i_n] [get_bd_pins sys_ps8/emio_spi1_ss_i_n] [get_bd_pins tx_fir_interpolator/out_resetn] [get_bd_pins util_adrv9009_tx_upack/s_axis_valid]
  connect_bd_net -net active_1 [get_bd_ports dac_fir_filter_active] [get_bd_pins tx_fir_interpolator/active]
  connect_bd_net -net active_2 [get_bd_ports adc_fir_filter_active] [get_bd_pins rx_fir_decimator/active]
  connect_bd_net -net adc_dovf_1 [get_bd_pins rx_adrv9009_tpl_core/adc_dovf] [get_bd_pins util_adrv9009_rx_cpack/fifo_wr_overflow]
  connect_bd_net -net adc_dovf_2 [get_bd_pins rx_os_adrv9009_tpl_core/adc_dovf] [get_bd_pins util_adrv9009_rx_os_cpack/fifo_wr_overflow]
  connect_bd_net -net adrv9009_rx_device_clk [get_bd_pins adrv9009_rx_device_clk_rstgen/slowest_sync_clk] [get_bd_pins axi_adrv9009_rx_clkgen/clk_0] [get_bd_pins axi_adrv9009_rx_dma/fifo_wr_clk] [get_bd_pins axi_adrv9009_rx_jesd/device_clk] [get_bd_pins rx_adrv9009_tpl_core/link_clk] [get_bd_pins rx_fir_decimator/aclk] [get_bd_pins util_adrv9009_rx_cpack/clk] [get_bd_pins util_adrv9009_xcvr/rx_clk_0] [get_bd_pins util_adrv9009_xcvr/rx_clk_1]
  connect_bd_net -net adrv9009_rx_device_clk_rstgen_peripheral_reset [get_bd_pins adrv9009_rx_device_clk_rstgen/peripheral_reset] [get_bd_pins util_adrv9009_rx_cpack/reset]
  connect_bd_net -net adrv9009_rx_os_device_clk [get_bd_pins adrv9009_rx_os_device_clk_rstgen/slowest_sync_clk] [get_bd_pins axi_adrv9009_rx_os_clkgen/clk_0] [get_bd_pins axi_adrv9009_rx_os_dma/fifo_wr_clk] [get_bd_pins axi_adrv9009_rx_os_jesd/device_clk] [get_bd_pins rx_os_adrv9009_tpl_core/link_clk] [get_bd_pins util_adrv9009_rx_os_cpack/clk] [get_bd_pins util_adrv9009_xcvr/rx_clk_2] [get_bd_pins util_adrv9009_xcvr/rx_clk_3]
  connect_bd_net -net adrv9009_rx_os_device_clk_rstgen_peripheral_reset [get_bd_pins adrv9009_rx_os_device_clk_rstgen/peripheral_reset] [get_bd_pins util_adrv9009_rx_os_cpack/reset]
  connect_bd_net -net adrv9009_tx_device_clk [get_bd_pins adrv9009_tx_device_clk_rstgen/slowest_sync_clk] [get_bd_pins axi_adrv9009_dacfifo/dac_clk] [get_bd_pins axi_adrv9009_tx_clkgen/clk_0] [get_bd_pins axi_adrv9009_tx_jesd/device_clk] [get_bd_pins tx_adrv9009_tpl_core/link_clk] [get_bd_pins tx_fir_interpolator/aclk] [get_bd_pins util_adrv9009_tx_upack/clk] [get_bd_pins util_adrv9009_xcvr/tx_clk_0] [get_bd_pins util_adrv9009_xcvr/tx_clk_1] [get_bd_pins util_adrv9009_xcvr/tx_clk_2] [get_bd_pins util_adrv9009_xcvr/tx_clk_3]
  connect_bd_net -net adrv9009_tx_device_clk_rstgen_peripheral_reset [get_bd_pins adrv9009_tx_device_clk_rstgen/peripheral_reset] [get_bd_pins axi_adrv9009_dacfifo/dac_rst] [get_bd_pins util_adrv9009_tx_upack/reset]
  connect_bd_net -net axi_adrv9009_dacfifo_dac_data [get_bd_pins axi_adrv9009_dacfifo/dac_data] [get_bd_pins util_adrv9009_tx_upack/s_axis_data]
  connect_bd_net -net axi_adrv9009_dacfifo_dac_dunf [get_bd_pins axi_adrv9009_dacfifo/dac_dunf] [get_bd_pins tx_adrv9009_tpl_core/dac_dunf]
  connect_bd_net -net axi_adrv9009_dacfifo_dma_ready [get_bd_pins axi_adrv9009_dacfifo/dma_ready] [get_bd_pins axi_adrv9009_tx_dma/m_axis_ready]
  connect_bd_net -net axi_adrv9009_rx_dma_irq [get_bd_pins axi_adrv9009_rx_dma/irq] [get_bd_pins sys_concat_intc_1/In5]
  connect_bd_net -net axi_adrv9009_rx_jesd_irq [get_bd_pins axi_adrv9009_rx_jesd/irq] [get_bd_pins sys_concat_intc_1/In2]
  connect_bd_net -net axi_adrv9009_rx_jesd_phy_en_char_align [get_bd_pins axi_adrv9009_rx_jesd/phy_en_char_align] [get_bd_pins util_adrv9009_xcvr/rx_calign_0] [get_bd_pins util_adrv9009_xcvr/rx_calign_1]
  connect_bd_net -net axi_adrv9009_rx_jesd_rx_data_tdata [get_bd_pins axi_adrv9009_rx_jesd/rx_data_tdata] [get_bd_pins rx_adrv9009_tpl_core/link_data]
  connect_bd_net -net axi_adrv9009_rx_jesd_rx_data_tvalid [get_bd_pins axi_adrv9009_rx_jesd/rx_data_tvalid] [get_bd_pins rx_adrv9009_tpl_core/link_valid]
  connect_bd_net -net axi_adrv9009_rx_jesd_rx_sof [get_bd_pins axi_adrv9009_rx_jesd/rx_sof] [get_bd_pins rx_adrv9009_tpl_core/link_sof]
  connect_bd_net -net axi_adrv9009_rx_jesd_sync [get_bd_ports rx_sync_0] [get_bd_pins axi_adrv9009_rx_jesd/sync]
  connect_bd_net -net axi_adrv9009_rx_os_dma_irq [get_bd_pins axi_adrv9009_rx_os_dma/irq] [get_bd_pins sys_concat_intc_1/In3]
  connect_bd_net -net axi_adrv9009_rx_os_jesd_irq [get_bd_pins axi_adrv9009_rx_os_jesd/irq] [get_bd_pins sys_concat_intc_1/In0]
  connect_bd_net -net axi_adrv9009_rx_os_jesd_phy_en_char_align [get_bd_pins axi_adrv9009_rx_os_jesd/phy_en_char_align] [get_bd_pins util_adrv9009_xcvr/rx_calign_2] [get_bd_pins util_adrv9009_xcvr/rx_calign_3]
  connect_bd_net -net axi_adrv9009_rx_os_jesd_rx_data_tdata [get_bd_pins axi_adrv9009_rx_os_jesd/rx_data_tdata] [get_bd_pins rx_os_adrv9009_tpl_core/link_data]
  connect_bd_net -net axi_adrv9009_rx_os_jesd_rx_data_tvalid [get_bd_pins axi_adrv9009_rx_os_jesd/rx_data_tvalid] [get_bd_pins rx_os_adrv9009_tpl_core/link_valid]
  connect_bd_net -net axi_adrv9009_rx_os_jesd_rx_sof [get_bd_pins axi_adrv9009_rx_os_jesd/rx_sof] [get_bd_pins rx_os_adrv9009_tpl_core/link_sof]
  connect_bd_net -net axi_adrv9009_rx_os_jesd_sync [get_bd_ports rx_sync_2] [get_bd_pins axi_adrv9009_rx_os_jesd/sync]
  connect_bd_net -net axi_adrv9009_rx_os_xcvr_up_pll_rst [get_bd_pins axi_adrv9009_rx_os_xcvr/up_pll_rst] [get_bd_pins util_adrv9009_xcvr/up_cpll_rst_2] [get_bd_pins util_adrv9009_xcvr/up_cpll_rst_3]
  connect_bd_net -net axi_adrv9009_rx_xcvr_up_pll_rst [get_bd_pins axi_adrv9009_rx_xcvr/up_pll_rst] [get_bd_pins util_adrv9009_xcvr/up_cpll_rst_0] [get_bd_pins util_adrv9009_xcvr/up_cpll_rst_1]
  connect_bd_net -net axi_adrv9009_tx_dma_irq [get_bd_pins axi_adrv9009_tx_dma/irq] [get_bd_pins sys_concat_intc_1/In4]
  connect_bd_net -net axi_adrv9009_tx_dma_m_axis_data [get_bd_pins axi_adrv9009_dacfifo/dma_data] [get_bd_pins axi_adrv9009_tx_dma/m_axis_data]
  connect_bd_net -net axi_adrv9009_tx_dma_m_axis_last [get_bd_pins axi_adrv9009_dacfifo/dma_xfer_last] [get_bd_pins axi_adrv9009_tx_dma/m_axis_last]
  connect_bd_net -net axi_adrv9009_tx_dma_m_axis_valid [get_bd_pins axi_adrv9009_dacfifo/dma_valid] [get_bd_pins axi_adrv9009_tx_dma/m_axis_valid]
  connect_bd_net -net axi_adrv9009_tx_dma_m_axis_xfer_req [get_bd_pins axi_adrv9009_dacfifo/dma_xfer_req] [get_bd_pins axi_adrv9009_tx_dma/m_axis_xfer_req]
  connect_bd_net -net axi_adrv9009_tx_jesd_irq [get_bd_pins axi_adrv9009_tx_jesd/irq] [get_bd_pins sys_concat_intc_1/In1]
  connect_bd_net -net axi_adrv9009_tx_xcvr_up_pll_rst [get_bd_pins axi_adrv9009_tx_xcvr/up_pll_rst] [get_bd_pins util_adrv9009_xcvr/up_qpll_rst_0]
  connect_bd_net -net axi_sysid_0_rom_addr [get_bd_pins axi_sysid_0/rom_addr] [get_bd_pins rom_sys_0/rom_addr]
  connect_bd_net -net dac_fifo_bypass_1 [get_bd_ports dac_fifo_bypass] [get_bd_pins axi_adrv9009_dacfifo/bypass]
  connect_bd_net -net gpio_i_1 [get_bd_ports gpio_i] [get_bd_pins sys_ps8/emio_gpio_i]
  connect_bd_net -net logic_or_Res [get_bd_pins logic_or/Res] [get_bd_pins util_adrv9009_tx_upack/fifo_rd_en]
  connect_bd_net -net rom_sys_0_rom_data [get_bd_pins axi_sysid_0/sys_rom_data] [get_bd_pins rom_sys_0/rom_data]
  connect_bd_net -net rx_adrv9009_tpl_core_adc_data_0 [get_bd_pins rx_adrv9009_tpl_core/adc_data_0] [get_bd_pins rx_fir_decimator/data_in_0]
  connect_bd_net -net rx_adrv9009_tpl_core_adc_data_1 [get_bd_pins rx_adrv9009_tpl_core/adc_data_1] [get_bd_pins rx_fir_decimator/data_in_1]
  connect_bd_net -net rx_adrv9009_tpl_core_adc_data_2 [get_bd_pins rx_adrv9009_tpl_core/adc_data_2] [get_bd_pins rx_fir_decimator/data_in_2]
  connect_bd_net -net rx_adrv9009_tpl_core_adc_data_3 [get_bd_pins rx_adrv9009_tpl_core/adc_data_3] [get_bd_pins rx_fir_decimator/data_in_3]
  connect_bd_net -net rx_adrv9009_tpl_core_adc_enable_0 [get_bd_pins rx_adrv9009_tpl_core/adc_enable_0] [get_bd_pins rx_fir_decimator/enable_in_0]
  connect_bd_net -net rx_adrv9009_tpl_core_adc_enable_1 [get_bd_pins rx_adrv9009_tpl_core/adc_enable_1] [get_bd_pins rx_fir_decimator/enable_in_1]
  connect_bd_net -net rx_adrv9009_tpl_core_adc_enable_2 [get_bd_pins rx_adrv9009_tpl_core/adc_enable_2] [get_bd_pins rx_fir_decimator/enable_in_2]
  connect_bd_net -net rx_adrv9009_tpl_core_adc_enable_3 [get_bd_pins rx_adrv9009_tpl_core/adc_enable_3] [get_bd_pins rx_fir_decimator/enable_in_3]
  connect_bd_net -net rx_adrv9009_tpl_core_adc_valid_0 [get_bd_pins rx_adrv9009_tpl_core/adc_valid_0] [get_bd_pins rx_fir_decimator/valid_in_0]
  connect_bd_net -net rx_adrv9009_tpl_core_adc_valid_1 [get_bd_pins rx_adrv9009_tpl_core/adc_valid_1] [get_bd_pins rx_fir_decimator/valid_in_1]
  connect_bd_net -net rx_adrv9009_tpl_core_adc_valid_2 [get_bd_pins rx_adrv9009_tpl_core/adc_valid_2] [get_bd_pins rx_fir_decimator/valid_in_2]
  connect_bd_net -net rx_adrv9009_tpl_core_adc_valid_3 [get_bd_pins rx_adrv9009_tpl_core/adc_valid_3] [get_bd_pins rx_fir_decimator/valid_in_3]
  connect_bd_net -net rx_data_0_n_1 [get_bd_ports rx_data_0_n] [get_bd_pins util_adrv9009_xcvr/rx_0_n]
  connect_bd_net -net rx_data_0_p_1 [get_bd_ports rx_data_0_p] [get_bd_pins util_adrv9009_xcvr/rx_0_p]
  connect_bd_net -net rx_data_1_n_1 [get_bd_ports rx_data_1_n] [get_bd_pins util_adrv9009_xcvr/rx_1_n]
  connect_bd_net -net rx_data_1_p_1 [get_bd_ports rx_data_1_p] [get_bd_pins util_adrv9009_xcvr/rx_1_p]
  connect_bd_net -net rx_data_2_n_1 [get_bd_ports rx_data_2_n] [get_bd_pins util_adrv9009_xcvr/rx_2_n]
  connect_bd_net -net rx_data_2_p_1 [get_bd_ports rx_data_2_p] [get_bd_pins util_adrv9009_xcvr/rx_2_p]
  connect_bd_net -net rx_data_3_n_1 [get_bd_ports rx_data_3_n] [get_bd_pins util_adrv9009_xcvr/rx_3_n]
  connect_bd_net -net rx_data_3_p_1 [get_bd_ports rx_data_3_p] [get_bd_pins util_adrv9009_xcvr/rx_3_p]
  connect_bd_net -net rx_fir_decimator_data_out_0 [get_bd_pins rx_fir_decimator/data_out_0] [get_bd_pins util_adrv9009_rx_cpack/fifo_wr_data_0]
  connect_bd_net -net rx_fir_decimator_data_out_1 [get_bd_pins rx_fir_decimator/data_out_1] [get_bd_pins util_adrv9009_rx_cpack/fifo_wr_data_1]
  connect_bd_net -net rx_fir_decimator_data_out_2 [get_bd_pins rx_fir_decimator/data_out_2] [get_bd_pins util_adrv9009_rx_cpack/fifo_wr_data_2]
  connect_bd_net -net rx_fir_decimator_data_out_3 [get_bd_pins rx_fir_decimator/data_out_3] [get_bd_pins util_adrv9009_rx_cpack/fifo_wr_data_3]
  connect_bd_net -net rx_fir_decimator_enable_out_0 [get_bd_pins rx_fir_decimator/enable_out_0] [get_bd_pins util_adrv9009_rx_cpack/enable_0]
  connect_bd_net -net rx_fir_decimator_enable_out_1 [get_bd_pins rx_fir_decimator/enable_out_1] [get_bd_pins util_adrv9009_rx_cpack/enable_1]
  connect_bd_net -net rx_fir_decimator_enable_out_2 [get_bd_pins rx_fir_decimator/enable_out_2] [get_bd_pins util_adrv9009_rx_cpack/enable_2]
  connect_bd_net -net rx_fir_decimator_enable_out_3 [get_bd_pins rx_fir_decimator/enable_out_3] [get_bd_pins util_adrv9009_rx_cpack/enable_3]
  connect_bd_net -net rx_fir_decimator_valid_out_0 [get_bd_pins rx_fir_decimator/valid_out_0] [get_bd_pins util_adrv9009_rx_cpack/fifo_wr_en]
  connect_bd_net -net rx_os_adrv9009_tpl_core_adc_data_0 [get_bd_pins rx_os_adrv9009_tpl_core/adc_data_0] [get_bd_pins util_adrv9009_rx_os_cpack/fifo_wr_data_0]
  connect_bd_net -net rx_os_adrv9009_tpl_core_adc_data_1 [get_bd_pins rx_os_adrv9009_tpl_core/adc_data_1] [get_bd_pins util_adrv9009_rx_os_cpack/fifo_wr_data_1]
  connect_bd_net -net rx_os_adrv9009_tpl_core_adc_data_2 [get_bd_pins rx_os_adrv9009_tpl_core/adc_data_2] [get_bd_pins util_adrv9009_rx_os_cpack/fifo_wr_data_2]
  connect_bd_net -net rx_os_adrv9009_tpl_core_adc_data_3 [get_bd_pins rx_os_adrv9009_tpl_core/adc_data_3] [get_bd_pins util_adrv9009_rx_os_cpack/fifo_wr_data_3]
  connect_bd_net -net rx_os_adrv9009_tpl_core_adc_enable_0 [get_bd_pins rx_os_adrv9009_tpl_core/adc_enable_0] [get_bd_pins util_adrv9009_rx_os_cpack/enable_0]
  connect_bd_net -net rx_os_adrv9009_tpl_core_adc_enable_1 [get_bd_pins rx_os_adrv9009_tpl_core/adc_enable_1] [get_bd_pins util_adrv9009_rx_os_cpack/enable_1]
  connect_bd_net -net rx_os_adrv9009_tpl_core_adc_enable_2 [get_bd_pins rx_os_adrv9009_tpl_core/adc_enable_2] [get_bd_pins util_adrv9009_rx_os_cpack/enable_2]
  connect_bd_net -net rx_os_adrv9009_tpl_core_adc_enable_3 [get_bd_pins rx_os_adrv9009_tpl_core/adc_enable_3] [get_bd_pins util_adrv9009_rx_os_cpack/enable_3]
  connect_bd_net -net rx_os_adrv9009_tpl_core_adc_valid_0 [get_bd_pins rx_os_adrv9009_tpl_core/adc_valid_0] [get_bd_pins util_adrv9009_rx_os_cpack/fifo_wr_en]
  connect_bd_net -net rx_ref_clk_0_1 [get_bd_ports rx_ref_clk_0] [get_bd_pins util_adrv9009_xcvr/cpll_ref_clk_0] [get_bd_pins util_adrv9009_xcvr/cpll_ref_clk_1]
  connect_bd_net -net rx_ref_clk_2_1 [get_bd_ports rx_ref_clk_2] [get_bd_pins util_adrv9009_xcvr/cpll_ref_clk_2] [get_bd_pins util_adrv9009_xcvr/cpll_ref_clk_3]
  connect_bd_net -net spi0_csn_concat_dout [get_bd_ports spi0_csn] [get_bd_pins spi0_csn_concat/dout]
  connect_bd_net -net spi0_miso_1 [get_bd_ports spi0_miso] [get_bd_pins sys_ps8/emio_spi0_m_i]
  connect_bd_net -net spi1_csn_concat_dout [get_bd_ports spi1_csn] [get_bd_pins spi1_csn_concat/dout]
  connect_bd_net -net spi1_miso_1 [get_bd_ports spi1_miso] [get_bd_pins sys_ps8/emio_spi1_m_i]
  connect_bd_net -net sync_1 [get_bd_ports tx_sync_0] [get_bd_pins axi_adrv9009_tx_jesd/sync]
  connect_bd_net -net sys_250m_clk [get_bd_pins axi_adrv9009_dacfifo/dma_clk] [get_bd_pins axi_adrv9009_rx_dma/m_dest_axi_aclk] [get_bd_pins axi_adrv9009_rx_os_dma/m_dest_axi_aclk] [get_bd_pins axi_adrv9009_tx_dma/m_axis_aclk] [get_bd_pins axi_adrv9009_tx_dma/m_src_axi_aclk] [get_bd_pins axi_hp1_interconnect/aclk] [get_bd_pins axi_hp2_interconnect/aclk] [get_bd_pins axi_hp3_interconnect/aclk] [get_bd_pins sys_250m_rstgen/slowest_sync_clk] [get_bd_pins sys_ps8/pl_clk1] [get_bd_pins sys_ps8/saxihp1_fpd_aclk] [get_bd_pins sys_ps8/saxihp2_fpd_aclk] [get_bd_pins sys_ps8/saxihp3_fpd_aclk]
  connect_bd_net -net sys_250m_reset [get_bd_pins axi_adrv9009_dacfifo/dma_rst] [get_bd_pins sys_250m_rstgen/peripheral_reset]
  connect_bd_net -net sys_250m_resetn [get_bd_pins axi_adrv9009_rx_dma/m_dest_axi_aresetn] [get_bd_pins axi_adrv9009_rx_os_dma/m_dest_axi_aresetn] [get_bd_pins axi_adrv9009_tx_dma/m_src_axi_aresetn] [get_bd_pins axi_hp1_interconnect/aresetn] [get_bd_pins axi_hp2_interconnect/aresetn] [get_bd_pins axi_hp3_interconnect/aresetn] [get_bd_pins sys_250m_rstgen/peripheral_aresetn]
  connect_bd_net -net sys_500m_clk [get_bd_pins sys_500m_rstgen/slowest_sync_clk] [get_bd_pins sys_ps8/pl_clk2]
  connect_bd_net -net sys_500m_reset [get_bd_pins sys_500m_rstgen/peripheral_reset]
  connect_bd_net -net sys_500m_resetn [get_bd_pins sys_500m_rstgen/peripheral_aresetn]
  connect_bd_net -net sys_concat_intc_0_dout [get_bd_pins sys_concat_intc_0/dout] [get_bd_pins sys_ps8/pl_ps_irq0]
  connect_bd_net -net sys_concat_intc_1_dout [get_bd_pins sys_concat_intc_1/dout] [get_bd_pins sys_ps8/pl_ps_irq1]
  connect_bd_net -net sys_cpu_clk [get_bd_ports axi_clk] [get_bd_pins axi_adrv9009_rx_clkgen/s_axi_aclk] [get_bd_pins axi_adrv9009_rx_dma/s_axi_aclk] [get_bd_pins axi_adrv9009_rx_jesd/s_axi_aclk] [get_bd_pins axi_adrv9009_rx_os_clkgen/s_axi_aclk] [get_bd_pins axi_adrv9009_rx_os_dma/s_axi_aclk] [get_bd_pins axi_adrv9009_rx_os_jesd/s_axi_aclk] [get_bd_pins axi_adrv9009_rx_os_xcvr/s_axi_aclk] [get_bd_pins axi_adrv9009_rx_xcvr/s_axi_aclk] [get_bd_pins axi_adrv9009_tx_clkgen/s_axi_aclk] [get_bd_pins axi_adrv9009_tx_dma/s_axi_aclk] [get_bd_pins axi_adrv9009_tx_jesd/s_axi_aclk] [get_bd_pins axi_adrv9009_tx_xcvr/s_axi_aclk] [get_bd_pins axi_cpu_interconnect/ACLK] [get_bd_pins axi_cpu_interconnect/M00_ACLK] [get_bd_pins axi_cpu_interconnect/M01_ACLK] [get_bd_pins axi_cpu_interconnect/M02_ACLK] [get_bd_pins axi_cpu_interconnect/M03_ACLK] [get_bd_pins axi_cpu_interconnect/M04_ACLK] [get_bd_pins axi_cpu_interconnect/M05_ACLK] [get_bd_pins axi_cpu_interconnect/M06_ACLK] [get_bd_pins axi_cpu_interconnect/M07_ACLK] [get_bd_pins axi_cpu_interconnect/M08_ACLK] [get_bd_pins axi_cpu_interconnect/M09_ACLK] [get_bd_pins axi_cpu_interconnect/M10_ACLK] [get_bd_pins axi_cpu_interconnect/M11_ACLK] [get_bd_pins axi_cpu_interconnect/M12_ACLK] [get_bd_pins axi_cpu_interconnect/M13_ACLK] [get_bd_pins axi_cpu_interconnect/M14_ACLK] [get_bd_pins axi_cpu_interconnect/M15_ACLK] [get_bd_pins axi_cpu_interconnect/M16_ACLK] [get_bd_pins axi_cpu_interconnect/S00_ACLK] [get_bd_pins axi_hp0_interconnect/aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axi_sysid_0/s_axi_aclk] [get_bd_pins jtag_axi_0/aclk] [get_bd_pins rom_sys_0/clk] [get_bd_pins rx_adrv9009_tpl_core/s_axi_aclk] [get_bd_pins rx_os_adrv9009_tpl_core/s_axi_aclk] [get_bd_pins sys_ps8/maxihpm0_lpd_aclk] [get_bd_pins sys_ps8/pl_clk0] [get_bd_pins sys_ps8/saxihp0_fpd_aclk] [get_bd_pins sys_rstgen/slowest_sync_clk] [get_bd_pins tx_adrv9009_tpl_core/s_axi_aclk] [get_bd_pins util_adrv9009_xcvr/up_clk]
  connect_bd_net -net sys_cpu_reset [get_bd_pins sys_rstgen/peripheral_reset]
  connect_bd_net -net sys_cpu_resetn [get_bd_ports axi_rst_n] [get_bd_pins adrv9009_rx_device_clk_rstgen/ext_reset_in] [get_bd_pins adrv9009_rx_os_device_clk_rstgen/ext_reset_in] [get_bd_pins adrv9009_tx_device_clk_rstgen/ext_reset_in] [get_bd_pins axi_adrv9009_rx_clkgen/s_axi_aresetn] [get_bd_pins axi_adrv9009_rx_dma/s_axi_aresetn] [get_bd_pins axi_adrv9009_rx_jesd/s_axi_aresetn] [get_bd_pins axi_adrv9009_rx_os_clkgen/s_axi_aresetn] [get_bd_pins axi_adrv9009_rx_os_dma/s_axi_aresetn] [get_bd_pins axi_adrv9009_rx_os_jesd/s_axi_aresetn] [get_bd_pins axi_adrv9009_rx_os_xcvr/s_axi_aresetn] [get_bd_pins axi_adrv9009_rx_xcvr/s_axi_aresetn] [get_bd_pins axi_adrv9009_tx_clkgen/s_axi_aresetn] [get_bd_pins axi_adrv9009_tx_dma/s_axi_aresetn] [get_bd_pins axi_adrv9009_tx_jesd/s_axi_aresetn] [get_bd_pins axi_adrv9009_tx_xcvr/s_axi_aresetn] [get_bd_pins axi_cpu_interconnect/ARESETN] [get_bd_pins axi_cpu_interconnect/M00_ARESETN] [get_bd_pins axi_cpu_interconnect/M01_ARESETN] [get_bd_pins axi_cpu_interconnect/M02_ARESETN] [get_bd_pins axi_cpu_interconnect/M03_ARESETN] [get_bd_pins axi_cpu_interconnect/M04_ARESETN] [get_bd_pins axi_cpu_interconnect/M05_ARESETN] [get_bd_pins axi_cpu_interconnect/M06_ARESETN] [get_bd_pins axi_cpu_interconnect/M07_ARESETN] [get_bd_pins axi_cpu_interconnect/M08_ARESETN] [get_bd_pins axi_cpu_interconnect/M09_ARESETN] [get_bd_pins axi_cpu_interconnect/M10_ARESETN] [get_bd_pins axi_cpu_interconnect/M11_ARESETN] [get_bd_pins axi_cpu_interconnect/M12_ARESETN] [get_bd_pins axi_cpu_interconnect/M13_ARESETN] [get_bd_pins axi_cpu_interconnect/M14_ARESETN] [get_bd_pins axi_cpu_interconnect/M15_ARESETN] [get_bd_pins axi_cpu_interconnect/M16_ARESETN] [get_bd_pins axi_cpu_interconnect/S00_ARESETN] [get_bd_pins axi_hp0_interconnect/aresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axi_sysid_0/s_axi_aresetn] [get_bd_pins jtag_axi_0/aresetn] [get_bd_pins rx_adrv9009_tpl_core/s_axi_aresetn] [get_bd_pins rx_os_adrv9009_tpl_core/s_axi_aresetn] [get_bd_pins sys_rstgen/peripheral_aresetn] [get_bd_pins tx_adrv9009_tpl_core/s_axi_aresetn] [get_bd_pins util_adrv9009_xcvr/up_rstn]
  connect_bd_net -net sys_ps8_emio_gpio_o [get_bd_ports gpio_o] [get_bd_pins sys_ps8/emio_gpio_o]
  connect_bd_net -net sys_ps8_emio_gpio_t [get_bd_ports gpio_t] [get_bd_pins sys_ps8/emio_gpio_t]
  connect_bd_net -net sys_ps8_emio_spi0_m_o [get_bd_ports spi0_mosi] [get_bd_pins sys_ps8/emio_spi0_m_o]
  connect_bd_net -net sys_ps8_emio_spi0_sclk_o [get_bd_ports spi0_sclk] [get_bd_pins sys_ps8/emio_spi0_sclk_o]
  connect_bd_net -net sys_ps8_emio_spi0_ss1_o_n [get_bd_pins spi0_csn_concat/In1] [get_bd_pins sys_ps8/emio_spi0_ss1_o_n]
  connect_bd_net -net sys_ps8_emio_spi0_ss2_o_n [get_bd_pins spi0_csn_concat/In2] [get_bd_pins sys_ps8/emio_spi0_ss2_o_n]
  connect_bd_net -net sys_ps8_emio_spi0_ss_o_n [get_bd_pins spi0_csn_concat/In0] [get_bd_pins sys_ps8/emio_spi0_ss_o_n]
  connect_bd_net -net sys_ps8_emio_spi1_m_o [get_bd_ports spi1_mosi] [get_bd_pins sys_ps8/emio_spi1_m_o]
  connect_bd_net -net sys_ps8_emio_spi1_sclk_o [get_bd_ports spi1_sclk] [get_bd_pins sys_ps8/emio_spi1_sclk_o]
  connect_bd_net -net sys_ps8_emio_spi1_ss1_o_n [get_bd_pins spi1_csn_concat/In1] [get_bd_pins sys_ps8/emio_spi1_ss1_o_n]
  connect_bd_net -net sys_ps8_emio_spi1_ss2_o_n [get_bd_pins spi1_csn_concat/In2] [get_bd_pins sys_ps8/emio_spi1_ss2_o_n]
  connect_bd_net -net sys_ps8_emio_spi1_ss_o_n [get_bd_pins spi1_csn_concat/In0] [get_bd_pins sys_ps8/emio_spi1_ss_o_n]
  connect_bd_net -net sys_ps8_pl_resetn0 [get_bd_pins sys_250m_rstgen/ext_reset_in] [get_bd_pins sys_500m_rstgen/ext_reset_in] [get_bd_pins sys_ps8/pl_resetn0] [get_bd_pins sys_rstgen/ext_reset_in]
  connect_bd_net -net sysref_1 [get_bd_ports tx_sysref_0] [get_bd_pins axi_adrv9009_tx_jesd/sysref]
  connect_bd_net -net sysref_2 [get_bd_ports rx_sysref_0] [get_bd_pins axi_adrv9009_rx_jesd/sysref]
  connect_bd_net -net sysref_3 [get_bd_ports rx_sysref_2] [get_bd_pins axi_adrv9009_rx_os_jesd/sysref]
  connect_bd_net -net tx_adrv9009_tpl_core_dac_enable_0 [get_bd_pins tx_adrv9009_tpl_core/dac_enable_0] [get_bd_pins tx_fir_interpolator/dac_enable_0]
  connect_bd_net -net tx_adrv9009_tpl_core_dac_enable_1 [get_bd_pins tx_adrv9009_tpl_core/dac_enable_1] [get_bd_pins tx_fir_interpolator/dac_enable_1]
  connect_bd_net -net tx_adrv9009_tpl_core_dac_enable_2 [get_bd_pins tx_adrv9009_tpl_core/dac_enable_2] [get_bd_pins tx_fir_interpolator/dac_enable_2]
  connect_bd_net -net tx_adrv9009_tpl_core_dac_enable_3 [get_bd_pins tx_adrv9009_tpl_core/dac_enable_3] [get_bd_pins tx_fir_interpolator/dac_enable_3]
  connect_bd_net -net tx_adrv9009_tpl_core_dac_valid_0 [get_bd_pins tx_adrv9009_tpl_core/dac_valid_0] [get_bd_pins tx_fir_interpolator/dac_valid_0]
  connect_bd_net -net tx_adrv9009_tpl_core_dac_valid_1 [get_bd_pins tx_adrv9009_tpl_core/dac_valid_1] [get_bd_pins tx_fir_interpolator/dac_valid_1]
  connect_bd_net -net tx_adrv9009_tpl_core_dac_valid_2 [get_bd_pins tx_adrv9009_tpl_core/dac_valid_2] [get_bd_pins tx_fir_interpolator/dac_valid_2]
  connect_bd_net -net tx_adrv9009_tpl_core_dac_valid_3 [get_bd_pins tx_adrv9009_tpl_core/dac_valid_3] [get_bd_pins tx_fir_interpolator/dac_valid_3]
  connect_bd_net -net tx_fir_interpolator_data_out_0 [get_bd_pins tx_adrv9009_tpl_core/dac_data_0] [get_bd_pins tx_fir_interpolator/data_out_0]
  connect_bd_net -net tx_fir_interpolator_data_out_1 [get_bd_pins tx_adrv9009_tpl_core/dac_data_1] [get_bd_pins tx_fir_interpolator/data_out_1]
  connect_bd_net -net tx_fir_interpolator_data_out_2 [get_bd_pins tx_adrv9009_tpl_core/dac_data_2] [get_bd_pins tx_fir_interpolator/data_out_2]
  connect_bd_net -net tx_fir_interpolator_data_out_3 [get_bd_pins tx_adrv9009_tpl_core/dac_data_3] [get_bd_pins tx_fir_interpolator/data_out_3]
  connect_bd_net -net tx_fir_interpolator_enable_out_0 [get_bd_pins tx_fir_interpolator/enable_out_0] [get_bd_pins util_adrv9009_tx_upack/enable_0]
  connect_bd_net -net tx_fir_interpolator_enable_out_1 [get_bd_pins tx_fir_interpolator/enable_out_1] [get_bd_pins util_adrv9009_tx_upack/enable_1]
  connect_bd_net -net tx_fir_interpolator_enable_out_2 [get_bd_pins tx_fir_interpolator/enable_out_2] [get_bd_pins util_adrv9009_tx_upack/enable_2]
  connect_bd_net -net tx_fir_interpolator_enable_out_3 [get_bd_pins tx_fir_interpolator/enable_out_3] [get_bd_pins util_adrv9009_tx_upack/enable_3]
  connect_bd_net -net tx_fir_interpolator_valid_out_0 [get_bd_pins logic_or/Op1] [get_bd_pins tx_fir_interpolator/valid_out_0]
  connect_bd_net -net tx_fir_interpolator_valid_out_2 [get_bd_pins logic_or/Op2] [get_bd_pins tx_fir_interpolator/valid_out_2]
  connect_bd_net -net tx_ref_clk_0_1 [get_bd_ports tx_ref_clk_0] [get_bd_pins util_adrv9009_xcvr/qpll_ref_clk_0]
  connect_bd_net -net util_adrv9009_tx_upack_fifo_rd_data_0 [get_bd_pins tx_fir_interpolator/data_in_0] [get_bd_pins util_adrv9009_tx_upack/fifo_rd_data_0]
  connect_bd_net -net util_adrv9009_tx_upack_fifo_rd_data_1 [get_bd_pins tx_fir_interpolator/data_in_1] [get_bd_pins util_adrv9009_tx_upack/fifo_rd_data_1]
  connect_bd_net -net util_adrv9009_tx_upack_fifo_rd_data_2 [get_bd_pins tx_fir_interpolator/data_in_2] [get_bd_pins util_adrv9009_tx_upack/fifo_rd_data_2]
  connect_bd_net -net util_adrv9009_tx_upack_fifo_rd_data_3 [get_bd_pins tx_fir_interpolator/data_in_3] [get_bd_pins util_adrv9009_tx_upack/fifo_rd_data_3]
  connect_bd_net -net util_adrv9009_tx_upack_s_axis_ready [get_bd_pins axi_adrv9009_dacfifo/dac_valid] [get_bd_pins util_adrv9009_tx_upack/s_axis_ready]
  connect_bd_net -net util_adrv9009_xcvr_rx_out_clk_0 [get_bd_pins axi_adrv9009_rx_clkgen/clk] [get_bd_pins util_adrv9009_xcvr/rx_out_clk_0]
  connect_bd_net -net util_adrv9009_xcvr_rx_out_clk_2 [get_bd_pins axi_adrv9009_rx_os_clkgen/clk] [get_bd_pins util_adrv9009_xcvr/rx_out_clk_2]
  connect_bd_net -net util_adrv9009_xcvr_tx_0_n [get_bd_ports tx_data_0_n] [get_bd_pins util_adrv9009_xcvr/tx_0_n]
  connect_bd_net -net util_adrv9009_xcvr_tx_0_p [get_bd_ports tx_data_0_p] [get_bd_pins util_adrv9009_xcvr/tx_0_p]
  connect_bd_net -net util_adrv9009_xcvr_tx_1_n [get_bd_ports tx_data_1_n] [get_bd_pins util_adrv9009_xcvr/tx_1_n]
  connect_bd_net -net util_adrv9009_xcvr_tx_1_p [get_bd_ports tx_data_1_p] [get_bd_pins util_adrv9009_xcvr/tx_1_p]
  connect_bd_net -net util_adrv9009_xcvr_tx_2_n [get_bd_ports tx_data_2_n] [get_bd_pins util_adrv9009_xcvr/tx_2_n]
  connect_bd_net -net util_adrv9009_xcvr_tx_2_p [get_bd_ports tx_data_2_p] [get_bd_pins util_adrv9009_xcvr/tx_2_p]
  connect_bd_net -net util_adrv9009_xcvr_tx_3_n [get_bd_ports tx_data_3_n] [get_bd_pins util_adrv9009_xcvr/tx_3_n]
  connect_bd_net -net util_adrv9009_xcvr_tx_3_p [get_bd_ports tx_data_3_p] [get_bd_pins util_adrv9009_xcvr/tx_3_p]
  connect_bd_net -net util_adrv9009_xcvr_tx_out_clk_0 [get_bd_pins axi_adrv9009_tx_clkgen/clk] [get_bd_pins util_adrv9009_xcvr/tx_out_clk_0]

  # Create address segments
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_adrv9009_rx_dma/m_dest_axi] [get_bd_addr_segs sys_ps8/SAXIGP4/HP2_DDR_LOW] SEG_sys_ps8_HP2_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_adrv9009_rx_os_dma/m_dest_axi] [get_bd_addr_segs sys_ps8/SAXIGP3/HP1_DDR_LOW] SEG_sys_ps8_HP1_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_adrv9009_rx_os_xcvr/m_axi] [get_bd_addr_segs sys_ps8/SAXIGP2/HP0_DDR_LOW] SEG_sys_ps8_HP0_DDR_LOW
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_adrv9009_rx_os_xcvr/m_axi] [get_bd_addr_segs sys_ps8/SAXIGP2/HP0_LPS_OCM] SEG_sys_ps8_HP0_LPS_OCM
  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_adrv9009_rx_os_xcvr/m_axi] [get_bd_addr_segs sys_ps8/SAXIGP2/HP0_PCIE_LOW] SEG_sys_ps8_HP0_PCIE_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_adrv9009_rx_os_xcvr/m_axi] [get_bd_addr_segs sys_ps8/SAXIGP2/HP0_QSPI] SEG_sys_ps8_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_adrv9009_rx_xcvr/m_axi] [get_bd_addr_segs sys_ps8/SAXIGP2/HP0_DDR_LOW] SEG_sys_ps8_HP0_DDR_LOW
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_adrv9009_rx_xcvr/m_axi] [get_bd_addr_segs sys_ps8/SAXIGP2/HP0_LPS_OCM] SEG_sys_ps8_HP0_LPS_OCM
  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_adrv9009_rx_xcvr/m_axi] [get_bd_addr_segs sys_ps8/SAXIGP2/HP0_PCIE_LOW] SEG_sys_ps8_HP0_PCIE_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_adrv9009_rx_xcvr/m_axi] [get_bd_addr_segs sys_ps8/SAXIGP2/HP0_QSPI] SEG_sys_ps8_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_adrv9009_tx_dma/m_src_axi] [get_bd_addr_segs sys_ps8/SAXIGP5/HP3_DDR_LOW] SEG_sys_ps8_HP3_DDR_LOW
  create_bd_addr_seg -range 0x00010000 -offset 0x00030000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_drp/Reg] SEG_axi_drp_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_regs/Reg] SEG_axi_regs_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x00020000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_rx_bram/Reg] SEG_axi_rx_bram_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x00010000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_tx_bram/Reg] SEG_axi_tx_bram_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80300000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_drp/Reg] SEG_axi_drp_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80000000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_regs/Reg] SEG_axi_regs_Reg
  create_bd_addr_seg -range 0x00080000 -offset 0x80200000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_rx_bram/Reg] SEG_axi_rx_bram_Reg
  create_bd_addr_seg -range 0x00080000 -offset 0x80100000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_tx_bram/Reg] SEG_axi_tx_bram_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x83C10000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_adrv9009_rx_clkgen/s_axi/axi_lite] SEG_data_axi_adrv9009_rx_clkgen
  create_bd_addr_seg -range 0x00001000 -offset 0x9C400000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_adrv9009_rx_dma/s_axi/axi_lite] SEG_data_axi_adrv9009_rx_dma
  create_bd_addr_seg -range 0x00004000 -offset 0x84AA0000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_adrv9009_rx_jesd/rx_axi/s_axi/axi_lite] SEG_data_axi_adrv9009_rx_jesd
  create_bd_addr_seg -range 0x00010000 -offset 0x83C20000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_adrv9009_rx_os_clkgen/s_axi/axi_lite] SEG_data_axi_adrv9009_rx_os_clkgen
  create_bd_addr_seg -range 0x00001000 -offset 0x9C440000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_adrv9009_rx_os_dma/s_axi/axi_lite] SEG_data_axi_adrv9009_rx_os_dma
  create_bd_addr_seg -range 0x00004000 -offset 0x84AB0000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_adrv9009_rx_os_jesd/rx_axi/s_axi/axi_lite] SEG_data_axi_adrv9009_rx_os_jesd
  create_bd_addr_seg -range 0x00010000 -offset 0x84A50000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_adrv9009_rx_os_xcvr/s_axi/axi_lite] SEG_data_axi_adrv9009_rx_os_xcvr
  create_bd_addr_seg -range 0x00010000 -offset 0x84A60000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_adrv9009_rx_xcvr/s_axi/axi_lite] SEG_data_axi_adrv9009_rx_xcvr
  create_bd_addr_seg -range 0x00010000 -offset 0x83C00000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_adrv9009_tx_clkgen/s_axi/axi_lite] SEG_data_axi_adrv9009_tx_clkgen
  create_bd_addr_seg -range 0x00001000 -offset 0x9C420000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_adrv9009_tx_dma/s_axi/axi_lite] SEG_data_axi_adrv9009_tx_dma
  create_bd_addr_seg -range 0x00004000 -offset 0x84A90000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_adrv9009_tx_jesd/tx_axi/s_axi/axi_lite] SEG_data_axi_adrv9009_tx_jesd
  create_bd_addr_seg -range 0x00010000 -offset 0x84A80000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_adrv9009_tx_xcvr/s_axi/axi_lite] SEG_data_axi_adrv9009_tx_xcvr
  create_bd_addr_seg -range 0x00010000 -offset 0x85000000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs axi_sysid_0/s_axi/axi_lite] SEG_data_axi_sysid_0
  create_bd_addr_seg -range 0x00001000 -offset 0x84A00000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs rx_adrv9009_tpl_core/tpl_core/s_axi/axi_lite] SEG_data_rx_adrv9009_tpl_core
  create_bd_addr_seg -range 0x00001000 -offset 0x84A08000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs rx_os_adrv9009_tpl_core/tpl_core/s_axi/axi_lite] SEG_data_rx_os_adrv9009_tpl_core
  create_bd_addr_seg -range 0x00001000 -offset 0x84A04000 [get_bd_addr_spaces sys_ps8/Data] [get_bd_addr_segs tx_adrv9009_tpl_core/tpl_core/s_axi/axi_lite] SEG_data_tx_adrv9009_tpl_core


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


