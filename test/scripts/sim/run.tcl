#
# Example Tcl simulation script for Xilinx XSim simulator
#
# Luca Pacher - pacher@to.infn.it
# Fall, 2020
#

## profiling
set tclStart [clock seconds]

## scripts directory
set TCL_DIR  [pwd]/../../scripts ;   ## **IMPORTANT: assume to run the flow inside $(WORK_DIR)/sim (ref. to Makefile)

## WCFG directory
set WCFG_DIR [pwd]/../../wcfg

## top-level RTL module (then tb_${RTL_TOP_MODULE} is the testbench)
set RTL_TOP_MODULE ${::env(RTL_TOP_MODULE)} ;   ## **REM: the RTL_TOP_MODULE environment variable is exported from Makefile

## top-level
set TOP tb_${::env(RTL_TOP_MODULE)}

if { [current_wave_config] eq "" } {

   if { [file exists ${WCFG_DIR}/${TOP}.wcfg] } {

      ## open waveforms configuration file if exists...
      open_wave_config ${WCFG_DIR}/${TOP}.wcfg

   } else {

      ## or create new Wave window (default name is "Untitled 1") otherwise and probe all top-level signals to the Wave window
      create_wave_config "Untitled 1"
      add_wave /${TOP}/*
      add_wave /${TOP}/DUT/pll_clk
      add_wave /${TOP}/DUT/pll_locked
   }
}

## run the simulation
run all

## print overall simulation time on XSim console
puts "Simulation finished at [current_time]"

## report CPU time
set tclStop [clock seconds]
set tclSeconds [expr ${tclStop} - ${tclStart} ]

puts "\nTotal elapsed-time for [file normalize [info script]]: [format "%.2f" [expr ${tclSeconds}/60.]] minutes\n"


## **IMPORTANT: load into XSim Tcl environment the custom 'relaunch' procedure
source -notrace -quiet [pwd]/../../scripts/sim/relaunch.tcl


########################################################
##   other simulation commands (just for reference)   ##
########################################################

## reset simulation time back to t=0
#restart

## get/set current scope
#current_scope
#get_scopes
#report_scopes

## change default radix for buses (default is hexadecimal)
#set_property radix bin       [get_waves *]
#set_property radix unsigned  [get_waves *] ;  ## unsigned decimal
#set_property radix hex       [get_waves *]
#set_property radix dec       [get_waves *] ;  ## signed decimal
#set_property radix ascii     [get_waves *]
#set_property radix oct       [get_waves *]

## save Waveform Configuration File (WCFG) for later restore
#save_wave_config /path/to/filename.wcfg

## query signal values and drivers
#get_value /path/to/signal
#describe /path/to/signal
#report_values
#report_drivers /path/to/signal
#report_drivers [get_nets *signal]

## deposit a logic value on a signal
#set_value [-radix bin] /hierarchical/path/to/signal value

## force a signal
#add_force [-radix] [-repeat_every] [-cancel_after] [-quiet] [-verbose] /hierarchical/path/to/signal value
#set forceName [add_force /hierarchical/path/to/signal value]

## delete a force or all forces
#remove_forces ${forceName}
#remove_forces -all

## add/remove breakpoints to RTL sources
#add_bp [pwd]/../../rtl/fileName.vhd lineNumber
#remove_bp -file fileName [pwd]/../../rtl/fileName.vhd -line lineNumber
#remove_bp -all

## unload the simulation snapshot without exiting Vivado
#close_sim

## dump Switching Activity Interchange Format (SAIF) file for power analysis
#open_saif /path/to/file.saif
#log_saif /path/to/signal
#log_saif [get_objects]
#close_saif

## hide the GUI
#stop_gui

## exit the simulator
#exit
