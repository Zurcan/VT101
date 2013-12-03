#include <mega16.h>
#include <delay.h>
#include <stdlib.h>
#include <math.h>

#define LOBYTE(word)   (word  & 0xFF) 
#define HIBYTE(word)   (word >>8) 
#define sbi(port,bit)  (port |= (1<<bit))   //set bit in port
#define cbi(port,bit)  (port &= ~(1<<bit))  //clear bit in port
#define qbi(var,bit)   (var  &   (1<<bit)) 
#define PAGESIZE  128 
#define PAGES     128
#define APP_PAGES 112 
#define Y_01            1       //������� 1
#define Y_02            2       //������� 2
#define Z_01            3       //�������� �� ������� 1
#define Z_02            4       //�������� �� ������� 2
#define P___            5       //������������
#define C___            6       //�������� ������������

#define A_01            7       //����������
#define A_02            8       //�������� ������������ �� ������� 1,2
#define A_03            9       //������������ ���� � ������������ �� ������� 1
#define A_04            10      //������������ ���� � ������������ �� ������� 2
#define A_05            11      //������� ��������� ����������/�������
#define A_06            12      //������ ������ ���������
#define A_07            13      //������� ������ ���������
#define A_08            14      //������ ������� ���� ������� �������
#define A_09            15      //������ ������� ���� �������� �������
#define A_10            16      //����� ����������
#define A_11            17      //����� ���������� ��� ���������
#define A_12            18      //----
#define A_13            19      //����� �������� �� ����
#define A_14            20      //��������� �� ������� 1
#define A_15            21      //��������� �� ������� 2
#define A_16            22      //����������
#define A_17            23      //��������� ���������
#define A_18            24      //������ ��
#define A_19            25      //���� �������
#define adres           26
#define CRCCONST        27
#define SOFTID          28
            
#define MAX_REGISTER    28
#define DREBEZG_TIME    200//�� 0,5����
#define buzern          PORTD.4
#define buzerp          PORTD.5

#define anode           PORTC
#define anode1          PORTC.3
#define anode2          PORTC.4
#define anode3          PORTC.5
#define anode4          PORTC.6
#define anode5          PORTC.7

#define katode          PORTA
#define katodeA         PORTA.0
#define katodeB         PORTA.1
#define katodeC         PORTA.2
#define katodeD         PORTA.3
#define katodeE         PORTA.4
#define katodeF         PORTA.5
#define katodeG         PORTA.6
#define katodeH         PORTA.7

#define relay_alarm1    PORTB.0
#define relay_alarm2    PORTB.1

#define rx_tx           PORTD.2
#define power           PORTD.3
#define cs              PORTB.4

#define key_1           PINC.0
#define key_2           PINC.1
#define key_3           PIND.6
#define key_4           PIND.7

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

//#define TCNT0_reload  220
#define TCNT0_reload  111//222
//#define TCNT2_reload  131
#define TCNT2_reload  94//188

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

