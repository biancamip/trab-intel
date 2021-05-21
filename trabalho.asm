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

clearLine       db  '                                           ', 0
menuLine1       db  '1-7 - movimentacao de pecas', 0
menuLine2       db  'Z   - recomecar o jogo', 0
menuLine3       db  'R   - ler arquivo de jogo', 0
menuLine4       db  'G   - gravar arquivo de jogo', 0

zChar          BYTE    "z",0
rChar          BYTE    "r",0
gChar          BYTE    "g",0
sChar          BYTE    "s",0
nChar          BYTE    "n",0

msgLinePos         db       21
msgReset        db      'O jogo foi resetado                  ', 0
msgFileInput    db      'Entre com o nome do arquivo:       ', 0

msgInput1    db      'Voce digitou o numero 1      ', 0
msgInput2    db      'Voce digitou o numero 2      ', 0
msgInput3    db      'Voce digitou o numero 3      ', 0
msgInput4    db      'Voce digitou o numero 4      ', 0
msgInput5    db      'Voce digitou o numero 5      ', 0
msgInput6    db      'Voce digitou o numero 6      ', 0
msgInput7    db      'Voce digitou o numero 7      ', 0
unrecognizedCommand    db      'Comando nao reconhecido      ', 0

;--------------------------------------------------------------------

;   ASCII VALUES
;   A = 41H (65);    V = 56H (86);    x = 78H (120);    . = 2EH (46)
gameState       db      7 dup(?)

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
    call    setCursorInput
    call    getKey
    ; check if 1-7 here

    or      al, 20h    ; to lowercase
    cmp     al, zChar
    je      zInput
    cmp     al, rChar
    je      readingFile
    cmp     al, gChar
    je      recordingFile

    cmp     al, 31H
    je      tryMove1
    cmp     al, 32H
    je      tryMove2

    mov     dh, msgLinePos
    mov     dl,0
    call    setCursor
    lea     bx, unrecognizedCommand
    call    printf_s
    jmp     nextKey

    tryMove1:
    mov     dh, 13
    mov     dl, 0
    call    setCursor
    lea     bx, msgInput1
    call    printf_s
    jmp     nextKey

    tryMove2:
    mov     dh, 13
    mov     dl, 0
    call    setCursor
    lea     bx, msgInput2
    call    printf_s
    jmp     nextKey

    readingFile:
        call    clearMenu

        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx,msgFileInput
        call    printf_s
        
        call    setCursorInput
        ;   ler nome do arquivo
        ;   tentar abrir
        ;       se abrir -> reproduzir jogadas de alguma maneira
        ;       se nao -> erro
        call    getKey

    recordingFile:
        call    clearMenu

        mov     dh, msgLinePos
        mov     dl, 0
        call    setCursor
        lea     bx,msgFileInput
        call    printf_s
        
        call    setCursorInput
        ;   ler nome do arquivo
        ;   tentar abrir:
        ;       se existe -> escrever por cima
        ;       se nao -> criar
        ;   gravar jogadas de alguma maneira
        call    getKey


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
resetGame proc near
; Mov        [vet + 2],'A'
; aqui eu coloco os valores padrao no array e printo na tela com uma  funcao
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

    call updateGameDisplay
    ret
resetGame         endp

;--------------------------------------------------------------------
updateGameDisplay proc near
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