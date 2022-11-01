str_fmt:        .string "User ( username='%s', password='%s' )\n"
str_u1_name:    .string "user1"
str_u2_name:    .string "user2"
str_u3_name:    .string "user3"
str_u1_pass:    .string "securepass"
str_u2_pass:    .string "insecurepass"
str_u3_pass:    .string "insecurepass"


	.global main
	.balign 4

        // Define constants for structs
        max_users = 100
        user_size = 16
        user_username_s = 0
        user_password_s = 8
        database_size = user_size*max_users + 4
        database_users_s = 0
        database_numusers_s = user_size*max_users

	
	define(db_base_r, x21)
        define(user_base_r, x22)
        main_alloc = -(16 + database_size + user_size*3) & -16
        db_s = 16
        u1_s = 16 + database_size
        u2_s = 16 + database_size + user_size
        u3_s = 16 + database_size + user_size*2
main:	stp	x29, x30, [sp, main_alloc]!
	mov	x29, sp

        ldr     x0, =str_u1_name
        bl      printf
	
        @ add     db_base_r, x29, db_s
	@ ldr     wzr, [db_base_r, database_numusers_s]
        
        @ add     user_base_r, x29, u1_s
        @ ldr     x19, =str_u1_name
        @ str     x19, [user_base_r, user_username_s]
        @ ldr     x19, =str_u1_pass
        @ str     x19, [user_base_r, user_password_s]
        @ add     user_base_r, x29, u2_s
        @ ldr     x19, =str_u2_name
        @ str     x19, [user_base_r, user_username_s]
        @ ldr     x19, =str_u2_pass
        @ str     x19, [user_base_r, user_password_s]
        @ add     user_base_r, x29, u3_s
        @ ldr     x19, =str_u3_name
        @ str     x19, [user_base_r, user_username_s]
        @ ldr     x19, =str_u3_pass
        @ str     x19, [user_base_r, user_password_s]

        @ mov     x0, db_base_r
        @ add     x1, x29, u1_s
        @ bl      adduser
        @ mov     x0, db_base_r
        @ add     x1, x29, u2_s
        @ bl      adduser
        @ mov     x0, db_base_r
        @ add     x1, x29, u3_s
        @ bl      adduser
	
        @ ldr     x0, =str_fmt
        @ ldr     x1, [db_base_r, user_username_s]
        @ ldr     x2, [db_base_r, user_password_s]
        @ bl      printf
        
        mov	x0, 0
	ldp	x29, x30, [sp], -main_alloc
	ret



        define(users_base_r, x21)
        define(users_index_r, x24)
        define(users_offset_r, x23)
        define(user_base_r, x25)
        adduser_alloc = -(16) & -16
adduser:stp	x29, x30, [sp, adduser_alloc]!
	mov	x29, sp
	
        add     users_base_r, x0, database_users_s
        add     users_index_r, x0, database_numusers_s
        mul     users_offset_r, users_index_r, user_size

        add     user_base_r, users_base_r, users_offset_r
        ldr     x19, [x1, user_username_s]
        str     x19, [user_base_r, user_username_s]
        ldr     x19, [x1, user_password_s]
        str     x19, [user_base_r, user_password_s]

        ldr     w19, [x0, database_numusers_s]
        add     w19, w19, 1
        str     w19, [x0, database_numusers_s]
        	
        ldp	x29, x30, [sp], -adduser_alloc
	ret 


