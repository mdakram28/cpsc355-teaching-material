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
`help` | | Get help on a particular command, EG `help run`
`file FILE` | | Use `FILE` as program to be debugged.
`break temp.c:28` | `b temp.c:28` | Set a breakpoint in the file `temp.c` at line 28
`break f` | `b f` | Set a breakpoint at the start of the `f` function
`run` | `r` | Start the program and run until the end of the program/the program crashes/the next breakpoint/the next watchpoint (if the program is already running, this command will tell the program to start from the beginning)
`continue` | `c` | Continue running until the end of the program/the program crashes/the next breakpoint/the next watchpoint
`next` | `n` | Execute the current command, and move to the next command in the program (if the current command is a function call, then execute the whole function and return from it)
`step` | `s` | Step through the current command, but if this command is a function call, then go to the first line of that function
`finish` | | Run until the current function is finished and has returned
`until` | `u` | This is like `n`, except that if we are in a loop, `u` will continue execution until the loop is exited
| | | [No command] Repeat the previous command (useful if repeating the same command repeatedly, EG stepping through a loop)
`list` | | Print the current line, and a few lines above and below
`backtrace` | `bt` | List all the function calls in the stack frame at the current location
`frame N` | `f N` | Examine stack frame `N`, which gives access to the local variables in that stack frame. Frame zero is the innermost (currently executing) frame, frame one is the frame that called the innermost one, and so on. The highest level frame is usually the one for the `main` function. The frame numbers correspond to the numbers printed by the `backtrace` function.
`up N` | | Move `N` frames up the stack. `N` defaults to 1.
`down N` | | Move `N` frames down the stack. `N` defaults to 1.
`frame function func_name` | | Move up or down the stack frame to the frame inside the `func_name` function. If there are multiple stack frames for function `func_name` then the inner most stack frame is selected. See [Selecting a Frame](https://sourceware.org/gdb/onlinedocs/gdb/Selection.html) for more information.
`print x` | `p x` | Print the value of the variable `x`. If it is an array, the whole array is printed. The `->`, `*` and `.` operators can be used in case `x` is a struct/pointer/pointer to a struct, or even print the entire contents of the struct (see section [Printing `struct` types](#printing-struct-types) below for an example of printing out struct types)
`print/x x` | `p/x x` | Print the value of the variable `x` in hexadecimal
`print x[0]@4` | `p x[0]@4` | Print the first 4 values in the array pointed to by `x`. This is equivalent to the `gdb` command `print *x@4`. For more information, see [10.4 Artificial Arrays on sourceware.org](https://sourceware.org/gdb/current/onlinedocs/gdb/Arrays.html)
`printf` | | Print formatted text to the console window. The first argument should be a format string (using the same syntax as the format string in the [C `printf` function](https://www.cplusplus.com/reference/cstdio/printf/)), and subsequent arguments should be expressions, which can include [convenience variables](https://sourceware.org/gdb/onlinedocs/gdb/Convenience-Vars.html). The arguments to this function should be separated by commas, EG `printf "$x + 10 = %i\n", $x + 10` (assuming `$x` is an integer)
`eval` | | Send a command to `gdb`, using `printf` syntax to format the command. This is useful if the command depends on convenience variables, EG `eval "dump memory %s &multiples[0] &multiples[10]", $filename`. It can also be used to set convenience variables that depend on other convenience variables, EG `eval "set $filename = \"data/data_%i.bin\"", $i`
`set` | | Set a [convenience variable](https://sourceware.org/gdb/onlinedocs/gdb/Convenience-Vars.html). The name of the convenience variable should always start with `$`, including when it is set and every time it is used, EG `set $x = 5`, `printf "$x + 10 = %i\n", $x + 10`
`set var` | | Set the value of a variable in the program being debugged, EG `set var width=47`. Equivalent to `print width=47`, except that the return value is not printed ([source](https://sourceware.org/gdb/current/onlinedocs/gdb/Assignment.html))
`define` | | Create a user-defined command, which is essentially a user-defined function containing `gdb` commands. A user-defined command can contain any number (or even a variable number) of arguments. See [User-defined Commands](https://sourceware.org/gdb/current/onlinedocs/gdb/Define.html) for more information and examples
`ptype x` | | Print a detailed description of the type `x` (EG a `typdef struct`), or the type of a variable `x`, or the type of an expression `x`. Contrary to `whatis`, `ptype` always unrolls any typedefs in its argument declaration, whether the argument is a variable, expression, or a data type
`ptype /o x` | | If `x` is a struct, then print the sizes and offsets (in bytes) of each element in the struct
`whatis x` | | Print the data type of `x`, which can be either an expression or a name of a data type. With no argument, print the data type of `$`, the last value in the value history. If `x` is a variable or an expression, `whatis` prints its literal type as it is used in the source code. If `x` is a type name that was defined using `typedef`, whatis unrolls only one level of that `typedef`.
`x addr` | | Print value at memory location `addr`
`x/nfu addr` | | Examine memory in the specified format (see [sourceware.org: "Examining Memory"](https://sourceware.org/gdb/current/onlinedocs/gdb/Memory.html))
`watch x` | | Place a watchpoint on variable `x`, meaning that the program will pause whenever the value of `x` is modified, and the old and new values of `x` will be printed (if `x` is an array, then the program will pause and print out the old and new values of the whole array whenever any element of `x` is modified)
`condition N COND` | | Specify breakpoint number `N` to break only if `COND` is true (this can also be achieved using `break` in a single command using the syntax `break file.c:N if COND`)
`commands N` | | Specify a list of commands to run when breakpoint `N` is reached. If `N` is omitted, then `commands` refers to the last breakpoint, watchpoint, or catchpoint set (not to the breakpoint most recently encountered). The commands themselves appear on the following lines. Type a line containing just `end` to terminate the commands. You can use breakpoint commands to start your program up again, EG by using the `continue` command, or `step`, or any other command that resumes execution. See [Breakpoint Command Lists](https://sourceware.org/gdb/current/onlinedocs/gdb/Break-Commands.html) for more.
`info breakpoints` | `info b` | Display information about all declared breakpoints
`info variables` | | List all global and static variable names
`info locals` | | List local variables of current stack frame (names and values), including static variables in that function.
`info args` | | List arguments of the current stack frame (names and values)
`info symbol addr` | | Print the name of a symbol which is stored at the address `addr`. If no symbol is stored exactly at `addr`, GDB prints the nearest symbol and an offset from it
`delete breakpoints` | `delete` | Delete all breakpoints that have been set
`delete n` | | Delete breakpoint number `n`
`clear function_name` | | Deletes the breakpoint set in that function
`dump memory filename start_addr end_addr` | | Copy binary data starting at `start_addr` and ending at `end_addr` (not including `end_addr`) into a binary file called `filename`. `start_addr` and `end_addr` can refer to variables and use array and pointer operators, EG `dump memory x.bin x &x[20]`. See section [Using `dump` (and loading a binary file from Python)](#using-dump-and-loading-a-binary-file-from-python) below for an example of how to load this memory in Python
`dump value filename expr` | | Copy binary data starting from `expr` into a binary file called `filename`. If `expr` is the name of an array, then the whole array is copied, EG `dump value x.bin x` is the same as `dump memory x.bin x &x[20]` if x is an array of length 20
`restore filename binary bias start end` | | Restore the contents of binary file `filename` into memory
`set max-value-size unlimited` | | Remove the limit on the maximum value size. This can be useful when trying to use the `dump` command on a value which is too big, in which case an error message will be displayed which says `value requires 115202 bytes, which is more than max-value-size` (or similar)
`set logging on` | | Enable logging
`set logging file filename` | | Tell `gdb` to store logging outputs in a file called `filename` (without calling this command, the default filename for logging outputs is `gdb.txt`)
`quit` | | Exit `gdb`
