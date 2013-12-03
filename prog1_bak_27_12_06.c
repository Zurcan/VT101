/*****************************************************
Project : Для ВИБРО-Т 
Version : V1.02.01
Date    : 23.12.2006
Author  : Метелкин Евгений          
Company : ООО ЭЛЬТЭРА           
Comments: V1.24.5 Standard

Chip type           : ATmega16
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
Data Stack size     : 256
*****************************************************/
#include <mega16.h>
#include <delay.h>
#include <stdlib.h>

#define MAX_REGISTER    23
#define DREBEZG_TIME    200//по 0,5мсек
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
unsigned char rx_wr_index,rx_rd_index,rx_counter;
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

unsigned char tx_wr_index,tx_rd_index,tx_counter;

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

bit buzer_en,buzer,pik_en;
char pik_count;
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
        {//прерывание для бузера
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
bit key_mode,key_plus,key_mines,key_enter,key_mode_press,key_plus_press,key_mines_press,key_enter_press,key_mode_press_switch;
bit key_plus_press_switch,key_minus_press_switch;
char count_led,drebezg;
int count_blink;
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
        {//прерывание 500мкс
        char n;
        TCNT2=TCNT2_reload;
        #asm("wdr");
        sys_time=sys_time+1;

        if (key_1==0)
                {
                key_mode=1;
                if ((key_mode_press==0)&&(pik_en==0)){key_mode_press_switch=1;pik_en=1;drebezg=0;}
                key_mode_press=1;
                }
        else if ((key_2==1)&&(key_3==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME))
                {key_mode=0;key_mode_press=0;}

        if (key_2==0)
                {
                key_plus=1;
                if ((key_plus_press==0)&&(pik_en==0)){key_plus_press_switch=1;pik_en=1;drebezg=0;}
                key_plus_press=1;
                }
        else if ((key_1==1)&&(key_3==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME))
                {key_plus=0;key_plus_press=0;}
                
        if (key_3==0)
                {
                key_mines=1;
                if ((key_mines_press==0)&&(pik_en==0)){key_minus_press_switch=1;pik_en=1;drebezg=0;}
                key_mines_press=1;
                }
        else if ((key_2==1)&&(key_1==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME))
                {key_mines=0;key_mines_press=0;}
                
        if (key_4==0) {key_enter=1;if (key_enter_press==0)pik_en=1;key_enter_press=1;}
        else {key_enter=0;key_enter_press=0;}
        
        
        
        if (++count_blink>2000) count_blink=0;
//        if (count_blink<1700) n=0;
        if (count_blink<300) n=1;
        else n=0;
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

//eeprom int *ee_int[20]={1,1,1,1,1,1,-999,9999,10,50,6,3,5,1,1,1111};
eeprom int *ee_int;
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
                case '_': a=0b01110111;break;
                case 'У': a=0b00010001;break;
                case 'a': a=0b00001000;break;
                case 'п': a=0b01001000;break;

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
        {//установка данных для светодиодов и точек
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
        {//установка данных для светодиодов и точек
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
        {//установка данных для дисплея, 1-я, 2-я, 3-я, 4-я цифры
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
        {//установка данных для дисплея, 1-я, 2-я, 3-я, 4-я цифры
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
char ed,des,sot,tis,count_filter,count_filter1,i,count_key,count_key1;
long filter_value;
unsigned int adc_buf,filter_min,filter_max,filter_buf[9],filter_buf1[100];
void hex2dec(unsigned int x)		// подпрограмма преобразования кода в ASCII
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
int read_adc()
        {
        int a;
        a=rand();
        a=a/200;
        a=a+2048;
        return a;
        }

const flash signed int MAX_MIN[24,2]={{0,0},
/*  Y_1         Y_2         3_1         3_2         M_          C_    */
{-999,9999},{-999,9999},{   0,  30},{   0,  30},{   0,   1},{   0,   1},
/*  A_1         A_2         A_3         A_4         A_5         A_6         A_7         A_8   */
{   0,  10},{   0,   1},{   0,   1},{   0,   1},{   0,   1},{   0,   1},{-999,9999},{-999,9999},
/*  A_9         A_10        A_11        A_12        A_13        A_14        A_15        A_16        A_17  */
{   0,1000},{   0,1000},{   0, 100},{   0,  30},{   1,   5},{   1,  10},{   0,   1},{   0,   1},{   0,   1}};
const flash signed int FAKTORY[24]=
{1000,1000,0,0,1,1,0,1,1,1,1,1,0,2000,2,2,0,10,2,5,0,1,0};
unsigned int buf[9];
unsigned int buf_m[9];
char buf_begin,buf_end;
char buf_n[9];
signed char rang[9];
float xx,yy,x;


signed int data_register;

char j,k,count_register;
long start_time,start_time_mode,time_key;

void rekey()
        {
        if (count_key1>100){if (++count_key1>110) count_key1=102;}
        else if (((sys_time-time_key)>50)&&(count_key>0))
                {time_key=sys_time;if (--count_key<20){count_key=40;if(++count_key1>4){count_key1=102;count_key=250;}}}
        }

void main(void)
{
// Declare your local variables here
//eeprom *int ee_int;
float time_filter;
// Reset Source checking
if (MCUCSR & 1)
{/* Power-on Reset*/MCUCSR&=0xE0;}
else if (MCUCSR & 2)
{/* External Reset*/MCUCSR&=0xE0;/* Place your code here*/}
else if (MCUCSR & 4)
{// Brown-Out Reset
   MCUCSR&=0xE0;/* Place your code here*/}
else if (MCUCSR & 8){// Watchdog Reset
   MCUCSR&=0xE0;/* Place your code here*/}
else if (MCUCSR & 0x10){// JTAG Reset
   MCUCSR&=0xE0;/* Place your code here*/};

PORTA=0xFF;DDRA=0xFF;
PORTB=0x00;DDRB=0xB3;
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

count_register=1;
data_register=1234;
time_filter=2;
#asm("sei")
mode=0;
x=0;
start_time=sys_time;
while (1)
        {
        #asm("wdr");
        for (i=0;i<9;i++)rang[i]=0;
        if (++buf_end>8) buf_end=0;
        buf[buf_end]=read_adc();
        for (j=0;j<9;j++)
                {
                for (i=0;i<9;i++)
                        {
                        if (buf[j]<buf[i]) rang[j]--;
                        if (buf[j]>buf[i]) rang[j]++;
                        }
                }
        for(i=0;i<9;i++){if (rang[i]<0)rang[i]=0-rang[i];}
        j=0;for(i=0;i<9;i++){if (rang[j]>rang[i])j=i;}

        xx=(6-time_filter)*0.002;xx=xx*buf[j];
        yy=1-((6-time_filter)*0.002);yy=yy*x;x=xx+yy;
        adc_buf=x+0.5;
        
        if (mode==0)
                {
                hex2dec(adc_buf);
                }
                
        if (((sys_time-start_time_mode)>15000)) mode=0;
        if (mode==1)//уставка №1
                {
                set_led_on(0,0,1,1,0,0,0,0);
                set_led_off(0,0,0,1,0,0,0,0);
                if (((sys_time-start_time_mode)<5000))
                        {
                        tis='У';sot='_';des=1;ed=' ';
                        set_digit_off(' ',' ',' ',' ');
                        }
                else
                        {
                        tis=' ';sot=5;des=4;ed=3;
                        set_digit_off(' ',' ',' ',' ');
                        }
                }
        if (mode==2)//уставка №2
                {
                set_led_on(0,1,0,1,0,0,0,0);
                set_led_off(0,0,0,1,0,0,0,0);
                if (((sys_time-start_time_mode)<5000))
                        {
                        tis='У';sot='_';des=2;ed=' ';
                        set_digit_off(' ',' ',' ',' ');
                        }
                else
                        {
                        tis=' ';sot=7;des=6;ed=5;
                        set_digit_off(' ',' ',' ',' ');
                        }
                }
        if (mode==3)//время до уставки 1
                {
                if (((sys_time-start_time_mode)<5000))
                        {
                        set_led_on(0,0,1,1,0,0,0,0);
                        set_led_off(0,0,0,1,0,0,0,0);
                        tis=3;sot='_';des=1;ed=' ';
                        set_digit_off(' ',' ',' ',' ');
                        }
                else
                        {
                        tis=' ';sot=7;des=6;ed=5;
                        set_digit_off(' ',' ',' ',' ');
                        }
                }
        if (mode==4)//время до уставки 2
                {
                if (((sys_time-start_time_mode)<5000))
                        {
                        set_led_on(0,1,0,1,0,0,0,0);
                        set_led_off(0,0,0,1,0,0,0,0);
                        tis=3;sot='_';des=2;ed=' ';
                        set_digit_off(' ',' ',' ',' ');
                        }
                else
                        {
                        tis=' ';sot=7;des=6;ed=5;
                        set_digit_off(' ',' ',' ',' ');
                        }
                }
        if (mode==5)
                {
                tis=' ';sot=5;des=5;ed=' ';
                set_digit_off(' ',' ',' ',' ');
                set_led_on(0,0,1,1,0,1,0,0);
                set_led_off(0,0,0,1,0,1,0,0);
                }

        if (mode==10)
                {
                hex2dec(count_register);
                if (des==0) des='_';
                tis='a';sot='_';//des=count_register;ed=' ';
                set_digit_off(' ',' ',' ',' ');
                set_led_on(0,0,1,1,0,0,0,0);
                set_led_off(0,0,0,1,0,0,0,0);
                }

        if (mode==11)
                {
                hex2dec(data_register);
//                tis=' ';sot=1;des=2;ed=3;
                set_led_on(0,0,1,1,0,1,0,0);
                set_led_off(0,0,0,1,0,1,0,0);
                }
        
        
        if (key_plus_press==1)
                {
                start_time_mode=sys_time;
                if (count_key==0){if (mode==10)if (++count_register>MAX_REGISTER)count_register=MAX_REGISTER;}
                if ((count_key==0)||(count_key==21)||(count_key1==102))
                        {
                        if (mode==11){if (++data_register>MAX_MIN[count_register,1])data_register=MAX_MIN[count_register,1];}
                        if (count_key==0)count_key=60;if (count_key==21)count_key=20;
                        }
                rekey();
                }
        else if ((mode!=100)&&(key_enter_press==0)&&(key_mines_press==0)){count_key=0;count_key1=0;}

        if (key_mines_press==1)
                {
                start_time_mode=sys_time;
                if (count_key==0){if (mode==10)if (--count_register>MAX_REGISTER)count_register=MAX_REGISTER;}
                if ((count_key==0)||(count_key==21)||(count_key1==102))
                        {
                        if (mode==11){if (--data_register<MAX_MIN[count_register,0])data_register=MAX_MIN[count_register,0];}
                        if (count_key==0)count_key=60;if (count_key==21)count_key=20;
                        }
                rekey();
                }
        else if ((mode!=100)&&(key_enter_press==0)&&(key_plus_press==0)){count_key=0;count_key1=0;}

        if ((key_enter_press==1)&&(key_plus_press==0)&&(key_mines_press==0)&&(key_mode_press==0))
                {
                mode=100;
                ee_int=count_register*2;
                *ee_int=data_register;
                start_time_mode=sys_time;
                }
        else if (mode==100)
                {
                if ((sys_time-start_time_mode)>3250)
                        {
                        start_time_mode=sys_time;start_time=sys_time;mode=10;
                        }
                }

        if (key_mode_press_switch==1)
                {
                key_mode_press_switch=0;
                start_time_mode=sys_time;
                switch (mode)
                        {
                        case 0: mode=1;break;
                        case 1: mode=2;break;
                        case 2: mode=3;break;
                        case 3: mode=4;break;
                        case 4: mode=5;break;
                        case 5: mode=10;break;
                        case 10:mode=11;break;
                        case 11:mode=10;break;
                        case 100:mode=100;break;
                        }
                }

        if (((sys_time-start_time)>250)) 
                {
                set_digit_on(tis,sot,des,ed);
                if (mode==100)
                        {
                        set_digit_on(' ',3,'a','п');
                        set_digit_off(' ',3,'a','п');
                        set_led_on(0,0,0,0,0,0,0,0);
                        set_led_off(0,0,0,0,0,0,0,0);
                        }
                if (mode==11)
                        {
                        if((key_plus_press==1)||(key_mines_press==1)) set_digit_off(tis,sot,des,ed);
                        else set_digit_off(' ',' ',' ',' ');
                        }
                if (mode==0)
                        {
                        set_digit_off(tis,sot,des,ed);
                        set_led_on(0,0,0,1,0,1,0,0);
                        set_led_off(0,0,0,1,0,1,0,0);
                        }
                start_time=sys_time;
                }
        };
}
