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
//#ifdef cc
//        a=255-a;
//#endif                
        return a;
        }
void set_led_on(char a,char b,char c,char d,char p1, char p2,char p3,char p4)
        {//установка данных для светодиодов и точек
        char i;
        if (avaria==1)d=0;
//#ifdef ca
         if (p1==0) {i=led_byte[0][0];i=i|128;led_byte[0][0]=i;}
         else       {i=led_byte[0][0];i=i&127;led_byte[0][0]=i;}
         if (p2==0) {i=led_byte[1][0];i=i|128;led_byte[1][0]=i;}
         else       {i=led_byte[1][0];i=i&127;led_byte[1][0]=i;}
         if (p3==0) {i=led_byte[2][0];i=i|128;led_byte[2][0]=i;}
         else       {i=led_byte[2][0];i=i&127;led_byte[2][0]=i;}
         if (p4==0) {i=led_byte[3][0];i=i|128;led_byte[3][0]=i;}
         else       {i=led_byte[3][0];i=i&127;led_byte[3][0]=i;}
/*#else
        if (p1==0) {i=led_byte[0,0];i=i&127;led_byte[0,0]=i;}
        else       {i=led_byte[0,0];i=i|128;led_byte[0,0]=i;}
        if (p2==0) {i=led_byte[1,0];i=i&127;led_byte[1,0]=i;}
        else       {i=led_byte[1,0];i=i|128;led_byte[1,0]=i;}
        if (p3==0) {i=led_byte[2,0];i=i&127;led_byte[2,0]=i;}
        else       {i=led_byte[2,0];i=i|128;led_byte[2,0]=i;}
        if (p4==0) {i=led_byte[3,0];i=i&127;led_byte[3,0]=i;}
        else       {i=led_byte[3,0];i=i|128;led_byte[3,0]=i;}*/
//#endif
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
        {//установка данных для светодиодов и точек
        char i;
        if (avaria==1)d=0;
//#ifdef ca
        if (p1==0) {i=led_byte[0][1];i=i|128;led_byte[0][1]=i;}
         else       {i=led_byte[0][1];i=i&127;led_byte[0][1]=i;}
         if (p2==0) {i=led_byte[1][1];i=i|128;led_byte[1][1]=i;}
         else       {i=led_byte[1][1];i=i&127;led_byte[1][1]=i;}
         if (p3==0) {i=led_byte[2][1];i=i|128;led_byte[2][1]=i;}
         else       {i=led_byte[2][1];i=i&127;led_byte[2][1]=i;}
         if (p4==0) {i=led_byte[3][1];i=i|128;led_byte[3][1]=i;}
         else       {i=led_byte[3][1];i=i&127;led_byte[3][1]=i;}
/*#else
        if (p1==0) {i=led_byte[0,1];i=i&127;led_byte[0,1]=i;}
        else       {i=led_byte[0,1];i=i|128;led_byte[0,1]=i;}
        if (p2==0) {i=led_byte[1,1];i=i&127;led_byte[1,1]=i;}
        else       {i=led_byte[1,1];i=i|128;led_byte[1,1]=i;}
        if (p3==0) {i=led_byte[2,1];i=i&127;led_byte[2,1]=i;}
        else       {i=led_byte[2,1];i=i|128;led_byte[2,1]=i;}
        if (p4==0) {i=led_byte[3,1];i=i&127;led_byte[3,1]=i;}
        else       {i=led_byte[3,1];i=i|128;led_byte[3,1]=i;}
#endif*/
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
        {//установка данных для дисплея, 1-я, 2-я, 3-я, 4-я цифры
        char i;
        i=led_byte[0][0];i=i&128;i=i|led_calk(a);led_byte[0][0]=i;
        i=led_byte[1][0];i=i&128;i=i|led_calk(b);led_byte[1][0]=i;
        i=led_byte[2][0];i=i&128;i=i|led_calk(c);led_byte[2][0]=i;
        i=led_byte[3][0];i=i&128;i=i|led_calk(d);led_byte[3][0]=i;
        }
void set_digit_off(char a,char b,char c,char d)
        {//установка данных для дисплея, 1-я, 2-я, 3-я, 4-я цифры
        char i;
        i=led_byte[0][1];i=i&128;i=i|led_calk(a);led_byte[0][1]=i;
        i=led_byte[1][1];i=i&128;i=i|led_calk(b);led_byte[1][1]=i;
        i=led_byte[2][1];i=i&128;i=i|led_calk(c);led_byte[2][1]=i;
        i=led_byte[3][1];i=i&128;i=i|led_calk(d);led_byte[3][1]=i;
        }
