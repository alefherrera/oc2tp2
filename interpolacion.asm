global _interpolar

section .data
;vector db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63
img1 dd 0x2,0x4,0x4,0x8,0x6,0x6,0x12,0x8
img2 dd 0x4,0x5,0x6,0x7,0x2,0x8,0x10,0x24
interpol dd 0.5
vector dd 0,0,0,0
complemento dd 1.0, 1.0, 1.0, 1.0
vectorDebug dd 0,0,0,0,0,0,0,0

section .bss
debug resd 0

section .text

;void interpolar(unsigned char *img1, unsigned char *img2, unsigned char *resultado,float p, int cantidad);

global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    push 8
    push dword [interpol]
    push vectorDebug
    push img2
    push img1
    call _interpolar
    add esp, 20
    
    
    
    ret


_interpolar:
    mov ebp, esp; for correct debugging
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]      ;img1
    mov ebx, [ebp + 12]     ;img2
    mov edx, [ebp + 16]     ;resultado
    ;mov edx, [ebp + 20]     ;p
    
;    mov edx, [ebp + 24]
;    mov ecx, 4
;    mul edx

    xor ecx, ecx
CICLO:
    cmp ecx, [ebp + 24]
    jge FIN_CICLO
    
    ;usar shuffle para leer el array de bytes y ponerlo en registros xmm
    
    movups xmm0, [eax + ecx + ecx + ecx + ecx]
    movups xmm1, [ebx + ecx + ecx + ecx + ecx]
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

    add ecx, 4
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