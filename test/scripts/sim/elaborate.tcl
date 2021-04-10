#
# Example custom Tcl-based simulation flow to run XSim simulation flows interactively [ELABORATION step]
#
# Luca Pacher - pacher@to.infn.it
# Fall 2020
#

###################################################################################################
#
# **NOTE
#
# There is no "non-project mode" simulation Tcl flow in Vivado, the "non-project mode" flow
# requires to call standalone xvlog/xvhdl, xelab and xsim executables from the command-line
# or inside a GNU Makefile.
# However in "non-project mode" the simulation can't be re-invoked from the GUI after RTL
# or testbench changes, thus requiring to exit from the GUI and re-build the simulation
# from scratch. This happens because XSim doesn't keep track of xvlog/xvhdl and xelab flows.
#
# In order to be able to "relaunch" a simulation from the XSim GUI you necessarily have to
# create a project in Vivado or to use a "project mode" Tcl script to automate the simulation.
# The overhead of creating an in-memory project is low compared to the benefits of fully automated
# one-step compilation/elaboration/simulation and re-launch features.
#
# This **CUSTOM** Tcl-based simulation flow basically reproduces all compilation/elaboration/simulation
# steps that actually Vivado performs "under the hood" for you without notice in project-mode.
# Most important, this custom flow is **PORTABLE** across Linux/Windows systems and allows
# to "relaunch" a simulation after RTL or testbench changes from the XSim Tcl console without
# the need of creating a project.
#
# Ref. also to  https://www.edn.com/improve-fpga-project-management-test-by-eschewing-the-ide
#
###################################################################################################


proc elaborate {} {

   ## **IMPORTANT: assume to run the flow inside WORK_DIR/sim (the WORK_DIR environment variable is exported by Makefile)
   cd ${::env(WORK_DIR)}/sim

   ## variables
   set TCL_DIR  [pwd]/../../scripts
   set LOG_DIR  [pwd]/../../log
   set RTL_DIR  [pwd]/../../rtl
   set SIM_DIR  [pwd]/../../bench
   set IPS_DIR  [pwd]/../../cores

   ## top-level RTL module (then tb_${RTL_TOP_MODULE} is the testbench)
   set RTL_TOP_MODULE ${::env(RTL_TOP_MODULE)}

   ####################################
   ##   design elaboration (xelab)   ##
   ####################################

   ## delete the previous log file if exists
   if { [file exists ${LOG_DIR}/elaborate.log] } {

      file delete ${LOG_DIR}/elaborate.log
   }

   #
   # **IMPORTANT
   #
   # If the RTL design to be simulated already contains Xilinx primitives (e.g. IBUF, OBUF etc.)
   # then pre-compiled simulation libraries e.g. UNISIM, SIMIPRIME, SECUREIP etc. must be referenced
   # in the code using
   #
   #    library UNISIM ;
   #    use UNISIM.vcomponents.all ;
   #
   # at the beginning of each VHDL source file referencing FPGA primitives.
   #
   # As already done for the compilation flow, by using the 'catch' Tcl command the elaboration process
   # will continue until the end despite ELABORATION ERRORS are present inside compiled sources.
   # All elaboration errors are then shown on the console using 'grep' on the log file.
   #

   puts "\n**INFO: Top-level RTL module: ${::env(RTL_TOP_MODULE)}\n\n"

   puts "\n-- Elaborating the design ...\n"

   catch {exec xelab -relax -mt 2 \
      -L work -L xil_defaultlib -L secureip \
      -debug all work.tb_${RTL_TOP_MODULE}  \
      -snapshot tb_${RTL_TOP_MODULE} -nolog >@stdout 2>@stdout | tee ${LOG_DIR}/elaborate.log}



   ######################################
   ##   check for elaboration errors   ##
   ######################################

   puts "\n-- Checking for elaboration errors ...\n"

   if { [catch {exec grep --color ERROR ${LOG_DIR}/elaborate.log >@stdout 2>@stdout }] } {

      puts "\t================================="
      puts "\t   NO ELABORATION ERRORS FOUND   "
      puts "\t================================="
      puts "\n"

      return 0

   } else {

      puts "\n"
      puts "\t==================================="
      puts "\t   ELABORATION ERRORS DETECTED !   "
      puts "\t==================================="
      puts "\n"

      puts "Please, fix all elaboration errors and recompile sources.\n"

      return 1
   }
}


## optionally, run the Tcl procedure when the script is executed by tclsh from Makefile
if { [info exists argv] } {
   if { [lindex ${argv} 0] == "elaborate" } {

      puts "\n**INFO \[TCL\]: Running [file normalize  [info script]]\n"

      if { [elaborate] } {

         ## elaboration contains errors, exit with non-zero error code
         puts "Elaboration **FAILED**"
         exit 1

      } else {

         ## elaboration OK
         exit 0
      }
   }
}
