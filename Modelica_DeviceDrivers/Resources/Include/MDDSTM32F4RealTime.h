#ifndef MDDARMREALTIME__H
#define MDDARMREALTIME__H

#include <main.h>

#if defined(STM32F405xx) || defined(STM32F407xx) || defined(STM32F415xx) || defined(STM32F417xx)
const uint16_t MOD2BSP_VoltageScale[2] = {PWR_REGULATOR_VOLTAGE_SCALE1, PWR_REGULATOR_VOLTAGE_SCALE2};
#else
const uint16_t MOD2BSP_VoltageScale[3] = {PWR_REGULATOR_VOLTAGE_SCALE1, PWR_REGULATOR_VOLTAGE_SCALE2, PWR_REGULATOR_VOLTAGE_SCALE3};
#endif

const uint16_t MOD2BSP_PLLP[4] = {RCC_PLLP_DIV2, RCC_PLLP_DIV4, RCC_PLLP_DIV6, RCC_PLLP_DIV8};
const uint16_t MOD2BSP_AHBCLKDivider[9] = { RCC_SYSCLK_DIV1, RCC_SYSCLK_DIV2, RCC_SYSCLK_DIV4, RCC_SYSCLK_DIV8,
						RCC_SYSCLK_DIV16, RCC_SYSCLK_DIV64, RCC_SYSCLK_DIV128, RCC_SYSCLK_DIV256, RCC_SYSCLK_DIV512,};
const uint16_t MOD2BSP_APBCLKDivider[5] = { RCC_HCLK_DIV1, RCC_HCLK_DIV2, RCC_HCLK_DIV4, RCC_HCLK_DIV8, RCC_HCLK_DIV16};


static inline void* MDD_stm32f4_rt_init(void* time, int clock, int pllM, int pllN, int pllP, int pllQ,
					int ahbPre, int apb1Pre, int apb2Pre, int voltageScale,  int overdrive, int prefetchBufEnable)
{
  RCC_ClkInitTypeDef RCC_ClkInitStruct;
  RCC_OscInitTypeDef RCC_OscInitStruct;

  /* Enable Power Control clock */
  __HAL_RCC_PWR_CLK_ENABLE();
  
  /* The voltage scaling allows optimizing the power consumption when the device is 
     clocked below the maximum system frequency, to update the voltage scaling value 
     regarding system frequency refer to product datasheet.  */
  __HAL_PWR_VOLTAGESCALING_CONFIG(MOD2BSP_VoltageScale[voltageScale - 1]);
  
  /* Enable HSE Oscillator and activate PLL with HSE as source */
  switch (clock) {
  case 1:
    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
    RCC_OscInitStruct.HSIState = RCC_HSI_ON;
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_NONE;
    break;
  case 2:
    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
    RCC_OscInitStruct.HSEState = RCC_HSE_ON;
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_NONE;
    break;
  case 3:
    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
    RCC_OscInitStruct.HSIState = RCC_HSI_ON;
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSI;
    break;
  case 4:
    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
    RCC_OscInitStruct.HSEState = RCC_HSE_ON;
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
    break;
  }
  
  RCC_OscInitStruct.PLL.PLLM = pllM;//8;
  RCC_OscInitStruct.PLL.PLLN = pllN;//3;
  RCC_OscInitStruct.PLL.PLLP = MOD2BSP_PLLP[pllP - 1];//RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = pllQ;//7;
  if(HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    exit(1);
  }
  
#if defined(STM32F427xx) || defined(STM32F437xx) || defined(STM32F429xx) || defined(STM32F439xx) || defined(STM32F446xx) ||\
    defined(STM32F469xx) || defined(STM32F479xx)
  if (overdrive) {
    /* Activate the Over-Drive mode */
    HAL_PWREx_EnableOverDrive();
  }
#endif
  /* Select PLL as system clock source and configure the HCLK, PCLK1 and PCLK2 
     clocks dividers */
  RCC_ClkInitStruct.ClockType = (RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2);
  switch (clock) {
  case 1:
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSI;
    break;
  case 2:
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSE;
    break;
  case 3:
  case 4:
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
    break;
  }
  RCC_ClkInitStruct.AHBCLKDivider = MOD2BSP_AHBCLKDivider[ahbPre - 1];//RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = MOD2BSP_APBCLKDivider[apb1Pre - 1];//RCC_HCLK_DIV4;  
  RCC_ClkInitStruct.APB2CLKDivider = MOD2BSP_APBCLKDivider[apb2Pre - 1];//RCC_HCLK_DIV2;  
  if(HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_5) != HAL_OK)
  {
    exit(1);
  }

  if (prefetchBufEnable) {
  /* STM32F405x/407x/415x/417x Revision Z devices: prefetch is supported  */
    if (HAL_GetREVID() == 0x1001)
      {
	/* Enable the Flash prefetch */
	__HAL_FLASH_PREFETCH_BUFFER_ENABLE();
      }
  }

  return time;

}

static inline void MDD_stm32f4_rt_close(void *rt)
{
	return;
}


/* The wait routine actually starts the clock.
 * This is done after initialization to avoid weird behaviour
 */
static inline void MDD_stm32f4_rt_wait(void *timer,uint32_t tick)
{
  while (HAL_GetTick() <= tick) {};
}

#endif
