# Design
set ::env(DESIGN_NAME) "decred_top"

set script_dir [file dirname [file normalize [info script]]]

set ::env(VERILOG_FILES) "\
   $script_dir/../../verilog/rtl/defines.v \
   $script_dir/../../verilog/rtl/decred_top/rtl/src/decred_defines.v \
   $script_dir/../../verilog/rtl/decred_top/rtl/src/decred_top.v"

set ::env(VERILOG_FILES_BLACKBOX) "\
	$script_dir/../../verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/decred_top/rtl/src/decred_defines.v \
        $script_dir/../../verilog/rtl/decred_top/rtl/src/addressalyzer.v \
        $script_dir/../../verilog/rtl/decred_top/rtl/src/clock_div.v \
        $script_dir/../../verilog/rtl/decred_top/rtl/src/controller.v \
        $script_dir/../../verilog/rtl/decred_top/rtl/src/decred_controller.v \
        $script_dir/../../verilog/rtl/decred_top/rtl/src/register_bank.v \
        $script_dir/../../verilog/rtl/decred_top/rtl/src/spi_passthrough.v \
        $script_dir/../../verilog/rtl/decred_top/rtl/src/spi_des.v \
	$script_dir/../../verilog/rtl/decred_top/rtl/src/decred_hash_macro.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../decred_hash_macro/runs/decred_hash_macro/results/magic/decred_hash_macro.lef \
	$script_dir/../decred_controller/runs/decred_controller/results/magic/decred_controller.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../decred_hash_macro/runs/decred_hash_macro/results/magic/decred_hash_macro.gds \
	$script_dir/../decred_controller/runs/decred_controller/results/magic/decred_controller.gds"

#set ::env(BASE_SDC_FILE) "$script_dir/decred_top.sdc"
set ::env(MACRO_PLACEMENT_CFG) "$script_dir/macro_placement.cfg"

#set ::env(CLOCK_PORT) "M1_CLK_IN PLL_INPUT S1_CLK_IN"
#set ::env(CLOCK_NET) "m1_clk_local"

set ::env(CLOCK_PORT) "0"
set ::env(CLOCK_TREE_SYNTH) 0

set ::env(DESIGN_IS_CORE) 0

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 2800 3400"

set ::env(CLOCK_PERIOD) "15.000"
#default is 50
#set ::env(FP_CORE_UTIL) "50"
set ::env(PL_TARGET_DENSITY) 0.15
set ::env(SYNTH_STRATEGY) "3"
set ::env(CELL_PAD) "4"
#default is 0.15
set ::env(GLB_RT_ADJUSTMENT) "0.15"
#default is 3
set ::env(DIODE_INSERTION_STRATEGY) "3"
set ::env(GLB_RT_MAX_DIODE_INS_ITERS) 10
# default is 5
set ::env(SYNTH_MAX_FANOUT) "5"
#default is 1
set ::env(FP_ASPECT_RATIO) "1"
#default is 0
set ::env(FP_PDN_CORE_RING) 0
#default is 6
set ::env(GLB_RT_MAXLAYER) 5
#default is 0
set ::env(PL_BASIC_PLACEMENT) 0

#default is 4
set ::env(ROUTING_CORES) 4
