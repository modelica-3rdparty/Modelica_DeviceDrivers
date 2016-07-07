message(STATUS "WRITING BUILD FILES FOR External Project lcm")
#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

if (UNIX)

  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    ExternalProject_Add(EPlcm
      PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/lcm
      BINARY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/lcm/src/bin64
      URL https://github.com/lcm-proj/lcm/releases/download/v1.3.1/lcm-1.3.1.zip
      CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_CURRENT_SOURCE_DIR}/lcm --without-python --without-java --enable-static "PKG_CONFIG_PATH=${dirGlibLib}/pkgconfig"
      BUILD_COMMAND make
    )
    add_dependencies(EPlcm EPglib)
    ExternalProject_Get_Property(EPlcm install_dir)
    set(dirLcmLib ${install_dir}/lib)

  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
    ExternalProject_Add(EPlcm
      PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/lcm
      BINARY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/lcm/src/bin32
      URL https://github.com/lcm-proj/lcm/releases/download/v1.3.1/lcm-1.3.1.zip
      CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_CURRENT_SOURCE_DIR}/lcm --without-python --without-java --enable-static --build=i686-pc-linux-gnu "CFLAGS=-g -O2 -m32" "CXXFLAGS=-g -O2 -m32" "LDFLAGS=-m32" "PKG_CONFIG_PATH=${dirGlibLib}/pkgconfig"
      BUILD_COMMAND make
    )
    add_dependencies(EPlcm EPglib)
    ExternalProject_Get_Property(EPlcm install_dir)
    set(dirLcmLib ${install_dir}/lib)

  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    message(SEND_ERROR "Uups. Shouldn't be possible to get here")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )

  set(fLcm ${dirLcmLib}/liblcm.a)
  add_library(libLcm STATIC IMPORTED GLOBAL)
  set_property(TARGET libLcm PROPERTY IMPORTED_LOCATION ${fLcm} )
  add_dependencies(libLcm EPlcm)

  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    install(FILES ${fLcm} DESTINATION Library/linux64)
  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
    install(FILES ${fLcm} DESTINATION Library/linux32)
  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    message(SEND_ERROR "Uups. Shouldn't be possible to get here")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )

else (UNIX)
    message("Skipping managing ThirdParty projects from cmake (currently Linux only)")
endif (UNIX)
