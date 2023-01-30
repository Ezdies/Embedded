#include <8051.h>

#define TRUE 1
#define FALSE 0
#define WZOR_SIZE 10
#define TH_0 224
#define INTS_PER_SECOND 900
#define LED P1_7
#define CURR_SEG_KEY P3_5
#define SEGS 6
#define STATES 3
#define MAX_CSDS_i 64

// definitions for keyboard

#define ENTER 0b000001
#define ESC 0b000010
#define RIGHT 0b000100
#define UP 0b001000
#define DOWN 0b010000
#define LEFT 0b100000

__code unsigned char WZOR[WZOR_SIZE] = { 0b0111111, 0b0000110, 0b1011011, 0b1001111,
                                         0b1100110, 0b1101101, 0b1111101, 0b0000111, 0b1111111, 0b1101111
                                       };

__bit __at (0x96) SEG_OFF;

unsigned char SS, MM, GG;
unsigned char ZEGAR[SEGS];

unsigned char key_state[STATES];

__xdata unsigned char* CSDS = (__xdata unsigned char *) 0xFF30;
__xdata unsigned char* CSDB = (__xdata unsigned char *) 0xFF38;

unsigned char CSDS_i = 0b00000001;
unsigned char CSDB_i = 0;

unsigned char t0_flag = FALSE;
unsigned int t0_counter = INTS_PER_SECOND;
unsigned char ONE_SEC_PASSED = FALSE;
unsigned char digit_counter = 0;

void t0_int(void) __interrupt(1) {
    TH0 = TH_0;
    t0_flag = TRUE;
    t0_counter--;
    if(t0_counter == 0) {
        ONE_SEC_PASSED = TRUE;
    }
}

void set_init_time(void) {
    GG = 23;
    MM = 59;
    SS = 30;
}

void init_variables(void) {
    TH0 = TH_0;
    TR0 = TRUE;
    ET0 = TRUE;
    ES = TRUE;
    EA = TRUE;
}
void update_SEG7(void) {
    ZEGAR[0] = SS % 10;
    ZEGAR[1] = SS / 10;
    ZEGAR[2] = MM % 10;
    ZEGAR[3] = MM / 10;
    ZEGAR[4] = GG % 10;
    ZEGAR[5] = GG / 10;
}

void print_SEG(void) {
    SEG_OFF = TRUE;
    *CSDS = CSDS_i;
    *CSDB = WZOR[ZEGAR[CSDB_i % WZOR_SIZE]];
    SEG_OFF = FALSE;
}

void update_in_one_sec(void) {
    if(ONE_SEC_PASSED) {
        LED = !LED;
        SS++;
        t0_counter = INTS_PER_SECOND;
        ONE_SEC_PASSED = FALSE;
    }
}

void set_seg_boundaries(void) {
    if(SS == 60) {
        MM++;
        SS = 0;
        if(MM == 60) {
            GG++;
            MM = 0;
            if(GG == 24) {
                GG = 0;
            }
        }
    }
}
void handle_keyboard(void) {
    if(key_state[0] != key_state[1] && key_state[0] != key_state[2]) {

        if(key_state[0] == (ESC | UP)) {
            if(GG != 23) {
                GG++;
                t0_counter = INTS_PER_SECOND;
            }
            else {
                GG = 0;
                update_SEG7();
            }
        }

        if(key_state[0] == (ESC | DOWN)) {
            if(GG != 0) {
                GG--;
                t0_counter = INTS_PER_SECOND;
            }
            else {
                GG = 23;
            }
            update_SEG7();
        }

        if(key_state[0] == (ENTER | UP)) {
            if (MM != 59) {
                MM++;
                t0_counter = INTS_PER_SECOND;
            }
            else {
                MM = 0;
            }
            update_SEG7();
        }

        if(key_state[0] == (ENTER | DOWN)) {
            if(MM != 0) {
                MM--;
                t0_counter = INTS_PER_SECOND;
            }
            else {
                MM = 59;
            }
            update_SEG7();
        }

        if(key_state[0] == (ENTER | LEFT)) {
            if(SS != 59) {
                t0_counter = INTS_PER_SECOND;
                SS++;
            }
            else {
                SS = 0;
            }
            update_SEG7();
        }

        if(key_state[0] == (ENTER | RIGHT)) {
            if(SS != 0) {
                t0_counter = INTS_PER_SECOND;
                SS--;
            }
            else {
                SS = 59;
            }
        }
    }
    key_state[2] = key_state[1];
    key_state[1] = key_state[0];
    key_state[0] = 0;
}

void handle_interrupt(void) {
    if(t0_flag) {
        t0_flag = FALSE;
        print_SEG();
        CSDB_i++;
        //jesli kliknalem przycisk pod obecnym wyswietlaczem
        //ustawia na 1 bity wszystkich wyświetlaczy które minely
        //funkcja handle keyboard je zeruje potem
        if(CURR_SEG_KEY) {
            key_state[0] |= CSDS_i;
        }

        CSDS_i <<= 1;

        if(CSDS_i == MAX_CSDS_i) {
            CSDS_i = 1;
            CSDB_i = 0;

            //jesli nie wszystkie przyciski sa obsluzone obsluz je
            if(key_state[0] > 0) {
                handle_keyboard();
            }
        }
        update_in_one_sec();
        update_SEG7();
    }
}
void main()
{
    set_init_time();
    init_variables();

    while(TRUE) {
        set_seg_boundaries();
        handle_interrupt();
    }
}
