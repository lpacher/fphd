##
## Example design-export script for a non-project mode Vivado implementation flow.
## Generate FPGA and memory configuration files, export final Verilog gate-level
## netlist and back-annoted net delay (SDF) for signoff gate-level timing simulations.
##
## The script can be also executed standalone from Makefile using:
##
##    % make build/import [mode=gui|tcl|batch]
##
## Luca Pacher - pacher@to.infn.it
## Fall 2020
##


## **DEBUG
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

   if { [file exists ${outputsDir}/routed.dcp] } {

      ## if available, restore previous post-routing design-checkpoint
      open_checkpoint -verbose ${outputsDir}/routed.dcp

      #read_checkpoint ${outputsDir}/routed.dcp
      #link_design

   } else {

      ## re-run the routing flow otherwise
      puts "\n\n**WARN: ROUTED design checkpoint not found! Re-running routing flow ...\n\n"

      source ${scriptsDir}/build/route.tcl
   }
}


puts "#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n# FLOW INFO: EXPORT\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n#\n"


## profiling
set tclStart [clock seconds]


##################################################################
##   export gate-level netlist and SDF for timing simulations   ##
##################################################################

puts "\n\nINFO: \[TCL\] Final signoff Verilog gate-level netlist is ${outputsDir}/signoff.v\n"

write_verilog \
   -mode timesim -nolib -sdf_anno false -force -file ${outputsDir}/signoff.v


## export SDF for all corners
foreach corner [list slow fast] {

   write_sdf \
      -mode timesim -process_corner ${corner} -force -file ${outputsDir}/signoff\_${corner}.sdf
}


############################
##   generate bitstream   ##
############################

puts "\n\nINFO: \[TCL\] Write bitsream...\n"

##
## **IMPORTANT
##
## In order to be able to write the FPGA configuration into a dedicated
## external memory you must generate a pure BINARY (.bin) file, not
## only the BIT (.bit) file.
##


## optimize the programming of the Quad SPI Flash
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4               [current_design]


## generate FPGA and memory configuration files
write_bitstream \
   -verbose -force -bin_file ${outputsDir}/[get_property top [current_design]].bit


## report CPU time
set tclStop [clock seconds]
set seconds [expr ${tclStop} - ${tclStart} ]

puts "\nINFO: \[TCL\] Total elapsed-time for [file normalize [info script]]: [format "%.2f" [expr $seconds/60.]] minutes\n"

