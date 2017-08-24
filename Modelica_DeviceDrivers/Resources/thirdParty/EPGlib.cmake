message(STATUS "WRITING BUILD FILES FOR External Project glib")
#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

if (UNIX)

  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    ExternalProject_Add(EPglib
      # Setting the prefix will automatically set other dirs like SOURCE_DIR/INSTALL_DIR (see http://www.kitware.com/media/html/BuildingExternalProjectsWithCMake2.8.html)
      PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/glib
      BINARY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/glib/src/bin64
      # BUILD_IN_SOURCE 1 # Project supports out of source builds, so we use BINARY_DIR for that
      # GIT_REPOSITORY https://github.com/GNOME/glib.git
      # GIT_TAG 2.40.2 # This was not completely working for me and it pulls the complete repo of 108M
      # Alternatively, one could just "copy" the source directly into the MDD repo (https://developer.atlassian.com/blog/2015/05/the-power-of-git-subtree/) with
      # git subtree add --prefix Modelica_DeviceDrivers/Resources/thirdParty/glib https://github.com/GNOME/glib tags/2.40.2 --squash
      URL https://github.com/GNOME/glib/archive/2.40.2.tar.gz
      CONFIGURE_COMMAND <SOURCE_DIR>/autogen.sh && <SOURCE_DIR>/configure --prefix=${CMAKE_CURRENT_SOURCE_DIR}/glib --enable-static --enable-debug=no
      BUILD_COMMAND make
    )
    ExternalProject_Get_Property(EPglib install_dir)
    set(dirGlibLib ${install_dir}/lib)

  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
    # Force compilation to 32 bit binaries on 64 bit architectures with "..=-m32"
    ExternalProject_Add(EPglib
      PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/glib
      BINARY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/glib/src/bin32
      URL https://github.com/GNOME/glib/archive/2.40.2.tar.gz
      CONFIGURE_COMMAND <SOURCE_DIR>/autogen.sh && <SOURCE_DIR>/configure --prefix=${CMAKE_CURRENT_SOURCE_DIR}/glib --enable-debug=no --enable-static --build=i686-pc-linux-gnu "CFLAGS=-O2 -fPIC -m32" "CXXFLAGS=-O2 -fPIC -m32" "LDFLAGS=-m32"
      BUILD_COMMAND make
    )
    ExternalProject_Get_Property(EPglib install_dir)
    set(dirGlibLib ${install_dir}/lib)

  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    message(SEND_ERROR "Uups. Shouldn't be possible to get here")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )

  # Find (static) library. Doesn't work to declare dependency from find_library to EPglib, so using set(..) instead
  # http://cmake.3232098.n2.nabble.com/using-find-library-with-a-ExternalProject-td7582093.html
  # https://cmake.org/pipermail/cmake/2013-October/056105.html
  #find_library(fGlibGlib20 NAMES libglib-2.0.a glib-2.0 PATHS  ${dirGlibLib} NO_DEFAULT_PATH)
  set(fGlibGlib20 ${dirGlibLib}/libglib-2.0.a)
  # Import libraries so that they become regular TARGETS
  # https://cmake.org/Wiki/CMake/Tutorials/Exporting_and_Importing_Targets
  add_library(libGlibGlib20 STATIC IMPORTED GLOBAL)
  set_property(TARGET libGlibGlib20 PROPERTY IMPORTED_LOCATION ${fGlibGlib20} )
  add_dependencies(libGlibGlib20 EPglib)

  # Installation
  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    install(FILES ${fGlibGlib20} DESTINATION Library/linux64)
  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
    install(FILES ${fGlibGlib20} DESTINATION Library/linux32)
  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    message(SEND_ERROR "Uups. Shouldn't be possible to get here")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )

elseif (MSVC)
	ExternalProject_Add(EPglib
		PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/glib
		BINARY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/glib/src/bin64
		URL https://github.com/winlibs/glib/archive/glib-2.45.4.zip
		CONFIGURE_COMMAND msg * "Please go to folder ${CMAKE_CURRENT_SOURCE_DIR}/glib/src/EPglib/build/win32 and build glib manually using the Visual Studio sln file of your choice"
		BUILD_COMMAND start ${CMAKE_CURRENT_SOURCE_DIR}/glib/src/EPglib/build/win32
		INSTALL_COMMAND msg * "After building glib copy glib-2.0.dll and glib-2.0.lib into Resources/Library/win32 (32-bit build) or Resources/Library/win64 (64-bit build)"
	)
    if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
      message(STATUS "SETTING lcm library to ${PROJECT_SOURCE_DIR}/Library/win64/lcm.dll")
      set(fLcm ${PROJECT_SOURCE_DIR}/Library/win64/lcm.dll)
      set(fLcmIMP ${PROJECT_SOURCE_DIR}/Library/win64/lcm.lib)
      message(STATUS "SETTING glib library to ${PROJECT_SOURCE_DIR}/Library/win64/glib-2.0.dll")
      set(fGlibGlib20 ${PROJECT_SOURCE_DIR}/Library/win64/glib-2.0.dll)
      set(fGlibGlib20IMP ${PROJECT_SOURCE_DIR}/Library/win64/glib-2.0.lib)
    elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
      message(STATUS "SETTING lcm library to ${PROJECT_SOURCE_DIR}/Library/win32/lcm.dll")
      set(fLcm ${PROJECT_SOURCE_DIR}/Library/win32/lcm.dll)
      set(fLcmIMP ${PROJECT_SOURCE_DIR}/Library/win32/lcm.lib)
      message(STATUS "SETTING glib library to ${PROJECT_SOURCE_DIR}/Library/win32/glib-2.0.dll")
      set(fGlibGlib20 ${PROJECT_SOURCE_DIR}/Library/win32/glib-2.0.dll)
      set(fGlibGlib20IMP ${PROJECT_SOURCE_DIR}/Library/win32/glib-2.0.lib)
    else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
      message(SEND_ERROR "Uups. Shouldn't be possible to get here")
    endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    add_library(libLcm SHARED IMPORTED GLOBAL)
    set_property(TARGET libLcm PROPERTY IMPORTED_LOCATION ${fLcm})
    set_property(TARGET libLcm PROPERTY IMPORTED_IMPLIB ${fLcmIMP})

    add_library(libGlibGlib20 SHARED IMPORTED GLOBAL)
    set_property(TARGET libGlibGlib20 PROPERTY IMPORTED_LOCATION ${fGlibGlib20})
    set_property(TARGET libGlibGlib20 PROPERTY IMPORTED_IMPLIB ${fGlibGlib20IMP})
else (UNIX)
    message("Skipping managing ThirdParty projects from cmake (currently Linux only)")
endif (UNIX)
