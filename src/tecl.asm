[BITS 16]
[ORG 100h]

start:

    ; esperar tecla
    mov ah, 00h
    int 16h

    ; AH = scancode
    mov bl, ah

    ; nibble alto
    mov dl, bl
    shr dl, 4
    call printHex

    ; nibble bajo
    mov dl, bl
    and dl, 0Fh
    call printHex

    ; salto de linea
    mov ah, 02h
    mov dl, 0Dh
    int 21h

    mov dl, 0Ah
    int 21h

    mov ah, 4Ch
    int 21h

; -----------------------
printHex:
    add dl, 30h
    cmp dl, 39h
    jle .ok

    add dl, 07h

.ok:
    mov ah, 02h
    int 21h
    ret