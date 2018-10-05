/*
 *  Copyright (c) 2012-2018, DLR, ESI ITI, and Linkoeping University (PELAB)
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *
 *  1. Redistributions of source code must retain the above copyright notice, this
 *     list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright notice,
 *     this list of conditions and the following disclaimer in the documentation
 *     and/or other materials provided with the distribution.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 *  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/** Test for efficient Endianness conversion.
*
* @file
* @author      bernhard-thiele
* @since       2013-11-24
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

#elif defined(__MINGW32__)
#define BSWAP16(a) \
    ((((a) >> 8) & 0xffu) \
   | (((a) & 0xffu) << 8))
#define BSWAP32(a) \
    ((((a) & 0xff000000u) >> 24) \
   | (((a) & 0x00ff0000u) >> 8) \
   | (((a) & 0x0000ff00u) << 8) \
   | (((a) & 0x000000ffu) << 24))
#define BSWAP64(a) \
    ((((a) & 0xff00000000000000ull) >> 56) \
   | (((a) & 0x00ff000000000000ull) >> 40) \
   | (((a) & 0x0000ff0000000000ull) >> 24) \
   | (((a) & 0x000000ff00000000ull) >> 8) \
   | (((a) & 0x00000000ff000000ull) << 8) \
   | (((a) & 0x0000000000ff0000ull) << 24) \
   | (((a) & 0x000000000000ff00ull) << 40) \
   | (((a) & 0x00000000000000ffull) << 56))

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
    }
    else {
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
    }
    else {
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
    }
    else {
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
