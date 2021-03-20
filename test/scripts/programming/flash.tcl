
#-----------------------------------------------------------------------------------------------------
#                               University of Torino - Department of Physics
#                                   via Giuria 1 10125, Torino, Italy
#-----------------------------------------------------------------------------------------------------
# [Filename]       flash.tcl
# [Project]        Introduction to FPGA programming using Xilinx Vivado and VHDL (PhD course)
# [Author]         Luca Pacher - pacher@to.infn.it
# [Language]       Tcl/Xilinx Vivado Tcl commands
# [Created]        Fall 2020
# [Modified]       -
# [Description]    Standalone download script using Xilinx Vivado Hardware Manager Tcl commands
#                  to program the non-volatile external Quad SPI Flash memory.
#
# [Notes]          The script is executed with:
#
#                     linux% make flash
#
#                  Alternatively, source the script at the Vivado command prompt:
#
#                     vivado% source ./scripts/impl/flash.tcl
#
# [Version]        1.0
#-----------------------------------------------------------------------------------------------------


if { [lindex $argv 0] == {} } {

   puts "\n **ERROR: The script requires a top-level module !"
   puts "Please specify top-level module name and retry."

   ## force an exit
   exit 1

} else {

   ## top-level design module
   set RTL_TOP_MODULE  [lindex $argv 0] ; puts "\n**INFO: Top-level RTL module is ${RTL_TOP_MODULE}\n"

}


## bitstream file
set OUT_DIR  [pwd]/results
set BINFILE  ${OUT_DIR}/bitstream/${RTL_TOP_MODULE}.bin ;     ## **WARN: the .bin file is required to program the external memory !


## server setup (local machine) 
set SERVER   localhost
set PORT     3121


## connect to the server
open_hw
connect_hw_server -url ${SERVER}:${PORT} -verbose
puts "Current hardware server set to [get_hw_servers]"


## specify target FPGA
## manually
#current_hw_target  [get_hw_targets */xilinx_tcf/Digilent/210319788446A]

## automatically
open_hw_target
current_hw_device [lindex [get_hw_devices] 0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]


## identify Quad SPI Flash memory (n25q128-3.3v-spi-x1_x2_x4 device)
create_hw_cfgmem -hw_device [lindex [get_hw_devices] 0] -mem_dev  [lindex [get_cfgmem_parts {n25q128-3.3v-spi-x1_x2_x4}] 0]


## set programming options
#set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
#set_property PROGRAM.ERASE        1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
#set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
#set_property PROGRAM.VERIFY       1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
#set_property PROGRAM.CHECKSUM     0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
#refresh_hw_device [lindex [get_hw_devices xc7a35t_0] 0]


## programming file
set_property PROGRAM.FILES ${BINFILE} [get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]

set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]

set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.ERASE        1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.VERIFY       1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
#set_property PROGRAM.CHECKSUM     0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]

## download the firmware to target external memory
program_hw_devices  [lindex [get_hw_devices] 0]
program_hw_cfgmem -hw_cfgmem [get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]


## terminate the connection when done
disconnect_hw_server  [current_hw_server]

