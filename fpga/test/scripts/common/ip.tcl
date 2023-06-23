##
## Example Tcl script to create/open a standalone IP project to compile IP cores
## using Xilinx Vivado Tcl commands.
## Optionally, if a Xilinx Core Instance (.xci) XML configuration file
## is specified at the command line the script will try to re-generate/upgrade
## all output products according to IP configuration.
##
## Ref. to "Vivado Design Suite User Guide: Designing with IP (UG896)" for
## in depth documentation about Vivado IP flows.
##
## Luca Pacher - pacher@to.infn.it
## Fall 2020
##


puts "\nINFO: \[TCL\] Running [file normalize [info script]]\n"


## profiling
set tclStart [clock seconds]

## location of IP repository
set ipsDir [pwd]/cores

## scripts directory
set scriptsDir [pwd]/scripts


#####################
##   target FPGA   ##
#####################

## load target device from dedicated script (common to all flows)
source ${scriptsDir}/common/part.tcl


#############################
##   IP repository setup   ##
#############################


##
## When you launch Vivado in GUI mode you can create a so called "IP project"
## through File > IP > New Location or load into Vivado an existing custom
## IP repository through File > IP > Open Location.
## The following statements are the Tcl-equivalent to setup a new IP repository
## or to load an existing IP repository.
##


## project name and XML file (use the same default naming convention as in the GUI flow)
set projectName managed_ip_project
set projectFile ${ipsDir}/${projectName}/${projectName}.xpr


## check if an IP project already exists
if { [file exists ${projectFile}] } {

   ## an IP project already exists, just re-open it (same as File > IP > Open Location wizard)
   open_project ${projectFile}

   ## reports IPs status
   if { [llength [get_ips]] != 0 } {
   
      puts "**INFO: IPs already in the repo: [get_ips]" ; report_ip_status
   }
   

} else {

   file mkdir ${ipsDir}

   ## create new IP project otherwise (same as File > IP > New Location wizard)
   create_project -ip -force -part ${targetXilinxDevice} ${projectName} ${ipsDir}/${projectName} -verbose

   ## simulation settings
   #set_property target_language     VHDL     [current_project]
   set_property target_language     Verilog  [current_project]
   set_property target_simulator    XSim     [current_project]
   set_property simulator_language  Mixed    [current_project]

   set_property ip_repo_paths ${ipsDir} [current_project]
   update_ip_catalog

   ## **DEBUG
   puts "**INFO: Target FPGA set to [get_parts -of_objects [current_project]]"

   ## display the IP catalog in the main window
   load_features ipintegrator

}


#####################################################################
##   optionally, synthesize IP from .xci XML configuration file    ##
#####################################################################

##
## **TOFIX
##
## This is an in-memory project. The right command would be synth_design in place of synth_ip
## to avoid warnings in the console, but synth_design doesn't generate *sim_netlist.v files
## for simulation.
##

if { [info exists ::env(XCI_FILE)]} {

   set xciFile [file normalize ${::env(XCI_FILE)}] ;  ## use file normalize to automatically get absolute path and to map \ into /

   ## the file exists, try to compile the IP
   if { [file exists ${xciFile}] } {

      ## read IP customization (XML file)
      puts "\n\nINFO \[TCL\] Loading IP configuration file ${xciFile}\n\n"

      ## check if IP is already part of the project
      if { [llength [get_files ${xciFile}]] == 1 } {

         puts "\n\n\WARNING: IP already in the repository! Recompiling IP...\n\n"

         ## reset output products
         reset_target all -verbose [get_files ${xciFile}]  
         remove_files -verbose [get_files ${xciFile}]

         ## re-load IP customization
         read_ip -verbose [get_files ${xciFile}]

         ## IP name
         set ipName [get_property IP_TOP [get_files ${xciFile}]]

         ## optionally upgrade IP to new Xilix Vivado version
         if { [get_property IS_LOCKED [get_ips ${ipName}]] } {

            upgrade_ip -verbose [get_ips ${ipName}]
         }

         ## re-generate output products
         generate_target all -force -verbose [get_files ${xciFile}]

         ## synthesize the IP to generate Out-Of Context (OOC) design checkpoint (.dcp)
         synth_ip -force [get_files ${xciFile}]
         #synth_design -top ${ipName} -part ${targetXilinxDevice} -mode out_of_context

      } else {

         ## IP not yet part of the repository, compile it from .xci
         read_ip -verbose ${xciFile}

         ## IP name
         set ipName [get_property IP_TOP [get_files ${xciFile}]]

         ## optionally upgrade IP to new Xilix Vivado version
         if { [get_property IS_LOCKED [get_ips ${ipName}]] } {

            upgrade_ip -verbose [get_ips ${ipName}]
         }

         ## generate output products
         generate_target all -force -verbose [get_files ${xciFile}] ; puts "\n\nDone !\n\n"

         ## synthesize the IP to generate Out-Of Context (OOC) design checkpoint (.dcp)
         synth_ip -force [get_files ${xciFile}]
         #synth_design -top [get_property IP_TOP [get_files ${xciFile}]] -part ${targetXilinxDevice} -mode out_of_context
      }

      puts "\n\nDone! Generated files:\n"

      ## report all the files for the IP
      foreach f [get_files -all -of_objects [get_files ${xciFile}]] { puts $f }


   ## else the specified .xci file does not exist, force an exit 
   } else {

      puts "\n\nERROR: \[TCL\] The specified XCI file ${xciFile} does not exist !"
      puts "             Please specify a valid path to an existing XCI file."
      puts "             Force an exit now.\n\n"

      ## script failure
      exit 1
   }

} else {

   ## no .xci file passed, nothing to do
}


## report CPU time
set tclStop [clock seconds]
set seconds [expr ${tclStop} - ${tclStart} ]

puts "\nTotal elapsed-time for [file normalize [info script]]: [format "%.2f" [expr $seconds/60.]] minutes\n"


##
## extra stuffs
##


## custom procedure to export all XSim simulation scripts
proc export_xsim_scripts {} {

   file mkdir ${::ipsDir}/export_scripts

   ## export XSim simulation scripts for all IPs in the current repo
   export_simulation -force -simulator xsim -directory ${::ipsDir}/export_scripts -of_objects [get_ips]
}
