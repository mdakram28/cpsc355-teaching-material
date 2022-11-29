# Session 19: Command Line Arguments

## Date: November 22, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. Command Line Arguments
2. ASCII to Integer (atoi) function
3. Using atoi() with command line arguments
----

## 1. Command Line Arguments

Command Line Arguments are arguments passed from the OS to a new process.

### Passing Arguments through the linux shell

Syntax to pass arguments:
```bash
<PROGRAM_NAME> <ARG1> <ARG2> <ARG3> ...
```

1. Any number of space separated arguments can be passed to the process. 
2. Each argument is of string (char *) type.
3. The arguments are separated by a space or tab or any combination of both.


Example:
```bash
./a.out 1234 random_string 1234abc
```

### Receiving arguments in a program

Arguments passed to the process are available in the form of arguments to the main function.

1. The first argument (w0) is the number of arguments passed
2. The second argument (x1) is a pointer to an array of arguments (strings)
3. The first string in the list of arguments is the program name itself. 
4. Arguments start from the second item in the list of arguments.

> Note: The array is an external pointer array. Each item of the array is a pointer to a string.

Example (c):
```c
#include<stdio.h>

// argc (w0) : count of arguments
// argv (x1) : pointer to an array of pointers to arguments (strings)
int main(int argc, char *argv[]) {
        register int i = 1;

        while(i < argc) {
                printf("argument %d = %s\n", i, argv[i]);
                i++;
        }
        return 0;
}
/*******************  Output should be similar to:  ********
argument 1 = <arg1>
argument 2 = <arg2>
argument 3 = <arg3>
*/
```


---

## 2. ASCII to Integer (atoi) function

https://man7.org/linux/man-pages/man3/atoi.3.html

The atoi function is used to convert a **string** (in ASCII code) to the **integer** it represents.
e.g.: "1234" -> 1234

Example (c) :
```c
#include <stdlib.h>
#include <stdio.h>
 
int main(void)
{
        register int i = atoi(" -9885");     /* i = -9885 */
        printf("i = %d\n",i);
        return 0;
}
 
/*******************  Output should be similar to:  ********
i = -9885
*/
```

Example (Assembly) :
```assembly

str_num:        .string " -9885"
str_fmt:        .string "i = %d\n"

                .global main
                .balign 4
main:	        stp	x29, x30, [sp, -16]!
                mov	x29, sp


                // register int i = atoi(" -9885");
                ldr     x0, =str_num
                bl      atoi
                mov     w21, w0

                // printf("i = %d\n",i);
                mov     x0, =str_fmt
                mov     w1, w21
                bl      printf


exit:	        mov	x0, 0
                ldp	x29, x30, [sp], 16
                ret


```


---

## 3. Using atoi() with command line arguments

All command line arguments are strings (Even if the user enters a number).

Use the atoi function to convert numeric strings to integers.


Example (c): Program to add two numbers passed as command line arguments.
```c
#include <stdio.h>

int main(int argc, char *argv[]) {
        register int num1 = atoi(argv[1]);
        register int num2 = atoi(argv[2]);
        printf("Sum = %d\n", num1 + num2);
}

```

```assembly
str_fmt:        .string "Sum = %d\n"


                define(num1_r, w22)
                define(num2_r, w23)
                define(base_r, x20)
                define(index_r, w21)

                .global main
                .balign 4
main:	        stp	x29, x30, [sp, -16]!
                mov	x29, sp
        
                mov     base_r, x1

                mov     index_r, 1
                ldr     x0, [base_r, index_r, SXTW 3]
                bl      atoi
                mov     num1_r, w0

                mov     index_r, 2
                ldr     x0, [base_r, index_r, SXTW 3]
                bl      atoi
                mov     num2_r, w0

                ldr     x0, =str_fmt
                add     w1, num1_r, num2_r
                bl      printf
        
exit:	        mov	x0, 0
                ldp	x29, x30, [sp], 16
                ret

```


---

## 4. Exercise

Write a calculator program in assembly that can either add or subtract two numbers.
The input is given through the command line arguments. as follows:

1. argument 1 : First number
2. argument 2 : "+" or "-"
3. argument 3 : Second number

```
$ ./my_calculator   14 + 25
Result = 39

$ ./my_calculator   14 - 25
Result = -11
```

> Hint: For comparing a register to the ascii value of a character use :
> cmp   $w23, '-'

```c
int main (int argc, char *argv[]) {
        register int num1 = atoi(argv[1]);
        register int num2 = atoi(argv[3]);
        register char operation = argv[2][0];

        if (operation == '+') {
                printf("Result = %d\n", num1 + num2);
        } else if (operation == '-') {
                printf("Result = %d\n", num1 - num2);
        }
        return 0;
}
```

