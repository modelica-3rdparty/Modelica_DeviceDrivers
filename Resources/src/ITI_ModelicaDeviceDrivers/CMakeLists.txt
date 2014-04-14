message(STATUS "WRITING BUILD FILES FOR ITI_ModelicaDeviceDrivers")
#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

set(libSrcsITI_ModelicaDeviceDriversLibrary MDDWrapper.c)
set(libSrcsITI_ModelicaDeviceDriversSoftingCANLibrary MDDSoftingCANWrapper.c)

if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  find_library( MODELICA_EXTERNAL_C ModelicaExternalC
	PATHS   ${PROJECT_SOURCE_DIR}/thirdParty/ITI/win64)
  find_library( CANL2_LIBRARY canL2_64
      PATHS   ${PROJECT_SOURCE_DIR}/thirdParty/softing/win64)
elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
  find_library( MODELICA_EXTERNAL_C ModelicaExternalC
	PATHS   ${PROJECT_SOURCE_DIR}/thirdParty/ITI/win32)
  find_library( CANL2_LIBRARY canL2
      PATHS   ${PROJECT_SOURCE_DIR}/thirdParty/softing/win32)
else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  message(SEND_ERROR "Uups. Neither 64, nor 32 bit??")
endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )

add_library(ITI_ModelicaDeviceDrivers SHARED ${libSrcsITI_ModelicaDeviceDriversLibrary})
# FIXME ${MDDUtil} might not be needed
target_link_libraries(ITI_ModelicaDeviceDrivers ${MODELICA_EXTERNAL_C} ${MDDUtil})

if ( CANL2_LIBRARY )
	add_library(ITI_ModelicaDeviceDriversSoftingCAN SHARED ${libSrcsITI_ModelicaDeviceDriversSoftingCANLibrary})
	# FIXME ${MDDUtil} might not be needed
	target_link_libraries(ITI_ModelicaDeviceDriversSoftingCAN ${MODELICA_EXTERNAL_C} ${MDDUtil} ${CANL2_LIBRARY})
else ( CANL2_LIBRARY )
  	message("Softing canL2 libraries not found. Skipping build of ITI_ModelicaDeviceDriversSoftingCAN.dll ...")
endif ( CANL2_LIBRARY )


# install to directory (CMAKE_INSTALL_PREFIX) into subdirectory "lib"
if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  install(TARGETS ITI_ModelicaDeviceDrivers DESTINATION Library/win64)
  if ( CANL2_LIBRARY )
	install(TARGETS ITI_ModelicaDeviceDriversSoftingCAN DESTINATION Library/win64)
  endif ( CANL2_LIBRARY )
elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
  install(TARGETS ITI_ModelicaDeviceDrivers DESTINATION Library/win32)
  if ( CANL2_LIBRARY )
	install(TARGETS ITI_ModelicaDeviceDriversSoftingCAN DESTINATION Library/win32)
  endif ( CANL2_LIBRARY )
else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  message(SEND_ERROR "Uups. Shouldn't be possible to get here")
endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )






