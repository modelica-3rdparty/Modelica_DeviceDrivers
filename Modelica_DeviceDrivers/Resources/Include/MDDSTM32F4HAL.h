#ifndef MDDARMHAL__H
#define MDDARMHAL__H

#include <main.h>

static inline void* MDD_stm32f4_hal_init()
{
  HAL_Init();
  return 0;
}

static inline void* MDD_stm32f4_hal_close(void* hal)
{
  HAL_DeInit();
  return 0;
}
#endif
