##
## Example synthesis script for a non-project mode Vivado implementation flow.
## Parse all Xilinx Design Constraints (XDC) files and map the RTL into real
## FPGA device primitives. At the end of the flow save a design-checkpoint
## of the design for later restore and debug.
##
## The script can be also executed standalone from Makefile using:
##
##    % make build/syn [mode=gui|tcl|batch]
##
## Luca Pacher - pacher@to.infn.it
## Fall 2020
##


puts "\nINFO: \[TCL\] Running [file normalize [info script]]\n"

##
## save/restore flow
##

## **WARN: you can't save a "checkpoint" until the design is synthesized, thus no .dcp database to restore here
if { [current_project -quiet] eq "" } {

   source ${scriptsDir}/build/import.tcl
}


puts "#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n# FLOW INFO: SYNTHESIS\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n"

## profiling
set tclStart [clock seconds]


##################################
##   parse design constraints   ##
##################################

puts "\n-- Parsing design constraints..."

if { [llength [glob -nocomplain [pwd]/xdc/*.xdc]] != 0 } {

   foreach src [glob -nocomplain [pwd]/xdc/*.xdc] {

      puts "\n\nLoading Xilinx Design Constraint (XDC) source file ${src} ...\n" ; read_xdc -unmanaged ${src}
   }

} else {

   puts "\n**ERROR: No constraints specified for FPGA implementation, aborting."

   ## script failure
   exit 1
}


##########################
##   mapped synthesis   ##
##########################

## synthesize the design
synth_design \
   -top                 ${RTL_TOP_MODULE}     \
   -part                ${targetXilinxDevice} \
   -flatten_hierarchy   full                  \
   -name                syn_1



## generate post-synthesis reports
report_utilization \
   -file ${reportsDir}/post_syn_utilization.rpt

report_timing \
   -file ${reportsDir}/post_syn_timing.rpt



####################################
##   save synthesis output data   ##
####################################

## save post-synthesis Verilog gate-level netlist for functional simulations
write_verilog \
   -mode funcsim -force ${outputsDir}/mapped.v

## write a database for the synthesized design
write_checkpoint \
   -force ${outputsDir}/mapped.dcp


## if running in GUI mode, save to PDF the gate-level schematic for later debug or project documentation
if { ${rdi::mode} eq "gui" } {

   show_schematic [concat [get_cells] [get_ports]]
   write_schematic -force -format pdf -scope all -orientation landscape ${outputsDir}/syn_schematic.pdf
}

