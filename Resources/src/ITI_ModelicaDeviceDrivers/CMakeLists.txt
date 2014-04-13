message(STATUS "WRITING BUILD FILES FOR ITI_ModelicaDeviceDrivers")
#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

set(libSrcsITI_ModelicaDeviceDriversLibrary MDDWrapper.c)

if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  find_library( MODELICA_EXTERNAL_C ModelicaExternalC
	PATHS   ${PROJECT_SOURCE_DIR}/thirdParty/ITI/win64)
elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
  find_library( MODELICA_EXTERNAL_C ModelicaExternalC
	PATHS   ${PROJECT_SOURCE_DIR}/thirdParty/ITI/win32)
else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  message(SEND_ERROR "Uups. Neither 64, nor 32 bit??")
endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )

add_library(ITI_ModelicaDeviceDrivers SHARED ${libSrcsITI_ModelicaDeviceDriversLibrary})

target_link_libraries(ITI_ModelicaDeviceDrivers ${MODELICA_EXTERNAL_C})

# install to directory (CMAKE_INSTALL_PREFIX) into subdirectory "lib"
if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  install(TARGETS ITI_ModelicaDeviceDrivers DESTINATION Library/win64)
elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
  install(TARGETS ITI_ModelicaDeviceDrivers DESTINATION Library/win32)
else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  message(SEND_ERROR "Uups. Shouldn't be possible to get here")
endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )






