# Session 01: Introduction & Setup

## Date: September 13, 2022

## By: Mohd Akram Ansari - https://mdakram.com

## Email: mohdakram.ansari@ucalgary.ca

Mention your course and tutorial number when sending email

Example: `CPSC 355 - T05 ...`


---
## Agenda

1. Introduction
2. Setting up your ssh workspace
3. Intro to sh and VIM
4. Compiling your first C program
5. Hello World in C
6. Exercise



---
## 1. Introduction



---
## 2. Setting up your ssh workspace

- Make sure you have your CPSC account set up. 
	- IT Account Management Portal [https://password.ucalgary.ca/](https://password.ucalgary.ca/)
- Make sure you have a ssh client installed on your computer.
	- Windows: [Putty Installation Instructions](https://www.ssh.com/academy/ssh/putty/windows/install)
	- linux/macOS: OpenSSH (Pre-Installed)
- Make sure you are using the university remote access VON if you are outside the unviersity network.
[Remote Access Instructions](https://ucalgary.service-now.com/it?id=kb_article&sys_id=52a169d6dbe5bc506ad32637059619cd)
- Connect to CPSC ARM server
	- Hostname: **arm.cpsc.ucalgary.ca**
	- Username: **Your_CPSC_Username**
	- Password: **Your_CPSC_Password**
	- On Windows: Open Putty > Enter Hostname: (john.sturgis@arm.cpsc.ucalgary.ca) > Open > Enter Password when prompted

---
## 3. Intro to the linux shell and VIM

- Basic Shell Commands
	```bash
	# This is a comment
	
	# 1. Print Directory Content
	ls

	# 2. Enter a Directory
	cd <Directory>

	# 3. Exit The current directory
	cd ..

	# 4. Crate a file
	touch <filename>

	# 5. Edit or create a file using vim
	vim <filename>

	# Clear the screen
	clear

	# Make a new directory
	mkdir <directory>

	# Delete a file
	rm <filename>

	# Delete a directory
	rm -r <directory>

	```

- VIM

	Operating modes in vim editor:

	- **Command Mode:** By default, command mode is on as soon as the vim editor is started. This command mode helps users to copy, paste, delete, or move text. We should be pressing [Esc] key to go to command mode when we are in other modes.
	- **Insert mode:** Whenever we try to open vim editor, it will go to command mode by default. To write the contents in the file, we must go to insert mode. Press ‘I’ to go to insert mode. If we want to go back to command mode, press the [Esc] key.

---
## 4. Compiling Your first C program

- Compiling a C program
	- Write your C program in a file with the extention `.c` (Not a requirement).
	- Enter the command to compile your C program into an `executable binary`
		```
		gcc codefile.c -o outfile.out
		```
	- Run the compiled binary.
		```
		./outfile.out
		```

---

## 5. Hello World in C
```c
#include <stdio.h>

int main() {
	printf("Hello World\n");
	return 0;
}
```

## 6. Exercise
Write a C program to convert celcius to fahrenheit

1. Get the current temperature in fahrenheit from the user
2. Convert it to celsius
3. Print the converted temperature

$$
C = \frac{(F - 32) * 5}{9}
$$

**Solution**
```c

```
