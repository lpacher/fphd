<div align="justify">

# ROOT and PyROOT installation references

The easiest way to download and install the ROOT package by CERN is to use **pre-compiled binaries**
made available by the ROOT development team for most common operating systems (Windows, MacOS and Linux).

For this course a ROOT version **5.34.32** still using the legacy **CINT** C/C++ interpreter will be assumed:

_<https://root.cern/releases/release-53432/>_

<br />

Feel free of course to install a newer **6.x** version that uses the new **Cling** C/C++ interpreter instead.
The complete list of ROOT releases is available at the following link:

_<https://root.cern/install/all_releases/>_

<br />

Since ROOT 5.34.32 has been compiled against **Python 2.7 x86 (32-bit)** you will also need on your machine
a Python installation matching this **exact version** if you want to **run ROOT from Python (PyROOT)**.

<br />
<!--------------------------------------------------------------------->


## Linux users

Simply download and extract the pre-compiled `.tar.gz` file already prepared for you by CERN
starting from the following page:

_<https://root.cern/releases/release-53432/>_

<br />

Pre-compiled versions are available for several Linux distributions with no major differences between one distribution and another.
However it might be useful to check the `gcc` version before selecting the download:

```
% gcc --version
```

<br />

As an example, if you run **Linux Ubuntu** with **gcc4.8** use the following pre-compiled `.tar.gz` file:

_<https://root.cern/download/root_v5.34.32.Linux-ubuntu14-x86_64-gcc4.8.tar.gz>_

<br />

You can easily perform the installation at the command line as follows:

```
% cd ~/
% mkdir -p local/ROOT
% cd local/ROOT
% wget https://root.cern/download/root_v5.34.32.Linux-ubuntu14-x86_64-gcc4.8.tar.gz
% tar -xzf root_v5.34.32.Linux-ubuntu14-x86_64-gcc4.8.tar.gz
% ls -l
% mv root 5.34.32
% rm root_v5.34.32.Linux-ubuntu14-x86_64-gcc4.8.tar.gz
```

<br />

Feel free of course to change the target installation directory as usual depending on your needs, e.g. `/opt/ROOT/`.
Once done simply update the `.bashrc` initialization file with the following setup:

```
## ROOT/PyROOT setup for data analysis
export ROOTSYS=$HOME/local/ROOT/5.34.32
source $ROOTSYS/bin/thisroot.sh
set PYTHONPATH=$ROOTSYS/bin:$PYTHONPATH
```

<br />

Save and exit once done. Finally check if the `root` executable is properly found
in the search path:

```
% source ~/.bashrc
% which root
```

<br />

Python 2.7 should be already installed on your Linux system by default. Double-check this with:

```
% which python
% python -V
```

<br />


## Windows users

Simply download and extract both ROOT and Python pre-compiled `.zip` files already prepared for you.
If GNU Win is properly installed you can use `wget` and `unzip` utilities at the command
line as follows:

```
% cd C:\Users\<username>
% mkdir -p local
% cd local
% wget https://www.to.infn.it/~pacher/teaching/FPGA/software/windows/ROOT.zip
% wget https://www.to.infn.it/~pacher/teaching/FPGA/software/windows/Python.zip
% unzip ROOT.zip
% unzip Python.zip
% rm -f ROOT.zip Python.zip
```

<br />

Feel free of course to change the target installation directory as usual, e.g. `C:\opt`
or `D:\local` etc. depending on your needs. Once done update the `login.bat` initialization file
with the following setup:

```
:: Python 2.7 setup
set PATH=C:\users\<username>\local\Python\2.7\x86;%PATH%

:: ROOT/PyROOT setup for data analysis
set ROOTSYS=C:\users\<username>\local\ROOT\5.34.32
call %ROOTSYS%\bin\thisroot.bat
set PYTHONPATH=%ROOTSYS%\bin;%PYTHONPATH%
```

<br />

Save and exit once done. Finally check if both `root.exe` and `python.exe` executables are properly found
in the search path:

```
% call login.bat
% where root
% where python
% python -V
```

<br />
<!--------------------------------------------------------------------->


## Installation check

A couple of minimal ROOT and PyROOT scripts have been already prepared for you to quickly verify your
local ROOT/PyROOT installation. You can run them from the command line as follows:

```
% cd Desktop/lae/sample/ROOT
% root histo.cxx
% python -i histo.py
```

<br />

In case of troubles in running PyROOT double-check also that ROOT and Python versions matches together:

```
% python -V                     => 2.7
% root-config --python-version  => 2.7.x  (Linux-only users)
``` 

</div>
