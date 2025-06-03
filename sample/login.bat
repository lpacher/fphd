::
:: Sample configuration script for the MS Windows Command Prompt.
:: Use this file to set the proper Xilinx Vivado runtime environment
:: and to improve the overall command line usage under Windows.
::
:: Copy this file in your main %USERPROFILE% home directory
:: (usually C:\Users\<username>) and customize all statements 
:: to fit your actual software installations.
::
:: Also modify the default Command Prompt shortcut in order to
:: force the cmd.exe executable to load the script at startup:
::
:: %windir%\System32\cmd.exe /K %USERPROFILE%\login.bat
::
:: For all details please ref. to:
::
:: https://github.com/lpacher/lae/blob/master/fpga/labs/lab0/README.md
::
:: Luca Pacher - pacher@to.infn.it
:: Spring 2019
::


:: turn off commands echoing
@echo off


:: print on the screen that the file is sourced (debug feature)
echo.
echo Loading %USERPROFILE%\login.bat
echo.


::
:: **OPTIONAL: inject Clink into the Windows console (local non-administrator installation)
::

: \path\to\clink_x86.exe inject > nul  or
: \path\to\clink_x64.exe inject > nul


::---------------------
::   Notepad++ setup   
::---------------------

:: include Notepad++ executable to search path
set PATH=\where\you\installed\Notepad++;%PATH%

:: create a shorter alias (doskey) for notepad++.exe for faster typing 
doskey n++=notepad++.exe $*


::--------------------------------------
::   GnuWin setup (Linux executables)
::--------------------------------------

:: add Linux executables from GnuWin to search path
set PATH=\where\you\installed\GnuWin\bin;%PATH%

:: force the Command Prompt to search built in executables in PATH to prevent name clashes
doskey mkdir="mkdir.exe" $*
doskey rmdir="rmdir.exe" $*
doskey echo="echo.exe" $*
doskey more="more.exe" $*


::-----------------------------------
::   additional Linux-like doskeys
::-----------------------------------

:: a few useful aliases for the 'ls' command
doskey ls=ls --color $*
doskey  l=ls --color -l $*
doskey ll=ls --color -lah $*

:: force the built in 'cd' command to behave as the Linux one
doskey cd=if /i "$1" == "" ( cd /d %%USERPROFILE%% ^& set OLDCD=%%CD%% ) else ( if /i "$1" == "-" ( cd /d %%OLDCD%% ^& set OLDCD=%%CD%% ) else ( cd /d "$1" ^& set OLDCD=%%CD%% )) 

:: redefine 'pwd' in order to display paths with / separator instead of \ as under Linux
doskey pwd=echo %%CD%% ^| sed -e "s/\\\\/\//g"


::--------------------
::   Nano/Vim setup
::--------------------

:: add Nano executable to search path
set PATH=\where\you\installed\Nano;%PATH%

:: add Vim executable to search path
:set PATH=\where\you\installed\Vim;%PATH%


::---------------
::   Git setup
::---------------

:: add git executable to search path
set PATH=\where\you\installed\Git\cmd;%PATH%


::------------------
::   Tcl/Tk setup
::------------------

:: add WinTclTk executables to search path
set PATH=\where\you\installed\WinTclTk\bin;%PATH%

:: if required, invoke the default executable tclsh85.exe as tclsh
:doskey tclsh=tclsh85.exe $* 


::-----------------
::   PuTTY setup
::-----------------

:: add PuTTY executables to search path
set PATH=C:\where\you\installed\PuTTY;%PATH%


::----------------------------------------
::   Evince PDF viewer setup (optional)
::----------------------------------------

:: add Evince executable to search path
set PATH=C:\where\you\installed\Evince;%PATH%

:: redirect garbage 'No display font' errors to NUL (but DosKey ignores the usual > redirection character, needs the $G special character for this)
doskey evince=evince.exe $* $G nul


::-------------------------
::   Xilinx Vivado setup
::-------------------------

:: variable to locate the main Xilinx Vivado installation directory (by default C:\Xilinx)
set XILINX_DIR=C:\Xilinx

:: add Vivado executables to system search path
call %XILINX_DIR%\Vivado\<version>\settings64.bat

:: if required you can also use the XILINXD_LICENSE_FILE environment variable to locate
:: a licence file for Xilinx Vivado
: set XILINXD_LICENSE_FILE=C:\Xilinx|Xilinx.lic


:: add here additional user customizations

