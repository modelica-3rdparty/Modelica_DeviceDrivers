#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")
# Some test applications

include_directories(../../Include)

if (UNIX)
  # Make sure to link with the correct threading library (defines ${CMAKE_THREAD_LIBS_INIT}):
  find_package (Threads)
endif (UNIX)
# alternative way to compile with threading for gcc. However, using recommended find_package (Threads) way for the moment
#if (CMAKE_COMPILER_IS_GNUCC)
#SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pthread")
#endif (CMAKE_COMPILER_IS_GNUCC)

if (MSVC)
  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    find_library( PAHO_MQTT3CS_LIBRARY paho-mqtt3cs
        PATHS   ${PROJECT_SOURCE_DIR}/Library/win64)
  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
    find_library( PAHO_MQTT3CS_LIBRARY paho-mqtt3cs
        PATHS   ${PROJECT_SOURCE_DIR}/Library/win32)
  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    message(SEND_ERROR "Uups. Neither 64, nor 32 bit??")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
endif (MSVC)

if (CYGWIN)
  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    find_library( PAHO_MQTT3CS_LIBRARY paho-mqtt3cs-static
        PATHS   ${PROJECT_SOURCE_DIR}/Library/win64)
    find_library( CRYPTO_LIBRARY crypto
        PATHS   ${PROJECT_SOURCE_DIR}/Library/win64)
    find_library( SSL_LIBRARY ssl
        PATHS   ${PROJECT_SOURCE_DIR}/Library/win64)
  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
    find_library( PAHO_MQTT3CS_LIBRARY paho-mqtt3cs-static
        PATHS   ${PROJECT_SOURCE_DIR}/Library/win32)
    find_library( CRYPTO_LIBRARY crypto
        PATHS   ${PROJECT_SOURCE_DIR}/Library/win32)
    find_library( SSL_LIBRARY ssl
        PATHS   ${PROJECT_SOURCE_DIR}/Library/win32)
  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    message(SEND_ERROR "Uups. Neither 64, nor 32 bit??")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
elseif (UNIX)
  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    find_library( PAHO_MQTT3CS_LIBRARY paho-mqtt3cs
        PATHS   ${PROJECT_SOURCE_DIR}/Library/linux64)
    find_library( CRYPTO_LIBRARY crypto
        PATHS   ${PROJECT_SOURCE_DIR}/Library/linux64)
    find_library( SSL_LIBRARY ssl
        PATHS   ${PROJECT_SOURCE_DIR}/Library/linux64)
  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
    find_library( PAHO_MQTT3CS_LIBRARY paho-mqtt3cs
        PATHS   ${PROJECT_SOURCE_DIR}/Library/linux32)
    find_library( CRYPTO_LIBRARY crypto
        PATHS   ${PROJECT_SOURCE_DIR}/Library/linux32)
    find_library( SSL_LIBRARY ssl
        PATHS   ${PROJECT_SOURCE_DIR}/Library/linux32)
  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    message(SEND_ERROR "Uups. Neither 64, nor 32 bit??")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
endif ()

add_executable(test_MDDUDPSocket test_MDDUDPSocket.c ../Util/ModelicaUtilities.c)
set_property(TARGET test_MDDUDPSocket PROPERTY FOLDER "test/Communication")
if (UNIX)
  target_link_libraries(test_MDDUDPSocket ${CMAKE_THREAD_LIBS_INIT})
else (UNIX)
  # assume we are in windows
  target_link_libraries(test_MDDUDPSocket Ws2_32)
endif (UNIX)
add_test(test_MDDUDPSocket
	${EXECUTABLE_OUTPUT_PATH}/test_MDDUDPSocket)

add_executable(test_MDDTCPIPSocketClient test_MDDTCPIPSocketClient.c ../Util/ModelicaUtilities.c)
set_property(TARGET test_MDDTCPIPSocketClient PROPERTY FOLDER "test/Communication")
if (MSVC OR MINGW)
  target_link_libraries(test_MDDTCPIPSocketClient Ws2_32)
endif (MSVC OR MINGW)
add_test(test_MDDTCPIPSocketClient
${EXECUTABLE_OUTPUT_PATH}/test_MDDTCPIPSocketClient)

add_executable(test_MDDSerialPackager
  test_MDDSerialPackager.c ../Util/ModelicaUtilities.c)
set_property(TARGET test_MDDSerialPackager PROPERTY FOLDER "test/Communication")
if (NOT MSVC)
  target_link_libraries(test_MDDSerialPackager m)
endif (NOT MSVC)
add_test(test_MDDSerialPackager
  ${EXECUTABLE_OUTPUT_PATH}/test_MDDSerialPackager)

add_executable(test_MDDSharedMemory
  test_MDDSharedMemory.c ../Util/ModelicaUtilities.c)
set_property(TARGET test_MDDSharedMemory PROPERTY FOLDER "test/Communication")
if (UNIX)
  target_link_libraries(test_MDDSharedMemory rt)
  target_link_libraries(test_MDDSharedMemory ${CMAKE_THREAD_LIBS_INIT})
endif (UNIX)
add_test(test_MDDSharedMemory
  ${EXECUTABLE_OUTPUT_PATH}/test_MDDSharedMemory)

add_executable(test_MDDSerialPort test_MDDSerialPort.c ../Util/ModelicaUtilities.c)
set_property(TARGET test_MDDSerialPort PROPERTY FOLDER "test/Communication")
if (UNIX)
  target_link_libraries(test_MDDSerialPort ${CMAKE_THREAD_LIBS_INIT})
endif (UNIX)
add_test(test_MDDSerialPort
	${EXECUTABLE_OUTPUT_PATH}/test_MDDSerialPort)

add_executable(test_EndiannessConversion
  test_EndiannessConversion.c ../Util/ModelicaUtilities.c)
set_property(TARGET test_EndiannessConversion PROPERTY FOLDER "test/Communication")
add_test(test_EndiannessConversion
  ${EXECUTABLE_OUTPUT_PATH}/test_EndiannessConversion)

add_executable(test_MDDLCM test_MDDLCM.c ../Util/ModelicaUtilities.c)
set_property(TARGET test_MDDLCM PROPERTY FOLDER "test/Communication")
target_link_libraries(test_MDDLCM libLcm)
if (CYGWIN)
  target_link_libraries(test_MDDLCM glib-2.0)
else (CYGWIN)
  target_link_libraries(test_MDDLCM libGlibGlib20)
endif (CYGWIN)
if (UNIX)
  target_link_libraries(test_MDDLCM rt)
  target_link_libraries(test_MDDLCM ${CMAKE_THREAD_LIBS_INIT})
endif (UNIX)
add_test(test_MDDLCM ${EXECUTABLE_OUTPUT_PATH}/test_MDDLCM)
if (MSVC)
  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    set_tests_properties(test_MDDLCM PROPERTIES ENVIRONMENT "PATH=${PROJECT_SOURCE_DIR}/Library/win64;$ENV{PATH}" )
  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
    set_tests_properties(test_MDDLCM PROPERTIES ENVIRONMENT "PATH=${PROJECT_SOURCE_DIR}/Library/win32;$ENV{PATH}" )
  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    message(SEND_ERROR "Uups. Neither 64, nor 32 bit??")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
endif (MSVC)

add_executable(test_MDDMQTT test_MDDMQTT.c ../Util/ModelicaUtilities.c)
set_property(TARGET test_MDDMQTT PROPERTY FOLDER "test/Communication")
target_link_libraries(test_MDDMQTT ${PAHO_MQTT3CS_LIBRARY})
if (CYGWIN)
  target_link_libraries(test_MDDMQTT ${CMAKE_THREAD_LIBS_INIT})
  target_link_libraries(test_MDDMQTT ssl)
  target_link_libraries(test_MDDMQTT crypto)
  target_link_libraries(test_MDDMQTT z)
elseif(UNIX)
  target_link_libraries(test_MDDMQTT ${CMAKE_THREAD_LIBS_INIT})
  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    target_link_libraries(test_MDDMQTT ${PROJECT_SOURCE_DIR}/Library/linux64/libssl.a)
    target_link_libraries(test_MDDMQTT ${PROJECT_SOURCE_DIR}/Library/linux64/libcrypto.a)
  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
    target_link_libraries(test_MDDMQTT ${PROJECT_SOURCE_DIR}/Library/linux32/libssl.a)
    target_link_libraries(test_MDDMQTT ${PROJECT_SOURCE_DIR}/Library/linux32/libcrypto.a)
  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    message(SEND_ERROR "Uups. Neither 64, nor 32 bit??")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
endif ()
add_test(test_MDDMQTT ${EXECUTABLE_OUTPUT_PATH}/test_MDDMQTT)
if (MSVC)
  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    set_tests_properties(test_MDDMQTT PROPERTIES ENVIRONMENT "PATH=${PROJECT_SOURCE_DIR}/Library/win64;$ENV{PATH}" )
  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
    set_tests_properties(test_MDDMQTT PROPERTIES ENVIRONMENT "PATH=${PROJECT_SOURCE_DIR}/Library/win32;$ENV{PATH}" )
  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    message(SEND_ERROR "Uups. Neither 64, nor 32 bit??")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
endif (MSVC)

# Test if we can build a shared library from shipped MDDMQTT binary dependencies
add_library(test_MDDMQTT_buildAsSharedLibrary SHARED test_MDDMQTT_buildAsSharedLibrary ../Util/ModelicaUtilities.c  ../../Include/MDDTCPIPSocketServer.h ../../src/include/util.h)
set_property(TARGET test_MDDMQTT_buildAsSharedLibrary PROPERTY FOLDER "test/Communication")
target_link_libraries(test_MDDMQTT ${PAHO_MQTT3CS_LIBRARY})
if (CYGWIN)
  target_link_libraries(test_MDDMQTT ${CMAKE_THREAD_LIBS_INIT})
  target_link_libraries(test_MDDMQTT ssl)
  target_link_libraries(test_MDDMQTT crypto)
  target_link_libraries(test_MDDMQTT z)
elseif(UNIX)
  target_link_libraries(test_MDDMQTT ${CMAKE_THREAD_LIBS_INIT})
  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    target_link_libraries(test_MDDMQTT ${PROJECT_SOURCE_DIR}/Library/linux64/libssl.a)
    target_link_libraries(test_MDDMQTT ${PROJECT_SOURCE_DIR}/Library/linux64/libcrypto.a)
  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
    target_link_libraries(test_MDDMQTT ${PROJECT_SOURCE_DIR}/Library/linux32/libssl.a)
    target_link_libraries(test_MDDMQTT ${PROJECT_SOURCE_DIR}/Library/linux32/libcrypto.a)
  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    message(SEND_ERROR "Uups. Neither 64, nor 32 bit??")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
endif ()


add_executable(test_MDDTCPIPSocketServer test_MDDTCPIPSocketServer.c ../Util/ModelicaUtilities.c ../../Include/MDDTCPIPSocketServer.h ../../src/include/util.h)
if (UNIX)
	target_link_libraries(test_MDDTCPIPSocketServer ${CMAKE_THREAD_LIBS_INIT})
endif (UNIX)
add_test(test_MDDTCPIPSocketServer ${EXECUTABLE_OUTPUT_PATH}/test_MDDTCPIPSocketServer)
set_property(TARGET test_MDDTCPIPSocketServer PROPERTY FOLDER "test/Communication")

add_executable(TCPIPClientAsRemoteStation TCPIPClientAsRemoteStation.c ../Util/ModelicaUtilities.c)
set_property(TARGET TCPIPClientAsRemoteStation PROPERTY FOLDER "test/Communication")
if (MSVC OR MINGW)
  target_link_libraries(TCPIPClientAsRemoteStation Ws2_32)
endif (MSVC OR MINGW)
