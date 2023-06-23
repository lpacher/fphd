# Short git command-line usage summary

A small collection of most frequentely used `git` commands for your day-to-day work and common tasks. 


### Jargon terms

**master** => THE main branch, should always represent the stable version of the project

**remote** => a branch on the GitHub remote server 

**origin** => misleading term, it's just the default **alias** for the address of the 
              remote repository, i.e. `https://github.com/lpacher/lae.git`. This URL is returned by `git config --get remote.origin.url`


### General usage

```
% git <command> [options] [target]
```

### Command help

Short help:

```
% git <command> -h 
```

Complete manual page:

```
% git <command> --help
```

Example:

```
% git clone -h
% git clone --help
```


### Git configuration

Some useful aliases and configurations:

```
% git config --global alias.root "rev-parse --show-toplevel"    # create a "git root" alias to easily locate the Git top-level directory
% git config --global alias.co 'checkout'                       # allows to use "git co" instead of "git checkout"
% git config color.ui true                                      # enable better display with colors

```



### Repository download

```
% cd Desktop
% git clone https://github.com/lpacher/lae.git [target directory]
```

**NOTE**: This is equivalent to:

```
% cd Desktop
% mkdir lae (or mkdir <target directory>)
% cd lae
% git init
% git remote add origin https://github.com/lpacher/lae.git
% git pull origin master
```


### List all available branches on remote server

There are many different commands for this:

```
% git branch --remote
```

or 

```
% git remote show origin
```

or

```
% git ls-remote
```

**WARNING**: Always **fetch** latest updates from the remote server with `git fetch` before running these commands, otherwise new branches
created on the server will not be listed.


### Checkout an existing branch

```
% git checkout <branch name>
```

**WARNING**: Be sure to commit all your local changes to tracked files before changing working branch !




### Display a list of all checked-out branches

```
% git branch
```

**NOTE**: The * indicates the current working branch.


### Changing working branch

```
% git checkout <branch name>
```


### Display commits history (log file)

```
% git log [with many options available]
```



### Display working branch status

This shows you all modified files, committed files and untracked files:

```
% git status [--verbose]
```


### Fetching 

Retrieve **all updates** (commits and new branches) published by other people into the remote server:

```
% git fetch
```

Use instead

```
% git fetch origin <branchName>
```

to fetch only from the specified branch.


**NOTE**: Fetching from a repository grabs all the new remote-tracking branches
and tags **without merging those changes** into your own branches.




### Stage and commit

```
% git add /path/to/filename1
% git add /path/to/filename2
% git add /path/to/filename3
% git commit -m "Commit message for those 3 modified files"
% git add /path/to/filename4
% git commit -m "Commit message for the 4th modified file"
```

**NOTE**: You can add as many commits as you wants, also multiple-commits on the
same file for different changes. All commits will be pushed into remote repository after a `git push`.


### Undo a git add (i.e. remove files staged for a git commit)

```tcsh
% git reset /path/to/filename
```

To undo `git add .` use instead

```tcsh
% git reset
```

without the dot.


### Discard changes to a file in working directory

```tcsh
% git checkout -- /path/to/filename
```


### Edit the commit messagge

In case your last-commit message contains typos/missing information and thus requires
changes you can **amend** it :

```tchs
% git commit --amend
```

Then enter the new commit messagge.


### Adding more changes to your last commit

In case you already issued a `git commit` but you want to add modified file(s) to the last commit :

```tcsh
% git add /path/to/filename [/path/to/another/filename]
% git commit --amend
```

If you don't want to change your commit message, you can run the `--amend` command with the `--no-edit` flag :

```tcsh
% git commit --amend --no-edit
```


### Pushing an amended commit

```tcsh
% git push -f origin <branchName>
```



### Renaming files and directories

```
% git mv oldFileName newFileName
% git commit -m "Why you changed the file name"
```

**WARNING**: **DO NOT USE** a standard UNIX `mv` on tracked files !


### Deleting files and directories


```
% git rm /path/to/filename
% git rm -r /path/to/directory
% git commit -m "Why you removed the file/directory"
```

**WARNING**: **DO NOT USE** a standard UNIX `rm` on tracked files !



### Merging from other branches

```
% git pull origin <branchName>
```

This is equivalent to:

```
% git fetch
% git merge
```


### Resolve merge conflicts

Git is smart-enough to try to merge all non-conflicting differences seen in a file that has been modified both 
by you and by someone else. However, in case of a merge conflict you have to fix it yourself. 
To do this, open the file/files for editing and manually fix conflicts enclosed between

```
<<<<<<< HEAD
Local version of the code creating the conflict
=======
Remote version of the code creating the conflict
>>>>>>> [other/branch/name]
```

After having fixed all conflicting lines, save the file and perform a `git commit` to mark the conflict as resolved.

**NOTE**: There are also many text-based and GUI-based merging tools. Just call `git mergetool` after having configured the tool to be used, e.g.

```
% git config --global merge.tool vimdiff
```


### Uploading changes to the remote server

```
% git push origin <branch name>
```


### Rename a branch

To rename a branch, either use :

```
% git branch -m <newBranchName>    # inside the branch you want to rename
```

or

```
% git branch -m <branchName> <newBranchName>  # from any other different branch
```

To push this branch-renaming to the remote server, then use :

```
% git push origin :<oldBranchName> <newBranchName>
% git push origin -u <newBranchName>
```


### Delete feature branches (both local and remote)


```
% git checkout devel
% git branch -d <branchName>                   # removes your LOCAL branch <branchName>
% git push origin --delete <branchName>        # removes the REMOTE branch <branchName>
```

**WARN**: You cannot delete a checked-out branch ! Change working branch before deleting your feature branch.


### Tag master releases

```
% git checkout master
% git pull origin devel
% git push origin master
% git tag -a <tagName> -m "Tag message"
% git push origin <tagName>
```

