project(Modelica_DeviceDrivers)
cmake_minimum_required(VERSION 2.6)
enable_testing()

#set(CMAKE_VERBOSE_MAKEFILE on)
set(CMAKE_BUILD_TYPE DEBUG)

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
endif (MSVC)

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


# Forget about everything under this line
# set preprocessor symbol to indicate that we use a special ModelicaUtilities.h for testing at c-code level
# add_definitions(-DUSE_TESTFIXTUREMODELICAUTILITIES_H)
# configure_file(${CMAKE_CURRENT_SOURCE_DIR}/Readme.txt ${CMAKE_CURRENT_BINARY_DIR}/foo.c
#                 COPYONLY)