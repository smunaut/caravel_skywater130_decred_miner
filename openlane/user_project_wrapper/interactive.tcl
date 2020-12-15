package require openlane
set script_dir [file dirname [file normalize [info script]]]

prep -design $script_dir -tag user_project_wrapper -overwrite
set save_path $script_dir/../..

verilog_elaborate
#run_synthesis

init_floorplan
place_io_ol
#run_floorplan

set ::env(FP_DEF_TEMPATE) $script_dir/../../def/user_project_wrapper_empty.def

apply_def_template

#add_macro_placement mprj 1150 1700 N
#add_macro_placement mprj 0 0 N
add_macro_placement decred_hash_block0 133.28 368.0 S
add_macro_placement decred_hash_block1 1593.92 368.0 S
add_macro_placement decred_hash_block2 133.28 1919.58 S
add_macro_placement decred_hash_block3 1593.92 1919.58 S
add_macro_placement decred_controller_block 1360.0 1577.8 S

manual_macro_placement f

#run_placement

exec -ignorestderr openroad -exit $script_dir/gen_pdn.tcl
set_def $::env(pdn_tmp_file_tag).def

global_routing_or
detailed_routing

run_magic
run_magic_spice_export

save_views       -lef_path $::env(magic_result_file_tag).lef \
                 -def_path $::env(tritonRoute_result_file_tag).def \
                 -gds_path $::env(magic_result_file_tag).gds \
                 -mag_path $::env(magic_result_file_tag).mag \
                 -save_path $save_path \
                 -tag $::env(RUN_TAG)

run_magic_drc

run_lvs; # requires run_magic_spice_export

run_antenna_check
