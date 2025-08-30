# vivado.tcl — recreate Vivado project from clean sources (recursive + debug)

# === EDIT THESE ===
set PART    ""                 ;
set RTL_TOP "core_top"         ;# your RTL top module
set TB_TOP  "core_top_tb"      ;# your testbench top ("" if none)

# --- helper: recursively collect files matching patterns ---
proc collect_files {root patterns} {
    set out {}
    if {![file exists $root]} { return $out }
    # collect matches in this dir
    foreach pat $patterns {
        foreach f [glob -nocomplain -directory $root $pat] {
            if {![file isdirectory $f]} { lappend out [file normalize $f] }
        }
    }
    # recurse into subdirs
    foreach d [glob -nocomplain -directory $root *] {
        if {[file isdirectory $d]} {
            set out [concat $out [collect_files $d $patterns]]
        }
    }
    return $out
}

# --- project setup ---
set PROJ "proj_clean"
set PROJ_DIR [file normalize "./build/$PROJ"]
file delete -force $PROJ_DIR
file mkdir $PROJ_DIR

create_project $PROJ $PROJ_DIR -force
if {$PART ne ""} { set_property part $PART [current_project] }

# --- collect files ---
set rtl_files [collect_files "./rtl" {"*.sv" "*.v"}]
set tb_files  [collect_files "./tb"  {"*.sv"}]
set xdc_files [collect_files "./constr" {"*.xdc"}]

puts "Found [llength $rtl_files] RTL files"
puts "Found [llength $tb_files]  TB files"
puts "Found [llength $xdc_files] XDC files"

# --- add to project ---
if {[llength $rtl_files] > 0} {
    add_files -fileset sources_1 $rtl_files
    if {$RTL_TOP ne ""} { set_property top $RTL_TOP [get_filesets sources_1] }
}

if {[llength $xdc_files] > 0} {
    add_files -fileset constrs_1 $xdc_files
}

if {[llength $tb_files] > 0} {
    add_files -fileset sim_1 $tb_files
    if {$TB_TOP ne ""} { set_property top $TB_TOP [get_filesets sim_1] }
}

# Optional: show current working dir for sanity
puts "vivado.tcl executed from: [pwd]"
