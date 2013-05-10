#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

# Some test applications

include_directories(../../Include)

add_executable(test_MDDMapIntInt test_MDDMapIntInt.c ../Util/ModelicaUtilities.c)
target_link_libraries(test_MDDMapIntInt MDDUtil)
add_test(test_MDDMapIntInt ${EXECUTABLE_OUTPUT_PATH}/test_MDDMapIntInt)

add_executable(test_MDDMapIntpVoid test_MDDMapIntpVoid.c ../Util/ModelicaUtilities.c)
target_link_libraries(test_MDDMapIntpVoid MDDUtil)
add_test(test_MDDMapIntpVoid ${EXECUTABLE_OUTPUT_PATH}/test_MDDMapIntpVoid)

