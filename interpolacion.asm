%include "io.inc"

section .data
;vector db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63
img1 dd 0x1,0x2,0x4,0x8
img2 dd 0x4,0x5,0x6,0x7
interpol dd 0.5
vector dd 0,0,0,0
complemento dd 1.0, 1.0, 1.0, 1.0

section .bss
result resd 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    xor eax, eax
    xor ebx, ebx
    mov eax, [interpol]
    
    ;usar shuffle para leer el array de bytes y ponerlo en registros xmm
    
    movups xmm0, [img1]
    movups xmm1, [img2]
    
    cvtdq2ps xmm0, xmm0
    cvtdq2ps xmm1, xmm1
    
    ;inicializamos un vector con el valor de interpolacion
    push 4
    push dword eax
    push vector
    call INICIALIZAR_VECTOR
    add esp, 12
    
    movups xmm2, [vector]
    mulps xmm0, xmm2
    
    movups [result], xmm0
    
    
    ret


;void InicializarVector(short *vectorA, short valorInicial, int dimension)
INICIALIZAR_VECTOR:

    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    mov edx, [ebp + 12]
    mov ebx, [ebp + 16]
    xor ecx, ecx
    CICLO:
    mov [eax], edx
    add eax, 4
    inc ecx
    cmp ecx, ebx
    jb CICLO
    pop ebp
    ret