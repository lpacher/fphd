##
## A first example Tcl simulation script for the Xilinx XSim simulator.
##
## Luca Pacher - pacher@to.infn.it
## Spring 2023
##


## profiling
set tclStart [clock seconds]

## add all top-level signals to the Wave window
add_wave /*

## run the simulation until a $stop or $finish statement is found in the code
run all

## print the overall simulation time on XSim console
puts "\nSimulation finished at [current_time]\n"

## report CPU time
set tclStop [clock seconds]
set seconds [expr ${tclStop} - ${tclStart} ]

puts "\nTotal elapsed-time for [info script]: [format "%.2f" [expr ${seconds}/60.]] minutes\n"
