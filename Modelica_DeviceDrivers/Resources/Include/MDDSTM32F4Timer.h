#ifndef MDDAVRTIMER__H
#define MDDAVRTIMER__H



static inline void* MDD_stm32f4_timer_init(int timerValue)
{

  return (void*)timerValue;
}

static inline void MDD_stm32f4_timer_close(void *avr)
{
}

#endif

