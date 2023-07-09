##
## Use this script to define target Xilinx device and external Quad SPI Flash memory 
## as global Tcl variables common to all flows.
##
## Example device IDs for popular boards are:
##
## - ARTYA7  - Digilent Arty A7 Development board : xc7a35ticsg324-1L
## - ARTYZ7  - Digilent Arty Z7 Development board : xc7z020clg400-1
## - KC705   - Xilinx Kintex7 Evaluation Board    : xc7k325tffg900-2
##
## Luca Pacher - pacher@to.infn.it
## Fall 2020
##


############################
##   target Xilinx FPGA   ##
############################

global targetXilinxDevice

## check if XILINX_DEVICE environment variable has been exported from Makefile
if { [info exists ::env(XILINX_DEVICE)] } {

   set targetXilinxDevice ${::env(XILINX_DEVICE)}

} else {

   ## default: Digilent Arty A7 development board
   set targetXilinxDevice xc7a35ticsg324-1L
}


################################
##   target external memory   ##
################################

global targetQuadSpiFlash

## check if QFLASH_MEMORY environment variable has been exported from Makefile
if { [info exists ::env(QFLASH_MEMORY)] } {

   set targetQuadSpiFlash ${::env(QFLASH_MEMORY)}

} else {

   ## default: Micron 128 MB Quad SPI Flash (Arty/Z7, KC705)
   set targetQuadSpiFlash mt25ql128-spi-x1_x2_x4
   #set targetQuadSpiFlash n25q128-3.3v-spi-x1_x2_x4 ;   ## **WARN: should be the same as "mt25ql128-spi-x1_x2_x4" (alias), but this string gives programming errors
}

## **DEBUG
puts "INFO: Target Xilinx device: ${targetXilinxDevice}"
puts "INFO: Target external Quad SPI Flash memory: ${targetQuadSpiFlash}\n"

