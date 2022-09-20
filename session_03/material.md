# Session 03: Intro to Assembly & GDB

## Date: September 20, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. Writing and compiling an assembly program


---
## 1. Writing and compiling an assembly program

- Save your assembly code with the file extension `.s`
- Compile to `.s` assembly code file to `.o` binary executable file.
	```bash
	gcc code_file.s -o code_file.o -g
	```
	- The `-g` flag tells gcc to add debug information to the binary executable. Use it when you plan to debug the created binary using **gdb**.



---
## 2. 
