;%include "io.inc"

global _interpolar

section .data
;img1 dd 0xed,0x1c,0x24,0xed,0x1c,0x24,0xed,0x1c,0x24,0xed,0x1c,0x24,0x13
;237,28,36,237,28,36,237,28,36,237,28,36
;img2 dd 0xff,0xf2,0x0a,0xff,0xf2,0x0a,0xff,0xf2,0x0a,0xff,0xf2,0x0a,0x13
;255,242,10,255,242,10,255,242,10,255,242,10
;img1 dd 0x2,0x4,0x4,0x8,0x6,0x6,0x12,0x8
;img2 dd 0x4,0x5,0x6,0x7,0x2,0x8,0x10,0x24
;interpol dd 0.5
;vector dd 0,0,0,0
complemento dd 1.0
;vectorDebug dd 0,0,0,0,0,0,0,0,0,0,0,0,0
align 16
separar db 03h,0ffh,0ffh,0ffh,02h,0ffh,0ffh,0ffh,01h,0ffh,0ffh,0ffh,00h,0ffh,0ffh,0ffh
;mascara para unir
align 16
juntar db 0ch,08h,04h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

section .text
;void interpolar(unsigned char *img1, unsigned char *img2, unsigned char *resultado,float p, int cantidad);

_interpolar:
    push ebp
    mov ebp, esp
    
    ;multiplicamos por 4 el valor de cantidad
    mov edi, [ebp + 24]     ;cantidad
    SHR edi, 2
    
    mov eax, [ebp + 8]      ;img1
    mov ebx, [ebp + 12]     ;img2
    mov edx, [ebp + 16]     ;resultado
    mov esi, [ebp + 20]     ;p
    xor ecx, ecx
CICLO:
    cmp ecx, edi
    jge FIN_CICLO
    
    ;usar shuffle para leer el array de bytes y ponerlo en registros xmm
    
    movups xmm0, [eax + ecx*4]; img1
    movups xmm1, [ebx + ecx*4]; img2
    
    
    movd xmm2, esi; paso el float a un registro xmm
    pshufd xmm2, xmm2, 00000000;aplico la mascara
    
    movd xmm3, [complemento];muevo el 1.0 de la etiqueta
    pshufd xmm3, xmm3, 00000000;aplico la mascara
    subps xmm3, xmm2

    pshufb xmm0, [separar]
    pshufb xmm1, [separar]
    
    cvtdq2ps xmm0, xmm0
    cvtdq2ps xmm1, xmm1

    mulps xmm0, xmm2 ; img1 * p
    mulps xmm1, xmm3 ; img2 * (1 - p)
    
    addps xmm0, xmm1
    
    cvtps2dq xmm0, xmm0

    pshufb xmm0, [juntar]
    
    movd [edx + ecx*4], xmm0

    inc ecx
    jmp CICLO
    
FIN_CICLO:
    
    pop ebp
    ret
