#
# Extended Makefile to automate simulation and implementation flows using Xilinx Vivado.
#
# Luca Pacher - pacher@to.infn.it
# Fall 2020
#

#######################################
##   preamble (reserved variables)   ##
#######################################

#
# **IMPORTANT
#
# This is a fully UNIX-compliant Makefile that can run on both Linux and Windows systems.
# On Windows, please ensure that all required Linux executables are available in the search
# path from the Command Prompt. Required executables are :
#
# make.exe bash.exe mkdir.exe echo.exe rm.exe tclsh.exe
#


## 'make' extra flags
MAKEFLAGS += --warn-undefined-variables --debug

## Bash configuration (be picky and exit immediately on any error)
SHELL := bash
.SHELLFLAGS := -e -u -o pipefail -c


################################################
##   target FPGA device and external memory   ##
################################################

## default: Digilent Arty-7 development board
part  := xc7a35ticsg324-1L
flash := n25q128-3.3v-spi-x1_x2_x4  

## export the ID of the target device to all flows
export XILINX_DEVICE=$(part)


##############################
##   top-level RTL module   ##
##############################

#
# **NOTE
#
# By default all rtl/*.vhd and bench/*.vhd sources are parsed and compiled using xvhdl,
# then tb_$(dut) is considered as testbench module when xelab is invoked for elaboration.
#
dut := Counter


## export the name of the top-level module as an environment variable to be used from tclsh
export RTL_TOP_MODULE=$(dut)


############################
##   working area setup   ##
############################

## main "scratch" working area used to run the flows (default: work/sim for simulations, work/impl for implementation)
WORK_DIR := work

## export the chosen working directory to all flows
export WORK_DIR

## additional useful "clean" directories to store input design data
RTL_DIR := rtl
SIM_DIR := bench
TCL_DIR := scripts
LOG_DIR := log
DOC_DIR := doc

## put non-Tcl scripts and programs into a ./bin directory (e.g. Python scripts)
BIN_DIR := bin

## flows-specific directories
IPS_DIR := cores
XDC_DIR := xdc

## extra directories
TEMP_DIR := tmp
TEST_DIR := test


#########################
##   other variables   ##
#########################

## some useful UNIX aliases
ECHO  := echo -e
RM    := rm -f -v
RMDIR := rm -rf -v
MKDIR := mkdir -p -v


################################
##   Xilinx Vivado settings   ##
################################

## by default, run Vivado/XSim in GUI mode
mode ?= gui
#mode ?= tcl
#mode ?= batch


################################
##   targets implementation   ##
################################

#
# **NOTE: None of implemented targets are on-disk files with build dependencies, declare each target as PHONY
#

## default target
.PHONY : default
default : help


## creates a new fresh working area with all necessary directories used in the flows
.PHONY : area
area :

	@$(MKDIR) $(RTL_DIR)
	@$(MKDIR) $(SIM_DIR)
	@$(MKDIR) $(TCL_DIR)/common
	@$(MKDIR) $(TCL_DIR)/simulation
	@$(MKDIR) $(TCL_DIR)/implementation
	@$(MKDIR) $(TCL_DIR)/programming
	@$(MKDIR) $(TCL_DIR)/debug

	@$(MKDIR) $(BIN_DIR)

	@$(MKDIR) $(LOG_DIR)
	@$(MKDIR) $(DOC_DIR)
	@$(MKDIR) $(IPS_DIR)
	@$(MKDIR) $(XDC_DIR)

	@$(MKDIR) $(WORK_DIR)/sim
	@$(MKDIR) $(WORK_DIR)/impl

	@$(MKDIR) $(TEMP_DIR)
	@$(MKDIR) $(TEST_DIR)

	@$(ECHO) "\n   -- Working area setup completed !\n\n"
##_______________________________________________________________________________________


## parse and compile all RTL and simulation sources
.PHONY : compile
compile : $(TCL_DIR)/simulation/compile.tcl

ifeq ($(wildcard $(WORK_DIR)/sim/.*),)
	@$(error ERROR: Missing simulation working area $(WORK_DIR)/sim ! Run 'make area' before running the flows.)
else
	@tclsh $(TCL_DIR)/simulation/compile.tcl $@
endif
##_______________________________________________________________________________________


## elaborate the design
.PHONY : elaborate
elaborate : $(TCL_DIR)/simulation/elaborate.tcl

	@tclsh $(TCL_DIR)/simulation/elaborate.tcl $@
##_______________________________________________________________________________________


## run simulation executable
.PHONY : simulate
simulate : $(TCL_DIR)/simulation/simulate.tcl $(WORK_DIR)/sim/xsim.dir

	@tclsh $(TCL_DIR)/simulation/simulate.tcl $@ $(mode)
##_______________________________________________________________________________________


## one-step compilation, elaboration and simulation (same as 'make compile elaborate simulate')
.PHONY : sim
sim : compile elaborate simulate
##_______________________________________________________________________________________


## create fresh Vivado project attached to Arty7 device
.PHONY : project
project : $(TCL_DIR)/common/init.tcl $(TCL_DIR)/common/project.tcl

ifeq ($(wildcard $(WORK_DIR)/impl/.*),)
	@$(error ERROR: Missing implementation working area $(WORK_DIR)/impl ! Run 'make area' before running the flows.)
else
   ifeq ($(mode),gui)
	@echo "exec vivado -mode gui \
	   -source $(TCL_DIR)/common/init.tcl -source $(TCL_DIR)/common/project.tcl \
	   -log $(LOG_DIR)/$@.log -nojournal -verbose -notrace &" | tclsh
   else
	@vivado -mode $(mode) \
	   -source $(TCL_DIR)/common/init.tcl -source $(TCL_DIR)/common/project.tcl \
	   -log $(LOG_DIR)/$@.log -nojournal -verbose -notrace
   endif
endif
##_______________________________________________________________________________________


## restore Vivado project from XML project file (.xpr) or design checkpoint (.dcp)
.PHONY : restore
restore :

ifeq ($(mode),gui)
	@echo "exec vivado -mode gui \
	   -source $(TCL_DIR)/common/init.tcl -log $(LOG_DIR)/$@.log -nojournal -verbose -notrace $(db) &" | tclsh
else
	@vivado -mode $(mode) \
	   -source $(TCL_DIR)/common/init.tcl -log $(LOG_DIR)/$@.log -nojournal -verbose -notrace $(db)
endif
##_______________________________________________________________________________________


## launch IP flow in GUI mode

#
# empty variable to store Xilinx Core Instance (.xci) configuration file
#
xci :=

.PHONY : ip
ip : $(TCL_DIR)/common/init.tcl $(TCL_DIR)/common/ip.tcl

ifeq ($(wildcard $(IPS_DIR)/.*),)
	@$(error ERROR: Missing IPs directory ! Run 'make area' before running the flows.)
else
ifeq ($(mode),gui)
	@echo "exec vivado -mode gui \
	   -source $(TCL_DIR)/common/init.tcl -source $(TCL_DIR)/common/ip.tcl \
	   -notrace -log $(LOG_DIR)/$@.log -nojournal -tclargs $(xci) &" | tclsh
else
	@vivado -mode $(mode) \
	   -source $(TCL_DIR)/common/init.tcl -source $(TCL_DIR)/common/ip.tcl \
	   -notrace -log $(LOG_DIR)/$@.log -nojournal -tclargs $(xci)
endif
endif
##_______________________________________________________________________________________


## run Vivado FPGA implementation flow in non-project mode
.PHONY : xflow
xflow : $(TCL_DIR)/common/init.tcl $(TCL_DIR)/implementation/xflow.tcl
 
ifeq ($(wildcard $(WORK_DIR)/impl/.*),)
	@$(error ERROR: Missing implementation working area $(WORK_DIR)/impl ! Run 'make area' before running the flows.)
else
   ifeq ($(mode),gui)
	@echo "exec vivado -mode gui \
	   -source $(TCL_DIR)/common/init.tcl -source $(TCL_DIR)/implementation/xflow.tcl \
	   -log $(LOG_DIR)/$@.log -nojournal -verbose -notrace &" | tclsh
   else
	@vivado -mode $(mode) \
	   -source $(TCL_DIR)/common/init.tcl -source $(TCL_DIR)/implementation/xflow.tcl \
	   -log $(LOG_DIR)/$@.log -nojournal -verbose -notrace
   endif
endif
##_______________________________________________________________________________________


## alias, same as 'make xflow'
.PHONY : build
build : xflow
##_______________________________________________________________________________________


## launch Vivado GUI and open the Hardware Manager
.PHONY :
hm : $(TCL_DIR)/common/init.tcl $(TCL_DIR)/common/hm.tcl

	@echo "exec vivado -mode gui \
	   -source $(TCL_DIR)/common/init.tcl -source $(TCL_DIR)/common/hm.tcl \
	   -notrace -log $(LOG_DIR)/$@.log -nojournal &" | tclsh
##_______________________________________________________________________________________


## upload bitstream to target FPGA using Hardware Manager

#
# empty variables to store program file (.bit) and optionally ILA probes file (.ltx)
#
bit :=
ltx :=

.PHONY : install/fpga
install/fpga : $(TCL_DIR)/common/init.tcl $(TCL_DIR)/programming/upload.tcl

ifeq ($(mode),gui)

	@echo "exec vivado -mode gui \
	   -source $(TCL_DIR)/common/init.tcl -source $(TCL_DIR)/programming/upload.tcl \
	   -notrace -log $(LOG_DIR)/$@.log -nojournal -tclargs $(bit) $(ltx) &" | tclsh
else
	@vivado -mode $(mode) \
	   -source $(TCL_DIR)/common/init.tcl -source $(TCL_DIR)/programming/upload.tcl \
	   -notrace -log $(LOG_DIR)/$@.log -nojournal -tclargs $(bit) $(ltx)
endif
##_______________________________________________________________________________________


.PHONY : install/flash
install/flash : $(TCL_DIR)/common/init.tcl $(TCL_DIR)/programming/flash.tcl

ifeq ($(mode),gui)

	@echo "exec vivado -mode gui \
	   -source $(TCL_DIR)/common/init.tcl -source $(TCL_DIR)/programming/flash.tcl \
	   -notrace -log $(LOG_DIR)/$@.log -nojournal -tclargs $(bit) $(ltx) &" | tclsh
else
	@vivado -mode $(mode) \
	   -source $(TCL_DIR)/common/init.tcl -source $(TCL_DIR)/programming/flash.tcl \
	   -notrace -log $(LOG_DIR)/$@.log -nojournal -tclargs $(bit) $(ltx)
endif
##_______________________________________________________________________________________


## delete all log files and temporary files
.PHONY : clean/log clean/sim clean/impl clean

clean/log :

	@$(RM) *.log *.jou $(LOG_DIR)/*

clean/sim :

	@$(RM) *.pb *.wdb
	@$(RMDIR) xsim.dir
	@$(RMDIR) $(WORK_DIR)/sim/*	

clean/impl :

	@$(RMDIR) $(WORK_DIR)/impl/*	

clean/all : clean/log clean/sim clean/impl

	@$(RM) *.log *.jou $(LOG_DIR)/*
	@$(RMDIR) .Xil
	@$(RMDIR) $(WORK_DIR)/sim/*
	@$(RMDIR) $(WORK_DIR)/impl/*

clean : clean/all
##_______________________________________________________________________________________


## command line help
.PHONY : help
help :

	@$(ECHO) "\n\nUsage: make <target> [dut=ModuleName] [part=device] [mode=gui|tcl|batch] [db=/path/to/project.xpr | db=/path/to/project.dcp]"
	@$(ECHO) ""
	@$(ECHO) "Defaults :\n"
	@$(ECHO) " - top-level RTL module :  $(dut)"
	@$(ECHO) " - target device :         $(part)"
	@$(ECHO) " - external memory :       $(flash)\n\n"

	@$(ECHO) "Setup targets:"
	@$(ECHO) ""
	@$(ECHO) " - make help            Command-line help"
	@$(ECHO) " - make area            Creates new fresh working area\n"

	@$(ECHO) "Simulation targets:"
	@$(ECHO) ""
	@$(ECHO) " - make compile         Parse and compile Verilog sources"
	@$(ECHO) " - make elaborate       Elaborate design"
	@$(ECHO) " - make simulate        Run simulation executable"
	@$(ECHO) " - make sim             Alias, one step compilation, elaboration and simulation\n"

	@$(ECHO) "Implementation targets:"
	@$(ECHO) ""
	@$(ECHO) " - make project         Creates new fresh project attached to Xilinx device (default: xc7a35ticsg324-1L)"
	@$(ECHO) " - make restore         Restore Vivado project from XML project file (.xpr) or design checkpoint (.dcp)"
	@$(ECHO) " - make ip              Customize and compile IP cores for your design"
	@$(ECHO) " - make xflow           Run Vivado FPGA implementation flow in non-project mode"
	@$(ECHO) " - make build           Alias, same as make xflow"
	@$(ECHO) " - make hm              Launch Vivado in GUI mode and open the Hardware Manager\n"

	@$(ECHO) "Programming targets:"
	@$(ECHO) ""
	@$(ECHO) " - make install/fpga    Upload bitsream to target FPGA using Hardware Manager"
	@$(ECHO) " - make install/flash   Upload bitsream to external memory using Hardware Manager\n"

	@$(ECHO) "Cleanup targets:"
	@$(ECHO) ""
	@$(ECHO) " - make clean/log   Delete all log and journal files"
	@$(ECHO) " - make clean/sim   Delete everything from $(WORK_DIR)/sim"
	@$(ECHO) " - make clean/impl  Delete everything from $(WORK_DIR)/impl"
	@$(ECHO) " - make clean/all   Delete all log files and temporary files"
	@$(ECHO) " - make clean       Alias, same as make clean/all\n"
##_______________________________________________________________________________________

