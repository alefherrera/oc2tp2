;%include "io.inc"

global _interpolar

section .data
img1 dd 0xed,0x1c,0x24,0xed,0x1c,0x24,0xed,0x1c,0x24,0xed,0x1c,0x24
;237,28,36,237,28,36,237,28,36,237,28,36
img2 dd 0xff,0xf2,0x00,0xff,0xf2,0x00,0xff,0xf2,0x00,0xff,0xf2,0x00
;255,242,0,255,242,0,255,242,0,255,242,0
;img1 dd 0x2,0x4,0x4,0x8,0x6,0x6,0x12,0x8
;img2 dd 0x4,0x5,0x6,0x7,0x2,0x8,0x10,0x24
interpol dd 1.0
vector dd 0,0,0,0
complemento dd 1.0, 1.0, 1.0, 1.0
vectorDebug dd 0,0,0,0,0,0,0,0,0,0,0,0

section .bss
debug resd 0

section .text

;void interpolar(unsigned char *img1, unsigned char *img2, unsigned char *resultado,float p, int cantidad);

global CMAIN
CMAIN:
    push 8
    push dword [interpol]
    push vectorDebug
    push img2
    push img1
    call _interpolar
    add esp, 20
    
    ret


_interpolar:
    push ebp
    mov ebp, esp
    
    ;multiplicamos por 4 el valor de cantidad
    mov eax, 4
    mov ecx, [ebp + 24]
    mul ecx
    mov ebx, eax
    
    mov edx, [ebp + 16]     ;resultado

    xor ecx, ecx
CICLO:
    cmp ecx, ebx
    jg FIN_CICLO
    
    ;usar shuffle para leer el array de bytes y ponerlo en registros xmm
    
    mov eax, [ebp + 8]      ;img1
    movups xmm0, [eax + ecx]
    mov eax, [ebp + 12]     ;img2
    movups xmm1, [eax + ecx]
    cvtdq2ps xmm0, xmm0
    cvtdq2ps xmm1, xmm1
    
    movups [debug], xmm0
    movups [debug], xmm1
    
    
    ;inicializamos un vector con el valor de interpolacion
    push eax
    push ebx
    push ecx
    push edx
    push 4
    push dword [ebp + 20]
    push vector
    call INICIALIZAR_VECTOR
    add esp, 12
    pop edx
    pop ecx
    pop ebx
    pop eax
    
    movups xmm2, [vector]
    mulps xmm0, xmm2
    movups xmm3, [complemento]
    subps xmm3, xmm2
    mulps xmm3, xmm1
    addps xmm0, xmm3
    
    cvtps2dq xmm0, xmm0
    
    movups [debug], xmm0
    movups [edx + ecx], xmm0

    add ecx, 16
    jmp CICLO
    
FIN_CICLO:
    
    
    pop ebp
    ret


;void InicializarVector(short *vectorA, short valorInicial, int dimension)
INICIALIZAR_VECTOR:

    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    mov edx, [ebp + 12]
    mov ebx, [ebp + 16]
    xor ecx, ecx
    INIVECTOR_CICLO:
    mov [eax], edx
    add eax, 4
    inc ecx
    cmp ecx, ebx
    jb INIVECTOR_CICLO
    pop ebp
    ret