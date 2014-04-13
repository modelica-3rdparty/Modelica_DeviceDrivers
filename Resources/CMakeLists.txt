project(Modelica_DeviceDrivers)
cmake_minimum_required(VERSION 2.6)
enable_testing()

#set(CMAKE_VERBOSE_MAKEFILE on)
#set(CMAKE_BUILD_TYPE DEBUG)

# All library installation will be relative to the "Resources" directory
set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR})

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
#set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_EDIT_COMMAND cmake-gui)

include_directories(src/include)

if (MSVC)
  # Dummy Windows rt library for uniform treatment of GCC and MS Visual C within Modelica
  add_subdirectory(src/DummyRTLibrary)
  # Dummy Windows X11 library for uniform treatment of GCC and MS Visual C within Modelica
  add_subdirectory(src/DummyX11Library)
  # Create a SimulationX specific DLL wrapper library
  add_subdirectory(src/ITI_ModelicaDeviceDrivers)
endif (MSVC)

if (UNIX)
  # Are we trying to force compilation for linux32 on a native linux64 platform?
  if ( ($ENV{CFLAGS} MATCHES "-m32") AND ($ENV{CXXFLAGS} MATCHES "-m32") )
    set(M32_FLAG TRUE)
  endif()
  # Uncomment to force 32 bit compilation on Linux (this is needed if a Modelica tool
  # uses 32 bit simulation executable also on 64 bit linux (as is/was the case for Dymola)
  # Alternatively, that can be achieved by calling cmake (from Resources/build) like this:
  # CFLAGS=-m32 CXXFLAGS=-m32 cmake ..
  #set(M32_FLAG True)
  #set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32") # force compile for 32 bit
  #set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32") # force compile for 32 bit
endif (UNIX)

# Windows and linux library for 3Dconnexion space mouse support
add_subdirectory(src/SpaceMouse)

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
