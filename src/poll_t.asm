[BITS 16]
[ORG 0x100]

MAX_RETRY EQU 0FFFFh

start:
    MOV AX, CS
    MOV DS, AX
    MOV CX, MAX_RETRY

.poll:
    ; Verificar si hay tecla disponible via BIOS
    MOV AH, 01h
    INT 16h             ; ZF=1 si NO hay tecla, ZF=0 si HAY tecla
    JNZ .dato_listo     ; si hay tecla, ir a leerla
    LOOP .poll          ; si no, decrementar CX y repetir

    ; Timeout
    MOV AH, 09h
    MOV DX, msg_timeout
    INT 21h
    JMP .fin

.dato_listo:
    ; Leer la tecla
    MOV AH, 00h
    INT 16h             ; AL = caracter, AH = scancode
    MOV AH, 02h
    MOV DL, AL
    INT 21h             ; mostrar caracter

.fin:
    MOV AH, 4Ch
    MOV AL, 00h
    INT 21h

msg_timeout DB 'Timeout: sin respuesta del dispositivo$'