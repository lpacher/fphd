
# Basic Linux shell commands
[[**Home**](../../README.md)] 

This is a collection of most important **Linux shell commands used for the course**.
All commands can be also used under Windows <br /> in the _Command Prompt_ assuming that
you installed and configured the **GNU Win** package as described [**here**](../../fpga/labs/lab0/README.md#add-linux-executables-to-search-path).

See also:

* _<https://linuxize.com/post/basic-linux-commands>_
* _<https://www.hostinger.com/tutorials/linux-commands>_
* _<https://maker.pro/linux/tutorial/basic-linux-commands-for-beginners>_
* _<https://www.guru99.com/must-know-linux-commands.html>_


<br />

## Jargon terms

**SHELL**

Indicates a **text-based interface** that allows to interact with the operating system. For our purposes we will simply refer to the shell <br />
also as _terminal_, _console_, _command line_, _command interpreter_ etc. despite in computer technology they are not the same thing.

For the course we assume to use the Linux **Bash shell** and the **Tcl shell** to run all flows.


See also:

* _<https://www.hanselman.com/blog/whats-the-difference-between-a-console-a-terminal-and-a-shell>_
* _<https://askubuntu.com/questions/506510/what-is-the-difference-between-terminal-console-shell-and-command-line>_

<br />


**PROMPT**

The **string** of characters indicating _"I'm ready to accept a command and execute it"_. That is, we usually **type a command** after <br />
the "prompt string" and then we press the **RETURN key** in order to **execute** the command itself.

Examples:

```
C:\Users\username>

[username@hostname ~]$

bash$ etc.
```

<br />

All **cut-and-paste instructions** written in README files have the `%` character to indicate a generic "prompt" for both Linux and Windows
command line applications:

```
% command
```

<br />

>
> **IMPORTANT !**
>
>
> **THE `%` SYMBOL IS NOT PART OF THE COMMAND TO BE COPIED OR TYPED IN THE TERMINAL !**
>

<br />

**STANDARD OUTPUT (stdout)**

Most of commands generate some output results that are printed on the screen of the terminal, referred to as
the "standard output" (stdout). If a command generates errors this information goes to the "standard error" (stderr) instead.


<br />

**TAB COMPLETION**

The capability of the shell program to **automatically complete partially-typed commands** pressing the **TAB key**.
This is a very important feature for less-typing that allows to save time when working at the command line.

```
% comm <TAB>  => command
```

Example:

```
% cd Desk <TAB>   => cd Desktop
```

<br />

>
> **IMPORTANT !**
>
> The default TAB completion of the Windows _Command Prompt_ is terrible. In order to have a Linux-like TAB completion
> also under Windows you have to install **Clink** as described [**here**](../../fpga/labs/lab0/README.md#install-a-Linux-like-tab-completion).
>

<br />


**SEARCH PATH**

The **list of directories** in which the shell program searches the executable of the command you want to run.
Both Linux and Windows systems use the `PATH` **environment variable** for this purpose.

If you obtain a "command not found" error when you type a command and then you press the RETURN key
either the command is wrongly typed or it is not found in the search path.

Examples:

```
% vivadoooooo -mode gui   => the command is wrongly typed, the Vivado executable is 'vivado'

vivadoooooo: command not found

% vivado -mode gui        => the command is right, so very likely it's not found in the search path

vivado: command not found
```

<br />

You can always use the `which` command to verify if a command executable is found in the search path.

Example:

```
% which mkdir
```

If a command exists but is not found then you have to **extend the search path**, that is update the `PATH` environment
variable in order to include also the directory containing the executable that you want to run.

<br />

**HOME DIRECTORY**

The main directory that has been created on the system for your account:

```
/home/username   => Linux
```

```
C:\Users\username   => Windows
```

The path to the user's home directory is contained in the reserved `HOME` environment variable on Linux
and `USERPROFILE` on Windows:

```
% echo $HOME   => Linux
```

```
% echo %USERPROFILE%   => Windows
```

<br />

>
> **WARNING**
>
> In Linux the home directory is also identified by tilde character `~`, however this syntax doesn't work natively
> in the Windows _Command Prompt_. You can use `~` on Windows only if you start a `bash` session.
>
<br />

<br />
<!--------------------------------------------------------------------->



## Command help

Short console help:

```
% command --help
```

Example:

```
% mkdir --help

Usage: mkdir [OPTION]... DIRECTORY...
Create the DIRECTORY(ies), if they do not already exist.

Mandatory arguments to long options are mandatory for short options too.
  -m, --mode=MODE   set file mode (as in chmod), not a=rwx - umask
  -p, --parents     no error if existing, make parent directories as needed
  -v, --verbose     print a message for each created directory
  -Z                   set SELinux security context of each created directory
                         to the default type
      --context[=CTX]  like -Z, or if CTX is specified then set the SELinux
                         or SMACK security context to CTX
      --help     display this help and exit
      --version  output version information and exit

GNU coreutils online help: <http://www.gnu.org/software/coreutils/>
For complete documentation, run: info coreutils 'mkdir invocation'
```

<br />

Display the "man" (manual) page of a command:

```
% man command
```

<br />

>
> **NOTE**
>
> Man pages are not available under Windows for Linux executables that comes with the proposed GNU Win package! <br />
> The `--help` switch works on both Linux and Windows instead.
>

<br />
<!--------------------------------------------------------------------->


## Display the current working directory


```
% pwd   => Print Working Directory
```

<br />

>
> **REMIND**
>
> One dot `.` indicates the **current directory**, two dots `..` the **parent directory** instead.
>

<br />
<!--------------------------------------------------------------------->


## Changing directory


```
% cd /absolute/path/to/some/directory
```

```
% cd relative/path/to/some/directory    (same as cd ./relative/path/to/some/directory )
```

As a special case, use

```
% cd ..   (same as cd ../ )
```

in order to **move back to the parent directory**, that is the directory immediately above the current one.
You can move back as many levels as you want:

```
% cd ../../       => two-levels back
% cd ../../../    => three levels back etc.
```

Example:

```
% cd Desktop/lae/fpga/labs/lab0
% pwd
% cd ..
% pwd             => now you are in Desktop/lae/fpga/labs
% cd ../../
% pwd             => and now you are in Desktop
```

<br />

>
> **IMPORTANT !**
>
> The `cd` command is a **built-in command** part of the shell program itself, **not a standalone executable**!
> That is, there is no `cd` executable in the Linux shell, neither in the Windows one:
>
> ```
> % which cd
> cd: shell built-in command.
> ```
>
> ```
> % where cd
> INFO: Could not find files for the given pattern(s).
> ```
>
> <br />
>
> This is true also after installing the GNU Win package for Windows, when you type `cd` in the _Command Prompt_ you are
> invoking the native `cd` command from MS/DOS (there is no `cd.exe` executable as part of the GNU Win package).
> For this reason you cannot use special `cd` cases  as under Linux.
> 
> As a first example, if you just execute `cd` without a target directory:
>
> * you move to the **home directory** on Linux
> * it shows the **current working directory** on Windows (same as `pwd`)
>
> Additionally, in Linux `cd -` allows to come back to the previous working directory, while under Windows `-` is simply interpreted as a non-existing directory.
>
> If you work under Windows you can play a little bit to improve this and create an additional `doskey` for `cd` in the `login.bat` script
> and force the native command to behave like the Linux one as follows:
>
> ```
> doskey cd=if /i "$1" == "" ( cd /d %%USERPROFILE%% ^& set OLDCD=%%CD%% ) else ( if /i "$1" == "-" ( cd /d %%OLDCD%% ^& set OLDCD=%%CD%% ) else ( cd /d "$1" ^& set OLDCD=%%CD%% )) 
> ```
>
> With this solution the `if/else` statement parses what comes after the `cd` command and
> if you execute `cd` without a target directory you move to the user's home `%USERPROFILE%`,
> while `cd -` moves back to the previous working directory.
>

<br />
<!--------------------------------------------------------------------->


## Listing directory contents

List the content of the **current working directory**:

```
% ls
```

List the content of a specific directory:

```
% ls /path/to/some/directory   => can be absolute or relative path
```

As for the `cd` command you can use `..` to list the content of directories back in the hierarchy:

```
% ls ../
% ls ../../  etc.
```

The default output of the `ls` command shows only the names of the files and directories.
Use the `-l` option to list files and directories with more details (permissions, size, owner etc.)
in a table-like format:

```
% ls -l
```

Use the `-a` option to display **all** files, including also **hidden files and directories** (those files and directories
that have a dot `.` as a first character in the name, e.g. `.solutions` or `.gitignore`) :

```
% ls -la
```

Example:

```
% cd Desktop/lae
% ls
% ls -l
% ls -la
```

<br />

>
> **NOTE**
>
> Since `ls -l` and `ls -la` commands are used very often it is a common practice to create **aliases** for them
> in the shell login script.
>
> For Linux users:
>
> ```
> alias l="ls -l $@"
> alias ll="ls -la $@"
> ```
>
> For Windows users:
>
> ```
> doskey l=ls -l $*
> doskey ll=ls -la $*
> ```

<br />
<!--------------------------------------------------------------------->


## Displaying text files contents

Use `cat` to show the **whole content** of a text file in the terminal:

```
% cat filename
```

If you want to explore the file slowly "page" after "page" use `more` or `less` instead.
The `more` command shows the content of the file one page at a time, but you can **only scroll down** the text
with the down arrow key:

```
% more filename
```

The `less` command is smarter and allows also to **scroll backward** using the **up arrow** key:

```
% less filename
```

Either if you use `more` or `less` you will have to press the **Q key** to quit the program and come back to
the shell.

Example:

```
% cd Desktop/lae
% cat README.md
% more README.md
% less README.md
```



<br />
<!--------------------------------------------------------------------->


## Creating empty text files 

```
% touch filename
```

You can also use the `echo` command along with the `>` redirection operator:

```
% echo > filename
```

<br />

>
> **WARNING**
>
> If `filename` already exists the `touch` command simply changes the time of the last access/modification to the file. 
> Be aware that the above `echo` command **deletes** the entire content of `filename` if the file already exists!
>
<br />
<!--------------------------------------------------------------------->


## Creating directories

Use `mkdir` to create a new directory:

```
% mkdir dirname
```

You can also create more directories at the same time:

```
% mkdir dirname1 dirname2 dirname3
```

The target of the `mkdir` command can be also a path (either absolute or relative):

```
% mkdir /path/to/new/directory
```

If the directory already exists `mkdir` generates an error. Use the `-p` switch to suppress the error:

```
% mkdir -p dirname
```

Use the `-p` switch also to automatically create all intermediate parent directories in a nested tree:

```
% mkdir -p parent/child1/child2
```

<br />
<!--------------------------------------------------------------------->


## Copying files and directories

Copy the file from the current directory into the same directory (usually a backup):

```
% cp filename filename.bak
```

To copy a file to another directory, specify the absolute or the relative path to the destination directory:

```
% cp filename /path/to/directory   => filename is copied as /path/to/directory/filename
```

Copy and rename the file:

```
% cp filename /path/to/directory/filename2   => filename is copied as /path/to/directory/filename2
```


Use the `-r` switch to copy a directory recursively including all its files and subdirectories:

```
% cp -r dirname /path/to/directory
```

<br />

>
> **REMIND**
>
> You can always use the `*` **wildcar character** to match several files at the same time:
>
> ```
> % cp ./solutions/scripts/sim/*.tcl  ./scripts/sim
> ```
>

<br />
<!--------------------------------------------------------------------->



## Removing files and directories

<br />

>
> **IMPORTANT !**
>
> Deleting a file or a directory with `rm` is a **NON RECOVERABLE** operation!
> Once you remove the file you cannot come back, it's not moved in the "trash" icon on your Desktop, so
> **BE CAREFUL** in order to avoid disasters!
> 

<br />

Remove a single file:

```
% rm filename
```

```
% rm /path/to/filename   (either absolute or relative path)
```

Remove more files at the same time:

```
% rm filename1 filename2 /path/to/filename3
```


Add the `-r` switch to recursively delete a directory and its contents:

```
% rm -r dirname
```

```
% rm -r /path/to/directory
```

As for `mkdir`, also `rm` generates an error in case the file does not exist. Use the `-f` switch to
force the operation and ignore errors:

```
% rm -f filename
```

```
% rm -rf dirname
```

<br />

>
> **REMIND**
>
> You can always use the `*` **wildcar character** to match several files at the same time:
>
> ```
> % rm log/*.log   => delete ALL files ending with .log from the log/ directory
> ```
>

<br />

<!--------------------------------------------------------------------->


## Moving and renaming files and directories

The primary use of the `mv` command is to move files from one place to another:

```
% mv filename /path/to/directory   => filename is moved into /path/to/directory with the same name
```

```
% mv dirname /path/to/new/directory
```

More in general, you can also change the name:

```
% mv filename filename2  => rename the file
```

```
% mv dirname dirname2  => rename the directory
```


<br />
<!--------------------------------------------------------------------->


## Printing on the screen

```
% echo "something to print"
```

<br />
<!--------------------------------------------------------------------->


## Output redirection

```
% command > filename.log
```

```
% command1 | command1 
```

<br />
<!--------------------------------------------------------------------->

## Searching patterns

```
% grep pattern filename
```

```
% cat filename | grep pattern
```

Example:

```
% cd Desktop/lae
% grep tcl ./sample/tclshrc.tcl
```

