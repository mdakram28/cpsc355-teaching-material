#include <stdio.h>

int main() {
	float temp_f, temp_c;
	printf("Enter temperature in fahrenheit: ");
	scanf("%f", &temp_f);
	temp_c = ((temp_f - 32) * 5) / 9;
	printf("Temperature in Celsius: %f\n", temp_c);
	return 0;
}
