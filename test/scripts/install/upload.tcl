#
# Example standalone bitstream download script
# using Xilinx Vivado Hardware Manager Tcl commands.
#
# The script can be executed at the command line with:
#
#   % make upload [bit=/path/to/filename.bit]
#
# Alternatively, source the script at the Vivado command prompt:
#
#   vivado% source ./scripts/impl/upload.tcl
#
# Luca Pacher - pacher@to.infn.it
# Fall 2020
#

puts "\nINFO: \[TCL\] Running [file normalize [info script]]\n"


## profiling
set tclStart [clock seconds]

## variables
set WORK_DIR  ${::env(WORK_DIR)}


variable programFile
variable probeFile


###########################################
##   program file/debug probes parsing   ##
###########################################

## as a first step, check if the path to a bitfile (.bit) is passed to Vivado executable from Makefile
if { [llength ${argv}] > 0 } {

   if { [llength ${argv}] < 2 } {

      ## only program file (.bit) specified
      set programFile [file normalize [lindex ${argv} 0]] ;  ## **IMPORTANT: use [file normalize $filename] to automatically map \ into /

   } else {

      ## both program file (.bit) and ILA probes file (.ltx) specified
      set programFile [file normalize [lindex ${argv} 0]]
      set probeFile   [file normalize [lindex ${argv} 1]]

   }

   if { [file exists ${programFile}] } {

      puts "INFO: \[TCL\] Current program file set to ${programFile}\n\n"

   } else {

      puts "ERROR: \[TCL\] The specified file ${programFile} does not exist !"
      puts "             Please specify a valid path to an existing program file."
      puts "             Force an exit now.\n\n"

      ## script failure
      exit 1
   }

## assume $WORK_DIR/impl/outputs/bitstream/$RTL_TOP_MODULE.bit as default program file otherwise
} elseif { [info exists env(RTL_TOP_MODULE)] } {

      set RTL_TOP_MODULE ${::env(RTL_TOP_MODULE)}

      set programFile ${WORK_DIR}/impl/outputs/bitstream/${RTL_TOP_MODULE}.bit

      if { [file exists ${programFile}] } {

         puts "INFO: \[TCL\] Default program file ${programFile} assumed for device programming.\n\n"

      } else {

         puts "ERROR: \[TCL\] Default program file ${programFile} not found !"
         puts "             Force an exit now.\n\n"

         ## script failure
         exit 1
      }

} else {

    ## no valid program file specified
   puts "ERROR: \[TCL\] No valid program file specified. Please specify a valid program file!"
   puts "             Force an exit now.\n\n"

   ## script failure 
   exit 1
}


###############################
##   hardware server setup   ##
###############################

## launch Harware Manager
open_hw_manager ;                 ## **IMPORTANT: legacy 'open_hw' command is now DEPRECATED 


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
if { [info exists env(XILINX_DEVICE)] } {

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

## specify JTAG TCK frequency (Hz)
#set_property PARAM.FREQUENCY 125000 [current_hw_device]

## download the firmware to target hardware FPGA device
program_hw_devices [current_hw_device]


##############################
##   disconnect when done   ##
##############################

## close current hardware target
close_hw_target [current_hw_target]

## disconnect from hardware server
disconnect_hw_server [current_hw_server]

## optionally, close the Vivado Hardware Manager
#close_hw_manager


puts "\n -- FPGA succesfully programmed !\n\n"

## report CPU time
set tclStop [clock seconds]
set seconds [expr ${tclStop} - ${tclStart} ]

puts "\nTotal elapsed-time for [file normalize [info script]]: [format "%.2f" [expr $seconds/60.]] minutes\n"
