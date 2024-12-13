set LOG_DATE [clock format [clock seconds] -format "%Y%m%d_%H%M%S"]
set_host_options -max_cores 16
set DESIGN_NAME top

# Setup the library
set NVLM_PATH /capsule/pdk/tsmcN28/TSMCHOME/digital/Front_End/timing_power_noise/NLDM

set RTL_PATH ../src_new
set search_path "$search_path NVLM_PATH PAL_PATH RTL_PATH"

#set_units -current mA
set target_library "$NVLM_PATH/tcbn28hpcplusbwp30p140uhvt_180b/tcbn28hpcplusbwp30p140uhvtssg0p9v0c.db"
set symbol_library "$NVLM_PATH/tcbn28hpcplusbwp30p140uhvt_180b/tcbn28hpcplusbwp30p140uhvtssg0p9v0c.db"
set link_library "* $NVLM_PATH/tcbn28hpcplusbwp30p140uhvt_180b/tcbn28hpcplusbwp30p140uhvtssg0p9v0c.db"

# Read in the verilog RTL
# analyze -format verilog $RTL_PATH/ml_top.v

analyze -format verilog $RTL_PATH/Add/Add_quant.v
analyze -format verilog $RTL_PATH/Add/Buffer.v
analyze -format verilog $RTL_PATH/Add/Add_2048.v
analyze -format verilog $RTL_PATH/Buf/inst_buf.v
analyze -format verilog $RTL_PATH/Buf/inter_buffer.v
analyze -format verilog $RTL_PATH/Out/out_buf.v
analyze -format verilog $RTL_PATH/Ctrl/PC.v
analyze -format verilog $RTL_PATH/Ctrl/Cpu_ctrl.v
analyze -format verilog $RTL_PATH/CiM/CimBank_Acc.v
analyze -format verilog $RTL_PATH/CiM/ClockGate.v
analyze -format verilog $RTL_PATH/CiM/CimRow8X.v
analyze -format verilog $RTL_PATH/CiM/CimAdderTree.v
analyze -format verilog $RTL_PATH/CiM/CimBlock.v
analyze -format verilog $RTL_PATH/CiM/CimBankQ.v
analyze -format verilog $RTL_PATH/CiM/CimDecoder.v
analyze -format verilog $RTL_PATH/CiM/Quant.v
analyze -format verilog $RTL_PATH/CiM/Buffer.v
# analyze -format verilog $RTL_PATH/CiM/CimBank.v
#! 用CimBank_empty替换CimBank
analyze -format verilog $RTL_PATH/CiM/CimBank.v
analyze -format verilog $RTL_PATH/CiM/CimDecoderBuffer.v
analyze -format verilog $RTL_PATH/CiM/RA6T.v
analyze -format verilog $RTL_PATH/CiM/CimBankQ2_test.v
analyze -format verilog $RTL_PATH/CiM/CimRow.v
analyze -format verilog $RTL_PATH/CiM/WD7T.v
analyze -format verilog $RTL_PATH/CiM/CimMacro.v
analyze -format verilog $RTL_PATH/CiM/RA6T16X.v
analyze -format verilog $RTL_PATH/CiM/S8T1.v
analyze -format verilog $RTL_PATH/TOP/top.v

elaborate $DESIGN_NAME
current_design $DESIGN_NAME
link

# setting constains
create_clock -name "clk" -period 2.3 [get_ports clk]

set_clock_uncertainty -setup 0.25 [all_clocks]
set_clock_transition 0.1 [all_clocks]
set_clock_latency 0.2 [all_clocks]
# set_propagated_clock [all_clocks]
set_timing_derate -early 0.9
set_timing_derate -late 1.1

set_max_fanout 32 [current_design]
set_max_area 0

set_fix_hold [all_clocks]
set_fix_multiple_port_nets -buffer_constants -all

set_dont_use {tcbn28hpcplusbwp30p140uhvtssg0p9v0c/ND2OPTPAD*BWP30P140UHVT}

# Do synthesis
compile_ultra -no_autoungroup

# Output the report
set REPORTS reports_$DESIGN_NAME
set SYN_FILES syn_files_$DESIGN_NAME
file delete -force $SYN_FILES
file delete -force $REPORTS
file mkdir $SYN_FILES
file mkdir $REPORTS

report_power -hierarchy > $REPORTS/$DESIGN_NAME.hierarchy.power
report_power > $REPORTS/$DESIGN_NAME.power
report_area  -hierarchy > $REPORTS/$DESIGN_NAME.area
report_timing > $REPORTS/$DESIGN_NAME.max.timing
report_timing -delay_type min > $REPORTS/$DESIGN_NAME.min.timing
report_constraint -verbose > $REPORTS/$DESIGN_NAME.constraint
report_constraint -all_violators > $REPORTS/$DESIGN_NAME.violation

# report_timing -from invCkr0 -to ecsum_cimMacro/popcount/positive_W0_A0_reg_reg[42]/D

# Ouptut the results
write -h $DESIGN_NAME -output ./$SYN_FILES/$DESIGN_NAME.db
write_file -format ddc -hierarchy -output ./$SYN_FILES/$DESIGN_NAME.ddc
# Delays in SDF format for Verilog simulation
write_sdf -context verilog -version 1.0 ./$SYN_FILES/$DESIGN_NAME.syn.sdf
# The post-syn Verilog netlist
write -h -f verilog $DESIGN_NAME -output ./$SYN_FILES/$DESIGN_NAME.syn.v -pg
# Constraints in SDC format, for APR
write_sdc ./$SYN_FILES/$DESIGN_NAME.sdc
