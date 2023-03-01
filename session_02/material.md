# Session 02: C for Java Developers

## Date: January 19, 2023

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. What's the same? What's different?
2. Data Types
3. Input and Output
4. String utilities

---
## 1. What's the same? What's different?

- What's the same?
	- Values, Types (more or less), literals, expressions
	- Variables (more or less)
	- Conditionals: `if,switch`
	- Iteration: while, for, do-while, but not for-in-collection (“colon” syntax)
	- Call-return (methods in Java, functions in C): parameters/arguments return values
	- Arrays (with one big difference)
	- Primitive and reference types
	- Typecasts
	- Libraries that extend the core language (although the mechanisms differ somewhat)
- Whats Different
	- No classes or objects
	- Arrays are simpler
	- C-Strings are much more limited
	- No Collections
	- No garbage collection
	- Pointers !! (Memory addresses)



## 2. Data Types

- Primitive Types
	| java | C | 
	| --- | --- | 
	| int | int |
	| short | short |
	| long | long |
	| float | float |
	| double | double |
	| char | char |
	| byte | N/A |
	| boolean | N/A |

- Strings
	In C, strings are simply arrays of chars. That’s it. The following allocates a string that can hold 32 characters:
	```c
	char name[32];
	```
	You can use the string literal syntax to initialize a character array, and if you do, the C compiler is smart enough to figure out the length for itself
	```c
	char name[] = "George";
	```
	**C-strings are null terminated**


## 3. Input and Output

- **printf** - https://man7.org/linux/man-pages/man3/printf.3.html
	- Syntax: printf(char * format, ...variable_list)
	- format: A character string composed of zero or more ordinary chracters (not %) and format specifiers (starting with %).
	- variable_list: A list of values to replace in place of format specifiers according to the given format
	- Example: 
	```c
	int num = 2;
	printf("%d", num);

	float num2 = 3.1415926;
	printf("PI = %f", num2); 				// PI = 3.1415926
	printf("PI (2 decimal places) = %.2f", num2); 		// PI (2 decimal places) = 3.14

	char str[] = "Sheldon Cooper";
	printf("Name :: %s", str);				// Name :: Sheldon Cooper
	```

- **scanf** - https://man7.org/linux/man-pages/man3/scanf.3.html
	- Syntax: scanf(char *format, ...variable_pointers)
	- format: A character string composed of zero or more ordinary chracters (not %) and format specifiers (starting with %).
	- variable_pointers: Memory addresses of variables to store the input
	- Example:
	```c
	int num;
	print("Enter a number : ");
	scanf("%d", &num);

	char str[10];
	scanf("%9s", str);
	printf("Entered string : %s", str);
	```

- **getchar** - https://man7.org/linux/man-pages/man3/getchar.3p.html
	- get a byte from standard input stream
	- Example:
	```c
	#include <stdio.h>

	int main () {
		char c;

		printf("Enter character: ");
		c = getchar();

		printf("Character entered: ");
		putchar(c);

		return(0);
	}

	```

- **putchar** - https://man7.org/linux/man-pages/man3/putchar.3p.html
	- put a byte on the standard output stream
	- Example:
	```c
	#include <stdio.h>

	int main () {
		char ch;

		for(ch = 'A' ; ch <= 'Z' ; ch++) {
			putchar(ch);
		}

		return(0);
	}
	```
	
## 4. String utilities

- **strlen** - https://man7.org/linux/man-pages/man3/strlen.3.html
	- calculate the length of a string
- **strcpy** - https://man7.org/linux/man-pages/man3/strncpy.3.html
	- copy a string

- Example:
	```c
	char str[] = "Hello World";
	char str2[32];
	printf("String length = %d", strlen(str));
	strcpy(str2, str);
	printf("Copied string : %s", str2);
	```

## References
1. C for Java Programmers (George Ferguson) - https://www.cs.rochester.edu/u/ferguson/csc/c/c-for-java-programmers.pdf

