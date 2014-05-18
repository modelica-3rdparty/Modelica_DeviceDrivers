/** Support for processing CAN messages in Modelica (header-only library).
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id: MDDCANMessage.h 15940 2012-06-26 08:27:11Z thie_be $
 * @since       2012-06-19
 * @copyright Modelica License 2
 *
*/

#ifndef MDDCANMESSAGE_H_
#define MDDCANMESSAGE_H_

#include <string.h>
#include <stdlib.h>
#include "ModelicaUtilities.h"


typedef struct {
    unsigned char data[8];
} CANMessage;



void* MDD_CANMessageConstructor() {
	CANMessage* msg = (CANMessage*) calloc(1, sizeof(CANMessage)); /* all bits initialized to zero */
	return (void*) msg;
}

void MDD_CANMessageDestructor(void* p_cANMessage) {
	CANMessage* msg = (CANMessage*) p_cANMessage;
	free(msg);
}

/** Print content of message
 * @param[in] p_cANMessage pointer to the CANMessage
 * @param showBitVector additionally to the bytes, print out every single bit
 */
void MDD_CANMessagePrint(void* p_cANMessage, int showBitVector) {
	CANMessage* msg = (CANMessage*) p_cANMessage;
	unsigned char bits[64];
	int i,j;

	ModelicaFormatMessage("CANMessage start:\nBytes signed dec:   ");
    for(j=0; j < 8; j++) {
		ModelicaFormatMessage(" d%d, ", msg->data[j]);
    }
	ModelicaFormatMessage("\nBytes unsigned hex: ");
	for(j=0; j < 8; j++) {
		ModelicaFormatMessage("0x%X, ", msg->data[j]);
    }
	if (showBitVector) {
		    for (i=0; i<8; i++) {
				bits[i*8 + 0] = msg->data[i] & 0x01;
				bits[i*8 + 1] = (msg->data[i] & 0x02) >> 1;
				bits[i*8 + 2] = (msg->data[i] & 0x04) >> 2;
				bits[i*8 + 3] = (msg->data[i] & 0x08) >> 3;
				bits[i*8 + 4] = (msg->data[i] & 0x10) >> 4;
				bits[i*8 + 5] = (msg->data[i] & 0x20) >> 5;
				bits[i*8 + 6] = (msg->data[i] & 0x40) >> 6;
				bits[i*8 + 7] = (msg->data[i] & 0x80) >> 7;
			}
		ModelicaFormatMessage("\nBit vector:\n");
		for (i=0; i < 64; i++)  ModelicaFormatMessage("%2d,", i); ModelicaFormatMessage("\n");
		for (i=0; i < 64; i++)  ModelicaFormatMessage("%2d ", bits[i]);
	}
    ModelicaFormatMessage("\nCANMessage end.");
}

/** Unpack integer value from CAN data (using Intel endianness).
 *
 * @TODO: This function should be improved (performance and functionality, e.g. endiannes support)
 * @NOTE: We have little endian on x86
 *
 * @param[in] p_cANMessage pointer to the CANMessage
 * @param[in] bitStartPosition data bit position where reading shall start (min=0)
 * @param[in] width bit-width of region encoding the integer value
 * @return value of extracted integer
 */
int MDD_CANMessageIntegerBitunpacking(void* p_cANMessage, int bitStartPosition, int width) {
	CANMessage* msg = (CANMessage*) p_cANMessage;
    unsigned char bits[64];
    int i,j;
    int factor = 1;
    int data = 0;

    for (i=0; i<8; i++) {
	bits[i*8 + 0] = msg->data[i] & 0x01;
	bits[i*8 + 1] = (msg->data[i] & 0x02) >> 1;
	bits[i*8 + 2] = (msg->data[i] & 0x04) >> 2;
	bits[i*8 + 3] = (msg->data[i] & 0x08) >> 3;
	bits[i*8 + 4] = (msg->data[i] & 0x10) >> 4;
	bits[i*8 + 5] = (msg->data[i] & 0x20) >> 5;
	bits[i*8 + 6] = (msg->data[i] & 0x40) >> 6;
	bits[i*8 + 7] = (msg->data[i] & 0x80) >> 7;
    }

    for (i=bitStartPosition, j=0; i < bitStartPosition + width; i++, j++) {
	data = data + bits[i]*factor;
	factor = 2 << j;
    }

    return data;
}


/** Pack integer value into CAN data (using Intel endianness).
 *
 * @TODO: This function should be improved (performance and functionality, e.g. endiannes support)
 * @NOTE: We have little endian on x86
 *
 * @param[in] p_cANMessage pointer to the CANMessage
 * @param[in] bitStartPosition data bit position where writing shall start (min=0)
 * @param[in] width bit-width of region encoding the integer value
 * @param[in] data integer value that shall be encoded into CAN message
 */
void MDD_CANMessageIntegerBitpacking(void* p_cANMessage, int bitStartPosition, int width, int data) {
	CANMessage* msg = (CANMessage*) p_cANMessage;
    unsigned char bits[64];
    int i;
    int j=0;
    int base_i;
    int rem_i;
    for (i=0; i<64; i++) bits[i] = 0;
    for (i=bitStartPosition, j=0; i < bitStartPosition + width; i++, j++) {
	bits[(bitStartPosition + j)] = 0x0001 & (data >> j);
	base_i = i / 8;
	rem_i  = i % 8;
	if (bits[i]) {
	    /* set bit */
	    msg->data[base_i] |= (1 << rem_i);
	} else {
	    /* unset bit */
	    msg->data[base_i] &= ~(1 << rem_i);
	}

    }
}

/** Pack IEEE float value into CAN data.
 *
 * @param[in] p_cANMessage pointer to the CANMessage
 * @param[in] bitStartPosition data bit position where writing shall start (min=0, max=32)
 * @param[in] data float value that shall be encoded into CAN message
 *            (passsed in as double in order to conform to Modelica's external function interface)
 */
void MDD_CANMessageFloatBitpacking(void* p_cANMessage, int bitStartPosition, double data) {
	CANMessage* msg = (CANMessage*) p_cANMessage;
	float fdata = (float)data;
	int byteStartPosition = bitStartPosition / 8;
	int byteBitOffset = bitStartPosition % 8;
	unsigned char floatData[4];
	unsigned int i, j;

	ModelicaFormatMessage("Packing byteStartPosition: %d, byteBitOffset: %d\n", byteStartPosition, byteBitOffset);

	if (bitStartPosition > 32) {
		ModelicaFormatError("MDDCANMessage: Error: Bit start position for writing IEEE float > 32 => size(float) exceeds message size!\n");
		exit(-1);
	}

	if (byteBitOffset != 0) {
		/* Need to assemble the float which is not aligned to the byte borders! */
		memcpy(floatData, &fdata, sizeof(float));
		for (i=byteStartPosition, j=0; i < byteStartPosition+sizeof(float); i++, j++) {
			/* Need to preserve the first byteBitOffset-1 bits in msg->data[i] and overwrite the remaining with the bits from data */
			msg->data[i] = ( (msg->data[i] >> (8-byteBitOffset)) << (8-byteBitOffset) ) | (floatData[j] >> byteBitOffset);
			/* Need to overwrite the first byteBitOffset bits in msg->data[i+1] and preserve the remaining bits of msg->data[i+1] */
			msg->data[i+1] = ( (msg->data[i+1] << byteBitOffset) >> byteBitOffset ) | (floatData[j] << (8-byteBitOffset));
		}
	} else {
		/* Float aligned to byte borders. That should be easy */
		memcpy(&(msg->data[byteStartPosition]), &fdata, sizeof(float));
	}
}

/** Unpack IEEE float value from CAN data.
 *
 * @param[in] p_cANMessage pointer to the CANMessage
 * @param[in] bitStartPosition data bit position where reading shall start (min=0)
 * @return value of extracted IEEE float converted to double in order to support Modelica's external function interface
 */
double MDD_CANMessageFloatBitunpacking(void* p_cANMessage, int bitStartPosition) {
	CANMessage* msg = (CANMessage*) p_cANMessage;
	float data;
	int byteStartPosition = bitStartPosition / 8;
	int byteBitOffset = bitStartPosition % 8;
	unsigned char floatData[4];
	unsigned int i, j, lower, upper;

	if (bitStartPosition > 32) {
		ModelicaFormatError("MDDCANMessage: Error: Bit start position for reading IEEE float > 32 => size(float) exceeds message size!\n");
		exit(-1);
	}

	if (byteBitOffset != 0) {
		/* Need to assemble the float which is not aligned to the byte borders! */
		for (i=byteStartPosition, j=0; i < byteStartPosition+sizeof(float); i++, j++) {
			lower = (msg->data[i] << byteBitOffset);
			upper = (msg->data[i+1] >> (8-byteBitOffset));
			floatData[j] = lower | upper;
		}
		memcpy(&data, floatData, sizeof(float));
	} else {
		/* Float aligned to byte borders. That should be easy */
		memcpy(&data, &(msg->data[byteStartPosition]), sizeof(float));
	}
    return (double)data;
}


/** Pack IEEE double value into CAN data.
 *
 * @param[in] p_cANMessage pointer to the CANMessage
 * @param[in] data double value that shall be encoded into CAN message
 */
void MDD_CANMessageDoubleBitpacking(void* p_cANMessage, double data) {
	CANMessage* msg = (CANMessage*) p_cANMessage;

	memcpy(msg->data, &data, sizeof(double));
}

/** Unpack IEEE double value from CAN data.
 *
 * @param[in] p_cANMessage pointer to the CANMessage
 * @return value of extracted IEEE double
 */
double MDD_CANMessageDoubleBitunpacking(void* p_cANMessage) {
	CANMessage* msg = (CANMessage*) p_cANMessage;
	double data;

	memcpy(&data, msg->data, sizeof(double));
    return data;
}

#endif /* MDDCANMESSAGE_H_ */




