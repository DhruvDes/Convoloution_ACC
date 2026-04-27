# ================================================================
#  run.tcl  —  full automated flow
#  Usage: vivado -mode batch -source run.tcl
# ================================================================

set origin_dir  [file dirname [file normalize [info script]]]
set proj_name   "convAccTop"
set part        "xc7z020clg400-1"
set board       "tul.com.tw:pynq-z2:part0:1.0"
set ip_repo_dir "${origin_dir}/ip_repo"

set local_board_path [file normalize "${origin_dir}/boards"]
if {[file exists $local_board_path]} {
    set_param board.repoPaths $local_board_path
    puts "INFO: Set board repository to $local_board_path"
} else {
    puts "WARNING: Local 'boards' folder not found. Script might fail if board is not installed."
}

# ── 1. Create a temporary simulation-only project ───────────────
create_project sim_only ./sim_only -part $part -force
set_property simulator_language Mixed [current_project]

add_files -norecurse [glob ${origin_dir}/RTL/*.sv \
                           ${origin_dir}/RTL/*.v]
set_property file_type SystemVerilog \
    [get_files -filter {FILE_TYPE != "Verilog"}]

add_files -fileset sim_1 -norecurse ${origin_dir}/TB/top.sv


set_property top top            [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
update_compile_order -fileset sim_1


# ── 1b. Simulator settings ─────────────────────────────────────
# Vivado auto-adds -L uvm and --relax when UVM is detected.
# Don't duplicate them. Only set what you actually need.

set_property -name {xsim.simulate.xsim.more_options} \
    -value {-testplusarg UVM_TESTNAME=test -testplusarg UVM_VERBOSITY=UVM_LOW} \
    -objects [get_filesets sim_1]

set_property -name {xsim.simulate.runtime} -value {-all} \
    -objects [get_filesets sim_1]

set_property -name {xsim.elaborate.xelab.more_options} \
    -value {-L xilinx_vip -L xpm} \
    -objects [get_filesets sim_1]


set_property -name {xsim.simulate.xsim.more_options} \
    -value {-testplusarg UVM_TESTNAME=test -testplusarg UVM_VERBOSITY=UVM_MEDIUM} \
    -objects [get_filesets sim_1]
# ── 2. Run UVM simulation ───────────────────────────────────────
puts "INFO: ====== Running UVM Simulation ======"
launch_simulation
# run all
close_sim

# ── 3. Parse UVM results ────────────────────────────────────────
set sim_log "${origin_dir}/sim_only/sim_only.sim/sim_1/behav/xsim/simulate.log"
set fh      [open $sim_log r]
set log     [read $fh]
close $fh

set fatal_count 0
set error_count 0

regexp {UVM_FATAL\s+:\s+(\d+)} $log -> fatal_count
regexp {UVM_ERROR\s+:\s+(\d+)} $log -> error_count

if {$fatal_count > 0 || $error_count > 0} {
    puts "ERROR: ====== Simulation FAILED ======"
    puts "ERROR: UVM_FATAL=$fatal_count  UVM_ERROR=$error_count"
    close_project
    file delete -force ./sim_only
    exit 1
}

puts "INFO: ====== Simulation PASSED ======"
puts "INFO: UVM_FATAL=$fatal_count  UVM_ERROR=$error_count"
close_project
file delete -force ./sim_only

# ── 2. IP Packaging Phase ──────────────────────────────────────
# CRITICAL: These must match recreate_bd.tcl exactly
set ip_name    "convAcc2d"
set ip_vendor  "xilinx.com"
set ip_library "user"
set ip_version "3.0"

puts "INFO: ====== Packaging IP: $ip_name ======"
create_project ip_pack ./ip_pack -part $part -force
add_files -norecurse [glob ${origin_dir}/RTL/*.sv ${origin_dir}/RTL/*.v]
update_compile_order -fileset sources_1

file delete -force $ip_repo_dir
ipx::package_project -root_dir $ip_repo_dir -vendor $ip_vendor -library $ip_library -taxonomy /User_IP
set_property name $ip_name [ipx::current_core]
set_property version $ip_version [ipx::current_core]
set_property display_name "Convolutional Accelerator v3.0" [ipx::current_core]

ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
close_project

# ── 3. Project Creation & BD Sourcing ──────────────────────────
puts "INFO: ====== Building Project and Block Design ======"

# 1. Create project
create_project $proj_name ./${proj_name} -part $part -force

# 2. Link the IP Repo
set_property ip_repo_paths $ip_repo_dir [current_project]
update_ip_catalog -rebuild

# 3. Source BD script — it handles create_bd_design internally
#    DO NOT call create_bd_design or create_root_design here
source ${origin_dir}/recreate_bd.tcl

# 4. Finalize
set bd_file [get_files convacc.bd]
validate_bd_design
save_bd_design

validate_bd_design
save_bd_design


# ── 4. Wrapper & Implementation ───────────────────────────────
puts "INFO: ====== Generating Bitstream Flow ======"

# Generate HDL Wrapper
set bd_file [get_files convacc.bd]
set wrapper_path [make_wrapper -files $bd_file -top]
add_files -norecurse $wrapper_path
set_property top convacc_wrapper [get_filesets sources_1]

# Run Synthesis
launch_runs synth_1 -jobs 8
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] != "100%"} { exit 1 }

# Run Implementation & Bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1

if {[get_property PROGRESS [get_runs impl_1]] == "100%"} {
    puts "INFO: ====== SUCCESS: Bitstream Generated ======"

    # ── Find .bit and .hwh ─────────────────────────────────────

    set overlay_dir "${origin_dir}/OverlayFiles"
    file mkdir $overlay_dir

    set bit_file "./${proj_name}/${proj_name}.runs/impl_1/convacc_wrapper.bit"
    set hwh_file "./${proj_name}/${proj_name}.gen/sources_1/bd/convacc/hw_handoff/convacc.hwh"

    file copy -force $bit_file "${overlay_dir}/convAcc.bit"
    file copy -force $hwh_file "${overlay_dir}/convAcc.hwh"
    puts "INFO: Copied convAcc.bit and convAcc.hwh to ${overlay_dir}"


    puts "INFO: ====== DONE — overlay files at OverlayFiles/convAcc.bit/.hwh ======"

} else {
    puts "ERROR: Implementation failed."
    exit 1
}