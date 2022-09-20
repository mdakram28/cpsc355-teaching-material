# Session 03: Intro to Assembly & GDB

## Date: September 20, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. Compiling an assembly program
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
## 2. ARM Assembly Example

Proram to print hello world 10 times.

```assembly
# AARCH64 assembly tutorial example 01

		// Tell GCC to use printf function from outside this code
        .extern printf
fmt:
        .string "x19 = %d Hello World!\n"			// String to send to printf


		// Main function
        .balign 4						// Align instructions to word
        .global main					// Make main function visible to outside this code
main:
        stp     x29, x30, [sp, -16]!    // Save FP and LR to stack
        mov     x29, sp					// Update FP to current SP
		
		// Initialize loop counter
        mov     x19, #1;				// x19 starts from 1
loop_top:								// Loop starts here
        cmp     x19, #10				// Compare x19 to 10
        b.gt    loop_end				// If x19 > 10 then goto loop_end

		// Call printf external function
        ldr     x0, =fmt				// First argument is the pointer to format string
        mov     x1, x19					// Second argument is the integer to replace "%d"
        bl      printf					// Call printf

        add     x19, x19, #1			// Increment loop counter
        b       loop_top				// Repeat loop
loop_end:
        b       exit					// Goto Exit (Not needed here)

exit:
        // return 0
        mov x0, 0						// Return value 0 is stored in x0
        ldp x29, x30, [sp], 16			// Restore FP and LR from stack pointer
        ret								// Go back to the callee


```





---
## 3. Debugging using `gdb`

TO open the program in `gdb`:
```bash
gdb my_asm.o
```





---
## 3. Useful `gdb` commands

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
 `x addr`             |                | Inspect memory at address (Prints 32 bytes hex value by default) 
`x/s addr` |  | Print the string starting at `addr` and ending with a `\0` 
`info breakpoints` | `i b` | Display information about all declared breakpoints
`info registers` | `i r` | List all registers and their values. 
info registers x19 | i r x19 | Print the value of regsiter x19 
`delete breakpoints` | `delete` | Delete all breakpoints that have been set
`clear label_name` | | Deletes the breakpoint set on `label_name` 
`quit` | `q` | Exit `gdb`
