/*****************************************************
Project : ��� �����-�
Version : 3.0.00
Date    : 02.07.2008
Author  : �������� �������
Comments: V1.24.5 Standard

Program type        : Application
Clock frequency     : 8,000000 MHz
*****************************************************/
#include <define.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
//#define cc
//#define ca
//--------------------------------------//
//	USART Receiver buffer
//--------------------------------------//
#define RX_BUFFER_SIZE 36
char rx_buffer[RX_BUFFER_SIZE];
unsigned char rx_counter,mod_time,mod_time_s,rx_wr_index;
bit rx_c,ti_en,rx_m;
interrupt [USART_RXC] void usart_rx_isr(void)
        {
	char status,d;
	status=UCSRA;d=UDR;
	if (((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)&&((ti_en==0)&&(rx_c==0)))
		{if (mod_time==0){rx_m=1;rx_wr_index=0;}mod_time=mod_time_s;}
	rx_buffer[rx_wr_index]=d;
	if (++rx_wr_index >= RX_BUFFER_SIZE) rx_wr_index=0;
	if (++rx_counter >= RX_BUFFER_SIZE) rx_counter=0;
	}
//--------------------------------------//
// USART Transmitter buffer
//--------------------------------------//
#define TX_BUFFER_SIZE 64
unsigned char tx_buffer_begin,tx_buffer_end,tx_buffer[TX_BUFFER_SIZE];
interrupt [USART_TXC] void usart_tx_isr(void)
        {
        if (ti_en==1)
	        {
        	if (++tx_buffer_begin>=TX_BUFFER_SIZE) tx_buffer_begin=0;
	        if (tx_buffer_begin!=tx_buffer_end) {UDR=tx_buffer[tx_buffer_begin];}
        	else {ti_en=0;rx_c=0;rx_m=0;rx_tx=0;rx_counter=0;}
	        }
        }
//-------------------------------------------------------------------//
bit buzer_en,buzer,pik_en,buzer_buzer_en;
char pik_count;
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
        {//���������� ��� ������
        TCNT0=TCNT0_reload;
        #asm("wdr");
        if ((buzer_en==1)&&(buzer_buzer_en==1)){if (buzer==1) {buzerp=1;buzer=0;}else {buzerp=0;buzer=1;}}
        else if (pik_en==1){if (++pik_count>200) {pik_en=0;pik_count=0;}if (buzer==1) {buzerp=1;buzer=0;}else {buzerp=0;buzer=1;}}
        else buzerp=0;
        if (pik_en==1){if (++pik_count>200) {pik_en=0;pik_count=0;}}
        }
char led_byte[5,2];
interrupt [TIM0_COMP] void timer0_comp_isr(void){}
interrupt [TIM1_OVF] void timer1_ovf_isr(void){TCNT1H=0x05;TCNT1L=0x01;}
interrupt [TIM1_CAPT] void timer1_capt_isr(void){}
interrupt [TIM1_COMPA] void timer1_compa_isr(void){}
interrupt [TIM1_COMPB] void timer1_compb_isr(void){}
//-------------------------------------------------------------------//
// ���������� ������ 500 ���
//-------------------------------------------------------------------//
long sys_time,whait_time;
bit key_mode,key_plus,key_mines,key_enter,key_mode_press,key_plus_press,key_mines_press,key_enter_press,key_mode_press_switch;
bit key_plus_press_switch,key_minus_press_switch,key_enter_press_switch;
char count_led,count_led1,drebezg;
bit avaria,alarm1,alarm2,alarm_alarm1,alarm_alarm2;
int count_blink;
//-------------------------------------------------------------------//
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
        {//���������� 500���
        char n;
        TCNT2=TCNT2_reload;
        #asm("sei");
        sys_time=sys_time+1;

	if (mod_time==0){if (rx_m==1) rx_c=1;}
	else 	mod_time--;


        if (key_1==0){key_mode=1;if ((key_mode_press==0)&&(pik_en==0)){key_mode_press_switch=1;pik_en=1;drebezg=0;}key_mode_press=1;}
        else if ((key_2==1)&&(key_3==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME)){key_mode=0;key_mode_press=0;}

        if (key_2==0){key_plus=1;if ((key_plus_press==0)&&(pik_en==0)){key_plus_press_switch=1;pik_en=1;drebezg=0;}key_plus_press=1;}
        else if ((key_1==1)&&(key_3==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME)){key_plus=0;key_plus_press=0;}

        if (key_3==0){key_mines=1;if ((key_mines_press==0)&&(pik_en==0)){key_minus_press_switch=1;pik_en=1;drebezg=0;}key_mines_press=1;}
        else if ((key_2==1)&&(key_1==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME)){key_mines=0;key_mines_press=0;}

        if (key_4==0){key_enter=1;if (key_enter_press==0){key_enter_press_switch=1;pik_en=1;whait_time=sys_time;}key_enter_press=1;alarm_alarm1=0;alarm_alarm2=0;}
        else {key_enter=0;key_enter_press=0;}

        if (++count_blink>2000) count_blink=0;
        if (count_blink<300) {n=1;buzer_en=0;if ((alarm_alarm1==1)||(alarm_alarm2==1))buzer_en=1;else buzer_en=0;}
        else {n=0;if ((alarm1==1)||(alarm2==1))buzer_en=1;}
//#ifdef ca
         katode=0xFF;anode=anode&0b00000111;
/*#else
        katode=0x00;anode=anode|0b01111000;anode5=0;
#endif*/
        switch (count_led)
                {
//#ifdef ca
                 case 4: count_led=0;anode1=1;DDRC.3=1;katode=led_byte[0,n];break;
                 case 3: count_led=4;anode2=1;DDRC.4=1;katode=led_byte[1,n];break;
                 case 2: count_led=3;anode3=1;DDRC.5=1;katode=led_byte[2,n];break;
                 case 1: count_led=2;anode4=1;DDRC.6=1;katode=led_byte[3,n];break;
                 default:count_led=1;anode5=1;DDRC.7=1;katode=led_byte[4,n];break;
/*#else

                case 4: count_led=0;katode=led_byte[0,n];anode1=0;DDRC.3=1;break;
                case 3: count_led=4;katode=led_byte[1,n];anode2=0;DDRC.4=1;break;
                case 2: count_led=3;katode=led_byte[2,n];anode3=0;DDRC.5=1;break;
                case 1: count_led=2;katode=led_byte[3,n];anode4=0;DDRC.6=1;break;
                default:
                        {count_led=1;
                        if (++count_led1>5)
                                {count_led1=0;katode=led_byte[4,n];anode5=1;DDRC.7=1;}*/
                    //    break;
                        }


//#endif
 //               }
        }
//-------------------------------------------------------------------//
interrupt [TIM2_COMP] void timer2_comp_isr(void){}
#include <spi.h>

eeprom float reg[4,27]=
 {{0, 4.6, 7.1,   0,   5,   0,   1,   0,   1,   0,   0,   1,0.00,20.0,   2,   2,   0,  10,   2,   5,   0,   0,   1,   0,1.00,11.09,    1},
  {0, 4.6, 7.1,   0,   5,   0,   1,   0,   1,   0,   0,   1,0.00,20.0,   2,   2,   0,  10,   2,   5,   0,   0,   1,   0,1.00,11.09,    1},
  {0,9999,9999,  30,  30,   1,   1,  10,   2,   1,   1,   2,9999,9999,  10,  10,   5,  30,   4,  10,   1,   1, 1.8,   1,9999,9999,  247},
  {0,-999,-999,   0,   0,   0,   0,   0,   1,   0,   0,   0,-999,-999,   0,   0,   0,   0,   0,   0,   0,   0, 0.2,   0,-999,-999,    0}};
  //|���1|���2|���1|���2|����|����|����|����|���1|���2|����| ���| ���|����|����|����|����|����|����|���1|���2| ���|����|����|����|�����|
  // Y_01,Y_02,Z_01,Z_02,P___,C___,A_01,A_02,A_03,A_04,A_05,A_06,A_07,A_08,A_09,A_10,A_11,A_12,A_13,A_14,A_15,A_16,A_17,A_18,A_19,Adres;

eeprom char ee_point=3;

char mode,point,work_point,save_point;
#include <function_led.h>

char ed,des,sot,tis,count_filter,count_filter1,i,count_key,count_key1;
long filter_value;
unsigned int adc_buf;

void hex2dec(float x)		// ������������ �������������� ���� � ASCII
 	{				//
 	char str[9],str1[9];
 	signed char a,b;
 	if (x<-999) x=-999;
 	if (x>9999) x=9999;
 	ftoa(x,5,str1);
 	for (a=0;a<9;a++){if (str1[a]=='.') goto p1;}
p1:
        b=4;
        while ((a>=0)&&(b>=0)){str[b]=str1[a];a--;b--;}
        a=3-b;
        while (b>=0) {str[b]='0';b--;}
        b=4;
        while ((a<9)&&(b<9)){str[b]=str1[a];a++;b++;}
        while (b<9) {str[b]='0';b++;}
 	if (point==1)
 	        {
                if (str[0]=='-') tis='-';
                else if (str[0]==0)tis=0;
                else tis=str[0]-0x30;
                sot=str[1]-0x30;
                des=str[2]-0x30;
                ed=str[3]-0x30;
                if (tis==0){tis=' ';if (sot==0){sot=' ';if(des==0) des=' ';}}
 	        }
 	if (point==2)
 	        {
                if (str[1]=='-') tis='-';
                else if (str[1]==0)tis=0;
                else tis=str[1]-0x30;
                if (str[2]=='-') sot='-';
                else if (str[2]==0)sot=0;
                else sot=str[2]-0x30;
                des=str[3]-0x30;
                ed=str[5]-0x30;
                if (tis==0){tis=' ';if (sot==0)sot=' ';}
 	        }
 	if (point==3)
 	        {
                if (str[2]=='-') tis='-';
                else if (str[2]==0)tis=0;
                else tis=str[2]-0x30;
                if (str[3]=='-') sot='-';
                else if (str[3]==0)sot=0;
                else sot=str[3]-0x30;
                des=str[5]-0x30;
                ed=str[6]-0x30;
                if (tis==0)tis=' ';
 	        }
 	if (point==4)
 	        {
                if (str[3]=='-') tis='-';
                else if (str[3]==0)tis=0;
                else tis=str[3]-0x30;
                if (str[5]=='-') sot='-';
                else if (str[5]==0)sot=0;
                else sot=str[5]-0x30;
                des=str[6]-0x30;
                ed=str[7]-0x30;
 	        }
 	}
//-------------------------------------------------------------------//
// ������ �� ���
void find_save_reg(unsigned int a,float b);
float find_reg(unsigned int a);
void response_m_err(char a);                     //
//-------------------------------------------------------------------//
int read_adc()
        {
        int a;
        cs=0;
        SPCR=0b01010001;
        i=reg[0,A_12];
        switch (i)
                {
                case 0: SPDR=0b10110001;break;//4-20mA 20=4.4   =3606 k=20/3606 AIN0
                case 1: SPDR=0b10111001;break;//0-5mA   5=4.4   =3606 k= 5/3606 AIN1
                case 2: SPDR=0b10110001;break;//0-20mA 20=4.4   =3606 k=20/3606 AIN0
                case 3: SPDR=0b10111001;break;//0-10V  10=4.506 =3606 k=10/3691 AIN1
                default:SPDR=0b10110001;break;//0-5V    5=4.506 =3606 k= 5/3691 AIN0
                }
        while(SPSR.7==0);a=SPDR;SPDR=0;a=a<<8;
        while (SPSR.7 == 0);a = a + SPDR;
        cs=1;
        return a;
        }
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
        //���������
        //-------------------------------------------------------------------//
        if (++buf_end>8) buf_end=0;buf[buf_end]=read_adc();min_r=9;
        //-------------------------------------------------------------------//
        //-------------------------------------------------------------------//
        //��������� ������
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
        //���
        //-------------------------------------------------------------------//
        k_f=reg[0,A_10];
        if (k_f==0) k_f=0.001;
        k_f=0.001/k_f;adc_filter=k_f*buf[min_n]+(1-k_f)*adc_filter;
        //-------------------------------------------------------------------//
        return adc_filter;
        }
//-------------------------------------------------------------------//
char error;
int crc;
float value[6],adc_value1,adc_value2,adc_value3;
bit blok1,blok2,signal;
void response_m_aa1();
void response_m_aa46();
void response_m_aa48();
void check_add_cr();

void check_rx();
void mov_buf_mod(char a);		//
void mov_buf(char a);			//
void crc_end();				//
void crc_rtu(char a);			//


void main(void)
{
bit flag_start_pause1,flag_start_pause2,f_m1,key_enter_press_switch1;
float time_pause1,time_pause2/*,adc_value1*/;
float data_register,adc_filter/*,adc_value2*/;
float k_k,kk,bb,dop1,dop2;
float gis_val1=reg[0,Y_01];         //�������� � ������ �����������
float gis_val2=reg[0,Y_02];
char q1,q2,q3,q4,diap_val1=0,diap_val2=0;//diap_val1,2 - ��� �������� �� 1� � �� 2� ����
float temp;


// while(1)
//         {
//         DDRC=0xFF;
//         DDRA=0xFF;
//         anode1=1;
//         anode2=1;
//         anode3=1;
//         anode4=0;
//         anode5=0;
//         q1++;
//         if (q1>9)q1=0;
//         katode=255-led_calk(q1);
//         delay_ms(500);
//
//
//         }
//
// temp=2345;
// reg[0,0]=temp;
//
// reg[0,0]=1234;
// temp=reg[0,0];
//
// q1=(*((unsigned char *)(&temp)+0));
// q2=(*((unsigned char *)(&temp)+1));
// q3=(*((unsigned char *)(&temp)+2));
// q4=(*((unsigned char *)(&temp)+3));
//
//
// q1=0;
// q2=1;
// q3=2;
// q4=0x44;
//
//
// *((unsigned char *)(&temp)+0)=q1;
// *((unsigned char *)(&temp)+1)=q2;
// *((unsigned char *)(&temp)+2)=q3;
// *((unsigned char *)(&temp)+3)=q4;
//
// reg[0,0]=temp;
// reg[0,0]=temp;
// reg[0,0]=temp;
//

point=ee_point;
power_off:

#asm("cli");
PORTA=0b11111111;DDRA=0b11111111;
PORTB=0b00000000;DDRB=0b10110011;
PORTC=0b11111011;DDRC=0b11111000;
PORTD=0b11000011;DDRD=0b00111110;
UBRRH=0x00;UBRRL=0x00;UCSRB=0x00;UCSRC=0x00;

while ((key_1==0)&&(key_2==0)&&(key_3==0)&&(key_4==0));
TCCR0=0x03;TCNT0=TCNT0_reload;OCR0=0x00;

ASSR=0x00;TCCR2=0x04;TCNT2=TCNT2_reload;OCR2=0x00;
//ASSR=0x00;TCCR2=0x07;TCNT2=TCNT2_reload;OCR2=0x00;
MCUCR=0x00;MCUCSR=0x00;TIMSK=0xFF;

//UBRRH=0x00;UBRRL=0x67;UCSRB=0xD8;UCSRC=0x86;
ACSR=0x80;SFIOR=0x00;SPCR=0x52;SPSR=0x00;WDTCR=0x1F;WDTCR=0x0F;
mod_time_s=60;

//goto a1;//test
//goto a2;//test

//-------------------------------------------------------------------//
//�������� ��������� �������
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
data_register=reg[0,A_07];
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

// a2:
#asm("sei")
//         tis=1;sot=2;des=3;ed=4;
//         set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
//         set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
// //        delay_ms(500);
//
// while (1);
//-------------------------------------------------------------------//
//�������� �������� ���������
//���������� �� ���������
//-------------------------------------------------------------------//
start_time=sys_time;count_register=1;
set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
while ((sys_time-start_time)<reg[0,A_11]*1000)
//while (1)
        {
        ed=' ';
        switch (count_register)
                {
                case 2: tis='�';sot='_';des= 2 ;break;
                case 3: tis= 3 ;sot='_';des= 1 ;break;
                case 4: tis= 3 ;sot='_';des= 2 ;break;
                case 5: tis='p';sot='_';des='_';break;
                case 6: tis='c';sot='_';des='_';break;
                case 1: tis='�';sot='_';des= 1 ;break;
                default:tis='�';sot='_';des= 1 ;break;
                }
        set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
        set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
        delay_ms(500);

        data_register=reg[0,count_register];
//        if ((data_register>MAX_MIN[count_register,1])||(data_register<MAX_MIN[count_register,0])) data_register=FAKTORY[count_register];//�������� ��������� ��������

//        save_reg(data_register,count_register);

        switch (count_register)
                {
                case 2: count_register=3;point=work_point;break;
                case 3: count_register=4;point=1;break;
                case 4: count_register=5;point=1;break;
                case 5: count_register=6;point=1;break;
                case 6: count_register=1;point=1;break;
                case 1: count_register=2;point=work_point;break;
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
UBRRH=0x00;UBRRL=0x67;UCSRB=0xD8;UCSRC=0x86;
power=1;


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
k_k=reg[0,A_16];

point=ee_point;
work_point=point;
ti_en=0;

rx_wr_index=0;
tx_buffer_begin=0;
tx_buffer_end=0;
//-------------------------------------------------------------------//
while (1)
        {
        #asm("wdr");
        adc_filter=izm();
//        adc_filter=1234;
        //-------------------------------------------------------------------//
        //���������� ��������
        //-------------------------------------------------------------------//
        i=reg[0,A_12];
        switch (i)
                {
                case 0: adc_value1=adc_filter*k_k*20/3606;break;//4-20mA 20=4.4   =3606 k=20/3606
                case 1: adc_value1=adc_filter*k_k* 5/3606;break;//0-5mA   5=4.4   =3606 k= 5/3606
                case 2: adc_value1=adc_filter*k_k*20/3606;break;//0-20mA 20=4.4   =3606 k=20/3606
                case 3: adc_value1=adc_filter*k_k*10/3691;break;//0-10V  10=4.506 =3606 k=10/3691
                default:adc_value1=adc_filter*k_k* 5/3691;break;//0-5V    5=4.506 =3606 k= 5/3691
                }



//        if (reg[0,A_12]<3) adc_value1=adc_filter*k_k/100;
//        else adc_value1=adc_filter*k_k/200;
        //-------------------------------------------------------------------//
        //������������� ��������
        //-------------------------------------------------------------------//
        i=reg[0,A_12];
        switch (i)
                {
                case 0: kk=(reg[0,A_07]-reg[0,A_06])/(20-4);bb=reg[0,A_06]-kk*4;dop1=4;dop2=20;break;//4-20mA
                case 1: kk=(reg[0,A_07]-reg[0,A_06])/( 5-0);bb=reg[0,A_06]-kk*0;dop1=0;dop2= 5;break;//0-5mA
                case 2: kk=(reg[0,A_07]-reg[0,A_06])/(20-0);bb=reg[0,A_06]-kk*0;dop1=0;dop2=20;break;//0-20mA
                case 3: kk=(reg[0,A_07]-reg[0,A_06])/(10-0);bb=reg[0,A_06]-kk*0;dop1=0;dop2=10;break;//0-10V
                default:kk=(reg[0,A_07]-reg[0,A_06])/( 5-0);bb=reg[0,A_06]-kk*0;dop1=0;dop2= 5;break;//0-5V
                }
        adc_value2=adc_value1*kk+bb;

        //-------------------------------------------------------------------//
        //������
        //-------------------------------------------------------------------//

        if (adc_value1<(dop1*(1-reg[0,A_08]/100)))//��������� � adc_value2
                {
                avaria=1;
                adc_value2=(dop1*(1-reg[0,A_08]/100))*kk+bb;
                }
        else if (adc_value2>(dop2*(1+reg[0,A_09]/100)))
                {
                avaria=1;
                adc_value2=(dop2*(1+reg[0,A_09]/100))*kk+bb;
                }
        else avaria=0;


//         if (adc_value2<(reg[0,A_06]*(1-reg[0,A_08]/100)))
//                 {avaria=1;adc_value2=reg[0,A_06]*(1-reg[0,A_08]/100);}
//         else if (adc_value2>(reg[0,A_07]*(1+reg[0,A_09]/100)))
//                 {avaria=1;adc_value2=reg[0,A_07]*(1+reg[0,A_09]/100);}
//         else avaria=0;

        //-------------------------------------------------------------------//


        //-------------------------------------------------------------------//
        //������� 1,2
        //-------------------------------------------------------------------//
        if ((alarm1==1)&&(alarm_alarm1==1)){
        switch(key_enter_press){
        case 1:
                if (adc_value2>gis_val1){//if (adc_value2>(reg[0,Y_01]*(1+reg[0,A_01]/100))) {
                         alarm1=1;
                        gis_val1=(reg[0,Y_01])*(1-reg[0,A_01]/100);}
                else
                        {
                         alarm1=0;flag_start_pause1=0;
                        if ((reg[0,P___]==0)||(reg[0,P___]==1)&&(reg[0,A_14]==0))alarm_alarm1=0;
                        gis_val1=(reg[0,Y_01]);
                        }
                        key_enter_press=0;
                break;
        default:      break;}}
        else   {
                        if (adc_value2>gis_val1){//if (adc_value2>(reg[0,Y_01]*(1+reg[0,A_01]/100))) {
                         alarm1=1;
                        gis_val1=(reg[0,Y_01])*(1-reg[0,A_01]/100);}
                        else
                        {
                         alarm1=0;flag_start_pause1=0;
                        if ((reg[0,P___]==0)||(reg[0,P___]==1)&&(reg[0,A_14]==0))alarm_alarm1=0;
                        gis_val1=(reg[0,Y_01]);
                        }
                       // key_enter_press_switch1=0;
                }
        if ((alarm2==1)&&(alarm_alarm2==1)){
        switch(key_enter_press){
        case 1:
                        if (adc_value2>gis_val2)//if (adc_value2>(reg[0,Y_02]*(1+reg[0,A_01]/100)))
                                {alarm2=1;
                                gis_val2=(reg[0,Y_02])*(1-reg[0,A_01]/100);}
                        else
                                {
                                alarm2=0;flag_start_pause2=0;
                                if ((reg[0,P___]==0)||(reg[0,P___]==1)&&(reg[0,A_15]==0))alarm_alarm2=0;
                                gis_val2=(reg[0,Y_02]);
                                }
                       key_enter_press=0;
                break;
        default: break;}}
        else {
                if (adc_value2>gis_val2)//if (adc_value2>(reg[0,Y_02]*(1+reg[0,A_01]/100)))
                   {alarm2=1;
                   gis_val2=(reg[0,Y_02])*(1-reg[0,A_01]/100);}
                else
                   {
                   alarm2=0;flag_start_pause2=0;
                   if ((reg[0,P___]==0)||(reg[0,P___]==1)&&(reg[0,A_15]==0))alarm_alarm2=0;
                   gis_val2=(reg[0,Y_02]);
                   }
               // key_enter_press_switch1=0;
              }
        //-------------------------------------------------------------------//
        //
        //�������� ����� � ����������
        //
        //-------------------------------------------------------------------//



        //-------------------------------------------------------------------//

        //-------------------------------------------------------------------//
        //����� 1,2
        //-------------------------------------------------------------------//
        if (alarm_alarm1==1){relay_alarm1=1;}
        else relay_alarm1=0;
        if (alarm_alarm2==1){relay_alarm2=1;}
        else relay_alarm2=0;

        if ((flag_start_pause1==1))//&&(alarm_alarm1==0))
                {
                if ((sys_time-time_pause1)>(reg[0,Z_01]*800)){alarm_alarm1=1;}
                }
        else if (alarm1==1)
                {
                if ( ( (reg[0,C___]==1) && (reg[0,A_02]==1) ) ){signal=1;buzer_buzer_en=1;}
                if ( (reg[0,P___]==0) || ( (reg[0,P___]==1) && (reg[0,A_03]==1) ) )
                        {
                        time_pause1=sys_time;
                        flag_start_pause1=1;
                        }
                }
        if ((alarm1==0)&&(alarm2==0))
                {
                if (((alarm_alarm1==0)||((alarm_alarm1==1)&&(reg[0,A_14]==0)))&&((alarm_alarm2==0)||((alarm_alarm2==1)&&(reg[0,A_15]==0)))){signal=0;buzer_buzer_en=0;}
                if ((blok1==0)&&(blok2==0)){signal=0;buzer_buzer_en=0;}
                }
        if (reg[0,C___]==0)buzer_buzer_en=0;
        if ((flag_start_pause2==1))//&&(alarm_alarm2==0))
                {
                if ((sys_time-time_pause2)>(reg[0,Z_02]*800))alarm_alarm2=1;
                }
        else if (alarm2==1)
                {
                if (((reg[0,C___]==1)&&(reg[0,A_02]==2))){signal=1;buzer_buzer_en=1;}
                if ((reg[0,P___]==0)||((reg[0,P___]==1)&&(reg[0,A_04]==1)))
                        {
                        time_pause2=sys_time;
                        flag_start_pause2=1;
                        }
                }
        //-------------------------------------------------------------------//












        //-------------------------------------------------------------------//
        //      ����
        //-------------------------------------------------------------------//
        //������� �� ����
        //-------------------------------------------------------------------//
        if (((sys_time-start_time_mode)>reg[0,A_13]*1000)){mode=0;f_m1=0;}
        //-------------------------------------------------------------------//



        if ((key_enter_press_switch==1)&&(mode==0)){key_enter_press_switch=0;key_enter_press_switch1=1;}


        //-------------------------------------------------------------------//
        //���� � ���������� ����
        //-------------------------------------------------------------------//
        if ((key_enter_press_switch1==1)&&(key_enter==1)&&(key_mode==0))
                {if ((sys_time-whait_time)>1500){mode=10;start_time_mode=sys_time;key_enter_press_switch1=0;}}
        //-------------------------------------------------------------------//

        //-------------------------------------------------------------------//
        //�������� ���������� �������
        //-------------------------------------------------------------------//
        if ((key_enter_press_switch1==1)&&(key_enter==1)&&(key_mode==1)&&(key_2==1)&&(key_3==1))
                {if ((sys_time-whait_time)>1500) {goto power_off;}}
        //-------------------------------------------------------------------//

        //-------------------------------------------------------------------//
        //��� ���������� � mode=0
        //-------------------------------------------------------------------//
        if (mode==0)
                {
                count_register=1;
                point=work_point;
                if (((alarm_alarm1==0)||((alarm_alarm1==1)&&(reg[0,A_14]==0)))&&((alarm_alarm2==0)||((alarm_alarm2==1)&&(reg[0,A_15]==0))))
                        {
                        if (reg[0,A_05]==0)adc_value3=adc_value1;
                        else if (reg[0,A_05]==2){adc_value3=buf[buf_end];point=1;}
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
        //���������������� ����
        //-------------------------------------------------------------------//
        if (mode==1)
                {
                hex2dec(count_register);
                ed=' ';
                switch (count_register)
                        {
                        case 2: tis='�';sot='_';des= 2 ;set_led_on(0,1,0,1,0,0,0,0);break;
                        case 3: tis= 3 ;sot='_';des= 1 ;set_led_on(0,0,1,1,0,0,0,0);break;
                        case 4: tis= 3 ;sot='_';des= 2 ;set_led_on(0,1,0,1,0,0,0,0);break;
                        case 5: tis='p';sot='_';des='_';set_led_on(0,0,0,1,0,0,0,0);break;
                        case 6: tis='c';sot='_';des='_';set_led_on(0,0,0,1,0,0,0,0);break;
                        default:tis='�';sot='_';des= 1 ;set_led_on(0,0,1,1,0,0,0,0);break;
                        }
                set_led_off(0,0,0,1,0,0,0,0);
                }
        //-------------------------------------------------------------------//

        //-------------------------------------------------------------------//
        //������ ����������������� ����
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
        //���������� ����
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
        //����������
        //-------------------------------------------------------------------//
        if ((mode==11)&&(count_register==A_16))
                {
                point=work_point;
                k_k=data_register;
                if (reg[0,A_05]==0)adc_value3=adc_value1;
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
        //������ ����������� ����
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
               if (count_register==A_19){tis=1,sot=1;des=0;ed=9;point=3;}//������� ���� � �����
                if (count_register==A_16)
                        {
                        if      (data_register==0){tis=4,sot='-';des=2;ed=0;point=1;}
                        else if (data_register==1){tis=0,sot='-';des=0;ed=5;point=1;}
                        else if (data_register==2){tis=0,sot='-';des=2;ed=0;point=1;}
                        else if (data_register==3){tis=0,sot='-';des=1;ed=0;point=1;}
                        else                      {tis=0,sot='-';des=0;ed=5;point=3;}
                        }
                if (point==1)       {set_led_on(0,0,0,0,0,0,0,0);set_led_off(0,0,0,0,0,0,0,0);}
                else if (point==2)  {set_led_on(0,0,0,0,0,0,1,0);set_led_off(0,0,0,0,0,0,1,0);}
                else if (point==3)  {set_led_on(0,0,0,0,0,1,0,0);set_led_off(0,0,0,0,0,1,0,0);}
                else if (point==4)  {set_led_on(0,0,0,0,1,0,0,0);set_led_off(0,0,0,0,1,0,0,0);}
                if (count_register==A_18)
                        {
                        tis=1,sot=0;des=0;ed=0;point=1;
                        set_led_on(0,0,0,0,1,1,0,0);set_led_off(0,0,0,0,1,1,0,0);
                        }
                }
        //-------------------------------------------------------------------//

        diap_val1 = reg[0,A_12];/*� ���� ������� ���� ������������� ��������������� ��������*/
        if(diap_val1!=diap_val2){
        diap_val2=diap_val1;
        switch (diap_val1){
                case 0:reg[0,A_06]=4; reg[0,A_07]=20;point=3;break;
                case 1:reg[0,A_06]=0; reg[0,A_07]=5;point=4;break;
                case 2:reg[0,A_06]=0; reg[0,A_07]=20;point=3;break;
                case 3:reg[0,A_06]=0; reg[0,A_07]=10;point=3;break;
                default:reg[0,A_06]=0; reg[0,A_07]=5;point=4;break;}
                ee_point=point;work_point=point;  }        //����� ������������� ����������� ���������� ���� � ����������� �� ������ ������ (��� 0-10 - 3 ����� ����� �������, ��� 0-20 - 2 ����� ����� �������)
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
                        if (data_register>reg[2,count_register])data_register=reg[2,count_register];
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
                        if (data_register<reg[3,count_register])data_register=reg[3,count_register];
                        if (count_key==0)count_key=60;if (count_key==21)count_key=20;
                        }
                rekey();
                }
        else if ((mode!=100)&&(key_enter_press==0)&&(key_plus_press==0)){count_key=0;count_key1=0;count_key2=0;}

        if ((key_enter_press_switch==1)&&(key_enter==1)&&(key_plus_press==0)&&(key_mines_press==0)&&(key_mode_press==0)&&(mode!=0)&&(mode!=10)&&(mode!=1))
                {
                reg[0,count_register]=data_register;
                start_time_mode=sys_time;
                if (count_register==A_07){ee_point=point;work_point=point;}
                if (count_register==A_17)
                        {
                        for (i=0;i<22;i++)reg[0,i]=reg[1,i];
                        }
                set_digit_on(' ',3,'a','�');
                set_digit_off(' ',3,'a','�');
                set_led_on(0,0,0,1,0,0,0,0);
                set_led_off(0,0,0,1,0,0,0,0);
                for (i=0;i<100;i++)
                        {
                        delay_ms(10);
                        check_rx();
                        delay_ms(10);
                        check_rx();
                        }
                key_enter_press_switch=0;
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
                        case 1: mode=2;data_register=reg[0,count_register];break;
                        case 2: mode=1;break;
                        case 10:mode=11;data_register=reg[0,count_register];break;
                        case 11:mode=10;break;
                        case 100:mode=100;break;
                        }
                }

        if (((sys_time-start_time)>250))
                {
                set_digit_on(tis,sot,des,ed);
                if ((mode==0)||(key_plus_press==1)||(key_mines_press==1)) set_digit_off(tis,sot,des,ed);
                else set_digit_off(' ',' ',' ',' ');
                start_time=sys_time;
                }
        check_rx();
        };
}         //main ����������.
void check_rx()
        {
	if (rx_c==1)			//
		{			//
		check_add_cr();
//  	        mov_buf(error);
//  	        mov_buf(rx_buffer[rx_wr_index-1]);
//  	        mov_buf(crc>>8);
//  	        mov_buf(rx_buffer[rx_wr_index-2]);
//                  mov_buf(crc&0x00FF);
//                  crc_end();                      //
		crc=0xffff;
		if (error==0)
		        {
//               		switch (rx_buffer[1])
//                                {
//                		case 0x1:
                        if (rx_buffer[1]==1)
                		        {
        	        	        if (rx_counter==8)
        		                        {
                		                if ((rx_buffer[3]+rx_buffer[5])<5) response_m_aa1();
                                                else  response_m_err(2);
                                                }
        	                        else response_m_err(3);
//                	          	break;
                		        }
//                		case 0x48:
                        else if (rx_buffer[1]==0x48)
                		        {
        	        	        if (rx_counter==8)
        		                        {
                		                if (rx_buffer[2]<3) response_m_aa48();
                                                else  response_m_err(2);
                                                }
        	                        else response_m_err(3);
//                	          	break;
                		        }
//       		                case 0x46:
                        else if (rx_buffer[1]==0x46)
         		                {
                                        if (rx_counter==10)
                                                {
                                                if (rx_buffer[2]<3) response_m_aa46();
                                                else response_m_err(2);
                                                }
                 	          	else response_m_err(3);
//                                        rx_c=0;rx_m=0;rx_counter=0;
//        		                crc=0xffff;
//                                        rx_wr_index=0;
//         	                  	break;
         		                }
//                		default:response_m_err(1);
                        else response_m_err(1);
//                		}
        	        }
                rx_c=0;rx_m=0;rx_counter=0;
		crc=0xffff;
                rx_wr_index=0;
       		}
	}
//--------------------------------------//
float find_reg(unsigned int a)
        {
        float d;
        if      (a==0x0000)              d=adc_value1;
        else if (a==0x0001)              d=adc_value2;
        else if (a==0x0002)              d=buf[buf_end];
        else if (a==0x0003)
                {
                if (avaria==0) d=1;
                else d=0;
                if (alarm2==1) d=d+2;
                else d=d;
                if (alarm1==1) d=d+4;
                else d=d;
                if (avaria==1) d=d+8;
                else d=d;
                }


        else if (a==0x0100)              d=reg[0,Y_01];
        else if (a==0x0101)              d=reg[0,Y_02];
        else if (a==0x0102)              d=reg[0,Z_01];
        else if (a==0x0103)              d=reg[0,Z_02];
        else if (a==0x0104)              d=reg[0,P___];
        else if (a==0x0105)              d=reg[0,C___];

        else if (a==0x0200)              d=reg[0,A_01];
        else if (a==0x0201)              d=reg[0,A_02];
        else if (a==0x0202)              d=reg[0,A_03];
        else if (a==0x0203)              d=reg[0,A_04];
        else if (a==0x0204)              d=reg[0,A_05];
        else if (a==0x0205)              d=reg[0,A_06];
        else if (a==0x0206)              d=reg[0,A_07];
        else if (a==0x0207)              d=reg[0,A_08];
        else if (a==0x0208)              d=reg[0,A_09];
        else if (a==0x0209)              d=reg[0,A_10];
        else if (a==0x020A)              d=reg[0,A_11];
        else if (a==0x020B)              d=reg[0,A_12];
        else if (a==0x020C)              d=reg[0,A_13];
        else if (a==0x020D)              d=reg[0,A_14];
        else if (a==0x020E)              d=reg[0,A_15];
        else if (a==0x020F)              d=reg[0,A_16];
        else if (a==0x0210)              d=reg[0,A_17];
        else if (a==0x0211)              d=reg[0,A_18];
        else if (a==0x0212)              d=reg[0,A_19];
        else if (a==0x0213)              d=reg[0,adres];
        else                             d=0;
        return d;
        }
void find_save_reg(unsigned int a,float b)
        {
        if (a==0x0100)                   reg[0,Y_01]=b;
        else if (a==0x0101)              reg[0,Y_02]=b;
        else if (a==0x0102)              reg[0,Z_01]=b;
        else if (a==0x0103)              reg[0,Z_02]=b;
        else if (a==0x0104)              reg[0,P___]=b;
        else if (a==0x0105)              reg[0,C___]=b;

        else if (a==0x0200)              reg[0,A_01]=b;
        else if (a==0x0201)              reg[0,A_02]=b;
        else if (a==0x0202)              reg[0,A_03]=b;
        else if (a==0x0203)              reg[0,A_04]=b;
        else if (a==0x0204)              reg[0,A_05]=b;
        else if (a==0x0205)              reg[0,A_06]=b;
        else if (a==0x0206)              reg[0,A_07]=b;
        else if (a==0x0207)              reg[0,A_08]=b;
        else if (a==0x0208)              reg[0,A_09]=b;
        else if (a==0x0209)              reg[0,A_10]=b;
        else if (a==0x020A)              reg[0,A_11]=b;
        else if (a==0x020B)              reg[0,A_12]=b;
        else if (a==0x020C)              reg[0,A_13]=b;
        else if (a==0x020D)              reg[0,A_14]=b;
        else if (a==0x020E)              reg[0,A_15]=b;
        else if (a==0x020F)              reg[0,A_16]=b;
        else if (a==0x0210)              reg[0,A_17]=b;
        else if (a==0x0211)              reg[0,A_18]=b;
        else if (a==0x0212)              reg[0,A_19]=b;
        else if (a==0x0213)              reg[0,adres]=b;
        }
//--------------------------------------//
void response_m_aa1()                   //
	{mov_buf_mod(rx_buffer[0]);     //
	mov_buf_mod(rx_buffer[1]);      //
	mov_buf_mod(1);                 //
        while (rx_buffer[5]>0)          //
                {if (rx_buffer[3]==0)   //
                        {if (avaria==1) i=1;
                        else i=0;}      //
                if (rx_buffer[3]==1)    //
                        {if (alarm1==0) i=i+2;
        	        else i=i;}      //
                if (rx_buffer[3]==2)    //
                        {if (alarm2==0) i=i+4;
                        else i=i;}      //
                if (rx_buffer[3]==3)    //
                        {if (avaria==0) i=i+4;
                        else i=i;}      //
               	rx_buffer[5]--;         //
               	rx_buffer[3]++;}        //
        mov_buf_mod(i);crc_end();}      //
//--------------------------------------//
void response_m_aa46()                  //
	{float temp;                    //
        int adr;                        //
        *((unsigned char *)(&temp)+0)=rx_buffer[4];
        *((unsigned char *)(&temp)+1)=rx_buffer[5];
        *((unsigned char *)(&temp)+2)=rx_buffer[6];
        *((unsigned char *)(&temp)+3)=rx_buffer[7];

       	adr=rx_buffer[2];               //
       	adr=adr<<8;                     //
       	adr=adr+rx_buffer[3];           //
        find_save_reg(adr,temp);        //
	mov_buf_mod(rx_buffer[0]);      //
	mov_buf_mod(rx_buffer[1]);      //
	mov_buf_mod(rx_buffer[2]);      //
	mov_buf_mod(rx_buffer[3]);      //
	mov_buf_mod(rx_buffer[4]);      //
	mov_buf_mod(rx_buffer[5]);      //
	mov_buf_mod(rx_buffer[6]);      //
	mov_buf_mod(rx_buffer[7]);      //
        crc_end();}                     //
//--------------------------------------//
void response_m_aa48()                  //
	{char a,i;                      //
        float temp;                     //
        int adr;                        //
        i=rx_buffer[5]*2;               //
        a=0;                            //
       	mov_buf_mod(rx_buffer[0]);      //
        mov_buf_mod(rx_buffer[1]);      //
       	mov_buf_mod(rx_buffer[5]*4);    //
       	adr=rx_buffer[2];               //
       	adr=adr<<8;                     //
       	adr=adr+rx_buffer[3];           //
        temp=find_reg(adr);             //
        while (i>0)                     //
       	        {mov_buf_mod(*((unsigned char *)(&temp)+0+a));
                mov_buf_mod(*((unsigned char *)(&temp)+1+a));
       	        i--;a++;a++;}           //
	crc_end();}                     //
//--------------------------------------//
void response_m_err(char a)             //
        {mov_buf_mod(rx_buffer[0]);     //
	mov_buf_mod(rx_buffer[1]|128);  //
	mov_buf_mod(a);                 //
        crc_end();}                     //
//--------------------------------------//
void check_add_cr()                     //
	{char i;                        //
	error=0;crc=0xFFFF;             //
	i=(unsigned char)reg[0,adres];  //
	if (rx_buffer[0]!=i) error=5;   //
	i=0;                            //
	while (i<(rx_wr_index-2)){crc_rtu(rx_buffer[i]);i++;}
	i=crc>>8;                       //
	if ((rx_buffer[rx_wr_index-1])!=i) error=2;
	i=crc;                          //
	if ((rx_buffer[rx_wr_index-2])!=i) error=3;
	}                               //
//--------------------------------------//
void mov_buf_mod(char a){crc_rtu(a);mov_buf(a);}
//--------------------------------------//
void mov_buf(char a)                    //
        {#asm("cli");                   //
        tx_buffer[tx_buffer_end]=a;     //
        if (++tx_buffer_end==TX_BUFFER_SIZE) tx_buffer_end=0;
        #asm("sei");}                   //
//--------------------------------------//
void crc_end()                          //
        {mov_buf(crc);mov_buf(crc>>8);rx_tx=1;
        UDR=tx_buffer[tx_buffer_begin]; //
        ti_en=1;crc=0xffff;}		//
//--------------------------------------//
void crc_rtu(char a)			//
	{char n;                         //
	crc = a^crc;			//
	for(n=0; n<8; n++)		//
		{if(crc & 0x0001 == 1)  //
		        {crc = crc>>1;	//
			crc=crc&0x7fff;	//
			crc = crc^0xA001;}
		else    {crc = crc>>1;	//
			crc=crc&0x7fff;}}}
//--------------------------------------//
//adc_value1- mA    reg 0
//adc_value2- mm    reg 1
//buf[buf_end]- ADC reg 2

//1-�������
//2-�����
//3-������

//0 4-20mA  20=4.4   =3606 k=20/3606 AIN0
//1  0-5mA   5=4.4   =3606 k= 5/3606 AIN1
//2 0-20mA  20=4.4   =3606 k=20/3606 AIN0
//3  0-10V  10=4.506 =3606 k=10/3691 AIN1
//4   0-5V   5=4.506 =3606 k= 5/3691 AIN0


// ���������� ������� �����
