##
## Implementation constraints for the Gates.v Verilog example.
## All pin positions and electrical properties refer to the
## Digilent Arty-A7 development board.
##
## The complete .xdc for the board can be downloaded from the
## official Digilent GitHub repository at :
## 
##    https://github.com/Digilent/Arty/blob/master/Resources/XDC/Arty_Master.xdc
##
## To find actual physical locations of pins on the board, please check
## board reference schematics :
##
##    https://reference.digilentinc.com/_media/arty:arty_sch.pdf
##
## Luca Pacher - pacher@to.infn.it
## Fall 2020
##


###############
##   units   ##
###############

## just for reference, these are already default units
#set_units -time          ns
#set_units -voltage       V
#set_units -power         mW
#set_units -capacitance   pF


#############################################
##   physical constraints (port mapping)   ##
#############################################

## slide switches
set_property -dict { PACKAGE_PIN A8   IOSTANDARD LVCMOS33 } [get_ports A] ;   ## SW0
set_property -dict { PACKAGE_PIN C11  IOSTANDARD LVCMOS33 } [get_ports B] ;   ## SW1

## standard LEDs
set_property -dict { PACKAGE_PIN H5  IOSTANDARD LVCMOS33 } [get_ports { Z[0] }] ;   ## LD4
set_property -dict { PACKAGE_PIN J5  IOSTANDARD LVCMOS33 } [get_ports { Z[1] }] ;   ## LD5 
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports { Z[2] }] ;   ## LD6
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { Z[3] }] ;   ## LD7

## RGB LEDs
set_property -dict { PACKAGE_PIN G6  IOSTANDARD LVCMOS33 } [get_ports { Z[4] }]; ## LD0_r
set_property -dict { PACKAGE_PIN G3  IOSTANDARD LVCMOS33 } [get_ports { Z[5] }]; ## LD1_r


################################
##   electrical constraints   ##
################################

## voltage configurations
set_property CFGBVS VCCO        [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]


##
## **WARNING
##
## The load capacitance is used during power analysis when running the report_power
## command, but it's not used during timing analysis
##
set_load 10 [all_outputs] -verbose



############################
##   timing constraints   ##
############################

## this is a pure combinational block, only constrain a maximum delay of 10 ns between input and output ports
#set_max_delay 10 -from [all_inputs] -to [all_outputs] -verbose

## alternatively, disable timing checks from all inputs to all outputs
set_false_path -from [all_inputs] -to [all_outputs]

