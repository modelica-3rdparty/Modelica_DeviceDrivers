#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

# Some test applications

include_directories(../../Include)

add_executable(test_MDDJoystick test_MDDJoystick.c ../Util/ModelicaUtilities.c)
if (MSVC OR MINGW)
  target_link_libraries(test_MDDJoystick Winmm)
endif (MSVC OR MINGW)
add_test(test_MDDJoystick ${EXECUTABLE_OUTPUT_PATH}/test_MDDJoystick)

add_executable(test_MDDKeyboard test_MDDKeyboard.c ../Util/ModelicaUtilities.c)
if (MSVC OR MINGW)
  target_link_libraries(test_MDDKeyboard User32)
else (MSVC OR MINGW)
  target_link_libraries(test_MDDKeyboard x11)
endif (MSVC OR MINGW)
add_test(test_MDDKeyboard ${EXECUTABLE_OUTPUT_PATH}/test_MDDKeyboard)

# Only build test application in linux if library has been built successfully before
if (MSVC)
  add_executable(test_MDDSpaceMouse test_MDDSpaceMouse.c ../Util/ModelicaUtilities.c)
  target_link_libraries(test_MDDSpaceMouse MDDSpaceMouseStatic)
  add_test(test_MDDSpaceMouse ${EXECUTABLE_OUTPUT_PATH}/test_MDDSpaceMouse)
else (MSVC)
  if (srcXdrvlib)
    add_executable(test_MDDSpaceMouse test_MDDSpaceMouse.c ../Util/ModelicaUtilities.c)
    target_link_libraries(test_MDDSpaceMouse x11 MDDSpaceMouse)
    add_test(test_MDDSpaceMouse ${EXECUTABLE_OUTPUT_PATH}/test_MDDSpaceMouse)
  else (srcXdrvlib)
    message("xdrvlib.c not found. Skipping test generation for 3Dconnexion Space Mouse!")
  endif (srcXdrvlib)
endif (MSVC)




