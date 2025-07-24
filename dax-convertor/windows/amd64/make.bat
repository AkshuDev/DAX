@echo off

@REM Assuming you are inside cdir
@REM Assuming you already have nasm and ld

@REM Build the files into .o by nasm
nasm -g -f win64 -o build/objs/dax.o src/dax.asm -i src
echo nasm -g -f win64 -o build/objs/dax.o src/dax.asm -i src

@REM Exit on error
if %errorlevel% neq 0 (
    echo Error: Assembly failed!
    exit /b %errorlevel%
)

@REM Link the object files into an executable
ld -g -o build/bin/dax.exe build/objs/dax.o -lkernel32
echo ld -g -o build/bin/dax.exe build/objs/dax.o

@REM Exit on error
if %errorlevel% neq 0 (
    echo Error: Linking failed!
    exit /b %errorlevel%
)

echo Done!