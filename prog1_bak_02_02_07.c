/*****************************************************
Project : Для ВИБРО-Т 
Version : V3.02.02
Date    : 23.01.2007
Author  : Метелкин Евгений          
Company : ООО ЭЛЬТЭРА           
Comments: V1.24.5 Standard

Chip type           : ATmega16
Program type        : Application
Clock frequency     : 8,000000 MHz
*****************************************************/
#include <def.h>

//-------------------------------------------------------------------//
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
//-------------------------------------------------------------------//


//-------------------------------------------------------------------//
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
//-------------------------------------------------------------------//

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
//-------------------------------------------------------------------//
// прерывание каждые 500 мкс
//-------------------------------------------------------------------//
long sys_time,whait_time;
bit key_mode,key_plus,key_mines,key_enter,key_mode_press,key_plus_press,key_mines_press,key_enter_press,key_mode_press_switch;
bit key_plus_press_switch,key_minus_press_switch,key_enter_press_switch;
char count_led,drebezg;
bit avaria,alarm1,alarm2,alarm_alarm1,alarm_alarm2;
int count_blink;
//-------------------------------------------------------------------//
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
        {//прерывание 500мкс
        char n;
        TCNT2=TCNT2_reload;
        #asm("sei");
        sys_time=sys_time+1;

        if (key_1==0){key_mode=1;if ((key_mode_press==0)&&(pik_en==0)){key_mode_press_switch=1;pik_en=1;drebezg=0;}key_mode_press=1;}
        else if ((key_2==1)&&(key_3==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME)){key_mode=0;key_mode_press=0;}

        if (key_2==0){key_plus=1;if ((key_plus_press==0)&&(pik_en==0)){key_plus_press_switch=1;pik_en=1;drebezg=0;}key_plus_press=1;}
        else if ((key_1==1)&&(key_3==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME)){key_plus=0;key_plus_press=0;}
           
        if (key_3==0){key_mines=1;if ((key_mines_press==0)&&(pik_en==0)){key_minus_press_switch=1;pik_en=1;drebezg=0;}key_mines_press=1;}
        else if ((key_2==1)&&(key_1==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME)){key_mines=0;key_mines_press=0;}
                
        if (key_4==0){key_enter=1;if (key_enter_press==0){key_enter_press_switch=1;pik_en=1;whait_time=sys_time;}key_enter_press=1;alarm_alarm2=0;}
        else {key_enter=0;key_enter_press=0;}
        
        if (++count_blink>2000) count_blink=0;
        if (count_blink<300) {n=1;buzer_en=0;if ((alarm_alarm1==1)||(alarm_alarm2==1))buzer_en=1;else buzer_en=0;}
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
        }
//-------------------------------------------------------------------//
interrupt [TIM2_COMP] void timer2_comp_isr(void){}
#include <spi.h>
#asm
.eseg
.org 0x10
.cseg
#endasm
eeprom float *ee_float;
eeprom char ee_point=3;
eeprom char *ee_char;
//eeprom float kal[2]={0,0.005};
eeprom float reg[30]={0,
5.6,7.1,0,5,0,1,
/*A_1  A_2  A_3  A_4  A_5  A_6   A_7  A_8  A_9  A_10  A_11  A_12  A_13  A_14  A_15  A_16  A_17  A_18  A_19 */
   0,   1,   0,   0,   1, 0.00, 20.00, 2,   2,   0,    10,   2,    5,    0,    1,    1,    0,    0,    0};

char mode,point,work_point,save_point;
#include <function_led.h>

        
char ed,des,sot,tis,count_filter,count_filter1,i,count_key,count_key1;
long filter_value;
unsigned int adc_buf,filter_min,filter_max,filter_buf[9],filter_buf1[100];

void hex2dec(float x)		// подпрограмма преобразования кода в ASCII
 	{				//
 	char str[9],str1[9];
 	signed char a,b;
 	if (x<-999) x=-999;
 	if (x>9999) x=9999;
 	ftoa(x,5,str1);
 	for (a=0;a<9;a++)
 	        {
 	        if (str1[a]=='.') goto p1;
 	        }
p1:
        b=4;
        while ((a>=0)&&(b>=0))
                {
                str[b]=str1[a];
                a--;b--;
                }
        a=3-b;
        while (b>=0) {str[b]='0';b--;}
                
        b=4;
        while ((a<9)&&(b<9))
                {
                str[b]=str1[a];
                a++;b++;
                }

        while (b<9) {str[b]='0';b++;}

 	if (point==1)
 	        {
                if (str[0]=='-') tis='-';
                else if (str[0]==0)tis=0;
                else tis=str[0]-0x30;


                sot=str[1]-0x30;
                des=str[2]-0x30;
                ed=str[3]-0x30;
                if (tis==0)
                        {
                        tis=' ';
                        if (sot==0)
                                {
                                sot=' ';
                                if(des==0) des=' ';
                                }
                        }
 	        }
 	if (point==2)
 	        {
                if (str[1]=='-') tis='-';
                else if (str[1]==0)tis=0;
                else tis=str[1]-0x30;

                if (str[2]=='-') sot='-';
                else if (str[2]==0)sot=0;
                else sot=str[2]-0x30;
//                sot=str[2]-0x30;
                des=str[3]-0x30;
                ed=str[5]-0x30;
                if (tis==0)
                        {
                        tis=' ';
                        if (sot==0)
                                {
                                sot=' ';
                                }
                        }
 	        }
 	if (point==3)
 	        {
                if (str[2]=='-') tis='-';
                else if (str[2]==0)tis=0;
                else tis=str[2]-0x30;

                if (str[3]=='-') sot='-';
                else if (str[3]==0)sot=0;
                else sot=str[3]-0x30;

//                sot=str[3]-0x30;
                des=str[5]-0x30;
                ed=str[6]-0x30;
                if (tis==0)
                        {
                        tis=' ';
                        }
 	        }
 	if (point==4)
 	        {
                if (str[3]=='-') tis='-';
                else if (str[3]==0)tis=0;
                else tis=str[3]-0x30;

                if (str[5]=='-') sot='-';
                else if (str[5]==0)sot=0;
                else sot=str[5]-0x30;

//                sot=str[5]-0x30;
                des=str[6]-0x30;
                ed=str[7]-0x30;
 	        }
 	}
//-------------------------------------------------------------------//
// чтение из АЦП
//-------------------------------------------------------------------//
int read_adc()
        {
        int a;
        a=rand();
        a=a/200;
        a=a+618;
        return a;
        }
// int read_adc()
//         {
//         int a;
//         cs=0;
//         SPCR=0b01010001;SPDR=0b10000001;
//         while(SPSR.7==0);a=SPDR;SPDR=0;a=a<<8;
//         while (SPSR.7 == 0);a = a + SPDR; 
//         cs=1;
//         return a;
//         }
//-------------------------------------------------------------------//

unsigned int buf[9],buf_m[9];
char buf_begin,buf_end,buf_n[9];
float x,adc_filter;
char j,k,count_register,count_key2;
long start_time,start_time_mode,time_key;

#include <function.h>

float izm()
        {
        char min_r,min_n;
        signed char rang[9];
        float k_f;
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
                rang[j]=0;for (i=0;i<9;i++)
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
        //ФНЧ
        //-------------------------------------------------------------------//
        k_f=read_reg(A_10);
        if (k_f==0) {adc_filter=buf[min_n];}
        else {k_f=0.002/k_f;adc_filter=k_f*buf[min_n]+(1-k_f)*adc_filter;}
        //-------------------------------------------------------------------//
        return adc_filter;
        }
//-------------------------------------------------------------------//
void main(void)
{
bit flag_start_pause1,flag_start_pause2,f_m1,key_enter_press_switch1;
float time_pause1,time_pause2,adc_value1,adc_value3;
float data_register,adc_filter,adc_value2;
float k_k,kk,bb;
ee_char=&ee_point;point=*ee_char;

power_off:

#asm("cli");
PORTA=0b11111111;DDRA=0b11111111;
PORTB=0b00000000;DDRB=0b10110011;
PORTC=0b11111000;DDRC=0b11111011;
PORTD=0b11110000;DDRD=0b00001000;
while ((key_1==0)&&(key_2==0)&&(key_3==0)&&(key_4==0));
TCCR0=0x02;TCNT0=TCNT0_reload;OCR0=0x00;

TCCR1A=0x00;TCCR1B=0x05;TCNT1H=0x00;TCNT1L=0x01;
ICR1H=0x00;ICR1L=0x04;OCR1AH=0x00;OCR1AL=0x02;
OCR1BH=0x00;OCR1BL=0x03;

ASSR=0x00;TCCR2=0x03;TCNT2=TCNT2_reload;OCR2=0x00;
MCUCR=0x00;MCUCSR=0x00;TIMSK=0xFF;

UCSRA=0x00;UCSRB=0xD8;UCSRC=0x86;UBRRH=0x00;UBRRL=0x33;
ACSR=0x80;SFIOR=0x00;SPCR=0x52;SPSR=0x00;WDTCR=0x1F;WDTCR=0x0F;
//goto a1;//test
//-------------------------------------------------------------------//
//Ожидание включения питания 
//-------------------------------------------------------------------//
i=0;
while (i<100)
        {
        if ((key_1==0)&&(key_4==0)&&(key_2==1)&&(key_3==1)) i++;
        else i=0;
        delay_ms(20);
        }
//-------------------------------------------------------------------//
power=1;
data_register=read_reg(A_07);
if (data_register<0)
        {
        if (data_register>=-1000)point=1;
        else if (data_register>=-100)point=2;
        else if (data_register>=-10)point=3;
        }
else
        {
        if (data_register<10)point=4;
        else if (data_register<100)point=3;
        else if (data_register<1000)point=2;
        else if (data_register>=1000)point=1;
        }
work_point=point;
#asm("sei")
//-------------------------------------------------------------------//
//Показать основные настройки
//блокировка по включению
//-------------------------------------------------------------------//
start_time=sys_time;count_register=1;
set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
while ((sys_time-start_time)<read_reg(A_11)*2000) 
        {
        hex2dec(count_register);
        ed=' ';
        switch (count_register)
                {
                case 2: tis='У';sot='_';des= 2 ;break;
                case 3: tis= 3 ;sot='_';des= 1 ;break;
                case 4: tis= 3 ;sot='_';des= 2 ;break;
                case 5: tis='p';sot='_';des='_';break;
                case 6: tis='c';sot='_';des='_';break;
                default:tis='У';sot='_';des= 1 ;break;
                }
        set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
        set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
        delay_ms(500);

        data_register=read_reg(count_register);
        if ((data_register>MAX_MIN[count_register,1])||(data_register<MAX_MIN[count_register,0])) data_register=FAKTORY[count_register];//проверка граничных значений
        save_reg(data_register,count_register);
        
        switch (count_register)
                {
                case 2: count_register=3;point=work_point;break;
                case 3: count_register=4;point=1;break;
                case 4: count_register=5;point=1;break;
                case 5: count_register=6;point=1;break;
                case 6: count_register=1;point=1;break;
                default:count_register=2;point=work_point;break;
                }
        hex2dec(data_register);
        set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
        if (point==1)       {set_led_on(0,0,0,0,0,0,0,0);set_led_off(0,0,0,0,0,0,0,0);}
        else if (point==2)  {set_led_on(0,0,0,0,0,0,1,0);set_led_off(0,0,0,0,0,0,1,0);}
        else if (point==3)  {set_led_on(0,0,0,0,0,1,0,0);set_led_off(0,0,0,0,0,1,0,0);}
        else if (point==4)  {set_led_on(0,0,0,0,1,0,0,0);set_led_off(0,0,0,0,1,0,0,0);}
        delay_ms(500);
        }
a1:

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
k_k=read_reg(A_16);

ee_char=&ee_point;
point=*ee_char;
work_point=point;

//-------------------------------------------------------------------//
while (1)
        {
        #asm("wdr");
        adc_filter=izm();
        //-------------------------------------------------------------------//
        //абсолютная величина
        //-------------------------------------------------------------------//
        if (read_reg(A_12)<3) adc_value1=adc_filter*k_k/100;
        else adc_value1=adc_filter*k_k/200;

        //-------------------------------------------------------------------//
        //относительная величина
        //-------------------------------------------------------------------//
        i=read_reg(A_12);
        switch (i)
                {
                case 0:kk=(read_reg(A_07)-read_reg(A_06))/(20-4);bb=read_reg(A_06)-kk*4;break;//4-20mA
                case 1:kk=(read_reg(A_07)-read_reg(A_06))/(5-0);bb=read_reg(A_06)-kk*0;break;//0-5mA
                case 2:kk=(read_reg(A_07)-read_reg(A_06))/(20-0);bb=read_reg(A_06)-kk*0;break;//0-20mA
                case 3:kk=(read_reg(A_07)-read_reg(A_06))/(10-0);bb=read_reg(A_06)-kk*0;break;//0-10V
                default:kk=(read_reg(A_07)-read_reg(A_06))/(5-0);bb=read_reg(A_06)-kk*0;break;//0-5V
                }
        adc_value2=adc_value1*kk+bb;
                
        //-------------------------------------------------------------------//
        //авария
        //-------------------------------------------------------------------//
        if (adc_value2<(read_reg(A_06)*(1-read_reg(A_08)/100))) {avaria=1;}
        else if (adc_value2>(read_reg(A_07)*(1+read_reg(A_09)/100))) {avaria=1;}
        else avaria=0;
        //-------------------------------------------------------------------//


        //-------------------------------------------------------------------//
        //уставка 1,2
        //-------------------------------------------------------------------//
        if (adc_value2>(read_reg(Y_01)*(1+read_reg(A_01)/100))) {alarm1=1;}
        else {alarm1=0;alarm_alarm1=0;flag_start_pause1=0;}
        if (adc_value2>(read_reg(Y_02)*(1+read_reg(A_01)/100))) {alarm2=1;}
        else {alarm2=0;flag_start_pause2=0;}
        //-------------------------------------------------------------------//
        //
        //добавить маску и блокировку
        //
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
        //      МЕНЮ
        //-------------------------------------------------------------------//
        //возврат из меню
        //-------------------------------------------------------------------//
        if (((sys_time-start_time_mode)>read_reg(A_13)*2000)){mode=0;f_m1=0;}
        //-------------------------------------------------------------------//



        if ((key_enter_press_switch==1)&&(mode==0)){key_enter_press_switch=0;key_enter_press_switch1=1;}


        //-------------------------------------------------------------------//
        //вход в инженерное меню
        //-------------------------------------------------------------------//
        if ((key_enter_press_switch1==1)&&(key_enter==1)&&(key_mode==0))
                {if ((sys_time-whait_time)>3000){mode=10;start_time_mode=sys_time;key_enter_press_switch1=0;}}
        //-------------------------------------------------------------------//

        //-------------------------------------------------------------------//
        //Ожидание выключения питания 
        //-------------------------------------------------------------------//
        if ((key_enter_press_switch1==1)&&(key_enter==1)&&(key_mode==1)&&(key_2==1)&&(key_3==1))
                {if ((sys_time-whait_time)>3000) {goto power_off;}}
        //-------------------------------------------------------------------//

        //-------------------------------------------------------------------//
        //что показывать в mode=0
        //-------------------------------------------------------------------//
        if (mode==0)
                {
                count_register=1;
                point=work_point;
                if (alarm_alarm2==0)
                        {
                        if (read_reg(A_05)==0)adc_value3=adc_value1;
                        else adc_value3=adc_value2;
                        }
                hex2dec(adc_value3);
                if (point==1)       {set_led_on(0,0,0,1,0,0,0,0);set_led_off(0,0,0,1,0,0,0,0);}
                else if (point==2)  {set_led_on(0,0,0,1,0,0,1,0);set_led_off(0,0,0,1,0,0,1,0);}
                else if (point==3)  {set_led_on(0,0,0,1,0,1,0,0);set_led_off(0,0,0,1,0,1,0,0);}
                else if (point==4)  {set_led_on(0,0,0,1,1,0,0,0);set_led_off(0,0,0,1,1,0,0,0);}
                }
        //-------------------------------------------------------------------//
                
        //-------------------------------------------------------------------//
        //пользовательское меню
        //-------------------------------------------------------------------//
        if (mode==1)
                {
                hex2dec(count_register);
                ed=' ';
                switch (count_register)
                        {
                        case 2: tis='У';sot='_';des= 2 ;set_led_on(0,1,0,1,0,0,0,0);break;
                        case 3: tis= 3 ;sot='_';des= 1 ;set_led_on(0,0,1,1,0,0,0,0);break;
                        case 4: tis= 3 ;sot='_';des= 2 ;set_led_on(0,1,0,1,0,0,0,0);break;
                        case 5: tis='p';sot='_';des='_';set_led_on(0,0,0,1,0,0,0,0);break;
                        case 6: tis='c';sot='_';des='_';set_led_on(0,0,0,1,0,0,0,0);break;
                        default:tis='У';sot='_';des= 1 ;set_led_on(0,0,1,1,0,0,0,0);break;
                        }
                set_led_off(0,0,0,1,0,0,0,0);
                }
        //-------------------------------------------------------------------//

        //-------------------------------------------------------------------//
        //данные пользовательского меню
        //-------------------------------------------------------------------//
        if (mode==2)
                {
                if (count_register>6)count_register=1;
                if (count_register<3)point=work_point;
                else point=1;
                hex2dec(data_register);
                if (point==1)       {set_led_on(0,0,0,0,0,0,0,0);set_led_off(0,0,0,0,0,0,0,0);}
                else if (point==2)  {set_led_on(0,0,0,0,0,0,1,0);set_led_off(0,0,0,0,0,0,1,0);}
                else if (point==3)  {set_led_on(0,0,0,0,0,1,0,0);set_led_off(0,0,0,0,0,1,0,0);}
                else if (point==4)  {set_led_on(0,0,0,0,1,0,0,0);set_led_off(0,0,0,0,1,0,0,0);}
                }
        //-------------------------------------------------------------------//

        //-------------------------------------------------------------------//
        //инженерное меню
        //-------------------------------------------------------------------//
        if (mode==10)
                {
                if (count_register<7) count_register=7;
                hex2dec(count_register-6);point=1;
                if (des==' ') des='_';
                tis='a';sot='_';
                set_led_on(0,0,0,1,0,0,0,0);
                set_led_off(0,0,0,1,0,0,0,0);
                }
        //-------------------------------------------------------------------//

        //-------------------------------------------------------------------//
        //калибровка
        //-------------------------------------------------------------------//
        if ((mode==11)&&(count_register==A_16))
                {
                point=work_point;
                k_k=data_register;
                if (read_reg(A_05)==0)adc_value3=adc_value1;
                else adc_value3=adc_value2;
                hex2dec(adc_value3);
                if (point==1)       {set_led_on(0,0,0,1,0,0,0,0);set_led_off(0,0,0,1,0,0,0,0);}
                else if (point==2)  {set_led_on(0,0,0,1,0,0,1,0);set_led_off(0,0,0,1,0,0,1,0);}
                else if (point==3)  {set_led_on(0,0,0,1,0,1,0,0);set_led_off(0,0,0,1,0,1,0,0);}
                else if (point==4)  {set_led_on(0,0,0,1,1,0,0,0);set_led_off(0,0,0,1,1,0,0,0);}
                point=4;
                }
        //-------------------------------------------------------------------//

        //-------------------------------------------------------------------//
        //данные инженерного меню
        //-------------------------------------------------------------------//
        if ((mode==11)&&(count_register!=A_16))
                {
                if (((count_register>=A_06)&&(count_register<=A_09)))
                        {//point=work_point;
                        if ((data_register<0))
                                {
                                if (data_register>=-1000)point=1;
                                else if (data_register>=-100)point=2;
                                else if (data_register>=-10)point=3;
                                }
                        else
                                {
                                if (data_register<10)point=4;
                                else if (data_register<100)point=3;
                                else if (data_register<1000)point=2;
                                else if (data_register>=1000)point=1;
                                }
                        }
                else if (count_register==A_10)point=3;
                else point=1;
                hex2dec(data_register);
                if (count_register==A_18){tis='a',sot=2;des='-';ed=1;point=1;}
                if (count_register==A_19){tis=0,sot=1;des=0;ed=7;point=3;}
                if (count_register==A_16)
                        {
                        if (data_register==0)     {tis=4,sot='-';des=2;ed=0;point=1;}
                        else if (data_register==1){tis=0,sot='-';des=0;ed=5;point=1;}
                        else if (data_register==2){tis=0,sot='-';des=2;ed=0;point=1;}
                        else if (data_register==3){tis=0,sot='-';des=1;ed=0;point=1;}
                        else                      {tis=0,sot='-';des=0;ed=5;point=3;}
                        }
                if (point==1)       {set_led_on(0,0,0,0,0,0,0,0);set_led_off(0,0,0,0,0,0,0,0);}
                else if (point==2)  {set_led_on(0,0,0,0,0,0,1,0);set_led_off(0,0,0,0,0,0,1,0);}
                else if (point==3)  {set_led_on(0,0,0,0,0,1,0,0);set_led_off(0,0,0,0,0,1,0,0);}
                else if (point==4)  {set_led_on(0,0,0,0,1,0,0,0);set_led_off(0,0,0,0,1,0,0,0);}
                }
        //-------------------------------------------------------------------//
        
        
        if (key_plus_press==1)
                {
                start_time_mode=sys_time;
                if (count_key==0)
                        {
                        if (mode==10)if (++count_register>MAX_REGISTER)count_register=MAX_REGISTER;
                        if (mode==1)if (++count_register>6)count_register=6;
                        }
                if ((count_key==0)||(count_key==21)||(count_key1==102))
                        {
                        if      (point==1)
                                {
                                data_register=data_register+1;
                                if ((data_register<0)&&(data_register>=-100))point=2;
                                }
                        else if (point==2)
                                {
                                data_register=data_register+0.1;
                                if ((data_register>0)&&(data_register>=1000))point=1;
                                else if ((data_register<0)&&(data_register>=-10))point=3;
                                }
                        else if (point==3)
                                {
                                data_register=data_register+0.01;
                                if ((data_register>0)&&(data_register>=100))point=2;
                                else if ((data_register<0)&&(data_register>=-10))point=2;
                                }
                        else if (point==4)
                                {
                                data_register=data_register+0.001;
                                if ((data_register>0)&&(data_register>=10))point=3;
//                                else if ((data_register<0)&&(data_register>=-1))point=3;
                                }
                        if (data_register>MAX_MIN[count_register,1])data_register=MAX_MIN[count_register,1];
                        if (count_key==0)count_key=60;if (count_key==21)count_key=20;
                        }
                rekey();
                }
        else if ((mode!=100)&&(key_enter_press==0)&&(key_mines_press==0)){count_key=0;count_key1=0;count_key2=0;}

        if (key_mines_press==1)
                {
                start_time_mode=sys_time;
                if (count_key==0)
                        {
                        if (mode==10)if (--count_register<7)count_register=7;
                        if (mode==1)if (--count_register<1)count_register=1;
                        }
                if ((count_key==0)||(count_key==21)||(count_key1==102))
                        {
                        if      (point==1)
                                {
                                data_register=data_register-1;
                                if ((data_register>0)&&(data_register<1000))point=2;
                                }
                        else if (point==2)
                                {
                                data_register=data_register-0.1;
                                if ((data_register>0)&&(data_register<100))point=3;
                                else if ((data_register<0)&&(data_register<=-100))point=1;
                                }
                        else if (point==3)
                                {
                                data_register=data_register-0.01;
                                if ((data_register>0)&&(data_register<10))point=4;
                                else if ((data_register<0)&&(data_register<=-10))point=2;
                               
                                }
                        else if (point==4)
                                {
                                data_register=data_register-0.001;
                                if ((data_register<0))point=3;
                                }
                        if (data_register<MAX_MIN[count_register,0])data_register=MAX_MIN[count_register,0];
                        if (count_key==0)count_key=60;if (count_key==21)count_key=20;
                        }
                rekey();
                }
        else if ((mode!=100)&&(key_enter_press==0)&&(key_plus_press==0)){count_key=0;count_key1=0;count_key2=0;}

        if ((key_enter_press_switch==1)&&(key_enter==1)&&(key_plus_press==0)&&(key_mines_press==0)&&(key_mode_press==0)&&(mode!=0)&&(mode!=10)&&(mode!=1))
                {
                save_reg(data_register,count_register);
                start_time_mode=sys_time;
                if (count_register==A_07)
                        {
                        ee_char=&ee_point;
                        *ee_char=point;
                        work_point=point;
                        }
                if (count_register==A_17)
                        {
                        for (i=0;i<22;i++)
                                {
                                save_reg(FAKTORY[i],i);
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
                        case 0: mode=1;count_register=1;break;
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
                if (mode>0)//это шобы мигало
                        {
                        if((key_plus_press==1)||(key_mines_press==1)) set_digit_off(tis,sot,des,ed);
                        else set_digit_off(' ',' ',' ',' ');
                        }
                if (mode==0)//а это шобы не мигало
                        {
                        set_digit_off(tis,sot,des,ed);
                        }
                start_time=sys_time;
                }
        };
}
//-------------------------------------------------------------------//
