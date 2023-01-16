;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
	.module helloLED
	.optsdcc -mmcs51 --model-small
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _WZOR
	.globl _t0_int
	.globl _main
	.globl _CY
	.globl _AC
	.globl _F0
	.globl _RS1
	.globl _RS0
	.globl _OV
	.globl _F1
	.globl _P
	.globl _PS
	.globl _PT1
	.globl _PX1
	.globl _PT0
	.globl _PX0
	.globl _RD
	.globl _WR
	.globl _T1
	.globl _T0
	.globl _INT1
	.globl _INT0
	.globl _TXD
	.globl _RXD
	.globl _P3_7
	.globl _P3_6
	.globl _P3_5
	.globl _P3_4
	.globl _P3_3
	.globl _P3_2
	.globl _P3_1
	.globl _P3_0
	.globl _EA
	.globl _ES
	.globl _ET1
	.globl _EX1
	.globl _ET0
	.globl _EX0
	.globl _P2_7
	.globl _P2_6
	.globl _P2_5
	.globl _P2_4
	.globl _P2_3
	.globl _P2_2
	.globl _P2_1
	.globl _P2_0
	.globl _SM0
	.globl _SM1
	.globl _SM2
	.globl _REN
	.globl _TB8
	.globl _RB8
	.globl _TI
	.globl _RI
	.globl _P1_7
	.globl _P1_6
	.globl _P1_5
	.globl _P1_4
	.globl _P1_3
	.globl _P1_2
	.globl _P1_1
	.globl _P1_0
	.globl _TF1
	.globl _TR1
	.globl _TF0
	.globl _TR0
	.globl _IE1
	.globl _IT1
	.globl _IE0
	.globl _IT0
	.globl _P0_7
	.globl _P0_6
	.globl _P0_5
	.globl _P0_4
	.globl _P0_3
	.globl _P0_2
	.globl _P0_1
	.globl _P0_0
	.globl _B
	.globl _ACC
	.globl _PSW
	.globl _IP
	.globl _P3
	.globl _IE
	.globl _P2
	.globl _SBUF
	.globl _SCON
	.globl _P1
	.globl _TH1
	.globl _TH0
	.globl _TL1
	.globl _TL0
	.globl _TMOD
	.globl _TCON
	.globl _PCON
	.globl _DPH
	.globl _DPL
	.globl _SP
	.globl _P0
	.globl _SEG_OFF
	.globl _t0_flag
	.globl _send_flag
	.globl _rec_flag
	.globl _LED
	.globl _send_buf
	.globl _timer_buf
	.globl _t0_serv
	.globl _rec_serv
	.globl _send_serv
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
_P0	=	0x0080
_SP	=	0x0081
_DPL	=	0x0082
_DPH	=	0x0083
_PCON	=	0x0087
_TCON	=	0x0088
_TMOD	=	0x0089
_TL0	=	0x008a
_TL1	=	0x008b
_TH0	=	0x008c
_TH1	=	0x008d
_P1	=	0x0090
_SCON	=	0x0098
_SBUF	=	0x0099
_P2	=	0x00a0
_IE	=	0x00a8
_P3	=	0x00b0
_IP	=	0x00b8
_PSW	=	0x00d0
_ACC	=	0x00e0
_B	=	0x00f0
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
_P0_0	=	0x0080
_P0_1	=	0x0081
_P0_2	=	0x0082
_P0_3	=	0x0083
_P0_4	=	0x0084
_P0_5	=	0x0085
_P0_6	=	0x0086
_P0_7	=	0x0087
_IT0	=	0x0088
_IE0	=	0x0089
_IT1	=	0x008a
_IE1	=	0x008b
_TR0	=	0x008c
_TF0	=	0x008d
_TR1	=	0x008e
_TF1	=	0x008f
_P1_0	=	0x0090
_P1_1	=	0x0091
_P1_2	=	0x0092
_P1_3	=	0x0093
_P1_4	=	0x0094
_P1_5	=	0x0095
_P1_6	=	0x0096
_P1_7	=	0x0097
_RI	=	0x0098
_TI	=	0x0099
_RB8	=	0x009a
_TB8	=	0x009b
_REN	=	0x009c
_SM2	=	0x009d
_SM1	=	0x009e
_SM0	=	0x009f
_P2_0	=	0x00a0
_P2_1	=	0x00a1
_P2_2	=	0x00a2
_P2_3	=	0x00a3
_P2_4	=	0x00a4
_P2_5	=	0x00a5
_P2_6	=	0x00a6
_P2_7	=	0x00a7
_EX0	=	0x00a8
_ET0	=	0x00a9
_EX1	=	0x00aa
_ET1	=	0x00ab
_ES	=	0x00ac
_EA	=	0x00af
_P3_0	=	0x00b0
_P3_1	=	0x00b1
_P3_2	=	0x00b2
_P3_3	=	0x00b3
_P3_4	=	0x00b4
_P3_5	=	0x00b5
_P3_6	=	0x00b6
_P3_7	=	0x00b7
_RXD	=	0x00b0
_TXD	=	0x00b1
_INT0	=	0x00b2
_INT1	=	0x00b3
_T0	=	0x00b4
_T1	=	0x00b5
_WR	=	0x00b6
_RD	=	0x00b7
_PX0	=	0x00b8
_PT0	=	0x00b9
_PX1	=	0x00ba
_PT1	=	0x00bb
_PS	=	0x00bc
_P	=	0x00d0
_F1	=	0x00d1
_OV	=	0x00d2
_RS0	=	0x00d3
_RS1	=	0x00d4
_F0	=	0x00d5
_AC	=	0x00d6
_CY	=	0x00d7
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	.area REG_BANK_0	(REL,OVR,DATA)
	.ds 8
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	.area DSEG    (DATA)
_timer_buf::
	.ds 1
_send_buf::
	.ds 1
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	.area	OSEG    (OVR,DATA)
;--------------------------------------------------------
; Stack segment in internal ram 
;--------------------------------------------------------
	.area	SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	.area ISEG    (DATA)
;--------------------------------------------------------
; absolute internal ram data
;--------------------------------------------------------
	.area IABS    (ABS,DATA)
	.area IABS    (ABS,DATA)
;--------------------------------------------------------
; bit data
;--------------------------------------------------------
	.area BSEG    (BIT)
_LED	=	0x0097
_rec_flag::
	.ds 1
_send_flag::
	.ds 1
_t0_flag::
	.ds 1
_SEG_OFF	=	0x0096
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	.area PSEG    (PAG,XDATA)
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area XABS    (ABS,XDATA)
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
	.area XISEG   (XDATA)
	.area HOME    (CODE)
	.area GSINIT0 (CODE)
	.area GSINIT1 (CODE)
	.area GSINIT2 (CODE)
	.area GSINIT3 (CODE)
	.area GSINIT4 (CODE)
	.area GSINIT5 (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area CSEG    (CODE)
;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------
	.area HOME    (CODE)
__interrupt_vect:
	ljmp	__sdcc_gsinit_startup
	reti
	.ds	7
	ljmp	_t0_int
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME    (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area GSINIT  (CODE)
	.globl __sdcc_gsinit_startup
	.globl __sdcc_program_startup
	.globl __start__stack
	.globl __mcs51_genXINIT
	.globl __mcs51_genXRAMCLEAR
	.globl __mcs51_genRAMCLEAR
	.area GSFINAL (CODE)
	ljmp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME    (CODE)
	.area HOME    (CODE)
__sdcc_program_startup:
	ljmp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CSEG    (CODE)
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;led_wyb                   Allocated to registers 
;led_led                   Allocated to registers 
;led_p                     Allocated to registers r6 
;led_b                     Allocated to registers r7 
;------------------------------------------------------------
;	helloLED.c:45: void main()
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
;	helloLED.c:58: PCON = 0x80; // zegar dla sio, T1 (19200 b/s)
	mov	_PCON,#0x80
;	helloLED.c:59: SCON = 0b01010000;   //ustaw parametry transmisji
	mov	_SCON,#0x50
;	helloLED.c:61: TMOD = 0b00100001;   //ustaw T1 w tryb 2; T0 w tryb 1
	mov	_TMOD,#0x21
;	helloLED.c:63: TL0 = TL_0; //ustawienie m�odszego i starszego
	mov	_TL0,#0x66
;	helloLED.c:64: TH0 = TH_0; //bajtu T0 przerwanie co 1 milisekund �
	mov	_TH0,#0xfc
;	helloLED.c:66: TL1 = 0xFD; //ustawienie m�odszego
	mov	_TL1,#0xfd
;	helloLED.c:67: TH1 = 0xFD; //i starszego bajtu T1 (19200)
	mov	_TH1,#0xfd
;	helloLED.c:71: timer_buf  = T100;   // �aduj timeout T0 (100ms)
	mov	_timer_buf,#0x64
;	helloLED.c:72: send_flag  = FALSE;  // kasuj flag �  gotowo � ci danych
;	assignBit
	clr	_send_flag
;	helloLED.c:73: rec_flag   = FALSE;  // kasuj flag �  odbiornik gotowy
;	assignBit
	clr	_rec_flag
;	helloLED.c:74: t0_flag    = FALSE;  // zeruj flag �  przerw. t0_int
;	assignBit
	clr	_t0_flag
;	helloLED.c:76: ET0 = TRUE; // aktywuj przerwanie od licznika T0
;	assignBit
	setb	_ET0
;	helloLED.c:77: ES  = TRUE; // aktywuj przerwanie od UART
;	assignBit
	setb	_ES
;	helloLED.c:78: EA  = TRUE; // aktywuj wszystkie przerwania
;	assignBit
	setb	_EA
;	helloLED.c:79: TR0 = TRUE; // uruchom licznik T0
;	assignBit
	setb	_TR0
;	helloLED.c:80: TR1 = TRUE; // uruchom licznik T1 
;	assignBit
	setb	_TR1
;	helloLED.c:87: while (TRUE) {
00109$:
;	helloLED.c:89: if (rec_flag) {      //odebrany bajt w buf. UART
;	helloLED.c:90: rec_flag = FALSE;//kasuj flag �  bajt odebrany
;	assignBit
	jbc	_rec_flag,00140$
	sjmp	00102$
00140$:
;	helloLED.c:91: rec_serv();      //obs�u S  odebrany bajt
	lcall	_rec_serv
00102$:
;	helloLED.c:94: if (send_flag){       //trzeba wys�a�  dane UART
	jnb	_send_flag,00104$
;	helloLED.c:95: send_serv();     //wykonaj obs�ug�  nadawania
	lcall	_send_serv
00104$:
;	helloLED.c:98: if (t0_flag) {       //przerwanie zegarowe
;	helloLED.c:99: t0_flag = FALSE; //zeruj flag�
;	assignBit
	jbc	_t0_flag,00142$
	sjmp	00106$
00142$:
;	helloLED.c:100: t0_serv();       //obs�u� przerwanie od T0
	lcall	_t0_serv
00106$:
;	helloLED.c:106: for (led_p = 0, led_b = 1; led_p < 6;  led_p++,  led_b += led_b){
	mov	r7,#0x01
	mov	r6,#0x00
00112$:
	cjne	r6,#0x06,00143$
00143$:
	jnc	00109$
;	helloLED.c:107: SEG_OFF = TRUE;
;	assignBit
	setb	_SEG_OFF
;	helloLED.c:108: *led_wyb = led_b;
	mov	dptr,#0xff30
	mov	a,r7
	movx	@dptr,a
;	helloLED.c:109: *led_led = WZOR[led_p+4];
	mov	ar5,r6
	mov	a,r5
	add	a,#0x04
	mov	r5,a
	rlc	a
	subb	a,acc
	mov	r4,a
	mov	a,r5
	add	a,#_WZOR
	mov	dpl,a
	mov	a,r4
	addc	a,#(_WZOR >> 8)
	mov	dph,a
	clr	a
	movc	a,@a+dptr
	mov	r5,a
	mov	dptr,#0xff38
	movx	@dptr,a
;	helloLED.c:110: SEG_OFF = FALSE;
;	assignBit
	clr	_SEG_OFF
;	helloLED.c:106: for (led_p = 0, led_b = 1; led_p < 6;  led_p++,  led_b += led_b){
	inc	r6
	mov	a,r7
	add	a,r7
	mov	r7,a
;	helloLED.c:116: return;
;	helloLED.c:117: }
	sjmp	00112$
;------------------------------------------------------------
;Allocation info for local variables in function 't0_serv'
;------------------------------------------------------------
;	helloLED.c:123: void t0_serv(void)
;	-----------------------------------------
;	 function t0_serv
;	-----------------------------------------
_t0_serv:
;	helloLED.c:125: if (timer_buf){
	mov	a,_timer_buf
	jz	00102$
;	helloLED.c:126: timer_buf--;         //zmniejsz stan czasomierza
	dec	_timer_buf
	ret
00102$:
;	helloLED.c:129: timer_buf = T100;    //regeneruj licznik (100ms)
	mov	_timer_buf,#0x64
;	helloLED.c:130: LED = !LED;          //zmie�  stan diody LED
	cpl	_LED
;	helloLED.c:132: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'rec_serv'
;------------------------------------------------------------
;uc                        Allocated to registers r7 
;------------------------------------------------------------
;	helloLED.c:134: void rec_serv(void)
;	-----------------------------------------
;	 function rec_serv
;	-----------------------------------------
_rec_serv:
;	helloLED.c:136: unsigned char uc = SBUF; //pobierz z bufara RS'a
	mov	r7,_SBUF
;	helloLED.c:137: if (( uc >= 'a' ) && ( uc < 'z' + 1 ))
	cjne	r7,#0x61,00114$
00114$:
	jc	00102$
	cjne	r7,#0x7b,00116$
00116$:
	jnc	00102$
;	helloLED.c:138: uc += 'A' - 'a';   //zamie�  ma��  na wielk�
	mov	ar6,r7
	mov	a,#0xe0
	add	a,r6
	mov	r7,a
00102$:
;	helloLED.c:140: send_buf = uc;         //zapami�taj w buforze
	mov	_send_buf,r7
;	helloLED.c:141: send_flag = TRUE;      //ustaw flag�  gotowo�ci danych
;	assignBit
	setb	_send_flag
;	helloLED.c:142: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'send_serv'
;------------------------------------------------------------
;	helloLED.c:144: void send_serv(void)
;	-----------------------------------------
;	 function send_serv
;	-----------------------------------------
_send_serv:
;	helloLED.c:146: if (TI) //nadajnik nie jest gotowy
	jnb	_TI,00102$
;	helloLED.c:147: return;
	ret
00102$:
;	helloLED.c:149: send_flag = FALSE;     //zeruj flag� nadawania bajtu
;	assignBit
	clr	_send_flag
;	helloLED.c:150: SBUF = send_buf;       //wy�lij bajt
	mov	_SBUF,_send_buf
;	helloLED.c:151: }
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 't0_int'
;------------------------------------------------------------
;	helloLED.c:153: void t0_int(void) __interrupt(1)
;	-----------------------------------------
;	 function t0_int
;	-----------------------------------------
_t0_int:
;	helloLED.c:155: TL0 = TL0 | TL_0;      //od�wie�a licznik T0
	orl	_TL0,#0x66
;	helloLED.c:156: TH0 = TH_0;            //ustawia flag� sygnalizuj�c�
	mov	_TH0,#0xfc
;	helloLED.c:157: t0_flag = TRUE;        //fakt wyst�pienia przerwania
;	assignBit
	setb	_t0_flag
;	helloLED.c:158: }
	reti
;	eliminated unneeded mov psw,# (no regs used in bank)
;	eliminated unneeded push/pop psw
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;	eliminated unneeded push/pop acc
	.area CSEG    (CODE)
	.area CONST   (CODE)
_WZOR:
	.db #0x3f	; 63
	.db #0x06	; 6
	.db #0x5b	; 91
	.db #0x4f	; 79	'O'
	.db #0x66	; 102	'f'
	.db #0x6d	; 109	'm'
	.db #0x7d	; 125
	.db #0x07	; 7
	.db #0x7f	; 127
	.db #0x6f	; 111	'o'
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
