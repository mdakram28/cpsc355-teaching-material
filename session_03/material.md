# Session 03: Intro to Assembly & GDB

## Date: September 20, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. Writing and compiling an assembly program
2. Debugging using gdb


---
## 1. Writing and compiling an assembly program

- Save your assembly code with the file extension `.s`
- Compile the `.s` assembly code file to `.o` executable binary file.
	```bash
	gcc code_file.s -o code_file.o -g
	```
	- The `-g` flag tells gcc to add debug information to the binary executable. Use it when you plan to debug the created binary using **gdb**.




---
## 2. Debugging using `gdb`

TO open the program in `gdb`:
```
gdb my_asm.o

```

---
## Useful `gdb` commands

Full command | Abbreviation | Description
--- | --- | ---
`break temp.c:28` | `b temp.c:28` | Set a breakpoint in the file `temp.c` at line 28
`break flabel_name` | `b label_name` | Set a breakpoint at the start of the `label_name` label. 
`run` | `r` | Start the program and run until the end of the program/the program crashes/the next breakpoint/the next watchpoint (if the program is already running, this command will tell the program to start from the beginning)
`continue` | `c` | Continue running until the end of the program/the program crashes/the next breakpoint/the next watchpoint
`next/nexti` | `n/ni` | Execute the current command, and move to the next command in the program. The `i` variant will execute a single instruction instead of a line. 
`step/stepi` | `s/si` | Step through the current command, but if this command is a function call, then go to the first line of that function. The `i` variant will execute a single instruction instead of a line. 
`print x` | `p x` | Print the value of the register `x`. 
`print/x x` | `p/x x` | Print the value of the register `x` in hexadecimal 
`info breakpoints` | `i b` | Display information about all declared breakpoints
`info registers` | `i r` | List all registers and their values. 
`delete breakpoints` | `delete` | Delete all breakpoints that have been set
`clear label_name` | | Deletes the breakpoint set on `label_name` 
`quit` | `q` | Exit `gdb`
