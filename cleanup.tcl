# ================================================================
#  cleanup.tcl  —  remove all generated files
#  Usage: vivado -mode batch -source cleanup.tcl
#     or: tclsh cleanup.tcl
# ================================================================

set origin_dir [file dirname [file normalize [info script]]]

# ── Folders to delete ───────────────────────────────────────────
set dirs [list \
    ".done"         \
    "ip_repo"       \
    "ip_pack"       \
    "sim_only"      \
    "convAccTop"    \
    "OverlayFiles"  \
]

foreach dir $dirs {
    set path "${origin_dir}/${dir}"
    if {[file exists $path]} {
        catch {file delete -force $path}
        if {![file exists $path]} {
            puts "INFO: Removed ${path}"
        } else {
            puts "WARNING: Could not remove ${path} (may be in use)"
        }
    }
}

# ── Loose files to delete ───────────────────────────────────────
foreach pattern [list "*.jou" "*.log" "*.str" "*.xsa" "*.jou.bak" ".Xil" "dfx_runtime.txt" "NA"] {
    foreach f [glob -nocomplain "${origin_dir}/${pattern}"] {
        catch {file delete -force $f}
        if {![file exists $f]} {
            puts "INFO: Removed ${f}"
        } else {
            puts "WARNING: Skipped ${f} (locked by Vivado)"
        }
    }
}

puts "INFO: ====== Cleanup complete ======"