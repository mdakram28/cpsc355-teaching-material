# Session 04: Control Flow in Assembly

## Date: January 26, 2023

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. Define and Macros
2. Branch Instruction and Condition Codes
3. Loops
4. The if construct



---
## 1. Define and Macros
- The **define** statement can create alternate name for registers.
	```assembly
	// This will tell the assembler to replace all x_r to x19
	define(x_r, x19)
	```
Use the extention `.asm` for unprocessed code containing macros.

### Invoking the preprocessor

Run this command to process the .asm fle (containing macros) to `.s` processed file ready for compilation.

```bash
m4 code.asm > code.s
```

The `code.s` file will be created which can be compiled using gcc.

---
## 2. Branch Instruction and Condition Codes

- Conditional branch statements use the condition falgs to make a decision.
- These condition flags are set or unset depending on the result of a compare instruction. i.e. `cmp`

Example:
```assembly
cmp	x19, x20
b.eq	some_label
```

The `cmp` instruction compares the values of two registers or a register and a value and the `b.eq` instruction jumps to `some_label` if the compared values were equal.

Other branching instructions:
- b.eq (==)
- b.ne (!=)
- b.gt (>)
- b.lt (<)
- b.ge (>=)
- b.le (<=)


---
## 3. Loops

- **do-while** loop (post-test loop)
	- Example:
	C Code:
	```c
	long int x;
	
	x = 1;
	do {
		// Loop body
		x++;
	} while(x <= 10);
	```
	Equivalent Assembly Code:
	```assembly
		mov	x19, 1
	top:	// Loop Body
		// ...
		
		add	x19, x19, 1
		cmp	x19, 10
		b.le	top
	```

- **while** loop (pre-test loop)
	- Example
	C Code:
	```c
	long int x;
	x = 0;
	while (x<10) {
		// Loop body
		x++;
	}
	```
	Equivalent Assembly Code
	```assembly
	define(x_r, x19)
		
		mov	x_r, 0
		b	test
	top:	// Loop Body
		// ...
		
		add	x_r, x_r, 1
	test:	cmp	x_r, 10
		b.lt	top
		
		// Loop Finished				
	```


---
## 4. The if construct

- Formed by branching over the statement body if the condition is not true.
	Example:
	
	```c
	if (a > b) {
	  c = a+b;
	  d = c+5;
	}
	```
	
	Equivalent Assembly Code:
	
	```assembly
	define(a_r, w19)
	define(b_r, w20)
	define(c_r, w21)
	define(d_r, w22)
	
		...
		cmp		a_r, b_r	// test
		b.le	next			// Logical compliment
		add		c_r, a_r, b_r
		add		d_r, c_r, 5
	next:
		// Statements after if condition
	```

- The **if-else** construct is formed by brnaching to the else part if the condition is not true.

  Example C Code:

  ```c
  if (a>b) {
    a = a+b;
  } else {
    a = a-b;
  }
  ```

  Equivalent Assembly Code:

  ```assembly
  define(a_r, x19)
  define(b_r, x20)
  
  	cmp		a_r, b_r
  	b.le	else
  	
  	add		a_r, a_r, b_r
  	b			next
  	
  else:
  	sub		a_r, a_r, b_r
  	
  next:
  	// Statements after the if-else construct
  ```

  

  
