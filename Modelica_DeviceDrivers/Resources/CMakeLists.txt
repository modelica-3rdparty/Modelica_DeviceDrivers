project(Modelica_DeviceDrivers C)
cmake_minimum_required(VERSION 3.12.0)
enable_testing()
# copy CTestCustom.cmake to build dir to disable interactive tests in 'make test'
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/CTestCustom.cmake ${CMAKE_CURRENT_BINARY_DIR})
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
#set(CMAKE_VERBOSE_MAKEFILE on)
#set(CMAKE_BUILD_TYPE DEBUG)

# Default settings (can be overwritten by the user in the GUI or command line, e.g., cmake -DBUILD_EXTERNAL_PROJECTS=true ..)
set(BUILD_EXTERNAL_PROJECTS FALSE CACHE BOOL "if TRUE, download source code of external projects and (re)build them")
# All library installation will be relative to the "Resources" directory
IF(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR} CACHE PATH "Library installation path (don't change)" FORCE)
ENDIF(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)


set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
#set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_EDIT_COMMAND cmake-gui)

include_directories(src/include)
include_directories(Include)

# Set subdirectory "INSTALL_LIB" to platform specific directories
# (install libraries to (${CMAKE_INSTALL_PREFIX}/${INSTALL_LIB}))
if (UNIX)
  if ( (CMAKE_SIZEOF_VOID_P EQUAL 8) AND (NOT M32_FLAG) )
		set(INSTALL_LIB  "Library/linux64")
  elseif ( (CMAKE_SIZEOF_VOID_P EQUAL 4) OR (M32_FLAG) )
		set(INSTALL_LIB  "Library/linux32")
  else ( (CMAKE_SIZEOF_VOID_P EQUAL 8) AND (NOT M32_FLAG) )
    message(SEND_ERROR "Uups. Shouldn't be possible to get here")
  endif ( (CMAKE_SIZEOF_VOID_P EQUAL 8) AND (NOT M32_FLAG) )
elseif (MSVC OR MINGW)
  if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
		set(INSTALL_LIB  "Library/win64")
  elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
		set(INSTALL_LIB  "Library/win32")
  else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    message(SEND_ERROR "Uups. Shouldn't be possible to get here")
  endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
else (UNIX)
  message(SEND_ERROR "Uups. Not UNIX (or CYGWIN), not MSVC or MINGW => No Support")
endif (UNIX)

if (UNIX)
  if ( ($ENV{CFLAGS} MATCHES "-m32") AND ($ENV{CXXFLAGS} MATCHES "-m32") )
    set(M32_FLAG TRUE)
  endif()
  # FIXME Actually, I would like to provide a cache variable flag to force a 32-bit build, like
  # set(M32_FLAG FALSE CACHE BOOL "if TRUE, and using gcc under linux (64-bit), force generation of 32-bit libraries")
  # Having that I can activate things like
  # if (M32_FLAG)
  #   set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
  #   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
  #   And below should do something like like LDFLAGS=-m32?
  #   SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -m32")
  #   SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -m32")
  #   SET(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -m32")
  #   SET(CMAKE_STATIC_LINKER_FLAGS "${CMAKE_STATIC_LINKER_FLAGS} -m32")
  # endif()
  # HOWEVER, this won't set CMAKE_SIZEOF_VOID_P to 4, so that 32-bit library paths are searched first!
endif (UNIX)

# Dummy libraries for uniform treatment of GCC and MS Visual C within Modelica
add_subdirectory(src/DummyLibraries)

if (MSVC)
  # Create a SimulationX specific DLL wrapper library
  add_subdirectory(src/ITI_ModelicaDeviceDrivers)
endif (MSVC)

# Third party projects
add_subdirectory(thirdParty)

# Windows and Linux library for 3Dconnexion space mouse support
# add_subdirectory(src/SpaceMouse)

# Library providing some utility functions
add_subdirectory(src/Util)


# Various little C test programs:
# Operating System module
add_subdirectory(test/OperatingSystem)
# Input Devices module
add_subdirectory(test/InputDevices)
# Communication module
add_subdirectory(test/Communication)
# Softing CAN module
add_subdirectory(test/SoftingCAN)
# Linux comedi daq interface
add_subdirectory(test/HardwareIO)
# Linux socket CAN interface
add_subdirectory(test/SocketCAN)
# Utility module
add_subdirectory(test/Util)


# Forget about everything under this line
# set preprocessor symbol to indicate that we use a special ModelicaUtilities.h for testing at c-code level
# add_definitions(-DUSE_TESTFIXTUREMODELICAUTILITIES_H)
# configure_file(${CMAKE_CURRENT_SOURCE_DIR}/Readme.txt ${CMAKE_CURRENT_BINARY_DIR}/foo.c
#                 COPYONLY)
