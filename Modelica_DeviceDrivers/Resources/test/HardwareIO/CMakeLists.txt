#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

# Some test applications

include_directories(../../Include)

if (UNIX)
  # ${COMEDI_LIBRARY} seems to be already predefined in CMake so that following line is without effect in my installation
  find_library( COMEDI_LIBRARY comedi )
  if (${COMEDI_LIBRARY} MATCHES "COMEDI_LIBRARY-NOTFOUND")
    message("Comedi.lib not found. Skipping test generation for comedi module")
  else (${COMEDI_LIBRARY} MATCHES "COMEDI_LIBRARY-NOTFOUND")
    add_executable(test_MDDComedi test_MDDComedi.c ../Util/ModelicaUtilities.c)
    set_property(TARGET test_MDDComedi PROPERTY FOLDER "test/HardwareIO")
    target_link_libraries(test_MDDComedi ${COMEDI_LIBRARY} m)
    add_test(test_MDDComedi ${EXECUTABLE_OUTPUT_PATH}/test_MDDComedi)
  endif (${COMEDI_LIBRARY} MATCHES "COMEDI_LIBRARY-NOTFOUND")

else (UNIX)
  message("Comedi support only available for linux. Skipping ..")
endif (UNIX)
