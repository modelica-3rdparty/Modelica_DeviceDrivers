/** Test for Socket CAN support.
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id$
 * @since       2012-12-22
 * @copyright Modelica License 2
 * @test Test for MDDSocketCAN.h
 *
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../../Include/MDDSocketCAN.h"
#include "../../src/include/util.h"

/** Bring up the necessary virtual can devices
 *
 * (At least this works for Ubuntu)
 */
void setup_VirtualCANDevices() {
  system("sudo modprobe vcan");
  system("sudo ip link add type vcan"); /* gives vcan0 */
  system("sudo ifconfig vcan0 up");
}

int test_Constructor() {
  void * mDDSocketCan;
  int failed;

  mDDSocketCan = MDD_socketCANConstructor("vcan0");
  failed = mDDSocketCan == NULL ? 1 : 0;

  MDD_socketCANDestructor(mDDSocketCan);

  return failed;
}

int test_CANWrite() {
  void * mDDSocketCan;
  char data[8];
  int failed;

  mDDSocketCan = MDD_socketCANConstructor("vcan0");
  failed = mDDSocketCan == NULL ? 1 : 0;

  strcpy(data, "Hello C");
  MDD_socketCANWrite(mDDSocketCan, 1, sizeof(data), data);

  MDD_socketCANDestructor(mDDSocketCan);

  return failed;
}

int test_CANWriteRead() {
  void * mDDSocketCan0;
  void * mDDSocketCan1;
  char data_w[8];
  char data_r[8];
  int failed, i;

  mDDSocketCan0 = MDD_socketCANConstructor("vcan0");
  failed = mDDSocketCan0 == NULL ? 1 : 0;
  /* Need to bind *different* socket to *same* device in order
     to receive sent messages.
     Note that unless the flag CAN_RAW_RECV_OWN_MSGS is set
     (default is not set!) a socket won't receive the
     messages it sent (that's why we use two different sockets).
  */
  mDDSocketCan1 = MDD_socketCANConstructor("vcan0");
  failed = mDDSocketCan1 == NULL ? 1 : 0;

  MDD_socketCANDefineObject(mDDSocketCan1, 1, 8);

  for(i=0; i < 10; i++) {
    sprintf(data_w, "Hi %d", i*2);
    MDD_socketCANWrite(mDDSocketCan0, 1, 8, data_w);
    MDD_msleep(10);
    MDD_socketCANRead(mDDSocketCan1, 1,  8, data_r);
    failed = strcmp(data_w, data_r) == 0 ? failed : 1;
  }

  MDD_socketCANDestructor(mDDSocketCan0);
  MDD_socketCANDestructor(mDDSocketCan1);

  return failed;
}



int main() {
  int failed = 0;
  printf("Testing Socket CAN Support ..\n");
  printf("PLEASE NOTE: the virtual can device vcan0 must be up in order to run tests!\n");
  /* Setting up vcan0 can be done by uncommenting the line below, or manually by
     typing the commands in setup_VirtualCANDevices() in a console */
  //setup_VirtualCANDevices();

  //failed = test_Constructor(); if (failed) goto END;
  //failed = test_CANWrite(); if (failed) goto END;
  failed = test_CANWriteRead(); if (failed) goto END;

END:
  printf("\nTesting Socket CAN Support %s\n", (failed != 0) ? "FAILED" : "OK");
  return failed;
}



