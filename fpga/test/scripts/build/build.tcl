##
## Example non-project mode FPGA implementation flow using Xilinx Vivado.
## The script is executed at the command-line by using:
##
##   % make build [mode=gui|tcl|batch]
##
## Luca Pacher - pacher@to.infn.it
## Fall 2020
##
##
## **IMPORTANT
##
## The proposed Makefile allows also to run the flows step-by-step with
## a save/exit/restore approach, thus we are assuming that all scripts
## are executed by Vivado from the top repository. HOWEVER output results
## and reports are dumped into the work/build directory.
##

global scriptsDir ; set scriptsDir [pwd]/scripts

if { [catch {

   ## start global timer
   set buildStart [clock seconds]
   puts "Start at: [clock format ${buildStart} -format {%x %X}]"

   ## parse RTL and IP sources
   source ${scriptsDir}/build/import.tcl

   ## synthesis
   source ${scriptsDir}/build/syn.tcl

   ## placement
   source ${scriptsDir}/build/place.tcl

   ## routing
   source ${scriptsDir}/build/route.tcl

   ## generate bitsream and memory configuration files, export SDF, XDC and gate-level netlist for timing simulations
   source ${scriptsDir}/build/export.tcl

   ## end global timer
   set buildStop [clock seconds]
   set buildSeconds [expr ${buildStop} - ${buildStart} ]

   puts "\nINFO: \[TCL\] Total elapsed-time: [format "%.2f" [expr ${buildSeconds}/60.]] minutes\n"


   puts "============================================"
   puts "   FPGA implementation flow **COMPLETED**   "
   puts "============================================\n\n"

   ## normal exit
   #exit 0


} msg]} {


   puts "\n **ERROR: FPGA implementation could not finish successfully. Force an exit now. ($msg)\n"

   ## script failure
   exit 1

}

