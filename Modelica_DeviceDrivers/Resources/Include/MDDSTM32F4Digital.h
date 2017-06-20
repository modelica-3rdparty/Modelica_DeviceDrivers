#ifndef MDDARMDIGITAL__H
#define MDDARMDIGITAL__H


#include <main.h>

static inline void* MDD_stm32f4_led_init(void* handle, int led)
{
  switch (led) {
  case 1:
    BSP_LED_Init(LED3);
    break;
  case 2:
    BSP_LED_Init(LED4);
    break;
  case 3:
    BSP_LED_Init(LED5);
    break;
  case 4:
    BSP_LED_Init(LED6);
    break;
  }
  return (void*)handle;
}

static inline void MDD_stm32f4_led_close(void *handle)
{
}


static inline void MDD_stm32f4_led_out(void *handle, int led, int value)
{
  volatile uint8_t l;
  switch (led) {
  case 1:
    l = LED3;
    break;
  case 2:
    l = LED4;
    break;
  case 3:
    l = LED5;
    break;
  case 4:
    l = LED6;
    break;
  }
  if (value) {
    BSP_LED_On(l);
  } else {
    BSP_LED_Off(l);
  }
}

#endif
