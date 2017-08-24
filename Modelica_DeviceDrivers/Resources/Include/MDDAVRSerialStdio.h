#ifndef MDDAVRSERIALSTDIO__H
#define MDDAVRSERIALSTDIO__H

#if !defined(__AVR__)
#error "The AVR package can only be used when targeting AVR CPUs"
#endif

#include <stdio.h>

/* Based on: http://www.cs.mun.ca/~rod/Winter2007/4723/notes/serial/serial.html */

int uart_putchar(char c, FILE *stream);
int uart_getchar(FILE *stream);

FILE uart_output = FDEV_SETUP_STREAM(uart_putchar, NULL, _FDEV_SETUP_WRITE);
FILE uart_input = FDEV_SETUP_STREAM(NULL, uart_getchar, _FDEV_SETUP_READ);

int uart_putchar(char c, FILE *stream)
{
  if (c == '\n') {
    uart_putchar('\r', stream);
  }
#if defined(UDR0)
  loop_until_bit_is_set(UCSR0A, UDRE0);
  UDR0 = c;
#else
  loop_until_bit_is_set(UCSRA, UDRE);
  UDR = c;
#endif
  return 0;
}

int uart_getchar(FILE *stream)
{
#if defined(UDR0)
  loop_until_bit_is_set(UCSR0A, RXC0);
  return UDR0;
#else
  loop_until_bit_is_set(UCSRA, RXC);
  return UDR;
#endif
}

static inline void* MDD_avr_uart_stdio_init(void *uart, int mapIn, int mapOut)
{
  if (mapIn) {
    stdin  = &uart_input;
  }
  if (mapOut) {
    stdout = &uart_output;
  }
  return 0;
}

static inline void MDD_avr_uart_stdio_close(void *uartstdio)
{
}

#endif
