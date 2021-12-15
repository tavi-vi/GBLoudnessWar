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
        for(i=0; i<4; i++) {
            int i2 = i*2;
            if(!(buf[i2]>0) && !(buf[i2+1]>0))
                ;
            else if(buf[i2]>0 && buf[i2+1]>0)
                out ^= 1<<(6-i2);
            else
                out ^= 1<<(7-i2);
        }
        putchar(out);
        clearBuf(buf);
    }
    return 0;
}
