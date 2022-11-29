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
                mov     w1, bytes_written_r
                bl      printf
                

                // Step 3. Close File
                mov     w0, fd_r
                mov     x8, syscall_close
                svc     0

main_return:    ldp     x29, x30, [sp], -main_alloc
                ret