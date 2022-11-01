#include <stdio.h>

#define MAX_USERS 100

struct user {
        char *username;
        char *password;
};

struct database {
        struct user users[MAX_USERS];
        int num_users;
};


void add_user(struct database *db, struct user *u) {
        db->users[db->num_users].username = u->username;
        db->users[db->num_users].password = u->password;
        db->num_users++;
}

void print_users(struct database *db) {
        register int num_users = db->num_users;
        for(int i=0; i<num_users; i++) {
                printf("User ( username='%s', password='%s' )\n", db->users[i].username, db->users[i].password);
        }
}


int main() {
        struct database db;
        db.num_users = 0;
        struct user u1 = {"user1", "securepass"};
        struct user u2 = {"user2", "insecurepass"};
        struct user u3 = {"user3", "insecurepass"};

        add_user(&db, &u1);
        add_user(&db, &u2);
        add_user(&db, &u3);

        print_users(&db);

        return 0;
}
