##
## Example Xilinx Design Constraints (XDC) file for Counter test design.
## All pin positions and electrical properties refer to the Digilent
## Arty-A7 development board.
##
## The complete .xdc for the board can be downloaded from the
## official Digilent GitHub repository at:
##
##    https://github.com/Digilent/Arty/blob/master/Resources/XDC/Arty_Master.xdc
##
## To find actual physical locations of pins on the board, please check
## board reference schematics:
##
##    https://reference.digilentinc.com/_media/arty:arty_sch.pdf
##
##
## Luca Pacher - pacher@to.infn.it
## Fall 2020
##


###############
##   units   ##
###############

## just for reference, these are already default units
set_units -time          ns
set_units -voltage       V
set_units -power         mW
set_units -capacitance   pF


#############################################
##   physical constraints (port mapping)   ##
#############################################

## on-board 100 MHz clock signal
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk]

## reset
set_property -dict { PACKAGE_PIN D9   IOSTANDARD LVCMOS33 } [get_ports reset] ;   ## BTN0


## count-enable
set_property -dict { PACKAGE_PIN A8   IOSTANDARD LVCMOS33 } [get_ports enable] ;   ## SW0

## 4x GP LED (standard LEDs)
set_property -dict { PACKAGE_PIN H5  IOSTANDARD LVCMOS33 } [get_ports { LED[0] }] ;   ## LD4
set_property -dict { PACKAGE_PIN J5  IOSTANDARD LVCMOS33 } [get_ports { LED[1] }] ;   ## LD5
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports { LED[2] }] ;   ## LD6
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { LED[3] }] ;   ## LD7


################################
##   electrical constraints   ##
################################

## voltage configurations
set_property CFGBVS VCCO        [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]


############################
##   timing constraints   ##
############################

## create a 100 MHz clock signal with 50% duty cycle for reg2reg Static Timing Analysis (STA)
create_clock -period 10.000 -name clk100 -waveform {0.000 5.000} -add [get_ports clk]

