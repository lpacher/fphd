![](doc/etc/logo.png)

# Introduction to FPGA Programming <br/> _Using Xilinx Vivado and VHDL_

## PhD Degree in Physics, University of Torino

<br />

Git repository for the [_Introduction to FPGA Programming Using Xilinx Vivado and VHDL_](https://www.phdphysics.unito.it/do/corsi.pl/Show?_id=45hr) (4 CFU)
PhD course at University of Torino, Physics Department.

<br />

# Contents

* [**Contacts**](#contacts)
* [**Course program**](#course-program)
* [**Course material**](#course-material)
* [**Hands-on laboratories**](#hands-on-laboratories)
* [**Environment setup**](#environment-setup)
* [**Git installation and configuration**](#git-installation-and-configuration)
* [**Clone and update the Git repository for the course**](#clone-and-update-the-git-repository-for-the-course)
* [**Basic git commands**](#basic-git-commands)
* [**Sample Xilinx Vivado simulation and implementation flows**](#sample-xilinx-vivado-simulation-and-implementation-flows)
* [**Reference documentation**](#reference-documentation)
* [**Webex lectures**](#webex-lectures)

<br />
<!--------------------------------------------------------------------->


# Contacts
[**[Contents]**](#contents)

[<h3>Prof. Luca Pacher</h3>](https://fisica.campusnet.unito.it/do/docenti.pl/Show?_id=lpacher#tab-profilo)

University of Torino, Physics Department<br />
via Pietro Giuria 1, 10125, Torino, Italy<br />
Email: _pacher@NOSPAMto.infn.it_<br />
Office: new building, 3rd floor, room C4<br />
Phone: +39.011.670.7477<br />
Webex: _<https://unito.webex.com/meet/luca.pacher>_

<br />
<!--------------------------------------------------------------------->


# Course program
[**[Contents]**](#contents)

This is a postgraduate introductory course about digital design and FPGA programming using **Xilinx Vivado** <br />
and the **VHDL Hardware Description Language (HDL)**.

The main topics covered in the course are:

* VHDL syntax fundamentals, HDL design flow
* logic values, resolved vs. unresolved logic values, 3-state logic, buses and endianess
* review of boolean algebra
* introduction to Xilinx Vivado simulation and implementation flows
* design and simulation of combinational circuits with VHDL examples (multiplexers, decoders, encoders etc.)
* FPGA architectures overview and basic building blocks (fabric, BEL, LUT, CLB, CLA, slices, IOBs, hard-macros)
* introduction to Xilinx Design Constraints (XDCs)
* sequential circuits, latches and FlipFlops
* counters, registers, Pulse-Width Modulation (PWM), shift-registers, FSM, FIFOs, RAM/ROM
* advanced Xilinx Design Constraints (XDCs) and timing fundamentals
* synchronous design good and bad practices, example Vivado IP flows (clock wizard, FIFO compiler)
* gate-level simulations with back-annotated delays (SDF)
* practical implementation and test of small digital systems targeting a Xilinx Artix-7 FPGA device

>
> **IMPORTANT !**
>
> All students are requested to **complete the preparatory work** before attending practical lectures !<br/>
> Please go through detailed step-by-step instructions presented in [**labs/lab0/README.md**](labs/lab0/README.md)
>

<br />
<!--------------------------------------------------------------------->


# Course material
[**[Contents]**](#contents)

<br />
Lecture slides are available at:

<p>

**<http://personalpages.to.infn.it/~pacher/teaching/FPGA/phd/slides>**

</p>

A complete list of reference documentation and online resources is available in the [**Reference documentation**](#reference-documentation)
section instead.<br />

Board schematics can be found in the main `doc/` directory of the repository.<br />

<br />
Additional software components for Windows can be downloaded from:

<p>

**<http://personalpages.to.infn.it/~pacher/teaching/FPGA/software/windows>**

</p>

<br />

Links to **recorded video lectures** are listed in the [**Webex lectures**](#webex-lectures) section.

<br />
<!--------------------------------------------------------------------->


# Hands-on laboratories
[**[Contents]**](#contents)

The course is organized in form of [**virtual laboratories**](fpga/labs/README.md) to introduce fundamental concepts in FPGA design
and simulation using the **VHDL Hardware Description Language (HDL)** and **Xilinx Vivado**.<br />
Each "lab" consists of step-by-step instructions to guide the student in running the simulation and implementation flows using Xilinx tools from the command-line.
The only requirement for these labs is to have a personal computer with [all necessary development tools properly installed and configured](fpga/labs/lab0/README.md).

The complete list of proposed labs can be found [**here**](https://github.com/lpacher/fphd/tree/master/labs). 

Virtual laboratories are then supported by [**practical examples**](fpga/practicum/README.md) in the electronics lab in order to let students to physically experiment
with a real FPGA and digital circuits using real hardware and instrumentation. 

<br />
<!--------------------------------------------------------------------->


# Environment setup
[**[Contents]**](#contents)

<br />


>
> **IMPORTANT !**
>
> Each student is **requested** to have a **fully-working FPGA development environment** installed on his/her <br />
> personal computer in terms of software installations, licensing, command-line setup etc.<br /><br />
> Please complete the **preparatory work** by going through detailed **step-by-step instructions** presented<br />
> in [**_fpga/labs/lab0/README.md_**](fpga/labs/lab0/README.md) well **before** attending the first lecture! <br />
>
> Be aware that <b>Xilinx <u><i>only</i></u> supports Linux and Windows platforms</b>, not MacOS.
> Students using a MacOS personal computer must either install
> a supported operating system (Linux Ubuntu would be preferable)
> using a dual-boot or a virtualization software (VirtualBox is fine)
> or find another computer running a Linux distribution or Windows 7/10.
>

<br />

In this introductory course we will adopt a **script-based** and **command-line based** approach
to FPGA programming using Xilinx Vivado assuming a **Linux-like development environment**.

Both Linux and Windows operating systems are supported.
Familiarity with **Linux basic shell commands** to work with files and directories (`pwd`, `cd`, `ls`, `cp`, `mv`, `mkdir`, `rm`),
with the **GNU Makefile** (`make`) and with a **text editor** for source coding is therefore assumed.

Sample scripts `sample/.bashrc` and `sample/.cshrc` for Linux, as well as `sample/login.bat` for Windows are also provided to
support both `sh/bash` and `csh/tcsh` Linux shells and the Windows _Command Prompt_.

Detailed **step-by-step instructions** are provided in form of a [**_"lab zero"_**](fpga/labs/lab0/README.md)
to help students to setup a suitable development environment for both Linux and Windows operating systems.

<br />

>
> **NOTE**
>
> The number of Linux shell commands used through the course is very small indeed.
> If you are unfamiliar to work with the Linux command line a complete list of basic commands used in the course can be reviewed [**here**](doc/bash/README.md).
>
> An endless number of online tutorials and examples is available otherwise, just search for "Linux basic commands" or similar.<br />
> As an example:
>
>
>
> * _<https://linuxize.com/post/basic-linux-commands>_
> * _<https://www.hostinger.com/tutorials/linux-commands>_
> * _<https://maker.pro/linux/tutorial/basic-linux-commands-for-beginners>_
> * _<https://www.guru99.com/must-know-linux-commands.html>_
>

<br />
<!--------------------------------------------------------------------->


# Git installation and configuration
[**[Contents]**](#contents)

During the course we will write and discuss a lot of **source code** in form of **plain-text files** (VHDL sources, XDC constraints,
Tcl scripts, GNU Makefiles etc.).

These sources are tracked using the [**Git versioning tool**](https://en.wikipedia.org/wiki/Git). All students are therefore
**requested to have a working Git installation** to clone the repository and get updates.

<br />

### Linux installation

Usually `git` is already installed by default on most Linux distributions. Verify that `git` is found in your search path with:

```
% which git
```


In case the Git package is not installed on your Linux system, use

```
% sudo yum install git
```

or

```
% sudo apt-get install git
```

according to the package manager of the Linux distribution you are working with.

<br />

### Windows installation

Students working on a Windows system can download and install **Git for Windows** from the project official page:

_<https://gitforwindows.org>_

Detailed instructions for the installation can be found [**here**](fpga/labs/lab0/README.md#install-git).

<br />

### Initial configuration

Before starting to use `git` you are requested to do some **initial configuration** as follows:


```
% git config --global user.name "Your Name"
% git config --global user.email your.email@example.com
```

These settings are internal to Git and local to your machine. For the email address you can use
your official `name.surname@edu.unito.it` address. You can then check your configuration at any time with:


```
% git config --list
```

<br />
<!--------------------------------------------------------------------->


# Clone and update the Git repository for the course
[**[Contents]**](#contents)

All students are requested to use `git` from the command-line to **download the repository** and to **keep track of updates**.

In order to download the repository for the first time **open a terminal** and type:

```
% cd Desktop
% git clone https://github.com/lpacher/fphd.git [optional target directory]
```

By default a new `fphd/` directory containing the repository will be created where you invoked the above `git` command, unless
you specify a different target directory as optional parameter.

Feel free to use a different target directory. As an example:


```
% cd Desktop/Documents
% git clone https://github.com/lpacher/fphd.git FPGA
```

<br />

>
> **IMPORTANT** !
>
> All cut-and-paste instructions in `README` files assume that you clone the repository as `fphd` on your Desktop. If you decide to
> clone the repository **either with a different name or into a different location** it will be up to you to properly change
> the path to the repository wherever required.
>

<br />

According to Git jargon, the first time you download the repository you are in the `master` branch.
The `master` branch should always represent the "stable version" of the project:

```
% cd Desktop/fphd
% git branch
*master
```

The asterisk indicates the **current working branch**.


As a first step after downloading the repository for the first time you are requested to
**create your personal development branch** named `student` as follows:

```
% git branch student
% git checkout student
```

You can now **list all branches** in your local machine with:

```
% git branch
master
*student
```

Please, be sure that the asterisk now points to your own development branch `student` and not to the `master` branch.

Each time you will need to **update your local copy of the repository** simply perform a **pull from the remote repository** using:

```
% git pull origin master
```

<br />

>
> **IMPORTANT !**
>
> All `git` commands **must be invoked** inside the top `fphd/` directory or from any other sub-directory of the repository!
>

<br />
<!--------------------------------------------------------------------->


# Basic git commands
[**[Contents]**](#contents)

In this course students are only requested to use `git` to "clone" the repository for the first time and then to "pull" from the `master` branch
to get updates whenever required.

If you are interested in using Git for other projects a small collection of the most frequently used `git` **command-line syntax** for your
day-to-day work and common tasks can be found [**here**](doc/git/README.md).
A more complete guide to the basic `git` commands can be found [**here**](http://doc.gitlab.com/ee/gitlab-basics/start-using-git.html).

<br />
<!--------------------------------------------------------------------->


# Sample Xilinx Vivado simulation and implementation flows
[**[Contents]**](#contents)

A small **mixed-language** HDL design example is provided to help students in testing
their overall **command-line environment setup** and all **software installations** required for the course.<br />

Step-by-step instructions explaining how to run this test flow can be found [**here**](fpga/test/README.md).

<br />
<!--------------------------------------------------------------------->


# Reference documentation
[**[Contents]**](#contents)

<br />

>
> **NOTE**
>
> Links to Xilinx official documentation refer to Vivado version **2019.2** ! 
>

<br />

<details>
<summary><b>Digital electronics and logic design fundamentals</b></summary>

<p>

* J.D. Daniels, _Digital Design from Zero to One_
* J.F. Wakerly, _Digital Design Principles and Practices_
* A.K. Maini, _Digital Electronics, Principles, Devices and Applications_ 
* M.M. Mano and C.R. Kime, _Logic and Computer Design Fundamentals_

</p>
<br />
</details>

<details>
<summary><b>VHDL programming</b></summary>

<p>

* B. Mealy and F. Tappero, [_Free Range VHDL_](http://freerangefactory.org/pdf/df344hdh4h8kjfh3500ft2/free_range_vhdl.pdf) (open source)
* C.H. Roth Jr, _Digital Systems Design Using VHDL_
* V.A. Pedroni, _Circuit Design with VHDL_
* R.E. Haskell and D.M. Hanna, _Introduction to Digital Design Using Digilent FPGA Boards / VHDL Examples_
* P.P. Chu, _FPGA Prototyping By VHDL Examples_
* M. Field, [_Introducing the Spartan 3E FPGA and VHDL_](https://github.com/hamsternz/IntroToSpartanFPGABook/blob/master/IntroToSpartanFPGABook.pdf) (open source)
* P. Ashenden, _The Designer's Guide to VHDL_

</p>
<br />
</details>


<details>
<summary><b>Verilog programming</b></summary>

<p>

* Z. Navabi, _Verilog Digital System Design_
* D.E. Thomas and P.R. Moorby, _The Verilog Hardware Description Language_
* R.E. Haskell and D.M. Hanna, _Introduction to Digital Design Using Digilent FPGA Boards / Verilog Examples_
* F. Vahid, _Verilog for Digital Design_
* P.P. Chu, _FPGA Prototyping By Verilog Examples_

</p>
<br />
</details>


<details>
<summary><b>FPGA programming (mainly using Xilinx Vivado but not only)</b></summary>

<p>

* S. Churiwala (Editor), _Designing with Xilinx FPGAs Using Vivado_
* C. Unsalan and B. Tar, _Digital System Design with FPGA: Implementation Using Verilog and VHDL_
* R.E. Haskell and D.M. Hanna, _Introduction to Digital Design Using Digilent FPGA Boards / Verilog (VHDL) Vivado Edition_
* S. Kilts, _Advanced FPGA Design: Architecture, Implementation, and Optimization_
* E. Stavinov, _100 Power Tips for FPGA Designers_
* C. Maxfield, _The Design Warrior's Guide to FPGAs: Devices, Tools and Flows_

</p>
<br/>
</details>

<details>
<summary><b>Xilinx Vivado official documentation (open)</b></summary>

<p>

* [_Vivado Design Suite User Guide: Release Notes, Installation, and Licensing (UG973)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug973-vivado-release-notes-install-license.pdf)
* [_Vivado Design Suite User Guide: Getting Started (UG910)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug910-vivado-getting-started.pdf)
* [_Vivado Design Suite User Guide: Design Flows Overview (UG892)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug892-vivado-design-flows-overview.pdf)
* [_Vivado Design Suite User Guide: Using the Vivado IDE (UG893)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug893-vivado-ide.pdf)
* [_Vivado Design Suite User Guide: Using Tcl Scripting (UG894)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug894-vivado-tcl-scripting.pdf)
* [_Vivado Design Suite User Guide: System-Level Design Entry (UG895)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug895-vivado-system-level-design-entry.pdf)
* [_Vivado Design Suite User Guide: Designing with IP (UG896)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug896-vivado-ip.pdf)
* [_Vivado Design Suite User Guide: Model-Based DSP Design Using System Generator (UG897)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug897-vivado-sysgen-user.pdf)
* [_Vivado Design Suite User Guide: Embedded Processor Hardware Design (UG898)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug898-vivado-embedded-design.pdf)
* [_Vivado Design Suite User Guide: I/O and Clock Planning (UG899)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug899-vivado-io-clock-planning.pdf)
* [_Vivado Design Suite User Guide: Logic Simulation (UG900)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug900-vivado-logic-simulation.pdf)
* [_Vivado Design Suite User Guide: Synthesis (UG901)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug901-vivado-synthesis.pdf)
* [_Vivado Design Suite User Guide: High-Level Synthesis (UG902)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug902-vivado-high-level-synthesis.pdf)
* [_Vivado Design Suite User Guide: Using Constraints (UG903)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug903-vivado-using-constraints.pdf)
* [_Vivado Design Suite User Guide: Implementation (UG904)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug904-vivado-implementation.pdf)
* [_Vivado Design Suite User Guide: Hierarchical Design (UG905)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug905-vivado-hierarchical-design.pdf)
* [_Vivado Design Suite User Guide: Design Analysis and Closure Techniques (UG906)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug906-vivado-design-analysis.pdf)
* [_Vivado Design Suite User Guide: Power Analysis and Optimization (UG907)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug907-vivado-power-analysis-optimization.pdf)
* [_Vivado Design Suite User Guide: Programming and Debugging (UG908)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug908-vivado-programming-debugging.pdf)
* [_Vivado Design Suite User Guide: Partial Reconfiguration (UG909)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug909-vivado-partial-reconfiguration.pdf)
* [_UltraFast Design Methodology Guide for the Vivado Design Suite (UG949)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug949-vivado-design-methodology.pdf)

</p>
<br/>
</details>


<details>
<summary><b>Xilinx Vivado official tutorials (open)</b></summary>

<p>

* [_Vivado Design Suite Tutorial: Logic Simulation (UG973)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug937-vivado-design-suite-simulation-tutorial.pdf)

</p>
<br/>
</details>


<details>
<summary><b>Xilinx 7-series FPGAs official documentation (open)</b></summary>

<p>

* [_7 Series FPGAs Data Sheet: Overview (DS180)_](https://www.xilinx.com/support/documentation/data_sheets/ds180_7Series_Overview.pdf)
* [_7 Series Product Selection Guide_](https://www.xilinx.com/support/documentation/selection-guides/7-series-product-selection-guide.pdf)
* [_7 Series FPGAs Configuration User Guide (UG470)_](https://www.xilinx.com/support/documentation/user_guides/ug470_7Series_Config.pdf)
* [_7 Series FPGAs SelectIO Resources User Guide (UG471)_](https://www.xilinx.com/support/documentation/user_guides/ug471_7Series_SelectIO.pdf)
* [_7 Series FPGAs Clocking Resources User Guide (UG472)_](https://www.xilinx.com/support/documentation/user_guides/ug472_7Series_Clocking.pdf)
* [_7 Series FPGAs Memory Resources User Guide (UG473)_](https://www.xilinx.com/support/documentation/user_guides/ug473_7Series_Memory_Resources.pdf)
* [_7 Series FPGAs Configurable Logic Block User Guide (UG474)_](https://www.xilinx.com/support/documentation/user_guides/ug474_7Series_CLB.pdf)
* [_7 Series FPGAs Packaging and Pinout User Guide (UG475)_](https://www.xilinx.com/support/documentation/user_guides/ug475_7Series_Pkg_Pinout.pdf)
* [_7 Series FPGAs GTX/GTH Transceivers User Guide (UG476)_](https://www.xilinx.com/support/documentation/user_guides/ug476_7Series_Transceivers.pdf)
* [_7 Series FPGAs DSP48E1 Slice User Guide (UG479)_](https://www.xilinx.com/support/documentation/user_guides/ug479_7Series_DSP48E1.pdf)
* [_7 Series FPGAs and Zynq-7000 SoC XADC Dual 12-Bit 1 MSPS Analog-to-Digital Converter<br/>User Guide (UG480)_](https://www.xilinx.com/support/documentation/user_guides/ug480_7Series_XADC.pdf)
* [_7 Series FPGAs PCB Design Guide (UG483)_](https://www.xilinx.com/support/documentation/user_guides/ug483_7Series_PCB.pdf)

</p>
<br/>
</details>

<details>
<summary><b>Design constraints</b></summary>

<p>

* S. Gangadaran and S. Churiwala, _Constraining Designs for Synthesis and Timing<br/>Analysis: A Practical Guide to Synopsys Design Constraints (SDC)_
* [_Vivado Design Suite User Guide: Using Constraints (UG903)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug903-vivado-using-constraints.pdf)
* [_Vivado Design Suite Tutorial: Using Constraints (UG945)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug903-vivado-using-constraints.pdf)

</p>
<br/>
</details>



<details>
<summary><b>Tcl programming</b></summary>

<p>

* B.B. Welch, _Practical Programming in Tcl and Tk_
* J.K. Ousterhout, _Tcl and the Tk Toolkit_
* A.P. Nadkarni, _The Tcl Programming Language: A Comprehensive Guide_
* [_Vivado Design Suite Tcl Command Reference Guide (UG835)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug835-vivado-tcl-commands.pdf)
* [_Vivado Design Suite User Guide: Using Tcl Scripting (UG894)_](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug894-vivado-tcl-scripting.pdf)
* [_TCL/TK Command Reference Guide_](https://www.rkeene.org/projects/vtcl/tcl-tk-reference-guide.html)
* [_TCL/TK Quick Reference Card_](http://www.cheat-sheets.org/saved-copy/TclTk_quickref.pdf)

</p>
<br/>
</details>


#### Other online resources

* _<https://www.fpga4student.com>_
* _<https://www.fpga4fun.com>_
* _<http://www.asic-world.com/verilog/index.html>_
* _<http://www.asic-world.com/vhdl/index.html>_
* _<https://www.nandland.com/verilog/tutorials/index.html>_
* _<https://www.nandland.com/vhdl/tutorials/index.html>_
* _<https://vhdlwhiz.com/basic-vhdl-tutorials>_
* _<https://en.wikibooks.org/wiki/Category:Book:VHDL_for_FPGA_Design>_
* _<https://surf-vhdl.com>_
* _<https://www.so-logic.net/documents/knowledge/tutorial/Basic_FPGA_Tutorial_VHDL>_
* _<https://www.hackster.io/xilinx/projects>_
* _<https://web.archive.org/web/20190115230224/http://hamsterworks.co.nz/mediawiki/index.php/FPGA_Projects>_

#### List of acronyms and abbreviations

A list of of common acronyms and abbreviations relevant to electronics engineering and FPGA programming<br />
can be found [**here**](doc/LOA.md).

<br />
<!--------------------------------------------------------------------->


# Webex lectures
[**[Contents]**](#contents)

In order to maximize the participation all lectures will be held **remotely** using the [**WebEx UniTO**](https://www.unito.it/node/2373) platform.
All lectures will be also **video-recorded**.<br />

The virtual room to attend the lectures is accessible at the following link:

**_<https://unito.webex.com/meet/luca.pacher>_**

<br/>

### Links to **video-recorded lectures** (in Italian)

The complete list of past video-recorded lectures can be accessed [**here**](doc/webex/README.md).

* Lecture 1
* Lecture 2
* Lecture 3
* Lecture 4
* Lecture 5
* Lecture 6
* Lecture 7
* Lecture 8

