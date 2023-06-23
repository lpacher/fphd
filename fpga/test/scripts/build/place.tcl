##
## Example placement script for a non-project mode Vivado implementation flow.
##
## The script can be also executed standalone from Makefile using:
##
##    % make build/place [mode=gui|tcl|batch]
##
## Luca Pacher - pacher@to.infn.it
## Fall 2020
##



puts "\nINFO: \[TCL\] Running [file normalize [info script]]\n"

##
## save/restore flow
##

if { [current_project -quiet] eq "" } {

   ## load common variables and preferences
   source ${scriptsDir}/common/variables.tcl
   source ${scriptsDir}/common/part.tcl

   ## load flow-specific variables and preferences
   source ${scriptsDir}/build/variables.tcl

   if { [file exists ${outputsDir}/mapped.dcp] } {

      ## if available, restore previous post-synthesis design-checkpoint
      open_checkpoint -verbose ${outputsDir}/mapped.dcp

      #read_checkpoint ${outputsDir}/mapped.dcp
      #link_design

   } else {

      ## re-run the synthesis flow otherwise
      puts "\n\n**WARN: SYNTHESIS design checkpoint not found! Re-running synthesis flow ...\n\n"

      source ${scriptsDir}/build/syn.tcl
   }
}


puts "#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n# FLOW INFO: PLACEMENT\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n"


## profiling
set tclStart [clock seconds]


###########################################
##   pre-placement design optimization   ##
###########################################

opt_design -remap

report_utilization -file ${reportsDir}/post_opt_utilization.rpt


#######################
##   run placement   ##
#######################

place_design \
   -verbose -timing_summary

#place_design -no_timing_driven -verbose


##########################
##   save design data   ##
##########################

## write a database for the placed design
write_checkpoint \
   -force ${outputsDir}/placed.dcp

## generate post-routing reports
report_utilization -file ${reportsDir}/post_place_utilization.rpt
report_timing -file ${reportsDir}/post_place_timing.rpt


## report CPU time
set tclStop [clock seconds]
set seconds [expr ${tclStop} - ${tclStart} ]

puts "\nINFO: \[TCL\] Total elapsed-time for [file normalize [info script]]: [format "%.2f" [expr $seconds/60.]] minutes\n"

