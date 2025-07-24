#include "stdio.h"
#include "stdlib.h"

// Structs
typedef struct {
    char magic[3]; // DPH
    uint8_t version;
    uint32_t entry_point;
    uint32_t text_size;
    uint32_t data_size;
    uint32_t bss_size;
} DAX_PAD_hdr;

// Error codes
#define USAGE_ERROR 1

int main(int argc, char** argv) {
    if (argc < 3) {
        printf("Usage: dax-asm <input> <output> <-[OPTIONS]>\n");
        return USAGE_ERROR;
    }

    for (int i = 1;i < argc; i++){
	
    }

    return 0;
}
