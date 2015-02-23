message(STATUS "WRITING BUILD FILES FOR DummyRTLibrary")
#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

set(libSrcsMDDDummyX11Library MDDDummyX11Library.c)

add_library(X11 SHARED ${libSrcsMDDDummyX11Library})

# install to directory (CMAKE_INSTALL_PREFIX) into subdirectory "lib"
if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  install(TARGETS X11 DESTINATION Library/win64)
elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
  install(TARGETS X11 DESTINATION Library/win32)
else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  message(SEND_ERROR "Uups. Shouldn't be possible to get here")
endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )






