
# Known problems and solutions


## bash.exe: warning: could not find /tmp, please create

On Windows, the `bash.exe` that comes with **Git for Windows** (and also included in the **GNU Win** `.zip` file)
gives this error.

#### Solution

Launch `bash` in the _Command Prompt_ and create the missing directory :

```
% bash

Loading C:\Users\username\.bashrc

bash$ mkdir /tmp
bash$ exit
```

Credits :

_<https://stackoverflow.com/questions/22492715/bash-exe-warning-could-not-find-tmp-please-create>_


