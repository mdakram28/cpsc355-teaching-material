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
```bash
$ gdb my_asm.o
GNU gdb (GDB) Fedora 12.1-1.fc36
Copyright (C) 2022 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "aarch64-redhat-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from my_asm.o...
(gdb)

```
