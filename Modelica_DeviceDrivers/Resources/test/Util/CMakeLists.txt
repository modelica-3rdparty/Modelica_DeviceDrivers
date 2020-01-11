# message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

# Some test applications

include_directories(../../Include)

add_executable(test_MDDMapIntInt test_MDDMapIntInt.c ../Util/ModelicaUtilities.c)
set_property(TARGET test_MDDMapIntInt PROPERTY FOLDER "test/Util")
add_test(test_MDDMapIntInt ${EXECUTABLE_OUTPUT_PATH}/test_MDDMapIntInt)

add_executable(test_MDDMapIntpVoid test_MDDMapIntpVoid.c ../Util/ModelicaUtilities.c)
set_property(TARGET test_MDDMapIntpVoid PROPERTY FOLDER "test/Util")
add_test(test_MDDMapIntpVoid ${EXECUTABLE_OUTPUT_PATH}/test_MDDMapIntpVoid)

add_executable(test_MDDUtilities test_MDDUtilities.c ../Util/ModelicaUtilities.c)
set_property(TARGET test_MDDUtilities PROPERTY FOLDER "test/Util")
if (UNIX)
  target_link_libraries(test_MDDUtilities uuid)
elseif (CYGWIN)
  target_link_libraries(test_MDDUtilities uuid IPHlpApi)
elseif (MSVC OR MINGW)
  target_link_libraries(test_MDDUtilities Rpcrt4 Ws2_32 IPHlpApi)
endif (UNIX)
add_test(test_MDDUtilities ${EXECUTABLE_OUTPUT_PATH}/test_MDDUtilities)
file(COPY parameterInitValues.txt DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
