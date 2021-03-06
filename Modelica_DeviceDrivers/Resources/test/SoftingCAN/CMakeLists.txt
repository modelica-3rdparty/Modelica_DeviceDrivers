#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

# Some test applications

include_directories(../../Include)

if (MSVC)

  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    find_library( CANL2_LIBRARY canL2_64
      PATHS   ${PROJECT_SOURCE_DIR}/thirdParty/softing/win64)
  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
    find_library( CANL2_LIBRARY canL2
      PATHS   ${PROJECT_SOURCE_DIR}/thirdParty/softing/win32)
  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    message(SEND_ERROR "Uups. Shouldn't be possible to get here")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )

  if ( CANL2_LIBRARY )
	add_executable(test_MDDSoftingCAN test_MDDSoftingCAN.c ../Util/ModelicaUtilities.c)
	set_property(TARGET test_MDDSoftingCAN PROPERTY FOLDER "test/SoftingCAN")
	target_link_libraries(test_MDDSoftingCAN ${CANL2_LIBRARY})
	add_test(test_MDDSoftingCAN ${EXECUTABLE_OUTPUT_PATH}/test_MDDSoftingCAN)
    if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
      set_tests_properties(test_MDDSoftingCAN PROPERTIES ENVIRONMENT "PATH=${PROJECT_SOURCE_DIR}/thirdParty/softing/win64;$ENV{PATH}" )
    elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
      set_tests_properties(test_MDDSoftingCAN PROPERTIES ENVIRONMENT "PATH=${PROJECT_SOURCE_DIR}/thirdParty/softing/win32;$ENV{PATH}" )
    else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
      message(SEND_ERROR "Uups. Neither 64, nor 32 bit??")
    endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  else ( CANL2_LIBRARY )
  	message("Softing canL2 libraries not found. No support for Softing CAN. Skipping ..")
  endif ( CANL2_LIBRARY )

else (MSVC)
  message("No Softing CAN support for this platform. Skipping ..")
endif (MSVC)

add_executable(test_MDDCANMessage test_MDDCANMessage.c ../Util/ModelicaUtilities.c)
set_property(TARGET test_MDDCANMessage PROPERTY FOLDER "test/SoftingCAN")
add_test(test_MDDCANMessage ${EXECUTABLE_OUTPUT_PATH}/test_MDDCANMessage)
