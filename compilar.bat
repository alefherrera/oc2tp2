nasm -o interpolacion.obj -f win32 .\interpolacion.asm
gcc -Wall -m32 -o programa.exe .\interpolacion.obj .\main.c
