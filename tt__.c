#include <mega16.h>

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Place your code here


}

// Timer 1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
// Place your code here

}

// Declare your global variables here

void main(void)
{
PORTD=0x00;
DDRD=0b00110000;

TCCR1A=0b11000011;
TCCR1B=0b00001010;


OCR1AH=0x01;
OCR1AL=0x7F;

//TIMSK=0x14;

//#asm("sei")

while (1)
      {
        #asm("wdr");
      };
}
