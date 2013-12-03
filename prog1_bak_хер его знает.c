/*****************************************************
Project : Для ВИБРО-Т 
Version : V1.02.03
Date    : 21.01.2007
Author  : Метелкин Евгений          
Company : ООО ЭЛЬТЭРА           
Comments: V1.24.5 Standard

Chip type           : ATmega16
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
Data Stack size     : 256
*****************************************************/
#include <def.h>

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
bit avaria,alarm1,alarm2,alarm_alarm1,alarm_alarm2;
int count_blink;
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
        {//прерывание 500мкс
        char n;
        TCNT2=TCNT2_reload;
        #asm("sei");
//        #asm("wdr");
        sys_time=sys_time+1;

        if (key_1==0){key_mode=1;if ((key_mode_press==0)&&(pik_en==0)){key_mode_press_switch=1;pik_en=1;drebezg=0;}key_mode_press=1;}
        else if ((key_2==1)&&(key_3==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME)){key_mode=0;key_mode_press=0;}

        if (key_2==0){key_plus=1;if ((key_plus_press==0)&&(pik_en==0)){key_plus_press_switch=1;pik_en=1;drebezg=0;}key_plus_press=1;}
        else if ((key_1==1)&&(key_3==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME)){key_plus=0;key_plus_press=0;}
           
        if (key_3==0){key_mines=1;if ((key_mines_press==0)&&(pik_en==0)){key_minus_press_switch=1;pik_en=1;drebezg=0;}key_mines_press=1;}
        else if ((key_2==1)&&(key_1==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME)){key_mines=0;key_mines_press=0;}
                
        if (key_4==0){key_enter=1;if (key_enter_press==0){key_enter_press_switch=1;pik_en=1;whait_time=sys_time;}key_enter_press=1;}
        else {key_enter=0;key_enter_press=0;}
        
        if (++count_blink>2000) count_blink=0;
        if (count_blink<300) {n=1;buzer_en=0;}//if ((alarm_alarm1==1)||(alarm_alarm2==1))buzer_en=1;else buzer_en=0;}
        else {n=0;if ((alarm1==1)||(alarm2==1))buzer_en=1;}
        PORTA=0xFF;
        anode1=0;anode2=0;anode3=0;anode4=0;DDRC.3=0;DDRC.4=0;DDRC.5=0;DDRC.6=0;DDRC.7=0;
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
//        #asm("");
        }
interrupt [TIM2_COMP] void timer2_comp_isr(void){}
#include <spi.h>

eeprom float *ee_float;
eeprom char point=2;
eeprom float reg[30]={0,
10.00,15.00,8,8,0,1,
0,1,1,1,1,1,0.00,20.00,2,2,1,10,2,5,0,1,0,0,0,0,0,0};
char mode;

#include <function_led.h>

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
// void hex2dec(float x)		// подпрограмма преобразования кода в ASCII
// 	{				//
// // 	char a;
// // 	ftoa(x);
// // 	ee_char=&point;
// // 	a=*ee_char;
// // 	if (a==1)
// // 	        {
// // 	        }
// //         if (a==2)	        
// //                 {
// //                 }
// //         if (a==3)	        
// //                 {
// //                 }
// // 	
// //	x=x*100;
// 	
// 	tis=0;sot=0;des=0;ed=0;
//         if (x<0) x=-x;
// //        if (x>
// 
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


//-------------------------------------------------------------------//
// чтение из АЦП
//-------------------------------------------------------------------//
int read_adc()
        {
        int a;
        cs=0;SPCR=0b01010001;SPDR=0b10000001;
        while(SPSR.7==0);a=SPDR;SPDR=0;a=a<<8;
        while (SPSR.7 == 0);a = a + SPDR;cs=1;
        return a;
        }
//-------------------------------------------------------------------//


unsigned int buf[9],buf_m[9];
char buf_begin,buf_end,buf_n[9];
signed char rang[9];
float x;
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
bit flag_start_pause1,flag_start_pause2,f_m1,key_enter_press_switch1;
char min_r,min_n;
float time_pause1,time_pause2,adc_value1;
float data_register,k_f,adc_filter,adc_value2;


if      (MCUCSR & 0x01){/* Power-on Reset */MCUCSR&=0xE0;}
else if (MCUCSR & 0x02){/* External Reset */MCUCSR&=0xE0;}
else if (MCUCSR & 0x04){/* Brown-Out Reset*/MCUCSR&=0xE0;}
else if (MCUCSR & 0x08){/* Watchdog Reset */MCUCSR&=0xE0;}
else if (MCUCSR & 0x10){/* JTAG Reset     */MCUCSR&=0xE0;};

PORTA=0b11111111;DDRA=0b11111111;
PORTB=0b00000000;DDRB=0b10110011;
PORTC=0b11111000;DDRC=0b11111011;
PORTD=0b11110000;DDRD=0b00001000;

TCCR0=0x02;TCNT0=TCNT0_reload;OCR0=0x00;

TCCR1A=0x00;TCCR1B=0x05;TCNT1H=0x00;TCNT1L=0x01;
ICR1H=0x00;ICR1L=0x04;OCR1AH=0x00;OCR1AL=0x02;
OCR1BH=0x00;OCR1BL=0x03;

ASSR=0x00;TCCR2=0x03;TCNT2=TCNT2_reload;OCR2=0x00;

MCUCR=0x00;MCUCSR=0x00;TIMSK=0xFF;

UCSRA=0x00;UCSRB=0xD8;UCSRC=0x86;UBRRH=0x00;UBRRL=0x33;
ACSR=0x80;SFIOR=0x00;SPCR=0x52;SPSR=0x00;WDTCR=0x1F;WDTCR=0x0F;

test:
for (i=1;i<30;i++)
        {
        ee_float=&(reg[i]);
        *ee_float=FAKTORY[i];//проверка граничных значений
        }

goto a1;

//Ожидание включения питания 
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
power=1;
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
//=================================================================//
while (1)
        {
        if (read_reg(6)==0)buzer_buzer_en=0;
        else buzer_buzer_en=1;
        #asm("wdr");
        //-------------------------------------------------------------------//
        //измерение
        //-------------------------------------------------------------------//
        if (++buf_end>8) buf_end=0;buf[buf_end]=read_adc();min_r=9;
        //-------------------------------------------------------------------//
        //-------------------------------------------------------------------//
        //модальный фильтр
        //-------------------------------------------------------------------//
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
        //-------------------------------------------------------------------//

        //-------------------------------------------------------------------//
        //ФНЧ
        //-------------------------------------------------------------------//
        k_f=read_reg(A_10);//постоянная времени фильтра
        if (k_f==0){adc_filter=buf[min_n];}
        else {k_f=0.002/k_f;adc_filter=k_f*buf[min_n]+(1-k_f)*adc_filter;}
        //-------------------------------------------------------------------//
        
        //-------------------------------------------------------------------//
        //первичное преобразование
        //-------------------------------------------------------------------//
        ee_float=&reg[20];
        adc_value1=adc_filter+*ee_float;
        ee_float=&reg[21];
        adc_value1=adc_value1*0.01;//(*ee_float);
        //-------------------------------------------------------------------//

        //вторичное преобразование//???????????????????????????????
//         ee_float=12*4;k_f=*ee_float;
//         adc_value=adc_filter+*ee_float;
//         ee_float=21;
//         adc_filter=adc_filter*(*ee_float);
        adc_value2=adc_value1;
        

        //-------------------------------------------------------------------//
        //авария ставит флаг аварии
        //-------------------------------------------------------------------//
        if (adc_value2<(read_reg(A_06)*(1-read_reg(A_08)/100))) {avaria=1;}
        if (adc_value2>(read_reg(A_07)*(1+read_reg(A_09)/100))) {avaria=1;}
        //-------------------------------------------------------------------//

        //-------------------------------------------------------------------//
        //уставка 1,2  ставит флаги тревог 
        //-------------------------------------------------------------------//
        if (adc_value2>(read_reg(Y_01)*(1+read_reg(A_01)/100))) {alarm1=1;}
        else {alarm1=0;alarm_alarm1=0;flag_start_pause1=0;}
        if (adc_value2>(read_reg(Y_02)*(1+read_reg(A_01)/100))) {alarm2=1;}
        else {alarm2=0;flag_start_pause2=0;}
        //-------------------------------------------------------------------//





        //-------------------------------------------------------------------//
        //пауза 1,2
        //-------------------------------------------------------------------//
        if (alarm_alarm1==1){relay_alarm1=1;}
        else relay_alarm1=0;
        if (alarm_alarm2==1){relay_alarm2=1;}
        else relay_alarm2=0;
        
        if ((flag_start_pause1==1))//&&(alarm_alarm1==0))
                {
                if ((sys_time-time_pause1)>(read_reg(3)*2000)){alarm_alarm1=1;}
                }
        else if (alarm1==1)
                {
                time_pause1=sys_time;
                flag_start_pause1=1;
                }
        if ((flag_start_pause2==1))//&&(alarm_alarm2==0))
                {
                if ((sys_time-time_pause2)>(read_reg(4)*2000))alarm_alarm2=1;
                }
        else if (alarm2==1)
                {
                time_pause2=sys_time;
                flag_start_pause2=1;
                }
        //-------------------------------------------------------------------//



        //-------------------------------------------------------------------//
        //возврат из меню
        //-------------------------------------------------------------------//
        if (((sys_time-start_time_mode)>read_reg(A_12)*2000)){mode=0;f_m1=0;}
        //-------------------------------------------------------------------//


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
                
//----------------------------------------------------------
        if (mode==1)
                {
                hex2dec(count_register);
                ed=' ';
                switch (count_register)
                        {
                        case 1:tis='у';des='_';sot= 1 ;set_led_on(0,0,1,1,0,0,0,0);set_led_off(0,0,0,1,0,0,0,0);break;
                        case 2:tis='у';des='_';sot= 2 ;set_led_on(0,1,0,1,0,0,0,0);set_led_off(0,0,0,1,0,0,0,0);break;
                        case 3:tis= 3 ;des='_';sot= 1 ;set_led_on(0,0,1,1,0,0,0,0);set_led_off(0,0,0,1,0,0,0,0);break;
                        case 4:tis= 3 ;des='_';sot= 2 ;set_led_on(0,1,0,1,0,0,0,0);set_led_off(0,0,0,1,0,0,0,0);break;
                        case 5:tis='p';des='_';sot='_';set_led_on(0,1,1,1,0,0,0,0);set_led_off(0,0,0,1,0,0,0,0);break;
                        case 6:tis='c';des='_';sot='_';set_led_on(0,1,1,1,0,0,0,0);set_led_off(0,0,0,1,0,0,0,0);break;
                        }
                set_digit_off(' ',' ',' ',' ');
                set_led_on(0,0,1,1,0,0,0,0);
                set_led_off(0,0,0,1,0,0,0,0);
                }
        if (mode==10)
                {
                if (count_register<7) count_register=7;
                hex2dec(count_register-6);
                if (des==0) des='_';
                tis='a';sot='_';
                set_digit_off(' ',' ',' ',' ');
                set_led_on(0,0,1,1,0,0,0,0);
                set_led_off(0,0,0,1,0,0,0,0);
                }

        if ((mode==11)||(mode==2))
                {
                hex2dec(data_register);
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
                set_led_on(0,0,0,1,0,0,0,0);
                set_led_off(0,0,0,1,0,0,0,0);
                delay_ms(3000);key_enter_press_switch=0;
                set_digit_off(' ',' ',' ',' ');
                start_time_mode=sys_time;start_time=sys_time;
                f_m1=0;
                }
        if ((key_mode_press_switch==1)&&(key_4==1))
                {
                key_mode_press_switch=0;f_m1=0;
                start_time_mode=sys_time;
                switch (mode)
                        {
                        case 0: mode=1;break;
                        case 1: mode=2;data_register=read_reg(count_register);break;
                        case 2: mode=1;break;
                        case 10:mode=11;data_register=read_reg(count_register);break;
                        case 11:mode=10;break;
                        case 100:mode=100;break;
                        }
                }

        if (((sys_time-start_time)>250)) 
                {
                set_digit_on(tis,sot,des,ed);
                if (((mode>0)&&(mode<7))||(mode==11))
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
