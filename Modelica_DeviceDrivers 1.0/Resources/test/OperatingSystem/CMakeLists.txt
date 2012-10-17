#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

# Some test applications

include_directories(../../Include)

add_executable(test_MDDBeep test_MDDBeep.c ../Util/ModelicaUtilities.c)
if (NOT MSVC)
  target_link_libraries(test_MDDBeep X11)
endif (NOT MSVC)
add_test(test_MDDBeep ${EXECUTABLE_OUTPUT_PATH}/test_MDDBeep)

add_executable(test_MDD_getTimeMS test_MDD_getTimeMS.c ../Util/ModelicaUtilities.c)
if (NOT MSVC)
  target_link_libraries(test_MDD_getTimeMS m rt)
endif (NOT MSVC)
add_test(test_MDD_getTimeMS ${EXECUTABLE_OUTPUT_PATH}/test_MDD_getTimeMS)

add_executable(test_MDDRealtimeSynchronize_idle test_MDDRealtimeSynchronize_idle.c ../Util/ModelicaUtilities.c)
if (NOT MSVC)
  target_link_libraries(test_MDDRealtimeSynchronize_idle m rt)
endif (NOT MSVC)
add_test(test_MDDRealtimeSynchronize_idle ${EXECUTABLE_OUTPUT_PATH}/test_MDDRealtimeSynchronize_idle)

add_executable(test_MDDRealtimeSynchronize_low test_MDDRealtimeSynchronize_low.c ../Util/ModelicaUtilities.c)
if (NOT MSVC)
  target_link_libraries(test_MDDRealtimeSynchronize_low m rt)
endif (NOT MSVC)
add_test(test_MDDRealtimeSynchronize_low ${EXECUTABLE_OUTPUT_PATH}/test_MDDRealtimeSynchronize_low)

add_executable(test_MDDRealtimeSynchronize_normal test_MDDRealtimeSynchronize_normal.c ../Util/ModelicaUtilities.c)
if (NOT MSVC)
  target_link_libraries(test_MDDRealtimeSynchronize_normal m rt)
endif (NOT MSVC)
add_test(test_MDDRealtimeSynchronize_normal ${EXECUTABLE_OUTPUT_PATH}/test_MDDRealtimeSynchronize_normal)

add_executable(test_MDDRealtimeSynchronize_high test_MDDRealtimeSynchronize_high.c ../Util/ModelicaUtilities.c)
if (NOT MSVC)
  target_link_libraries(test_MDDRealtimeSynchronize_high m rt)
endif (NOT MSVC)
add_test(test_MDDRealtimeSynchronize_high ${EXECUTABLE_OUTPUT_PATH}/test_MDDRealtimeSynchronize_high)

add_executable(test_MDDRealtimeSynchronize_realtime test_MDDRealtimeSynchronize_realtime.c ../Util/ModelicaUtilities.c)
if (NOT MSVC)
  target_link_libraries(test_MDDRealtimeSynchronize_realtime m rt)
endif (NOT MSVC)
add_test(test_MDDRealtimeSynchronize_realtime ${EXECUTABLE_OUTPUT_PATH}/test_MDDRealtimeSynchronize_realtime)










