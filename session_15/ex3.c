#include <stdio.h>

struct color {
        int r;
        int g;
        int b;
};

void lighten(struct color *origcol, int factor) {
        origcol.r = origcol.r * factor;
        origcol.g = origcol.g * factor;
        origcol.b = origcol.b * factor;
}

int main() {
        struct color col;
	col.r = 100;
	col.g = 200;
	col.b = 300;
        lighten(&col, 5);
        printf("Color( r=%d, g=%d, b=%d )\n", col.r, col.g, col.b);
        return 0;
}
