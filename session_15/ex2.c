struct color {
        int r;
        int g;
        int b;
}

struct color black() {
        struct color newcol;
        newcol.r = 0;
        newcol.g = 0;
        newcol.b = 0;
        return newcol;
}

struct color lighten(struct color origcol, int factor) {
        struct color newcol;
        newcol.r = origcol.r * factor;
        newcol.g = origcol.g * factor;
        newcol.b = origcol.b * factor;
        return newcol;
}

int main() {
        struct color col, lighcol;
        col = black();
        lightcol = lighten(col, 10)
        return 0;
}