# Session 21: I/O

## Date: November 29, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. System I/O
2. Reading a file from filesystem
3. Writing a file from filesystem

----

## 1. System I/O

In linux all I/O devices such as networks, disks, mouse, keyboard are modeled as files, and all input and output is performed by reading and writing the appropriate files.
Files can be opened in linux using system calls (Kernal functions). The kernal ensures safe and secure access to the requested file.

### System Call
System call is like a subroutine call to execute privileged functions (such as opening a file). This is done by the `svc` instruction.


| x8  | Service Request | Documentation |
| --- | ---             | --- |
| 56  | openat          | https://man7.org/linux/man-pages/man2/open.2.html |
| 57  | close           | https://man7.org/linux/man-pages/man2/close.2.html |
| 63  | read            | https://man7.org/linux/man-pages/man2/read.2.html |
| 64  | write           | https://man7.org/linux/man-pages/man2/write.2.html |

### Steps to perform System I/O:

1. **Open file** - Open the file for the system I/O that you wish to perform using the `openat` system call.
2. **Read/Write file** - Read/Write bytes from the file using the `read` or `write` system call.
3. **Close File** - Disconnects device (If needed) or any other cleanup if needed using the `close` system call.

> File descriptor is a handle to an opened file for a process.

---

## 2. Reading/Writing a file

### Step 1. Open the file

```c
int fd = openat(int dirfd, const char *pathname, int flags, mode_t mode);
```

- **dirfd** - Directory file description relative from where the file needs to be opened. Set this to AT_FDCWD (the value -100) if the path is relative to the current working directory.
- **pathname** - Path of the file to be opened.
- **flags** - Settings with which to open the file. Multiple setings are combined using the or ( | ) operator. Each setting is specified using a constant value.
  - File operations needed. Choose exactly one of these.
    | Constant | Value | Description |
    | --- | --- | --- |
    | O_RDONLY | 00 | Read-Only Access |
    | O_WRONLY | 01 | Write-Only Access |
    | O_RDWR   | 02 | Read/Write Access |
  - Optional Flags. Can select multiple.
    | Constant | Value | Description |
    | --- | --- | --- |
    | O_CREAT  | 00100 | Create file if it doesn't exist |
    | O_EXCL   | 00200 | Fail if file exists |
    | O_TRUNC  | 01000 | Truncate an existing  |
    | O_APPEND | 02000 | Append to the file |
- **mode** - Unix permission mode for the newly created file (If created). Use `0666` in octal for read/write permission only to the owner (The user creating the file).
  https://chmodcommand.com/



### Step 2. Read/Write File

```c
// Rading 
int bytes_read = read(int fd, void *buf, size_t count);
// Writing
int bytes_write = write(int fd, const void *buf, size_t count);
```

- **fd** - Opened file's file descriptor
- **buf** - Address of where to read/write data inside the process' memory.
- **count** - Number of bytes to read/write
- **Return Val** - Actual number of bytes read/wrote.

---

## Step 3. Close File

```c
int success = close(int fd);
```

- **fd** - Opened file's file descriptor to close.

---

Example 1 (c) - Writing an int to a binary file

```c
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

int main() {
        // Step 1. Open file
        register int fd = openat(AT_FDCWD, "input.bin", O_RDWR | O_CREAT, 0666);
        int value;
        register int bytes_write;

        if (fd == -1) {
                printf("Cannot open input.bin file for writing!\n");
                return -1;
        }

        // Step 2. Write 4 bytes to file
        value = 1234;
        bytes_write = write(fd, &value, 4);   // sizeof(value) -> 4
        printf("Written %d bytes to file\n", bytes_write);

        // Step 3. Close file
        close(fd);

        return 0;
}
```

Example 1 (asm) - Writing an int to a binary file

```assembly     
str_filename:   .string "input.bin"
str_openfail:   .string "Cannot open input.bin file for writing!\n"
str_written:    .string "Written %d bytes to file\n"

                // Syscall codes
                define(syscall_openat, 56)
                define(syscall_close, 57)
                define(syscall_read, 63)
                define(syscall_write, 64)

                // File Open Constants
                define(AT_FDCWD, -100)
                define(O_RDWR, 02)
                define(O_CREAT, 00100)

                // Function macros
                define(fd_r, w25)
                define(bytes_write_r, w26)
                alloc = -(16 + 4) & -16
                value_s = 16

                .balign 4
                .global main
main:           stp     x29, x30, [sp, main_alloc]!
                mov     x29, sp

                // Step 1. Open file
                mov     w0, AT_FDCWD
                ldr     x1, =str_filename
                mov     w2, (O_RDWR | O_CREAT)
                mov     w3, 0666
                mov     x8, syscall_openat
                svc     0
                mov     fd_r, w0

                // Check if there was error
                cmp     fd_r, 0
                b.ge    open_ok
                ldr     x0, =str_openfail
                bl      printf
                mov     w0, -1
                b       main_return
open_ok:

                // value = 1234;
                mov     w19, 1234
                str     w19, [x29, value_s]

                // Step 2. Write value to file
                mov     w0, fd_r
                add     x1, x29, value_s
                mov     w2, 4
                mov     x8, syscall_write
                svc     0
                mov     bytes_write_r, w0

                // Print bytes written
                ldr     x0, =str_written
                mov     w1, bytes_write_r
                bl      printf
                

                // Step 3. Close File
                mov     w0, fd_r
                mov     x8, syscall_close
                svc     0

main_return:    ldp     x29, x30, [sp], -main_alloc
                ret
                
```

---

## Exercise

Write a program to read an int (4 bytes) from a binary file - `input.bin`
