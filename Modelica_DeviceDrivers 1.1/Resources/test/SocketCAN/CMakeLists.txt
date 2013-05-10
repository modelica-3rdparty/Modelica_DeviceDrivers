#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

# Some test applications

include_directories(../../Include)

if (UNIX)
  add_executable(test_MDDSocketCAN test_MDDSocketCAN.c ../Util/ModelicaUtilities.c)
  # Make sure to link with the correct threading library:
  find_package (Threads)
  target_link_libraries(test_MDDSocketCAN MDDUtil ${CMAKE_THREAD_LIBS_INIT})
  add_test(test_MDDSocketCAN ${EXECUTABLE_OUTPUT_PATH}/test_MDDSocketCAN)
else (UNIX)
  message("Socket CAN support only available for linux. Skipping ..")
endif (UNIX)



