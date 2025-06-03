
# Known problems and solutions


## bash.exe: warning: could not find /tmp, please create

On Windows, the `bash.exe` that comes with **Git for Windows** (and also included in the **GNU Win** `.zip` file)
gives this error.

#### Solution

Launch `bash` in the _Command Prompt_ and create the missing directory:

```
% bash

Loading C:\Users\username\.bashrc

bash$ mkdir /tmp
bash$ exit
```
<br />

Credits:

_<https://stackoverflow.com/questions/22492715/bash-exe-warning-could-not-find-tmp-please-create>_

<br />
<!--------------------------------------------------------------------->


## ERROR: [XSIM 43-3409] Failed to compile generated C file xsim.dir/xxx/obj/xsim_1.c.

When running the proposed **test flow** students working with **Linux Ubuntu** reported
that by default `make elaborate` fails with the following error:

```
ERROR: [XSIM 43-3409] Failed to compile generated C file xsim.dir/tb_Counter/obj/xsim_1.c.
ERROR: [XSIM 43-3915] Encountered a fatal error. Cannot continue.
Exiting...
```

#### Solution

The source of the error is due to **missing dependencies** installed on the system.
In particular the `clang` compiler that comes with the Vivado installation requires `libncurses.so`
which might be not installed. This can be easily solved by installing the following packages:

```
sudo apt-get install libncurses5 libtinfo5
```
<br />

Credits:

_<https://support.xilinx.com/s/question/0D52E00006iHlpQSAS/vivado-20172-simulation-xsim-433409-failed-to-compile-generated-c-file?language=en_US>_

