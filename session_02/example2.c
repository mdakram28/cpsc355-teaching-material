#include <stdio.h>

int main() {
	char str[10];
	int num = 123;

	printf("Enter a string : ");
 	scanf("%90s", str);
	printf("Entered string : %s\n", str);
	printf("Num = %d\n", num);
}
