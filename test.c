#include <mega16.h>
#include <stdlib.h>
#include <math.h>


int read_adc()
        {
        int a;
        a=rand()/200+2000; 
        return a;
        }

void main(void)
{
unsigned int buf[9];
char buf_end,i,j;
signed char min_r,min_n;
signed char rang[9];
float adc_filter,k_f;

while (1)
        {
        #asm("wdr");
        //���������
        if (++buf_end>8) buf_end=0;buf[buf_end]=read_adc();min_r=9;
        //��������� ������
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
        adc_filter=k_f*buf[min_n]+(1-k_f)*adc_filter;
        };
}
