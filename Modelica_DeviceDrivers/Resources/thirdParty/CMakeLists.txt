message(STATUS "WRITING BUILD FILES FOR ThirdParty projects")
#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

# https://cmake.org/cmake/help/v2.8.8/cmake.html#module%3AExternalProject
# http://www.kitware.com/media/html/BuildingExternalProjectsWithCMake2.8.html
include(ExternalProject)

if (BUILD_EXTERNAL_PROJECTS)
  # Include cmake files that manage the external projects
  include("EPGlib.cmake")
  include("EPlcm.cmake")
else (BUILD_EXTERNAL_PROJECTS)
  message(STATUS "Variable BUILD_EXTERNAL_PROJECTS=${BUILD_EXTERNAL_PROJECTS} - Skipping build of external projects")
  if (UNIX)
    if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
      set(fLcm ${${PROJECT_SOURCE_DIR}}/Library/linux64/liblcm.a)
    elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
      set(fLcm ${${PROJECT_SOURCE_DIR}}/Library/linux32/liblcm.a)
    else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
      message(SEND_ERROR "Uups. Shouldn't be possible to get here")
    endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    add_library(libLcm STATIC IMPORTED GLOBAL)
    set_property(TARGET libLcm PROPERTY IMPORTED_LOCATION ${fLcm} )

  elseif (MSVC)
    if ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
      set(fLcm ${${PROJECT_SOURCE_DIR}}/Library/win64/lcm.dll)
      set(fLcmIMP ${${PROJECT_SOURCE_DIR}}/Library/win64/lcm.lib)
    elseif ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
      set(fLcm ${${PROJECT_SOURCE_DIR}}/Library/win32/lcm.dll)
      set(fLcmIMP ${${PROJECT_SOURCE_DIR}}/Library/win32/lcm.lib)
    else ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
      message(SEND_ERROR "Uups. Shouldn't be possible to get here")
    endif ( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    add_library(libLcm SHARED IMPORTED GLOBAL)
    set_property(TARGET libLcm PROPERTY IMPORTED_LOCATION ${fLcm})
    set_property(TARGET libLcm PROPERTY IMPORTED_IMPLIB ${fLcmIMP})

  else (UNIX)
    message(SEND_ERROR "Uups. Not UNIX, not MSVC")
  endif (UNIX)


endif (BUILD_EXTERNAL_PROJECTS)
