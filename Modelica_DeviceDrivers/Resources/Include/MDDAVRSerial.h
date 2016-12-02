#ifndef MDDAVRSERIAL__H
#define MDDAVRSERIAL__H

#if !defined(__AVR__)
#error "The AVR package can only be used when targeting AVR CPUs"
#endif

#include <stdio.h>

/* Avoid ifdef in all the below macros... */
#if defined(UBRR0H) && !defined(UBRRH)
#define UBRRH UBRR0H
#endif
#if defined(UBRR0L) && !defined(UBRRL)
#define UBRRL UBRR0L
#endif
#if defined(UCSR0A) && !defined(UCSRA)
#define UCSRA UCSR0A
#endif
#if defined(U2X0) && !defined(U2X)
#define U2X U2X0
#endif

static inline void uart_2400(void)
{
#undef BAUD
#define BAUD 2400
#include <util/setbaud.h>
UBRRH = UBRRH_VALUE;
UBRRL = UBRRL_VALUE;
#if USE_2X
UCSRA |= (1 << U2X);
#else
UCSRA &= ~(1 << U2X);
#endif
}

static inline void uart_4800(void)
{
#undef BAUD
#define BAUD 4800
#include <util/setbaud.h>
UBRRH = UBRRH_VALUE;
UBRRL = UBRRL_VALUE;
#if USE_2X
UCSRA |= (1 << U2X);
#else
UCSRA &= ~(1 << U2X);
#endif
}

static inline void uart_9600(void)
{
#undef BAUD
#define BAUD 9600
#include <util/setbaud.h>
UBRRH = UBRRH_VALUE;
UBRRL = UBRRL_VALUE;
#if USE_2X
UCSRA |= (1 << U2X);
#else
UCSRA &= ~(1 << U2X);
#endif
}

static inline void uart_19200(void)
{
#undef BAUD
#define BAUD 19200
#include <util/setbaud.h>
UBRRH = UBRRH_VALUE;
UBRRL = UBRRL_VALUE;
#if USE_2X
UCSRA |= (1 << U2X);
#else
UCSRA &= ~(1 << U2X);
#endif
}

static inline void uart_38400(void)
{
#undef BAUD
#define BAUD 38400
#include <util/setbaud.h>
UBRRH = UBRRH_VALUE;
UBRRL = UBRRL_VALUE;
#if USE_2X
UCSRA |= (1 << U2X);
#else
UCSRA &= ~(1 << U2X);
#endif
}

static inline void uart_57600(void)
{
#undef BAUD
#define BAUD 57600
#include <util/setbaud.h>
UBRRH = UBRRH_VALUE;
UBRRL = UBRRL_VALUE;
#if USE_2X
UCSRA |= (1 << U2X);
#else
UCSRA &= ~(1 << U2X);
#endif
}

static inline void uart_115200(void)
{
#undef BAUD
#define BAUD 115200
#include <util/setbaud.h>
UBRRH = UBRRH_VALUE;
UBRRL = UBRRL_VALUE;
#if USE_2X
UCSRA |= (1 << U2X);
#else
UCSRA &= ~(1 << U2X);
#endif
}

static inline void* MDD_avr_uart_init(int baudRate)
{
  switch (baudRate) {
  case 1: uart_115200(); break;
  case 2: uart_57600(); break;
  case 3: uart_38400(); break;
  case 4: uart_19200(); break;
  case 5: uart_9600(); break;
  case 6: uart_4800(); break;
  case 7: uart_2400(); break;
  }

#if defined(UCSRB) && defined(UCSRC)
  /* URSEL controls which one of UBRRH and UCSRC will be updated. */
  UCSRC |= (1<<URSEL) | (1<<UCSZ1) | (1<<UCSZ0); /* 8-bit data. */
  UCSRB |= (1<<RXEN) | (1<<TXEN); /* Enable RX and TX */
#else
  UCSR0C = (1<<UCSZ01) | (1<<UCSZ00); /* 8-bit data */
  UCSR0B = (1<<RXEN0) | (1<<TXEN0); /* Enable RX and TX */
#endif

  return 0;
}

static inline void MDD_avr_uart_close(void *uart)
{
}

#endif
