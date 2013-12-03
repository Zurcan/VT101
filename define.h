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
#define Y_01            1       //уставка 1
#define Y_02            2       //уставка 2
#define Z_01            3       //задержка по уставке 1
#define Z_02            4       //задержка по уставке 2
#define P___            5       //маскирование
#define C___            6       //звуковая сигнализация

#define A_01            7       //гистерезис
#define A_02            8       //звуковая сигнализация по уставке 1,2
#define A_03            9       //срабатывание реле в маскировании по уставке 1
#define A_04            10      //срабатывание реле в маскировании по уставке 2
#define A_05            11      //единицы измерения абсолютные/относит
#define A_06            12      //нижний предел измерения
#define A_07            13      //верхний предел измерения
#define A_08            14      //допуск сигнала ниже нижнего предела
#define A_09            15      //допуск сигнала выше верхнего предела
#define A_10            16      //время усреднения
#define A_11            17      //время блокировки при включении
#define A_12            18      //----
#define A_13            19      //время возврата из меню
#define A_14            20      //залипание по уставке 1
#define A_15            21      //залипание по уставке 2
#define A_16            22      //калибровка
#define A_17            23      //заводские установки
#define A_18            24      //версия ПО
#define A_19            25      //дата выпуска
#define adres           26
#define CRCCONST        27
#define SOFTID          28
            
#define MAX_REGISTER    28
#define DREBEZG_TIME    200//по 0,5мсек
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

