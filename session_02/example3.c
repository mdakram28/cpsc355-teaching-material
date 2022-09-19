#include <stdio.h>
#include <string.h>

int main() {
	char str[] = "Hello World";
	char str2[32];
	printf("String length = %d\n", strlen(str));
	strcpy(str2, str);
	printf("Copied string : %s\n", str2);
}
