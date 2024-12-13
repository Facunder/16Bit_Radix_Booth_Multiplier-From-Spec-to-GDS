# environment variables are setted in .synopsys_dc.setup
set LOG_DATE [clock format [clock seconds] -format "%Y%m%d_%H%M%S"]
set_host_options -max_cores 16
set DESIGN_NAME ArcherChipTop

# Setup the library
set NVLM_PATH /lamport/shared/hzzhu/techlib/tn22ull/stdcell/TSMCHOME/digital/Front_End/timing_power_noise/NLDM
set NEW_PATH /lamport/shared/hyzhang/Tianyuan/custom_lib/db
set NEW_PATH_TEST /capsule/home/bcb/workspace/zhy/liberate/LIBRARY
set PAD_PATH /lamport/shared/hzzhu/techlib/tn22ull/stdcell/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tphn22ullgv18e_110c
set SRAM_PATH /capsule/home/skyhe/WorkSpace/Puti/memory
set BLOCK_DB /lamport/shared/hyzhang/Tianyuan/apr_files/20240321_1441/CimBlock.db

#set_units -current mA
set target_library "$NVLM_PATH/tcbn22ullbwp30p140hvt_110b/tcbn22ullbwp30p140hvttt0p8v25c.db $PAD_PATH/tphn22ullgv18ett0p8v1p8v25c.db $SRAM_PATH/sram_sp_uhde_512x128_tt_typical_0p80v_0p80v_25c.db $NEW_PATH_TEST/RA5T.db $NEW_PATH/S8T1.db $NEW_PATH/WD7T.db $BLOCK_DB"
set symbol_library "$NVLM_PATH/tcbn22ullbwp30p140hvt_110b/tcbn22ullbwp30p140hvttt0p8v25c.db $PAD_PATH/tphn22ullgv18ett0p8v1p8v25c.db $SRAM_PATH/sram_sp_uhde_512x128_tt_typical_0p80v_0p80v_25c.db $NEW_PATH_TEST/RA5T.db $NEW_PATH/S8T1.db $NEW_PATH/WD7T.db $BLOCK_DB"
set link_library "* $NVLM_PATH/tcbn22ullbwp30p140hvt_110b/tcbn22ullbwp30p140hvttt0p8v25c.db $PAD_PATH/tphn22ullgv18ett0p8v1p8v25c.db $SRAM_PATH/sram_sp_uhde_512x128_tt_typical_0p80v_0p80v_25c.db $NEW_PATH_TEST/RA5T.db $NEW_PATH/S8T1.db $NEW_PATH/WD7T.db $BLOCK_DB"

set GENERATE_PATH /capsule/home/skyhe/WorkSpace/Puti/generate_scp/hw
set RTL_PATH /capsule/home/skyhe/WorkSpace/archer-cim/hw
set NIC_PATH /capsule/home/skyhe/WorkSpace/Puti/nic400_1
set search_path "$search_path"

file mkdir ./work
define_design_lib WORK -path ./work
set_svf $DESIGN_NAME.svf

set_app_var verilogout_show_unconnected_pins true

###############################################  input RTL files  ##############################################

#####################   PAD   #####################
analyze -format sverilog -define { FLOW_ASIC ASIC_CLOCK_GATING } $RTL_PATH/vsrc/ArcherChipTop.sv
analyze -format sverilog -define { FLOW_ASIC ASIC_CLOCK_GATING } $RTL_PATH/vsrc/InputCell.sv
analyze -format sverilog -define { FLOW_ASIC ASIC_CLOCK_GATING } $RTL_PATH/vsrc/OutputCell.sv

#####################   D2D   #####################
analyze -format verilog -define { FLOW_ASIC ASIC_CLOCK_GATING } $RTL_PATH/vsrc/3rdparty/d2d/d2dSlave.v
analyze -format sverilog -define { FLOW_ASIC ASIC_CLOCK_GATING } $RTL_PATH/archer/resources/JayLinkSlaveBbox.sv

#####################   Generate Files   #####################
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/AcornDpToAxiLiteBridge.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/AcornDpToSpBridge_1.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/AcornDpToSpBridge.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/Arbiter2_AcornSpCommandChannel_1.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/Arbiter2_AcornSpCommandChannel.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/ArcherChip.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/ArcherNpu.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/Axi4ToAcornDpBridge.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/AxiLiteToAxi4Bridge.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/AxiNic.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/Buffer_1.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/Buffer.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/BufferGate_1.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/BufferGate.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/CimCore.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/CimCoreArray.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/CimGate.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/CimWRMng.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/extern_modules.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/NpuAcornDemux.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/NpuBackend.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/NpuConfigRegBank.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/NpuFrontend.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/Queue16_Bool.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/ram_16x1.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/RegBank_1.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/RegBank.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/RegField_1.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/RegField_5.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/RegField_6.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/RegField_8.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/RegField_9.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/RegField_10.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/RegField_13.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/RegField_14.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/RegField_15.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/RegField_29.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/RegField_30.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/RegField.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/ResetSync.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/SpiDebugger.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/SramWrapperSp128bx512d.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/StreamDemux_1.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/StreamDemux_2.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/StreamDemux.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/StreamMux_1.sv
analyze -format sverilog -define { FLOW_ASIC } $GENERATE_PATH/StreamMux.sv

#####################   NIC   #####################
# read_file -autoread -recursive -top nic400_1 "$NIC_PATH"

analyze -format verilog -vcs "/capsule/home/skyhe/WorkSpace/Puti/nic400_1/nic400/verilog/nic400_1.v \
                              -y $NIC_PATH/nic400/verilog/Axi  \
                              -y $NIC_PATH/nic400/verilog/Axi4PC  \
                              -y $NIC_PATH/amib_m_d2ds_ctrl/verilog  \
                              -y $NIC_PATH/reg_slice/verilog  \
                              -y $NIC_PATH/amib_m_npu/verilog  \
                              -y $NIC_PATH/asib_s_d2ds_data/verilog  \
                              -y $NIC_PATH/asib_s_spi/verilog  \
                              -y $NIC_PATH/default_slave_ds_1/verilog  \
                              -y $NIC_PATH/ib_s_spi_ib/verilog  \
                              +incdir+$NIC_PATH/amib_m_d2ds_ctrl/verilog \
                              +incdir+$NIC_PATH/amib_m_npu/verilog \
                              +incdir+$NIC_PATH/asib_s_d2ds_data/verilog \
                              +incdir+$NIC_PATH/asib_s_spi/verilog \
                              +incdir+$NIC_PATH/busmatrix_bm0/verilog \
                              +incdir+$NIC_PATH/cdc_blocks/verilog \
                              +incdir+$NIC_PATH/default_slave_ds_1/verilog \
                              +incdir+$NIC_PATH/ib_s_spi_ib/verilog \
                              +incdir+$NIC_PATH/reg_slice/verilog \
                              +incdir+$NIC_PATH/nic400/verilog/Axi \
                              +incdir+$NIC_PATH/nic400/verilog/Axi4PC" 

elaborate $DESIGN_NAME
current_design ${DESIGN_NAME}
link 

##############################################  clock attribution  ##############################################
create_clock -name clock -period 3.3 [get_ports uInputCell_clock/core_i]
create_clock -name Rx_clock -period 3.3 [get_pins uInputCell_d2d_rx_clock/core_i]
set_dont_touch [get_cells -hier -filter "full_name =~ uInputCell*"]
set_dont_touch [get_cells -hier -filter "full_name =~ uOutputCell*"]

set_clock_groups -asynchronous -name func_async -group {clock} -group {Rx_clock}

set_false_path -from [get_ports pad_reset]

set_false_path -fall_from [get_clocks *]
set_clock_uncertainty -setup 0.25 [all_clocks]
set_clock_uncertainty -hold 0.1 [all_clocks]
set_clock_transition 0.1 [all_clocks]
set_clock_latency 0.2 [all_clocks]
# set_propagated_clock [all_clocks]
set_timing_derate -early 0.9
set_timing_derate -late 1.1

# set_input_delay -max 0.2 -clock clock [remove_from_collection [all_inputs] [get_ports "i_clock i_reset"]]
# set_output_delay -max 0.2 -clock clock [all_outputs]
set_load 0.2 [get_ports [all_outputs]]

# set false paths
# set_dont_touch_network [get_ports reset]

# driving and loading
set driving_cell "BUFFD8BWP30P140HVT"
set_driving_cell -lib_cell $driving_cell [remove_from_collection [all_inputs] [get_ports {pad_clock pad_reset pad_spi_ssn pad_spi_sck pad_spi_mosi pad_d2d_rx_clock pad_d2d_rx_flit_valid pad_d2d_rx_flit_* pad_d2d_rx_creditFree pad_d2d_rx_replayPkgID}]]

#design rule constraints
set_clock_gating_style -control_point before -control_signal scan_enable -positive_edge_logic {integrated:CKLNQD12BWP30P140HVT} -max_fanout 32 -minimum_bitwidth 4
set_max_transition 0.4 [current_design]
# set_max_capacitance 0.9 [current_design]
set_max_fanout 40 [current_design]
set_max_area 0

set_fix_hold [all_clocks]
set_fix_multiple_port_nets -buffer_constants -all

compile_ultra -no_autoungroup -gate_clock

######################### async fifo ################################
# asynchronous fifo constrain from Rxclock to Phyclock
set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQPackageIDUsed/fifo/wrAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQPackageIDUsed/fifo/wrPtrSync_r_reg[*]/D]
set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQPackageIDUsed/fifo/rdAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQPackageIDUsed/fifo/rdPtrSync_r_reg[*]/D]

set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQPackageIDOut/fifo/wrAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQPackageIDOut/fifo/wrPtrSync_r_reg[*]/D]
set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQPackageIDOut/fifo/rdAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQPackageIDOut/fifo/rdPtrSync_r_reg[*]/D]

set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQCreditRBFree/fifo/wrAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQCreditRBFree/fifo/wrPtrSync_r_reg[*]/D]
set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQCreditRBFree/fifo/rdAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQCreditRBFree/fifo/rdPtrSync_r_reg[*]/D]

set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQCreditARWFree/fifo/wrAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQCreditARWFree/fifo/wrPtrSync_r_reg[*]/D]
set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQCreditARWFree/fifo/rdAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/asyncQCreditARWFree/fifo/rdPtrSync_r_reg[*]/D]

# asynchronous fifo constrain from Txclock to Phyclock
set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/Tx/asyncQR/fifo/wrAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/Tx/asyncQR/fifo/wrPtrSync_r_reg[*]/D]
set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/Tx/asyncQR/fifo/rdAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/Tx/asyncQR/fifo/rdPtrSync_r_reg[*]/D]

set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/Tx/asyncQB/fifo/wrAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/Tx/asyncQB/fifo/wrPtrSync_r_reg[*]/D]
set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/Tx/asyncQB/fifo/rdAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/Tx/asyncQB/fifo/rdPtrSync_r_reg[*]/D]

# asynchronous fifo constrain from Rxclock to Txclock
set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/Rx/asyncQAW/fifo/wrAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/Rx/asyncQAW/fifo/wrPtrSync_r_reg[*]/D]
set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/Rx/asyncQAW/fifo/rdAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/Rx/asyncQAW/fifo/rdPtrSync_r_reg[*]/D]

set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/Rx/asyncQAR/fifo/wrAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/Rx/asyncQAR/fifo/wrPtrSync_r_reg[*]/D]
set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/Rx/asyncQAR/fifo/rdAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/Rx/asyncQAR/fifo/rdPtrSync_r_reg[*]/D]

set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/Rx/asyncQW/fifo/wrAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/Rx/asyncQW/fifo/wrPtrSync_r_reg[*]/D]
set_max_delay 2 -from [get_pins uChip/uJayLinkSlave/uD2dSlave/Rx/asyncQW/fifo/rdAddrGray_reg[*]/CP]  -to [get_pins uChip/uJayLinkSlave/uD2dSlave/Rx/asyncQW/fifo/rdPtrSync_r_reg[*]/D]

compile_ultra -no_autoungroup -gate_clock

##############################################  output files  ##############################################
set REPORTS reports_${DESIGN_NAME}/$LOG_DATE
set SYN_FILES syn_files_${DESIGN_NAME}/$LOG_DATE 
file delete -force $SYN_FILES
file delete -force $REPORTS
file mkdir $SYN_FILES
file mkdir $REPORTS

report_port -verbose > $REPORTS/${DESIGN_NAME}_port_verbose.rpt
report_clock  > $REPORTS/${DESIGN_NAME}_clock.rpt
check_design > $REPORTS/${DESIGN_NAME}_check.rpt
report_power -hierarchy > $REPORTS/$DESIGN_NAME.hierarchy.power
report_power > $REPORTS/$DESIGN_NAME.power
report_area  -hierarchy > $REPORTS/$DESIGN_NAME.area
report_timing > $REPORTS/$DESIGN_NAME.max.timing
report_timing -delay_type min > $REPORTS/$DESIGN_NAME.min.timing
report_constraint -verbose > $REPORTS/$DESIGN_NAME.constraint
report_constraint -all_violators > $REPORTS/$DESIGN_NAME.violation
report_clock_gating -verbose > $REPORTS/$DESIGN_NAME.icg
report_clock_gating -gating_elements > $REPORTS/$DESIGN_NAME.elements.icg

# Ouptut the results
write -h $DESIGN_NAME -output ./$SYN_FILES/$DESIGN_NAME.db
write_file -format ddc -hierarchy -output ./$SYN_FILES/$DESIGN_NAME.ddc
# Delays in SDF format for Verilog simulation
write_sdf -context verilog -version 1.0 ./$SYN_FILES/$DESIGN_NAME.syn.sdf
# The post-syn Verilog netlist
write -h -f verilog $DESIGN_NAME -output ./$SYN_FILES/$DESIGN_NAME.syn.v -pg
# Constraints in SDC format, for APR
write_sdc ./$SYN_FILES/$DESIGN_NAME.sdc

set_svf -off