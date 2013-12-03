/*****************************************************
Project : Для ВИБРО-Т 
Version : V1.02.01
Date    : 09.01.2007
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
#include <math.h>

#define MAX_REGISTER    30
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

bit buzer_en,buzer,pik_en,buzer_buzer_en;
char pik_count;
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
        {//прерывание для бузера
        TCNT0=TCNT0_reload;
        #asm("wdr");
        if ((buzer_en==1)&&(buzer_buzer_en==1)){if (buzer==1) {buzerp=1;buzer=0;}else {buzerp=0;buzer=1;}}
        else if (pik_en==1){if (++pik_count>200) {pik_en=0;pik_count=0;}if (buzer==1) {buzerp=1;buzer=0;}else {buzerp=0;buzer=1;}}
        else buzerp=0;
        }
char led_byte[5,2];
interrupt [TIM0_COMP] void timer0_comp_isr(void){}
interrupt [TIM1_OVF] void timer1_ovf_isr(void){TCNT1H=0x00;TCNT1L=0x01;}
interrupt [TIM1_CAPT] void timer1_capt_isr(void){}
interrupt [TIM1_COMPA] void timer1_compa_isr(void){}
interrupt [TIM1_COMPB] void timer1_compb_isr(void){}
long sys_time,whait_time;
bit key_mode,key_plus,key_mines,key_enter,key_mode_press,key_plus_press,key_mines_press,key_enter_press,key_mode_press_switch;
bit key_plus_press_switch,key_minus_press_switch,key_enter_press_switch;
char count_led,drebezg;
bit avaria,alarm1,alarm2;
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
                
        if (key_4==0)
                {
                key_enter=1;
                if (key_enter_press==0)
                        {
                        key_enter_press_switch=1;
                        pik_en=1;
                        whait_time=sys_time;
                        }
                key_enter_press=1;
                }
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
//eeprom int *ee_int;
eeprom float *ee_float;
eeprom char point=2;
eeprom float reg[30]={0,10.00,15.00,8,8,0,1,
0,1,1,1,1,1,0.00,20.00,2,2,1,10,2,5,0,1,0,0,0,0,0,0};
char mode,mode_old;

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
                case 'c': a=0b01000110;break;

                case 't': a=0b01110010;break;
                case 'b': a=0b01111001;break;
                case 'd': a=0b01011110;break;
                case 'e': a=0b00101111;break;
                case 'f': a=0b00010111;break;
                case 'g': a=0b01001011;break;
                case 'h': a=0b01100101;break;
                default:  a=0b01110010;break;
                }
        return a;
        }
        
void set_led_avaria_on(char a)
        {//установка данных для светодиодов и точек
        }
void set_led_avaria_off(char a)
        {//установка данных для светодиодов и точек
        }
void set_led_alarm1_on(char a)
        {//установка данных для светодиодов и точек
        if (a==0)  led_byte[4,0]=led_byte[4,0]|4;
        else       led_byte[4,0]=led_byte[4,0]&0b11111011;
        }
void set_led_alarm1_off(char a)
        {//установка данных для светодиодов и точек
        if (a==0)  led_byte[4,1]=led_byte[4,1]|4;
        else       led_byte[4,1]=led_byte[4,1]&0b11111011;
        }
void set_led_alarm2_on(char a)
        {//установка данных для светодиодов и точек
        if (a==0)  led_byte[4,0]=led_byte[4,0]|8;
        else       led_byte[4,0]=led_byte[4,0]&0b11110111;
        }
void set_led_alarm2_off(char a)
        {//установка данных для светодиодов и точек
        if (a==0)  led_byte[4,1]=led_byte[4,1]|8;
        else       led_byte[4,1]=led_byte[4,1]&0b11110111;
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
        }
void set_digit_off(char a,char b,char c,char d)
        {//установка данных для дисплея, 1-я, 2-я, 3-я, 4-я цифры
        char i;
        i=led_byte[0,1];i=i&128;i=i|led_calk(a);led_byte[0,1]=i;
        i=led_byte[1,1];i=i&128;i=i|led_calk(b);led_byte[1,1]=i;
        i=led_byte[2,1];i=i&128;i=i|led_calk(c);led_byte[2,1]=i;
        i=led_byte[3,1];i=i&128;i=i|led_calk(d);led_byte[3,1]=i;
        }
char ed,des,sot,tis,count_filter,count_filter1,i,count_key,count_key1;
long filter_value;
unsigned int adc_buf,filter_min,filter_max,filter_buf[9],filter_buf1[100];
// void hex2dec(unsigned int x)		// подпрограмма преобразования кода в ASCII
// 	{				//
// 	tis=0;sot=0;des=0;ed=0;
// 	while (x>=1000) {x=x-1000;tis++;}	//
// 	while (x>=100) {x=x-100;sot++;}	//
// 	while (x>=10){x=x-10;des++;}	//
// 	if (x<1) x=0;			//
// 	ed=x;		  		//
// 
//         if (tis==0)
//                 {
//                 tis=' ';
//                 if (sot==0)
//                         {
//                         sot=' ';
//                         }
//                 }
//         
// 	}				//
void hex2dec(float x)		// подпрограмма преобразования кода в ASCII
	{				//
// 	char a;
// 	ftoa(x);
// 	ee_char=&point;
// 	a=*ee_char;
// 	if (a==1)
// 	        {
// 	        }
//         if (a==2)	        
//                 {
//                 }
//         if (a==3)	        
//                 {
//                 }
// 	
//	x=x*100;
	
	tis=0;sot=0;des=0;ed=0;
        if (x<0) x=-x;
//        if (x>

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

const flash float MAX_MIN[30,2]={{0,0},
/*  Y_1         Y_2         3_1         3_2         M_          C_    */
{-999,9999},{-999,9999},{   0,  30},{   0,  30},{   0,   1},{   0,   1},
/*  A_1         A_2         A_3         A_4         A_5         A_6         A_7         A_8   */
{   0,  10},{   0,   1},{   0,   1},{   0,   1},{   0,   1},{   0,   1},{-999,9999},{-999,9999},
/*  A_9         A_10        A_11        A_12        A_13        A_14        A_15        A_16        A_17  */
{   0,1000},{   0,1000},{   0, 100},{   0,  30},{   1,   5},{   1,  10},{   0,   1},{   0,   1},{   0,   1},
{   0,1000},{   0,1000},{   0, 100},{   0,  30},{   1,   5},{   0,   1}};
const flash float FAKTORY[30]={0,
10.00,15.00,8,8,0,1,
0,1,1,1,1,1,0.00,20.00,2,2,0,10,2,5,0,1,0,0,0,0,0,0};
unsigned int buf[9],buf_m[9];
char buf_begin,buf_end,buf_n[9];
signed char rang[9];
float xx,yy,x;
float data_register,k_f,adc_filter,adc_value2;
char j,k,count_register,count_key2;
long start_time,start_time_mode,time_key;

float read_reg(char a)
        {
        float k_f;
        ee_float=&(reg[a]);
        k_f=*ee_float;
        if ((k_f>MAX_MIN[a,1])||(k_f<MAX_MIN[a,0])) k_f=FAKTORY[a];//проверка граничных значений
        return k_f;
        }
void rekey()
        {
        if (count_key2>20){if (++count_key1>103) count_key1=102;} 
        else if (count_key1>100){if (++count_key1>106) {count_key1=102;count_key2++;}}
        else if (((sys_time-time_key)>50)&&(count_key>0))
                {time_key=sys_time;if (--count_key<20){count_key=40;if(++count_key1>4){count_key1=102;count_key=250;}}}
        }

void main(void)
{
// Declare your local variables here
bit alarm_alarm1,alarm_alarm2,flag_start_pause1,flag_start_pause2,f_m1,key_enter_press_switch1;
char min_r,min_n;
float time_pause1,time_pause2,adc_value1;


if      (MCUCSR & 0x01){/* Power-on Reset */MCUCSR&=0xE0;}
else if (MCUCSR & 0x02){/* External Reset */MCUCSR&=0xE0;}
else if (MCUCSR & 0x04){/* Brown-Out Reset*/MCUCSR&=0xE0;}
else if (MCUCSR & 0x08){/* Watchdog Reset */MCUCSR&=0xE0;}
else if (MCUCSR & 0x10){/* JTAG Reset     */MCUCSR&=0xE0;};

PORTA=0b11111111;DDRA=0b11111111;
PORTB=0b00000000;DDRB=0b10110011;
PORTC=0b11111000;DDRC=0b11111011;
PORTD=0b11110000;DDRD=0b00000000;

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


test:
for (i=1;i<30;i++)
        {
        ee_float=&(reg[i]);
        *ee_float=FAKTORY[i];//проверка граничных значений
        }

//k_f=read_reg(19)*2000;
goto a1;

//Ожидание включения питания 8 сек
ee_float=&(reg[18]);
k_f=*ee_float;
if ((k_f>MAX_MIN[18,1])||(k_f<MAX_MIN[18,0])) k_f=FAKTORY[18];//проверка граничных значений
k_f=*ee_float;
k=k_f;i=0;
while (i<k)
        {
        if ((key_1==0)&&(key_4==0)&&(key_2==1)&&(key_3==1)) i++;
        else i=0;
        delay_ms(1000);
        }
a1:
#asm("sei")
//Показать основные настройки
for (i=7;i<9;i++)
        {
        hex2dec(i-6);
        set_digit_on('a','_',des,ed);
        set_digit_off('a','_',des,ed);
        set_led_on(0,0,0,1,0,0,0,0);
        set_led_off(0,0,0,1,0,0,0,0);
        delay_ms(700);
        ee_float=&(reg[i]);
        k_f=*ee_float;
        if ((k_f>MAX_MIN[i,1])||(k_f<MAX_MIN[i,0])) *ee_float=FAKTORY[i];//проверка граничных значений
        k_f=*ee_float;
        if (i==14) k_f=k_f*100;
        hex2dec(k_f);
        set_digit_on(tis,sot,des,ed);
        set_digit_off(tis,sot,des,ed);
        set_led_on(0,0,0,1,0,1,0,0);
        set_led_off(0,0,0,1,0,1,0,0);
        delay_ms(700);
        }
key_mode_press=0;
key_plus_press=0;
key_mines_press=0;
key_enter_press=0;
key_mode_press_switch=0;
key_plus_press_switch=0;
key_minus_press_switch=0;

#asm("sei")
mode=0;
x=0;
start_time=sys_time;
while (1)
        {
        if (read_reg(6)==0)buzer_buzer_en=0;
        else buzer_buzer_en=1;
        #asm("wdr");
        //измерение
        if (++buf_end>8) buf_end=0;buf[buf_end]=read_adc();min_r=9;
        //модальный фильтр
        for (j=0;j<9;j++)
                {
                rang[j]=0;
                for (i=0;i<9;i++)
                        {
                        if (i!=j)
                                {
                                if (buf[j]<buf[i]) rang[j]--;
                                if (buf[j]>buf[i]) rang[j]++;
                                }
                        }
                if (cabs(rang[j])<min_r) {min_r=cabs(rang[j]);min_n=j;}
                }
        //ФНЧ
        ee_float=&(reg[17]);
        k_f=*ee_float;
        if (k_f==0)
                {adc_filter=buf[min_n];}
        else
                {
                k_f=0.002/k_f;
                adc_filter=k_f*buf[min_n]+(1-k_f)*adc_filter;
                }
        
        //первичное преобразование
        ee_float=&(reg[20]);
        adc_value1=adc_filter+*ee_float;
        ee_float=&(reg[21]);
        adc_value1=adc_value1*0.01;//(*ee_float);

        //вторичное преобразование//???????????????????????????????
//         ee_float=12*4;k_f=*ee_float;
//         adc_value=adc_filter+*ee_float;
//         ee_float=21;
//         adc_filter=adc_filter*(*ee_float);
        adc_value2=adc_value1;
        
        //авария
        ee_float=&(reg[14]);k_f=*ee_float;
        ee_float=&(reg[12]);
        if (adc_value2<(*ee_float*(1-k_f/100))) {avaria=1;set_led_alarm1_on(1);}
        ee_float=&(reg[15]);k_f=*ee_float;
        ee_float=&(reg[13]);
        if (adc_value2>(*ee_float*(1+k_f/100))) {avaria=1;set_led_alarm2_on(1);}

        //уставка 1,2
        ee_float=&(reg[5]);k_f=*ee_float;
        ee_float=&(reg[0]);
        if (adc_value2>(*ee_float*(1+k_f/100))) alarm1=1;
        else {alarm1=0;alarm_alarm1=0;}
        ee_float=&(reg[1]);
        if (adc_value2>(*ee_float*(1+k_f/100))) alarm2=1;
        else alarm2=0;





        //пауза 1,2
        if (alarm_alarm1==1){relay_alarm1=1;}
        else relay_alarm1=0;
        if (alarm_alarm2==1){relay_alarm2=1;}
        else relay_alarm2=0;

        
        if ((flag_start_pause1==1)&&(alarm_alarm1==0))
                {
                ee_float=&reg[2];
                if ((sys_time-time_pause1)>*ee_float){alarm_alarm1=1;}
                }
        else if (alarm1==1)
                {
                time_pause1=sys_time;
                flag_start_pause1=1;
                }

        if ((flag_start_pause2==1)&&(alarm_alarm2==0))
                {
                ee_float=&reg[3];
                if ((sys_time-time_pause2)>*ee_float)alarm_alarm2=1;
                }
        else if (alarm2==1)
                {
                time_pause2=sys_time;
                flag_start_pause2=1;
                }












        //возврат из меню
        if (((sys_time-start_time_mode)>read_reg(20)*2000)){mode=0;f_m1=0;}

        if ((key_enter_press_switch==1)&&(mode==0)){key_enter_press_switch=0;key_enter_press_switch1=1;}
        if ((key_enter_press_switch1==1)&&(key_enter==1))
                {
                if ((sys_time-whait_time)>3000)
                        {
                        mode=10;start_time_mode=sys_time;key_enter_press_switch1=0;
                        }
                }

        //МЕНЮ
        if (mode==0)
                {
                hex2dec(adc_value2*100);
                }
                
        if (mode==1)//уставка №1
                {
                set_led_on(0,0,1,1,0,0,0,0);//светодиод предупр.,норма 
                set_led_off(0,0,0,1,0,0,0,0);//светодиод норма

                if ((((sys_time-start_time_mode)<read_reg(19)*2000))&&(f_m1==0))//пока время индикации наименования
                        {
                        tis='У';sot='_';des=1;ed=' ';
                        set_digit_off(' ',' ',' ',' ');
                        }
                else
                        {
                        set_led_on(0,0,1,1,0,1,0,0);//светодиод предупр.,норма, запятая 2
                        count_register=1;
                        hex2dec(data_register*100);
                        f_m1=1;
                        }
                }
        if (mode==2)//уставка №2
                {
                set_led_on(0,1,0,1,0,0,0,0);//светодиод аварийн.,норма
                set_led_off(0,0,0,1,0,0,0,0);//светодиод норма

                if ((((sys_time-start_time_mode)<read_reg(19)*2000))&&(f_m1==0))//пока время индикации наименования
                        {
                        tis='У';sot='_';des=2;ed=' ';
                        set_digit_off(' ',' ',' ',' ');
                        }
                else
                        {
                        set_led_on(0,1,0,1,0,1,0,0);//светодиод аварийн.,норма, запятая 2
                        count_register=2;
                        hex2dec(data_register*100);
                        f_m1=1;
                        }
                }
        if (mode==3)//время до уставки 1
                {
                set_led_on(0,0,1,1,0,0,0,0);//светодиод предупр.,норма, запятая 2
                set_led_off(0,0,0,1,0,0,0,0);//светодиод норма
                if ((((sys_time-start_time_mode)<read_reg(19)*2000))&&(f_m1==0))//пока время индикации наименования
                        {
                        tis=3;sot='_';des=1;ed=' ';
                        set_digit_off(' ',' ',' ',' ');
                        }
                else
                        {
                        count_register=3;
                        hex2dec(data_register);
                        f_m1=1;
                        }
                }
        if (mode==4)//время до уставки 2
                {
                set_led_on(0,1,0,1,0,0,0,0);//светодиод аварийн.,норма, запятая 2
                set_led_off(0,0,0,1,0,0,0,0);//светодиод норма
                if ((((sys_time-start_time_mode)<read_reg(19)*2000))&&(f_m1==0))//пока время индикации наименования
                        {
                        tis=3;sot='_';des=2;ed=' ';
                        set_digit_off(' ',' ',' ',' ');
                        }
                else
                        {
                        count_register=4;
                        hex2dec(data_register);
                        f_m1=1;
                        }
                }
        if (mode==5)//режим маскирование
                {
                set_led_on(0,1,1,1,0,0,0,0);//светодиод аварийн.,предупр.,норма
                set_led_off(0,0,0,1,0,0,0,0);//светодиод норма
                if ((((sys_time-start_time_mode)<read_reg(19)*2000))&&(f_m1==0))//пока время индикации наименования
                        {
                        tis=6;sot='_';des='_';ed=' ';
                        set_digit_off(' ',' ',' ',' ');
                        }
                else
                        {
                        count_register=5;
                        hex2dec(data_register);
                        f_m1=1;
                        }
                }

        if (mode==6)//режим маскирование
                {
                set_led_on(0,1,1,1,0,0,0,0);//светодиод аварийн.,предупр.,норма
                set_led_off(0,0,0,1,0,0,0,0);//светодиод норма
                if ((((sys_time-start_time_mode)<read_reg(19)*2000))&&(f_m1==0))//пока время индикации наименования
                        {
                        tis='c';sot='_';des='_';ed=' ';
                        set_digit_off(' ',' ',' ',' ');
                        }
                else
                        {
                        count_register=6;
                        hex2dec(data_register);
                        f_m1=1;
                        }
                }
//----------------------------------------------------------
        if (mode==10)
                {
                if (count_register<7) count_register=7;
                hex2dec(count_register-6);
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
                        if ((mode==11)||(mode==3)||(mode==4)||(mode==5)||(mode==6))
                                {
                                data_register=data_register+1;
                                if (data_register>MAX_MIN[count_register,1])data_register=MAX_MIN[count_register,1];
                                }
                        if ((mode==1)||(mode==2))
                                {
                                data_register=data_register+0.01;
                                if (data_register>MAX_MIN[count_register,1])data_register=MAX_MIN[count_register,1];
                                }
                        if (count_key==0)count_key=60;if (count_key==21)count_key=20;
                        }
                rekey();
                }
        else if ((mode!=100)&&(key_enter_press==0)&&(key_mines_press==0)){count_key=0;count_key1=0;count_key2=0;}

        if (key_mines_press==1)
                {
                start_time_mode=sys_time;
                if (count_key==0){if (mode==10)if (--count_register<7)count_register=7;}
                if ((count_key==0)||(count_key==21)||(count_key1==102))
                        {
                        if ((mode==11)||(mode==3)||(mode==4)||(mode==5)||(mode==6))
                             {
                             data_register=data_register-1;
                             if (data_register<MAX_MIN[count_register,0])data_register=MAX_MIN[count_register,0];
                             }
                        if ((mode==1)||(mode==2))
                                {
                                data_register=data_register-0.01;
                                if (data_register<MAX_MIN[count_register,0])data_register=MAX_MIN[count_register,0];
                                }
                        if (count_key==0)count_key=60;if (count_key==21)count_key=20;
                        }
                rekey();
                }
        else if ((mode!=100)&&(key_enter_press==0)&&(key_plus_press==0)){count_key=0;count_key1=0;count_key2=0;}

        if ((key_enter_press_switch==1)&&(key_plus_press==0)&&(key_mines_press==0)&&(key_mode_press==0)&&(mode!=0)&&(mode!=10))
                {
//                mode_old=mode;mode=100;
                ee_float=&reg[count_register];
                *ee_float=data_register;
                start_time_mode=sys_time;
                if (count_register==30)
                        {
                        for (i=0;i<30;i++)
                                {
                                ee_float=&reg[i];
                                *ee_float=FAKTORY[i];
                                }
                        }
                set_digit_on(' ',3,'a','п');
                set_digit_off(' ',3,'a','п');
                set_led_on(0,0,0,0,0,0,0,0);
                set_led_off(0,0,0,0,0,0,0,0);
                delay_ms(3000);key_enter_press_switch=0;
                set_digit_off(' ',' ',' ',' ');
                start_time_mode=sys_time;start_time=sys_time;
                f_m1=0;
                }
//         else if (mode==100)
//                 {
//                 if (((sys_time-start_time_mode)>read_reg(19)*2000))
//                         {
//                         start_time_mode=sys_time;start_time=sys_time;mode=mode_old;key_enter_press=0;
//                         }
//                 }

        //----------------------------------------------------------
        // переключение режимов
        //----------------------------------------------------------
        if ((key_mode_press_switch==1)&&(key_2==1)&&(key_3==1)&&(key_4==1))
                {
                key_mode_press_switch=0;f_m1=0;
                start_time_mode=sys_time;
                switch (mode)
                        {
                        case 0: mode=1;data_register=read_reg(count_register);break;
                        case 1: mode=2;data_register=read_reg(count_register);break;
                        case 2: mode=1;data_register=read_reg(count_register);break;

                        case 10:mode=11;if (count_register<7) count_register=7;data_register=read_reg(count_register);break;
                        case 11:mode=10;break;
                        }
                }
        //----------------------------------------------------------

        if (((sys_time-start_time)>250)) 
                {
                set_digit_on(tis,sot,des,ed);
//                 if (mode==100)
//                         {
//                         set_digit_on(' ',3,'a','п');
//                         set_digit_off(' ',3,'a','п');
//                         set_led_on(0,0,0,0,0,0,0,0);
//                         set_led_off(0,0,0,0,0,0,0,0);
//                         }
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
