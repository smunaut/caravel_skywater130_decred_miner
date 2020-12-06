# Design
set ::env(DESIGN_NAME) "decred_top"

set ::env(VERILOG_FILES) [glob $::env(OPENLANE_ROOT)/designs/skywater130_decred_miner/verilog/rtl/decred_top/rtl/src/*.v]

set ::env(BASE_SDC_FILE) [glob $::env(OPENLANE_ROOT)/designs/skywater130_decred_miner/openlane/decred_top/decred_top.sdc]

set ::env(CLOCK_PORT) "M1_CLK_IN PLL_INPUT S1_CLK_IN"
set ::env(CLOCK_NET) "clock_divBlock.even_0.clk decred_macro.SPI_CLK"
#set ::env(CLOCK_TREE_SYNTH) 0

set ::env(DESIGN_IS_CORE) 0

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 2920 3520"

# 8 macro
set ::env(CLOCK_PERIOD) "15.000"
#default is 50
set ::env(FP_CORE_UTIL) "55"
set ::env(PL_TARGET_DENSITY) 0.58
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
