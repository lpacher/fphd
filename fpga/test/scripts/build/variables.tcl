##
## Collect here all Tcl variables and preferences specific to the implementation flow.
##
## Luca Pacher - pacher@to.infn.it
## Fall 2020
##


##
## implementation working directory (assume to place output results and reports into work/build)
##

global workDir

if { [info exists ::env(WORK_DIR)] } {

   set workDir ${::env(WORK_DIR)}/build

} else {

   puts "**WARN \[TCL\]: WORK_DIR environment variable not defined, assuming ./work/build to run implementation flows."

   set workDir [pwd]/work/build

}

if { ![file exists ${workDir}] } {

   file mkdir ${workDir}
}


#############################
##   reports directories   ##
#############################

global reportsDir ; set reportsDir ${workDir}/reports

if { ![file exists ${reportsDir}] } {

   file mkdir ${reportsDir}
}


###########################
##   outputs directory   ##
###########################

global outputsDir ; set outputsDir ${workDir}/outputs

if { ![file exists ${outputsDir}] } {

   file mkdir ${outputsDir}
}

