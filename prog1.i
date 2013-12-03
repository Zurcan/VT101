
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb OCDR=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
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
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

#pragma used+

unsigned char cabs(signed char x);
unsigned int abs(int x);
unsigned long labs(long x);
float fabs(float x);
int atoi(char *str);
long int atol(char *str);
float atof(char *str);
void itoa(int n,char *str);
void ltoa(long int n,char *str);
void ftoa(float n,unsigned char decimals,char *str);
void ftoe(float n,unsigned char decimals,char *str);
void srand(int seed);
int rand(void);
void *malloc(unsigned int size);
void *calloc(unsigned int num, unsigned int size);
void *realloc(void *ptr, unsigned int size); 
void free(void *ptr);

#pragma used-
#pragma library stdlib.lib

#pragma used+

signed char cmax(signed char a,signed char b);
int max(int a,int b);
long lmax(long a,long b);
float fmax(float a,float b);
signed char cmin(signed char a,signed char b);
int min(int a,int b);
long lmin(long a,long b);
float fmin(float a,float b);
signed char csign(signed char x);
signed char sign(int x);
signed char lsign(long x);
signed char fsign(float x);
unsigned char isqrt(unsigned int x);
unsigned int lsqrt(unsigned long x);
float sqrt(float x);
float floor(float x);
float ceil(float x);
float fmod(float x,float y);
float modf(float x,float *ipart);
float ldexp(float x,int expon);
float frexp(float x,int *expon);
float exp(float x);
float log(float x);
float log10(float x);
float pow(float x,float y);
float sin(float x);
float cos(float x);
float tan(float x);
float sinh(float x);
float cosh(float x);
float tanh(float x);
float asin(float x);
float acos(float x);
float atan(float x);
float atan2(float y,float x);

#pragma used-
#pragma library math.lib

char rx_buffer[64];
unsigned char CRCLow = 0xff,rx_counter,mod_time,mod_time_s,rx_wr_index,CRCHigh=0xff;
bit rx_c,ti_en,rx_m;
interrupt [12] void usart_rx_isr(void)
{
char status,d;
status=UCSRA;d=UDR;
if (((status & ((1<<4) | (1<<2) | (1<<3)))==0)&&((ti_en==0)&&(rx_c==0)))
{if (mod_time==0){rx_m=1;rx_wr_index=0;}mod_time=mod_time_s;}
rx_buffer[rx_wr_index]=d;
if (++rx_wr_index >= 64) rx_wr_index=0;
if (++rx_counter >= 64) rx_counter=0;
}

unsigned char tx_buffer_begin,tx_buffer_end,tx_buffer[64];
interrupt [14] void usart_tx_isr(void)
{
if (ti_en==1)
{
if (++tx_buffer_begin>=64) tx_buffer_begin=0;
if (tx_buffer_begin!=tx_buffer_end) {UDR=tx_buffer[tx_buffer_begin];}
else {ti_en=0;rx_c=0;rx_m=0;PORTD.2=0;rx_counter=0;}
}
}

bit buzer_en,buzer,pik_en,buzer_buzer_en;
char pik_count;
interrupt [10] void timer0_ovf_isr(void)
{
TCNT0=111;
#asm("wdr");
if ((buzer_en==1)&&(buzer_buzer_en==1)){if (buzer==1) {PORTD.5=1;buzer=0;}else {PORTD.5=0;buzer=1;}}
else if (pik_en==1){if (++pik_count>200) {pik_en=0;pik_count=0;}if (buzer==1) {PORTD.5=1;buzer=0;}else {PORTD.5=0;buzer=1;}}
else PORTD.5=0;
if (pik_en==1){if (++pik_count>200) {pik_en=0;pik_count=0;}}
}
char led_byte[5][2];
interrupt [20] void timer0_comp_isr(void){}
interrupt [9] void timer1_ovf_isr(void){TCNT1H=0x05;TCNT1L=0x01;}
interrupt [6] void timer1_capt_isr(void){}
interrupt [7] void timer1_compa_isr(void){}
interrupt [8] void timer1_compb_isr(void){}

long sys_time,whait_time;
bit key_mode,key_plus,key_mines,key_enter,key_mode_press,key_plus_press,key_mines_press,key_enter_press,key_mode_press_switch;
bit key_plus_press_switch,key_minus_press_switch,key_enter_press_switch;
char count_led,count_led1,drebezg;
bit avaria,alarm1,alarm2,alarm_alarm1,alarm_alarm2;
int count_blink,crc;

interrupt [5] void timer2_ovf_isr(void)
{
char n;
TCNT2=94;
#asm("sei");
sys_time=sys_time+1;

if (mod_time==0){if (rx_m==1) rx_c=1;}
else 	mod_time--;

if (PINC.0==0){key_mode=1;if ((key_mode_press==0)&&(pik_en==0)){key_mode_press_switch=1;pik_en=1;drebezg=0;}key_mode_press=1;}
else if ((PINC.1==1)&&(PIND.6==1)&&(PIND.7==1)&&(++drebezg>200)){key_mode=0;key_mode_press=0;}

if (PINC.1==0){key_plus=1;if ((key_plus_press==0)&&(pik_en==0)){key_plus_press_switch=1;pik_en=1;drebezg=0;}key_plus_press=1;}
else if ((PINC.0==1)&&(PIND.6==1)&&(PIND.7==1)&&(++drebezg>200)){key_plus=0;key_plus_press=0;}

if (PIND.6==0){key_mines=1;if ((key_mines_press==0)&&(pik_en==0)){key_minus_press_switch=1;pik_en=1;drebezg=0;}key_mines_press=1;}
else if ((PINC.1==1)&&(PINC.0==1)&&(PIND.7==1)&&(++drebezg>200)){key_mines=0;key_mines_press=0;}

if (PIND.7==0){key_enter=1;if (key_enter_press==0){key_enter_press_switch=1;pik_en=1;whait_time=sys_time;}key_enter_press=1;alarm_alarm1=0;alarm_alarm2=0;}
else {key_enter=0;key_enter_press=0;}

if (++count_blink>2000) count_blink=0;
if (count_blink<300) {n=1;buzer_en=0;if ((alarm_alarm1==1)||(alarm_alarm2==1))buzer_en=1;else buzer_en=0;}
else {n=0;if ((alarm1==1)||(alarm2==1))buzer_en=1;}

PORTA=0xFF;PORTC=PORTC&0b00000111;

switch (count_led)        
{

case 4: count_led=0;PORTC.3=1;DDRC.3=1;PORTA=led_byte[0][n];break;
case 3: count_led=4;PORTC.4=1;DDRC.4=1;PORTA=led_byte[1][n];break;
case 2: count_led=3;PORTC.5=1;DDRC.5=1;PORTA=led_byte[2][n];break;
case 1: count_led=2;PORTC.6=1;DDRC.6=1;PORTA=led_byte[3][n];break;
default:count_led=1;PORTC.7=1;DDRC.7=1;PORTA=led_byte[4][n];break;

}

}

interrupt [4] void timer2_comp_isr(void){}

#pragma used+
unsigned char spi(unsigned char data);
#pragma used-

#pragma library spi.lib

eeprom float reg[4][27]=
{{0, 4.6, 7.1,   0,   5,   0,   1,   0,   1,   0,   0,   1,0.00,20.0,   2,   2,   0,  10,   2,   5,   0,   0,   1,   0,1.00,11.09,    1},
{0, 4.6, 7.1,   0,   5,   0,   1,   0,   1,   0,   0,   1,0.00,20.0,   2,   2,   0,  10,   2,   5,   0,   0,   1,   0,1.00,11.09,    1},
{0,9999,9999,  30,  30,   1,   1,  10,   2,   1,   1,   2,9999,9999,  10,  10,   5,  30,   4,  10,   1,   1, 1.8,   1,99.99,12.99,  247},
{0,-999,-999,   0,   0,   0,   0,   0,   1,   0,   0,   0,-999,-999,   0,   0,   0,   0,   0,   0,   0,   0, 0.2,   0,0,1.00,    0}};

eeprom char ee_point=3;
eeprom int crceep = 0x0000;
eeprom const int crcstatic = 0x45cb;
eeprom char crc1digit = 3, crc2digit = 'c', crc3digit =2 , crc4digit = 1;    

char mode,point,work_point,save_point;
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
case 'p': a=0b00001100;break;
case '-': a=0b00111111;break;

case 'r': a=0b00101111;break;
case 't': a=0b00000111;break;
case 'b': a=0b00000011;break;
case 'd': a=0b00100001;break;
case 'e': a=0b00000110;break;
case 'f': a=0b00001110;break;
case 'g': a=0b01000010;break;
case 'h': a=0b01100101;break;
case 'k': a=0b00001010;break; 
case 'i': a=0b01001111;break;
case 'l': a=0b01000111;break; 
case 'v': a=0b01000001;break;
default:  a=0b01110010;break;
}

return a;
}
void set_led_on(char a,char b,char c,char d,char p1, char p2,char p3,char p4)
{
char i;
if (avaria==1)d=0;

if (p1==0) {i=led_byte[0][0];i=i|128;led_byte[0][0]=i;}
else       {i=led_byte[0][0];i=i&127;led_byte[0][0]=i;}
if (p2==0) {i=led_byte[1][0];i=i|128;led_byte[1][0]=i;}
else       {i=led_byte[1][0];i=i&127;led_byte[1][0]=i;}
if (p3==0) {i=led_byte[2][0];i=i|128;led_byte[2][0]=i;}
else       {i=led_byte[2][0];i=i&127;led_byte[2][0]=i;}
if (p4==0) {i=led_byte[3][0];i=i|128;led_byte[3][0]=i;}
else       {i=led_byte[3][0];i=i&127;led_byte[3][0]=i;}

if ((a==0)&&(avaria==0))  led_byte[4] [0]=led_byte[4] [0]|1;
else       led_byte[4] [0]=led_byte[4] [0]&0b11111110;
if ((b==0)&&(alarm2==0))  led_byte[4] [0]=led_byte[4] [0]|2;
else       led_byte[4] [0]=led_byte[4] [0]&0b11111101;
if ((c==0)&&(alarm1==0))  led_byte[4] [0]=led_byte[4] [0]|4;
else       led_byte[4] [0]=led_byte[4] [0]&0b11111011;
if (d==0)  led_byte[4] [0]=led_byte[4] [0]|8;
else       led_byte[4] [0]=led_byte[4] [0]&0b11110111;

}
void set_led_off(char a,char b,char c,char d,char p1, char p2,char p3,char p4)
{
char i;
if (avaria==1)d=0;

if (p1==0) {i=led_byte[0][1];i=i|128;led_byte[0][1]=i;}
else       {i=led_byte[0][1];i=i&127;led_byte[0][1]=i;}
if (p2==0) {i=led_byte[1][1];i=i|128;led_byte[1][1]=i;}
else       {i=led_byte[1][1];i=i&127;led_byte[1][1]=i;}
if (p3==0) {i=led_byte[2][1];i=i|128;led_byte[2][1]=i;}
else       {i=led_byte[2][1];i=i&127;led_byte[2][1]=i;}
if (p4==0) {i=led_byte[3][1];i=i|128;led_byte[3][1]=i;}
else       {i=led_byte[3][1];i=i&127;led_byte[3][1]=i;}

if ((a==0)&&(avaria==0))  led_byte[4][1]=led_byte[4][1]|1;
else       led_byte[4][1]=led_byte[4][1]&0b11111110;
if ((b==0)&&(alarm_alarm2==0))  led_byte[4][1]=led_byte[4][1]|2;
else       led_byte[4][1]=led_byte[4][1]&0b11111101;
if ((c==0)&&(alarm_alarm1==0))  led_byte[4][1]=led_byte[4][1]|4;
else       led_byte[4][1]=led_byte[4][1]&0b11111011;
if (d==0)  led_byte[4][1]=led_byte[4][1]|8;
else       led_byte[4][1]=led_byte[4][1]&0b11110111;
}
void set_digit_on(char a,char b,char c,char d)
{
char i;
i=led_byte[0][0];i=i&128;i=i|led_calk(a);led_byte[0][0]=i;
i=led_byte[1][0];i=i&128;i=i|led_calk(b);led_byte[1][0]=i;
i=led_byte[2][0];i=i&128;i=i|led_calk(c);led_byte[2][0]=i;
i=led_byte[3][0];i=i&128;i=i|led_calk(d);led_byte[3][0]=i;
}
void set_digit_off(char a,char b,char c,char d)
{
char i;
i=led_byte[0][1];i=i&128;i=i|led_calk(a);led_byte[0][1]=i;
i=led_byte[1][1];i=i&128;i=i|led_calk(b);led_byte[1][1]=i;
i=led_byte[2][1];i=i&128;i=i|led_calk(c);led_byte[2][1]=i;
i=led_byte[3][1];i=i&128;i=i|led_calk(d);led_byte[3][1]=i;
}

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

crc = crctable[((crc>>8)^d)&0xFF] ^ (crc<<8);
}              
void hex2dec(float x)		
{				
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

void find_save_reg(unsigned int a,float b);
float find_reg(unsigned int a);
void response_m_err(char a);                     

int read_adc()
{
int a;
PORTB.4=0;
SPCR=0b01010001;
i=reg[0][18      ];
switch (i)
{
case 0: SPDR=0b10110001;break;
case 1: SPDR=0b10111001;break;
case 2: SPDR=0b10110001;break;
case 3: SPDR=0b10111001;break;
default:SPDR=0b10110001;break;
}
while(SPSR.7==0);
a=SPDR;
SPDR=0;
a=a<<8;
while (SPSR.7 == 0);
a = a + SPDR; 
PORTB.4=1;
return a;
}

unsigned int buf[9],buf_m[9];
char buf_begin,buf_end,buf_n[9];
float x,adc_filter;
char j,k,count_register,count_key2;
long start_time,start_time_mode,time_key;

void rekey()
{
if (count_key2>20){if (++count_key1>103) count_key1=102;} 
else if (count_key1>100){if (++count_key1>106) {count_key1=102;count_key2++;}}
else if (((sys_time-time_key)>50)&&(count_key>0))
{time_key=sys_time;if (--count_key<20){count_key=40;if(++count_key1>4){count_key1=102;count_key=250;}}}
}

float izm()
{
char min_r,min_n;
signed char rang[9];
float k_f;

if (++buf_end>8) buf_end=0;
buf[buf_end]=read_adc();
min_r=9;

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

k_f=reg[0][16      ];
if (k_f==0) k_f=0.001;
k_f=0.001/k_f;
adc_filter=k_f*buf[min_n]+(1-k_f)*adc_filter;

return adc_filter;
}

char error;

float value[6],adc_value1,adc_value2,adc_value3;
bit blok1,blok2,signal;
void response_m_aa1();
void response_m_aa46();
void response_m_aa48();
void check_add_cr();

void check_rx();
void mov_buf_mod(char a);		
void mov_buf(char a);			
void crc_end();				
void crc_rtu(char a);			

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

TCCR0=0x03;TCNT0=111;OCR0=0x00;

ASSR=0x00;TCCR2=0x04;TCNT2=94;OCR2=0x00;

MCUCR=0x00;MCUCSR=0x00;TIMSK=0xFF;

ACSR=0x80;SFIOR=0x00;SPCR=0x52;SPSR=0x00;WDTCR=0x1F;WDTCR=0x0F;
mod_time_s=60;
} 

void main(void)
{    
bit flag_start_pause1,flag_start_pause2,f_m1,key_enter_press_switch1;
float time_pause1,time_pause2;
float data_register,adc_filter;
float k_k,kk,bb,dop1,dop2;
float gis_val1=reg[0][1       ];         
float gis_val2=reg[0][2       ];
char q1,q2,q3,q4,diap_val1=0,diap_val2=0,dataH,dataL,crcok_flag=0;
float temp;
int  imin, imax, data, j = 0, j1=0;
crc = 0xffff;

point=ee_point;

sys_init();
#asm("cli");

while ((data<=65534)|(j<=16382))
{
data= read_program_memory (j);
dataH = (int)data>>8;
dataL = data;
CRC_update(dataH);
CRC_update(dataL);

j=j+2;
}
crceep = crc;
i=0;
#asm("sei")
start_time=sys_time;count_register=1;
PORTD.3 = 1;
for(j1=0;j1<2;j1++)
{
tis='v';sot=1;des= 0 ;ed=1;
set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
delay_ms(1500);
tis=1;sot=0;des= 0 ;ed=0;
set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
delay_ms(1500);
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
PORTD.3 = 0;
if(crcok_flag==1)
{
while ((PINC.0==0)&&(PINC.1==0)&&(PIND.6==0)&&(PIND.7==0));
while (i<100)
{
if ((PINC.0==0)&&(PIND.7==0)&&(PINC.1==1)&&(PIND.6==1)) i++;
else i=0;
delay_ms(20);   
}

PORTD.3=1;
data_register=reg[0][13      ];
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

start_time=sys_time;count_register=1;
set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
while ((sys_time-start_time)<reg[0][17      ]*1000) 

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
PORTD.3=1;

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
k_k=reg[0][22      ];

point=ee_point;
work_point=point;
ti_en=0;

rx_wr_index=0;
tx_buffer_begin=0;
tx_buffer_end=0;

while (1)
{
#asm("wdr");
adc_filter=izm();

i=reg[0][18      ];
switch (i)
{
case 0: adc_value1=adc_filter*k_k*20/3606;break;
case 1: adc_value1=adc_filter*k_k* 5/3606;break;
case 2: adc_value1=adc_filter*k_k*20/3606;break;
case 3: adc_value1=adc_filter*k_k*10/3691;break;
default:adc_value1=adc_filter*k_k* 5/3691;break;
} 

i=reg[0][18      ];
switch (i)
{
case 0: kk=(reg[0][13      ]-reg[0][12      ])/(20-4);bb=reg[0][12      ]-kk*4;dop1=4;dop2=20;break;
case 1: kk=(reg[0][13      ]-reg[0][12      ])/( 5-0);bb=reg[0][12      ]-kk*0;dop1=0;dop2= 5;break;
case 2: kk=(reg[0][13      ]-reg[0][12      ])/(20-0);bb=reg[0][12      ]-kk*0;dop1=0;dop2=20;break;
case 3: kk=(reg[0][13      ]-reg[0][12      ])/(10-0);bb=reg[0][12      ]-kk*0;dop1=0;dop2=10;break;
default:kk=(reg[0][13      ]-reg[0][12      ])/( 5-0);bb=reg[0][12      ]-kk*0;dop1=0;dop2= 5;break;
}
adc_value2=adc_value1*kk+bb;

if (adc_value1<(dop1*(1-reg[0][14      ]/100)))
{
avaria=1;
adc_value2=(dop1*(1-reg[0][14      ]/100))*kk+bb;
}
else if (adc_value2>(dop2*(1+reg[0][15      ]/100)))
{
avaria=1;
adc_value2=(dop2*(1+reg[0][15      ]/100))*kk+bb;
}
else avaria=0;

if ((alarm1==1)&&(alarm_alarm1==1)){
switch(key_enter_press){
case 1:        
if (adc_value2>gis_val1){
alarm1=1;
gis_val1=(reg[0][1       ])*(1-reg[0][7       ]/100);} 
else        
{
alarm1=0;flag_start_pause1=0;
if ((reg[0][5       ]==0)||(reg[0][5       ]==1)&&(reg[0][20      ]==0))alarm_alarm1=0;
gis_val1=(reg[0][1       ]);
}  
key_enter_press=0;
break;
default:      break;}}        
else   {
if (adc_value2>gis_val1){
alarm1=1;
gis_val1=(reg[0][1       ])*(1-reg[0][7       ]/100);} 
else        
{
alarm1=0;flag_start_pause1=0;
if ((reg[0][5       ]==0)||(reg[0][5       ]==1)&&(reg[0][20      ]==0))alarm_alarm1=0;
gis_val1=(reg[0][1       ]);
} 

}              
if ((alarm2==1)&&(alarm_alarm2==1)){
switch(key_enter_press){
case 1:         
if (adc_value2>gis_val2)
{alarm2=1;
gis_val2=(reg[0][2       ])*(1-reg[0][7       ]/100);}
else 
{
alarm2=0;flag_start_pause2=0;
if ((reg[0][5       ]==0)||(reg[0][5       ]==1)&&(reg[0][21      ]==0))alarm_alarm2=0; 
gis_val2=(reg[0][2       ]);
}  
key_enter_press=0;
break;
default: break;}}
else {
if (adc_value2>gis_val2)
{alarm2=1;
gis_val2=(reg[0][2       ])*(1-reg[0][7       ]/100);}
else 
{
alarm2=0;flag_start_pause2=0;
if ((reg[0][5       ]==0)||(reg[0][5       ]==1)&&(reg[0][21      ]==0))alarm_alarm2=0; 
gis_val2=(reg[0][2       ]);
}   

}

if (alarm_alarm1==1){PORTB.0=1;}
else PORTB.0=0;
if (alarm_alarm2==1){PORTB.1=1;}
else PORTB.1=0;

if ((flag_start_pause1==1))
{
if ((sys_time-time_pause1)>(reg[0][3       ]*800)){alarm_alarm1=1;}
}
else if (alarm1==1)
{
if ( ( (reg[0][6       ]==1) && (reg[0][8       ]==1) ) ){signal=1;buzer_buzer_en=1;}
if ( (reg[0][5       ]==0) || ( (reg[0][5       ]==1) && (reg[0][9       ]==1) ) )
{
time_pause1=sys_time;
flag_start_pause1=1;
}
}
if ((alarm1==0)&&(alarm2==0))
{
if (((alarm_alarm1==0)||((alarm_alarm1==1)&&(reg[0][20      ]==0)))&&((alarm_alarm2==0)||((alarm_alarm2==1)&&(reg[0][21      ]==0)))){signal=0;buzer_buzer_en=0;}
if ((blok1==0)&&(blok2==0)){signal=0;buzer_buzer_en=0;}
}
if (reg[0][6       ]==0)buzer_buzer_en=0;
if ((flag_start_pause2==1))
{
if ((sys_time-time_pause2)>(reg[0][4       ]*800))alarm_alarm2=1;
}
else if (alarm2==1)
{
if (((reg[0][6       ]==1)&&(reg[0][8       ]==2))){signal=1;buzer_buzer_en=1;}
if ((reg[0][5       ]==0)||((reg[0][5       ]==1)&&(reg[0][10      ]==1)))
{
time_pause2=sys_time;
flag_start_pause2=1;
}
}

if (((sys_time-start_time_mode)>reg[0][19      ]*1000)){mode=0;f_m1=0;}

if ((key_enter_press_switch==1)&&(mode==0)){key_enter_press_switch=0;key_enter_press_switch1=1;}

if ((key_enter_press_switch1==1)&&(key_enter==1)&&(key_mode==0))
{if ((sys_time-whait_time)>1500){mode=10;start_time_mode=sys_time;key_enter_press_switch1=0;}}

if ((key_enter_press_switch1==1)&&(key_enter==1)&&(key_mode==1)&&(PINC.1==1)&&(PIND.6==1))
{if ((sys_time-whait_time)>1500) {goto power_off;}}

if (mode==0)
{
count_register=1;
point=work_point;
if (((alarm_alarm1==0)||((alarm_alarm1==1)&&(reg[0][20      ]==0)))&&((alarm_alarm2==0)||((alarm_alarm2==1)&&(reg[0][21      ]==0))))
{
if (reg[0][11      ]==0)adc_value3=adc_value1;
else if (reg[0][11      ]==2){adc_value3=buf[buf_end];point=1;}
else adc_value3=adc_value2;
}
hex2dec(adc_value3);
if (point==1)       {set_led_on(0,0,0,1,0,0,0,0);set_led_off(0,0,0,1,0,0,0,0);}
else if (point==2)  {set_led_on(0,0,0,1,0,0,1,0);set_led_off(0,0,0,1,0,0,1,0);}
else if (point==3)  {set_led_on(0,0,0,1,0,1,0,0);set_led_off(0,0,0,1,0,1,0,0);}
else if (point==4)  {set_led_on(0,0,0,1,1,0,0,0);set_led_off(0,0,0,1,1,0,0,0);}
}

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

if (mode==10)
{
if (count_register<7) count_register=7;
hex2dec(count_register-6);point=1;
if (des==' ') des='_';
tis='a';sot='_';
set_led_on(0,0,0,1,0,0,0,0);
set_led_off(0,0,0,1,0,0,0,0);
}

if ((mode==11)&&(count_register==22      ))
{
point=work_point;
k_k=data_register;
if (reg[0][11      ]==0)adc_value3=adc_value1;
else adc_value3=adc_value2;
hex2dec(adc_value3);
if (point==1)       {set_led_on(0,0,0,1,0,0,0,0);set_led_off(0,0,0,1,0,0,0,0);}
else if (point==2)  {set_led_on(0,0,0,1,0,0,1,0);set_led_off(0,0,0,1,0,0,1,0);}
else if (point==3)  {set_led_on(0,0,0,1,0,1,0,0);set_led_off(0,0,0,1,0,1,0,0);}
else if (point==4)  {set_led_on(0,0,0,1,1,0,0,0);set_led_off(0,0,0,1,1,0,0,0);}
point=4;
}

if ((mode==11)&&(count_register!=22      ))
{
if (((count_register>=12      )&&(count_register<=15      ))|(count_register==24      )|(count_register==25      ))
{
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
else if (count_register==16      )point=3;
else point=1;
hex2dec(data_register);

if (count_register==22      )
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

if(count_register==27) {tis = crc1digit; sot = crc2digit; des =crc3digit; ed = crc4digit; point = 0;}
if(count_register==28) {tis = 'v'; sot = 1; des = 0; ed = 1; point = 0;}        
}

diap_val1 = reg[0][18      ];
if(diap_val1!=diap_val2){
diap_val2=diap_val1;
switch (diap_val1){
case 0:reg[0][12      ]=4; reg[0][13      ]=20;point=3;break;
case 1:reg[0][12      ]=0; reg[0][13      ]=5;point=4;break;
case 2:reg[0][12      ]=0; reg[0][13      ]=20;point=3;break;
case 3:reg[0][12      ]=0; reg[0][13      ]=10;point=3;break;
default:reg[0][12      ]=0; reg[0][13      ]=5;point=4;break;}    
ee_point=point;work_point=point;  }        

if (key_plus_press==1)
{

start_time_mode=sys_time;
if (count_key==0)
{
if (mode==10)if (++count_register>28)count_register=28;
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
if((count_register==24      )|(count_register==25      )|(count_register==27)|(count_register==28)){;}
else
{
reg[0][count_register]=data_register;

start_time_mode=sys_time;
if (count_register==13      ){ee_point=point;work_point=point;}
if (count_register==23      )
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
if ((key_mode_press_switch==1)&&(PIND.7==1))
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
else while(1){delay_ms(1000);}

}         
void check_rx()
{
if (rx_c==1)			
{	

check_add_cr();

crc=0xffff;
if (error==0) 
{ 

if (rx_buffer[1]==1)
{
if (rx_counter==8)
{ 
if ((rx_buffer[3]+rx_buffer[5])<5) response_m_aa1();
else  response_m_err(2);
}
else response_m_err(3);

}

else if (rx_buffer[1]==0x48)
{

if (rx_counter==8)
{ 
if (rx_buffer[2]<3) response_m_aa48();
else  response_m_err(2);

}
else response_m_err(3);

}

else if (rx_buffer[1]==0x46)
{
if (rx_counter==10)
{
if (rx_buffer[2]<3) response_m_aa46();
else response_m_err(2);
}
else response_m_err(3);

}

else response_m_err(1);

}
rx_c=0;rx_m=0;rx_counter=0;
crc=0xffff;
rx_wr_index=0;
}
}

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

else if (a==0x0100)              d=reg[0][1       ];
else if (a==0x0101)              d=reg[0][2       ];
else if (a==0x0102)              d=reg[0][3       ];
else if (a==0x0103)              d=reg[0][4       ];
else if (a==0x0104)              d=reg[0][5       ];
else if (a==0x0105)              d=reg[0][6       ];

else if (a==0x0200)              d=reg[0][7       ];
else if (a==0x0201)              d=reg[0][8       ];
else if (a==0x0202)              d=reg[0][9       ];
else if (a==0x0203)              d=reg[0][10      ];
else if (a==0x0204)              d=reg[0][11      ];
else if (a==0x0205)              d=reg[0][12      ];
else if (a==0x0206)              d=reg[0][13      ];
else if (a==0x0207)              d=reg[0][14      ];
else if (a==0x0208)              d=reg[0][15      ];
else if (a==0x0209)              d=reg[0][16      ];
else if (a==0x020A)              d=reg[0][17      ];
else if (a==0x020B)              d=reg[0][18      ];
else if (a==0x020C)              d=reg[0][19      ];
else if (a==0x020D)              d=reg[0][20      ];
else if (a==0x020E)              d=reg[0][21      ];
else if (a==0x020F)              d=reg[0][22      ];
else if (a==0x0210)              d=reg[0][23      ];
else if (a==0x0211)              d=reg[0][24      ];
else if (a==0x0212)              d=reg[0][25      ];
else if (a==0x0213)              d=reg[0][26];

else                             d=0;
return d;
}
void find_save_reg(unsigned int a,float b)
{
if (a==0x0100)                   reg[0][1       ]=b;
else if (a==0x0101)              reg[0][2       ]=b;
else if (a==0x0102)              reg[0][3       ]=b;
else if (a==0x0103)              reg[0][4       ]=b;
else if (a==0x0104)              reg[0][5       ]=b;
else if (a==0x0105)              reg[0][6       ]=b;

else if (a==0x0200)              reg[0][7       ]=b;
else if (a==0x0201)              reg[0][8       ]=b;
else if (a==0x0202)              reg[0][9       ]=b;
else if (a==0x0203)              reg[0][10      ]=b;
else if (a==0x0204)              reg[0][11      ]=b;
else if (a==0x0205)              reg[0][12      ]=b;
else if (a==0x0206)              reg[0][13      ]=b;
else if (a==0x0207)              reg[0][14      ]=b;
else if (a==0x0208)              reg[0][15      ]=b;
else if (a==0x0209)              reg[0][16      ]=b;
else if (a==0x020A)              reg[0][17      ]=b;
else if (a==0x020B)              reg[0][18      ]=b;
else if (a==0x020C)              reg[0][19      ]=b;
else if (a==0x020D)              reg[0][20      ]=b;
else if (a==0x020E)              reg[0][21      ]=b;
else if (a==0x020F)              reg[0][22      ]=b;
else if (a==0x0210)              reg[0][23      ]=b;
else if (a==0x0211)              reg[0][24      ]=b;
else if (a==0x0212)              reg[0][25      ]=b;
else if (a==0x0213)              reg[0][26]=b;
}

void response_m_aa1()                   
{mov_buf_mod(rx_buffer[0]);     
mov_buf_mod(rx_buffer[1]);      
mov_buf_mod(1);                 
while (rx_buffer[5]>0)          
{if (rx_buffer[3]==0)   
{if (avaria==1) i=1;     
else i=0;}      
if (rx_buffer[3]==1)    
{if (alarm1==0) i=i+2;   
else i=i;}      
if (rx_buffer[3]==2)    
{if (alarm2==0) i=i+4;   
else i=i;}      
if (rx_buffer[3]==3)    
{if (avaria==0) i=i+4;   
else i=i;}      
rx_buffer[5]--;         
rx_buffer[3]++;}        
mov_buf_mod(i);crc_end();}      

void response_m_aa46()                  
{float temp;                    
int adr;                        
*((unsigned char *)(&temp)+0)=rx_buffer[4];
*((unsigned char *)(&temp)+1)=rx_buffer[5];
*((unsigned char *)(&temp)+2)=rx_buffer[6];
*((unsigned char *)(&temp)+3)=rx_buffer[7];

adr=rx_buffer[2];               
adr=adr<<8;                     
adr=adr+rx_buffer[3];           
find_save_reg(adr,temp);        
mov_buf_mod(rx_buffer[0]);      
mov_buf_mod(rx_buffer[1]);      
mov_buf_mod(rx_buffer[2]);      
mov_buf_mod(rx_buffer[3]);      
mov_buf_mod(rx_buffer[4]);      
mov_buf_mod(rx_buffer[5]);      
mov_buf_mod(rx_buffer[6]);      
mov_buf_mod(rx_buffer[7]);      
crc_end();}                     

void response_m_aa48()                  
{char a,i;                      
float temp;                     
int adr;                        
i=rx_buffer[5]*2;               
a=0;                            
mov_buf_mod(rx_buffer[0]);      
mov_buf_mod(rx_buffer[1]);      
mov_buf_mod(rx_buffer[5]*4);    
adr=rx_buffer[2];               
adr=adr<<8;                     
adr=adr+rx_buffer[3];           
temp=find_reg(adr);             
while (i>0)                     
{mov_buf_mod(*((unsigned char *)(&temp)+0+a));
mov_buf_mod(*((unsigned char *)(&temp)+1+a));
i--;a++;a++;}           
crc_end();}                     

void response_m_err(char a)             
{mov_buf_mod(rx_buffer[0]);     
mov_buf_mod(rx_buffer[1]|128);  
mov_buf_mod(a);                 
crc_end();}                     

void check_add_cr()                     
{char i;                        
error=0;crc=0xFFFF;  
i=(unsigned char)reg[0][26];  
if (rx_buffer[0]!=i) error=5;   
i=0;                            
while (i<(rx_wr_index-2)){crc_rtu(rx_buffer[i]);i++;}
i=crc>>8;                       
if ((rx_buffer[rx_wr_index-1])!=i) error=2;
i=crc;                          
if ((rx_buffer[rx_wr_index-2])!=i) error=3;

}                               

void mov_buf_mod(char a){crc_rtu(a);mov_buf(a);}

void mov_buf(char a)                    
{#asm("cli");                   
tx_buffer[tx_buffer_end]=a;     
if (++tx_buffer_end==64) tx_buffer_end=0;
#asm("sei");}                   

void crc_end()                          
{mov_buf(crc);mov_buf(crc>>8);PORTD.2=1;
UDR=tx_buffer[tx_buffer_begin]; 
ti_en=1;crc=0xffff;}		

void crc_rtu(char a)			
{
char n;                         
crc = a^crc;			
for(n=0; n<8; n++)		
{
if(crc & 0x0001 == 1)  
{
crc = crc>>1;	
crc=crc&0x7fff;	
crc = crc^0xA001;
}
else    
{
crc = crc>>1;	
crc=crc&0x7fff;
}
}
}

