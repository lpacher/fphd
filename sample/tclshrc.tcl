##
## Sample tclsh init script for MS Windows operating systems.
##
## Copy this file in your main %USERPROFILE% home directory
## (usually C:\Users\<username>) and use it to customize the
## tclsh interactive runtime environment.
##
## Be aware that this file is automatically executed ONLY
## if tclsh is invoked in interactive mode.
##
## The tclshrc init file is NOT automatically executed when
## tclsh is invoked in non-interactive mode as:
##
##   % tclsh script.tcl
##
##
## If you don't want customizations added to tclsh use the
## custom '-norc' option implemented in this script:
##
##   % tclsh -norc
##
## Luca Pacher - pacher@to.infn.it
## Spring 2019
##


##
## custom procedure to collect all initialization statements
##

proc tclsh_init {} {

   ## Tcl version and loading notification
   puts "Tcl version ${::tcl_version}"

   #puts "\nLoading [file normalize [info script]]\n"
   puts "\nLoading [info script]\n"

   ## change default prompt
   global tcl_prompt1
   set tcl_prompt1 {puts -nonewline "tclsh$ "}

   ## add here additional customizations

}


##
## parse command-line options using the native library package cmdline
## (if -norc is passed to tclsh skip executing tclsh_init)
##

package require cmdline


## available command-line switches
set options {

   {norc "Skip loading init file" }
}


array set opts [::cmdline::getoptions argv $options]


if { $opts(norc) } {

   ## "tclsh -norc" invoked, nothing to do ...

} else {

   ## load customizations otherwise (default)
   tclsh_init
}

