[BITS 16]
[ORG 0x100]

DATA_PORT   EQU 0378h
STATUS_PORT EQU 0379h
CTRL_PORT   EQU 037Ah

start:
    MOV AX, CS
    MOV DS, AX

    ; Imprimir mensaje inicio
    MOV AH, 09h
    MOV DX, msg_inicio
    INT 21h

    ; Esperar BUSY# = 1 (impresora lista, bit 7 en alto)
    MOV CX, 0FFFFh
.wait_ready:
    MOV DX, STATUS_PORT
    IN AL, DX           ; leer puerto via DX (>0FFh)
    TEST AL, 80h
    JNZ .enviar
    LOOP .wait_ready

    ; Timeout
    MOV AH, 09h
    MOV DX, msg_timeout
    INT 21h
    JMP .fin

.enviar:
    ; Colocar 'A' en el bus de datos
    MOV DX, DATA_PORT
    MOV AL, 41h
    OUT DX, AL          ; escribir via DX

    ; Activar STROBE (bit 0 = 0)
    MOV DX, CTRL_PORT
    IN AL, DX
    AND AL, 0FEh
    OUT DX, AL

    ; Retardo
    MOV CX, 0Fh
.delay:
    LOOP .delay

    ; Desactivar STROBE (bit 0 = 1)
    MOV DX, CTRL_PORT
    IN AL, DX
    OR AL, 01h
    OUT DX, AL

    ; Mensaje exito
    MOV AH, 09h
    MOV DX, msg_ok
    INT 21h

.fin:
    MOV AH, 4Ch
    MOV AL, 00h
    INT 21h

; DATOS AL FINAL
msg_inicio  DB 'Enviando al puerto paralelo LPT1...', 13, 10, '$'
msg_ok      DB 'Dato enviado correctamente al puerto 0378h', 13, 10, '$'
msg_timeout DB 'Timeout: impresora no disponible$'