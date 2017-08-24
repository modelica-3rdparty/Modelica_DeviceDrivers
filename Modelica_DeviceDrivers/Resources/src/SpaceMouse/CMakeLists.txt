message(STATUS "WRITING BUILD FILES FOR MDDSpaceMouse library")
#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")


if (CMAKE_COMPILER_IS_GNUCC)
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pthread")
endif (CMAKE_COMPILER_IS_GNUCC)

if (UNIX)
  find_file(srcXdrvlib xdrvlib.c PATHS ${PROJECT_SOURCE_DIR}/thirdParty/3DconnexionSDK)
  if (srcXdrvlib)
    set(libSrcsMDDSpaceMouseLibrary MDDSpaceMouse.c ${srcXdrvlib})
    add_library(MDDSpaceMouse STATIC ${libSrcsMDDSpaceMouseLibrary})
    target_link_libraries(MDDSpaceMouse m X11 pthread)
  else (srcXdrvlib)
    message("xdrvlib.c not found. No support for 3Dconnexion Space Mouse!")
  endif (srcXdrvlib)
else (MSVC)
  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
	  find_library( MSVC_HID_LIBRARY hid
		PATHS   ${PROJECT_SOURCE_DIR}/thirdParty/hdisdi/amd64)
	  find_library( MSVC_SETUPAPI_LIBRARY setupapi
		PATHS   ${PROJECT_SOURCE_DIR}/thirdParty/hdisdi/amd64)
  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
	  find_library( MSVC_HID_LIBRARY hid
		PATHS   ${PROJECT_SOURCE_DIR}/thirdParty/hdisdi/i386)
	  find_library( MSVC_SETUPAPI_LIBRARY setupapi
		PATHS   ${PROJECT_SOURCE_DIR}/thirdParty/hdisdi/i386)
  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
	  message(SEND_ERROR "Uups. Neither 64, nor 32 bit??")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  if ( MSVC_HID_LIBRARY )
	  set(libSrcsMDDSpaceMouseLibrary MDDSpaceMouse.c)
	  add_library(MDDSpaceMouse SHARED ${libSrcsMDDSpaceMouseLibrary})
	  target_link_libraries(MDDSpaceMouse ${MSVC_HID_LIBRARY} ${MSVC_SETUPAPI_LIBRARY})
	  # 2014-04-14: Hack to create a static library of the same name that overwrites previously created import lib.
	  add_library(MDDSpaceMouseStatic STATIC ${libSrcsMDDSpaceMouseLibrary})
	  set_target_properties(MDDSpaceMouseStatic PROPERTIES OUTPUT_NAME MDDSpaceMouse)
	  # Overwrite compile flag /MD with /MT to silence some compiler warnings when using lib with Dymola
	  set_target_properties(MDDSpaceMouseStatic PROPERTIES COMPILE_FLAGS "${STATIC_FLAGS} /MT")
	  # Unfortunately the following doesn't combine the libraries as intended,
	  # and it seems not to be possible, yet:
	  # http://cmake.3232098.n2.nabble.com/Merge-two-static-libraries-tp5602251p5602276.html
	  # The libraries below get instead linked directly into the
	  # test_MDDSpaceMouse executable.
	  # ==> NEED TO COMBINE THE LIBRARIES *MANUALLY* IN MSVC!
	  message("MDDSpaceMouseStatic: Add libraries hid.lib and setupapi.lib manually to generated VS project, since not supported to do that  automatically by CMake")
	  target_link_libraries(MDDSpaceMouseStatic ${MSVC_HID_LIBRARY} ${MSVC_SETUPAPI_LIBRARY})
	  # Force 'MDDSpaceMouse' to be built before 'MDDSpaceMouseStatic':
	  add_dependencies(MDDSpaceMouseStatic MDDSpaceMouse)
  else ( MSVC_HID_LIBRARY )
	message("hid.lib not found. No support for 3Dconnexion Space Mouse!")
  endif ( MSVC_HID_LIBRARY )
else (UNIX)
  message(SEND_ERROR "Uups. Not UNIX, not MSVC")
endif (UNIX)

if ( MSVC_HID_LIBRARY OR srcXdrvlib )
# Space Mouse libraries available: install to directory (CMAKE_INSTALL_PREFIX) into subdirectory "Library/.."
if ( (CMAKE_SIZEOF_VOID_P EQUAL 8) AND (NOT M32_FLAG) )
  if (UNIX)
	install(TARGETS MDDSpaceMouse DESTINATION Library/linux64)
  else (UNIX)
	install(TARGETS MDDSpaceMouse DESTINATION Library/win64)
  endif (UNIX)
elseif ( (CMAKE_SIZEOF_VOID_P EQUAL 4) OR M32_FLAG)
  if (UNIX)
	install(TARGETS MDDSpaceMouse DESTINATION Library/linux32)
	install(TARGETS MDDSpaceMouseStatic DESTINATION Library/linux32)
  else (UNIX)
	install(TARGETS MDDSpaceMouse DESTINATION Library/win32)
	install(TARGETS MDDSpaceMouseStatic DESTINATION Library/win32)
  endif (UNIX)
else ( (CMAKE_SIZEOF_VOID_P EQUAL 8) AND (NOT M32_FLAG) )
  message(SEND_ERROR "Uups. Neither 64, nor 32 bit??")
endif ( (CMAKE_SIZEOF_VOID_P EQUAL 8) AND (NOT M32_FLAG) )
endif ( MSVC_HID_LIBRARY OR srcXdrvlib )





