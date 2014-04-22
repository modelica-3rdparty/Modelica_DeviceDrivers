/** Support for Softing's CANL2 API (header-only library).
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @author      Miguel Neves <miguel.neves@dlr.de> (human readable error codes)
 * @version     $Id: MDDSoftingCAN.h 16335 2012-07-18 12:59:39Z thie_be $
 * @since       2012-06-18
 * @copyright Modelica License 2
 *
 * Modelica external function interface to use CAN interface cards from
 * Softing (http://www.softing.com/).
 * Tested with the CANusb card under windows.
*/
#ifndef MDDSOFTINGCAN_H_
#define MDDSOFTINGCAN_H_

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#if defined(_MSC_VER)

#	include <windows.h>
#	include "../src/include/CompatibilityDefs.h"
	/* CAN LAYER 2 LIBRARY INCLUDE FILES */
#	include "../thirdParty/softing/Can_def.h"  /* dll import and export definitions */
#	include "../thirdParty/softing/CANL2.H"    /* definition of the API functions an the structures */
#	include "ModelicaUtilities.h"
#	include "MDDCANMessage.h"
#   include "MDDSerialPackager.h"
#	if  defined(MDDSOFTINGCANUSECMAKE)
 		/* use cmake to resolve linking dependencies */
#	else
		/* Used as header-only library => add linking dependencies here: */
#		if defined(_WIN64)
#			pragma comment( lib, "canL2_64.lib" )
#		else
#			pragma comment( lib, "canL2.lib" )
#		endif /* defined(_WIN64) */
#	endif /*MDDSOFTINGCANWRAPPER_C_*/
#else
#	error "Modelica_DeviceDrivers: SoftingCAN driver only supported on WINDOWS!"
#endif /* _MSC_VER */



/* Bit timing (1 MBaud) */
#define PRESCALER_1             1
#define SYNC_JMP_WIDTH_1        3   /**< deviates from recommended value "1" */
#define TIME_SEG1_1             4
#define TIME_SEG2_1             3
#define SAMPLE_1                0
/* Bit timing (800 kBaud) */
#define PRESCALER_2             1
#define SYNC_JMP_WIDTH_2        3   /**< deviates from recommended value "1" */
#define TIME_SEG1_2             6
#define TIME_SEG2_2             3
#define SAMPLE_2                0
/* Bit timing (500 kBaud) */
#define PRESCALER_3             1
#define SYNC_JMP_WIDTH_3        3   /**< deviates from recommended value "1" */
#define TIME_SEG1_3             8
#define TIME_SEG2_3             7
#define SAMPLE_3                0
/* Bit timing (250 kBaud) */
#define PRESCALER_4             2
#define SYNC_JMP_WIDTH_4        3   /**< deviates from recommended value "1" */
#define TIME_SEG1_4             8
#define TIME_SEG2_4             7
#define SAMPLE_4                0
/* Bit timing (125 kBaud) */
#define PRESCALER_5             4
#define SYNC_JMP_WIDTH_5        3   /**< deviates from recommended value "1" */
#define TIME_SEG1_5             8
#define TIME_SEG2_5             7
#define SAMPLE_5                0
/* Bit timing (100 kBaud) */
#define PRESCALER_6             4
#define SYNC_JMP_WIDTH_6        4
#define TIME_SEG1_6             11
#define TIME_SEG2_6             8
#define SAMPLE_6                0
/* Bit timing (10 kBaud) */
#define PRESCALER_7             32
#define SYNC_JMP_WIDTH_7        4
#define TIME_SEG1_7             16
#define TIME_SEG2_7             8
#define SAMPLE_7                0

/* Acceptance filter */
#define ACCEPT_MASK_1           0x0000
#define ACCEPT_CODE_1           0x0000
#define ACCEPT_MASK_XTD_1       0x00000000L
#define ACCEPT_CODE_XTD_1       0x00000000L
/* Phys. layer (-1: default - CAN High Speed) */
#define OUTPUT_CONTROL_1        -1
#define OUTPUT_CONTROL_2        -1

typedef struct DataFrame_struct DataFrame;
typedef struct MefiCANL2_struct MefiCANL2;

struct DataFrame_struct{
    unsigned int Ident;
    int ObjectNumber;
    unsigned int nDataElements;
    unsigned int nCalled;
    unsigned char data[8];
};

/** External Object data structure.
 *
 */
typedef struct  {
    char deviceName[256];
    CAN_HANDLE can;
    /*DataFrame i2oMap[MAX_OBJECTS]; */
} MDDSoftingCAN;

/** Structure for initializing a channel
 *
 * https://github.com/modelica/Modelica_DeviceDrivers/issues/18
 */
typedef struct mdd_canl2_ch_s {
    CAN_HANDLE     ulChannelHandle;
    unsigned char  sChannelName[80];
} MDD_CANL2_CH_STRUCT;

char mDDErrorMsg[1024];

static char * descriptiveError(int ret, const char * caller_function);


DllExport void* MDD_softingCANConstructor(const char* deviceName, int baudRate) {
	MDD_CANL2_CH_STRUCT channel;
	int ret;

	MDDSoftingCAN* mDDSoftingCAN = (MDDSoftingCAN*) malloc(sizeof(MDDSoftingCAN));

	ModelicaFormatMessage("SoftingCAN: Initialize channel %s ...", deviceName);
	strcpy((char*)channel.sChannelName,deviceName);
	strcpy(mDDSoftingCAN->deviceName, deviceName);
	ret = INIL2_initialize_channel(&channel.ulChannelHandle, (char*) channel.sChannelName);
	if(ret) {
		ModelicaFormatError("%s",descriptiveError(ret, "INIL2_initialize_channel"));
		exit(ret);
	}
	mDDSoftingCAN->can = channel.ulChannelHandle;
	ModelicaFormatMessage("\tOK.\n");

	ModelicaFormatMessage("SoftingCAN (%s): Resetting chip ...", mDDSoftingCAN->deviceName);
	ret = CANL2_reset_chip(mDDSoftingCAN->can);
	if(ret) {
		ModelicaFormatError("%s",descriptiveError(ret, "CANL2_reset_chip"));
		exit(ret);
	}
	ModelicaFormatMessage("\tOK.\n");

	/* Note: Here is the knob to tune the baud rate: */
	/*
						baud rate presc sjw tseg1 tseg2
						1 Mbaud   1     1   4     3
						800 kBaud 1     1   6     3
						500 kBaud 1     1   8     7
						250 kBaud 2     1   8     7
						125 kBaud 4     1   8     7
						100 kBaud 4     4   11    8
						10 kBaud  32    4   16    8
	*/
	switch (baudRate) {
		case 1:
			ModelicaFormatMessage("SoftingCAN (%s): Initializing chip with baud rate 1 MBaud ...", mDDSoftingCAN->deviceName);
			ret = CANL2_initialize_chip(mDDSoftingCAN->can, PRESCALER_1, SYNC_JMP_WIDTH_1, TIME_SEG1_1,
						TIME_SEG2_1, SAMPLE_1);
			break;
		case 2:
			ModelicaFormatMessage("SoftingCAN (%s): Initializing chip with baud rate 800 kBaud ...", mDDSoftingCAN->deviceName);
			ret = CANL2_initialize_chip(mDDSoftingCAN->can, PRESCALER_2, SYNC_JMP_WIDTH_2, TIME_SEG1_2,
						TIME_SEG2_2, SAMPLE_2);
			break;
		case 3:
			ModelicaFormatMessage("SoftingCAN (%s): Initializing chip with baud rate 500 kBaud ...", mDDSoftingCAN->deviceName);
			ret = CANL2_initialize_chip(mDDSoftingCAN->can, PRESCALER_3, SYNC_JMP_WIDTH_3, TIME_SEG1_3,
						TIME_SEG2_3, SAMPLE_3);
			break;
		case 4:
			ModelicaFormatMessage("SoftingCAN (%s): Initializing chip with baud rate 250 kBaud ...", mDDSoftingCAN->deviceName);
			ret = CANL2_initialize_chip(mDDSoftingCAN->can, PRESCALER_4, SYNC_JMP_WIDTH_4, TIME_SEG1_4,
						TIME_SEG2_4, SAMPLE_4);
			break;
		case 5:
			ModelicaFormatMessage("SoftingCAN (%s): Initializing chip with baud rate 125 kBaud ...", mDDSoftingCAN->deviceName);
			ret = CANL2_initialize_chip(mDDSoftingCAN->can, PRESCALER_5, SYNC_JMP_WIDTH_5, TIME_SEG1_5,
						TIME_SEG2_5, SAMPLE_5);
			break;
		case 6:
			ModelicaFormatMessage("SoftingCAN (%s): Initializing chip with baud rate 100 kBaud ...", mDDSoftingCAN->deviceName);
			ret = CANL2_initialize_chip(mDDSoftingCAN->can, PRESCALER_6, SYNC_JMP_WIDTH_6, TIME_SEG1_6,
						TIME_SEG2_6, SAMPLE_6);
			break;
		case 7:
			ModelicaFormatMessage("SoftingCAN (%s): Initializing chip with baud rate 10 kBaud ...", mDDSoftingCAN->deviceName);
			ret = CANL2_initialize_chip(mDDSoftingCAN->can, PRESCALER_7, SYNC_JMP_WIDTH_7, TIME_SEG1_7,
						TIME_SEG2_7, SAMPLE_7);
			break;
		default:
			ModelicaFormatError("SoftingCAN (%s): Initializing chip with not (yet) supported Baud Rate (enum value %d)\n",
				mDDSoftingCAN->deviceName, baudRate);
			exit(-1);
	}

	if(ret) {
		ModelicaFormatError("%s",descriptiveError(ret, "CANL2_initialize_chip"));
		exit(ret);
	}
	ModelicaFormatMessage("\tOK.\n");

	ModelicaFormatMessage("SoftingCAN (%s): CANL2_set_acceptance ...", mDDSoftingCAN->deviceName);
	ret = CANL2_set_acceptance(mDDSoftingCAN->can, ACCEPT_MASK_1, ACCEPT_CODE_1, ACCEPT_MASK_XTD_1,
					ACCEPT_CODE_XTD_1);
	if (ret) {
		ModelicaFormatError("%s",descriptiveError(ret, "CANL2_set_acceptance"));
		exit(ret);
	}
	ModelicaFormatMessage("\tOK.\n");

	ModelicaFormatMessage("SoftingCAN (%s): Set ouput control ...", mDDSoftingCAN->deviceName);
	ret = CANL2_set_output_control(mDDSoftingCAN->can, OUTPUT_CONTROL_1);
	if(ret) {
		ModelicaFormatError("%s",descriptiveError(ret, "CANL2_set_output_control"));
		exit(ret);
	}
	ModelicaFormatMessage("\tOK.\n");

	ModelicaFormatMessage("SoftingCAN (%s): Enable dynamic object buffer ...", mDDSoftingCAN->deviceName);
	ret = CANL2_enable_dyn_obj_buf(mDDSoftingCAN->can);
	if(ret) {
		ModelicaFormatError("%s",descriptiveError(ret, "CANL2_enable_dyn_obj_buf"));
		exit(ret);
	}
	ModelicaFormatMessage("\tOK.\n");

	ModelicaFormatMessage("SoftingCAN (%s): Initialize interface ...", mDDSoftingCAN->deviceName);
	ret = CANL2_initialize_interface(mDDSoftingCAN->can, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0);
	if(ret) {
		ModelicaFormatError("%s",descriptiveError(ret, "CANL2_initialize_interface"));
		exit(ret);
	}
	ModelicaFormatMessage("\tOK.\n");

	return ((void*) mDDSoftingCAN);
}


DllExport void MDD_softingCANDestructor(void* p_mDDSoftingCAN) {
    MDDSoftingCAN * mDDSoftingCAN = (MDDSoftingCAN *) p_mDDSoftingCAN;
    ModelicaFormatMessage("SoftingCAN (%s): Closing CAN_HANDLE %lu and cleaning up ...", mDDSoftingCAN->deviceName, mDDSoftingCAN->can);
    INIL2_close_channel(mDDSoftingCAN->can);
    free(mDDSoftingCAN);
    ModelicaFormatMessage("\tOK.\n");
}

/** Define objects, interface to CANL2_define_object(..).
 *
 * @param p_mDDSoftingCAN pointer to external object
 * @param ident message identifier
 * @param type direction of transmission (see CANL2 docu)
 *        @arg 0: Standard receive object
 *        @arg 1: Standard transmit object
 *        @arg 2: Extended receive object
 *        @arg 3: Extended transmit object
 * @return object number of related object list
 */
DllExport int MDD_softingCANDefineObject(void* p_mDDSoftingCAN, int ident, int type) {
	MDDSoftingCAN * mDDSoftingCAN = (MDDSoftingCAN *) p_mDDSoftingCAN;
	int objectNumber, ret;
	char msgtype[80];

	/* We need to do "type - 1" since Modelica enumerations start with 1 not zero */
	ret = CANL2_define_object(mDDSoftingCAN->can, ident, &objectNumber,
						type - 1, 0, 0, 1);
	if (ret) {
		ModelicaFormatError("%s",descriptiveError(ret, "CANL2_define_object"));
		exit(ret);
	}
	switch (type) {
	case 1:
		strcpy(msgtype, "std rx");
		break;
	case 2:
		strcpy(msgtype, "std tx");
		break;
	case 3:
		strcpy(msgtype, "ext rx");
		break;
	case 4:
		strcpy(msgtype, "ext tx");
		break;
	default:
		ModelicaFormatError("SoftingCAN: Unsupported message type. Exiting.\n");
		exit(-1);
	}

	ModelicaFormatMessage("SoftingCAN (%s): Defined %s message, id %d (0x%x). Got object number %d.\n",
		mDDSoftingCAN->deviceName, msgtype, ident, ident, objectNumber);
	return objectNumber;
}

DllExport void MDD_softingCANWriteObject(void* p_mDDSoftingCAN, int objectNumber, int dataLength,
			     const char* data) {
	MDDSoftingCAN * mDDSoftingCAN = (MDDSoftingCAN *) p_mDDSoftingCAN;
    int ret;

	ret = CANL2_write_object(mDDSoftingCAN->can, objectNumber, dataLength,
				 (unsigned char*) data);
	if(ret) {
		ModelicaFormatMessage("%s", descriptiveError(ret, "CANL2_write_object"));
	    exit(ret);
	}
}

/** Read received data for a particular CAN object
 * If no new data is available for the requested object a logging message is
 * written using ModelicaFormatMessage and
 * the data from "serialPackager->data" is returned. That particularly allows to return
 * old values (i.e., data received at the last successful retrieval), if there is no
 * new data available
 */
DllExport const char* MDD_softingCANReadRcvData(void* p_mDDSoftingCAN, int objectNumber, void* p_serialPackager) {
	MDDSoftingCAN * mDDSoftingCAN = (MDDSoftingCAN *) p_mDDSoftingCAN;
	SerialPackager * serialPackager = (SerialPackager *) p_serialPackager;
	int frc = CANL2_RA_NO_DATA;
	byte rcvBuffer[8];
	unsigned long Time;

	frc = CANL2_read_rcv_data(mDDSoftingCAN->can, objectNumber,
		rcvBuffer, &Time);
	if (frc < 0) {
		ModelicaFormatMessage("%s", descriptiveError(frc, "CANL2_read_rcv_data"));
	}
	switch (frc) {
	case 0: /* No new data received */
		ModelicaFormatMessage("MDDSoftingCAN (ReadRcvData): No new data for objectNumber %d. Skipping.\n", objectNumber);
		break;
	case 1: /* Data frame received */
		#if 0
	    ModelicaFormatMessage("RCV Data: CAN%lu Ident0x%lX  Obj0x%x  Time%lu  "
		       "Data %2x %2x %2x %2x %2x %2x %2x %2x\n",
		       mDDSoftingCAN->can, -100, objectNumber, Time,
		       msg->data[0],
		       msg->data[1],
		       msg->data[2],
		       msg->data[3],
		       msg->data[4],
		       msg->data[5],
		       msg->data[6],
		       msg->data[7]);
		#endif
		memcpy(serialPackager->data, rcvBuffer, sizeof(rcvBuffer));
	    break;
	case 2: /* Remote frame received */
	    ModelicaFormatError("RCV Remote: CAN%lu Ident0x%lX  Obj0x%x  Time%lu\n",
		       mDDSoftingCAN->can, -100, objectNumber, Time);
	    ModelicaFormatError("Error: Received remote frame instead of data frame, CANL2_read_rcv()\n");
	    exit(-1);
	default:
	    break;
	}
	return (const char*) serialPackager->data;
}

/** Start chips, needs to be called *after* all objects are defined.
 * Calls CANL2_start_chip(..)
 */
DllExport void MDD_softingCANStartChip(void* p_mDDSoftingCAN) {
	MDDSoftingCAN * mDDSoftingCAN = (MDDSoftingCAN *) p_mDDSoftingCAN;
	int ret;
	ModelicaFormatMessage("SoftingCAN (%s): Starting chip ...", mDDSoftingCAN->deviceName);
	ret = CANL2_start_chip(mDDSoftingCAN->can);
	if(ret) {
		ModelicaFormatError("%s",descriptiveError(ret, "CANL2_start_chip"));
		exit(ret);
	}
	ModelicaFormatMessage("\tOK.\n");
}



/** Turn Softing(USB)-CAN error code into human readable descriptive string.
*/
static char * descriptiveError(int ret, const char * caller_function) {

	if (ret<0)
		sprintf(mDDErrorMsg, "CANL2 Error nr: %i in function %s: \n", ret, caller_function);
	switch (ret) {
		case -1:
		if (caller_function=="CANL2_write_signals") strcat(mDDErrorMsg, "CANL2_write_signals: signals have not yet been initialized, this must be done by using CANL2_init_signals() \n");
		else if (caller_function=="CANL2_set_rcv_fifo_size") strcat(mDDErrorMsg, "CANL2_set_rcv_fifo_size: The FIFO size can not be changed, because the CAN controller is already online \n");
		else if (caller_function=="CANL2_init_signals") strcat(mDDErrorMsg, "CANL2_init_signals: signals have already been initialized \n");
		break;

		case -2:
		strcpy(mDDErrorMsg, "An exclusive input port has been defined as output. \n\n");
		if (caller_function=="CANL2_write_signals")strcat(mDDErrorMsg, "CANL2_write_signals: write access to an input signal \n");
		else if (caller_function=="CANL2_init_signals")strcat(mDDErrorMsg, "CANL2_init_signals: An exclusive input port has been defined as output / Error: write access to an input signal \n\n");
		break;

		case -3:
		strcat(mDDErrorMsg, "Error accessing DPRAM \n\n");
		break;

		case -4:
		strcat(mDDErrorMsg, "Timeout firmware communication \n\n");
		break;

		case -99:
		strcat(mDDErrorMsg, "Board not initialized: INIL2_initialize_channel() was not yet called or a INIL2_close_channel() was done \n\n");
		break;

		case -102:
		strcat(mDDErrorMsg, "Parameter error / wrong parameter \n\n");
		break;

		case -104:
		strcat(mDDErrorMsg, "Timeout firmware communication \n\n");
		break;

		case -108:
		strcat(mDDErrorMsg, "Wrong hardware; (CANcard2 or EDICcard2 with 25MHz instead of 24MHz) \n\n");
		break;

		case -109:
		strcat(mDDErrorMsg, "Dyn. Obj. buffer mode not enabled \n\n");
		break;

		case -110:
		strcat(mDDErrorMsg, "Last request still pending \n\n");
		break;

		case -111:
		strcat(mDDErrorMsg, "Receive data frame overrun \n\n");
		break;

		case -112:
		strcat(mDDErrorMsg, "Receive remote frame overrun \n\n");
		break;

		case -113:
		strcat(mDDErrorMsg, "Object is undefined \n\n");
		break;

		case -114:
		strcat(mDDErrorMsg, "Transmit acknowledge overrun \n\n");
		break;

		case -115:
		strcat(mDDErrorMsg, "Object is not defined / access to an object denied, because the object has not been initialized with data using CANL2_supply_object() \n\n");
		break;

		case -116:
		strcat(mDDErrorMsg, "Transmit request FIFO overrun \n\n");
		break;

		case -602:
		strcat(mDDErrorMsg, "Unable to open USB pipe \n\n");
		break;

		case -603:
		strcat(mDDErrorMsg, "Communication via USB pipe broken \n\n");
		break;

		case -604:
		strcat(mDDErrorMsg, "No valid lookup table entry found \n\n");
		break;

		case -611:
		strcat(mDDErrorMsg, "CANusb framework initialization failed \n\n");
		break;

		case -1000:
		strcat(mDDErrorMsg, "Invalid channel handle / Channel not initialized: INIL2_initialize_channel() was not yet called or a INIL2_close_channel() was done \n\n");
		break;

		case -1002:
		strcat(mDDErrorMsg, "Too many open channels. \n\n");
		break;

		case -1003:
		strcat(mDDErrorMsg, "Wrong DLL or driver version. \n\n");
		break;

		case -1004:
		strcat(mDDErrorMsg, "Error while loading the firmware. (This may be a DPRAM access error) \n\n");
		break;

		case -1005:
		strcat(mDDErrorMsg, "CANusb DLL (CANusbM.dll) not found \n\n");
		break;

		case -536215500:
		strcat(mDDErrorMsg, "Error while calling a Windows function \n\n");
		break;

		case -536215511:
		strcat(mDDErrorMsg, "Channel can not be accessed, because it is not open \n\n");
		break;

		case -536215512:
		strcat(mDDErrorMsg, "An incompatible firmware is running on that device (CANalyzer/CANopen/DeviceNet firmware) \n\n");
		break;

		case -536215514:
		strcat(mDDErrorMsg, "Device is already open \n\n");
		break;

		case -536215516:
		strcat(mDDErrorMsg, "Interrupt does not work/Interrupt test failed! \n\n");
		break;

		case -536215519:
		strcat(mDDErrorMsg, "Can not access the DPRAM memory \n\n");
		break;

		case -536215521:
		strcat(mDDErrorMsg, "Error while accessing hardware \n\n");
		break;

		case -536215522:
		strcat(mDDErrorMsg, "Can not get a free address region for DPRAM from system \n\n");
		break;

		case -536215523:
		strcat(mDDErrorMsg, "Device not found \n\n");
		break;

		case -536215531:
		strcat(mDDErrorMsg, "An error occurred while hooking the interrupt service routine \n\n");
		break;

		case -536215541:
		strcat(mDDErrorMsg, "Out of memory \n\n");
		break;

		case -536215542:
		strcat(mDDErrorMsg, "Driver not loaded / not installed, or device is not plugged. \n\n");
		break;

		case -536215546:
		strcat(mDDErrorMsg, "Illegal driver call \n\n");
		break;

		case -536215550:
		strcat(mDDErrorMsg, "General Error \n\n");
		break;

		case -536215551:
		strcat(mDDErrorMsg, "Internal Error \n\n");
		break;
	}
return mDDErrorMsg;
}

#endif /* MDDSOFTINGCAN_H_ */
