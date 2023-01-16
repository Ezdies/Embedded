// pierwszy program w C do DSM-51
//obs�uga wy�wietlacza
#include <8051.h>
#define TRUE 1
#define FALSE 0
#define WZOR_SIZE 10

//obs�uga przerwa�
///////////////////////////////////////////////////////////

#define T0_DAT 65535-921 // przerwanie T0 co 1ms
#define TL_0 T0_DAT%256  // tak bedzie latwiej
#define TH_0 T0_DAT/256  // przeładować  timer
#define T100 100         // pokres LED

unsigned char timer_buf; // czasomierz programowy
unsigned char send_buf;  // bufor bajtu nadawanego

__bit __at (0x97) LED;   // bit 7 portu P1 sterujący LED
__bit rec_flag;          // flaga odebrania znaku
__bit send_flag;         // dane gotowe do transmisji
__bit t0_flag;           // flaga przerwania licznika T0

void rec_serv(void);
void send_serv(void);
void t0_serv(void);

//koniec obs�ugi przerwa�

// zmienne globalne do obs�ugi wy�wietlaczy
//////////////////////////////////////////////////////////

__code unsigned char WZOR[WZOR_SIZE] = { 0b0111111, 0b0000110,
               0b1011011, 0b1001111, 0b1100110, 0b1101101,
              0b1111101, 0b0000111, 0b1111111, 0b1101111};
              
__bit __at (0x96) SEG_OFF;

//koniec zmiennych globalnych do obsługi wyświetlaczy
/////////////////////////////////////////////////////




void main()
{
    __xdata unsigned char* led_wyb = (__xdata unsigned char*) 0xFF30;
    __xdata unsigned char* led_led = (__xdata unsigned char*) 0xFF38;
    unsigned char led_p, led_b;
     //SDCC generuje kod ustawiajacy Stack Pointer

     // PRZYGOTOWANIE  ŚRODOWISKA
    //-------------------------

    //ustawienie rejestr�w kontrolnych
    //--------------------------------

     PCON = 0x80; // zegar dla sio, T1 (19200 b/s)
     SCON = 0b01010000;   //ustaw parametry transmisji
                         //tryb 1: 8 bit�w, szybko �� : T1
     TMOD = 0b00100001;   //ustaw T1 w tryb 2; T0 w tryb 1

     TL0 = TL_0; //ustawienie m�odszego i starszego
     TH0 = TH_0; //bajtu T0 przerwanie co 1 milisekund �

     TL1 = 0xFD; //ustawienie m�odszego
     TH1 = 0xFD; //i starszego bajtu T1 (19200)

     //inne ustawienia
     //---------------
     timer_buf  = T100;   // �aduj timeout T0 (100ms)
     send_flag  = FALSE;  // kasuj flag �  gotowo � ci danych
     rec_flag   = FALSE;  // kasuj flag �  odbiornik gotowy
     t0_flag    = FALSE;  // zeruj flag �  przerw. t0_int

     ET0 = TRUE; // aktywuj przerwanie od licznika T0
     ES  = TRUE; // aktywuj przerwanie od UART
     EA  = TRUE; // aktywuj wszystkie przerwania
     TR0 = TRUE; // uruchom licznik T0
     TR1 = TRUE; // uruchom licznik T1 
     

    //wy�wietlanie i obs�uga wy�wietlaczy
    //////////////////////////////////////////////////////////////////////


    while (TRUE) {

         if (rec_flag) {      //odebrany bajt w buf. UART
             rec_flag = FALSE;//kasuj flag �  bajt odebrany
             rec_serv();      //obs�u S  odebrany bajt
         }

         if (send_flag){       //trzeba wys�a�  dane UART
             send_serv();     //wykonaj obs�ug�  nadawania
         }
             //podczas ostatniego obrotu p�tli wyst�pi�o
         if (t0_flag) {       //przerwanie zegarowe
             t0_flag = FALSE; //zeruj flag�
             t0_serv();       //obs�u� przerwanie od T0
         }


    //obsługa wyświetlaczy w pętli
    //////////////////////////////////
        for (led_p = 0, led_b = 1; led_p < 6;  led_p++,  led_b += led_b){
             SEG_OFF = TRUE;
             *led_wyb = led_b;
             *led_led = WZOR[led_p+4];
             SEG_OFF = FALSE;
			     }
    }
    //koniec wy�wietlania i obs�ugi wy�wietlaczy
    ///////////////////////////////////////////////////////////////////////////

    return;
}


// funkcje do obs�ugi przerwa�
    /////////////////////////////////////////////////////////////////////////
    
void t0_serv(void)
 {
     if (timer_buf){
         timer_buf--;         //zmniejsz stan czasomierza
     }
     else {
         timer_buf = T100;    //regeneruj licznik (100ms)
         LED = !LED;          //zmie�  stan diody LED
     }
 }

void rec_serv(void)
 {
     unsigned char uc = SBUF; //pobierz z bufara RS'a
     if (( uc >= 'a' ) && ( uc < 'z' + 1 ))
         uc += 'A' - 'a';   //zamie�  ma��  na wielk�

     send_buf = uc;         //zapami�taj w buforze
     send_flag = TRUE;      //ustaw flag�  gotowo�ci danych
 }

void send_serv(void)
 {
     if (TI) //nadajnik nie jest gotowy
         return;

     send_flag = FALSE;     //zeruj flag� nadawania bajtu
     SBUF = send_buf;       //wy�lij bajt
 }

void t0_int(void) __interrupt(1)
 {
     TL0 = TL0 | TL_0;      //od�wie�a licznik T0
     TH0 = TH_0;            //ustawia flag� sygnalizuj�c�
     t0_flag = TRUE;        //fakt wyst�pienia przerwania
 }