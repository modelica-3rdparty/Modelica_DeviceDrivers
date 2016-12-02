#ifndef MDDAVRTIMER__H
#define MDDAVRTIMER__H

#if !defined(__AVR__)
#error "The AVR package can only be used when targeting AVR CPUs"
#endif

#include <avr/io.h>
#include <assert.h>

static inline void* MDD_avr_timer_init(int timerSelect, int clockSelect, int clearTimerOnMatch)
{
  static const uint8_t clockSelectTable0[7] = {
    (1<<CS00),
    (1<<CS01),
    0xFF,
    (1<<CS01) | (1<<CS00),
    0xFF,
    (1<<CS02),
    (1<<CS02) | (1<<CS00)
  };
  static const uint8_t clockSelectTable1[7] = {
    (1<<CS10),
    (1<<CS11),
    0xFF,
    (1<<CS11) | (1<<CS10),
    0xFF,
    (1<<CS12),
    (1<<CS12) | (1<<CS10)
  };
  static const uint8_t clockSelectTable2[7] = {
    (1<<CS20),
    (1<<CS21),
    (1<<CS21) | (1<<CS20),
    (1<<CS22),
    (1<<CS22) | (1<<CS20),
    (1<<CS22) | (1<<CS21),
    (1<<CS22) | (1<<CS21) | (1<<CS20),
  };
  switch (timerSelect) {
#if defined(TCCR0)
  case 1: /* Timer 0 */
    if (clockSelectTable0[clockSelect-1] == 0xFF) {
      exit(1);
    }
    TCCR0 |= clockSelectTable0[clockSelect-1] | ((clearTimerOnMatch ? 1 : 0) << WGM01 /* CTC0 */);
    break;
#elif defined(TCCR0B)
  case 1: /* Timer 0 */
    if (clockSelectTable0[clockSelect-1] == 0xFF) {
      exit(1);
    }
    TCCR0B |= clockSelectTable0[clockSelect-1];
    if (clearTimerOnMatch) {
      TCCR0A |= 1 << WGM01 /* CTC0 */;
    }
    break;
#endif
#if defined(TCCR1B)
  case 2: /* Timer 1 */
    if (clockSelectTable1[clockSelect-1] == 0xFF) {
      exit(1);
    }
    TCCR1B |= clockSelectTable1[clockSelect-1] | ((clearTimerOnMatch ? 1 : 0) << WGM12 /* CTC1 */);
    break;
#endif
#if defined(TCCR2B)
  case 3: /* Timer 2 */
    if (clockSelectTable2[clockSelect-1] == 0xFF) {
      exit(1);
    }
    TCCR2B |= clockSelectTable2[clockSelect-1];
    if (clearTimerOnMatch) {
      TCCR2A |= 1 << WGM21 /* CTC2 */;
    }
    break;
#endif
  default:
    exit(1);
  }
  return (void*)timerSelect;
}

static inline void MDD_avr_timer_close(void *avr)
{
}

static inline void* MDD_avr_pwm_init(void *timer, int pin, int initialValue, int inverted)
{
  volatile uint8_t *pwm_port;
  int val;
  // uint8_t old = TCCR1B;
  switch ((int)timer) {
#if defined(TCCR1B)
  case 2: /* Port1 */
    // TCCR1B = 0x00;
#if defined(__AVR_ATmega16__)
    if (pin==1) {
      DDRD |= 1 << PIND4; // OC1A
    } else if (pin==2) {
      DDRD |= 1 << PIND5; // OC1B
    } else {
      exit(1);
    }
#elif defined(__AVR_ATmega328P__)
    if (pin==1) {
      DDRB |= 1 << PINB1; // OC1A
    } else if (pin==2) {
      DDRB |= 1 << PINB2; // OC1B
    } else {
      exit(1);
    }
#else
#warning "PIN controlled by PWM is not known. Needs to be set as output PIN..."
    exit(1);
    /* TODO: Pass a configured Digital output pin to the PWM instead */
#endif
    if (pin==1) {
      if (inverted) {
        TCCR1A |= (1 << WGM10) | (1 << COM1A1) | (1 << COM1A0); // COM1X1=1, COM1X0=1 = Inverting
      } else {
        TCCR1A |= (1 << WGM10) | (1 << COM1A1); // COM1X1=1, COM1X0=0 = Non-inverting
      }
      OCR1A = initialValue;
      pwm_port = &OCR1AL;
    } else if (pin==2) {
      if (inverted) {
        TCCR1A |= (1 << WGM10) | (1 << COM1B1);// COM1X1=1, COM1X0=1 = Inverting
      } else {
        TCCR1A |= (1 << WGM10) | (1 << COM1B1); // COM1X1=1, COM1X0=0 = Non-inverting
      }
      OCR1B = initialValue;
      pwm_port = &OCR1BL;
    } else {
      exit(1);
    }
    *pwm_port = initialValue;
    break;
#endif
  default:
    exit(1);
  }
  return (void*)pwm_port;
}

static inline void MDD_avr_pwm_close(void *pwm)
{
}

static inline void MDD_avr_pwm_set(void *pwm, int value)
{
  volatile uint8_t *pwm_port = (volatile uint8_t *) pwm;
  *pwm_port = value;
}

#endif
