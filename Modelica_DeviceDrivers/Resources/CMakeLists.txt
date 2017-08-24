project(Modelica_DeviceDrivers)
cmake_minimum_required(VERSION 2.8.12)
enable_testing()
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

if (MSVC OR MINGW)
  # Dummy Windows rt library for uniform treatment of GCC and MS Visual C within Modelica
  add_subdirectory(src/DummyRTLibrary)
  # Dummy Windows X11 library for uniform treatment of GCC and MS Visual C within Modelica
  add_subdirectory(src/DummyX11Library)
  # Dummy Windows pthread library for uniform treatment of GCC and MS Visual C within Modelica
  add_subdirectory(src/DummyPthreadLibrary)
endif (MSVC OR MINGW)

if (MSVC)
  # Create a SimulationX specific DLL wrapper library
  add_subdirectory(src/ITI_ModelicaDeviceDrivers)
endif (MSVC)

if (UNIX)
  if (M32_FLAG)

  endif()
  # Dummy Linux Winmm library for uniform treatment of GCC and MS Visual C within Modelica
  add_subdirectory(src/DummyWinmmLibrary)
  # Dummy Linux User32 library for uniform treatment of GCC and MS Visual C within Modelica
  add_subdirectory(src/DummyUser32Library)
  # Dummy Linux Ws2_32 library for uniform treatment of GCC and MS Visual C within Modelica
  add_subdirectory(src/DummyWs2_32Library)
  # Are we trying to force compilation for linux32 on a native linux64 platform?
  # (Dymola builds/built 32-bit simulation executables also on 64-bit Linux)
  # Note, that flags can be overwritten by calling CMake (from Resources/build) like this:
  # CFLAGS=-m32 CXXFLAGS=-m32 cmake ..
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
