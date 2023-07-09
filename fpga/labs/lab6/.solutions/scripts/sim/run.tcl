##
## Example Tcl simulation script for the Xilinx XSim simulator.
##
## The script is automatically executed when invoking the XSim
## standalone executable from Makefile. Alternatively you can
## also 'source' the script from the XSim Tcl console. Since
## we assume to run the simulation flow into work/sim use:
##
##   xsim% source ../../scripts/sim/run.tcl
##
## Use this file as a template script to automate your simulations
## using XSim Tcl commands.
##
## Luca Pacher - pacher@to.infn.it
## Fall, 2020
##


## profiling
set tclStart [clock seconds]

## main scripts directory
set scriptsDir [pwd]/../../scripts

## load into XSim Tcl environment the custom 'relaunch' procedure...
if { [info procs relaunch] eq "" } {

   source -notrace -quiet ${scriptsDir}/sim/relaunch.tcl ;  ## but do this only once !
}


#########################
##   waveforms setup   ##
#########################

## choose signals displayed in the Wave window or dumped into a VCD file
if { [file exists ${scriptsDir}/sim/probe.tcl] } {

   source -notrace -quiet ${scriptsDir}/sim/probe.tcl ;   ## use a dedicated script for this task
}


############################
##   run the simulation   ##
############################

##
## **NOTE
##
## By default the 'run' command runs the simulation until 100 ns
## and then stops, use 'run all' or 'run <time>' instead for
## longer simulations.
##

## run the simulation until a $finish or $stop statement is found in the testbench
run all

## alternatively run for a certain time
#run 500 ns
#run 1 us   etc.


## flush and close Value Change Dump (VCD) database (if any)
if { [current_vcd -quiet] != "" } {

   flush_vcd [current_vcd]
   close_vcd [current_vcd]
}

## print overall simulation time on XSim console
puts "Simulation finished at [current_time]"

## report CPU time
set tclStop [clock seconds]
set tclSeconds [expr ${tclStop} - ${tclStart} ]

puts "\nTotal elapsed-time for [file normalize [info script]]: [format "%.2f" [expr ${tclSeconds}/60.]] minutes\n"


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

