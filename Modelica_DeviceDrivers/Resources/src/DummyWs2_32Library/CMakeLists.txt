message(STATUS "WRITING BUILD FILES FOR DummyWs2_32Library")
#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

set(libSrcsMDDDummyWs2_32Library MDDDummyWs2_32Library.c)

add_library(Ws2_32 SHARED ${libSrcsMDDDummyWs2_32Library})

# install to directory (CMAKE_INSTALL_PREFIX) into subdirectory "lib"
if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  install(TARGETS rt DESTINATION Library/linux64)
elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
  install(TARGETS rt DESTINATION Library/linux32)
else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  message(SEND_ERROR "Uups. Shouldn't be possible to get here")
endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )






