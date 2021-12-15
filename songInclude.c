#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/stat.h>

off_t
fileSize(char *s) {
    off_t file_size;
    struct stat stbuf;
    int fd;
      
    fd = open(s, O_RDONLY);
    if (fd == -1) {
        printf("file '%s' does not exist", s);
        exit(1);
    }
      
    if ((fstat(fd, &stbuf) != 0) || (!S_ISREG(stbuf.st_mode))) {
        printf("can't stat file '%s'", s);
        exit(1);
    }
      
    return stbuf.st_size;
}

void
printBank(int bank, char *f, int length) {
    printf("SECTION \"song%d\",ROMX,BANK[%d]\n    INCBIN \"%s\",$%x,$%x\n\n", bank+1, bank+1, f, 0x4000*bank, length);
}

int
main() {
    const int bankSize = 0x4000;

    char *f = "./data.bin";
    int fs = fileSize(f);
    int nBanks = fs / bankSize;
    int remainder = fs % bankSize;
    
    int i;
    for(i=0; i<nBanks; i++)
        printBank(i, f, 0x4000);
    
    if(remainder != 0) {
        nBanks++;
        printBank(nBanks-1, f, remainder);
    }
    printf("SONG_BANKS EQU %d\n", nBanks);
    return 0;
}
