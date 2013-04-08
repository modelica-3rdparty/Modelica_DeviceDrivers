/** 3Dconnexion space mouse support.
 *
 * @file
 * @author      Tobias Bellmann <tobias.bellmann@dlr.de> (Windows)
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de> (Linux)
 * @version     $Id$
 * @since       2012-06-05
 * @copyright Modelica License 2
 *
 *
*/

#include "../include/CompatibilityDefs.h"
#include "ModelicaUtilities.h"

#if defined(_MSC_VER)

  #include <wtypes.h>
  #include <setupapi.h>
  #include "../../thirdParty/hdisdi/hidsdi.h"
  #include <malloc.h>
  #include "../../Include/MDDSpaceMouse.h"

  #define MAX_DEVICES 10
  int SPC_nDevices  = 0;
  /* Struct for the HID devices */
  typedef struct _HidDevice {
          PSP_DEVICE_INTERFACE_DETAIL_DATA  pDevInterfaceDetailData;
          HANDLE handle;
          PHIDP_PREPARSED_DATA pPreparsedData;
          HIDP_CAPS capabilities;
          PHIDP_BUTTON_CAPS pInButCaps,pOutButCaps,pFeatButCaps;
          PHIDP_VALUE_CAPS pInValCaps,pOutValCaps,pFeatValCaps;
          char *buf;
          BOOL bGotTranslationVector, bGotRotationVector;
          int allDOFs[6];
  } HidDevice;
  HidDevice SPC_Devices[MAX_DEVICES];
  double SPC_Axes[6] ={0};
  int SPC_Buttons[16] = {0};
  int SPC_bRun = 1;
  DWORD SPC_ThreadID = 0;

  /** Internal thread that queries the space mouse values
   */
  DWORD WINAPI MDD_spaceMouseGetDataThread(LPVOID pthis)
  {

          /*------------ search for devices attached ------------------*/
          GUID hidGuid;
          DWORD requiredSize;
          int memberIndex=0;
          SP_DEVICE_INTERFACE_DATA  DevInterfaceData;
          int listIndex, waitListIndex = 0;
          HANDLE *waitListHandles;
          HidDevice **waitListItems;
          HidDevice *pDev;
          DWORD nread, waitResult;
          int i;
          HDEVINFO hDevInfo;

          HidD_GetHidGuid( &hidGuid );
          hDevInfo = SetupDiGetClassDevs( &hidGuid, NULL, NULL,
                                                      DIGCF_DEVICEINTERFACE | DIGCF_PRESENT | DIGCF_PROFILE );




          DevInterfaceData.cbSize = sizeof(SP_DEVICE_INTERFACE_DATA);
          while(SetupDiEnumDeviceInterfaces( hDevInfo, NULL, &hidGuid, memberIndex, &DevInterfaceData ))
          {


                  /* First call, just gets the size so we can malloc enough memory for the detail struct */
                  SetupDiGetDeviceInterfaceDetail( hDevInfo, &DevInterfaceData, NULL, 0, &requiredSize, NULL );

                  /* Second call gets the data */
                  SPC_Devices[SPC_nDevices ].pDevInterfaceDetailData = (PSP_DEVICE_INTERFACE_DETAIL_DATA) malloc( requiredSize );
                  SPC_Devices[SPC_nDevices ].pDevInterfaceDetailData->cbSize = sizeof( SP_DEVICE_INTERFACE_DETAIL_DATA );
                  SetupDiGetDeviceInterfaceDetail( hDevInfo,
                                                                                  &DevInterfaceData,
                                                                                  SPC_Devices[SPC_nDevices ].pDevInterfaceDetailData,
                                                                                  requiredSize,
                                                                                  NULL,
                                                                                  NULL );


                  /* Open this device */
                  SPC_Devices[SPC_nDevices ].handle = CreateFile(SPC_Devices[SPC_nDevices ].pDevInterfaceDetailData->DevicePath,
                                                                                                  GENERIC_READ | GENERIC_WRITE,
                                                                                                  FILE_SHARE_READ | FILE_SHARE_WRITE,
                                                                                                  NULL,
                                                                                                  OPEN_EXISTING,
                                                                                                  FILE_ATTRIBUTE_NORMAL,
                                                                                                  NULL);
                  if ( SPC_Devices[SPC_nDevices ].handle == NULL)
                  {

                          goto next;
                  }

                  /* Get the preparsedData struct */
                  if (HidD_GetPreparsedData( SPC_Devices[SPC_nDevices ].handle, &SPC_Devices[SPC_nDevices ].pPreparsedData ) != TRUE)
                  {

                          goto next;
                  }

                  if ( HidP_GetCaps( SPC_Devices[SPC_nDevices ].pPreparsedData, &SPC_Devices[SPC_nDevices ].capabilities ) != HIDP_STATUS_SUCCESS )
                  {

                          goto next;
                  }

  next:
                  memberIndex++;
                  if (++SPC_nDevices  == MAX_DEVICES) {--SPC_nDevices ;}
          } /* end of while(SetupDiEnumDeviceInterfaces) loop */

          /* Done with devInfo list.  Release it. */
          SetupDiDestroyDeviceInfoList( hDevInfo );


          /* Read data from each usagePage==1, usage==8 device */

          waitListHandles = (HANDLE *)malloc(SPC_nDevices  * sizeof(HANDLE ));
          waitListItems  = (HidDevice **)malloc(SPC_nDevices  * sizeof(HidDevice*));

          for (listIndex=0; listIndex < SPC_nDevices ; listIndex++)
          {
                  if (SPC_Devices[listIndex].capabilities.UsagePage == 1 && SPC_Devices[listIndex].capabilities.Usage == 8)
                  {
                          /* Add its handle and a pointer to the waitList */
                          waitListHandles[waitListIndex] = SPC_Devices[listIndex].handle;
                          pDev = SPC_Devices + listIndex;
                          waitListItems  [waitListIndex] = pDev;
                          pDev->buf = (char *)malloc(pDev->capabilities.InputReportByteLength );
                          ZeroMemory( pDev->buf, pDev->capabilities.InputReportByteLength );
                          pDev->bGotTranslationVector =
                          pDev->bGotRotationVector    = FALSE;
                          waitListIndex++;
                  }
          }

          if (waitListIndex > 0)
          {




                  int iButton;
                  while(SPC_bRun)
                  {
                          /* This only wakes for one of the HID devices.  Not sure why. */
                          waitResult = WaitForMultipleObjects( waitListIndex, waitListHandles, FALSE, 10);



                          /* a HID device event */
                          if (waitResult < WAIT_OBJECT_0 + waitListIndex )
                          {
                                  int index = waitResult - WAIT_OBJECT_0;
                                  pDev = waitListItems[index];
                                  if (ReadFile(pDev->handle,
                                                          pDev->buf,
                                                      pDev->capabilities.InputReportByteLength,
                                                      &nread,
                                                      FALSE))
                                  {

                                  switch ( pDev->buf[0] )
                                  {
                                          case 0x01:
                                                  if (nread != 7) break; /* something is wrong */

                                                  pDev->bGotTranslationVector = TRUE;
                                                  pDev->allDOFs[0] = (pDev->buf[1] & 0x000000ff) | ((int)pDev->buf[2]<<8 & 0xffffff00);
                                                  pDev->allDOFs[1] = (pDev->buf[3] & 0x000000ff) | ((int)pDev->buf[4]<<8 & 0xffffff00);
                                                  pDev->allDOFs[2] = (pDev->buf[5] & 0x000000ff) | ((int)pDev->buf[6]<<8 & 0xffffff00);
                                                  break;

                                          case 0x02:
                                                  if (nread != 7) break; /* something is wrong */

                                                  pDev->bGotRotationVector    = TRUE;
                                                  pDev->allDOFs[3] = (pDev->buf[1] & 0x000000ff) | ((int)pDev->buf[2]<<8 & 0xffffff00);
                                                  pDev->allDOFs[4] = (pDev->buf[3] & 0x000000ff) | ((int)pDev->buf[4]<<8 & 0xffffff00);
                                                  pDev->allDOFs[5] = (pDev->buf[5] & 0x000000ff) | ((int)pDev->buf[6]<<8 & 0xffffff00);
                                                  break;

                                          case 0x03:  /* Buttons (display most significant byte to least) */

                                                  iButton = (pDev->buf[1] + (pDev->buf[2] << 8)+ (pDev->buf[3] << 16));

                                                  if(iButton&1)SPC_Buttons[0] = 1;else SPC_Buttons[0] = 0;
                                                  if(iButton&2)SPC_Buttons[1] = 1;else SPC_Buttons[1] = 0;
                                                  if(iButton&4)SPC_Buttons[2] = 1;else SPC_Buttons[2] = 0;
                                                  if(iButton&8)SPC_Buttons[3] = 1;else SPC_Buttons[3] = 0;
                                                  if(iButton&16)SPC_Buttons[4] = 1;else SPC_Buttons[4] = 0;
                                                  if(iButton&32)SPC_Buttons[5] = 1;else SPC_Buttons[5] = 0;
                                                  if(iButton&64)SPC_Buttons[6] = 1;else SPC_Buttons[6] = 0;
                                                  if(iButton&128)SPC_Buttons[7] = 1;else SPC_Buttons[7] = 0;
                                                  if(iButton&256)SPC_Buttons[8] = 1;else SPC_Buttons[8] = 0;
                                                  if(iButton&512)SPC_Buttons[9] = 1;else SPC_Buttons[9] = 0;
                                                  if(iButton&1024)SPC_Buttons[10] = 1;else SPC_Buttons[10] = 0;
                                                  if(iButton&2048)SPC_Buttons[11] = 1;else SPC_Buttons[11] = 0;
                                                  if(iButton&4096)SPC_Buttons[12] = 1;else SPC_Buttons[12] = 0;
                                                  if(iButton&8192)SPC_Buttons[13] = 1;else SPC_Buttons[13] = 0;
                                                  if(iButton&16384)SPC_Buttons[14] = 1;else SPC_Buttons[14] = 0;
                                                  if(iButton&32768)SPC_Buttons[15] = 1;else SPC_Buttons[15] = 0;

                                          default:
                                                  break;
                                  }
                                  if(pDev->bGotTranslationVector && pDev->bGotRotationVector)
                                  {
                                          pDev->bGotTranslationVector = pDev->bGotRotationVector = FALSE;


                                          for (i = 0; i< 6;i++)
                                                  SPC_Axes[i] = (double)pDev->allDOFs[i];


                                  }


                                  }
                          }


                  }

                  for(i=0; i<SPC_nDevices ; i++)
                  {
                          /* Free the preparsedData */
                          if (SPC_Devices[i].pPreparsedData)
                                  HidD_FreePreparsedData( SPC_Devices[i].pPreparsedData );

                          /* Close handles */
                          if (SPC_Devices[i].handle != INVALID_HANDLE_VALUE)
                                  CloseHandle( SPC_Devices[i].handle );

                          /* Free pDevInterfaceDetailData */
                          if (SPC_Devices[i].pDevInterfaceDetailData)
                                  free ( SPC_Devices[i].pDevInterfaceDetailData );

                          if (SPC_Devices[i].buf)
                                  free ( SPC_Devices[i].buf );
                  }
          }
          return 0;
  }

  /** Get space mouse data
   * @param[out] pdAxes array with 6 elements (value range [-1 1])
   * @param[out] piButtons array with 16 elements
   * */
  void MDD_spaceMouseGetData(double * pdAxes, int * piButtons)
  {
          int i,j;
          if (SPC_ThreadID == 0)
                  CreateThread(0,1024,MDD_spaceMouseGetDataThread,NULL,0,&SPC_ThreadID);
          for (i=0; i< 6;i++)
                  pdAxes[i] = SPC_Axes[i];
          for (j=0; j< 16;j++)
                  piButtons[j] = SPC_Buttons[j];
  }

#elif defined(__linux__)

  /* This #define is a hack needed since X11 declares "Time" and
   * also Dymola declares "Time" which then results in a compile
   * error. So we temporarly rename Time to MDDTime and hope
   * for the best.
  */
   /*#define Time MDDTime
     #include <X11/Xlib.h>
     #include <X11/Xutil.h>
     #undef Time */
  #include <stdlib.h>
  #include <stdio.h>
  #include <errno.h>

  #include <X11/Xlib.h>
  #include <X11/Xutil.h>
  #include <X11/Xos.h>
  #include <X11/Xatom.h>
  #include <X11/keysym.h>

  #include "../../thirdParty/3DconnexionSDK/xdrvlib.h"
  #include "../../Include/MDDSpaceMouse.h"


  #define MDD_N_AXES (6)
  #define MDD_N_BUTTONS (16)
  #define MDD_DEBUG (0)

  typedef struct {
    double axes[MDD_N_AXES];
    int buttons[MDD_N_BUTTONS];
    int runXEventsProccesing;
    pthread_t thread;
  } MDDSpaceMouse;

  int MDD_spaceMouseXEventsProcessing(void *p_mDDSpaceMouse);

  MDD_spaceMouseGetData(double * pdAxes, int * piButtons) {
    static MDDSpaceMouse* mDDSpaceMouse = NULL;
    int i,ret;

    if (mDDSpaceMouse == NULL) {
      mDDSpaceMouse = malloc(sizeof(MDDSpaceMouse));

      for(i=0; i < MDD_N_AXES; i++) mDDSpaceMouse->axes[i] = 0;
      for(i=0; i < MDD_N_BUTTONS; i++) mDDSpaceMouse->buttons[i] = 0;

      /* Start dedicated xevent processing thread */
      mDDSpaceMouse->runXEventsProccesing = 1;
      ret = pthread_create(&mDDSpaceMouse->thread, 0, (void *) MDD_spaceMouseXEventsProcessing, mDDSpaceMouse);
      if (ret) {
          ModelicaFormatError("MDDSpaceMouse.c: pthread(..) failed (%s)\n", strerror(errno));
          exit (-1);
      }
    }

    for (i=0; i < MDD_N_AXES; i++)
            pdAxes[i] = mDDSpaceMouse->axes[i];
    for (i=0; i < MDD_N_BUTTONS; i++)
            piButtons[i] = mDDSpaceMouse->buttons[i];
  }

  /** Dedicated thread for receiving xevents.
   *
   * @param p_mDDSpaceMouse pointer address to MDDSpaceMouse object
   */
  int MDD_spaceMouseXEventsProcessing(void *p_mDDSpaceMouse) {
    MDDSpaceMouse* mDDSpaceMouse = (MDDSpaceMouse*) p_mDDSpaceMouse;

    Display *display;
    Window window;

    int i;
    XSizeHints *sizehints;
    XWMHints *wmhints;
    XClassHint *classhints;

    GC wingc;
    XGCValues xgcvalues;

    XEvent xevent;
    MagellanFloatEvent mevent;

    char debugBuffer[ 256 ];

    wmhints    = XAllocWMHints();
    classhints = XAllocClassHint();
    if ( (wmhints==NULL) || (classhints==NULL) ) {
      ModelicaFormatError("MDDSpaceMouse.c: XAllocWMHints or XAllocClassHint failed\n" );
      exit( -1 );
    };

    display = XOpenDisplay( NULL );
    if ( display == NULL ) {
      ModelicaFormatError("MDDSpaceMouse.c: XOpenDisplay failed \n");
      exit( -1 );
    };

    window = XCreateSimpleWindow( display, DefaultRootWindow(display),
                                  0, 0, 100, 100, 20,
                                  BlackPixel(display, DefaultScreen(display)),
                                  WhitePixel(display, DefaultScreen(display)) );

    wmhints->initial_state = NormalState;
    wmhints->input = TRUE;
    wmhints->flags = StateHint | InputHint;

    classhints->res_name = "Space Mouse (Magellan) Modelica Interface";
    classhints->res_class = "BasicWindow";
    XSetWMProperties( display, window, NULL, NULL, NULL,
                      0, NULL, wmhints, classhints );


    xgcvalues.foreground = BlackPixel( display, 0 );
    xgcvalues.background = WhitePixel( display, 0 );
    wingc = XCreateGC( display, window, GCForeground | GCBackground, &xgcvalues );

    /* Magellan Event Types */
    if ( !MagellanInit( display, window ) ) {
      ModelicaFormatError("Space Mouse (Magellan) driver not running. Exit ... \n" );
      exit(-1);
    };

    #if MDD_DEBUG
    XMapWindow( display, window );
    #else
    XUnmapWindow(display, window); /* We really want the window 'invisible'! */
    #endif /* MDD_DEBUG */

    ModelicaFormatMessage("Space Mouse: Entering event loop in dedicated thread."
    " Root window=%d, Application window=%d\n", DefaultRootWindow(display), window);
    /* XEvent loop */
    while( mDDSpaceMouse->runXEventsProccesing ) {
      XNextEvent( display, &xevent );
      switch( xevent.type ) {

        case ClientMessage :
          switch( MagellanTranslateEvent( display, &xevent, &mevent, 1.0, 1.0 ) ) {
            case MagellanInputMotionEvent :
              MagellanRemoveMotionEvents( display );
              #if MDD_DEBUG
              sprintf( debugBuffer,
                  "x=%+5.0lf y=%+5.0lf z=%+5.0lf a=%+5.0lf b=%+5.0lf c=%+5.0lf   ",
                        mevent.MagellanData[ MagellanX ],
                        mevent.MagellanData[ MagellanY ],
                        mevent.MagellanData[ MagellanZ ],
                        mevent.MagellanData[ MagellanA ],
                        mevent.MagellanData[ MagellanB ],
                        mevent.MagellanData[ MagellanC ] );
              ModelicaFormatMessage("Motion Event: %s\n", debugBuffer);
              XClearWindow( display, window );
              XDrawString( display, window, wingc, 10,40,
                            debugBuffer, (int)strlen(debugBuffer) );
              XFlush( display );
              #endif
              mDDSpaceMouse->axes[0] = mevent.MagellanData[ MagellanX ];
              mDDSpaceMouse->axes[1] = mevent.MagellanData[ MagellanY ];
              mDDSpaceMouse->axes[2] = mevent.MagellanData[ MagellanZ ];
              mDDSpaceMouse->axes[3] = mevent.MagellanData[ MagellanA ];
              mDDSpaceMouse->axes[4] = mevent.MagellanData[ MagellanB ];
              mDDSpaceMouse->axes[5] = mevent.MagellanData[ MagellanC ];

              break;

            case MagellanInputButtonPressEvent :
              #if MDD_DEBUG
              sprintf( debugBuffer, "Button pressed [%d]  ", mevent.MagellanButton );
              ModelicaFormatMessage("%s\n", debugBuffer);
              XClearWindow( display, window );
              XDrawString( display, window, wingc, 10,40,
                            debugBuffer, (int)strlen(debugBuffer) );
              XFlush( display );
              #endif
              i = mevent.MagellanButton - 1;
              if (i < MDD_N_BUTTONS) {
                mDDSpaceMouse->buttons[i] = 1;
              } else {
                ModelicaFormatError("MDDSpaceMouse.c: Button %i is out of range (max=%d)\n", i, MDD_N_BUTTONS - 1);
                exit(-1);
              }

              break;

            case MagellanInputButtonReleaseEvent :
              #if MDD_DEBUG
              sprintf( debugBuffer, "Button released [%d] ", mevent.MagellanButton );
              printf("%s\n", debugBuffer);
              XClearWindow( display, window );
              XDrawString( display, window, wingc, 10,40,
                            debugBuffer, (int)strlen(debugBuffer) );
              XFlush( display );
              #endif
              i = mevent.MagellanButton - 1;
              if (i < MDD_N_BUTTONS) {
                mDDSpaceMouse->buttons[i] = 0;
              } else {
                ModelicaFormatError("MDDSpaceMouse.c: Button %i is out of range (max=%d)\n", i, MDD_N_BUTTONS - 1);
                exit(-1);
              }
              break;

          default : /* Ignore all other events that might slip through */
            break;
          };
          break;
        };
      };

    /* We will never get there. But if we did, we would clean up ;-) */
    MagellanClose( display );
    XFree( wmhints );
    XFree( classhints );
    XFreeGC( display, wingc );
    XDestroyWindow( display, window );
    XCloseDisplay( display );

    return 0;
  }



#else

  #error "Modelica_DeviceDrivers: No Keyboard support for your platform"

#endif /* defined(_MSC_VER) */

