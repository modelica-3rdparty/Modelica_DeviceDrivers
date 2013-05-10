/** Test for Linux Comedi interface.
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id$
 * @since       2012-06-26
 * @copyright Modelica License 2
 * @test Interactive test for MDDComedi.h.
 *
 * Compiling/linking needs libcomedi and libm, e.g., gcc test_MDDComedi.c -lcomedi -lm -Wall -o test_Comedi
 */


#include <stdio.h>

//#include "ComediReadWrite.h"

#include <comedilib.h>
#include "../../Include/MDDComedi.h"
#include "../../src/include/util.h"

int test_comediAnalogWrite(const char* devicename) {
  comedi_t* device;
  int subDevice = 1;
  int channel = 0;
  int range = 0;
  int aref = AREF_GROUND;
  int ret,i;

  lsampl_t data = 0; /* For USB-Dux D min=0, max=4095 */;

  printf("Hello Comedi. Test intended for analog out of USB-Dux\n");

  device = comedi_open(devicename);
  if(device == NULL) {
    ModelicaFormatError("comedi_open failure (%s)\n",
                        comedi_strerror(comedi_errno()) );
     return -1;
  }

  for (i=0; i < 4; i++) {
    printf("Writing data: %d\n", data);
    ret = comedi_data_write(device, subDevice, channel,
                              range, aref, data);
    if ( ret == -1) {
      comedi_perror("comedi_data_write");
      return -1;
    }
    data += 1000;
    MDD_msleep(2000);
  }

  return 0;
}

/* For USB-DUX D*/
int test_MDDComediAnalogReadWrite(const char* devicename) {
  void *device;
  int i, data;

  device = MDD_comedi_open(devicename);

  for (i=0; i < 10; i++) {
    printf("MDD_comedi_data_write(%s, %d, %d, %d, %d, %d)\n",
           devicename, 1, 0, 0, AREF_GROUND, i*200);
    MDD_comedi_data_write(device, 1, 0,
                         0, AREF_GROUND, i*200);
    MDD_msleep(400);
    data = MDD_comedi_data_read(device, 0, 0,
                       0, AREF_GROUND);
    printf("Got: %d\n", data);

  }

  MDD_comedi_close(device);
  return 0;
}

/* For USB-DUX D*/
int test_MDDComediDIOReadWrite(const char* devicename) {
  void *device;
  int subDevice = 2;
  int channelOut = 0;
  int channelIn = 1;
  int i, dataOut = 1, dataIn = 0;


  device = MDD_comedi_open(devicename);

  printf("MDD_comedi_dio_config(%s, %d, %d, %d)\n",devicename, subDevice, channelOut, COMEDI_OUTPUT);
  MDD_comedi_dio_config(device, subDevice, channelOut, COMEDI_OUTPUT);

  printf("MDD_comedi_dio_config(%s, %d, %d, %d)\n",devicename, subDevice, channelIn, COMEDI_INPUT);
  MDD_comedi_dio_config(device, subDevice, channelIn, COMEDI_INPUT);

  for (i=0; i < 10; i++) {
    dataOut = dataOut ? 0 : 1;
    printf("MDD_comedi_dio_write(%s, %d, %d, %d)\n",devicename, subDevice, channelOut, dataOut);
    MDD_comedi_dio_write(device, subDevice, channelOut, dataOut);
    MDD_msleep(400);
    dataIn = MDD_comedi_dio_read(device, subDevice, channelIn);
    printf("Got: %d\n", dataIn);
  }

  MDD_comedi_close(device);
  return 0;
}

/* For USB-DUX D */
int test_MDDComediPhysicalReadWrite(const char* devicename) {
  void *device;
  int subdeviceIn = 0, subdeviceOut = 1;
  int channelIn = 0, channelOut = 0;
  int range = 0;
  int aref = AREF_GROUND;
  int unitIn, maxdataIn, dataIn, unitOut, maxdataOut, dataOut, i;
  double minIn,maxIn,physical_valueIn, minOut, maxOut, physical_valueOut = -4.0;

  device = MDD_comedi_open(devicename);

  MDD_comedi_set_global_oor_behavior(1);

  /* Determine channel settings for output */
  MDD_comedi_get_range(device, subdeviceOut, channelOut, range,
                          &minOut, &maxOut, &unitOut);
  maxdataOut = MDD_comedi_get_maxdata(device, subdeviceOut, channelOut);
  printf("DAC range -> physical range in %s: [0,%d] -> [%g,%g]\n",
         unitOut == UNIT_volt ? "UNIT_volt" : unitOut == UNIT_mA ? "UNIT_mA" : "Unit_none", maxdataOut,
               minOut, maxOut);

  /* Determine channel settings for input */
  MDD_comedi_get_range(device, subdeviceIn, channelIn, range,
                          &minIn, &maxIn, &unitIn);
  maxdataIn = MDD_comedi_get_maxdata(device, subdeviceIn, channelIn);
  printf("ADC range -> physical range in %s: [0,%d] -> [%g,%g]\n",
         unitIn == UNIT_volt ? "UNIT_volt" : unitIn == UNIT_mA ? "UNIT_mA" : "Unit_none", maxdataIn,
               minIn, maxIn);


  for (i=0; i < 10; i++) {
    /* Write a value */
    dataOut = MDD_comedi_from_phys(physical_valueOut, minOut, maxOut, unitOut, maxdataOut);
    printf("\nWriting physical value %lf -> %d raw value\n", physical_valueOut, dataOut);
    MDD_comedi_data_write(device, subdeviceOut, channelOut,
                         range, aref, dataOut);

    /* Read the written value (assuming output channel electrical connected to input channel */
    dataIn = MDD_comedi_data_read(device, subdeviceIn, channelIn, range, aref);
    printf("Reading Raw value %d -> ", dataIn);
    physical_valueIn = MDD_comedi_to_phys(dataIn, minIn, maxIn, unitIn, maxdataIn);
    printf("Physical value is: ");
    if(isnan(physical_valueIn)) {
            printf("Out of range [%g,%g]\n", minIn, maxIn);
    } else {
            printf("%g\n", physical_valueIn);
    }
    physical_valueOut += 1.1;
    MDD_msleep(400);
  }

  MDD_comedi_close(device);

  return 0;
}

int main(void) {
  int fail=0;
  const char* devicename = "/dev/comedi0";

  printf("Starting:...\n");

  //fail = test_comediAnalogWrite(devicename);

//   fail = fail ||  test_MDDComediAnalogReadWrite(devicename);
//
//   fail = fail || test_MDDComediDIOReadWrite(devicename);

  fail = fail || test_MDDComediPhysicalReadWrite(devicename);

  return fail;
}
