#ifndef MDDARMDIGITAL__H
#define MDDARMDIGITAL__H


#include <main.h>
/* GPIO */
GPIO_TypeDef * MOD2BSP_Port[9] = {GPIOA, GPIOB, GPIOC, GPIOD, GPIOE, GPIOF, GPIOG, GPIOH, GPIOI};
const uint16_t MOD2BSP_Pin[17] = {GPIO_PIN_0, GPIO_PIN_1, GPIO_PIN_2, GPIO_PIN_3,
				  GPIO_PIN_4, GPIO_PIN_5, GPIO_PIN_6, GPIO_PIN_7,
				  GPIO_PIN_8, GPIO_PIN_9, GPIO_PIN_10, GPIO_PIN_11,
				  GPIO_PIN_12, GPIO_PIN_13, GPIO_PIN_14, GPIO_PIN_15, GPIO_PIN_All};
const uint32_t MOD2BSP_Mode[3] = {GPIO_MODE_IT_RISING, GPIO_MODE_IT_FALLING, GPIO_MODE_IT_RISING_FALLING};

typedef struct {
  GPIO_TypeDef * port;
  uint16_t pin;
}Gpio;

static inline void* MDD_stm32f4_digital_pin_init(void* handle, int port, int pin, int isOutput)
{
  	  GPIO_InitTypeDef   GPIO_InitStruct;
	  Gpio gpio;
	  assert_param(port >= 1 && port <= 9);
	  assert_param(pin >= 1 && pin <= 17);
	  /* Enable GPIO clock */
	  switch (port) {
	  case 1:
	    __HAL_RCC_GPIOA_CLK_ENABLE();
	    break;
	  case 2:
	    __HAL_RCC_GPIOB_CLK_ENABLE();
	    break;
	  case 3:
	    __HAL_RCC_GPIOC_CLK_ENABLE();
	    break;
	  case 4:
	    __HAL_RCC_GPIOD_CLK_ENABLE();
	    break;
	  case 5:
	    __HAL_RCC_GPIOE_CLK_ENABLE();
	    break;
	  case 6:
	    __HAL_RCC_GPIOF_CLK_ENABLE();
	    break;
	  case 7:
	    __HAL_RCC_GPIOG_CLK_ENABLE();
	    break;
	  case 8:
	    __HAL_RCC_GPIOH_CLK_ENABLE();
	    break;
	  case 9:
	    __HAL_RCC_GPIOI_CLK_ENABLE();
	    break;
	  }
	  gpio.port = MOD2BSP_Port[port - 1];
	  gpio.pin = MOD2BSP_Pin[pin - 1];
	  /* Configure the GPIO pin */
	  GPIO_InitStruct.Pin = gpio.pin;
	  if (isOutput) {
	    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
	    GPIO_InitStruct.Pull = GPIO_PULLUP;
	  } else {
	    GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
	    GPIO_InitStruct.Pull = GPIO_NOPULL;
	  }
	    
	  GPIO_InitStruct.Speed = GPIO_SPEED_HIGH;

	  HAL_GPIO_Init(gpio.port, &GPIO_InitStruct);
	  if (isOutput) {
	    HAL_GPIO_WritePin(gpio.port, gpio.pin, GPIO_PIN_RESET);
	  }

	  return (void*) gpio.port;

}

static inline void* MDD_stm32f4_exti_pin_init(void* handle, int port, int pin, int mode, int preempt_prio, int sub_prio)
{
  	  GPIO_InitTypeDef   GPIO_InitStruct;
	  Gpio gpio;
	  const IRQn_Type irqn[16] = {EXTI0_IRQn, EXTI1_IRQn, EXTI2_IRQn, EXTI3_IRQn, EXTI4_IRQn,
				      EXTI9_5_IRQn, EXTI9_5_IRQn, EXTI9_5_IRQn, EXTI9_5_IRQn, EXTI9_5_IRQn,
				      EXTI15_10_IRQn, EXTI15_10_IRQn, EXTI15_10_IRQn, EXTI15_10_IRQn, EXTI15_10_IRQn, EXTI15_10_IRQn}; 
	  assert_param(port >= 1 && port <= 9);
	  assert_param(pin >= 1 && pin <= 17);
	  /* Enable GPIO clock */
	  switch (port) {
	  case 1:
	    __HAL_RCC_GPIOA_CLK_ENABLE();
	    break;
	  case 2:
	    __HAL_RCC_GPIOB_CLK_ENABLE();
	    break;
	  case 3:
	    __HAL_RCC_GPIOC_CLK_ENABLE();
	    break;
	  case 4:
	    __HAL_RCC_GPIOD_CLK_ENABLE();
	    break;
	  case 5:
	    __HAL_RCC_GPIOE_CLK_ENABLE();
	    break;
	  case 6:
	    __HAL_RCC_GPIOF_CLK_ENABLE();
	    break;
	  case 7:
	    __HAL_RCC_GPIOG_CLK_ENABLE();
	    break;
	  case 8:
	    __HAL_RCC_GPIOH_CLK_ENABLE();
	    break;
	  case 9:
	    __HAL_RCC_GPIOI_CLK_ENABLE();
	    break;
	  }
	  gpio.port = MOD2BSP_Port[port - 1];
	  gpio.pin = MOD2BSP_Pin[pin - 1];
	  /* Configure the GPIO pin */
	  GPIO_InitStruct.Pin = gpio.pin;
	  //GPIO_InitStruct.Mode = MOD2BSP_Mode[mode - 1];
  GPIO_InitStruct.Mode = GPIO_MODE_IT_FALLING;
	  GPIO_InitStruct.Pull = GPIO_NOPULL;

	  HAL_GPIO_Init(gpio.port, &GPIO_InitStruct);
	  HAL_NVIC_SetPriority(irqn[pin - 1], (uint32_t)preempt_prio, (uint32_t)sub_prio);
	  HAL_NVIC_EnableIRQ(irqn[pin - 1]);
	  
	  return (void*) gpio.port;

}

static inline void* MDD_stm32f4_exti_pin_close(void* in_port)
{
}

static inline int MDD_stm32f4_digital_pin_read(void *in_port, int pin)
{
  Gpio gpio;
  gpio.port = (GPIO_TypeDef *)in_port;
  assert_param(pin >= 1 && pin <= 17);
  gpio.pin = MOD2BSP_Pin[pin - 1];
  return (int) HAL_GPIO_ReadPin(gpio.port, gpio.pin);
}

static inline void* MDD_stm32f4_digital_pin_close(void* handle)
{
}

static inline void MDD_stm32f4_digital_pin_write(void *in_port, int pin, int value)
{
  Gpio gpio;
  gpio.port = (GPIO_TypeDef *)in_port;
  assert_param(pin >= 1 && pin <= 17);
  gpio.pin = MOD2BSP_Pin[pin - 1];
  HAL_GPIO_WritePin(gpio.port, gpio.pin, (GPIO_PinState) value);
}


/* convenient functions for LEDs */
const Led_TypeDef MOD2BSP_LED_MAP[4] = {LED3, LED4, LED5, LED6};

static inline void* MDD_stm32f4_led_init(void* handle, int led)
{
  assert_param(led >= 1 && led <=4);
  BSP_LED_Init(MOD2BSP_LED_MAP[led - 1]);
  return (void*)MOD2BSP_LED_MAP[led - 1];
}

static inline void MDD_stm32f4_led_close(void *handle)
{
}


static inline void MDD_stm32f4_led_out(void *handle, int value)
{
  Led_TypeDef led = (Led_TypeDef)handle;
  if (value) {
    BSP_LED_On(led);
  } else {
    BSP_LED_Off(led);
  }
}

#endif
