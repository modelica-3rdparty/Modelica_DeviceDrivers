message(STATUS "WRITING BUILD FILES FOR DummyLibraries")
#message(STATUS "${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}")

# See README.md for the rationale of this file.
# The goal is to prevent linker errors by a workaround which creates dummy libraries
# for system libraries which are required for one platform, but are neither
# provided nor required for another platform.
# The libraries are installted to ${CMAKE_INSTALL_PREFIX}/${INSTALL_LIB}, where
# ${INSTALL_Lib} is a platform specific variable set in the top level CMakeLists.txt.

if (MSVC OR MINGW)
  # Dummy Windows crypto library for uniform treatment of GCC and MS Visual C within Modelica
	# For linux, the paho-mqtt3 functions need to link the libcrypto library (The OpenSSL Project).
  add_library(crypto SHARED MDDDummyLibrary.c)
	set_property(TARGET crypto PROPERTY FOLDER "DummyLibraries")
	install(TARGETS crypto DESTINATION ${INSTALL_LIB})
  # Dummy Windows ssl library for uniform treatment of GCC and MS Visual C within Modelica
	# For linux, the paho-mqtt3 functions need to link the libssl library (The OpenSSL Project).
	add_library(ssl SHARED MDDDummyLibrary.c)
	set_property(TARGET ssl PROPERTY FOLDER "DummyLibraries")
  install(TARGETS ssl DESTINATION ${INSTALL_LIB})
  # Dummy Windows rt library for uniform treatment of GCC and MS Visual C within Modelica
	# For linux, various functions need to link the librt library (POSIX.1b Realtime Extensions library).
	add_library(rt SHARED MDDDummyLibrary.c)
	set_property(TARGET rt PROPERTY FOLDER "DummyLibraries")
  install(TARGETS rt DESTINATION ${INSTALL_LIB})
  # Dummy Windows X11 library for uniform treatment of GCC and MS Visual C within Modelica
	# For linux, various functions need to link against the X11 library
	add_library(X11 SHARED MDDDummyLibrary.c)
	set_property(TARGET X11 PROPERTY FOLDER "DummyLibraries")
  install(TARGETS X11 DESTINATION ${INSTALL_LIB})
  # Dummy Windows pthread library for uniform treatment of GCC and MS Visual C within Modelica
	# For linux, various functions need to link against the pthread library.
	add_library(pthread SHARED MDDDummyLibrary.c)
	set_property(TARGET pthread PROPERTY FOLDER "DummyLibraries")
	install(TARGETS pthread DESTINATION ${INSTALL_LIB})
  # Dummy Windows uuid library for uniform treatment of GCC and MS Visual C within Modelica
	# For linux, the functions uuid_generate_random and uuid_unparse need to link the libuuid library.
	add_library(uuid SHARED MDDDummyLibrary.c)
	set_property(TARGET uuid PROPERTY FOLDER "DummyLibraries")
	install(TARGETS uuid DESTINATION ${INSTALL_LIB})
endif (MSVC OR MINGW)

if (UNIX)
  if (CYGWIN)
    # Dummy Windows X11 library
		add_library(X11 SHARED MDDDummyLibrary.c)
		set_property(TARGET X11 PROPERTY FOLDER "DummyLibraries")
		install(TARGETS X11 DESTINATION ${INSTALL_LIB})
  else (CYGWIN)
    # Dummy Linux Winmm library for uniform treatment of GCC and MS Visual C within Modelica
		# For windows, various functions need to link the Winmm.lib library.
		add_library(Winmm STATIC MDDDummyLibrary.c)
		set_property(TARGET Winmm PROPERTY FOLDER "DummyLibraries")
		install(TARGETS Winmm DESTINATION ${INSTALL_LIB})
    # Dummy Linux IPHlpApi library for uniform treatment of GCC and MS Visual C within Modelica
		# For windows, various functions need to link the IPHlpApi.lib library.
		add_library(IPHlpApi STATIC MDDDummyLibrary.c)
		set_property(TARGET IPHlpApi PROPERTY FOLDER "DummyLibraries")
    install(TARGETS IPHlpApi DESTINATION ${INSTALL_LIB})
  endif (CYGWIN)
  # Dummy Linux User32 library for uniform treatment of GCC and MS Visual C within Modelica
	# For windows, various functions need to link the User32.lib library.
	add_library(User32 STATIC MDDDummyLibrary.c)
	set_property(TARGET User32 PROPERTY FOLDER "DummyLibraries")
	install(TARGETS User32 DESTINATION ${INSTALL_LIB})
  # Dummy Linux Ws2_32 library for uniform treatment of GCC and MS Visual C within Modelica
	# For windows, various functions need to link the Ws2_32.lib library.
	add_library(Ws2_32 STATIC MDDDummyLibrary.c)
	set_property(TARGET Ws2_32 PROPERTY FOLDER "DummyLibraries")
	install(TARGETS Ws2_32 DESTINATION ${INSTALL_LIB})
  # Dummy Linux Rpcrt4 library for uniform treatment of GCC and MS Visual C within Modelica
	# For windows, various functions need to link the Rpcrt4.lib library.
	add_library(Rpcrt4 STATIC MDDDummyLibrary.c)
	set_property(TARGET Rpcrt4 PROPERTY FOLDER "DummyLibraries")
	install(TARGETS Rpcrt4 DESTINATION ${INSTALL_LIB})
endif (UNIX)
