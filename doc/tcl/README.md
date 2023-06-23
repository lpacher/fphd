
# Tcl programming quick references
[[**Home**](../../README.md)]

A small collection of most frequently used Tcl programming statements for your day-to-day work and common tasks.

See also:

* _<https://en.wikipedia.org/wiki/Tcl>_
* _<https://www.fundza.com/tcl/quickref_1/index.html>_

<br />
<!--------------------------------------------------------------------->


## Introduction

The **Tool Command Language (TCL)** is a general-purpose, high-level **interpreted** programming language.
Being an "interpreted" language there is **no compiler** for this language, what we usually do is to
collect a certain number of statements into a so called **script** and then the Tcl shell executes
line by line Tcl commands.

The main reason for using this language in the course is that Tcl is the scripting language
adopted by Xilinx Vivado. Most of CAD tools used in electronics and microelectronics fields
use the Tcl programming language as part of their software environments indeed. Thus learning Tcl
can be useful also for your later research work.

<br />
<!--------------------------------------------------------------------->


## Shell interpreter

In order to write and execute Tcl programs you need a Tcl "shell" application able to understand and execute Tcl statements.
This is similar to using the Linux Bash shell or the Windows _Command Prompt_ in which you type "commands"
executed by the shell _interpreter_.

Xilinx Vivado comes with its own **Tcl console** in which you can type both Xilinx-specific commands
and native Tcl commands.
Apart from this, we also installed the `tclsh` standalone Tcl shell in order to be able to write
portable-flows between Linux and Windows operating systems.

<br />
<!--------------------------------------------------------------------->


## Interactive vs. batch usage

You can use Tcl in two ways, either **interactive** or **batch** modes.

_Interactive_ mode means that you start a Tcl shell interpreter (can be `tclsh` but also Xilinx Vivado or the XSim simulator standalone)
and then you type Tcl commands interactively in the shell. This is very useful to test commands, rapid prototyping etc.

As an example:

```
% tclsh
Tcl version 8.5

Loading C:\Users\username\tclshrc.tcl

tclsh$
```

<br />

You can also collect multiple Tcl statements into a **script** and then ask the Tcl interpreter to execute all statements
line by line sequentially. This is usually done by "sourcing" the script with the `source` command:

```
source /path/to/script.tcl
```

<br />

In this case you work in _non-iteractive_ mode, also referred to as _batch_ mode.
More in general a Tcl script can be also executed from the command-line when invoking `tclsh` or Xilinx tools.

Here a few examples encountered through the course:

```
% tclsh scripts/sim/compile.tcl

% xsim -gui -tclbatch scripts/sim/run.tcl tb_Inverter

% vivado -mode gui -source scripts/common/ip.tcl 
```

<br />
<!--------------------------------------------------------------------->


## Tcl commands and Xilinx-specific Tcl commands

In this course we use both native Tcl commands and Xilinx-specific Tcl commands. Always bear in mind this difference.

As an example:

```
set PART xc7a35ticsg324-1L

create_project -force -part ${PART} myCoolProject -verbose
```

<br />

The `set` statement is native Tcl syntax to define a variable named `PART` with value `xc7a35ticsg324-1L`, but
of course `create_project` is a command not part of the Tcl programming language, being specific to Xilinx Vivado instead.

<br />
<!--------------------------------------------------------------------->


## Scripts

Scripts are **plain-text files** collecting sequences of Tcl commands. Thus you create/edit Tcl scripts with a **text-editor application**
such as Gedit or Notepad++ as used to create/edit HDL sources or other text-based sources:

```
% gedit script.tcl &

% n++ script.tcl
```

<br />

The `.tcl` extension helps you in recognizing that the source file contains Tcl code.

<br />
<!--------------------------------------------------------------------->


## Comments

Any comment in Tcl start with the `#` character:

```
# this is a comment in Tcl
```

<br />

If you need to comment multiple-lines simply start each line with the `#` character:

```
# this is a comment in Tcl
# distributed over
# multiple lines
```

<br />

Unfortunately there is no C/C++ equivalent for multi-lines comment using `/*` and `*/`, if you need to comment-out
multiple lines each line has to start with the `#` character.

A workaround to solve this limitation is to use the `if` statement to disable the portion of code that you don't want to execute:

```
if { 0 } {

   ...
   ...
   ...

}
```

<br />
<!--------------------------------------------------------------------->


## Print on the Tcl console (puts)

Use the `puts` command to display text messages on the Tcl console:

```
puts "Print this message in the Tcl shell"
```

<br />
<!--------------------------------------------------------------------->


## Variables (set)

Variables in Tcl are assigned using the `set` command:

```
set variableName  variableValue
```

<br />

You always have to assign a value to a variable, otherwise the statement is incorrect.
The Tcl language is **dynamically typed**, therefore you don't have to declare data types such as integer, float/double or string.
Everything in Tcl is actually a **string**. Internally, variables have types like integer, double etc. but data types are
automatically handled for you by the interpreter.

Example:

```
set a  10
set b  3.141592
set c  "Xilinx"
```

<br />

You can also redefine a variable at any time, also changing the data type:

```
set a  10
...
...
set a  3.141592
```

<br />

Once a variable is defined, use `$variableName` in order to access to the value stored in the variable.
This operation is referred to as **variable substitution**.

Example:

```
set PART  xc7a35ticsg324-1L
puts "Target FPGA set to $PART"
```

<br />

You can also use `${variableName}` for the same purpose:

```
puts "Target FPGA set to ${PART}"
```

<br />

The usage of curly brackets `{` `}` when accessing the value prevents errors in case the variable name might get mis-interpreted.

Example:

```
set dotted.name 1
puts $dotted.name
  => can't read "dotted": no such variable
puts ${dotted.name}
1
```

<br />
<!--------------------------------------------------------------------->


## Get exported environment variables (env)


```
set variableName $::env(ENVIRONMENT_VARIABLE)
```


<br />
<!--------------------------------------------------------------------->

## Lists

You can combine multiple objects to form **lists**. In Tcl lists are identified by curly brackets `{` and `}`.
Since at the end everything is a string in Tcl you can group in the same list items of different "data types".

Example:

```
set myList { 10 3.141592 "Xilinx" }
```

<br />

You can also create lists with the `list` command:

```
set myList [list 10 3.141592 "Xilinx"]
```

<br />

You can access list item with `lindex`:

```
puts [lindex $myList 2]
  => Xilinx
```

<br />

Use the `llength` command to get the number of items in the list:

```
puts [llength $myList]
   => 3
```

<br />

You can also dynamically add items to a list with the `lappend` command.

Example:

```
set RTL_SOURCES {} ;   ## this is an empty list

lappend RTL_SOURCES rtl/filename1.v
lappend RTL_SOURCES rtl/filename2.v
lappend RTL_SOURCES rtl/filename3.v
```

<br />

You can **concatenate** more lists into a bigger list with the `concat` command:

```
set list1 {1 2 3}
set list2 {4 5 6 7 8}
set list3 [concat $list1 $list2]
```

<br />
<!--------------------------------------------------------------------->


## Command evaluation

Since everything in Tcl at the end is considered as a string you need a way to **evaluate** Tcl commands.

As an example, `current_design` in Vivado returns the name of the top-level module, but

```
puts current_design
```

<br />

prints in the Tcl console the string "current_design".

In order to force Tcl to evaluate statements as commands you have to enclose the command between square brackets `[` and `]` as follows:

```
puts [current_design]
```

<br />

As you can see the output of a command can become the input for another command and you can nest commands evaluation as many times as you want.

Example:

```
puts "Total number of input ports in top-level RTL module: [llength [all_inputs]]"
```

<br />

In this case `all_inputs` returns a list of all top-level input ports, and the list is passed to `llength` to determine
the length of the list.

The output of a command can be also assigned to a variable:

```
set Ninputs   [llength [all_inputs]]
set Noutputs  [llength [all_outputs]]
```

<br />

>
> **IMPORTANT !**
>
> Since square brackets `[ ]` are used to indicate "command evaluation" you can immediately recognize that this
> is an issue when working with **signal buses** that also use `[ ]` to access bus items.
>
> As an example, we use `get_ports` in Xilinx Design Constraints (XDC) to map top-level RTL ports into physical FPGA pins,
> however in case of HDL signals declared as buses we have to prevent `[ ]` to be used for command evaluation.
> This is done by adding curly brackets `{ }` around the signal name.
>
> As an example,
>
> ```
> get_ports Z[0]
> ```
>
> gives an error, because `[0]` for Tcl means "evaluate" what is between `[` and `]` (nothing in this case). The following command
> works fine instead, because curly brackets `{ }` means "this is just a string":
>
> ```
> get_ports {Z[0]}
> ```
>

<br />
<!--------------------------------------------------------------------->


## Evaluate arithmetic expressions (expr)

Use the `expr` command to perform numerical computations.

Examples:

```
puts [expr 10 + 2]
```

```
set a 10
set b 2
set c [expr $a + $b] 
```

<br />
<!--------------------------------------------------------------------->


## Execute shell commands (exec)

Use the `exec` command to invoke shell executables from Tcl. You can run from Tcl any executable that is found in the system search path.

```
exec <shell command>
```

Example:

```
exec xvlog $VLOG_SOURCES
```

<br />

In order to capture the output of the command in the Tcl console you have to use the **redirection operator** `>` as follows: 

```
exec xvlog $VLOG_SOURCES >@stdout 2>@stdout
```

<br />
<!--------------------------------------------------------------------->


## if/else statement

```
if { condition } {

   ...
   ...
}
```


```
if { condition } {

   ...
   ...

} else {

   ...
   ...
}
```

```
if { condition } {

   ...
   ...

} elsif {

   ...
   ...

} else {

   ...
   ...
}
```

<br />
<!--------------------------------------------------------------------->


## for loop


```
for {set k 0} { $k < 10} {incr k} {

   ...
   ...
}
```

<br />
<!--------------------------------------------------------------------->


## foreach loop


```
foreach item {list of items} {

   ...
   ...
}
```


Example:

```
foreach p [get_ports] {

   puts "Port name: $p"
}
```

<br />
<!--------------------------------------------------------------------->

