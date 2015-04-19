message(STATUS "WRITING BUILD FILES FOR DummyUser32Library")
#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

set(libSrcsMDDDummyUser32Library MDDDummyUser32Library.c)

add_library(User32 STATIC ${libSrcsMDDDummyUser32Library})

# install to directory (CMAKE_INSTALL_PREFIX) into subdirectory "lib"
if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  install(TARGETS User32 DESTINATION Library/linux64)
elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
  install(TARGETS User32 DESTINATION Library/linux32)
else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  message(SEND_ERROR "Uups. Shouldn't be possible to get here")
endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
