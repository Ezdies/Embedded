; To m�j pierwszy program do DSM

TEST bit P1.7
BUZZ bit P1.5
SEG7 bit P1.6

CSDS equ 30h ;wska�niki
CSDB equ 38h ;segmenty

ZEGAR equ 7Ah ;wskazanie zegara
SS equ 79h ;sekundy
MM equ 78h ;minuty
GG equ 77h  ;godziny




org 0
	ljmp start


org 0Bh			;procedura obs�ugi przerwania od TIMER0
	mov TH0, #226 ;dla trybu 0
	setb F0 	;informujemy p�tl� g��wn� o wyst�pieniu przerwania
	reti

org 80h


start:
	mov SS, #53
	mov MM, #47
	mov GG, #21
	
	lcall przelicz



;	mov ZEGAR, #6   ;wst�pne ustawienie zegara
;	mov ZEGAR+1, #5
;	mov ZEGAR+2, #7
;	mov ZEGAR+3, #4
;	mov ZEGAR+4, #1
;	mov ZEGAR+5, #2


	mov R7, #00000001b  ;najm�odszy wy�wietlacz do R7
	mov R1, #ZEGAR   ;adres nam�odszej cyfry zegara do R1
	mov DPTR, #wzory ; adres wzoru wy�wietlacza 7seg do DPTR

	mov IE, #0 	;wy��czam obs�ug� wszystkich przerwa�
	
	;zliczanie 960 przerwan
	mov R6, #4
	mov R5, #192
	mov TMOD, #01110000b   ;dla trybu 0
	mov TH0, #226      ;960 przerwa� na sekund�
	setb TR0	;zgoda na zliczenie przez liczniki TIMER0(musi by� w��czona, aby licznik zlicza�)
	setb ET0	;zgoda na obs�ug� przerwania od TIMER0
	setb EA		;globalna zgoda na obs�ug� przerwa� (musi by� w��czone, �eby poprzednia zgoda dzia�a�a)

mLoop:
	jnb F0, mLoop	;czeja na wyst�pienie przerwania
	clr F0          ;zapominamy o przerwaniu
	
; tutaj jestem 960 razy na sekund�

	mov R0, #CSDB   ;adres zatrzasku segment�w do R0
	mov A, @R1      ;aktualna cyfra zegara do ACC
	inc R1          ;wybiera nast�pn� cyfr� zegara na potrzeby nast�pnego obrotu p�tli
	setb SEG7       ;wy��cza wy�wietlacze �eby nie by�o duch�w
	movc A, @A+DPTR ;pobiera wzorek z pami�ci ROM
	movx @R0, A     ; wysy�a wzorek do zatrzasku segment�w

	mov R0, #CSDS   ;adres zatrzasku wy�wietlaczy do R0
	mov A, R7       ;aktualny wy�wietlacz do R7

	movx @R0, A      ;wysy�a aktualny wy�wietlacz do zatrzasku wy�wietlaczy
	clr SEG7  	     ;
	rl A
	jnb ACC.7, noACC7
	mov A, #00000001b
	mov R1, #ZEGAR
noACC7:

	mov R7, A

	djnz R5, mLoop
	djnz R6, mLoop

	mov R6, #4 ;zliczanie 960 przerwa�
	mov R5, #192

; tutaj jestem raz na sekunc�
	inc SS
	mov A, SS
	cjne A, #60, nie60
	mov SS, #0
	inc MM
	mov A, MM
	cjne A, #60, nie60
	mov MM, #0
	inc GG
	mov A, GG
	cjne A, #24, nie60
	mov GG, #0


nie60:
	lcall przelicz
	
	cpl P1.7
	sjmp mLoop
	
przelicz:
	mov A, SS   ;seksundy do ACC
	mov B, #10  ; dzielnik do B
	div AB      ; dzielenie ca�kowite
	mov ZEGAR, B  ;jednostki
	mov ZEGAR + 1, A  ;dziesi�tki
	
	mov A, MM
	mov B, #10
	div AB
	mov ZEGAR + 2, B
	mov ZEGAR + 3, A
	
	mov A, GG
	mov B, #10
	div AB
	mov ZEGAR + 4, B
	mov ZEGAR + 5, A
	ret

wzory:
db 00111111b, 00000110b, 01011011b, 01001111b
db 01100110b, 01101101b, 01111101b, 00000111b
db 01111111b, 01101111b, 01110111b, 01111100b
end
