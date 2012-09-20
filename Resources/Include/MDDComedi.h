/** Linux Comedi DAQ support (header-only library).
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @version     $Id: MDDComedi.h 16050 2012-06-29 14:47:23Z thie_be $
 * @since       2012-06-26
 * @copyright Modelica License 2
 *
 * Read/Write signals using the comedi DAQ interface (http://www.comedi.org/).
 * @note Requires that the comedi device drivers are correctly setup on your linux system.
 *
 * The aim of this library is to provide a rather direct interface from the C libcomedi to
 * Modelica. Therefore you should look at the comedi documentation to understand what
 * is happening.
 */

#ifndef MDDCOMEDI_H_
#define MDDCOMEDI_H_

#include <stdlib.h>
#include <comedilib.h>

#include "ModelicaUtilities.h"


#if defined(__linux__)

void* MDD_comedi_open(const char* devicename) {
  comedi_t* device;

  ModelicaFormatMessage("MDDComedi: Opening device %s (needs special (root) privileges!) ..", devicename);

  device = comedi_open(devicename);

  if(device == NULL) {
    ModelicaFormatError("\nMDDComedi.h: comedi_open failure (%s)\n",
                        comedi_strerror(comedi_errno()) );
     exit(-1);
  }
  ModelicaFormatMessage("\tOK (fd=%d).\n", comedi_fileno(device));
  ModelicaFormatMessage("           Opened comedi device fd=%d: board name=%s, driver name=%s.\n",
                        comedi_fileno(device), comedi_get_board_name(device), comedi_get_driver_name(device));
  return (void*) device;
}

void MDD_comedi_close(void* p_device) {
  comedi_t* device = (comedi_t*) p_device;
  int ret;

  ModelicaFormatMessage("MDDComedi: Closing device with fd=%d.\n", comedi_fileno(device));
  ret = comedi_close(device);
  if (ret == -1) {
     ModelicaFormatError("MDDComedi.h: comedi_close failure (%s)\n",
                        comedi_strerror(comedi_errno()) );
  }
}

void MDD_comedi_data_write(void* p_device, int subDevice, int channel,
			 int range, int aref, int data) {
  comedi_t* device = (comedi_t*) p_device;
  lsampl_t udata = (lsampl_t) data;
  int ret;

  ret = comedi_data_write(device, subDevice, channel,
			      range, aref, udata);
  if (ret == -1) {
     ModelicaFormatError("MDDComedi.h: comedi_data_write failure (%s)\n",
                        comedi_strerror(comedi_errno()) );
  }
}

int MDD_comedi_data_read(void* p_device, int subDevice, int channel,
		       int range, int aref) {
  comedi_t* device = (comedi_t*) p_device;
  lsampl_t data;
  int ret;

  ret = comedi_data_read(device, subDevice, channel,
			     range, aref, &data);
  if ( ret == -1) {
    ModelicaFormatError("MDDComedi.h: comedi_data_read failure (%s).\n",
                        comedi_strerror(comedi_errno()) );
  }
  return (int) data;
}


void MDD_comedi_dio_config(void* p_device, int subdevice, int channel, int direction) {
  comedi_t* device = (comedi_t*) p_device;
  int ret;

  ret = comedi_dio_config(device, subdevice, channel, direction);
  if ( ret == -1) {
    ModelicaFormatError("MDDComedi.h: comedi_dio_config failure (%s).\n",
                        comedi_strerror(comedi_errno()) );
    exit(-1);
  }
}

void MDD_comedi_dio_write(void* p_device, int subDevice, int channel, int bit) {
  comedi_t* device = (comedi_t*) p_device;
  int ret;

  ret = comedi_dio_write(device, subDevice, channel, bit);
  if ( ret == -1) {
    ModelicaFormatError("MDDComedi.h: comedi_dio_write failure (%s).\n",
                        comedi_strerror(comedi_errno()) );
  }
}

int MDD_comedi_dio_read(void* p_device, int subDevice, int channel) {
  comedi_t* device = (comedi_t*) p_device;
  unsigned int bit;
  int ret;
  ret = comedi_dio_read(device, subDevice, channel, &bit);
  if ( ret == -1) {
    ModelicaFormatError("MDDComedi.h: comedi_dio_read failure (%s).\n",
                        comedi_strerror(comedi_errno()) );
  }
  return (int) bit;
}

/**
 * COMEDI_OOR_NUMBER = 0
 * COMEDI_OOR_NAN = 1
 */
int MDD_comedi_set_global_oor_behavior(int behavior) {
  enum comedi_oor_behavior oldBehavior;

  if (behavior >= 2) {
    ModelicaFormatError("MDDComedi: Error, not valid argument to MDD_comedi_set_global_oor_behavior (was %d). Exiting\n",
                        behavior);
    exit(-1);
  }

  ModelicaFormatMessage("MDDComedi: Setting the global out-of-range behavior to %s\n",
    behavior == COMEDI_OOR_NAN ? "COMEDI_OOR_NAN => endpoint values are converted to NAN"
    : "COMEDI_OOR_NUMBER => the endpoint values are converted similarly to other values");
  oldBehavior = comedi_set_global_oor_behavior(behavior);
  return oldBehavior;
}

/** Get range information about channel
 * @param[out] min (physical) min value.
 * @param[out] max (physical) max value.
 * @param[out] unit physical unit type. UNIT_volt=0 for volts, UNIT_mA=1 for milliamps, or UNIT_none=2 for unitless.
 */
void MDD_comedi_get_range(void* p_device, int subdevice, int channel, int range,
                          double* min, double* max, int* unit) {
  comedi_t* device = (comedi_t*) p_device;
  comedi_range* p_range;
  p_range = comedi_get_range(device, (unsigned int)subdevice, (unsigned int)channel, (unsigned int)range);
  if (p_range == NULL) {
    ModelicaFormatError("MDDComedi: MDD_comedi_get_range failed. exiting.\n");
    exit(-1);
  }
  *min = p_range->min;
  *max = p_range->max;
  *unit = p_range->unit;
}

int MDD_comedi_get_maxdata(void* p_device, int subdevice, int channel) {
  comedi_t* device = (comedi_t*) p_device;
  lsampl_t data = comedi_get_maxdata(device, (unsigned int)subdevice, (unsigned int)channel);
  return (int)data;
}

/**
 * @param data Raw data value as returned by MDD_comedi_data_read(..)
 * @param min minimum possible value from channel. Retrieve with MDD_comedi_get_range(..)
 * @param max maximum possible value from channel. Retrieve with MDD_comedi_get_range(..)
 * @param unit physical unit type of channel. Retrieve with MDD_comedi_get_range(..)
 * @param maxdata maximal raw value of channel. Retrieve with MDD_comedi_get_maxdata(..)
 * @return Physical value in unit indicated by unit type
 */
double MDD_comedi_to_phys(int data, double min, double max, int unit, int maxdata) {
  comedi_range range = {min, max, (unsigned int)unit};
  return comedi_to_phys( (lsampl_t)data, &range, (lsampl_t)maxdata);
}

/**
 * @param data Physical value given in the unit specified by the unit argument
 * @param min minimum possible value from channel. Retrieve with MDD_comedi_get_range(..)
 * @param max maximum possible value from channel. Retrieve with MDD_comedi_get_range(..)
 * @param unit physical unit type of channel. Retrieve with MDD_comedi_get_range(..)
 * @param maxdata maximal raw value of channel. Retrieve with MDD_comedi_get_maxdata(..)
 * @return Raw value of channel
 */
int MDD_comedi_from_phys(double data, double min, double max, int unit, int maxdata) {
  comedi_range range = {min, max, (unsigned int)unit};
  return (int)comedi_from_phys(data, &range, (lsampl_t)maxdata);
}


#else

  #error "Modelica_DeviceDrivers: Comedi DAQ drivers only supported on linux!"

#endif /* defined(__linux__) */

#endif /* MDDCOMEDI_H_ */
