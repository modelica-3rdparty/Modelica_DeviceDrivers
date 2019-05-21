message(STATUS "WRITING BUILD FILES FOR test")



# Google Test
# https://cliutils.gitlab.io/modern-cmake/chapters/testing/googletest.html
# Use shared (DLL) run-time lib even when Google Test is built as static lib
set(gtest_force_shared_crt TRUE CACHE BOOL "Use shared (DLL) run-time lib even when Google Test is built as static lib")
set(INSTALL_GMOCK FALSE CACHE BOOL "")
set(INSTALL_GTEST FALSE CACHE BOOL "")
add_subdirectory("${PROJECT_SOURCE_DIR}/thirdParty/googletest" "thirdParty/googletest")
set_property(TARGET gtest PROPERTY FOLDER "googletest")
set_property(TARGET gtest_main PROPERTY FOLDER "googletest")
set_property(TARGET gmock PROPERTY FOLDER "googletest")
set_property(TARGET gmock_main PROPERTY FOLDER "googletest")

# Keep CACHE cleaner
mark_as_advanced(
    BUILD_GMOCK BUILD_GTEST BUILD_SHARED_LIBS
    INSTALL_GMOCK INSTALL_GTEST
    gmock_build_tests gtest_build_samples gtest_build_tests
    gtest_disable_pthreads gtest_force_shared_crt gtest_hide_internal_symbols
)

if (NOT (${CMAKE_VERSION} VERSION_LESS "3.10.0"))
    # https://cmake.org/cmake/help/latest/module/GoogleTest.html
    include(GoogleTest)
endif()

macro(package_add_test TESTNAME)
    add_executable(${TESTNAME} ${ARGN})
    target_link_libraries(${TESTNAME} gtest gmock gtest_main)
    if (NOT (${CMAKE_VERSION} VERSION_LESS "3.10.0"))
        gtest_discover_tests(${TESTNAME} PROPERTIES TIMEOUT 10)
    else()
        add_test(NAME ${TESTNAME} COMMAND ${TESTNAME})
    endif()
endmacro()


# Operating System module
add_subdirectory(OperatingSystem)
# Input Devices module
add_subdirectory(InputDevices)
# Communication module
add_subdirectory(Communication)
# Softing CAN module
add_subdirectory(SoftingCAN)
# Linux comedi daq interface
add_subdirectory(HardwareIO)
# Linux socket CAN interface
add_subdirectory(SocketCAN)
# Utility module
add_subdirectory(Util)
