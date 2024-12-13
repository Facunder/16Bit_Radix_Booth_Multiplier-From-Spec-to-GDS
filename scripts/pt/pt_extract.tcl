set_host_options -max_cores 16
set DESIGN_NAME CimBlock
set DESIGN_DIR 20240107_094027
# Setup the library
set NVLM_PATH /capsule/pdk/tsmcN28/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/
set RAL_PATH  /capsule/home/hyzhang/CIM_analog_backend/lib/db
set RTL_PATH  ../
set_app_var search_path "$search_path NVLM_PATH PAL_PATH RTL_PATH"
set_app_var link_library "* $NVLM_PATH/tcbn28hpcplusbwp30p140hvt_180a/tcbn28hpcplusbwp30p140hvtssg0p9v0c.db $RAL_PATH/RA6T.db $RAL_PATH/S8T1.db $RAL_PATH/WD7T.db $RAL_PATH/TG_1.db"

read_verilog ../syn/syn_files_${DESIGN_NAME}/${DESIGN_DIR}/${DESIGN_NAME}.syn.v
#read_verilog /capsule/home/hyzhang/Beichen/icc2/apr_files_4_4/FPCIM_Core_v0.aprbhv.v
link_design ${DESIGN_NAME}
read_sdc ../syn/syn_files_${DESIGN_NAME}/${DESIGN_DIR}/${DESIGN_NAME}.sdc

#read_parasitics /capsule/home/hyzhang/Beichen/icc2/apr_files_4_4/FPCIM_Core_v0.tt0p9v25c_25.spef

# extract_model -output cimblock

# report_constraint
set_app_var extract_model_capacitance_limit 5.0
# extract_model -output CimBlock
extract_model -output ${DESIGN_NAME}_${DESIGN_DIR} -format lib