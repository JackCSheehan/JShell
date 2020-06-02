# JShell
A simple Linux shell written entirely in x86 NASM assembly language.

## Commands
Below is a tentative, work in progress list of JShell's commands that are either currently implemented or are planned to be implemented.

### Quit
Quits JShell.
```
$ quit
```

### Make File
Creates a new file with the given name. Specify path and filename in the *path* argument.
```
$ mkf <path>
```

### Make a Directory
Creates a new directory. Specify path and filename in the *path* argument.
```
$ mkdir <path>
```

### Remove a File
Removes given file. Specify path and filename in the *path* argument.
```
$ rmf <path>
```

### Remove a Directory
Removes given directory. Specify path and filename in the *path* argument.
```
$ rmdir <path>
```

### Rename a File
Renames given file. Specify path and filename in the *path* argument.
```
$ rn <path>
```

### Print Contents of File
Prints the contents of a file. Specify path and filename in the *path* argument.
```
$ print <path>
```

### List Contents of Directory
Lists the contents of a directory. Specify path and filename in the *path* argument. If no path given, will list contents of current directory.
```
$ lst [path]
```

### Run Program
Runs the given program at the location given in *path.* Any arguments provided after the *path* arg will be passed as a command line argument to the programming being called.
```
$ run <path> [args...]
```

### Get Time
Returns the current time in Unix time.
```
$ time
```

### Change Working Directory
Changes working directory to the given path.
```
$ cd <path> 
```

### Reboot
Reboots system. Requires 'confirm' to prevent accidental reboots.
```
$ rb confirm
```

