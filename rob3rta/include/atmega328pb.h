
// additional register definitions ATmega328P <-> ATmega328PB

#define PINE _SFR_MEM8(0x2C)
#define DDRE _SFR_MEM8(0x2D)
#define PORTE _SFR_MEM8(0x2E)



#define UDR1 _SFR_MEM8(0xC7)
#define UDR1_0 0
#define UDR1_1 1
#define UDR1_2 2
#define UDR1_3 3
#define UDR1_4 4
#define UDR1_5 5
#define UDR1_6 6
#define UDR1_7 7

#define UCSR1A _SFR_MEM8(0xC8)
#define MPCM1 0
#define U2X1 1
#define UPE1 2
#define DOR1 3
#define FE1 4
#define UDRE1 5
#define TXC1 6
#define RXC1 7

#define UCSR1B _SFR_MEM8(0xC9)
#define TXB81 0
#define RXB81 1
#define UCSZ12 2
#define TXEN1 3
#define RXEN1 4
#define UDRIE1 5
#define TXCIE1 6
#define RXCIE1 7

#define UCSR1C _SFR_MEM8(0xCA)
#define UCPOL1 0
#define UCSZ10 1
#define UCPHA1 1
#define UCSZ11 2
#define UDORD1 2
#define USBS1 3
#define UPM10 4
#define UPM11 5
#define UMSEL10 6
#define UMSEL11 7

#define UBRR1 _SFR_MEM16(0xCC)

#define UBRR1L _SFR_MEM8(0xCC)
#define UBRR1_0 0
#define UBRR1_1 1
#define UBRR1_2 2
#define UBRR1_3 3
#define UBRR1_4 4
#define UBRR1_5 5
#define UBRR1_6 6
#define UBRR1_7 7

#define UBRR1H _SFR_MEM8(0xCD)
#define UBRR1_8 0
#define UBRR1_9 1
#define UBRR1_10 2
#define UBRR1_11 3



#define TCCR3A _SFR_MEM8(0x90)
#define TCCR3B _SFR_MEM8(0x91)
#define TCCR3C _SFR_MEM8(0x92)

#define TCNT3 _SFR_MEM16(0x94)
#define TCNT3L _SFR_MEM8(0x94)
#define TCNT3H _SFR_MEM8(0x95)

#define ICR3 _SFR_MEM16(0x96)
#define ICR3L _SFR_MEM8(0x96)
#define ICR3H _SFR_MEM8(0x97)

#define OCR3A _SFR_MEM16(0x98)
#define OCR3AL _SFR_MEM8(0x98)
#define OCR3AH _SFR_MEM8(0x99)

#define OCR3B _SFR_MEM16(0x9a)
#define OCR3BL _SFR_MEM8(0x9a)
#define OCR3BH _SFR_MEM8(0x9b)


/* OSCAL */
#define OSCAL _SFR_MEM8(0x66)



/* INTERRUPTS */

#define USART0_RX_vect_num 18
#define USART0_RX_vect     _VECTOR(18)  /* USART0 Rx Complete */

#define USART0_UDRE_vect_num   19
#define USART0_UDRE_vect   _VECTOR(19)  /* USART0, Data Register Empty */

#define USART0_TX_vect_num 20
#define USART0_TX_vect     _VECTOR(20)  /* USART0 Tx Complete */

#define USART1_RX_vect_num 30
#define USART1_RX_vect     _VECTOR(30)  /* USART1 Rx Complete */

#define USART1_UDRE_vect_num   31
#define USART1_UDRE_vect   _VECTOR(31)  /* USART1, Data Register Empty */

#define USART1_TX_vect_num 32
#define USART1_TX_vect     _VECTOR(32)  /* USART1 Tx Complete */

#define USART1_START_vect_num 33
#define USART1_START_vect     _VECTOR(33)  /* USART1 Start Frame Detected */
