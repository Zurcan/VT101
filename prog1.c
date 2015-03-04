/*****************************************************
Project : ТКБ ВИБРО-Т 
Version : 3.0.00
Date    : 02.07.2008
Author  : Метелкин Евгений          
Comments: V1.24.5 Standard

Program type        : Application
Clock frequency     : 8,000000 MHz
*****************************************************/
#include <define.h>
//#define cc
//#define ca
//--------------------------------------//
//	USART Receiver buffer
//--------------------------------------//

#define RX_BUFFER_SIZE 64

char rx_buffer[RX_BUFFER_SIZE];
unsigned char CRCLow = 0xff,rx_counter,mod_time,mod_time_s,rx_wr_index,CRCHigh=0xff;
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
        {//прерывание для бузера
        TCNT0=TCNT0_reload;
        #asm("wdr");
        if ((buzer_en==1)&&(buzer_buzer_en==1)){if (buzer==1) {buzerp=1;buzer=0;}else {buzerp=0;buzer=1;}}
        else if (pik_en==1){if (++pik_count>200) {pik_en=0;pik_count=0;}if (buzer==1) {buzerp=1;buzer=0;}else {buzerp=0;buzer=1;}}
        else buzerp=0;
        if (pik_en==1){if (++pik_count>200) {pik_en=0;pik_count=0;}}
        }
char led_byte[5][2];
interrupt [TIM0_COMP] void timer0_comp_isr(void){}
interrupt [TIM1_OVF] void timer1_ovf_isr(void){TCNT1H=0x05;TCNT1L=0x01;}
interrupt [TIM1_CAPT] void timer1_capt_isr(void){}
interrupt [TIM1_COMPA] void timer1_compa_isr(void){}
interrupt [TIM1_COMPB] void timer1_compb_isr(void){}
//-------------------------------------------------------------------//
// прерывание каждые 500 мкс
//-------------------------------------------------------------------//
long sys_time,whait_time;
bit key_mode,key_plus,key_mines,key_enter,key_mode_press,key_plus_press,key_mines_press,key_enter_press,key_mode_press_switch;
bit key_plus_press_switch,key_minus_press_switch,key_enter_press_switch;
char count_led,count_led1,drebezg;
bit avaria,alarm1,alarm2,alarm_alarm1,alarm_alarm2;
int count_blink,crc;
//-------------------------------------------------------------------//
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
        {//прерывание 500мкс
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
                 case 4: count_led=0;anode1=1;DDRC.3=1;katode=led_byte[0][n];break;
                 case 3: count_led=4;anode2=1;DDRC.4=1;katode=led_byte[1][n];break;
                 case 2: count_led=3;anode3=1;DDRC.5=1;katode=led_byte[2][n];break;
                 case 1: count_led=2;anode4=1;DDRC.6=1;katode=led_byte[3][n];break;
                 default:count_led=1;anode5=1;DDRC.7=1;katode=led_byte[4][n];break;
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

eeprom float reg[4][27]=
 {{0, 4.6, 7.1,   0,   5,   0,   1,   0,   1,   0,   0,   0,0.00,20.0,   2,   2,   0,  10,   2,   5,   0,   0,   1,   0,1.00, 2.15,    1},
  {0, 4.6, 7.1,   0,   5,   0,   1,   0,   1,   0,   0,   0,0.00,20.0,   2,   2,   0,  10,   2,   5,   0,   0,   1,   0,1.00, 2.15,    1},
  {0,999,999,  30,  30,   1,   1,  10,   2,   1,   1,   2,999,999,  10,  10,   5,  30,   4,  10,   1,   1, 1.8,   1,1.00,12.99,  247},
  {0,-999,-999,   0,   0,   0,   0,   0,   1,   0,   0,   0,-999,-999,   0,   0,   0,   0,   0,   1,   0,   0, 0.2,   0,1.00,1.00,    0}};
  //|уст1 |уст2 |зад1|зад2|маск|звук  |гист|звук |рел1 |рел2 |едиз | нпи | впи  |дсну|дсву  |врус |вбпв|диап |ввим |зал1 |зал2 | кал |заву  |верс|дата|адрес|
  // Y_01,Y_02,Z_01,Z_02,P___,C___,A_01,A_02,A_03,A_04,A_05,A_06,A_07,A_08,A_09,A_10,A_11,A_12,A_13,A_14,A_15,A_16,A_17,A_18,A_19,Adres;

eeprom char ee_point=3;
eeprom int crceep = 0x0000;  //   расчётное crc     5я строка до 1ff, 2 байта начиная со 2го байта в строке (после  1001B000)
eeprom const int crcstatic = 0x70bb;//0x45cb;  
eeprom char crc1digit = 3, crc2digit = 'c', crc3digit =2 , crc4digit = 1;    
//eeprom char smth[9];

//eeprom const
char mode,point,work_point,save_point;
#include <function_led.h>
        
char ed,des,sot,tis,count_filter,count_filter1,i,count_key,count_key1;
long filter_value;
unsigned int adc_buf;
flash  int crctable[256]= {
        0x0000, 0xC1C0, 0x81C1, 0x4001, 0x01C3, 0xC003, 0x8002, 0x41C2, 0x01C6, 0xC006,
        0x8007, 0x41C7, 0x0005, 0xC1C5, 0x81C4, 0x4004, 0x01CC, 0xC00C, 0x800D, 0x41CD,
        0x000F, 0xC1CF, 0x81CE, 0x400E, 0x000A, 0xC1CA, 0x81CB, 0x400B, 0x01C9, 0xC009,
        0x8008, 0x41C8, 0x01D8, 0xC018, 0x8019, 0x41D9, 0x001B, 0xC1DB, 0x81DA, 0x401A,
        0x001E, 0xC1DE, 0x81DF, 0x401F, 0x01DD, 0xC01D, 0x801C, 0x41DC, 0x0014, 0xC1D4,
        0x81D5, 0x4015, 0x01D7, 0xC017, 0x8016, 0x41D6, 0x01D2, 0xC012, 0x8013, 0x41D3,
        0x0011, 0xC1D1, 0x81D0, 0x4010, 0x01F0, 0xC030, 0x8031, 0x41F1, 0x0033, 0xC1F3,
        0x81F2, 0x4032, 0x0036, 0xC1F6, 0x81F7, 0x4037, 0x01F5, 0xC035, 0x8034, 0x41F4,
        0x003C, 0xC1FC, 0x81FD, 0x403D, 0x01FF, 0xC03F, 0x803E, 0x41FE, 0x01FA, 0xC03A, 
        0x803B, 0x41FB, 0x0039, 0xC1F9, 0x81F8, 0x4038, 0x0028, 0xC1E8, 0x81E9, 0x4029,
        0x01EB, 0xC02B, 0x802A, 0x41EA, 0x01EE, 0xC02E, 0x802F, 0x41EF, 0x002D, 0xC1ED,
        0x81EC, 0x402C, 0x01E4, 0xC024, 0x8025, 0x41E5, 0x0027, 0xC1E7, 0x81E6, 0x4026,
        0x0022, 0xC1E2, 0x81E3, 0x4023, 0x01E1, 0xC021, 0x8020, 0x41E0, 0x01A0, 0xC060, 
        0x8061, 0x41A1, 0x0063, 0xC1A3, 0x81A2, 0x4062, 0x0066, 0xC1A6, 0x81A7, 0x4067,
        0x01A5, 0xC065, 0x8064, 0x41A4, 0x006C, 0xC1AC, 0x81AD, 0x406D, 0x01AF, 0xC06F,
        0x806E, 0x41AE, 0x01AA, 0xC06A, 0x806B, 0x41AB, 0x0069, 0xC1A9, 0x81A8, 0x4068, 
        0x0078, 0xC1B8, 0x81B9, 0x4079, 0x01BB, 0xC07B, 0x807A, 0x41BA, 0x01BE, 0xC07E,
        0x807F, 0x41BF, 0x007D, 0xC1BD, 0x81BC, 0x407C, 0x01B4, 0xC074, 0x8075, 0x41B5, 
        0x0077, 0xC1B7, 0x81B6, 0x4076, 0x0072, 0xC1B2, 0x81B3, 0x4073, 0x01B1, 0xC071,
        0x8070, 0x41B0, 0x0050, 0xC190, 0x8191, 0x4051, 0x0193, 0xC053, 0x8052, 0x4192, 
        0x0196, 0xC056, 0x8057, 0x4197, 0x0055, 0xC195, 0x8194, 0x4054, 0x019C, 0xC05C,
	0x805D, 0x419D, 0x005F, 0xC19F, 0x819E, 0x405E, 0x005A, 0xC19A, 0x819B, 0x405B, 
	0x0199, 0xC059, 0x8058, 0x4198, 0x0188, 0xC048, 0x8049, 0x4189, 0x004B, 0xC18B,
	0x818A, 0x404A, 0x004E, 0xC18E, 0x818F, 0x404F, 0x018D, 0xC04D, 0x804C, 0x418C,
	0x0044, 0xC184, 0x8185, 0x4045, 0x0187, 0xC047, 0x8046, 0x4186, 0x0182, 0xC042,
	0x8043, 0x4183, 0x0041, 0xC181, 0x8180, 0x4040
};    

void  CRC_update(unsigned char d)
{
  //unsigned char uindex;
  //uindex = CRCHigh^d;
  //CRCHigh=CRCLow^((int)crctable[uindex]>>8);
  //CRCLow=crctable[uindex];
  //crc = CRCHigh;
  //crc = ((int)crc)<<8+CRCLow;     
  crc = crctable[((crc>>8)^d)&0xFF] ^ (crc<<8);
}              
void hex2dec(float x)		// подпрограмма преобразования кода в ASCII
 	{				//
 	char str[9],str1[9];
 	signed char a,b;
    char counter=0;
 	if (x<-999) x=-999;
 	if (x>999) x=999;
 	ftoa(x,5,str1);   
//    for(a=0; a < 5; a++)
//    {   
//    
//        if(str1[a]==0x2e)
//        {
//           // point = a;
//        }
//        else
//        {       
//            if(counter==0)
//            {
//                if(x<0) 
//                   tis='-';
//                else
//                    tis = str1[a]-0x30;
//            }
//            else if(counter==1)
//            {
//                sot =  str1[a]-0x30;
//            }         
//            else if(counter==2)
//            {
//                des =  str1[a]-0x30;
//            }           
//            else if(counter==3)
//            {
//                ed =  str1[a]-0x30;
//            }           
//            counter++;
//        }
//            
//    }
 	for (a=0;a<9;a++)
    {
        if (str1[a]=='.') 
            goto p1;
    }
p1:
        b=4;
        while ((a>=0)&&(b>=0))
        {
            str[b]=str1[a];
            a--;
            b--;
        }
        a=3-b;
        while (b>=0) 
        {
            str[b]='0';
            b--;
        }
        b=4;
        while ((a<9)&&(b<9))
        {
            str[b]=str1[a];
            a++;
            b++;
        }
        while (b<9)
         {
            str[b]='0';
            b++;
         }
 	if (point==1)
 	        {
                if (str[0]=='-') tis='-';
                else if (str[0]==0)
                    tis=0;
                else 
                    tis=str[0]-0x30;
                sot=str[1]-0x30;
                des=str[2]-0x30;
                ed=str[3]-0x30;
                if (tis==0)
                {
                    tis=' ';
                    if (sot==0)
                    {
                        sot=' ';
                        if(des==0) 
                            des=' ';
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
// чтение из АЦП
void find_save_reg(unsigned int a,float b);
float find_reg(unsigned int a);
void response_m_err(char a);                     //
//-------------------------------------------------------------------//
int read_adc()
        {
        int a;
        cs=0;
        SPCR=0b01010001;
        i=reg[0][A_12];
        switch (i)
                {
                case 0: SPDR=0b10110001;break;//4-20mA 20=4.4   =3606 k=20/3606 AIN0
                case 1: SPDR=0b10111001;break;//0-5mA   5=4.4   =3606 k= 5/3606 AIN1
                case 2: SPDR=0b10110001;break;//0-20mA 20=4.4   =3606 k=20/3606 AIN0
                case 3: SPDR=0b10111001;break;//0-10V  10=4.506 =3606 k=10/3691 AIN1
                default:SPDR=0b10110001;break;//0-5V    5=4.506 =3606 k= 5/3691 AIN0
                }
        while(SPSR.7==0);
        a=SPDR;
        SPDR=0;
        a=a<<8;
        while (SPSR.7 == 0);
        a = a + SPDR; 
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
        //измерение
        //-------------------------------------------------------------------//
        if (++buf_end>8) buf_end=0;
        buf[buf_end]=read_adc();
        min_r=9;
        //-------------------------------------------------------------------//
        //-------------------------------------------------------------------//
        //модальный фильтр *- нижепреведенный код не делает ничего, кроме выборки наименьшего значения из последних 9ти измерений*
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
                if (cabs(rang[j])<min_r) 
                        {
                        min_r=cabs(rang[j]);
                        min_n=j;
                        }
                }
        //-------------------------------------------------------------------//
        //ФНЧ *- есть некоторые сомнения, что это можно назвать фильтром низких частот, тупо усредняем значение измерения ацп в единицу времени усреднения*
        //-------------------------------------------------------------------//
        k_f=reg[0][A_10];
        if (k_f==0) k_f=0.001;
        k_f=0.001/k_f;
        adc_filter=k_f*buf[min_n]+(1-k_f)*adc_filter;
        //-------------------------------------------------------------------//
        return adc_filter;
        }
//-------------------------------------------------------------------//
char error;
//int crc;
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

//////////////////////////////////////////////////////////////////////
//
//      Считывание данных из Flash
//      The registers R0, R1, R22, R23, R24, R25, R26, R27, R30 and R31 can be freely used in assembly routines.
/////////////////////////////////////////////////////////////////////////////
int read_program_memory (int adr)
{
       #asm
       LPM R22,Z+;//     загрузка в регистр R23 содержимого флеш по адресу Z с постинкрементом (мл. байт)
       LPM R23,Z; //     загрузка в регистр R22 содержимого Flash  по адресу Z+1 (старший байт)
       MOV R30, R22;
       MOV R31, R23;
       #endasm
}    

void sys_init()
{
PORTA=0b11111111;DDRA=0b11111111;
PORTB=0b00000000;DDRB=0b10110011;
PORTC=0b11111011;DDRC=0b11111000;
PORTD=0b11000011;DDRD=0b00111110;
//UBRRH=0x00;UBRRL=0x5f;UCSRB=0xD8;UCSRC=0x86;



TCCR0=0x03;TCNT0=TCNT0_reload;OCR0=0x00;

ASSR=0x00;TCCR2=0x04;TCNT2=TCNT2_reload;OCR2=0x00;
//ASSR=0x00;TCCR2=0x07;TCNT2=TCNT2_reload;OCR2=0x00;
MCUCR=0x00;MCUCSR=0x00;TIMSK=0xFF;

//UBRRH=0x00;UBRRL=0x67;UCSRB=0xD8;UCSRC=0x86;
ACSR=0x80;SFIOR=0x00;SPCR=0x52;SPSR=0x00;WDTCR=0x1F;WDTCR=0x0F;
mod_time_s=60;
} 

void main(void)
{    
bit flag_start_pause1,flag_start_pause2,f_m1,key_enter_press_switch1;
float time_pause1,time_pause2/*,adc_value1*/;
float data_register,adc_filter/*,adc_value2*/;
float k_k,kk,bb,dop1,dop2;
float gis_val1=reg[0][Y_01];         //значение с учетом гистерезиса
float gis_val2=reg[0][Y_02];
char q1,q2,q3,q4,diap_val1=0,diap_val2=0,dataH,dataL,crcok_flag=0;//diap_val1,2 - это диапазон на 1м и на 2м шаге
float temp;
int  imin, imax, data, j = 0, j1=0;
unsigned char tmp[9];
crc = 0xffff;
//if(high==0)
//{ 
          // imin=0;
         //  imax=PAGESIZE*APP_PAGES; 
//}
//else       
//{ 
//   imin=PAGESIZE*APP_PAGES;
//   imax=PAGESIZE*PAGES;     
//}
//            for(i=imin; i<imax;  i+=2)
//            {
//               data= read_program_memory (i,0);
//               crc^=LOBYTE(data);
//               crc^=HIBYTE(data);
//            }
//                 
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

sys_init();
#asm("cli");


//goto a1;//test
//goto a2;//test

//-------------------------------------------------------------------//
//Ожидание включения питания 
//-------------------------------------------------------------------//

while ((data<=65534)|(j<=16382))
{
    data= read_program_memory (j);
    dataH = (int)data>>8;
    dataL = data;
    CRC_update(dataH);
    CRC_update(dataL);
    //crc_rtu(data);
    //j++;
    j=j+2;
}
crceep = crc;
i=0;
#asm("sei")
start_time=sys_time;count_register=1;
power = 1;

//ftoa(-100.989,5,tmp);
//for(j=0; j < 9; j++)
//    smth[j] = tmp[j];
for(j1=0;j1<2;j1++)
{
tis='v';sot=1;des= 0 ;ed=1;
set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
delay_ms(1500);

if(reg[0][24]>=1000)
{
      tis=1;sot=0;des= 0 ;ed=0;     
       set_digit_on(tis,sot,des,ed);  
      set_led_on(0,0,0,0,0,0,0,0); 
}
else
{
    tis  = (reg[0][24]*1000)/1000;
    sot  = ((int)(reg[0][24]*1000)%1000)/100;
    des  = ((int)(reg[0][24]*1000)%100)/10;
    ed  =(int) (reg[0][24]*1000)%10;  
    set_digit_on(tis,sot,des,ed);        
    set_led_on(0,0,0,0,1,0,0,0); 
}
delay_ms(1000);
//tis=1;sot=0;des= 0 ;ed=0;
set_digit_off(tis,sot,des,ed);
set_led_off(0,0,0,0,0,0,0,0);
//delay_ms(750);

//set_digit_off(tis,sot,des,ed);
tis='c';sot='r';des= 'c' ;ed=' ';
set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
delay_ms(1500);
tis=3;sot='c';des= 2 ;ed=1;
set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
delay_ms(1500);
tis=' ';sot=' ';des= ' ' ;ed = ' ';
set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
if(crceep == crcstatic) 
    {
    tis=0;
    sot='k';
    des=' ';
    ed = ' ';
    crcok_flag=1;
    }
else 
    {
    tis='f';sot='a';des= 'i' ;ed = 'l';
    crcok_flag = 0;
    }
set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
delay_ms(1500);

}
power_off:
sys_init();
start_time =0;
#asm ("cli")
power = 0;
if(crcok_flag==1)
{
while ((key_1==0)&&(key_2==0)&&(key_3==0)&&(key_4==0));
while (i<100)
        {
        if ((key_1==0)&&(key_4==0)&&(key_2==1)&&(key_3==1)) i++;
        else i=0;
        delay_ms(20);   
        }
//-------------------------------------------------------------------//      

power=1;
data_register=reg[0][A_07];
if (data_register<0)
        {
        if (data_register>=-1000)point=1;
        if (data_register>=-100)point=2;
        if (data_register>=-10)point=3;
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
//Показать основные настройки
//блокировка по включению
//-------------------------------------------------------------------//
start_time=sys_time;count_register=1;
set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
while ((sys_time-start_time)<reg[0][A_11]*1000) 
//while (1) 
        {
        ed=' ';
        switch (count_register)
                {
                case 2: tis='У';sot='_';des= 2 ;break;
                case 3: tis= 3 ;sot='_';des= 1 ;break;
                case 4: tis= 3 ;sot='_';des= 2 ;break;
                case 5: tis='p';sot='_';des='_';break;
                case 6: tis='c';sot='_';des='_';break;
                case 1: tis='У';sot='_';des= 1 ;break;
                default:tis='У';sot='_';des= 1 ;break;
                }
        set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
        set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
        delay_ms(500);

        data_register=reg[0][count_register];
//        if ((data_register>MAX_MIN[count_register,1])||(data_register<MAX_MIN[count_register,0])) data_register=FAKTORY[count_register];//проверка граничных значений

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
UBRRH=0x00;UBRRL=0x5f;UCSRB=0xD8;UCSRC=0x86;UCSRA=0x02;
crc=0xffff;
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
k_k=reg[0][A_16];

point=ee_point;
work_point=point;
ti_en=0;
//tmpVal=UBRRL;
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
        //абсолютная величина
        //-------------------------------------------------------------------//
        i=reg[0][A_12];
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
        //относительная величина
        //-------------------------------------------------------------------//
        i=reg[0][A_12];
        switch (i)
                {
                case 0: 
                    kk=(reg[0][A_07]-reg[0][A_06])/(20-4);
                    bb=reg[0][A_06]-kk*4;
                    dop1=4;
                    dop2=20;
                    break;//4-20mA
                case 1: 
                    kk=(reg[0][A_07]-reg[0][A_06])/( 5-0);
                    bb=reg[0][A_06]-kk*0;
                    dop1=0;
                    dop2= 5;
                    break;//0-5mA
                case 2: 
                    kk=(reg[0][A_07]-reg[0][A_06])/(20-0);
                    bb=reg[0][A_06]-kk*0;
                    dop1=0;
                    dop2=20;
                    break;//0-20mA
                case 3: 
                    kk=(reg[0][A_07]-reg[0][A_06])/(10-0);
                    bb=reg[0][A_06]-kk*0;
                    dop1=0;
                    dop2=10;
                    break;//0-10V
                default:
                    kk=(reg[0][A_07]-reg[0][A_06])/( 5-0);
                    bb=reg[0][A_06]-kk*0;
                    dop1=0;
                    dop2= 5;
                    break;//0-5V
                }
        adc_value2=adc_value1*kk+bb;
                
        //-------------------------------------------------------------------//
        //авария
        //-------------------------------------------------------------------//

        if (adc_value1<(dop1*(1-reg[0][A_08]/100)))//потестить с adc_value2
                {
                avaria=1;
                adc_value2=(dop1*(1-reg[0][A_08]/100))*kk+bb;
                }
        else if (adc_value2>(dop2*(1+reg[0][A_09]/100)))
                {
                avaria=1;
                adc_value2=(dop2*(1+reg[0][A_09]/100))*kk+bb;
                }
        else avaria=0;


//         if (adc_value2<(reg[0,A_06]*(1-reg[0,A_08]/100)))
//                 {avaria=1;adc_value2=reg[0,A_06]*(1-reg[0,A_08]/100);}
//         else if (adc_value2>(reg[0,A_07]*(1+reg[0,A_09]/100)))
//                 {avaria=1;adc_value2=reg[0,A_07]*(1+reg[0,A_09]/100);}
//         else avaria=0;

        //-------------------------------------------------------------------//


        //-------------------------------------------------------------------//
        //уставка 1,2
        //-------------------------------------------------------------------//
        if ((alarm1==1)&&(alarm_alarm1==1)){
        switch(key_enter_press){
        case 1:        
                if (adc_value2>gis_val1){//if (adc_value2>(reg[0,Y_01]*(1+reg[0,A_01]/100))) {
                         alarm1=1;
                        gis_val1=(reg[0][Y_01])*(1-reg[0][A_01]/100);} 
                else        
                        {
                         alarm1=0;flag_start_pause1=0;
                        if ((reg[0][P___]==0)||(reg[0][P___]==1)&&(reg[0][A_14]==0))alarm_alarm1=0;
                        gis_val1=(reg[0][Y_01]);
                        }  
                        key_enter_press=0;
                break;
        default:      break;}}        
        else   {
                        if (adc_value2>gis_val1){//if (adc_value2>(reg[0,Y_01]*(1+reg[0,A_01]/100))) {
                         alarm1=1;
                        gis_val1=(reg[0][Y_01])*(1-reg[0][A_01]/100);} 
                        else        
                        {
                         alarm1=0;flag_start_pause1=0;
                        if ((reg[0][P___]==0)||(reg[0][P___]==1)&&(reg[0][A_14]==0))alarm_alarm1=0;
                        gis_val1=(reg[0][Y_01]);
                        } 
                       // key_enter_press_switch1=0;
                }              
        if ((alarm2==1)&&(alarm_alarm2==1)){
        switch(key_enter_press){
        case 1:         
                        if (adc_value2>gis_val2)//if (adc_value2>(reg[0,Y_02]*(1+reg[0,A_01]/100))) 
                                {alarm2=1;
                                gis_val2=(reg[0][Y_02])*(1-reg[0][A_01]/100);}
                        else 
                                {
                                alarm2=0;flag_start_pause2=0;
                                if ((reg[0][P___]==0)||(reg[0][P___]==1)&&(reg[0][A_15]==0))alarm_alarm2=0; 
                                gis_val2=(reg[0][Y_02]);
                                }  
                       key_enter_press=0;
                break;
        default: break;}}
        else {
                if (adc_value2>gis_val2)//if (adc_value2>(reg[0,Y_02]*(1+reg[0,A_01]/100))) 
                   {alarm2=1;
                   gis_val2=(reg[0][Y_02])*(1-reg[0][A_01]/100);}
                else 
                   {
                   alarm2=0;flag_start_pause2=0;
                   if ((reg[0][P___]==0)||(reg[0][P___]==1)&&(reg[0][A_15]==0))alarm_alarm2=0; 
                   gis_val2=(reg[0][Y_02]);
                   }   
               // key_enter_press_switch1=0;   
              }
        //-------------------------------------------------------------------//
        //
        //добавить маску и блокировку
        //
        //-------------------------------------------------------------------//
        


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
                if ((sys_time-time_pause1)>(reg[0][Z_01]*800)){alarm_alarm1=1;}
                }
        else if (alarm1==1)
                {
                if ( ( (reg[0][C___]==1) && (reg[0][A_02]==1) ) ){signal=1;buzer_buzer_en=1;}
                if ( (reg[0][P___]==0) || ( (reg[0][P___]==1) && (reg[0][A_03]==1) ) )
                        {
                        time_pause1=sys_time;
                        flag_start_pause1=1;
                        }
                }
        if ((alarm1==0)&&(alarm2==0))
                {
                if (((alarm_alarm1==0)||((alarm_alarm1==1)&&(reg[0][A_14]==0)))&&((alarm_alarm2==0)||((alarm_alarm2==1)&&(reg[0][A_15]==0)))){signal=0;buzer_buzer_en=0;}
                if ((blok1==0)&&(blok2==0)){signal=0;buzer_buzer_en=0;}
                }
        if (reg[0][C___]==0)buzer_buzer_en=0;
        if ((flag_start_pause2==1))//&&(alarm_alarm2==0))
                {
                if ((sys_time-time_pause2)>(reg[0][Z_02]*800))alarm_alarm2=1;
                }
        else if (alarm2==1)
                {
                if (((reg[0][C___]==1)&&(reg[0][A_02]==2))){signal=1;buzer_buzer_en=1;}
                if ((reg[0][P___]==0)||((reg[0][P___]==1)&&(reg[0][A_04]==1)))
                        {
                        time_pause2=sys_time;
                        flag_start_pause2=1;
                        }
                }
        //-------------------------------------------------------------------//
        











        //-------------------------------------------------------------------//
        //      МЕНЮ
        //-------------------------------------------------------------------//
        //возврат из меню
        //-------------------------------------------------------------------//
        if (((sys_time-start_time_mode)>reg[0][A_13]*1000)){mode=0;f_m1=0;}
        //-------------------------------------------------------------------//



        if ((key_enter_press_switch==1)&&(mode==0)){key_enter_press_switch=0;key_enter_press_switch1=1;}


        //-------------------------------------------------------------------//
        //вход в инженерное меню
        //-------------------------------------------------------------------//
        if ((key_enter_press_switch1==1)&&(key_enter==1)&&(key_mode==0))
                {if ((sys_time-whait_time)>1500){mode=10;start_time_mode=sys_time;key_enter_press_switch1=0;}}
        //-------------------------------------------------------------------//

        //-------------------------------------------------------------------//
        //Ожидание выключения питания 
        //-------------------------------------------------------------------//
        if ((key_enter_press_switch1==1)&&(key_enter==1)&&(key_mode==1)&&(key_2==1)&&(key_3==1))
                {if ((sys_time-whait_time)>1500) {goto power_off;}}
        //-------------------------------------------------------------------//

        //-------------------------------------------------------------------//
        //что показывать в mode=0
        //-------------------------------------------------------------------//
        if (mode==0)
                {
                count_register=1;
                point=work_point;
                if (((alarm_alarm1==0)||((alarm_alarm1==1)&&(reg[0][A_14]==0)))&&((alarm_alarm2==0)||((alarm_alarm2==1)&&(reg[0][A_15]==0))))
                        {
                        if (reg[0][A_05]==0)adc_value3=adc_value1;
                        else if (reg[0][A_05]==2){adc_value3=buf[buf_end];point=1;}
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
                if (count_register<3)
                {
                         if ((data_register<0))
                                {
                                if (data_register>=-1000)
                                   point = 1;
                                 if (data_register>=-100)
                                    point=2;
                                if (data_register>=-10)
                                    point=3;
                                }
                        else
                                {
                                if (data_register<10)
                                    point=work_point;
                                else if (data_register<100)
                                    point=3;
                                else if (data_register<1000)
                                    point=2;
                                else if (data_register>=1000)
                                    point=1;
                                }
                }
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
                if (reg[0][A_05]==0)adc_value3=adc_value1;
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
                if (((count_register==A_06)|(count_register==A_07))|(count_register==A_18))//|(count_register==A_19))
                        {//point=work_point;
                        if ((data_register<0))
                                {
                                if (data_register>=-1000)
                                   point = 1;
                                 if (data_register>=-100)
                                    point=2;
                                if (data_register>=-10)
                                    point=3;
                                }
                        else
                                {
                                if (data_register<10)
                                    point=4;
                                else if (data_register<100)
                                    point=3;
                                else if (data_register<1000)
                                    point=2;
                                else if (data_register>=1000)
                                    point=1;
                                }
                        }     
                else if((count_register==A_08)|(count_register==A_09))
                {
                            point = 1;
                }
                else if (count_register==A_10)point=3;
                else point=1;
                hex2dec(data_register);
              // if (count_register==A_19){tis=1,sot=1;des=0;ed=9;point=3;}//вписать дату и время
                if (count_register==A_16)
                        {
                        if      (data_register==0){tis=4,sot='-';des=2;ed=0;point=1;}
                        else if (data_register==1){tis=0,sot='-';des=0;ed=5;point=1;}
                        else if (data_register==2){tis=0,sot='-';des=2;ed=0;point=1;}
                        else if (data_register==3){tis=0,sot='-';des=1;ed=0;point=1;}
                        else                      {tis=0,sot='-';des=0;ed=5;point=3;}
                        }  
                if(count_register==A_19)
                {
                     tis  = (reg[0][25]*100)/1000;
                     sot  = ((int)(reg[0][25]*100)%1000)/100;
                     des  = ((int)(reg[0][25]*100)%100)/10;
                     ed  =(int) (reg[0][25]*100)%10;  
                     point = 3;
                }             
//                if (count_register==A_18)
//                {
//                        tis=1;sot=1;des=0;ed=0;point=3;
//                        //set_led_on(0,0,0,0,1,1,0,0);set_led_off(0,0,0,0,1,1,0,0);
//                }
                if (point==1)       
                {
                    set_led_on(0,0,0,0,0,0,0,0);
                    set_led_off(0,0,0,0,0,0,0,0);
                }
                else if (point==2)
                {
                    set_led_on(0,0,0,0,0,0,1,0);
                    set_led_off(0,0,0,0,0,0,1,0);
                }
                else if (point==3)
                {
                    set_led_on(0,0,0,0,0,1,0,0);
                    set_led_off(0,0,0,0,0,1,0,0);
                }
                else if (point==4)  
                {
                    set_led_on(0,0,0,0,1,0,0,0);
                    set_led_off(0,0,0,0,1,0,0,0);
                }
  

                if(count_register==CRCCONST) {tis = crc1digit; sot = crc2digit; des =crc3digit; ed = crc4digit; point = 0;}
                if(count_register==SOFTID) {tis = 'v'; sot = 1; des = 0; ed = 1; point = 0;}        
                }
        //-------------------------------------------------------------------//
        
        diap_val1 = reg[0][A_12];/*в этом участке кода устанавливаем соответствующее значение*/
        if(diap_val1!=diap_val2)
        {
            diap_val2=diap_val1;
            switch (diap_val1)
            {
                case 0:reg[0][A_06]=4; reg[0][A_07]=20;point=3;break;
                case 1:reg[0][A_06]=0; reg[0][A_07]=5;point=4;break;
                case 2:reg[0][A_06]=0; reg[0][A_07]=20;point=3;break;
                case 3:reg[0][A_06]=0; reg[0][A_07]=10;point=3;break;
                default:reg[0][A_06]=0; reg[0][A_07]=5;point=4;break;
            }    
                ee_point=point;work_point=point;  
        }        //здесь устанавливаем необходимое количество цифр в зависимости от режима работы (для 0-10 - 3 цифры после запятой, для 0-20 - 2 цифры после запятой)
       
       
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
                        if (data_register>reg[2][count_register])data_register=reg[2][count_register];
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
                        if (data_register<reg[3][count_register])data_register=reg[3][count_register];
                        if (count_key==0)count_key=60;if (count_key==21)count_key=20;
                        }
                rekey();
                }
        else if ((mode!=100)&&(key_enter_press==0)&&(key_plus_press==0)){count_key=0;count_key1=0;count_key2=0;}
        
        if ((key_enter_press_switch==1)&&(key_enter==1)&&(key_plus_press==0)&&(key_mines_press==0)&&(key_mode_press==0)&&(mode!=0)&&(mode!=10)&&(mode!=1))
                {
                    if((count_register==A_18)|(count_register==A_19)|(count_register==CRCCONST)|(count_register==SOFTID)){;}
                    else
                    {
                    reg[0][count_register]=data_register;
                    
                    start_time_mode=sys_time;
                    if (count_register==A_07){ee_point=point;work_point=point;}
                    if (count_register==A_17)
                            {
                            for (i=0;i<22;i++)reg[0][i]=reg[1][i];
                            }
                    set_digit_on(' ',3,'a','п');
                    set_digit_off(' ',3,'a','п');
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
                }
        if ((key_mode_press_switch==1)&&(key_4==1))
                {
                key_mode_press_switch=0;f_m1=0;
                start_time_mode=sys_time;
                switch (mode)
                        {
                        case 0: mode=1;count_register=1;break;
                        case 1: mode=2;data_register=reg[0][count_register];break;
                        case 2: mode=1;break;
                        case 10:mode=11;data_register=reg[0][count_register];break;
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
        }
else while(1)
{delay_ms(1000);}

}         //main закончился.
void check_rx()
        {
	if (rx_c==1)			//
		{	
                //tmpVal++;		//
		check_add_cr();
//  	        mov_buf(error);
//  	        mov_buf(rx_buffer[rx_wr_index-1]);
//  	        mov_buf(crc>>8);
//  	        mov_buf(rx_buffer[rx_wr_index-2]);
//                  mov_buf(crc&0x00FF);
//                  crc_end();                      //
		crc=0xffff;
		if (error==0) 
		        { //tmpVal++;
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
                                       // tmpVal++;
        	        	        if (rx_counter==8)
        		                        { 
                		                if (rx_buffer[2]<3) response_m_aa48();
                                                else  response_m_err(2);
                                               // tmpVal++;
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
                

        else if (a==0x0100)              d=reg[0][Y_01];
        else if (a==0x0101)              d=reg[0][Y_02];
        else if (a==0x0102)              d=reg[0][Z_01];
        else if (a==0x0103)              d=reg[0][Z_02];
        else if (a==0x0104)              d=reg[0][P___];
        else if (a==0x0105)              d=reg[0][C___];

        else if (a==0x0200)              d=reg[0][A_01];
        else if (a==0x0201)              d=reg[0][A_02];
        else if (a==0x0202)              d=reg[0][A_03];
        else if (a==0x0203)              d=reg[0][A_04];
        else if (a==0x0204)              d=reg[0][A_05];
        else if (a==0x0205)              d=reg[0][A_06];
        else if (a==0x0206)              d=reg[0][A_07];
        else if (a==0x0207)              d=reg[0][A_08];
        else if (a==0x0208)              d=reg[0][A_09];
        else if (a==0x0209)              d=reg[0][A_10];
        else if (a==0x020A)              d=reg[0][A_11];
        else if (a==0x020B)              d=reg[0][A_12];
        else if (a==0x020C)              d=reg[0][A_13];
        else if (a==0x020D)              d=reg[0][A_14];
        else if (a==0x020E)              d=reg[0][A_15];
        else if (a==0x020F)              d=reg[0][A_16];
        else if (a==0x0210)              d=reg[0][A_17];
        else if (a==0x0211)              d=reg[0][A_18];
        else if (a==0x0212)              d=reg[0][A_19];
        else if (a==0x0213)              d=reg[0][adres];
       // else if (a == 0x0214)
        else                             d=0;
        return d;
        }
void find_save_reg(unsigned int a,float b)
        {
        if (a==0x0100)                   reg[0][Y_01]=b;
        else if (a==0x0101)              reg[0][Y_02]=b;
        else if (a==0x0102)              reg[0][Z_01]=b;
        else if (a==0x0103)              reg[0][Z_02]=b;
        else if (a==0x0104)              reg[0][P___]=b;
        else if (a==0x0105)              reg[0][C___]=b;

        else if (a==0x0200)              reg[0][A_01]=b;
        else if (a==0x0201)              reg[0][A_02]=b;
        else if (a==0x0202)              reg[0][A_03]=b;
        else if (a==0x0203)              reg[0][A_04]=b;
        else if (a==0x0204)              reg[0][A_05]=b;
        else if (a==0x0205)              reg[0][A_06]=b;
        else if (a==0x0206)              reg[0][A_07]=b;
        else if (a==0x0207)              reg[0][A_08]=b;
        else if (a==0x0208)              reg[0][A_09]=b;
        else if (a==0x0209)              reg[0][A_10]=b;
        else if (a==0x020A)              reg[0][A_11]=b;
        else if (a==0x020B)              reg[0][A_12]=b;
        else if (a==0x020C)              reg[0][A_13]=b;
        else if (a==0x020D)              reg[0][A_14]=b;
        else if (a==0x020E)              reg[0][A_15]=b;
        else if (a==0x020F)              reg[0][A_16]=b;
        else if (a==0x0210)              reg[0][A_17]=b;
        else if (a==0x0211)              reg[0][A_18]=b;
        else if (a==0x0212)              reg[0][A_19]=b;
        else if (a==0x0213)              reg[0][adres]=b;
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
	error=0;crc=0xFFFF;  
       	i=(unsigned char)reg[0][adres];  //
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
	{
        char n;                         //
	crc = a^crc;			//
	for(n=0; n<8; n++)		//
		{
                if(crc & 0x0001 == 1)  //
		        {
                        crc = crc>>1;	//
			crc=crc&0x7fff;	//
			crc = crc^0xA001;
                        }
		else    
                        {
                        crc = crc>>1;	//
			crc=crc&0x7fff;
                        }
                }
        }
//--------------------------------------//
//adc_value1- mA    reg 0
//adc_value2- mm    reg 1
//buf[buf_end]- ADC reg 2

//1-функция
//2-адрес
//3-данные

//0 4-20mA  20=4.4   =3606 k=20/3606 AIN0
//1  0-5mA   5=4.4   =3606 k= 5/3606 AIN1
//2 0-20mA  20=4.4   =3606 k=20/3606 AIN0
//3  0-10V  10=4.506 =3606 k=10/3691 AIN1
//4   0-5V   5=4.506 =3606 k= 5/3691 AIN0


// переделать битовый опрос