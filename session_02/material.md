# Session 02: C for Java Developers

## Date: September 15, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. What's the same? What's different?
2. Data Types


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
	| --- | --- |
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

## References
1. C for Java Programmers (George Ferguson) - https://www.cs.rochester.edu/u/ferguson/csc/c/c-for-java-programmers.pdf

