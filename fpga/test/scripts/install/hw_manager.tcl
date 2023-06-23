##
## Simply launch Vivado Hardware Manager from Tcl console.
##
## Luca Pacher - pacher@to.infn.it
## Spring 2020
##

## **IMPORTANT: legacy 'open_hw' command is now DEPRECATED
open_hw_manager

## if launched in Tcl mode, change default prompt
if { $rdi::mode == "tcl" } {

   set tcl_prompt1  {puts -nonewline "hw_manager% "}
}

