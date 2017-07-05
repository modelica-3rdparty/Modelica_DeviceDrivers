/**
  *	File: ext_callback.c
  *
  *	Description: User file for callback function for external GPIO interrupt
  *
  *	Author: Lutz Berger (Berger IT-COSMOS GmbH)
  *
  *	Date: 03.07.2017
  *
  *
  *
  *     Remark: This is currently a workaround, as long as openmodelica is not able to create callback code
  *
  */      

#include <main.h>

/**
  * @brief EXTI line detection callbacks
  * @param GPIO_Pin: Specifies the pins connected EXTI line
  * @retval None
  */
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
  if(GPIO_Pin == KEY_BUTTON_PIN)
  {
    /* Toggle LED3 */
    BSP_LED_Toggle(LED3);
    /* Toggle LED4 */
    BSP_LED_Toggle(LED4);    
    /* Toggle LED5 */
    BSP_LED_Toggle(LED5);   
    /* Toggle LED6 */
    BSP_LED_Toggle(LED6);
  }
}
