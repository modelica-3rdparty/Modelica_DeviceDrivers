message(STATUS "WRITING BUILD FILES FOR DummyPthreadLibrary")
#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

set(libSrcsMDDDummyPthreadLibrary MDDDummyPthreadLibrary.c)

add_library(pthread SHARED ${libSrcsMDDDummyPthreadLibrary})

# install to directory (CMAKE_INSTALL_PREFIX) into subdirectory "lib"
if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  install(TARGETS pthread DESTINATION Library/win64)
elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
  install(TARGETS pthread DESTINATION Library/win32)
else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  message(SEND_ERROR "Uups. Shouldn't be possible to get here")
endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )






