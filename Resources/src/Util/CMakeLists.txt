message(STATUS "WRITING BUILD FILES FOR Util library")
#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")



set(libSrcsMDDUtilLibrary MDDMapIntInt.cpp MDDMapIntpVoid)
add_library(MDDUtil STATIC ${libSrcsMDDUtilLibrary})


if (UNIX)
  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
	install(TARGETS MDDUtil DESTINATION Library/linux64)
  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
	install(TARGETS MDDUtil DESTINATION Library/linux32)
  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    message(SEND_ERROR "Uups. Shouldn't be possible to get here")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 ) 
elseif (MSVC)
  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
	install(TARGETS MDDUtil DESTINATION Library/win64)
  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
	install(TARGETS MDDUtil DESTINATION Library/win32)
  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    message(SEND_ERROR "Uups. Shouldn't be possible to get here")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )  
else (UNIX)
  message(SEND_ERROR "Uups. Not UNIX, not MSVC => No Support")
endif (UNIX)