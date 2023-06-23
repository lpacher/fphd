##
## Example standalone programming script to program a target Xilinx FPGA
## using Xilinx Vivado Hardware Manager Tcl commands.
##
## The script can be executed at the command line with:
##
##   % make install [bit=/path/to/filename.bit]
##
## Alternatively, source the script at the Vivado command prompt at the
## end of the physical implementation flow:
##
##   Vivado% source ./scripts/install/install.tcl
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


###########################################
##   program file/debug probes parsing   ##
###########################################

set programFile {}
set probeFile   {}

## check if the path to a bitfile is specified from Makefile
if { [info exists ::env(BIT_FILE)] } {

   set programFile [file normalize ${::env(BIT_FILE)} ] ;  ## **IMPORTANT: use [file normalize $filename] to get absolute path and map \ to / under Windows

   ## check if the file exists
   if { [file exists ${programFile}] && [file extension ${programFile}] eq ".bit" } {

      puts "\nINFO: \[TCL\] Current program file set to ${programFile}\n\n"

   } else {

      puts "ERROR: \[TCL\] The specified file ${programFile} does not exist or is not a bit file!"
      puts "             Please specify a valid path to an existing program file."
      puts "             Force an exit now.\n\n"

      ## script failure
      exit 1
   }

## search for a bitfile file into work/build/outputs
} elseif { [glob -nocomplain */build/outputs/*.bit] != "" } {

   set programFile [glob -nocomplain */build/outputs/*.bit]

   puts "INFO: \[TCL\] Default program file ${programFile} assumed for device programming.\n\n"

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


###############################
##   target device parsing   ##
###############################

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


## check if the XILINX_DEVICE environment variable has been exported from Makefile...
if { [info exists ::env(XILINX_DEVICE)] } {

   ## ... and try to match the device string with $XILINX_DEVICE 
   foreach deviceName [get_hw_devices] {

      if { [string match "[string range ${::env(XILINX_DEVICE)} 0 6]*" ${deviceName}] } {

         current_hw_device ${deviceName}
         refresh_hw_device -update_hw_probes false ${deviceName}

      } else {

         puts "\n\nWARNING: \[TCL\] No hardware device matching XILINX_DEVICE=${::env(XILINX_DEVICE)}"
         puts "               Guessing the device from automatically-detected targets..."

      }
   }

## XILINX_DEVICE environment variable not set, guess the connected device 
} else {

      current_hw_device [lindex [get_hw_devices] 0]
      refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0] 
}


############################
##   device programming   ##
############################


puts "\n\nINFO: \[TCL\] Current hardware device set to [current_hw_device]\n\n"

## specify bitstream file
set_property PROGRAM.FILE ${programFile} [current_hw_device]

## specify ILA file (if any)
set_property PROBES.FILE {} [current_hw_device]

## download the firmware to target hardware FPGA device
program_hw_devices [current_hw_device]


##############################
##   disconnect when done   ##
##############################

## close current hardware target
close_hw_target [current_hw_target]

## disconnect from hardware server
disconnect_hw_server [current_hw_server]

puts "\n\n"
puts "===================================="
puts "   FPGA successfully programmed !   "
puts "===================================="


## report CPU time
set tclStop [clock seconds]
set seconds [expr ${tclStop} - ${tclStart} ]

puts "\nINFO: \[TCL\] Total elapsed-time for [file normalize [info script]]: [format "%.2f" [expr $seconds/60.]] minutes\n"

## if launched in batch mode, close the Vivado Hardware Manager and exit
if { ${rdi::mode} == "batch" } {

   close_hw_manager
   exit
}

