#
# Custom Tcl procedure to relaunch the simulation after sources changes   ##
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

proc relaunch {} {

   ## save current waveforms setup

   set fp [open "tmp.txt" "w"]
   puts $fp [current_wave_config] ; close $fp

   set fp [open "tmp.txt" "r"]
   set wcfgName [read $fp] ; close $fp

   if { ${wcfgName} != "" } {

      save_wave_config -verbose ${wcfgName}
   }

   ## unload the current simulation snapshot without exiting XSim
   close_sim -force -quiet

   ## ensure to start from scratch
   catch {exec rm -rf xsim.dir .Xil [glob -nocomplain *.pb] [glob -nocomplain *.wdb] }


   ## load custom Tcl procedures for compilation/elaboration
   source -notrace -quiet [pwd]/../../scripts/sim/compile.tcl 
   source -notrace -quiet [pwd]/../../scripts/sim/elaborate.tcl

   ## try to re-compile sources (compile returns 0 if OK)
   if { [compile] } {

      ## compilation errors exist, display the log file in the XSim Tcl console
      exec cat [pwd]/../../log/compile.log

   } else {

      ## re-compilation OK, try to re-elaborate the design
      if { [elaborate] } {

         ## elaboration errors exist, display the log file in the XSim Tcl console
         exec cat [pwd]/../../log/elaborate.log

      } else {

   
         ## re-elaboratin OK, reload the simulation snapshot
         xsim tb_${::env(RTL_TOP_MODULE)}

         ## **TODO: restore previous WCFG if available
         if { ${wcfgName} != {} } {

            #open_wave_config ${wcfgName}.wcfg
         }

         ## re-run the simulation
         #source -notrace [pwd]/../../scripts/sim/run.tcl

      } ;   # if/else [elaborate]
   } ;   # if/else [compile]

} ;   # proc relaunch
