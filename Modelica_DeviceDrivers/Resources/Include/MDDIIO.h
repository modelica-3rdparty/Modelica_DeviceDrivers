/** Linux Comedi DAQ support (header-only library).
 *
 * @file
 * @author      bernhard-thiele
 * @since       2012-06-26
 * @copyright see accompanying file LICENSE_Modelica_DeviceDrivers.txt
 */

#ifndef MDDIIO_H_
#define MDDIIO_H_

#include <stdlib.h>
#include <../thirdParty/libiio/iio.h>

#include "ModelicaUtilities.h"

#define IIO_ENSURE(expr, message, context) { \
	if (!(expr)) { \
		(void) ModelicaFormatError("%s %s (%s:%d)\n", message, context, __FILE__, __LINE__); \
	} \
}

// Streaming devices

static struct iio_buffer  *rxbuf;
static struct iio_channel **channels;
static unsigned int channel_count;

void* MDD_iio_open(const char* targetname) {
	static struct iio_context *ctx;
	if(strlen(targetname) > 0) {
		IIO_ENSURE(ctx = iio_create_network_context(targetname), "Could not open IIO host", targetname);
	}
	else  {
		IIO_ENSURE(ctx = iio_create_local_context(), "Could not open IIO host", "locally");
	}
	IIO_ENSURE(iio_context_get_devices_count(ctx) > 3, "No devices found at host", targetname);

    return (void*) ctx;
}

void MDD_iio_close(void* p_ctx) {
	static struct iio_context *ctx;
	ctx = (struct iio_context *) p_ctx;
    if (ctx) {
		iio_context_destroy(ctx);
	}
}

void* MDD_iio_open_channel(void *p_ctx, const char* devicename, const char* channelname) {
	static struct iio_context *ctx;
	ctx = (struct iio_context *) p_ctx;

	static struct iio_device *dev;
	IIO_ENSURE(dev = iio_context_find_device(ctx, devicename), "Device not found: ", devicename);

	struct iio_channel *chn;
	IIO_ENSURE(chn = iio_device_find_channel(dev, channelname, false), "Channel not found: ", channelname);

	return (void *) chn;
}

void MDD_iio_close_channel (void* p_chn) {
}

double MDD_iio_data_read(void* p_chn, const char* attrname) {
	struct iio_channel *chn;
	chn = (struct iio_channel *) p_chn;

	double val = 0;

	int ret = iio_channel_attr_read_double(chn, attrname, &val);
	IIO_ENSURE(ret == 0, "Attribute not found: ", attrname);

    return val;
}

#endif /* MDDIIO_H_ */
