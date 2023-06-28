##
## A first Makefile example to automate the Xilinx XSim simulation flow.
##
## Luca Pacher - pacher@to.infn.it
## Spring 2023
##

## list of Verilog sources to be compiled
SOURCES := Gates.vhd tb_Gates.vhd


## top-level module (testbench)
TOP := tb_Gates


## some useful aliases
RM    := rm -f -v
RMDIR := rm -rf -v


## compile Verilog sources (xvlog)
compile : $(SOURCES)
	@xvlog $(SOURCES) -log $@.log


## elaborate the design (xelab)
elaborate :
	@xelab -debug all $(TOP) -log $@.log


## run the simulation (xsim)
simulate :
	@echo "exec xsim -gui -tclbatch run.tcl $(TOP) -log $@.log &" | tclsh -norc


## one-step compilation/elaboration/simulation
sim : compile elaborate simulate


## delete all log files and simulation outputs
clean :
	@$(RM) *.log *.jou *.pb *.wdb *.wcfg
	@$(RMDIR) xsim.dir .Xil

