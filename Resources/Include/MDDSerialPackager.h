/** Serial packager to be used in Modelica (header-only library).
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @since       2012-07-10
 * @copyright Modelica License 2
 *
 * The first version of the packager ("MinimalSerialPackager") was written by Tobias Bellmann <tobias.bellmann@dlr.de>.
 *
 *
*/

#ifndef MDDSERIALPACKAGER_H_
#define MDDSERIALPACKAGER_H_

#include <string.h>
#include <stdlib.h>
#include <stddef.h>
#include <assert.h>
#include "../src/include/CompatibilityDefs.h"
#include "ModelicaUtilities.h"


typedef struct {
        unsigned int pos;
        unsigned int bitOffset;
        unsigned int size;
        unsigned char* data;
} SerialPackager;


/** External object constructor for SerialPackager.
 *
 * @param[in] size size in bytes of package data
 * @return pointer to external SerialPackager object
 */
DllExport void* MDD_SerialPackagerConstructor(int size) {
        SerialPackager* pkg = (SerialPackager*) calloc(1, sizeof(SerialPackager)); /* all bits initialized to zero */
        pkg->data = (unsigned char*) calloc(size, sizeof(unsigned char));
        pkg->pos = 0;
        pkg->bitOffset = 0;
        pkg->size = size;
        return (void*) pkg;
}

DllExport void MDD_SerialPackagerDestructor(void* p_package) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        free(pkg->data);
        free(pkg);
}

/** Set byte position in package (if bit offset != 0 it will be set to 0).
 */
DllExport void MDD_SerialPackagerSetPos(void* p_package, int pos) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        pkg->pos = (unsigned int) pos;
        pkg->bitOffset = 0;
}

/** Get byte position in package.
 */
DllExport int MDD_SerialPackagerGetPos(void* p_package) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        return pkg->pos;
}

/** Get bit offset in package.
 */
DllExport int MDD_SerialPackagerGetBitOffset(void* p_package) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        return pkg->bitOffset;
}

/** Get size of package data buffer.
 */
DllExport int MDD_SerialPackagerGetSize(void* p_package) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        return pkg->size;
}

/** Get pointer to the packagers payload data.
 *
 * @param[in] p_package pointer to the SerialPackager.
 * @return pointer to the payload.
 */
DllExport const char *  MDD_SerialPackagerGetData(void* p_package) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        return (const char*)pkg->data;
}

/** Copy data into the packager's payload data buffer.
 *
 * If @c size is smaller than the physical size of the payload buffer, the
 * buffers @c size variable is silently set to the smaller size. If @c size is bigger,
 * the function exits with an error message.
 *
 * The packager's @c pos and @c bitOffset variables are set to 0.
 *
 * @param[in,out] p_package pointer to the SerialPackager.
 * @param[in] data pointer the data that shall be copied into the packager's payload data buffer.
 * @param[in] size number of bytes that shall be copied.
 */
DllExport void MDD_SerialPackagerSetData( void* p_package, const char * data, int size) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        memcpy(pkg->data, data,  size);
        if ( (unsigned int) size > pkg->size) {
                ModelicaFormatError("SerialPackager: MDD_SerialPackagerSetData failed. Buffer overflow. Exiting.\n");
                exit(-1);
        }
        pkg->size = size;
        pkg->pos = 0;
        pkg->bitOffset = 0;
}


/** Print content of package.
 * @param[in] p_packager pointer to the SerialPackager
 */
DllExport void MDD_SerialPackagerPrint(void* p_package) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        unsigned int j;

        ModelicaFormatMessage("SerialPackager start: size %d, pos %d, bitOffset %d\n", pkg->size, pkg->pos, pkg->bitOffset);
        ModelicaFormatMessage("Bytes signed dec:   ");
        for(j=0; j < pkg->size; j++) {
                ModelicaFormatMessage(" d%d, ", pkg->data[j]);
        }
        ModelicaFormatMessage("\nBytes unsigned hex: ");
        for(j=0; j < pkg->size; j++) {
                ModelicaFormatMessage("0x%X, ", pkg->data[j]);
        }
        ModelicaFormatMessage("\nSerialPackager end.\n");
}

/** Set payload bytes to 0. Reset pos and bitOffset to 0.
 */
DllExport void MDD_SerialPackagerClear(void* p_package) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        memset(pkg->data,0, pkg->size);
        pkg->pos = 0;
        pkg->bitOffset = 0;
}

/** If there is a bit offset, align pos to next byte boundery after bit offset
 */
DllExport void MDD_SerialPackagerAlignToByteBoundery(SerialPackager* p_package) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        pkg->pos += pkg->bitOffset % 8 == 0 ?
                        pkg->bitOffset / 8 :
                        pkg->bitOffset / 8 + 1;
        pkg->bitOffset = 0;
}

/** Add integer array at current byte position.
 *
 * If p_package->bitOffset != 0 the value is aligned to the next byte boundery,
 * i.e., p_package->bitOffset set to 0 and p_package->pos++.
 * @param[in,out] p_package pointer to the SerialPackager
 * @param[in] u array of integer values
 * @param[in] n number of values in u
 */
DllExport void MDD_SerialPackagerAddInteger(void* p_package, int * u, size_t n) {
        SerialPackager* pkg = (SerialPackager*) p_package;

        if (pkg->bitOffset != 0) MDD_SerialPackagerAlignToByteBoundery(pkg);
        if (pkg->pos + n*sizeof(int) > pkg->size) {
                ModelicaFormatError("SerialPackager: MDD_SerialPackagerAddInteger failed. Buffer overflow. Exiting.+\n");
                exit(-1);
        }
        memcpy(pkg->data + pkg->pos, u, n*sizeof(int));
        pkg->pos += n*sizeof(int);
}

/** Get integer array at current byte position.
 *
 * If p_package->bitOffset != 0 the value is read from the next byte boundery,
 * i.e., p_package->bitOffset set to 0 and p_package->pos++.
 *
 * @param[in,out] p_package pointer to the SerialPackager
 * @param[out] y array of integer values
 * @param[in] n requested number of integer values
 *
 */
DllExport void MDD_SerialPackagerGetInteger(void* p_package, int * y, int n) {
        SerialPackager* pkg = (SerialPackager*) p_package;

        if (pkg->bitOffset != 0) MDD_SerialPackagerAlignToByteBoundery(pkg);
        if (pkg->pos + n*sizeof(int) > pkg->size) {
                ModelicaFormatError("SerialPackager: MDD_SerialPackagerGetInteger failed. Buffer overflow. Exiting.\n");
                exit(-1);
        }
        memcpy(y, pkg->data + pkg->pos, n*sizeof(int));
        pkg->pos += n*sizeof(int);

}

/** Add double array at current byte position.
 *
 * If p_package->bitOffset != 0 the value is aligned to the next byte boundery,
 * i.e., p_package->bitOffset set to 0 and p_package->pos++.
 * @param[in,out] p_package pointer to the SerialPackager
 * @param[in] u array of double values
 * @param[in] n number of values in u
 */
DllExport void MDD_SerialPackagerAddDouble(void* p_package, double * u, size_t n) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        if (pkg->bitOffset != 0) MDD_SerialPackagerAlignToByteBoundery(pkg);
        if (pkg->pos + n*sizeof(double) > pkg->size) {
                ModelicaFormatError("SerialPackager: MDD_SerialPackagerAddDouble failed. Buffer overflow. Exiting.\n");
                exit(-1);
        }
        memcpy(pkg->data + pkg->pos, u, n*sizeof(double));
        pkg->pos += n*sizeof(double);
}

/** Get double array at current byte position.
 *
 * If p_package->bitOffset != 0 the value is read from to the next byte boundery,
 * i.e., p_package->bitOffset set to 0 and p_package->pos++.
 * @param[in,out] p_package pointer to the SerialPackager
 * @param[out] y array of double values
 * @param[in] n requested number of values
 *
 */
DllExport void MDD_SerialPackagerGetDouble(void* p_package, double * y, int n) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        if (pkg->bitOffset != 0) MDD_SerialPackagerAlignToByteBoundery(pkg);
        if (pkg->pos + n*sizeof(double) > pkg->size) {
                ModelicaFormatError("SerialPackager: MDD_SerialPackagerGetDouble failed. Buffer overflow. Exiting.\n");
                exit(-1);
        }
        memcpy(y, pkg->data + pkg->pos, n*sizeof(double));
        pkg->pos += n*sizeof(double);
}

/** Cast double array values to float values and add them as float array at current byte position.
 *
 * If p_package->bitOffset != 0 the value is aligned to the next byte boundery,
 * i.e., p_package->bitOffset set to 0 and p_package->pos++.
 * @param[in,out] p_package pointer to the SerialPackager
 * @param[in] u array of double values that will be casted to float values before adding them
 * @param[in] n number of values in u
 */
DllExport void MDD_SerialPackagerAddDoubleAsFloat(void* p_package, double * u, size_t n) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        size_t i;
        float castedDouble;
        if (pkg->bitOffset != 0) MDD_SerialPackagerAlignToByteBoundery(pkg);
        if (pkg->pos + n*sizeof(float) > pkg->size) {
                ModelicaFormatError("SerialPackager: MDD_SerialPackagerAddDoubleAsFloat failed. Buffer overflow. Exiting.\n");
                exit(-1);
        }
        for (i = 0; i < n; i++) {
                castedDouble = (float) u[i];
                memcpy(pkg->data + pkg->pos + i*sizeof(float), &castedDouble, sizeof(float));
        }
        pkg->pos += n*sizeof(float);
}

/** Get double array which consists of the values of the float array at current byte position casted to type double.
 *
 * If p_package->bitOffset != 0 the value is read from to the next byte boundery,
 * i.e., p_package->bitOffset set to 0 and p_package->pos++.
 * @param[in,out] p_package pointer to the SerialPackager
 * @param[out] y array of double values
 * @param[in] n requested number of values
 *
 */
DllExport void MDD_SerialPackagerGetFloatAsDouble(void* p_package, double * y, int n) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        int i;
        float value;
        if (pkg->bitOffset != 0) MDD_SerialPackagerAlignToByteBoundery(pkg);
        if (pkg->pos + n*sizeof(float) > pkg->size) {
                ModelicaFormatError("SerialPackager: MDD_SerialPackagerGetFloatAsDouble failed. Buffer overflow. Exiting.\n");
                exit(-1);
        }
        for (i = 0; i < n; i++) {
                memcpy(&value, pkg->data + pkg->pos + i*sizeof(float), sizeof(float));
                y[i] = (double) value;
        }
        pkg->pos += n*sizeof(float);
}



/** Add string at current byte position.
 *
 * If p_package->bitOffset != 0 the value is aligned to the next byte boundery,
 * i.e., p_package->bitOffset set to 0 and p_package->pos++.
 * @param[in,out] p_package pointer to the SerialPackager
 * @param[in] u zero terminated string
 * @param[in] bufferSize that was reserved for that string
 */
DllExport void MDD_SerialPackagerAddString(void* p_package, const char* u, int bufferSize) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        //unsigned int size = (strlen(u)+1)*sizeof(char);

        if (pkg->bitOffset != 0) MDD_SerialPackagerAlignToByteBoundery(pkg);
        if (pkg->pos + bufferSize > pkg->size) {
		ModelicaFormatMessage("pkg->size: %d, pkg->pos+bufferSize: %d, bufferSize: %d, strlen(u): %d\n",
				      pkg->size, pkg->pos+bufferSize, bufferSize, strlen(u));
                ModelicaFormatError("SerialPackager: MDD_SerialPackagerAddString failed. Buffer overflow. Exiting.+\n");
                exit(-1);
        }
        memcpy(pkg->data + pkg->pos, u, bufferSize);
        pkg->pos += bufferSize;
}


/** Get string from current byte position.
 *
 * If p_package->bitOffset != 0 the value is aligned to the next byte boundery,
 * i.e., p_package->bitOffset set to 0 and p_package->pos++.
 * @param[in,out] p_package pointer to the SerialPackager
 * @param[out] y pointer to '\0' terminated string or NULL if no terminated '\0' found in package data.
 * @param[in] bufferSize that was reserved for that string
 */
DllExport char* MDD_SerialPackagerGetString(void* p_package, int bufferSize) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        char* y;
        unsigned int i, found = 0;
        if (pkg->bitOffset != 0) MDD_SerialPackagerAlignToByteBoundery(pkg);

        if (pkg->pos + bufferSize > pkg->size) {
                ModelicaFormatError("SerialPackager: MDD_SerialPackagerGetString failed. Buffer overflow. Exiting.\n");
                exit(-1);
        }

        for (i=pkg->pos; i < pkg->pos + bufferSize; i++) {
                if (pkg->data[i] == '\0') {
                        found = 1;
                        break;
                }
        }

        if (!found) {
                ModelicaFormatError("SerialPackager: MDD_SerialPackagerGetString failed. No terminating '\0' found in buffer\n");
                y = NULL;
        } else {
                y = (char*) &(pkg->data[ pkg->pos ]);
				/** TODO: Consider using ModelicaAllocateString() instead of (more efficient) direct buffer pointer, in order to be Modelica standard compliant */
			    /* y = ModelicaAllocateString(i - pkg->pos);  // Modelica standard compliant form for Strings returned back to Modelica environment
				   memcpy(y, &(pkg->data[ pkg->pos ]), i - pkg->pos); */
                pkg->pos += bufferSize;
        }
        return (char*)y;
}


/** Unpack integer value from package relative to current BYTE position (using Intel endianness).
 *
 * @Note: This function could be improved (performance and functionality, e.g. signed values, endiannes support).
 * We have little endian on x86
 *
 * @param[in,out] p_package pointer to the SerialPackager
 * @param[in] bitOffset data bit offset (relative to current BYTE position) where reading shall start (min=0)
 * @param[in] width bit-width of region encoding the integer value (max=32)
 * @return Extracted integer value
 */
DllExport int MDD_SerialPackagerIntegerBitunpack(void* p_package, int bitOffset, int width) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        unsigned char bits[32];
        unsigned int i,j, posEnd, posStart, factor = 1, data = 0;
		/*ModelicaFormatMessage("SerialPackager: bitOffset: %d, width: %d, pkg->pos: %d, pkg->bitOffset: %d\n",
			bitOffset, width, pkg->pos, pkg->bitOffset);*/
        if (width > 32) {
                ModelicaFormatError("SerialPackager: MDD_SerialPackagerIntegerBitunpacking failed."
                "width > 32. Exiting.\n");
                exit(-1);
        }

        if ((unsigned int) bitOffset < pkg->bitOffset) {
                ModelicaFormatError("SerialPackager: Cowardly refusing to start reading at bitOffset %d "
                "which is lower than the current Packager bitOffset %d. Exiting.\n", bitOffset, pkg->bitOffset);
                exit(-1);
        }

        posStart = pkg->pos + bitOffset / 8;
        posEnd = (bitOffset + width) % 8 == 0 ? pkg->pos + (bitOffset + width) / 8 : pkg->pos + (bitOffset + width) / 8 + 1;
		/*ModelicaFormatMessage("posStart: %d, posEnd: %d, pkg->size: %d\n", posStart, posEnd, pkg->size);*/
        if (posEnd > pkg->size) {
                ModelicaFormatError("SerialPackager: MDD_SerialPackagerIntegerBitunpacking failed. Buffer overflow.\n");
                exit(-1);
        }
        for (j=posStart, i=0; j < posEnd; i++, j++) {
                bits[i*8 + 0] =  pkg->data[j] & 0x01;
                bits[i*8 + 1] = (pkg->data[j] & 0x02) >> 1;
                bits[i*8 + 2] = (pkg->data[j] & 0x04) >> 2;
                bits[i*8 + 3] = (pkg->data[j] & 0x08) >> 3;
                bits[i*8 + 4] = (pkg->data[j] & 0x10) >> 4;
                bits[i*8 + 5] = (pkg->data[j] & 0x20) >> 5;
                bits[i*8 + 6] = (pkg->data[j] & 0x40) >> 6;
                bits[i*8 + 7] = (pkg->data[j] & 0x80) >> 7;
        }

        for (i = bitOffset % 8, j=0; i < bitOffset % 8 + (unsigned int) width; i++, j++) {
                data = data + bits[i]*factor;
                factor = 2 << j;
        }
        pkg->bitOffset = bitOffset + width;

		/*ModelicaFormatMessage("SerialPackager: POST bitOffset: %d, width: %d, pkg->pos: %d, pkg->bitOffset: %d\n",
		  bitOffset, width, pkg->pos, pkg->bitOffset);*/
        return data;
}

/** Unpack integer value from package relative to current BIT position (using Intel endianness).
 *
 * @param[in,out] p_package pointer to the SerialPackager
 * @param[in] bitOffset data bit offset (relative to current BIT position) where reading shall start (min=0)
 * @param[in] width bit-width of region encoding the integer value (max=32)
 * @return Extracted integer value
 */
DllExport int MDD_SerialPackagerIntegerBitunpack2(void* p_package, int bitOffset, int width) {
        SerialPackager* pkg = (SerialPackager*) p_package;

		return MDD_SerialPackagerIntegerBitunpack(p_package, pkg->bitOffset + bitOffset, width);
}

/** Pack integer value into package relative to current BYTE position (using Intel endianness).
 *
 * @Note: This function could be improved (performance and functionality, e.g., signed values, endiannes support).
 * We have little endian on x86
 *
 * @param[in,out] p_package pointer to the SerialPackager
 * @param[in] bitOffset data bit offset (relative to current BYTE position) where writing shall start (min=0)
 * @param[in] width bit-width of region encoding the integer value (max=32)
 * @param[in] data integer value that shall be encoded into package
 */
DllExport void MDD_SerialPackagerIntegerBitpack(void* p_package, int bitOffset, int width, int data) {
        SerialPackager* pkg = (SerialPackager*) p_package;
        unsigned char bits[40];
        unsigned int i, j, base_j, rem_j, posEnd;

        if (width > 32) {
                ModelicaFormatError("SerialPackager: MDD_SerialPackagerIntegerBitpack failed."
                "width > 32. Exiting.\n");
                exit(-1);
        }
        if ((unsigned int)bitOffset < pkg->bitOffset) {
                ModelicaFormatError("SerialPackager: Cowardly refusing to start writing at bitOffset %d "
                "which is lower than the current Packager bitOffset %d. Exiting.\n", bitOffset, pkg->bitOffset);
                exit(-1);
        }
        if ( width < 32 && (unsigned int)data >= 0x1u << (unsigned int)width ) {
                ModelicaFormatError("SerialPackager: Warning: Value %d can't be encoded into %d bits or is negative (no signed int support)!\n", data, width);
        }
        posEnd = (bitOffset + width) % 8 == 0 ? pkg->pos + (bitOffset + width) / 8 : pkg->pos + (bitOffset + width) / 8 + 1;
        if (posEnd > pkg->size) {
                ModelicaFormatError("SerialPackager: MDD_SerialPackagerIntegerBitpack failed. Buffer overflow. Exiting.\n");
                exit(-1);
        }

        memset(bits, 0, 40);
        for ( i = bitOffset % 8, j=0; j < (unsigned int)width; i++, j++ ) {
                bits[i] = 0x0001 & (data >> j);
                base_j = pkg->pos + ( (bitOffset + j) / 8 );
                rem_j = (bitOffset + j) % 8;
                if (bits[i]) {
                        /* set bit */
                        pkg->data[base_j] |= (1 << rem_j);
                } else {
                        /* unset bit */
                        pkg->data[base_j] &= ~(1 << rem_j);
                }
        }
        pkg->bitOffset = bitOffset + width;
}

/** Pack integer value into package relative to current BIT position (using Intel endianness).
 *
 * @param[in,out] p_package pointer to the SerialPackager
 * @param[in] bitOffset data bit offset (relative to current BIT position) where writing shall start (min=0)
 * @param[in] width bit-width of region encoding the integer value (max=32)
 * @param[in] data integer value that shall be encoded into package
 */
DllExport void MDD_SerialPackagerIntegerBitpack2(void* p_package, int bitOffset, int width, int data) {
        SerialPackager* pkg = (SerialPackager*) p_package;

		MDD_SerialPackagerIntegerBitpack(p_package, pkg->bitOffset + bitOffset, width, data);
}


#if 0 /* Incubator: Add and (test) functionality below or delete it? */

/** Pack IEEE float value into CAN data.
 *
 * @deprecated This is from the original CANMessage code. However functionality to Pack IEEE float between non-byte bounderies might not be needed in practice?
 *
 * @param[in] p_package pointer to the SerialPackager
 * @param[in] bitStartPosition data bit position where writing shall start
 * @param[in] int float value that shall be encoded into CAN message
 *            (passsed in as double in order to conform to Modelica's external function interface)
 */
void MDD_CANMessageFloatBitpacking(void* p_cANMessage, int bitStartPosition, double data) {
        CANMessage* pkg = (CANMessage*) p_cANMessage;
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
                        /* Need to preserve the first byteBitOffset-1 bits in pkg->data[i] and overwrite the remaining with the bits from data */
                        pkg->data[i] = ( (pkg->data[i] >> (8-byteBitOffset)) << (8-byteBitOffset) ) | (floatData[j] >> byteBitOffset);
                        /* Need to overwrite the first byteBitOffset bits in pkg->data[i+1] and preserve the remaining bits of pkg->data[i+1] */
                        pkg->data[i+1] = ( (pkg->data[i+1] << byteBitOffset) >> byteBitOffset ) | (floatData[j] << (8-byteBitOffset));
                }
        } else {
                /* Float aligned to byte borders. That should be easy */
                memcpy(&(pkg->data[byteStartPosition]), &fdata, sizeof(float));
        }
}

/** Unpack IEEE float value from CAN data.
 *
 * @deprecated This is from the original CANMessage code. However functionality to Pack IEEE float between non-byte bounderies might not be needed in practice?
 *
 * @param[in] p_cANMessage pointer to the CANMessage
 * @param[in] bitStartPosition data bit position where reading shall start (min=0)
 * @return value of extracted IEEE float converted to double in order to support Modelica's external function interface
 */
double MDD_CANMessageFloatBitunpacking(void* p_cANMessage, int bitStartPosition) {
        CANMessage* pkg = (CANMessage*) p_cANMessage;
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
                        lower = (pkg->data[i] << byteBitOffset);
                        upper = (pkg->data[i+1] >> (8-byteBitOffset));
                        floatData[j] = lower | upper;
                }
                memcpy(&data, floatData, sizeof(float));
        } else {
                /* Float aligned to byte borders. That should be easy */
                memcpy(&data, &(pkg->data[byteStartPosition]), sizeof(float));
        }
    return (double)data;
}


/** A memcpy which handles bit offsets and copies specified on bit length level.
 *
 * @deprecated Never tested. Almost Certainly buggy. Probably this functionality is never needed?
 *
 * Bit offset is counted in the direction of array layout. Assume an char a[2] vector with the following layout:
 @verbatim
     0        1
 IIIIIIII IIIIIIII
 @endverbatim
 * and an integer value that shall be encoded in 7 bit, with an offset of 2 into a. That would give
 @verbatim
 IIXXXXXX XIIIIIII
 @endverbatim
 * @param[out] destination target memory block
 * @param[in] source source memory block
 * @param[in] bitSourceOffset bit offset in source memory block (0-7)
 * @param[in] bitLength bit length of memory that shall be copied from offseted source to the destination
 * @return Pointer to destination
 */
void * MDD_SerialPackagerMemcpyBitRead(void* destination, const void* source, unsigned int bitSourceOffset, unsigned int bitLength) {
        unsigned char * dest = (unsigned char *) destination;
        const unsigned char * src = (const unsigned char *) source;

        unsigned int nBytesSrc = (bitLength + bitSourceOffset) % 8 == 0 ? (bitLength + bitSourceOffset) / 8 : (bitLength + bitSourceOffset) / 8 + 1;
        unsigned int nBytesBuffer = bitLength % 8 == 0 ? bitLength / 8 : bitLength / 8 + 1;
        int i=0,nBits=bitLength;

        if (bitSourceOffset > 7) {
                ModelicaFormatError("MDDSerialPackager: bit offsets in MDD_SerialPackagerBitmemcpy greater than max value 7. Exiting.\n");
                exit(-1);
        }

        if (bitSourceOffset == 0 && bitLength % 8 == 0) {
                assert(nBytesSrc == nBytesBuffer);
                memcpy(dest, src, nBytesSrc);
        } else if (bitSourceOffset == 0 && bitLength % 8 != 0) {
                assert(nBytesSrc == nBytesBuffer);
                memcpy(dest, src, nBytesSrc - 1);
                /* Only partial copy of last element: Wipe out the last (8 - (bitLength % 8)) bits */
                dest[nBytesSrc - 1] = (src[nBytesSrc - 1] >> (8 - (bitLength % 8))) << (8 - (bitLength % 8));
        } else if (bitSourceOffset != 0 && bitLength % 8 == 0) {
                assert(nBytesSrc == nBytesBuffer + 1);
                for (i=0; i < nBytesBuffer; i++) {
                        dest[i] = src[i] << bitSourceOffset | ( src[i+1] >> (8-bitSourceOffset) );
                }
        } else if (bitSourceOffset != 0 && bitLength % 8 != 0 && (bitLength + bitSourceOffset) % 8 == 0) {
                assert(nBytesSrc == nBytesBuffer);
                for (i=0; i < nBytesBuffer - 1; i++) {
                        dest[i] = src[i] << bitSourceOffset | ( src[i+1] >> (8-bitSourceOffset) );
                }
                /* The last element needs the lower bits of the src to be moved up in order to align at the
                 memory bounder between dest[nBytesSrc-2] and dest[nBytesSrc-1]*/
                dest[nBytesSrc - 1] = src[nBytesSrc - 1] << bitSourceOffset;
        } else if (bitSourceOffset != 0 && bitLength % 8 != 0 && (bitLength + bitSourceOffset) % 8 != 0
                && (bitLength % 8 + bitSourceOffset) < 8) {
                assert(nBytesSrc == nBytesBuffer);
                for (i=0; i < nBytesBuffer - 1; i++) {
                        dest[i] = src[i] << bitSourceOffset | ( src[i+1] >> (8-bitSourceOffset) );
                }
                /* The last element needs
                 * a) the upper src bits wiped out
                 * b) the remaining bits of the src to be moved up in order to align at the
                 *     memory bounder between dest[nBytesSrc-2] and dest[nBytesSrc-1]
                 */
                dest[nBytesSrc - 1] = ( src[nBytesSrc - 1] >> (8 - (bitLength % 8 + bitSourceOffset)) ) << bitSourceOffset;
        } else if ( bitSourceOffset != 0 && bitLength % 8 != 0 && (bitLength + bitSourceOffset) % 8 != 0
                && (bitLength % 8 + bitSourceOffset) > 8 ) {
                assert((bitLength % 8 + bitSourceOffset) != 0); /* Implies that (bitLength+bitSourceOffset)%8==0 which is already handled */
                assert(nBytesSrc == nBytesBuffer+1);
                for (i=0; i < nBytesBuffer - 1; i++) {
                        dest[i] = src[i] << bitSourceOffset | ( src[i+1] >> (8-bitSourceOffset) );
                }
                /* The last element needs
                 * a) The lower, remaining bits of the second to last element of src (src[nBytes - 1]) shifted up
                 * b) The (not-to-be-copied) bits of the last src element (src[nBytes]) wiped out
                 * c) Align the bits after the bits from the remaining bits of the second to last elment of src
                 */
                dest[nBytesSrc - 1] = src[nBytesSrc - 1] << (8-bitSourceOffset)
                        | ( (src[nBytesSrc] >> (8 - ((bitLength + bitSourceOffset) % 8) ) << (8 - ((bitLength + bitSourceOffset) % 8) ) ) >> bitSourceOffset );
        } else {
        ModelicaFormatError("MDDSerialPackager: Uups, it's not possible to get here!? Exiting.\n");
        exit(-1);
        }
        return destination;
}

#endif /* 0 */

#endif /* MDDSERIALPACKAGER_H_ */




