 /** Test for efficient Endianness conversion.
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id$
 * @since       2013-11-24
 * @copyright Modelica License 2
 * @test Test based on suggestions given at http://stackoverflow.com/questions/2182002/convert-big-endian-to-little-endian-in-c-without-using-provided-func.
 *
 * Might also want to have a look at http://www.codeproject.com/Articles/29807/Endian-Conversion-in-ARM-and-x86-Assembly
*/

#include <stdio.h>

#if defined(_MSC_VER)

#include <stdlib.h>
#define BSWAP16(a) (_byteswap_ushort(a))
#define BSWAP32(a) (_byteswap_ulong(a))
#define BSWAP64(a) (_byteswap_uint64(a))

#else
#include <byteswap.h>

#define BSWAP16(a) (bswap_16(a))
#define BSWAP32(a) (bswap_32(a))
#define BSWAP64(a) (bswap_64(a))

#endif


int test_BSWAP16() {

        int ret, failure = 0;
        unsigned short a = 0xFF;

        printf("test_BSWAP16 ... ");
        failure = BSWAP16(a) == 0xFF00 ? 0 : 1;

        if (failure) {
                printf("\tFAILED\n");
        } else {
                printf("\tOk\n");
        }
        return failure;
}

int test_BSWAP32() {

        int ret, failure = 0;
        unsigned int a = 0xFFFF;

        printf("test_BSWAP32 ... ");
        failure = BSWAP32(a) == 0xFFFF0000 ? 0 : 1;

        if (failure) {
                printf("\tFAILED\n");
        } else {
                printf("\tOk\n");
        }
        return failure;
}

int test_BSWAP64() {

        int ret, failure = 0;
        unsigned long long a = 0xFF;

        printf("test_BSWAP64 ... ");
        //printf("a: %llx, BSWAP64(a): %llx\n", a, BSWAP64(a));
        failure = BSWAP64(a) == 0xFF00000000000000 ? 0 : 1;

        if (failure) {
                printf("\tFAILED\n");
        } else {
                printf("\tOk\n");
        }
        return failure;
}

int main(void) {
        int failure = 0;

        failure = test_BSWAP16();
        failure = failure || test_BSWAP32();
        failure = failure || test_BSWAP64();

        return failure;
}
