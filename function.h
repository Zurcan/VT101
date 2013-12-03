//-------------------------------------------------------------------//
// повтор нажатия кнопки
//-------------------------------------------------------------------//
void rekey()
        {
        if (count_key2>20){if (++count_key1>103) count_key1=102;} 
        else if (count_key1>100){if (++count_key1>106) {count_key1=102;count_key2++;}}
        else if (((sys_time-time_key)>50)&&(count_key>0))
                {time_key=sys_time;if (--count_key<20){count_key=40;if(++count_key1>4){count_key1=102;count_key=250;}}}
        }
//-------------------------------------------------------------------//
