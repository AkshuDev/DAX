; Basic
%define NULL 0
%define NULL_T 0
%define ENDL 0xa, 0xd

; Buffers
%define MAX_FILE_BUF 256
%define MAX_FILE_CONTENTS_BUF 65536
%define HEADER_SIZE 12

; Errors
%define USAGE_ERROR 1
%define UNABLE_TO_READ_FILE_ERROR 2
%define UNABLE_TO_WRITE_FILE_ERROR 3

; Open FLAGS
%define O_RDONLY        0x0000
%define O_WRONLY        0x0001
%define O_RDWR          0x0002
%define O_ACCMODE       0x0003

%define O_CREAT         0x0040
%define O_EXCL          0x0080
%define O_NOCTTY        0x0100
%define O_TRUNC         0x0200
%define O_APPEND        0x0400
%define O_NONBLOCK      0x0800

%define O_DSYNC         0x1000
%define O_DIRECT        0x4000
%define O_LARGEFILE     0x8000

%define O_DIRECTORY     0x020000
%define O_NOFOLLOW      0x040000
%define O_CLOEXEC       0x080000

%define O_SYNC          0x101000
%define O_PATH          0x200000
%define O_TMPFILE       0x410000

; Open Modes
; File permission modes (octal values)
%define S_IRWXU  00700 ; Read, write, execute/search by owner
%define S_IRUSR  00400 ; Read by owner
%define S_IWUSR  00200 ; Write by owner
%define S_IXUSR  00100 ; Execute/search by owner

%define S_IRWXG  00070 ; Read, write, execute/search by group
%define S_IRGRP  00040 ; Read by group
%define S_IWGRP  00020 ; Write by group
%define S_IXGRP  00010 ; Execute/search by group

%define S_IRWXO  00007 ; Read, write, execute/search by others
%define S_IROTH  00004 ; Read by others
%define S_IWOTH  00002 ; Write by others
%define S_IXOTH  00001 ; Execute/search by others

; Combined Open Modes
%define MODE_644 0644  ; -rw-r--r--
%define MODE_755 0755  ; -rwxr-xr-x
