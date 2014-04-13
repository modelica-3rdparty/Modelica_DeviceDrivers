message(STATUS "WRITING BUILD FILES FOR DummyRTLibrary")
#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

set(libSrcsMDDDummyRTLibrary MDDDummyRTLibrary.c)

add_library(rt SHARED ${libSrcsMDDDummyRTLibrary})

# 2014-04-11: Logic to create a static library of the same name.
# Seems not be needed. Even if simulation executable is compiled with DLL dependency,
# this dependency is not required when executing the simulation executable
# (i.e., possible to copy around simulation executable _without_ the DLL)
# However, currently can't exclude that having a static lib is better in some cases
# => Only commented the logic below instead of deleting it for the moment ...
# add_library(rtStatic STATIC ${libSrcsMDDDummyRTLibrary})
# set_target_properties(rtStatic PROPERTIES OUTPUT_NAME rt)

# install to directory (CMAKE_INSTALL_PREFIX) into subdirectory "lib"
if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  install(TARGETS rt DESTINATION Library/win64)
  #install(TARGETS rtStatic DESTINATION Library/win64)
elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
  install(TARGETS rt DESTINATION Library/win32)
  #install(TARGETS rtStatic DESTINATION Library/win32)
else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  message(SEND_ERROR "Uups. Shouldn't be possible to get here")
endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )






