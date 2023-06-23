##
## Custom Tcl procedure to interactively relaunch the simulation from the XSim
## graphical interface after modifications to HDL sources.
##
## Luca Pacher - pacher@to.infn.it
## Fall 2020
##


##
## load custom Tcl procedures for compilation/elaboration (just once)
##
if { [info procs compile] eq "" } {

   source -notrace -quiet [pwd]/../../scripts/sim/compile.tcl 
}

if { [info procs elaborate] eq "" } {

   source -notrace -quiet [pwd]/../../scripts/sim/elaborate.tcl
}


##
## custom 'relaunch' procedure implementation
##
proc relaunch {} {


   #############################################################################
   ##   save ALL current Waveform Configurations for later restore (if any)   ##
   #############################################################################

   set tempDir wcfg.tmp ; exec mkdir -p ${tempDir}

   if { [llength [get_wave_configs]] != 0 } {

      foreach waveConfig [get_wave_configs] {

         ## save Waveform Configuration to XML file
         save_wave_config -object ${waveConfig} ${tempDir}/${waveConfig}

         ## close Waveform configuration
         close_wave_config -force ${waveConfig}
      }
   }


   #####################################################################
   ##   unload the current simulation snapshot without exiting XSim   ##
   #####################################################################

   close_sim -force -quiet 

   ## ensure to start from scratch
   catch {exec rm -rf xsim.dir .Xil [glob -nocomplain *.pb] [glob -nocomplain *.wdb] }


   ##############################################
   ##   re-run compilation/elaboration flows   ##
   ##############################################

   ## **REMIND: here we are in work/sim but all Makefile flows assume to start from the top directory!
   cd [pwd]/../../

   ## try to re-compile sources (compile returns 0 if OK)
   if { [compile] } {

      ## compilation errors exist, display the log file in the XSim Tcl console
      exec grep ERROR [pwd]/../../log/compile.log

   } else {

      cd [pwd]/../../

      ## re-compilation OK, try to re-elaborate the design
      if { [elaborate] } {

         ## elaboration errors exist, display the log file in the XSim Tcl console
         exec grep ERROR [pwd]/../../log/elaborate.log

      } else {
 
         ## re-elaboratin OK, reload the simulation snapshot
         xsim ${::env(SIM_TOP_MODULE)}

         ## restore also old Waveform Configuration files
         if { [llength [glob -nocomplain ${tempDir}/* ]] != 0 } {

            foreach oldWaveConfig [glob -nocomplain ${tempDir}/* ] {

               open_wave_config ${oldWaveConfig}
            }

            ## everything OK, delete WCFG temporary directory (otherwise keep it in case of errors)
            exec rm -rf ${tempDir}
         }

         ## optionally, re-run the simulation
         #run all

      } ;   # if/else [elaborate]
   } ;   # if/else [compile]


} ;   # proc relaunch

