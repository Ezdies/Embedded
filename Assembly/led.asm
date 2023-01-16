; To mój pierwszy program do DSM

TEST bit P1.7
BUZZ bit P1.5
SEG7 bit P1.6

CSDS equ 30h ;wskaŸniki
CSDB equ 38h ;segmenty

ZEGAR equ 7Ah ;wskazanie zegara
SS equ 79h ;sekundy
MM equ 78h ;minuty
GG equ 77h  ;godziny




org 0
	ljmp start


org 0Bh			;procedura obs³ugi przerwania od TIMER0
	mov TH0, #226 ;dla trybu 0
	setb F0 	;informujemy pêtlê g³ówn¹ o wyst¹pieniu przerwania
	reti

org 80h


start:
	mov SS, #53
	mov MM, #47
	mov GG, #21
	
	lcall przelicz



;	mov ZEGAR, #6   ;wstêpne ustawienie zegara
;	mov ZEGAR+1, #5
;	mov ZEGAR+2, #7
;	mov ZEGAR+3, #4
;	mov ZEGAR+4, #1
;	mov ZEGAR+5, #2


	mov R7, #00000001b  ;najm³odszy wyœwietlacz do R7
	mov R1, #ZEGAR   ;adres nam³odszej cyfry zegara do R1
	mov DPTR, #wzory ; adres wzoru wyœwietlacza 7seg do DPTR

	mov IE, #0 	;wy³¹czam obs³ugê wszystkich przerwañ
	
	;zliczanie 960 przerwan
	mov R6, #4
	mov R5, #192
	mov TMOD, #01110000b   ;dla trybu 0
	mov TH0, #226      ;960 przerwañ na sekundê
	setb TR0	;zgoda na zliczenie przez liczniki TIMER0(musi byæ w³¹czona, aby licznik zlicza³)
	setb ET0	;zgoda na obs³ugê przerwania od TIMER0
	setb EA		;globalna zgoda na obs³ugê przerwañ (musi byæ w³¹czone, ¿eby poprzednia zgoda dzia³a³a)

mLoop:
	jnb F0, mLoop	;czeja na wyst¹pienie przerwania
	clr F0          ;zapominamy o przerwaniu
	
; tutaj jestem 960 razy na sekundê

	mov R0, #CSDB   ;adres zatrzasku segmentów do R0
	mov A, @R1      ;aktualna cyfra zegara do ACC
	inc R1          ;wybiera nastêpn¹ cyfrê zegara na potrzeby nastêpnego obrotu pêtli
	setb SEG7       ;wy³¹cza wyœwietlacze ¿eby nie by³o duchów
	movc A, @A+DPTR ;pobiera wzorek z pamiêci ROM
	movx @R0, A     ; wysy³a wzorek do zatrzasku segmentów

	mov R0, #CSDS   ;adres zatrzasku wyœwietlaczy do R0
	mov A, R7       ;aktualny wyœwietlacz do R7

	movx @R0, A      ;wysy³a aktualny wyœwietlacz do zatrzasku wyœwietlaczy
	clr SEG7  	     ;
	rl A
	jnb ACC.7, noACC7
	mov A, #00000001b
	mov R1, #ZEGAR
noACC7:

	mov R7, A

	djnz R5, mLoop
	djnz R6, mLoop

	mov R6, #4 ;zliczanie 960 przerwañ
	mov R5, #192

; tutaj jestem raz na sekuncê
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
	div AB      ; dzielenie ca³kowite
	mov ZEGAR, B  ;jednostki
	mov ZEGAR + 1, A  ;dziesi¹tki
	
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
