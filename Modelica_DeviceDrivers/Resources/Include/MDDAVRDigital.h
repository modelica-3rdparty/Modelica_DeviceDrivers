#ifndef MDDAVRDIGITAL__H
#define MDDAVRDIGITAL__H

#if !defined(__AVR__)
#error "The AVR package can only be used when targeting AVR CPUs"
#endif

#include <avr/io.h>
#include <util/delay.h>

/* Return only the port and not the pin in order to avoid malloc
 * Trust the user calls the following functions correctly...
 */
static inline void* MDD_avr_digital_pin_init(int port, int pin, int isOutput)
{
  volatile uint8_t *ddr, *res, *inp;
  /*In this function the code to set a pin as input is added, which was not present earlier.
	The variable 'inp' is added for the same.
  */
  switch (port) {
#if defined(PORTA)
  case 1:
    res = &PORTA;
    ddr = &DDRA;
    inp = &PINA;  //The address of 'PINx' is assigned to 'inp', hence can be used to accept input
    break;
#endif
#if defined(PORTB)
  case 2:
    res = &PORTB;
    ddr = &DDRB;
    inp = &PINB;
    break;
#endif
#if defined(PORTC)
  case 3:
    res = &PORTC;
    ddr = &DDRC;
    inp = &PINC;
    break;
#endif
#if defined(PORTD)
  case 4:
    res = &PORTD;
    ddr = &DDRD;
    inp = &PIND;
    break;
#endif
  }
  if (isOutput) {
    *ddr |= (1<<(pin-1));
    return (void*)res;
  } else {
	  //If the pin is of type input then the corresponding pin is set a input using DDR register and returned.
    *ddr &= ~(1<<(pin-1));
    return (void*)inp;
  }
}

static inline void MDD_avr_digital_pin_close(void *in_port)
{
}

static inline int MDD_avr_digital_pin_read(void *in_port, int pin)
{
  volatile uint8_t *port = (volatile uint8_t *) in_port;
  return *port & (1<<(pin-1)) ? 1 : 0;
}

static inline void MDD_avr_digital_pin_write(void *in_port, int pin, int value)
{
  volatile uint8_t *port = (volatile uint8_t *) in_port;
  if (value) {
    *port |= (1<<(pin-1));
  } else {
    *port &= ~(1<<(pin-1));
  }
}

#endif
