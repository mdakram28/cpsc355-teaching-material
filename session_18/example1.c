#include <stdio.h>

int a = 5;
int b;

void printResult() {
        printf("Sum = %d\n", a + b);
}

int main() {
        printResult();
        b = 10;
        printResult();
        return 0;
}