#include <stdio.h>

struct color {
        int r;
        int g;
        int b;
};

struct color lighten(struct color origcol, int factor) {
        struct color newcol;
        newcol.r = origcol.r * factor;
        newcol.g = origcol.g * factor;
        newcol.b = origcol.b * factor;
        return newcol;
}

int main() {
        struct color col, lightcol;
	col.r = 100;
	col.g = 200;
	col.b = 300;
        lightcol = lighten(col, 5);
        printf("Color( r=%d, g=%d, b=%d )\n", lightcol.r, lightcol.g, lightcol.b);
        return 0;
}
