##
## Example standalone programming script to program a target external
## SPI flash memory using Xilinx Vivado Hardware Manager Tcl commands.
##
## The script can be executed at the command line with:
##
##   % make install_flash [bin=/path/to/filename.bin]
##
## Alternatively, source the script at the Vivado command prompt at the
## end of the physical implementation flow:
##
##   Vivado% source ./scripts/install/install_flash.tcl
##
## Luca Pacher - pacher@to.infn.it
## Fall 2020
##


## **DEBUG
puts "\nINFO: \[TCL\] Running [file normalize [info script]]\n"

## profiling
set tclStart [clock seconds]


###############################################
##   load common variables and preferences   ##
###############################################

set scriptsDir [pwd]/scripts

source ${scriptsDir}/common/variables.tcl
source ${scriptsDir}/common/part.tcl


#########################################
##   parse memory configuration file   ##
#########################################

set programFile {}

## check if the path to a bitfile is specified from Makefile
if { [info exists ::env(BIN_FILE)] } {

   set programFile [file normalize ${::env(BIN_FILE)} ] ;  ## **IMPORTANT: use [file normalize $filename] to get absolute path and map \ to / under Windows

   ## check if the file exists
   if { [file exists ${programFile}] && [file extension ${programFile}] eq ".bin"  } {

      puts "\nINFO: \[TCL\] Current program file set to ${programFile}\n\n"

   } else {

      puts "ERROR: \[TCL\] The specified file ${programFile} does not exist or is not a raw binary file!"
      puts "             Please specify a valid path to an existing program file."
      puts "             Force an exit now.\n\n"

      ## script failure
      exit 1
   }

## search for a bitfile file into work/build/outputs
} elseif { [glob -nocomplain */build/outputs/*.bit] != "" } {

   set programFile [glob -nocomplain */build/outputs/*.bin] ;   ## **IMPORTANT: use the RAW BINARY file for memory programming!

   puts "INFO: \[TCL\] Default program file ${programFile} assumed for memory programming.\n\n"

} else {

   ## no valid program file specified
   puts "ERROR: \[TCL\] No valid program file found for firmware installation. Please specify a valid program file!"
   puts "             Force an exit now.\n\n"

   ## script failure
   exit 1
}


###############################
##   hardware server setup   ##
###############################

## launch Harware Manager
open_hw_manager ;                 ## **IMPORTANT: legacy 'open_hw' command is now DEPRECATED

## if launched in Tcl mode, change default prompt
if { ${rdi::mode} == "tcl" } {

   set tcl_prompt1  {puts -nonewline "hw_manager% "}
}

## server setup (local machine)
set SERVER   localhost
set PORT     3121

## connect to hardware server
connect_hw_server -url ${SERVER}:${PORT} -verbose

puts "Current hardware server set to [current_hw_server]" ;   ## [current_hw_server] simply returns $SERVER:$PORT


################################
##   identify target device   ##
################################

## try to automatically detect all devices connected to the server (same as "Autoconnect" in the GUI)
if { [catch {

   open_hw_target ;   ## returns 1 if something is wrong

}] } {

   puts "\n\nERROR: \[TCL\] Cannot connect to any hardware target !"
   puts "             Please connect a board to the computer or check your cables."
   puts "             Force an exit now.\n\n"

   ## script failure
   exit 1
}

current_hw_device [lindex [get_hw_devices] 0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]


###################################
##   configuration memory setup  ##
###################################

puts "\n\nINFO: Attaching memory device ${targetQuadSpiFlash} to JTAG chain...\n"

##
## **NOTE
##
## The following statements are those recorded in the Tcl console when
## working from the GUI, nothing special.
##

## identify the Quad SPI Flash memory (same as "Add Configuration Memory Device..." in the GUI)
create_hw_cfgmem \
   -hw_device [lindex [get_hw_devices] 0] \
   -mem_dev   [lindex [get_cfgmem_parts ${targetQuadSpiFlash}] 0]

## set programming options
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.ERASE        1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.VERIFY       1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]] ;  ## **NOTE: set this value to 0 to EREASE-only the memory!
set_property PROGRAM.CHECKSUM     0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]

## programming file
set_property PROGRAM.FILES                  ${programFile} [get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]
set_property PROGRAM.ADDRESS_RANGE          {use_file}     [get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]
set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none}    [get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]

refresh_hw_device [lindex [get_hw_devices] 0]


######################################
##    program the external memory   ##
######################################

## write the FPGA firmware to target external flash memory
program_hw_devices  [lindex [get_hw_devices] 0]
program_hw_cfgmem -hw_cfgmem [get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]

refresh_hw_device [lindex [get_hw_devices] 0] 


##################################################
##   if needed, force a soft-boot from memory   ##
##################################################

##
## **NOTE
##
## You can immediately detect if the FPGA is programmed by looking at the DONE status bit
## in the JTAG instruction register (REGISTER.IR.BIT5_DONE).
##
## If the FPGA configuration has not been updated, issue a JPROGRAM command and re-initialize
## the JTAG startup programming sequence.
##

#
#if { [get_property REGISTER.IR.BIT5_DONE [lindex [get_hw_devices] 0]] == 0 } {
#
#   boot_hw_device    [lindex [get_hw_devices] 0] -verbose
#   refresh_hw_device [lindex [get_hw_devices] 0] 
#}
#

##############################
##   disconnect when done   ##
##############################

## close current hardware target
close_hw_target [current_hw_target]

## disconnect from hardware server
disconnect_hw_server [current_hw_server]

puts "\n\n"
puts "==============================================="
puts "   External memory successfully programmed !   "
puts "==============================================="


## report CPU time
set tclStop [clock seconds]
set seconds [expr ${tclStop} - ${tclStart} ]

puts "\nINFO: \[TCL\] Total elapsed-time for [file normalize [info script]]: [format "%.2f" [expr $seconds/60.]] minutes\n"

## if launched in batch mode, close the Vivado Hardware Manager and exit
if { ${rdi::mode} == "batch" } {

   close_hw_manager
   exit
}

