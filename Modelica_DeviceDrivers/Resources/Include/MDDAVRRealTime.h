#ifndef MDDAVRREALTIME__H
#define MDDAVRREALTIME__H

#if !defined(__AVR__)
#error "The AVR package can only be used when targeting AVR CPUs"
/* TODO: Add a second mode: count real time taken instead of 1 cycle/tick?
#elif !defined(F_CPU)
#error "Could not determine CPU clock frequency (needed for real-time synchronization)"
*/
#endif

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/atomic.h>
#include <util/delay.h>

static volatile uint16_t numInterruptTriggeredPerCycle=0;

static inline void* MDD_avr_rt_init(void *timer, int value, uint16_t numPerCycle)
{
  numInterruptTriggeredPerCycle=numPerCycle;
  switch ((int)timer) {
#if defined(__AVR_ATmega16__)
  case 1:
    TCCR0 |= 1 << WGM01; /* CTC0 */
    OCR0 = value;
    break;
#elif defined(__AVR_ATmega328P__)
  case 1:
    TCCR0A |= 1 << WGM01; /* CTC0 */
    OCR0A = value;
    break;
#endif
#if defined(__AVR_ATmega16__) || defined(__AVR_ATmega328P__)
  case 2:
    TCCR1B |= 1 << WGM12; /* CTC1 */
    OCR1A = value;
    break;
#endif
#if defined(__AVR_ATmega16__)
  case 3:
  exit(1);
    TCCR2 |= 1 << WGM21; /* CTC2 */
    OCR2 = value;
    break;
#elif defined(__AVR_ATmega328P__)
  case 3:
    TCCR2A |= 1 << WGM21; /* CTC2 */
    OCR2A = value;
    break;
#endif
  default:
    exit(1);
  }

  return timer;
}

static inline void MDD_avr_rt_close(void *rt)
{
}

static volatile char interruptTriggered=0;
static volatile uint16_t numInterruptTriggered=0;

/* The wait routine actually starts the clock.
 * This is done after initialization to avoid weird behaviour
 */
static inline void MDD_avr_rt_wait(void *timer, int isInitial)
{
  if (isInitial) {
    return;
  }
  switch ((int)timer) {
#if defined(__AVR_ATmega16__)
  case 1:
    TCNT0 = 0;
    TIMSK |= (1 << OCIE0); /* Set the ISR COMPA vect */
    break;
#elif defined(TCCR0B) && defined(OCIE0A)
  case 1:
    TCNT0 = 0;
    TIMSK0 |= (1 << OCIE0A); /* Set the ISR COMPA vect */
    break;
#endif
#if defined(__AVR_ATmega16__) || defined(__AVR_ATmega328P__)
  case 2:
    TCNT1 = 0;
#if defined(__AVR_ATmega16__)
    TIMSK |= (1 << OCIE1A); /* Set the ISR COMPA vect */
#else
    TIMSK1 |= (1 << OCIE1A); /* Set the ISR COMPA vect */
#endif
    break;
#endif
#if defined(__AVR_ATmega16__)
  case 3:
    TCNT2 = 0;
    TIMSK |= (1 << OCIE2); /* Set the ISR COMPA vect */
    break;
#elif defined(__AVR_ATmega328P__)
  case 3:
    TCNT2 = 0;
    TIMSK2 |= (1 << OCIE2A); /* Set the ISR COMPA vect */
    break;
#endif
  default:
    exit(1);
  }
  sei();

  int interruptTriggered_Local;
  do {
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
      interruptTriggered_Local = interruptTriggered;
    }
  } while (interruptTriggered_Local==0);
  interruptTriggered = 0;
}

#define MDD_ISR_REALTIME() { \
  numInterruptTriggered++; \
  if (interruptTriggered==1) { \
  } else if (numInterruptTriggered>=numInterruptTriggeredPerCycle) { \
    interruptTriggered = 1; \
    numInterruptTriggered = 0; \
  } \
}

#if defined(TCCR0)
ISR(TIMER0_COMP_vect)
{
  MDD_ISR_REALTIME();
}
#elif defined(TCCR0A)
ISR(TIMER0_COMPA_vect)
{
  MDD_ISR_REALTIME();
}
#endif

#if defined(TCCR1A)
ISR(TIMER1_COMPA_vect)
{
  MDD_ISR_REALTIME();
}
#endif

#if defined(TCCR2A)
ISR(TIMER2_COMPA_vect)
{
  MDD_ISR_REALTIME();
}
#endif

#endif
