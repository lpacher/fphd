##
## Improved GNU Makefile example to automate the Xilinx XSim simulation flow.
##
## Command line usage:
##
##   % make help
##   % make area
##   % make <target> [mode=gui|tcl|batch] [options]
##
## Examples:
##
##   % make compile [hdl=rtl/verilog.v]
##   % make sim
##
## Luca Pacher - pacher@to.infn.it
## Spring 2023
##


#######################################
##   preamble (reserved variables)   ##
#######################################

##
## **IMPORTANT
##
## This is a fully UNIX-compliant Makefile that can run on both Linux and Windows systems.
## On Windows, please ensure that all required Linux executables are available in the search
## path from the Command Prompt. Required executables are:
##
## make.exe bash.exe mkdir.exe echo.exe rm.exe tclsh.exe
##

## 'make' extra flags
MAKEFLAGS += --warn-undefined-variables --debug

## Bash configuration (be picky and exit immediately on any error)
SHELL := bash
.SHELLFLAGS := -e -u -o pipefail -c

## default target
.DEFAULT_GOAL := help


####################################
##   example working area setup   ##
####################################

## main "scratch" working area used to run the flows (default: work/sim for simulations, work/build for implementation)
WORK_DIR := work

## additional useful "clean" directories to store input design data
RTL_DIR := rtl
SIM_DIR := bench
TCL_DIR := scripts
DOC_DIR := doc

## put non-Tcl scripts and programs into a ./bin directory (e.g. Bash/Batch or Python scripts)
BIN_DIR := bin

## flows-specific directories
IPS_DIR := cores
XDC_DIR := xdc

## extra directories
TEMP_DIR := tmp
TEST_DIR := test
LOG_DIR  := log


##########################################
##   RTL and simulation sources setup   ##
##########################################

## specify top-level RTL (this is used for implementation and firmware installation)
RTL_TOP_MODULE := MUX2

## specify top-level testbench module (this is the target module for the xelab executable)
SIM_TOP_MODULE := tb_MUX2

##
## **NOTE
##
## The Xilinx XSim simulator allows to simulate mixed-language designs (Verilog + VHDL)
## without the need of a commercial license (the free-version of other simulators such
## as ModelSim by Mentor allows to simulate Verilog-only or VHDL-only designs instead).
##


##
## specify RTL sources by hand (more in general can be Verilog + VHDL code)
##

RTL_VHDL_SOURCES := $(RTL_DIR)/MUX2.vhd
SIM_VHDL_SOURCES := $(SIM_DIR)/tb_MUX2.vhd $(SIM_DIR)/ClockGen.vhd

## if no Verilog sources, you can either comment the below variables or just leave them empty
RTL_VLOG_SOURCES :=
SIM_VLOG_SOURCES :=


##
## or automatically find all *.(s)v and *.vhd source files
##

#
#ifneq ($(wildcard $(RTL_DIR)/*.v ),)
#   RTL_VLOG_SOURCES += $(wildcard $(RTL_DIR)/*.v )
#endif
#
#ifneq ($(wildcard $(RTL_DIR)/*.sv ),)
#   RTL_VLOG_SOURCES += $(wildcard $(RTL_DIR)/*.sv )
#endif
#
#ifneq ($(wildcard $(RTL_DIR)/*.vhd ),)
#   RTL_VHDL_SOURCES += $(wildcard $(RTL_DIR)/*.vhd )
#endif
#
#ifneq ($(wildcard $(SIM_DIR)/*.v ),)
#   SIM_VLOG_SOURCES += $(wildcard $(SIM_DIR)/*.v )
#endif
#
#ifneq ($(wildcard $(SIM_DIR)/*.sv ),)
#   SIM_VLOG_SOURCES += $(wildcard $(SIM_DIR)/*.sv )
#endif
#
#ifneq ($(wildcard $(SIM_DIR)/*.vhd ),)
#   SIM_VHDL_SOURCES += $(wildcard $(SIM_DIR)/*.vhd )
#endif
#


## group together all Verilog/SystemVerilog and VHDL sources
VLOG_SOURCES := $(RTL_VLOG_SOURCES) $(SIM_VLOG_SOURCES)
VHDL_SOURCES := $(RTL_VHDL_SOURCES) $(SIM_VHDL_SOURCES)


##########################
##   IP sources setup   ##
##########################

##
## **IMPORTANT
##
## When you compile Xilinx IP cores both Verilog and VHDL gate-level netlists are automatically
## generated for each core. In the following we will always assume to simulate IPs using Verilog
## netlists
##

## as for HDL sources, specify IP netlists by hand or automatically search for all *netlist.v sources
# IPS_SOURCES := $(IPS_DIR)/PLL/PLL_netlist.v

#
#ifneq ($(wildcard $(IPS_DIR)/*/*netlist.v ),)
#   IPS_SOURCES += $(wildcard $(IPS_DIR)/*/*netlist.v )
#endif
#


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

##
## **NOTE
##
## There is no Windows equivalent for the Linux & operator to fork in background the execution of a program
## invoked at the command line. Most of Windows programs launched from the Command Prompt by default already 
## start in background leaving the shell alive. Unfortunately this is not the case for the vivado executable. 
## In order to have portable flows between Linux and Windows the proposed solution is to forward the execution
## of 'vivado -mode gui' to tclsh using the Tcl command 'exec' which accepts the usage of the & instead.
##

## by default, run Vivado/XSim flows in GUI mode
mode ?= gui
#mode ?= tcl
#mode ?= batch


##############################################
##   export variables to tclsh and Vivado   ##
##############################################

##
## **NOTE
##
## Use the strip function to avoid interpreting whitespace as a non-empty values
## in case the design uses only one HDL language. 
##

## export the chosen working directory to all flows
export WORK_DIR

## export HDL variables to xvlog/xvhdl/xelab flows
export RTL_TOP_MODULE
export SIM_TOP_MODULE

ifneq ($(strip $(VLOG_SOURCES)),)
   export VLOG_SOURCES
endif

ifneq ($(strip $(VHDL_SOURCES)),)
   export VHDL_SOURCES
endif

ifneq ($(strip $(IPS_SOURCES)),)
   export IPS_SOURCES
endif


################################
##   targets implementation   ##
################################

##
## **NOTE
##
## Only for reference. In order to shorten the main Makefile you can also decide to move
## the implementation of all targets into flow-specific sub-makefiles and then include them
## in this Makefile.
##
## Example:
##
## include scripts/sim/Makefile.defs
## include scripts/builds/Makefile.defs etc.
##


##
## **IMPORTANT
##
## None of implemented targets are on-disk files with build dependencies!
## Declare each target as PHONY.
##


## default target (if nothing is passed to 'make' just call the 'help' target)
.PHONY : default
default : help


##
## Main help target (automatically generate Makefile documentation).
## Credits: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
##

.PHONY : help
help : ## Command line help

	@$(ECHO) ""
	@$(ECHO) "Usage: make <target> [mode=gui|tcl|batch] [variables]"
	@$(ECHO) ""
	@$(ECHO) "Available targets:"
	@$(ECHO) ""
	@grep -E '^[a-zA-Z_-]+ :.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "- make \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@$(ECHO) ""
	@$(ECHO) "Examples:"
	@$(ECHO) ""
	@$(ECHO) "   % make compile [hdl=/path/to/verilog.v|hdl=/path/to/vhdl.vhd]"
	@$(ECHO) "   % make sim"
	@$(ECHO) ""
##____________________________________________________________________________________________________


##
## working area setup
##

.PHONY : area
area : ## Create a new fresh working area with all necessary directories used in the flows

	@$(MKDIR) $(RTL_DIR)
	@$(MKDIR) $(SIM_DIR)
	@$(MKDIR) $(TCL_DIR)/common
	@$(MKDIR) $(TCL_DIR)/sim
	@$(MKDIR) $(TCL_DIR)/build
	@$(MKDIR) $(TCL_DIR)/install
	@$(MKDIR) $(TCL_DIR)/debug

	@$(MKDIR) $(BIN_DIR)

	@$(MKDIR) $(LOG_DIR)
	@$(MKDIR) $(DOC_DIR)
	@$(MKDIR) $(IPS_DIR)
	@$(MKDIR) $(XDC_DIR)

	@$(MKDIR) $(WORK_DIR)/sim
	@$(MKDIR) $(WORK_DIR)/build

	@$(MKDIR) $(TEMP_DIR)
	@$(MKDIR) $(TEST_DIR)

	@$(ECHO) "\n   -- Working area setup completed !\n\n"
##____________________________________________________________________________________________________


##
## simulation targets
##

## empty variable to optionally specify a single Verilog/SystemVerilog or VHDL file to be compiled
hdl :=

ifneq ($(hdl),)
   export HDL_FILE=$(hdl)
endif

.PHONY : compile
compile : $(TCL_DIR)/sim/compile.tcl ## Parse and compile RTL and simulation sources

ifeq ($(wildcard $(WORK_DIR)/sim/.*),)
	@$(error ERROR: Missing simulation working area $(WORK_DIR)/sim ! Run 'make area' before running the flows.)
else
	@tclsh $(TCL_DIR)/sim/compile.tcl $@
endif
##____________________________________________________________________________________________________


.PHONY : elaborate
elaborate : $(TCL_DIR)/sim/elaborate.tcl ## Elaborate the design

	@tclsh $(TCL_DIR)/sim/elaborate.tcl $@
##____________________________________________________________________________________________________


.PHONY : simulate
simulate : $(TCL_DIR)/sim/simulate.tcl $(WORK_DIR)/sim/xsim.dir ## Run simulation executable

	@tclsh $(TCL_DIR)/sim/simulate.tcl $@ $(mode)
##____________________________________________________________________________________________________


.PHONY : sim
sim : compile elaborate simulate ## One-step compilation, elaboration and simulation (same as 'make compile elaborate simulate')
##____________________________________________________________________________________________________


##
## Cleanup targets
##

.PHONY : clean_log
clean_log : ## Delete log files and journal files

	@$(RM) *.log *.jou
	@$(RM) $(LOG_DIR)/*
##____________________________________________________________________________________________________


.PHONY : clean_sim
clean_sim : ## Delete ALL files from work/sim

	@$(RMDIR) $(WORK_DIR)/sim/*
##____________________________________________________________________________________________________


.PHONY : clean_all
clean_all : clean_log clean_sim ## Delete ALL temporary and garbage files

	@$(RM) *.pb *.wdb *.log *.jou
	@$(RMDIR) xsim.dir
	@$(RMDIR) .Xil
##____________________________________________________________________________________________________


.PHONY : clean
clean : clean_all ## Alias, same as 'make clean_all'
##____________________________________________________________________________________________________

