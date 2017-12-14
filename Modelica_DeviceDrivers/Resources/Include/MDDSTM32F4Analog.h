#ifndef MDDARMANALOG__H
#define MDDARMANALOG__H


#include <main.h>

ADC_HandleTypeDef    AdcHandle;
DAC_HandleTypeDef    DacHandle;

/* Variable used to get converted value */
__IO uint16_t uhADCxConvertedValue[2] = {0,0};
__IO uint16_t uhDACxConvertedValue = 0;

static inline void* MDD_stm32f4_adc_close(void* handle)
{
}
static inline void* MDD_stm32f4_dac_close(void* handle)
{
}

static inline void* MDD_stm32f4_adc_init(void* handle)
{
          ADC_ChannelConfTypeDef sConfig;

 /*##-1- Configure the ADC peripheral #######################################*/
	  int rc = 0;
  AdcHandle.Instance = ADCx;
  
  AdcHandle.Init.ClockPrescaler = ADC_CLOCKPRESCALER_PCLK_DIV2;
  AdcHandle.Init.Resolution = ADC_RESOLUTION_12B;
  AdcHandle.Init.ScanConvMode = ENABLE;
  AdcHandle.Init.ContinuousConvMode = ENABLE;
  AdcHandle.Init.DiscontinuousConvMode = DISABLE;
  AdcHandle.Init.NbrOfDiscConversion = 0;
  AdcHandle.Init.ExternalTrigConvEdge = ADC_EXTERNALTRIGCONVEDGE_NONE;
  AdcHandle.Init.ExternalTrigConv = ADC_EXTERNALTRIGCONV_T1_CC1;
  AdcHandle.Init.DataAlign = ADC_DATAALIGN_RIGHT;
  AdcHandle.Init.NbrOfConversion = 2;
  AdcHandle.Init.DMAContinuousRequests = ENABLE;
  AdcHandle.Init.EOCSelection = DISABLE;
      
  if(HAL_ADC_Init(&AdcHandle) != HAL_OK)
  {
    /* Initialization Error */
    rc = 1;
    return (void*)rc;
  }
  
  /*##-2- Configure ADC regular channel ######################################*/
  /* Note: Considering IT occurring after each number of size of              */
  /*       "uhADCxConvertedValue"  ADC conversions (IT by DMA end             */
  /*       of transfer), select sampling time and ADC clock with sufficient   */
  /*       duration to not create an overhead situation in IRQHandler.        */  
  sConfig.Channel = ADCx_CHANNEL;
  sConfig.Rank = 1;
  sConfig.SamplingTime = ADC_SAMPLETIME_28CYCLES;
  sConfig.Offset = 0;
  
  if(HAL_ADC_ConfigChannel(&AdcHandle, &sConfig) != HAL_OK)
  {
    /* Channel Configuration Error */
    rc = 1;
    return (void*)rc;
  }

  sConfig.Rank = 2;
  sConfig.Channel = ADC_CHANNEL_9;

  if(HAL_ADC_ConfigChannel(&AdcHandle, &sConfig) != HAL_OK)
  {
    /* Channel Configuration Error */
    rc = 1;
    return (void*)rc;
  }
  /*##-3- Start the conversion process and enable interrupt ##################*/
  /* Note: Considering IT occurring after each number of ADC conversions      */
  /*       (IT by DMA end of transfer), select sampling time and ADC clock    */
  /*       with sufficient duration to not create an overhead situation in    */
  /*        IRQHandler. */ 
  if(HAL_ADC_Start_DMA(&AdcHandle, (uint32_t*)&uhADCxConvertedValue, 2) != HAL_OK)
  {
    /* Start Conversation Error */
    rc = 1;
    return (void*)rc;
  }
	  return (void*) rc;

}

static inline void* MDD_stm32f4_dac_init(void* handle)
{
  DAC_ChannelConfTypeDef sConfig;
  DacHandle.Instance = DAC;
  int rc = 0;
    if(HAL_DAC_Init(&DacHandle) != HAL_OK)
  {
    /* Initialization Error */
    rc = 1;
    return (void*)rc;
  }

  /*##-1- DAC channel1 Configuration #########################################*/
  sConfig.DAC_Trigger = DAC_TRIGGER_T6_TRGO;
  sConfig.DAC_OutputBuffer = DAC_OUTPUTBUFFER_ENABLE;

  if(HAL_DAC_ConfigChannel(&DacHandle, &sConfig, DACx_CHANNEL1) != HAL_OK)
  {
    /* Channel configuration Error */
    rc = 1;
    return (void*)rc;
  }

  /*##-2- Enable DAC Channel1 and associated DMA #############################*/
  if(HAL_DAC_Start_DMA(&DacHandle, DACx_CHANNEL1, (uint32_t*)&uhDACxConvertedValue, 1, DAC_ALIGN_8B_R) != HAL_OK)
  {
    /* Start DMA Error */
    rc = 1;
    return (void*)rc;
  }


  return (void*) rc;

}

static inline int MDD_stm32f4_analog_read(void* handle, int channel)
{
  return uhADCxConvertedValue[channel - 1];
}

static inline void MDD_stm32f4_analog_write(void* handle, int value)
{
  uhDACxConvertedValue = (uint16_t) value;
}


#endif
