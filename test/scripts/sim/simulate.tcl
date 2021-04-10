#
# Example custom Tcl-based simulation flow to run XSim simulation flows interactively [SIMULATION step]
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


proc simulate { {mode "gui"} } {

   ## **IMPORTANT: assume to run the flow inside WORK_DIR/sim (the WORK_DIR environment variable is exported by Makefile)
   cd ${::env(WORK_DIR)}/sim

   ## variables
   set TCL_DIR  [pwd]/../../scripts
   set LOG_DIR  [pwd]/../../log

   ## top-level RTL module (then tb_${RTL_TOP_MODULE} is the testbench)
   set RTL_TOP_MODULE ${::env(RTL_TOP_MODULE)}

   ## launch the xsim executable from Tcl

   if { ${mode} == "gui" } {

      puts "**INFO: \[TCL\] Running simulation in GUI mode\n\n"

      exec xsim tb_${RTL_TOP_MODULE} -gui \
         -onerror stop -stats -tclbatch ${TCL_DIR}/sim/run.tcl -log ${LOG_DIR}/simulate.log &

   } elseif { ${mode} == "tcl" } {

      puts "**INFO: \[TCL\] Running simulation in TCL mode\n\n"

      exec xsim tb_${RTL_TOP_MODULE} \
         -onerror stop -stats -tclbatch ${TCL_DIR}/sim/run.tcl -log ${LOG_DIR}/simulate.log >@stdout 2>@stdout

   } elseif { ${mode} == "batch" } {

      puts "**INFO: \[TCL\] Running simulation in BATCH mode\n\n"

      exec xsim tb_${RTL_TOP_MODULE} -onfinish quit \
         -onerror stop -stats -tclbatch ${TCL_DIR}/sim/run.tcl -log ${LOG_DIR}/simulate.log >@stdout 2>@stdout

   } else {

      puts "\n\n**ERROR: \[TCL\] Invalid option ${mode}. Please use mode=gui|tcl|batch when invoking make simulate."
      puts "               Force an exit.\n\n"

      ## script failure
      exit 1
   }
}


## optionally, run the Tcl procedure when the script is executed by tclsh from Makefile
if { ${argc} > 0 } {
   if { [lindex ${argv} 0] == "simulate" } {

      puts "\n**INFO: \[TCL\] Running [file normalize [info script]]"

      if { [llength ${argv}] == 2 } {

         set mode [lindex ${argv} 1]
         simulate ${mode}

      } else { 

         ## run in GUI mode otherwise
         simulate
      }
   }
}
