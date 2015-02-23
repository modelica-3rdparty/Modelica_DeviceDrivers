#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

# Some test applications

include_directories(../../Include)

if (CMAKE_COMPILER_IS_GNUCC)
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pthread")
endif (CMAKE_COMPILER_IS_GNUCC)
add_executable(test_MDDUDPSocket test_MDDUDPSocket.c ../Util/ModelicaUtilities.c)
add_test(test_MDDUDPSocket ${EXECUTABLE_OUTPUT_PATH}/test_MDDUDPSocket)

add_executable(test_MDDSerialPackager
  test_MDDSerialPackager.c ../Util/ModelicaUtilities.c)
if (NOT MSVC)
  target_link_libraries(test_MDDSerialPackager m)
endif (NOT MSVC)
add_test(test_MDDSerialPackager
  ${EXECUTABLE_OUTPUT_PATH}/test_MDDSerialPackager)

add_executable(test_MDDSharedMemory
  test_MDDSharedMemory.c ../Util/ModelicaUtilities.c)
if (NOT MSVC)
  target_link_libraries(test_MDDSharedMemory rt)
endif (NOT MSVC)
add_test(test_MDDSharedMemory
  ${EXECUTABLE_OUTPUT_PATH}/test_MDDSharedMemory)

add_executable(test_EndiannessConversion
  test_EndiannessConversion.c ../Util/ModelicaUtilities.c)
add_test(test_EndiannessConversion
  ${EXECUTABLE_OUTPUT_PATH}/test_EndiannessConversion)


# Following is suggested in forums for getting the right threading library
# but unfortunately it doesn't work for me:
# find_package (Threads)
# target_link_libraries (test_MDDUDPSocket ${CMAKE_THREAD_LIBS_INIT})








