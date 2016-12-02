#ifndef MDDAVRANALOG__H
#define MDDAVRANALOG__H

#if !defined(__AVR__)
#error "The AVR package can only be used when targeting AVR CPUs"
#endif

#include <avr/io.h>

/* Some sanity checks for the numering of the ADC ports */
#if ADC0!=0
#error "Assuming ADC0==0"
#endif
#if defined(ADC1) && ADC1!=1
#error "Assuming ADC1==1"
#endif
#if defined(MUX3) && defined(ADC7) && ADC7!=7
#error "Assuming ADC15==15"
#endif
#if defined(MUX4) && defined(ADC8) && ADC8!=8
#error "Assuming ADC8==8"
#endif
#if defined(MUX4) && defined(ADC15) && ADC15!=15
#error "Assuming ADC15==15"
#endif

static inline int MDD_avr_analog_read_8bit(int analogPort)
{
  /* select ADC channel with safety mask; only sets bits 1..5
   * and also sets ADLAR to get only 8-bit resolution of the ADC */
  ADMUX = (ADMUX & 0xE0) | ADLAR | ((analogPort-1) & 0x0F);
  /* Start single conversion */
  ADCSRA |= (1<<ADSC);
  /* wait until ADC conversion is complete */
  while (ADCSRA & (1<<ADSC));
  return ADCH;
}

static inline uint16_t read_adc_16bit(int analogPort)
{
  /* select ADC channel with safety mask; only sets bits 1..5
   * and also clears ADLAR to get the full resolution of the ADC */
  ADMUX = (ADMUX & (0xE0 ^ ADLAR)) | ((analogPort-1) & 0x0F);
  /* Start single conversion */
  ADCSRA |= (1<<ADSC);
  /* wait until ADC conversion is complete */
  while (ADCSRA & (1<<ADSC));
  return ADC;
}

static inline double MDD_avr_analog_read_float(int analogPort)
{
  return read_adc_16bit(analogPort);
}
static inline double MDD_avr_analog_read(int analogPort, double vref, int voltageResolution)
{
  return (read_adc_16bit(analogPort)*vref)/((1L<<voltageResolution)-1);
}

static inline void* MDD_avr_analog_init(int divisionFactor, int referenceVoltage)
{
#if defined(__AVR_ATmega328__) || (defined(ADCSRA) && defined(ADPS2) && defined(ADPS1) && defined(ADPS0) && defined(ADEN) && defined(REFS0) && defined(REFS1))
  static const int divisionFactorTable[7] = {
    (1<<ADPS0)|(1<<ADEN),
    (1<<ADPS1)|(1<<ADEN),
    (1<<ADPS1)|(1<<ADPS0)|(1<<ADEN),
    (1<<ADPS2)|(1<<ADEN),
    (1<<ADPS2)|(1<<ADPS0)|(1<<ADEN),
    (1<<ADPS2)|(1<<ADPS1)|(1<<ADEN),
    (1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0)|(1<<ADEN)
  };
  static const int referenceVoltageTable[4] = {
    0,
    (1<<REFS0),
    (1<<REFS1),
    (1<<REFS1)|(1<<REFS0)
  };
  ADMUX |= referenceVoltageTable[referenceVoltage-1];
  ADCSRA |= divisionFactorTable[divisionFactor-1];
#else
  #error "Unknown AVR device. Could not generate analog IO code"
#endif
  return 0;
}

static inline void MDD_avr_analog_close(void *avr)
{
}

#endif
