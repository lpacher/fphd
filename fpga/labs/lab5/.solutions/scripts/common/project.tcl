##
## Example Tcl script to create a Vivado project. Both project name and target device
## are retrieved as environment variables exported by Makefile when Vivado is invoked
## from the command line.
##
## Luca Pacher - pacher@to.infn.it
## Fall 2020
##

##
## **NOTE
##
## The resulting tree of files and directories automatically
## created by Vivado is the following :
##
## WORK_DIR/impl/${projectName}.xpr 
## WORK_DIR/impl/${projectName}.cache/
## WORK_DIR/impl/${projectName}.hw/
## WORK_DIR/impl/${projectName}.ip_user_files/
## WORK_DIR/impl/${projectName}.sim/
## WORK_DIR/impl/${projectName}.srcs/
##


## profiling
set tclStart [clock seconds]


#######################
##   Tcl variables   ##
#######################

## from the environment
set RTL_TOP_MODULE  ${::env(RTL_TOP_MODULE)}
set WORK_DIR        ${::env(WORK_DIR)}    
set XILINX_DEVICE   ${::env(XILINX_DEVICE)}     

## defaults
set rtlDir       [pwd]/rtl
set ipsDir       [pwd]/cores
set benchDir     [pwd]/bench
set xdcDir       [pwd]/xdc
set scriptsDir   [pwd]/scripts
set logDir       [pwd]/logs


#######################
##   project setup   ##
#######################

##
## **IMPORTANT !
##
## If the design uses IPs compiled targeting a specific device, the part
## has to match the project !
##

## target device
source ${scriptsDir}/common/part.tcl

## project name and directory
set projectName  ${RTL_TOP_MODULE}
set projectDir   ${WORK_DIR}/impl ; file mkdir ${projectDir}


############################
##   create new project   ##
############################

create_project -force -part ${targetFpga} ${projectName} ${projectDir} -verbose

puts "\nSuccessfully created new Vivado project ${projectName} attached to ${targetFpga} device."
puts "Project XML file is [file normalize ${WORK_DIR}/impl/${projectName}.xpr]\n\n"


###################################
##   extra settings (optional)   ##
###################################

## target HDL language
set_property target_language VHDL [current_project] ;    ## Verilog|VHDL

## target simulator
set_property target_simulator Xsim [current_project] ;   ## Xsim|ModelSim|IES|VCS

## simulator language
set_property simulator_language VHDL [current_project] ; ## Verilog|VHDL|Mixed


#############################################
##   read RTL, IPs and testbench sources   ##
#############################################

#
# **NOTE
# By default, "sources_1", "constrs_1" and "sim_1" filesets are automatically created with the project
#

#create_fileset -blockset  sources_1 ;
#create_fileset -simset    sim_1
#create_fileset -constrset constrs_1

#get_filesets
#current_fileset

##
## load RTL sources
##

## use a wildcar ...
add_files -norecurse -fileset sources_1 [concat [glob -nocomplain ${rtlDir}/*.vhd] [glob -nocomplain ${rtlDir}/*.v]]


## or specify each single file
#add_files -norecurse -fileset sources_1 {./rtl/filename1.vhd}
#add_files -norecurse -fileset sources_1 {./rtl/filename2.v}
#add_files -norecurse -fileset sources_1 {./rtl/rom.mem}     <= Vivado properly recognizes ROM memory initialization files
#


##
## load testbench sources
##
add_files -norecurse -fileset sim_1 [concat [glob -nocomplain ${benchDir}/*.vhd] [glob -nocomplain ${benchDir}/*.v]]


##
## load IP sources (simply load .xci files to use IPs in both simulation and implementation flows)
##

## examples :
#read_ip ${ipsDir}/PLL/PLL.xci
#add_files -norecurse -fileset sources_1 [glob -nocomplain ${ipsDir}/*/*.xci]
#add_files -norecurse -fileset sources_1 ${ipsDir}/ipName/ipName.xci


################################
##   read constraints (XDC)   ##
################################

add_files -norecurse -fileset constrs_1 [glob -nocomplain ${xdcDir}/*.xdc] 


###################################################
##   load and parse all files into the project   ##
###################################################

## RTL sources
puts "Loading RTL sources...\n"
import_files -force -norecurse -fileset sources_1
update_compile_order -fileset sources_1

## simulation source
puts "Loading simulation sources...\n"
import_files -force -norecurse -fileset sim_1
update_compile_order -fileset sim_1

## constraints
puts "Loading design constraints...\n"
import_files -force -norecurse -fileset constrs_1

## just for reference, by default a Vivado project is already an RTL project
set_property DESIGN_MODE RTL [current_fileset]


puts "\nProject initialization completed !\n"

## report CPU time
set tclStop [clock seconds]
set tclSeconds [expr ${tclStop} - ${tclStart} ]

puts "\nTotal elapsed-time for [file normalize [info script]]: [format "%.2f" [expr ${tclSeconds}/60.]] minutes\n"
