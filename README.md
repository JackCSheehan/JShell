# JShell
A simple Linux shell written entirely in x86 assembly language using the NASM syntax. I wrote JShell to teach myself assembly and to familiarize myself with a few of the basic Linux syscalls.

## Commands
Below is a list of JShell's commands.

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
$ mkdr <path>
```

### Remove a File
Removes given file. Specify path and filename in the *path* argument.
```
$ rmf <path>
```

### Remove a Directory
Removes given directory. Specify path and filename in the *path* argument.
```
$ rmdr <path>
```

### Rename a File
Renames given file or directory. First argument is the path to the old file or directory, second arg is the new name for that file or directory.
```
$ rn <old> <new>
```

### Print Contents of File
Prints the contents of a file. Specify path and filename in the *path* argument.
```
$ print <path>
```
