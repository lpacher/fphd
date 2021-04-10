#
# Example Tcl script to run the complete Xilinx Vivado
# implementation flow in non-project mode.
#
# The script is executed at the command-line by using :
#
#    % make xflow [aliased to make bit or make build]
#
# Luca Pacher - pacher@to.infn.it
# Fall 2020
#

## profiling
set tclStart [clock seconds]


## **IMPORTANT: assume to run the flow inside WORK_DIR/impl
cd [pwd]/${::env(WORK_DIR)}/impl


## Tcl variables
set RTL_DIR  [pwd]/../../rtl
set LOG_DIR  [pwd]/../../logs
set IPS_DIR  [pwd]/../../cores
set XDC_DIR  [pwd]/../../xdc
set TCL_DIR  [pwd]/../../scripts

## reports directories
set RPT_DIR  [pwd]/reports

file mkdir ${RPT_DIR}
file mkdir ${RPT_DIR}/synthesis
file mkdir ${RPT_DIR}/placement
file mkdir ${RPT_DIR}/routing

## outputs directories
set OUT_DIR  [pwd]/outputs

file mkdir ${OUT_DIR}
file mkdir ${OUT_DIR}/checkpoints
file mkdir ${OUT_DIR}/bitstream
file mkdir ${OUT_DIR}/sdf
file mkdir ${OUT_DIR}/netlist
file mkdir ${OUT_DIR}/xdc


##########################################################
##   RTL sources setup (project-dependent parameters)   ##
##########################################################

## top-level design module
set RTL_TOP_MODULE ${::env(RTL_TOP_MODULE)} ; puts "\n**INFO: Top-level RTL module is ${RTL_TOP_MODULE}\n"

## VHDL sources
set RTL_VHDL_SOURCES [glob -nocomplain ${RTL_DIR}/*.vhd]

## Verilog/SystemVerilog sources
set RTL_VLOG_SOURCES [concat [glob -nocomplain ${RTL_DIR}/*.v] [glob -nocomplain ${RTL_DIR}/*.sv]]

## IP sources (assume to load .xci file)
set IP_SOURCES [glob -nocomplain ${IPS_DIR}/*/*.xci]

## XDC sources
set XDC_SOURCES [glob -nocomplain ${XDC_DIR}/*.xdc]


###################################################################
##   design import  (parse RTL sources and design constraints)   ##
###################################################################


## target FPGA (Digilent Arty7 development board)
set targetFpga ${::env(XILINX_DEVICE)}

## create in-memory project
create_project -in_memory -part ${targetFpga}



puts "\n-- Parsing RTL sources ...\n"


## read Verilog/SystemVerilog sources
if { [llength ${RTL_VLOG_SOURCES}] != 0 } {

   foreach src ${RTL_VLOG_SOURCES} {

   puts "Parsing Verilog source file ${src} ..."
   read_verilog -sv ${src}

   }
}

## read VHDL sources
if { [llength ${RTL_VHDL_SOURCES}] != 0 } {

   foreach src ${RTL_VHDL_SOURCES} {

      puts "Parsing VHDL source file ${src} ..."
      read_vhdl ${src}
   }
}


## read IP cores
if { [llength ${IP_SOURCES}] != 0 } {

   foreach src ${IP_SOURCES} {

      puts "Parsing IP XML configuration file ${src} ..."
      read_ip ${src}
   }
}

## read and parse Xilinx Design Constraints (XDC)
if { [llength ${XDC_SOURCES}] == 0 } {

   puts "**ERROR: No constraints specified for FPGA implementation, aborting."
   exit 1

} else {

   foreach src ${XDC_SOURCES} {

      puts "Parsing Xilinx Design Constraint (XDC) source file ${src} ..."
      read_xdc -unmanaged ${src}
   }
}

set_part ${targetFpga}
set_property top ${RTL_TOP_MODULE} [current_fileset]


#########################
##   RTL elaboration   ##
#########################

## elaborate RTL source files into a schematic
synth_design -rtl -top ${RTL_TOP_MODULE} -part ${targetFpga} -flatten_hierarchy none -name rtl_1


##########################
##   mapped synthesis   ##
##########################

## synthesize the design
synth_design -top ${RTL_TOP_MODULE} -part ${targetFpga} -flatten_hierarchy full -name syn_1


## write a database for the synthesized design
write_checkpoint -force ${OUT_DIR}/checkpoints/synthesis
#read_checkpoint -force ${OUT_DIR}/checkpoints/synthesis


## generate post-synthesis reports
report_utilization -file ${RPT_DIR}/synthesis/post_syn_utilization.rpt
report_timing -file ${RPT_DIR}/synthesis/post_syn_timing.rpt


###################
##   placement   ##
###################

## place the design
place_design -verbose
#place_design -no_timing_driven -verbose


## write a database for the routed design
write_checkpoint -force ${OUT_DIR}/checkpoints/placement


## generate post-routing reports
report_utilization -file ${RPT_DIR}/placement/post_placement_utilization.rpt
report_timing -file ${RPT_DIR}/placement/post_placement_timing.rpt



#################
##   routing   ##
#################

## route the design
route_design
#route_design -no_timing_driven -verbose


## write a database for the routed design
write_checkpoint -force ${OUT_DIR}/checkpoints/routing


## generate post-routing reports
report_utilization -file ${RPT_DIR}/routing/post_routing_utilization.rpt
report_timing -file ${RPT_DIR}/routing/post_routing_timing.rpt
report_power -file ${RPT_DIR}/routing/post_routing_power.rpt
report_drc -file ${RPT_DIR}/routing/post_routing_drc.rpt


##################################################################
##   export gate-level netlist and SDF for timing simulations   ##
##################################################################

write_verilog -mode timesim -nolib -sdf_anno false -force -file ${OUT_DIR}/netlist/${RTL_TOP_MODULE}.vg

foreach corner [list slow fast] {

   write_sdf -mode timesim -process_corner ${corner} -force -file ${OUT_DIR}/sdf/${RTL_TOP_MODULE}\_${corner}.sdf
}


############################
##   generate bitstream   ##
############################

## generate bitstream
#write_bitstream -force ${OUT_DIR}/bitstream/${RTL_TOP_MODULE}.bit
write_bitstream -force -bin_file ${OUT_DIR}/bitstream/${RTL_TOP_MODULE}.bit



puts "\n -- FPGA implementation flow completed !\n\n"

## report CPU time
set tclStop [clock seconds]
set seconds [expr ${tclStop} - ${tclStart} ]

puts "\nTotal elapsed-time for [file normalize [info script]]: [format "%.2f" [expr $seconds/60.]] minutes\n"


## optionally, upload the bitstream to target FPGA
#source ${TCL_DIR}/upload.tcl


## optionally, start the GUI and debug synthesis/place-and-route schematic results
#start_gui
#stop_gui
