/** Test CAN message encoding/decoding.
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id$
 * @since       2012-06-18
 * @copyright Modelica License 2
 * @test Test for MDDCANMessage.h.
 *
*/

#include <stdio.h>
#include <string.h>
#include <float.h>
#include <math.h>
#include "MDDCANMessage.h"


int test_packAndUnpackFloatAtByteBoundery() {
	CANMessage* msg1;
	double value1;
	int failed;

	printf("Pack and unpack IEEE float value at byte boundery:\n");
	msg1 = (CANMessage*) MDD_CANMessageConstructor();
	MDD_CANMessageFloatBitpacking(msg1, 24, 3.2);
	value1 = MDD_CANMessageFloatBitunpacking(msg1, 24);
    failed = fabs(value1 - 3.2) < 2*FLT_EPSILON ? 0 : 1;
	MDD_CANMessageDestructor(msg1);
	printf("%s .. Packed value: %lf, got value: %lf\n.", failed ? "FAILED!" : "OK", 3.2, value1);

	return failed;
}

int test_packAndUnpackFloatWithOffsetToByteBoundery() {
	CANMessage* msg1;
	double value1;
	int failed;

	printf("Pack and unpack IEEE float value with offset to byte boundery:\n");
	msg1 = (CANMessage*) MDD_CANMessageConstructor();
	MDD_CANMessageFloatBitpacking(msg1, 9, 3.3);
	value1 = MDD_CANMessageFloatBitunpacking(msg1, 9);
    failed = fabs(value1 - 3.3) < 2*FLT_EPSILON ? 0 : 1;
	MDD_CANMessageDestructor(msg1);
	printf("%s .. Packed value: %lf, got value: %lf\n.", failed ? "FAILED!" : "OK", 3.3, value1);
	return failed;
}

int test_packAndUnpackDouble() {
	CANMessage* msg1;
	double value1;
	int failed;

	printf("Pack and unpack IEEE double value:\n");
	msg1 = (CANMessage*) MDD_CANMessageConstructor();
	MDD_CANMessageDoubleBitpacking(msg1, 4.4);
	value1 = MDD_CANMessageDoubleBitunpacking(msg1);
    failed = fabs(value1 - 4.4) < 2*DBL_EPSILON ? 0 : 1;
	MDD_CANMessageDestructor(msg1);
	printf("%s .. Packed value: %lf, got value: %lf\n.", failed ? "FAILED!" : "OK", 4.4, value1);
	return failed;
}


int main() {
	int failed, value1;
	void * msg1;
	CANMessage* msg2 = (CANMessage*) malloc(sizeof(CANMessage));
	int myIntValueIn = 1073741824; // 2^30
	int myIntValueOut=0;

	printf("Testing CAN message encoding/decoding\n");

	/* Is intel endianness correctly supported? */
	memcpy(msg2->data+1, &myIntValueIn, sizeof(int));
	myIntValueOut = MDD_CANMessageIntegerBitunpacking((void*)msg2, 8, 32);
	printf("myIntValueIn (2^30): %d, myIntValueOut (2^30): %d\n", myIntValueIn, myIntValueOut);
	failed = myIntValueIn == myIntValueOut ? 0 : 1;

	printf("Pack and unpack integer value\n");
	msg1 = MDD_CANMessageConstructor();
	MDD_CANMessageIntegerBitpacking(msg1, 0, 8, 20);
	value1 = MDD_CANMessageIntegerBitunpacking(msg1, 0, 8);
    failed = failed || value1 == 20 ? 0 : 1;
	printf("Packed value: %d, got value: %d\n", 20, value1);

	failed = failed || test_packAndUnpackFloatAtByteBoundery();

	failed = failed || test_packAndUnpackFloatWithOffsetToByteBoundery();

	failed = failed || test_packAndUnpackDouble();

    return failed;
}



