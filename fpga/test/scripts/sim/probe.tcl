##
## Example Tcl script for waveforms probing and debugging using the Xilinx XSim simulator.
## Use this file as a template script to automate your simulation using XSim Tcl commands.
##
## Common tasks involving waveforms are:
##
##   - selection of all signals of interest to be displayed in the Wave window if running
##     the simulation in GUI mode or to be dumped into a VCD file if running in batch mode
##
##   - definition of additional customizations for waveform traces (e.g. grouping signals
##     into buses)
##
##   - save waveforms settings into a waveform configuration file (WCFG)
##
## Ref. also to Xilinx official documentation:
##
##   - "Vivado Design Suite User Guide: Logic Simulation (UG900)"
##   - "Vivado Design Suite Tutorial: Logic Simulation (UG973)"
##
## Luca Pacher - pacher@to.infn.it
## Fall 2020
##


###########################
##   waveforms probing   ##
###########################

## dump all HDL signals and objects to binary Waveform Database (WDB) for later restore
log_wave -r /*

## create new Wave window (default name is "Untitled 1" otherwise)
create_wave_config "Waveforms"

## probe all top-level signals (testbench signals)
add_wave /tb_Counter/*

## probe PLL output signals (divided clock and locked flag)
add_wave /tb_Counter/DUT/pll_clk
add_wave /tb_Counter/DUT/pll_locked -color SILVER ;   ## you can also customize the trace color from Tcl

## define a new custom bus and group the first 5 least-significant bits of the counter to view some toggles
add_wave_virtual_bus "count[4:0]"

for {set k 0} {$k < 5} {incr k} {

   add_wave /tb_Counter/DUT/count[$k] -name "count[$k]" -into "count[4:0]" ;   ## you can also customize the name of the signal from Tcl
}


#######################################################
##   VCD setup (useful for batch-mode simulations)   ##
#######################################################

set vcdDir [pwd]/vcd

if { ![file exists ${vcdDir}] } {

   file mkdir ${vcdDir}
}


if { ${rdi::mode} != "gui" } {

   ## open VCD file
   open_vcd ${vcdDir}/waveforms.vcd

   ## use 'log_vcd' to select signals to trace
   log_vcd /tb_Counter/*
   log_vcd /tb_Counter/DUT/pll_clk
   log_vcd /tb_Counter/DUT/pll_locked
   log_vcd /tb_Counter/DUT/count[0]
   log_vcd /tb_Counter/DUT/count[1]
   log_vcd /tb_Counter/DUT/count[2]
   log_vcd /tb_Counter/DUT/count[3]
   log_vcd /tb_Counter/DUT/count[4]

}

#################################################################
##   example waveforms-related commands (just for reference)   ##
#################################################################

##
## Waveform Configuration
##

## list all Wave windows in the GUI
#get_wave_configs

## get current Waveform Configuration name (the currently selected in the GUI)
#current_wave_config

## create new Waveform Configuration with name (default is "Untitled 1" otherwise)
#create_wave_config [optional name]

## save Waveform Configuration to file for later restore
#save_wave_config /path/to/filename.wcfg

## restore Waveform Configuration from file
#open_wave_config /path/to/filename.wcfg

## close Waveform Configuration
#close_wave_config <name>
#close_wave_config [current_wave_config]

## close ALL waveform windows
#foreach w [get_wave_configs] { close_wave_config -force $w }


##
## probing commands
##

## add signals of interest to the Wave window (you can also use the * wildcard character)
# add_wave /path/to/signal

##
## dump waveforms to Value Change Dump (VCD) database
##

## create new VCD file
#open_vcd /path/to/filename.vcd

## select signals to trace
#log_vcd /tb_Counter/*
#log_vcd /tb_Counter/DUT/pll_clk
#log_vcd /tb_Counter/DUT/pll_clk

## run the simulation
#run all

## close VCD database once done
#close_vcd

