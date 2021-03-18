# Lab 4 Instructions
[[**Home**](https://github.com/lpacher/fphd)] [[**Back**](https://github.com/lpacher/fphd/tree/master/labs)]

In this lab we start discussing the **FPGA implementation flow** using Xilinx Vivado. For this purpose we create a simple **Vivado project** <br/>
in **graphical mode** to explore **GUI functionalities** and **FPGA implementation details**.

<br/>

<span>&#8226;</span> As a first step, **open a terminal** and move inside the `lab4/` directory :

```
% cd Desktop/fphd/labs/lab4
```
<br/>

<span>&#8226;</span> Copy from the `.solutions/` directory the main `Makefile` already prepared for you :


```
% cp .solutions/Makefile .
```

Explore **new available targets** :

```
% make help
% cat Makefile
```
<br/>

<span>&#8226;</span> To create a new fresh working area, type :

```
% make area
% ls -l
```
<br/>


<span>&#8226;</span> Copy from the `.solutions/` directory all **simulation and implementation Tcl scripts** as follows :

```
% cp .solutions/scripts/common/*.tcl  scripts/common/
% cp .solutions/scripts/sim/*.tcl     scripts/sim/
% cp .solutions/scripts/impl/*.tcl    scripts/impl/
```
<br/>

>
> **WARNING**
>
> If you want to use the asterisk `*` as **wildcar** for `cp` on Windows, please be aware that the `cp.exe` executable<br/>
> that comes with GNU Win works properly **only using forward slashes in the path !**
> 
> If you use the TAB completion on Windows the following commands **will not work** :
>
> ```
> % cp .solutions\scripts\common\*.tcl  scripts\common\
> % cp .solutions\scripts\sim\*.tcl     scripts\sim\
> % cp .solutions\scripts\impl\*.tcl    scripts\impl\
> ```
>
> You can use the native `copy` DOS command instead :
>
> ```
> % copy .solutions\scripts\common\*.tcl  scripts\common\
> % copy .solutions\scripts\sim\*.tcl     scripts\sim\
> % copy .solutions\scripts\impl\*.tcl    scripts\impl\
> ```
>
<br/>


<span>&#8226;</span> Explore the content of new scripts directories :

```
% ls scripts/common
% ls scrips/impl
```
<br/>


<span>&#8226;</span> For this lab we will also reuse the code already developed in `lab2` to implement and simulate **basic logic gates** in VHDL :

```
% cp .solutions/rtl/Gates.vhd       rtl/
% cp .solutions/bench/tb_Gates.vhd  bench/
```
<br/>


<span>&#8226;</span> Finally, copy from the `.solutions/xdc/` directory the main **Xilinx Design Constraints (XDC)** file that will be used to<br/>
**map top-level VHDL I/O ports to physical FPGA pins** of the
[**Digilent Arty A7 development board**](https://store.digilentinc.com/arty-a7-artix-7-fpga-development-board-for-makers-and-hobbyists/) :

```
% cp .solutions/xdc/Gates.xdc  xdc/
```
<br>


<span>&#8226;</span> Explore all command-line switches and options for the `vivado` executable :


```
% vivado -help

Description:
Vivado v2019.2 (64-bit)
SW Build 2708876 on Wed Nov  6 21:40:23 MST 2019
IP Build 2700528 on Thu Nov  7 00:09:20 MST 2019
Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.

Syntax:
vivado  [-mode <arg>] [-init] [-source <arg>] [-nojournal] [-appjournal]
        [-journal <arg>] [-nolog] [-applog] [-log <arg>] [-version]
        [-tclargs <arg>] [-tempDir <arg>] [-robot <arg>] [-verbose] [<project>]

Usage:
  Name           Description
  --------------------------
  [-mode]        Invocation mode, allowed values are 'gui', 'tcl', and
                 'batch'
                 Default: gui
  [-init]        Source vivado.tcl file
  [-source]      Source the specified Tcl file
  [-nojournal]   Do not create a journal file
  [-appjournal]  Open journal file in append mode
  [-journal]     Journal file name
                 Default: vivado.jou
  [-nolog]       Do not create a log file
  [-applog]      Open log file in append mode
  [-log]         Log file name
                 Default: vivado.log
  [-version]     Output version information and exit
  [-tclargs]     Arguments passed on to tcl argc argv
  [-tempDir]     Temporary directory name
  [-robot]       Robot JAR file name
  [-verbose]     Suspend message limits during command execution
  [<project>]    Load the specified project (.xpr) or design checkpoint
                 (.dcp) file

```
<br/>


<span>&#8226;</span> Launch Vivado in GUI mode. For Linux users :

```
% vivado -mode gui &
```

For Windows users :

```
% echo "exec vivado -mode gui &" | tclsh
```
<br/>

>
> **IMPORTANT**
>
> There is no Windows equivalent for the Linux `&` operator to **fork in background** the execution
> of a program invoked at the command line. Most of Windows programs launched from the _Command Prompt_ 
> by default already start in background leaving the shell alive (e.g. `notepad.exe` or `notepad++.exe`).
> Unfortunately this is not the case for the `vivado` executable.
>
> In principle one can use the `start` command to launch Vivado in GUI mode from the _Command Prompt_ as follows :
>
> ```
> % start /b vivado -mode gui
> ```
>
> which is the closest solution to the `&` on Linux operating systems.
> However, in order to have a **portable flow between Linux and Windows** the proposed solution in the `Makefile`
> is to **forward** the execution of `vivado -mode gui` to `tclsh` using the Tcl command `exec` which accepts the usage of the `&` instead.
>

<br/>

<span>&#8226;</span> Follow the **New Project wizard** and create a new **Vivado project** targeting
the `test/` directory and attached to the
[**Digilent Arty A7 development board**](https://store.digilentinc.com/arty-a7-artix-7-fpga-development-board-for-makers-and-hobbyists/)
(select the **xc7a35ticsg324-1L** device). Load in the project **all VHDL sources** (`Gates.vhd`, `tb_Gates.vhd`) and<br/>
the **constraints file** (`Gates.xdc`). Try to run from the GUI **all steps of the FPGA implementation flow** :

1. RTL behavioral simulation
1. generic synthesis (RTL elaboration)
1. mapped synthesis
1. post-synthesis behavioral simulation
1. post-synthesis timing simulation
1. place-and-route (implementation)
1. post-layout behavioral simulation
1. post-layout timing simulation
1. bitstream generation
1. firmware installation

<br/>

<span>&#8226;</span> Exit from  Vivado when done by typing

```
exit
```
<br/>

in the _Tcl Console_.

<br/>


## Explore the Vivado journal file

For each "click" performed in the Vivado graphical interface there is an **equivalent Tcl command**.
By default Vivado already keeps track of all these commands for you in the so called **journal file** (`.jou`).

If no additional `-journal` option is used to specify the name of the journal file when invoking `vivado`,
the default `vivado.jou` is created in the directory where `vivado` is executed.

Explore the syntax of Tcl command collected in the journal file :

```
% cat vivado.jou
```
<br/>

You can also easily **reproduce the entire flow** at any time by executing the journal file with the `-source` option when invoking `vivado`<br/>
at the command line (save the original journal file as `vivado.tcl` before, otherwise the file will be overwritten) :

```
% mv vivado.jou vivado.tcl
% vivado [-mode gui|tcl|batch] -source vivado.tcl
```
<br/>

This is a good starting point to understand how to **automate the FPGA implementation flow** in Xilinx Vivado
using either a **project mode** or a **non-project mode** Tcl script.

<br/>

## Creating a Vivado project from Tcl

All selections done in the **New Project wizard** graphical interface to create a new project
targeting a certain project directory and attached to a specific FPGA device have the following
single **Tcl equivalent command** :

```
create_project -part <target device> <project name> <project directory>
```
<br/>

Since creating a project as well as loading sources and design constraints into the project are repetitive tasks
we can **collect Tcl statements into a script** and automatically execute the script at Vivado startup from `Makefile`
as follows :


```
% make project [mode=gui]
```
<br/>

You can also **initialize the project in Tcl mode** (faster) and **later open the Vivado graphical interface**
with the `start_gui` command :

```
% make project mode=tcl

****** Vivado v2019.2 (64-bit)
  **** SW Build 2708876 on Wed Nov  6 21:40:23 MST 2019
  **** IP Build 2700528 on Thu Nov  7 00:09:20 MST 2019
    ** Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.

 ...
 ...

Vivado% start_gui
```
<br/>

Explore the content of the `scripts/common/project.tcl` script already prepared for you :

```
% more scripts/common/project.tcl
```
<br/>


## Running the flow in non-project mode

You can also try to run the FPGA implementation flow using a **non-project mode Tcl script** as follows :

```
% make clean
% make bit mode=tcl  (by default mode=gui)
```

Explore the content of the `scripts/impl/xflow.tcl` script already prepared for you :

```
% more scripts/impl/xflow.tcl
```


## Exercise

Modify the VHDL source code `rtl/Gates.vhd` and **instantiate Xilinx FPGA
primitives** `IBUF` and `OBUF` **input/output buffers** in order to buffer
all top-level input/output signals `A` and `B` and `Z(5 downto 0)` already
at RTL stage.

In order to **elaborate and simulate** the VHDL code instantiating Xilinx FPGA primitives
you have to include all components from the `UNISIM` library :

```vhdl
library UNISIM ;
use UNISIM.vcomponents.all ;
```
<br/>


The complete code is the following :

```vhdl
library ieee ;
use ieee.std_logic_1164.all ;


-- library to simulate Xilinx FPGA primitives
library UNISIM ;
use UNISIM.vcomponents.all ;


entity Gates is

   port (
      A : in  std_logic ;
      B : in  std_logic ;
      Z : out std_logic_vector(5 downto 0)
   ) ;

end entity Gates ;


architecture rtl of Gates is

   --------------------------
   --   internal signals   --
   --------------------------

   signal A_int : std_logic ;
   signal B_int : std_logic ;
   signal Z_int : std_logic_vector(5 downto 0) ;


   --------------------------------
   --   components declaration   --
   --------------------------------

   -- input buffer (assume default generics)
   component IBUF is
      port (
         I : in  std_logic ;
         O : out std_logic
      ) ;
   end component ;


   -- output buffer (assume default generics)
   component OBUF is
      port (
         I : in  std_logic ;
         O : out std_logic
      ) ;
   end component ;


begin

   -- place buffer on all input signals
   A_rtlbuf : IBUF port map( I => A, O => A_int ) ;
   B_rtlbuf : IBUF port map( I => B, O => B_int ) ;

   -- place buffers on all output signals
   Z0_rtlbuf : OBUF port map( I => Z_int(0), O => Z(0) ) ;
   Z1_rtlbuf : OBUF port map( I => Z_int(1), O => Z(1) ) ;
   Z2_rtlbuf : OBUF port map( I => Z_int(2), O => Z(2) ) ;
   Z3_rtlbuf : OBUF port map( I => Z_int(3), O => Z(3) ) ;
   Z4_rtlbuf : OBUF port map( I => Z_int(4), O => Z(4) ) ;
   Z5_rtlbuf : OBUF port map( I => Z_int(5), O => Z(5) ) ;

   -- AND
   Z_int(0) <= A_int and B_int ;

   -- NAND
   Z_int(1) <= A_int nand B_int ;

   -- OR
   Z_int(2) <= A_int or B_int ;

   -- NOR
   Z_int(3) <= A_int nor B_int ;

   -- XOR
   Z_int(4) <= A_int xor B_int ;

   -- XNOR
   Z_int(5) <= A_int xnor B_int ;

end architecture rtl ;
```
<br/>

Simulate the new code after modifications :

```
% make sim
```


## Further reading

If you are interested in more in-depth details about Vivado use models and flows ref. to the following **Xilinx official documentation** :

* [_Vivado Design Suite User Guide: Design Flows Overview_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug892-vivado-design-flows-overview.pdf)

