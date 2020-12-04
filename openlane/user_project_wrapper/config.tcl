set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_project_wrapper
set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
set ::env(PDN_CFG) $script_dir/pdn.tcl

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/decred_top/rtl/src/decred_defines.v \
	$script_dir/../../verilog/rtl/decred_top/rtl/src/addressalyzer.v \
	$script_dir/../../verilog/rtl/decred_top/rtl/src/clock_div.v \
	$script_dir/../../verilog/rtl/decred_top/rtl/src/decred.v \
	$script_dir/../../verilog/rtl/decred_top/rtl/src/decred_top.v \
	$script_dir/../../verilog/rtl/decred_top/rtl/src/hash_macro_nonblock.v \
	$script_dir/../../verilog/rtl/decred_top/rtl/src/register_bank.v \
	$script_dir/../../verilog/rtl/decred_top/rtl/src/spi_passthrough.v \
	$script_dir/../../verilog/rtl/decred_top/rtl/src/spi_slave_des.v \
	$script_dir/../../verilog/rtl/user_project_wrapper.v"

set ::env(VERILOG_INCLUDE_DIRS) "$script_dir/../../verilog/rtl/decred_top/rtl/src/"

set ::env(FP_PDN_CORE_RING) 1
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 2920 3520"

set ::env(CLOCK_PORT) "user_clock2"
set ::env(CLOCK_NET) "mprj.m1_clk_internal"

set ::unit 2.4
set ::env(FP_IO_VEXTEND) [expr 2*$::unit]
set ::env(FP_IO_HEXTEND) [expr 2*$::unit]
set ::env(FP_IO_VLENGTH) $::unit
set ::env(FP_IO_HLENGTH) $::unit

set ::env(FP_IO_VTHICKNESS_MULT) 4
set ::env(FP_IO_HTHICKNESS_MULT) 4

set ::env(PL_OPENPHYSYN_OPTIMIZATIONS) 0
#set ::env(DIODE_INSERTION_STRATEGY) 0

# Need to fix a FastRoute bug for this to work, but it's good
# for a sense of "isolation"
#set ::env(MAGIC_ZEROIZE_ORIGIN) 0
#set ::env(MAGIC_WRITE_FULL_LEF) 1

####Configuration for 8 hash macros.####
set ::env(CLOCK_PERIOD) "20"

#default is 50
set ::env(FP_CORE_UTIL) "50"

set ::env(PL_TARGET_DENSITY) 0.50
set ::env(SYNTH_STRATEGY) "1"
set ::env(CELL_PAD) "4"

#default is 0.15
set ::env(GLB_RT_ADJUSTMENT) "0.15"

#default is 3
set ::env(DIODE_INSERTION_STRATEGY) "3"

# default is 5
set ::env(SYNTH_MAX_FANOUT) "5"

#default is 1
set ::env(FP_ASPECT_RATIO) "1"

#default is 0
set ::env(FP_PDN_CORE_RING) 0

#default is 6
set ::env(GLB_RT_MAXLAYER) 6
#default is 0

set ::env(PL_BASIC_PLACEMENT) 0
