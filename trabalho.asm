;   Bianca Minusculli Pelegrini
;   Cartão 279598

;====================================================================
;   Trabalho de Programação Intel
;====================================================================
;
	.model 	small
	.stack
	
CR equ 0dh
LF equ 0ah

	.data

; Variavel interna usada na rotina printf_w
BufferWRWORD    db		10 dup (?)

; Variaveis para uso interno na funcao sprintf_w
sw_n	dw	0
sw_f	db	0
sw_m	dw	0

;--------------------------------------------------------------------
; display variables
headerLine1	    db	'Arquitetura e Organizacao de Computadores I', 0    ; 21.5
headerLine2	    db	'Trabalho do Intel - 2020/2', 0 ;13
headerLine3	    db	'Bianca Minusculli Pelegrini - Cartao 279598', 0 ; 17

gameFirstLine	db	'+--1--2--3--4--5--6--7--+', 0
gameLastLine	db	'+-----------------------+', 0
gameEmptyLines  db  '|                       |', 0
gameColShift    db  27

colPos1         db  30
colPos2         db  33
colPos3         db  36
colPos4         db  39
colPos5         db  42
colPos6         db  45
colPos7         db  48

clearLine       db  '                                                           ', 0
menuLine1       db  '1-7 - movimentacao de pecas', 0
menuLine2       db  'Z   - recomecar o jogo', 0
menuLine3       db  'R   - ler arquivo de jogo', 0
menuLine4       db  'G   - gravar arquivo de jogo', 0

zChar          BYTE    "z",0
rChar          BYTE    "r",0
gChar          BYTE    "g",0
kChar          BYTE    "k",0

msgLinePos         db       21
msgReset        db      'O jogo foi resetado                  ', 0
msgFileInput    db      'Entre com o nome do arquivo:', 0

msgInput1    db      'Voce digitou o numero 1 (movimento valido)   ', 0
msgInput2    db      'Voce digitou o numero 2 (movimento valido)   ', 0
msgInput3    db      'Voce digitou o numero 3 (movimento valido)   ', 0
msgInput4    db      'Voce digitou o numero 4 (movimento valido)   ', 0
msgInput5    db      'Voce digitou o numero 5 (movimento valido)   ', 0
msgInput6    db      'Voce digitou o numero 6 (movimento valido)   ', 0
msgInput7    db      'Voce digitou o numero 7 (movimento valido)   ', 0
unrecognizedCommand    db      'Comando nao reconhecido                       ', 0
invalidMovement        db      'Movimento invalido                            ', 0
notImplementedError    db      'Erro: funcionalidade nao implementada                     ', 0

;--------------------------------------------------------------------

;   ASCII VALUES
;   A = 41H (65);    V = 56H (86);    x = 78H (120);    . = 2EH (46)
gameState       db      7 dup(?)
isValidMovement db 0
execute         db 1

; quando ganhar, seto um desses
victory db 0
failure db 0

	.code
	.startup
	
	mov     ax,ds				; Seta ES = DS
	mov     es,ax

    call    clearScreen
    call    displayHeader
    call    displayGameContainer

    reset:
    call    resetGame
    call    displayMenu

    nextKey:
    call    updateGameDisplay
    call    setCursorInput
    call    getKey
    
    cmp     al, 31H
    je      input1
    cmp     al, 32H
    je      input2
    cmp     al, 33H
    je      input3
    cmp     al, 34H
    je      input4
    cmp     al, 35H
    je      input5
    cmp     al, 36H
    je      input6
    cmp     al, 37H
    je      input7

    or      al, 20h    ; to lowercase
    cmp     al, zChar
    je      zInput
    cmp     al, rChar
    je      readingFile
    cmp     al, gChar
    je      recordingFile

    ; cmp     al, kChar
    ; je      closeGame
    
    mov     dh, msgLinePos
    mov     dl,0
    call    setCursor
    lea     bx, unrecognizedCommand
    call    printf_s
    jmp     nextKey

    input1:
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, msgInput1
        call    printf_s

        call    tryMove1
        ; checar se venceu aqui
        cmp     victory, 1
        je      ganhou
        cmp     failure, 1
        je      perdeu

        jmp     nextKey

    input2:
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, msgInput2
        call    printf_s

        call    tryMove2
        ; checar se venceu aqui
        cmp     victory, 1
        je      ganhou
        cmp     failure, 1
        je      perdeu

        jmp     nextKey

    input3:
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, msgInput3
        call    printf_s

        call    tryMove3
        ; checar se venceu aqui
        cmp     victory, 1
        je      ganhou
        cmp     failure, 1
        je      perdeu

        jmp     nextKey

    input4:
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, msgInput4
        call    printf_s

        call    tryMove4
        ; checar se venceu aqui
        cmp     victory, 1
        je      ganhou
        cmp     failure, 1
        je      perdeu

        jmp     nextKey

    input5:
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, msgInput5
        call    printf_s

        call    tryMove5
        ; checar se venceu aqui

        cmp     victory, 1
        je      ganhou
        cmp     failure, 1
        je      perdeu

        jmp     nextKey

    input6:
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, msgInput6
        call    printf_s

        call    tryMove6
        ; checar se venceu aqui
        cmp     victory, 1
        je      ganhou
        cmp     failure, 1
        je      perdeu

        jmp     nextKey

    input7:
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, msgInput7
        call    printf_s

        call    tryMove7
        ; checar se venceu aqui
        cmp     victory, 1
        je      ganhou
        cmp     failure, 1
        je      perdeu

        jmp     nextKey

    readingFile:
        ;   ler nome do arquivo
        ;   tentar abrir
        ;       se abrir -> reproduzir jogadas
        ;       se nao -> erro
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, notImplementedError
        call    printf_s
        jmp     nextKey

    recordingFile:
        ;   ler nome do arquivo
        ;   tentar abrir:
        ;       se existe -> escrever por cima
        ;       se nao -> criar
        ;   gravar jogadas
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, notImplementedError
        call    printf_s
        jmp     nextKey

ganhou:
perdeu:
closeGame:
    call     clearScreen

.exit

zInput:
    mov      dh, msgLinePos
    mov      dl, 0
    call     setCursor
    lea      bx,msgReset
    call     printf_s
    jmp      reset

;--------------------------------------------------------------------
; As funcoes tryMoveX tentam executar movimento na posicao X
;   Se o movimento for valido e execute == 1, ele é executado
;   Se o movimento nao for valido, uma mensagem é mostrada
; As funcoes retornam a flag valido/invalido em isValidMovement
;--------------------------------------------------------------------
tryMove1 proc near
    cmp     gameState[0], 2EH   ; check if .
    je      invalid1

    cmp     gameState[0], 56H   ; check if V
    je      invalid1

    ; daqui em diante sei que gamestate[0]= A
    cmp     gameState[2], 41H   ; check if next is A
    je      invalid1
    
    cmp     gameState[2], 2EH   ; check if next is empty
    jne     continueChecks1

    cmp     execute, 1
    jne     valid1
    mov     gameState[0], 2EH
    mov     gameState[2], 41H
    jmp     valid1

    continueChecks1:
    ; daqui em diante sei que o gamestate[2]= V
    cmp     gameState[4], 2EH   ; check if empty space to jump
    jne     invalid1

    cmp     execute, 1
    jne     valid1
    mov     gameState[0], 2EH
    mov     gameState[4], 41H
    jmp     valid1

    invalid1:
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, invalidMovement
        call    printf_s
        mov     isValidMovement, 0
        ret

    valid1:
        mov     isValidMovement, 1
        ret
tryMove1 endp

;--------------------------------------------------------------------
tryMove2 proc near
    cmp     gameState[2], 2EH   ; check if .
    je      invalid2

    cmp     gameState[0], 41H   ; check if A
    je      isA2

    ; daqui em diante sei que gamestate[2]= V
    cmp     gameState[0], 2EH   ; check if previous is empty
    jne     invalid2

    cmp     execute, 1
    jne     valid2
    mov     gameState[2], 2EH
    mov     gameState[0], 56H
    jmp     valid2

    isA2:
    cmp     gameState[4], 2EH
    jne     invalid2

    cmp     execute, 1
    jne     valid2
    mov     gameState[4], 41H
    mov     gameState[2], 2EH
    jmp     valid2

    invalid2:
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, invalidMovement
        call    printf_s
        mov     isValidMovement, 0
        ret

    valid2:
        mov     isValidMovement, 1
        ret
tryMove2 endp

;--------------------------------------------------------------------
tryMove3 proc near
    cmp     gameState[4], 2EH   ; check if .
    je      invalid3

    cmp     gameState[4], 41H   ; check if A
    je      isA3

    ; daqui em diante sei que gamestate[4]= V

    cmp     gameState[2], 56H   ; check if previous is V
    je      invalid3

    cmp     gameState[2], 2EH   ; check if previous is empty
    jne     continueChecksV3

    cmp     execute, 1
    jne     valid3
    mov     gameState[4], 2EH
    mov     gameState[2], 56H
    jmp     valid3

    continueChecksV3:
    ; daqui em diante sei que o gamestate[02]= A
    cmp     gameState[0], 2EH   ; check if empty space to jump
    jne     invalid3

    cmp     execute, 1
    jne     valid3
    mov     gameState[4], 2EH
    mov     gameState[0], 56H
    jmp     valid3

    isA3:
    cmp     gameState[6], 41H ; check if next is A
    je      invalid3

    cmp     gameState[6], 2EH  ; check if next is empty
    jne     continueChecksA3

    cmp     execute, 1
    jne     valid3
    mov     gameState[6], 41H
    mov     gameState[4], 2EH
    jmp     valid3

    ; daqui em diante sei que gameState[8] = V
    continueChecksA3:
    cmp     gameState[8], 2EH  ; check if empty space to jump  
    jne     invalid3

    cmp     execute, 1
    jne     valid3
    mov     gameState[8], 41H
    mov     gameState[4], 2EH
    jmp     valid3

    invalid3:
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, invalidMovement
        call    printf_s
        mov     isValidMovement, 0
        ret

    valid3:
        mov     isValidMovement, 1
        ret
tryMove3 endp

;--------------------------------------------------------------------
tryMove4 proc near
    cmp     gameState[6], 2EH   ; check if .
    je      invalid4

    cmp     gameState[6], 41H   ; check if A
    je      isA4

    ; daqui em diante sei que gamestate[6]= V

    cmp     gameState[4], 56H   ; check if previous is V
    je      invalid4

    cmp     gameState[4], 2EH   ; check if previous is empty
    jne     continueChecksV4

    cmp     execute, 1
    jne     valid4
    mov     gameState[6], 2EH
    mov     gameState[4], 56H
    jmp     valid4

    continueChecksV4:
    ; daqui em diante sei que o gamestate[04]= A
    cmp     gameState[2], 2EH   ; check if empty space to jump
    jne     invalid4

    cmp     execute, 1
    jne     valid4
    mov     gameState[6], 2EH
    mov     gameState[2], 56H
    jmp     valid4

    isA4:
    cmp     gameState[8], 41H ; check if next is A
    je      invalid4

    cmp     gameState[8], 2EH  ; check if next is empty
    jne     continueChecksA4

    cmp     execute, 1
    jne     valid4
    mov     gameState[8], 41H
    mov     gameState[6], 2EH
    jmp     valid4

    ; daqui em diante sei que gameState[8] = V
    continueChecksA4:
    cmp     gameState[10], 2EH  ; check if empty space to jump  
    jne     invalid4

    cmp     execute, 1
    jne     valid4
    mov     gameState[10], 41H
    mov     gameState[6], 2EH
    jmp     valid4

    invalid4:
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, invalidMovement
        call    printf_s
        mov     isValidMovement, 0
        ret

    valid4:
        mov     isValidMovement, 1
        ret
tryMove4 endp

;--------------------------------------------------------------------
tryMove5 proc near
    cmp     gameState[8], 2EH   ; check if .
    je      invalid5

    cmp     gameState[8], 41H   ; check if A
    je      isA5

    ; daqui em diante sei que gamestate[8]= V

    cmp     gameState[6], 56H   ; check if previous is V
    je      invalid5

    cmp     gameState[6], 2EH   ; check if previous is empty
    jne     continueChecksV5

    cmp     execute, 1
    jne     valid5
    mov     gameState[8], 2EH
    mov     gameState[6], 56H
    jmp     valid5

    continueChecksV5:
    ; daqui em diante sei que o gamestate[06]= A
    cmp     gameState[4], 2EH   ; check if empty space to jump
    jne     invalid5

    cmp     execute, 1
    jne     valid5
    mov     gameState[8], 2EH
    mov     gameState[4], 56H
    jmp     valid5

    isA5:
    cmp     gameState[10], 41H ; check if next is A
    je      invalid5

    cmp     gameState[10], 2EH  ; check if next is empty
    jne     continueChecksA5

    cmp     execute, 1
    jne     valid5
    mov     gameState[10], 41H
    mov     gameState[8], 2EH
    jmp     valid5

    ; daqui em diante sei que gameState[10] = V
    continueChecksA5:
    cmp     gameState[12], 2EH  ; check if empty space to jump  
    jne     invalid5

    cmp     execute, 1
    jne     valid5
    mov     gameState[12], 41H
    mov     gameState[8], 2EH
    jmp     valid5

    invalid5:
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, invalidMovement
        call    printf_s
        mov     isValidMovement, 0
        ret

    valid5:
        mov     isValidMovement, 1
        ret
tryMove5 endp

;--------------------------------------------------------------------
tryMove6 proc near
    cmp     gameState[10], 2EH   ; check if .
    je      invalid6

    cmp     gameState[10], 41H   ; check if A
    je      isA6

    ; daqui em diante sei que gamestate[12]= V
    cmp     gameState[8], 56H   ; check if previous is V
    je      invalid6
    
    cmp     gameState[8], 2EH   ; check if previous is empty
    jne     continueChecks6

    cmp     execute, 1
    jne     valid6
    mov     gameState[10], 2EH
    mov     gameState[8], 56H
    jmp     valid6

    continueChecks6:
    ; daqui em diante sei que o gamestate[10]= A
    cmp     gameState[6], 2EH   ; check if empty space to jump
    jne     invalid6

    cmp     execute, 1
    jne     valid6
    mov     gameState[10], 2EH
    mov     gameState[6], 56H
    jmp     valid6

    isA6:
    cmp     gameState[12], 2EH
    jne     invalid6
    cmp     execute, 1
    jne     valid6
    mov     gameState[12], 41H
    mov     gameState[10], 2EH
    jmp     valid6

    invalid6:
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, invalidMovement
        call    printf_s
        mov     isValidMovement, 0
        ret

    valid6:
        mov     isValidMovement, 1
        ret
tryMove6 endp

;--------------------------------------------------------------------
tryMove7 proc near
    cmp     gameState[12], 2EH   ; check if .
    je      invalid7

    cmp     gameState[12], 41H   ; check if A
    je      invalid7

    ; daqui em diante sei que gamestate[14]= V
    cmp     gameState[10], 56H   ; check if previous is V
    je      invalid7
    
    cmp     gameState[10], 2EH   ; check if previous is empty
    jne     continueChecks2

    cmp     execute, 1
    jne     valid7
    mov     gameState[12], 2EH
    mov     gameState[10], 56H
    jmp     valid7

    continueChecks2:
    ; daqui em diante sei que o gamestate[12]= A
    cmp     gameState[8], 2EH   ; check if empty space to jump
    jne     invalid7

    cmp     execute, 1
    jne     valid7
    mov     gameState[12], 2EH
    mov     gameState[8], 56H
    jmp     valid7

    invalid7:
        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx, invalidMovement
        call    printf_s
        mov     isValidMovement, 0
        ret

    valid7:
        mov     isValidMovement, 1
        ret

tryMove7 endp

;--------------------------------------------------------------------
resetGame proc near
; coloco os valores padrao no array e printo na tela
	lea		di,gameState
	mov		ax,41H
	stosw
    mov		ax,41H
	stosw
    mov		ax,41H
	stosw
    mov		ax,2EH
	stosw
    mov		ax,56H
	stosw
    mov		ax,56H
	stosw
    mov		ax,56H
	stosw

    call    updateGameDisplay
    ret
resetGame endp

;--------------------------------------------------------------------
updateGameDisplay proc near
    mov     dh, 9
    mov     dl, gameColShift 
    call    setCursor
    lea     bx, gameEmptyLines
    call    printf_s

    mov     dh, 9
    mov     dl, colPos1
    call    setCursor
    lea     bx, gameState[0]
    call    printf_s
    
    mov     dh, 9
    mov     dl, colPos2
    call    setCursor
    lea     bx, gameState[2]
    call    printf_s
    
    mov     dh, 9
    mov     dl, colPos3
    call    setCursor
    lea     bx, gameState[4]
    call    printf_s

    mov     dh, 9
    mov     dl, colPos4
    call    setCursor
    lea     bx, gameState[6]
    call    printf_s

    mov     dh, 9
    mov     dl, colPos5
    call    setCursor
    lea     bx, gameState[8]
    call    printf_s

    mov     dh, 9
    mov     dl, colPos6
    call    setCursor
    lea     bx, gameState[10]
    call    printf_s

    mov     dh, 9
    mov     dl, colPos7
    call    setCursor
    lea     bx, gameState[12]
    call    printf_s
    ret
updateGameDisplay endp

;--------------------------------------------------------------------
setCursorInput proc near
    mov      dh, 24
    mov      dl, 0
    call     setCursor
    ret
setCursorInput    endp

;--------------------------------------------------------------------
displayGameContainer proc near
    mov     dh,7
    mov     dl, gameColShift
    call    setCursor
    lea     bx,gameFirstLine
    call    printf_s

    mov     dh,8
    mov     dl, gameColShift
    call    setCursor
    lea     bx,gameEmptyLines
    call    printf_s

    mov     dh,9
    mov     dl, gameColShift
    call    setCursor
    lea     bx,gameEmptyLines
    call    printf_s

    mov     dh,10
    mov     dl, gameColShift
    call    setCursor
    lea     bx,gameEmptyLines
    call    printf_s

    mov     dh,11
    mov     dl, gameColShift
    call    setCursor
    lea     bx,gameLastLine
    call    printf_s

    ret
displayGameContainer       endp

;--------------------------------------------------------------------
displayMenu proc near
    mov      dl,0

    mov      dh,16
    call     setCursor	
    lea      bx,menuLine1
    call     printf_s

    mov      dh,17
    call     setCursor	
    lea      bx,menuLine2
    call     printf_s

    mov      dh,18
    call     setCursor	
    lea      bx,menuLine3
    call     printf_s

    mov      dh,19
    call     setCursor	
    lea      bx,menuLine4
    call     printf_s

    ret
displayMenu       endp


;--------------------------------------------------------------------
clearMenu proc near
    mov     dl,0

    mov     dh,16
    call    setCursor
    lea     bx, clearLine
    call    printf_s
    
    mov     dh,17
    call    setCursor
    lea     bx, clearLine
    call    printf_s
    
    mov     dh,18
    call    setCursor
    lea     bx, clearLine
    call    printf_s
    
    mov     dh,19
    call    setCursor
    lea     bx, clearLine
    call    printf_s
    
    mov     dh,20
    call    setCursor
    lea     bx, clearLine
    call    printf_s
    
    mov     dh,21
    call    setCursor
    lea     bx, clearLine
    call    printf_s
    
    mov     dh,22
    call    setCursor
    lea     bx, clearLine
    call    printf_s
    
    mov     dh,23
    call    setCursor
    lea     bx, clearLine
    call    printf_s
    
    mov     dh,24
    call    setCursor
    lea     bx, clearLine
    call    printf_s
    
    ret
clearMenu endp

;--------------------------------------------------------------------
displayHeader proc near
    mov      dh,0
    mov      dl,0
    call     setCursor	
    lea      bx,headerLine1
    call     printf_s

    mov      dh,1
    mov      dl,0
    call     setCursor	
    lea      bx,headerLine2
    call     printf_s

    mov      dh,2
    mov      dl,0
    call     setCursor	
    lea      bx,headerLine3
    call     printf_s

    ret
displayHeader     endp
	
;--------------------------------------------------------------------
; Funcao: posiciona o cursor
;	mov		dh,linha
;	mov		dl,coluna
;	DH = row (00h is top)
;	DL = column (00h is left)
;--------------------------------------------------------------------
setCursor	proc	near
;	DH = row (00h is top)
;	DL = column (00h is left)
    mov      ah,2                 ; set cursor position
    mov      bh,0                 ; page number
    int      10h
    ret
setCursor         endp

;--------------------------------------------------------------------
; Funcao: limpa a tela e coloca no formato texto 80x25
;--------------------------------------------------------------------
clearScreen	proc	near
    mov      ah,0
    mov      al,7
    int      10h
    ret
clearScreen       endp

;--------------------------------------------------------------------
; Funcao: espera por um caractere do teclado
; Sai: AL => caractere lido do teclado
;--------------------------------------------------------------------
getKey	proc	near
    mov      ah,7
    int      21H
    ret
getKey            endp

;====================================================================
; A partir daqui, estao as funcoes ja desenvolvidas
;	1) printf_s
;	2) printf_w
;	3) sprintf_w
;====================================================================

;--------------------------------------------------------------------
; Funcao Escrever um string na tela
;		printf_s(char *s -> BX)
;--------------------------------------------------------------------
printf_s	proc	near
                  mov      dl,[bx]
                  cmp      dl,0
                  je       ps_1

                  push     bx
                  mov      ah,2
                  int      21H
                  pop      bx

                  inc      bx		
                  jmp      printf_s
		
ps_1:
                  ret
printf_s          endp


;--------------------------------------------------------------------
; Funcao: Escreve o valor de AX na tela
;		printf("%
;--------------------------------------------------------------------
printf_w	proc	near
	; sprintf_w(AX, BufferWRWORD)
                  lea      bx,BufferWRWORD
                  call     sprintf_w
	
	; printf_s(BufferWRWORD)
                  lea      bx,BufferWRWORD
                  call     printf_s
	
                  ret
printf_w          endp


;--------------------------------------------------------------------
; Funcao: Converte um inteiro (n) para (string)
;		 sprintf(string->BX, "%d", n->AX)
;--------------------------------------------------------------------
sprintf_w	proc	near
                  mov      sw_n,ax
                  mov      cx,5
                  mov      sw_m,10000
                  mov      sw_f,0
	
sw_do:
                  mov      dx,0
                  mov      ax,sw_n
                  div      sw_m
	
                  cmp      al,0
                  jne      sw_store
                  cmp      sw_f,0
                  je       sw_continue
sw_store:
                  add      al,'0'
                  mov      [bx],al
                  inc      bx
	
                  mov      sw_f,1
sw_continue:
	
                  mov      sw_n,dx
	
                  mov      dx,0
                  mov      ax,sw_m
                  mov      bp,10
                  div      bp
                  mov      sw_m,ax
	
                  dec      cx
                  cmp      cx,0
                  jnz      sw_do

                  cmp      sw_f,0
                  jnz      sw_continua2
                  mov      [bx],'0'
                  inc      bx
sw_continua2:

                  mov      byte ptr[bx],0
                  ret		
sprintf_w         endp

;--------------------------------------------------------------------
                  end
;--------------------------------------------------------------------