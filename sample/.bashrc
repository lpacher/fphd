##
## Sample ~/.bashrc configuration script for the Bash Linux shell
## to set the proper Xilinx Vivado runtime environment and to
## improve the command line usage. Use this template as a
## reference to customize the default ~/.bashrc script already
## placed in your home directory.
##
## Luca Pacher - pacher@to.infn.it
## Spring 2019
##


## print on the screen that the file is sourced (debug feature)
echo -e "\nLoading $HOME/.bashrc\n"


#############################
##   Xilinx Vivado setup   ##
#############################

## variable to locate the main Xilinx Vivado installation directory (by default /opt/Xilinx)
# export XILINX_DIR=/opt/Xilinx

## add Vivado executables to system search path
# source $XILINX_DIR/Vivado/<version>/settings64.sh

## if required you can also use the XILINXD_LICENSE_FILE environment variable to locate
## a licence file for Xilinx Vivado
# export XILINXD_LICENSE_FILE=/opt/Xilinx/Xilinx.lic


#####################
##   search path   ##
#####################

## update the system search path to find additional program executables and scripts
# export PATH=/path/to/directory:/path/to/another/directory:$PATH


#############################
##   user customizations   ##
#############################

## a few common useful aliases for the 'ls' command
alias l="ls -lh $@"
alias ll="ls -lah $@"

## change the prompt string as preferred
#export PS1="% "
export PS1="bash$ "

## redefine the 'cd' command in order to print the destination directory once done
function cd {

   builtin cd "$@" > /dev/null && echo $PWD
}

## add here additional user customizations

