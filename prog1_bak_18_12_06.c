/*****************************************************
Project : ��� �����-� 
Version : V1.02.01
Date    : 16.12.2006
Author  : �������� �������          
Company : ��� �������           
Comments: V1.24.5 Standard

Chip type           : ATmega16
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
Data Stack size     : 256
*****************************************************/
#include <mega16.h>
#include <delay.h>

#define buzern          PORTC.0
#define buzerp          PORTC.1

#define anode1          PORTC.3
#define anode2          PORTC.4
#define anode3          PORTC.5
#define anode4          PORTC.6
#define anode5          PORTC.7

#define kanodeA         PORTA.0
#define kanodeB         PORTA.1
#define kanodeC         PORTA.2
#define kanodeD         PORTA.3
#define kanodeE         PORTA.4
#define kanodeF         PORTA.5
#define kanodeG         PORTA.6
#define kanodeH         PORTA.7

#define relay_alarm1    PORTB.0
#define relay_alarm2    PORTB.1

#define rx_tx           PORTD.2
#define power           PORTD.3
#define cs              PORTB.4

#define key_1           PIND.4
#define key_2           PIND.5
#define key_3           PIND.6
#define key_4           PIND.7

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define TCNT0_reload  110
#define TCNT2_reload  131

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 32
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE<256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index]=data;
   if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      };
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 32
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE<256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index];
   if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index]=c;
   if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>
bit buzer_en,buzer,pik_en;
char pik_count;
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
        {//���������� ��� ������
        TCNT0=TCNT0_reload;
        #asm("wdr");
        if (buzer_en==1)
                {
                if (buzer==1) {buzerp=1;buzer=0;}
                else {buzerp=0;buzer=1;}
                }
        else if (pik_en==1)
                {
                if (++pik_count>200) {pik_en=0;pik_count=0;}
                if (buzer==1) {buzerp=1;buzer=0;}
                else {buzerp=0;buzer=1;}
                }
        else buzerp=0;
        }
char led_byte[5,2];
interrupt [TIM0_COMP] void timer0_comp_isr(void){}
interrupt [TIM1_OVF] void timer1_ovf_isr(void){TCNT1H=0x00;TCNT1L=0x01;}
interrupt [TIM1_CAPT] void timer1_capt_isr(void){}
interrupt [TIM1_COMPA] void timer1_compa_isr(void){}
interrupt [TIM1_COMPB] void timer1_compb_isr(void){}
long sys_time;
bit key_mode,key_plus,key_mines,key_enter,key_mode_press,key_plus_press,key_mines_press,key_enter_press;
char count_led;
int count_blink;
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
        {//���������� 500���
        char n;
        TCNT2=TCNT2_reload;
        sys_time=sys_time+1;
        if (key_1==0) {key_mode=1;if (key_mode_press==0)pik_en=1;key_mode_press=1;}
        else {key_mode=0;key_mode_press=0;}
        if (key_2==0) {key_plus=1;if (key_plus_press==0)pik_en=1;key_plus_press=1;}
        else {key_plus=0;key_plus_press=0;}
        if (key_3==0) {key_mines=1;if (key_mines_press==0)pik_en=1;key_mines_press=1;}
        else {key_mines=0;key_mines_press=0;}
        if (key_4==0) {key_enter=1;if (key_enter_press==0)pik_en=1;key_enter_press=1;}
        else {key_enter=0;key_enter_press=0;}
        
        
        
        if (++count_blink>2000) count_blink=0;
        if (count_blink<1700) n=0;
        if (count_blink<300) n=1;
        PORTA=0xFF;
        anode1=0;anode2=0;anode3=0;anode4=0;
        DDRC.3=0;DDRC.4=0;DDRC.5=0;DDRC.6=0;DDRC.7=0;
        switch (count_led)        
                {
                case 9: count_led=0;anode1=1;DDRC.3=1;PORTA=led_byte[0,n];break;
                case 8: count_led=9;anode1=1;DDRC.3=1;PORTA=led_byte[0,n];break;
                case 7: count_led=8;anode2=1;DDRC.4=1;PORTA=led_byte[1,n];break;
                case 6: count_led=7;anode2=1;DDRC.4=1;PORTA=led_byte[1,n];break;
                case 5: count_led=6;anode3=1;DDRC.5=1;PORTA=led_byte[2,n];break;
                case 4: count_led=5;anode3=1;DDRC.5=1;PORTA=led_byte[2,n];break;
                case 3: count_led=4;anode4=1;DDRC.6=1;PORTA=led_byte[3,n];break;
                case 2: count_led=3;anode4=1;DDRC.6=1;PORTA=led_byte[3,n];break;
                case 1: count_led=2;anode5=0;DDRC.7=0;PORTA=0xFF;break;
                default:count_led=1;anode5=1;DDRC.7=1;PORTA=led_byte[4,n];break;
                }
        }

interrupt [TIM2_COMP] void timer2_comp_isr(void){}

// SPI functions
#include <spi.h>

// Declare your global variables here
eeprom signed int ee_array[20]={1,1,1,1,1,1,-999,9999,10,50,6,3,5,1,1,1111};
char mode;

char led_calk(char a)
        {
        switch (a)
                {
                case 0:   a=0b01000000;break;
                case 1:   a=0b01111001;break;
                case 2:   a=0b00100100;break;
                case 3:   a=0b00110000;break;
                case 4:   a=0b00011001;break;
                case 5:   a=0b00010010;break;
                case 6:   a=0b00000010;break;
                case 7:   a=0b01111000;break;
                case 8:   a=0b00000000;break;
                case 9:   a=0b00010000;break;
                case ' ': a=0b01111111;break;


                case '-': a=0b01100101;break;
                case 't': a=0b01110010;break;
                case 'b': a=0b01111001;break;
                case 'c': a=0b00111100;break;
                case 'd': a=0b01011110;break;
                case 'e': a=0b00101111;break;
                case 'f': a=0b00010111;break;
                case 'g': a=0b01001011;break;
                case 'h': a=0b01100101;break;
                default:  a=0b01110010;break;
                }
        return a;
        }
        
void set_led_on(char a,char b,char c,char d,char p1, char p2,char p3,char p4)
        {//��������� ������ ��� ����������� � �����
        char i;
        if (p1==0) {i=led_byte[0,0];i=i|128;led_byte[0,0]=i;}
        else       {i=led_byte[0,0];i=i&127;led_byte[0,0]=i;}
        if (p2==0) {i=led_byte[1,0];i=i|128;led_byte[1,0]=i;}
        else       {i=led_byte[1,0];i=i&127;led_byte[1,0]=i;}
        if (p3==0) {i=led_byte[2,0];i=i|128;led_byte[2,0]=i;}
        else       {i=led_byte[2,0];i=i&127;led_byte[2,0]=i;}
        if (p4==0) {i=led_byte[3,0];i=i|128;led_byte[3,0]=i;}
        else       {i=led_byte[3,0];i=i&127;led_byte[3,0]=i;}

        if (a==0)  led_byte[4,0]=led_byte[4,0]|1;
        else       led_byte[4,0]=led_byte[4,0]&0b11111110;
        if (b==0)  led_byte[4,0]=led_byte[4,0]|2;
        else       led_byte[4,0]=led_byte[4,0]&0b11111101;
        if (c==0)  led_byte[4,0]=led_byte[4,0]|4;
        else       led_byte[4,0]=led_byte[4,0]&0b11111011;
        if (d==0)  led_byte[4,0]=led_byte[4,0]|8;
        else       led_byte[4,0]=led_byte[4,0]&0b11110111;
        }
void set_led_off(char a,char b,char c,char d,char p1, char p2,char p3,char p4)
        {//��������� ������ ��� ����������� � �����
        char i;
        if (p1==0) {i=led_byte[0,1];i=i|128;led_byte[0,1]=i;}
        else       {i=led_byte[0,1];i=i&127;led_byte[0,1]=i;}
        if (p2==0) {i=led_byte[1,1];i=i|128;led_byte[1,1]=i;}
        else       {i=led_byte[1,1];i=i&127;led_byte[1,1]=i;}
        if (p3==0) {i=led_byte[2,1];i=i|128;led_byte[2,1]=i;}
        else       {i=led_byte[2,1];i=i&127;led_byte[2,1]=i;}
        if (p4==0) {i=led_byte[3,1];i=i|128;led_byte[3,1]=i;}
        else       {i=led_byte[3,1];i=i&127;led_byte[3,1]=i;}

        if (a==0)  led_byte[4,1]=led_byte[4,1]|1;
        else       led_byte[4,1]=led_byte[4,1]&0b11111110;
        if (b==0)  led_byte[4,1]=led_byte[4,1]|2;
        else       led_byte[4,1]=led_byte[4,1]&0b11111101;
        if (c==0)  led_byte[4,1]=led_byte[4,1]|4;
        else       led_byte[4,1]=led_byte[4,1]&0b11111011;
        if (d==0)  led_byte[4,1]=led_byte[4,1]|8;
        else       led_byte[4,1]=led_byte[4,1]&0b11110111;
        }
void set_digit_on(char a,char b,char c,char d)
        {//��������� ������ ��� �������, 1-�, 2-�, 3-�, 4-� �����
        char i;
        i=led_byte[0,0];i=i&128;i=i|led_calk(a);led_byte[0,0]=i;
        i=led_byte[1,0];i=i&128;i=i|led_calk(b);led_byte[1,0]=i;
        i=led_byte[2,0];i=i&128;i=i|led_calk(c);led_byte[2,0]=i;
        i=led_byte[3,0];i=i&128;i=i|led_calk(d);led_byte[3,0]=i;


//        led_byte[1,0]=led_calk(b);
//        led_byte[2,0]=led_calk(c);
//        led_byte[3,0]=led_calk(d);
        }
void set_digit_off(char a,char b,char c,char d)
        {//��������� ������ ��� �������, 1-�, 2-�, 3-�, 4-� �����
        char i;
        i=led_byte[0,1];i=i&128;i=i|led_calk(a);led_byte[0,1]=i;
        i=led_byte[1,1];i=i&128;i=i|led_calk(b);led_byte[1,1]=i;
        i=led_byte[2,1];i=i&128;i=i|led_calk(c);led_byte[2,1]=i;
        i=led_byte[3,1];i=i&128;i=i|led_calk(d);led_byte[3,1]=i;

//         led_byte[0,1]=led_calk(a);
//         led_byte[1,1]=led_calk(b);
//         led_byte[2,1]=led_calk(c);
//         led_byte[3,1]=led_calk(d);
        }
char ed,des,sot,tis;
int adc_buf;
void hex2dec(unsigned int x)		// ������������ �������������� ���� � ASCII
	{				//
	tis=0;sot=0;des=0;ed=0;
	while (x>=1000) {x=x-1000;tis++;}	//
	while (x>=100) {x=x-100;sot++;}	//
	while (x>=10){x=x-10;des++;}	//
	if (x<1) x=0;			//
	ed=x;		  		//

        if (tis==0)
                {
                tis=' ';
                if (sot==0)
                        {
                        sot=' ';
                        }
                }
        
	}				//
void main(void)
{
// Declare your local variables here
//eeprom *int ee_int;


long start_time;

// Reset Source checking
if (MCUCSR & 1){/* Power-on Reset*/MCUCSR&=0xE0;}
else if (MCUCSR & 2){/* External Reset*/MCUCSR&=0xE0;/* Place your code here*/}
else if (MCUCSR & 4){// Brown-Out Reset
   MCUCSR&=0xE0;/* Place your code here*/}
else if (MCUCSR & 8){// Watchdog Reset
   MCUCSR&=0xE0;/* Place your code here*/}
else if (MCUCSR & 0x10){// JTAG Reset
   MCUCSR&=0xE0;/* Place your code here*/};

PORTA=0xFF;DDRA=0xFF;
PORTB=0x00;DDRB=0xB0;
PORTC=0b11111000;DDRC=0b11111011;
PORTD=0b11110000;DDRD=0x00;

TCCR0=0x02;TCNT0=TCNT0_reload;OCR0=0x00;

TCCR1A=0x00;TCCR1B=0x05;TCNT1H=0x00;TCNT1L=0x01;
ICR1H=0x00;ICR1L=0x04;OCR1AH=0x00;OCR1AL=0x02;
OCR1BH=0x00;OCR1BL=0x03;

ASSR=0x00;TCCR2=0x03;TCNT2=TCNT2_reload;OCR2=0x00;

MCUCR=0x00;MCUCSR=0x00;

TIMSK=0xFF;

UCSRA=0x00;UCSRB=0xD8;UCSRC=0x86;UBRRH=0x00;UBRRL=0x33;
ACSR=0x80;SFIOR=0x00;
SPCR=0x52;SPSR=0x00;
WDTCR=0x1F;WDTCR=0x0F;



#asm("sei")
mode=0;
start_time=sys_time;
while (1)
        {
//        adc_buf=read_adc();
        if (mode==0)
                {
                hex2dec(adc_buf);
                
                
                
                
//                #asm("cli")
//                set_digit_on(tis,sot,des,ed);
//                set_digit_off(' ',' ',' ',' ');
//                set_led_on(0,0,0,1,0,1,0,0);
//                set_led_off(0,0,0,0,0,1,0,0);
//                #asm("sei")
                }
                

        
/*        set_digit_on(8,8,8,8);
        set_digit_off(8,8,8,8);
        set_led_on(0,0,0,0,0,1,1,1);
        set_led_off(0,0,0,0,0,0,0,0);
        delay_ms(3000);

        set_led_on(1,0,1,1,0,0,1,0);
        set_led_off(0,0,1,1,0,0,1,0);
        set_digit_on(5,6,7,8);
        set_digit_off(' ',' ',' ',' ');
        delay_ms(3000);
        
        set_led_on(1,1,0,1,0,1,0,0);
        set_led_off(0,1,0,1,0,1,0,0);
        set_digit_on(9,0,1,2);
        set_digit_off(' ',' ',' ',' ');
        delay_ms(3000);

        set_led_on(0,0,0,1,0,0,1,0);
        set_led_off(0,0,0,0,0,0,1,0);
        set_digit_on(3,4,5,6);
        set_digit_off(' ',' ',' ',' ');
        delay_ms(3000);
        

//        if (((sys_time-start_time)>300)&&(buzer_en==0)) {buzer_en=1;start_time=sys_time;}
//        if (((sys_time-start_time)>1700)&&(buzer_en==1)) {buzer_en=0;start_time=sys_time;}
  */
        if (((sys_time-start_time)>300)) 
                {
                set_digit_on(tis,sot,des,ed);
                set_digit_off(' ',' ',' ',' ');
                set_led_on(0,0,0,1,0,1,0,0);
                set_led_off(0,0,0,0,0,1,0,0);

                start_time=sys_time;
                adc_buf=adc_buf+1;
                if (adc_buf>9999)adc_buf=0;
                }
        };
}
