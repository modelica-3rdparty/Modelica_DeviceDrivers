#ifndef MDDARMDIGITAL__H
#define MDDARMDIGITAL__H



#include "stm32f4xx_hal.h"
#include "stm32f4_discovery.h"

/* Return only the port and not the pin in order to avoid malloc
 * Trust the user calls the following functions correctly...
 */
static inline void* MDD_stm32f4_digital_pin_init(void* port, int pin, int isOutput)
{
  switch (pin) {
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
  return (void*)port;
}

static inline void MDD_stm32f4_digital_pin_close(void *in_port)
{
}

static inline int MDD_stm32f4_digital_pin_read(void *in_port, int pin)
{
	return 0; //TODO
}

static inline void MDD_stm32f4_digital_pin_write(void *in_port, int pin, int value)
{
  volatile uint8_t led;
  switch (pin) {
  case 1:
    led = LED3;
    break;
  case 2:
    led = LED4;
    break;
  case 3:
    led = LED5;
    break;
  case 4:
    led = LED6;
    break;
  }
  if (value) {
    BSP_LED_On(led);
  } else {
    BSP_LED_Off(led);
  }
}

#endif
