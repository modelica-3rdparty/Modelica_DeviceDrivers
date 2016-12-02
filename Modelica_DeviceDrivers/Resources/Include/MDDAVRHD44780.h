#ifndef MDDAVRHD44780__H
#define MDDAVRHD44780__H

#if !defined(__AVR__)
#error "The AVR package can only be used when targeting AVR CPUs"
#endif

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <assert.h>

static char buffer[32] = {
  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
};

static inline void enable(volatile uint8_t *port)
{
  *port|=0x04;
}

static inline void disable(volatile uint8_t *port)
{
  *port&=0xFB;
}

static inline void strobe(volatile uint8_t *port)
{
  enable(port);
  disable(port);
}

/* Extract upper/lower nibble */
static inline unsigned char upper(uint8_t data)
{
  return (data) & 0xF0;
}

static inline unsigned char lower(uint8_t data)
{
  return ((data) & 0x0F) << 4;
}

/* Transfer command to LCD */
static inline unsigned char data_transfer(volatile uint8_t *port, unsigned char upper,unsigned char lower)
{
  (*port) &= 0x0F;
  (*port) |= upper;
  strobe(port);

  (*port) &= 0x0F;
  (*port) |= lower;
  strobe(port);
  _delay_ms(1);
}

/* Transfer data to LCD */
static inline unsigned char lcd_data_transfer(volatile uint8_t *port, unsigned char upper,unsigned char lower)
{
  (*port) |= 0x01;
  (*port) &= 0x0F;

  (*port) |= upper;
  strobe(port);


  (*port) &= 0x0F;
  (*port) |= lower;
  strobe(port);

  _delay_us(50);
}

/* Switching to next line of LCD */
static inline void goto_nextline(volatile uint8_t *port)
{
  _delay_us(1);

  (*port) &= 0xFE;
  data_transfer(port,0xC0,0x00);
}

static inline void refresh_lcd(volatile uint8_t *port)
{
  _delay_us(1);
  data_transfer(port,0x00,0x10);
  _delay_ms(1);
}

static inline void update_lcd(volatile uint8_t *port)
{
  int i;
  refresh_lcd(port);
  for(i=0; i<16; i++) {
    lcd_data_transfer(port,upper(buffer[i]),lower(buffer[i]));
  }
  goto_nextline(port);
  for(i=16; i<32; i++) {
    lcd_data_transfer(port,upper(buffer[i]),lower(buffer[i]));
  }
}

void* MDD_avr_digitial_HD44780_init(int port_int, const char *text)
{
  volatile uint8_t *port=0;
  switch (port_int) {
  case 1:
    PORTA = 0x00;
    DDRA = 0xFF;
    port = &PORTA;
    break;
  case 2:
    PORTB = 0x00;
    DDRB = 0xFF;
    port = &PORTB;
    break;
  case 3:
    PORTC = 0x00;
    DDRC = 0xFF;
    port = &PORTC;
    break;
  default:
    assert(0);
  }
  for (int i=0; i<32; i++) {
    buffer[i] = text[i];
  }

  (*port)&=0xFB;
  (*port)&=0x0F;
  (*port)&=0xFE;

  data_transfer(port,0x20,0x80);
  data_transfer(port,0x00,0xE0);
  data_transfer(port,0x00,0x60);

  update_lcd(port);

  return (void*)port;
}

void MDD_avr_digitial_HD44780_close(void *lcd)
{
}

static inline void MDD_avr_digitial_HD44780_updateTextBufferByte(void *lcd, int index, int data)
{
  buffer[index-1] = data;
}

void MDD_avr_digitial_HD44780_updateDisplay(void *lcd)
{
  volatile uint8_t *port= (volatile uint8_t *) lcd;
  update_lcd(port);
}

#endif
