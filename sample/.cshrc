##
## Sample ~/.cshrc configuration script for csh/tcsh Linux shells
## to set the proper Xilinx Vivado runtime environment and to
## improve the command line usage. Use this template as a
## reference to customize the default ~/.cshrc script already
## placed in your home directory.
##
## Luca Pacher - pacher@to.infn.it
## Spring 2019
##


## print on the screen that the file is sourced (debug feature)
echo -e "\nLoading $HOME/.cshrc\n"


#############################
##   Xilinx Vivado setup   ##
#############################

## variable to locate the main Xilinx Vivado installation directory (by default /opt/Xilinx)
# setenv XILINX_DIR /opt/Xilinx

## add Vivado executables to system search path
# source $XILINX_DIR/Vivado/<version>/settings64.csh

## if required you can also use the XILINXD_LICENSE_FILE environment variable to locate
## a licence file for Xilinx Vivado
# setenv XILINXD_LICENSE_FILE /opt/Xilinx/Xilinx.lic


#####################
##   search path   ##
#####################

## update the system search path to find additional program executables and scripts
# set path = ( /path/to/directory /path/to/another/directory $path )


#############################
##   user customizations   ##
#############################

## a few common useful aliases for the 'ls' command
alias l   "ls -l"
alias ll  "ls -la"

## change the prompt string as preferred
#set prompt="% "
set prompt="tcsh$ "

## redefine the 'cd' command in order to print the destination directory once done
alias cd "cd \!* ; echo $PWD"

## add here additional user customizations

