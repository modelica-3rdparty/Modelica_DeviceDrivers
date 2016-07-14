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

add_executable(test_MDDUDPSocket test_MDDUDPSocket.c ../Util/ModelicaUtilities.c)
if (UNIX)
  target_link_libraries(test_MDDUDPSocket ${CMAKE_THREAD_LIBS_INIT})
else (UNIX)
  # assume we are in windows
  target_link_libraries(test_MDDUDPSocket Ws2_32)
endif (UNIX)
add_test(test_MDDUDPSocket
	${EXECUTABLE_OUTPUT_PATH}/test_MDDUDPSocket)

add_executable(test_MDDTCPIPSocketClient test_MDDTCPIPSocketClient.c ../Util/ModelicaUtilities.c)
add_test(test_MDDTCPIPSocketClient
${EXECUTABLE_OUTPUT_PATH}/test_MDDTCPIPSocketClient)

add_executable(test_MDDSerialPackager
  test_MDDSerialPackager.c ../Util/ModelicaUtilities.c)
if (NOT MSVC)
  target_link_libraries(test_MDDSerialPackager m)
endif (NOT MSVC)
add_test(test_MDDSerialPackager
  ${EXECUTABLE_OUTPUT_PATH}/test_MDDSerialPackager)

add_executable(test_MDDSharedMemory
  test_MDDSharedMemory.c ../Util/ModelicaUtilities.c)
if (UNIX)
  target_link_libraries(test_MDDSharedMemory rt)
  target_link_libraries(test_MDDSharedMemory ${CMAKE_THREAD_LIBS_INIT})
endif (UNIX)
add_test(test_MDDSharedMemory
  ${EXECUTABLE_OUTPUT_PATH}/test_MDDSharedMemory)

add_executable(test_MDDSerialPort test_MDDSerialPort.c ../Util/ModelicaUtilities.c)
if (UNIX)
  target_link_libraries(test_MDDSerialPort ${CMAKE_THREAD_LIBS_INIT})
endif (UNIX)
add_test(test_MDDSerialPort
	${EXECUTABLE_OUTPUT_PATH}/test_MDDSerialPort)

add_executable(test_EndiannessConversion
  test_EndiannessConversion.c ../Util/ModelicaUtilities.c)
add_test(test_EndiannessConversion
  ${EXECUTABLE_OUTPUT_PATH}/test_EndiannessConversion)

add_executable(test_MDDLCM test_MDDLCM.c ../Util/ModelicaUtilities.c)
target_link_libraries(test_MDDLCM libLcm)
target_link_libraries(test_MDDLCM libGlibGlib20)
if (UNIX)
  target_link_libraries(test_MDDLCM rt)
  target_link_libraries(test_MDDLCM ${CMAKE_THREAD_LIBS_INIT})
endif (UNIX)
add_test(test_MDDLCM
  ${EXECUTABLE_OUTPUT_PATH}/test_MDDLCM)
