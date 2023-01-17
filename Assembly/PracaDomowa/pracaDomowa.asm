;
; Moj pierwszy program dla DSM
; PD: Zabezpieczyc ustawianie godziny, zeby nie wychodzic poza zakres

TEST bit P1.7
BUZZER bit P1.5
SEG7 bit P1.6
SKEY bit P3.5

CSDS equ 30h 				; Adres rejestru aktywnych wyswietlaczy
CSDB equ 38h 				; Adres rejestru aktywnych segmentow

KEYS  equ 7Ch				; 4 ostatnie stany klawiatury
ZEGAR equ 76h 				; Tablica na 6 cyfr wskazania zegara
SS	equ 75h			; Licznik sekund
MM    equ 74h				; Licznik minut
GG    equ 73h				; Licznik godzin


org 0
	ljmp start

org 0Bh						; Procedura obslugi przerwania od TIMER0
	mov TH0, #224           ; Dla trybu 0 900 przerwan na sekunde co 1024 cykle maszynowe
	setb F0
	reti            		; Powrot z przerwania

org 80h
start:
	mov SS, #52
	mov MM, #46
	mov GG, #22
	
	lcall przelicz

	mov R1, #ZEGAR 			; Po tablicy z cyframi zegara chodzimy wskaznikiem R1

	clr SEG7 				; Wlacz 7-segment
	mov R7, #00000001b 		; Zaczynamy od "najmlodszego" wyswietlacza
	mov DPTR, #wzory        ; Adres tablicy przechowywujacej wzory 7-seg do DPTR

    mov IE, #0				; Blokujemy wszystkie przerwania
	mov TMOD, #01110000b	; Blokada TIMER1, TIMER0 w trybie 0
	mov TH0, #224           ; 900 przerwan na sekunde co 1024 cykle maszynowe

	mov R6, #132            ; Zliczanie do 900, zeby pierwsza sekunda trwala sekunde
	mov R5, #4          

	setb TR0				; zgoda na zliczanie przez liczniki TIMERa0
	setb ET0				; zgoda na obsluge przerwania od TIMER0
	setb EA					; globalna zgoda na obsluge przerwania

main_loop:
	jnb F0, main_loop		; Czekamy na przerwanie
	clr F0					; Zapominamy o przerwaniu
	
	; Tutaj jestem 900 razy na sekunde

	; Cyfra
	mov R0, #CSDB 			; Zaladuj adres CSDB do R0
	mov A, @R1              ; Aktualna cyfra zegara do akumulatora
	inc R1                  ; W nastepnym obrocie petli wez nastepna cyfre
	setb SEG7               ; Wylacz 7-segment (anti-ghosting)
	movx @R0, A             ; Wysylamy wzorek do rejestru segmentow

	; Wyswietlacz
	mov R0, #CSDS 			; Zaladuj adres CSDS do R0
	mov A, R7				; Aktualny wyswietlacz do akumulatora
	movx @R0, A             ; Wybierz wyswietlacz
	clr SEG7                ; Wlacz 7-segment
	
	jnb SKEY, noKey
	orl KEYS, A

noKey:
	rl A                    ; W nastepnym obrocie petli wez nastepny wyswietlacz
	mov R7, A				; Zapamietaj w R7 nowy wyswietlacz
	jnb ACC.7, noACC7 		; Jesli bit 7 = 0, skocz do noACC7
	mov R7, #00000001b       ; Jesli nie, zaczynam znowu od "najmlodszego" wyswietlacza
	mov R1, #ZEGAR 			; Wracamy na poczatek tablicy ZEGAR

	; Debouncing klawiatury, 3 takie same, 1 nie aby zareagowac tylko raz!
	mov A, KEYS
	cjne A, KEYS+1, unstable
	cjne A, KEYS+2, unstable
	cjne A, KEYS+3, stable
	sjmp unstable

stable:
	jz unstable				; Nie reagujemy na puszczenie klawisza
	lcall obslugaKlawiatury
unstable:
	mov KEYS+3, KEYS+2      ;
	mov KEYS+2, KEYS+1      ;
	mov KEYS+1, KEYS		;
	mov KEYS, #0            ; Skladaj klawiature od poczatku
noACC7:
	djnz R6, main_loop      ; Skocz do main_loop jesli R6 nie zero
	djnz R5, main_loop      ; Skocz do main_loop jesli R5 nie zero

	mov R6, #132            ; Zliczanie do 900 (pelna sekunda)
	mov R5, #4
	
	; Tutaj jestem co sekunde
	;cpl P1.7
	inc SS        			; Zwieksz sekundy

	; Zwiekszanie minut/godzin przy przepelnieniu
	mov A, SS
	cjne A, #60, nie60      ; Jesli sekundy != 60, pomijamy
	mov SS, #0              ; Jezeli tak, zerujemy sekundy
	inc MM                  ; I zwiekszamy minuty
	
	mov A, MM
	cjne A, #60, nie60
	mov MM, #0
	inc GG
	
	mov A, GG
	cjne A, #24, nie60
	mov GG, #0

nie60:
	lcall przelicz

	sjmp main_loop

obslugaKlawiatury:          ; Zakladamy ze stan klawiatury jest w akumulatorze
	cjne A, #100010b, nieLewoEsc
	inc GG
	mov A, GG
	cjne A, #24, obslugaKlawiatury
	mov GG, #0

nieLewoEsc:
	cjne A, #100001b, nieLewoEnter
	dec GG
	mov A, GG
	cjne A, #-1, nieLewoEsc
	mov GG, #23

nieLewoEnter:
	cjne A, #10010b, nieDolEsc
	inc MM
	mov A, MM
	cjne A, #60, nieLewoEnter
	mov MM, #0
nieDolEsc:
	cjne A, #10001b, nieDolEnter
	dec MM
	mov A, MM
	cjne A, #-1, nieDolEsc
	mov MM, #60
nieDolEnter:
	cjne A, #110b, niePrawoEsc
	inc SS
	mov A, SS
	cjne A, #60, nieDolEnter
	mov SS, #0
niePrawoEsc:
	cjne A, #101b, niePrawoEnter
	dec SS
	mov A, SS
	cjne A, #-1, niePrawoEsc
	mov SS, #60
niePrawoEnter:
	cjne A, #1000b, nieGora
	mov SS, #0
	mov R6, #132            ; Zliczanie do 900 (pelna sekunda)
	mov R5, #4
nieGora:
	lcall przelicz
	ret

przelicz:                   ; Przeliczanie liczb z GG, MM i SS na cyfry dla tablicy ZEGAR
	mov DPTR, #wzory

	mov A, SS				; Zaladuj do akumulator licznik sekund
	mov B, #10
	div AB					; Podziel sekundy przez 10
	movc A, @A+DPTR         ; Pobieramy wzorek cyfry dziesiatek sekund z pamieci ROM
	mov ZEGAR+1, A          ; Umieszczamy go w odpowiednim miejscu
	mov A, B                ; Jednostki sekund do akumulatora
	movc A, @A+DPTR         ; Pobieramy wzorek cyfry jednostek sekund z pamieci ROM
	mov ZEGAR, A            ; Umieszczamy go w odpowiednim miejscu

	mov A, MM				; Zaladuj do akumulator licznik minut
	mov B, #10
	div AB					; Podziel minuty przez 10
	movc A, @A+DPTR         ; Pobieramy wzorek cyfry dziesiatek minut z pamieci ROM
	mov ZEGAR+3, A          ; Umieszczamy go w odpowiednim miejscu
	mov A, B                ; Jednostki minut do akumulatora
	movc A, @A+DPTR         ; Pobieramy wzorek cyfry jednostek minut z pamieci ROM
	mov ZEGAR+2, A          ; Umieszczamy go w odpowiednim miejscu

	mov A, GG				; Zaladuj do akumulator licznik godzin
	mov B, #10
	div AB					; Podziel godzin przez 10
	movc A, @A+DPTR         ; Pobieramy wzorek cyfry dziesiatek godzin z pamieci ROM
	mov ZEGAR+5, A          ; Umieszczamy go w odpowiednim miejscu
	mov A, B                ; Jednostki godzin do akumulatora
	movc A, @A+DPTR         ; Pobieramy wzorek cyfry jednostek godzin z pamieci ROM
	mov ZEGAR+4, A          ; Umieszczamy go w odpowiednim miejscu

	ret                     ; Powrot z funkcji

wzory:                      ; Wzorki wyswietlacza 7-seg w pamieci ROM
db 00111111b, 00000110b, 01011011b, 01001111b
db 01100110b, 01101101b, 01111101b, 00000111b
db 01111111b, 01101111b, 01110111b, 01111100b

end