#include <stdio.h>

void
clearBuf(char *buf) {
        int i;
        for(i=0; i<8; i++)
                buf[i] = 0;
}

int
main() {
    char buf[8];
    clearBuf(buf);
    while(fread(buf, 1, 8, stdin)) {
        unsigned char out=0;
        int i;
        for(i=0; i<8; i++) {
            if(buf[i]>0)
                out ^= 1<<(7-i);
        }
        putchar(out);
        clearBuf(buf);
    }
    return 0;
}
