# Modelica_DeviceDrivers
Free library for interfacing hardware drivers to Modelica models.
There is support for joysticks, keyboards, UDP, TCP/IP, LCM, MQTT, shared memory, AD/DA converters, serial port and other devices.

## Library description
The `Modelica_DeviceDrivers` (MDD) library is an open source Modelica package that interfaces hardware drivers to Modelica models. An overview of the library is provided in

> Bernhard Thiele, Thomas Beutlich, Volker Waurich, Martin Sjölund, and Tobias Bellmann, Towards a Standard-Conform, Platform-Generic and Feature-Rich Modelica Device Drivers Library. In Jiří Kofránek and Francesco Casella, editors, _12th Int. Modelica Conference_, Prague, Czech Republic, May 2017. [Download](https://www.modelica.org/events/modelica2017/proceedings/html/submissions/ecp17132713_ThieleBeutlichWaurichSjolundBellmann.pdf)

The library unifies previous developments concerning device driver support in Modelica, see [Interactive Simulations and advanced Visualization with Modelica](https://modelica.org/events/modelica2009/Proceedings/memorystick/pages/papers/0056/0056.pdf) and [Modelica for Embedded Systems](https://modelica.org/events/modelica2009/Proceedings/memorystick/pages/papers/0096/0096.pdf) (Modelica'2009 conference). The functionality covered by this library has been used internally at DLR for several years, such as for Driver-in-the-Loop simulation and for the [DLR Robot Motion Simulator](http://www.dlr.de/media/en/desktopdefault.aspx/tabid-4995/8426_read-17606/).
The previously fragmented functionality was streamlined, improved, and extended to a coherent cross-platform library.

Main features:
  * Cross-platform (Windows and Linux).
  * (Soft) real-time synchronization of a simulation.
  * Support for keyboard, joystick/gamepad, and 3Dconnexion Spacemouse.
  * Support for a universal packaging concept to pack Modelica variables in a graphical and convenient way into a bit vector and transport such a bit vector via UDP, TCP/IP, LCM, MQTT, serial I/O or shared memory (CAN support is prototypical available).
  * Support of the Linux control and measurement device interface for digital and analog I/O (Comedi interface).

All device drivers are made available via external Modelica functions. Furthermore, high level interfaces on these functions are provided via Modelica blocks. The first interface uses Modelica 3.2 functionality only (when-clauses and sample-operator).
The second interface uses the synchronous language elements introduced in Modelica 3.3 and is based on clocks (works together with the `Modelica_Synchronous` library).

![BlockOverview](screenshot.png)

### Self-certification
 - [X] Internationalized
 - [ ] Unit tests
 - [X] End-user documentation
 - [X] Internal documentation (documentation, interfaces, etc.)
 - [X] Existed and maintained for at least 6 months

## Build status
[![Build Status](https://travis-ci.org/modelica/Modelica_DeviceDrivers.svg)](https://travis-ci.org/modelica/Modelica_DeviceDrivers)

## Current release

Download [Modelica_DeviceDrivers latest release](../../releases/latest)

Please note that the library is known to work with
* Dymola,
* SimulationX (with `userBufferSize` all non-clocked communication blocks are working in SimulationX, but `autoBufferSize` only works for external solvers CVode and Fixed Step solver and fails for BDF and MEBDF solvers, see [#54 (comment)](https://github.com/modelica/Modelica_DeviceDrivers/issues/54#issuecomment-76032325)),
* OpenModelica (partial support starting with OpenModelica v1.11.0 Beta 1, e.g., UDP, serial port, shared memory, LCM, keyboard).

If you tested the library successfully with another Modelica tool, please contact [Bernhard Thiele](https://github.com/bernhard-thiele) or send a [pull request](https://github.com/modelica/Modelica_DeviceDrivers/pulls) that updates this README.md.

#### Release notes
Bug fix releases usually won't have release notes, so please use the download link from above to get the latest release including bug fixes.

*  Upcoming release v1.7.0 (2019-03-28)
   * Uses latest version of Modelica Standard Library (v3.2.3).
   * Option for using blocking UDP receive calls (#275). On the function interface level an optional third argument in the `UDPSocket` constructor allows to create the external object without starting a dedicated receive thread (default: `useRecvThread=true`). On the block interface level (block `UDPReceive`) a new parameter `useRecvThread` (default: `useRecvThread=true`) allows to select the desired behavior. See example `Blocks.Examples.TestSerialPackager_UDPWithoutReceiveThread`.
   * Added parameter `enable` (default: `enable=true`) for conditionally enabling or disabling the real-time synchronization within the `Blocks.OperatingSystem.SynchronizeRealtime` block (#270).
   * Update OpenSSL to 1.0.2r (#280).
   * Bug fixes:
     * `EmbeddedTargets.AVR`: Only start the RT synch timer once (#274).
     * `EmbeddedTargets.AVR`: Fixed reading of digital pins (#266).
     * Fixed Cygwin build (#271).
     * Fixed scale factor calculation error in `JoystickInput` block (#272).
     * Fix missing byte copy of `\0` in external C code function `MDDEXT_SerialPackagerGetString()` (#273).
   * Other (minor) fixes and improvements.
*  [Version v1.6.0 (2018-10-06)](../../releases/tag/v1.6.0)
   * Support for MQTT (Message Queuing Telemetry Transport protocol) client communication (see #130, #256).
   * Utility function to retrieve MAC address (`Utilities.Functions.getMACAddress`, see #255).
   * Utility function to generate a UUID (`Utilities.Functions.generateUUID()`, see #244).
   * Number of received bytes in `UDPReceive` block is provided as output (see #236).
   * Scalable real-time synchronization (see #215).
   * Adaption of the new Modelica Association license for libraries:
     [The 3-Clause BSD License](https://modelica.org/licenses/modelica-3-clause-bsd) (see #238, #264).
     The C-code parts of the library were already BSD 3-Clause licensed, but the Modelica code was licensed
     under the Modelica License 2. Since Modelica Association projects, most notably the Modelica Standard Library (MSL),
     changed from Modelica License 2 to the BSD 3-Clause license, the Modelica_DeviceDrivers library follows this development.
   * Other (minor) fixes and improvements.
*  [Version v1.5.1 (2017-09-19)](../../releases/tag/v1.5.1)
    * Bug fix for variable name spelling error in `Blocks.InputDevices.JoystickInput` (#224)
*  [Version v1.5.0 (2017-05-12)](../../releases/tag/v1.5.0)
    * **Important**: A bug fix in the shared memory implementation for *Windows* potentially affects applications that adapted the (wrong) buffer layout (see #138)!
    * Presentation of the library at the [Modelica'2017 conference](https://www.modelica.org/events/modelica2017).
    * OpenModelica (v1.11.0 Beta 1 and later) is now the third tool known to (partially) support the library (e.g., UDP, TCP/IP, serial port, shared memory, and LCM communication).
    * Added support for sending and receiving of Lightweight Communications and Marshalling [LCM](https://lcm-proj.github.io) datagrams (only the communication aspect of LCM is considered).
    * Added support for TCP/IP communication for Linux (was already available for Windows).
    * New top-level package `EmbeddedTargets` with a first prototypical support for the Atmel AVR family of microcontrollers (ATmega16 and ATmega328P (=Arduino Uno) are supported; currently only known to work with OpenModelica's ExperimentalEmbeddedC code generation, see documentation).
    * Bug fixes for the serial port support (#117, #118, #119, #127, #128).
    * Bug fix for the byte order swapping logic (endianness, #203).
    * Other (minor) fixes and improvements.
*  [Version v1.4.4 (2016-04-12)](../../releases/tag/v1.4.4)
    * Bug fix release, no new features, but many improvements since version v1.4.0 (more than 70 commits since v1.4.0), so let's list some of the improvements...
    * Uses latest version of Modelica Standard Library (v3.2.2).
    * Changed the license of the external C code and header files to [Simplified BSD License](Modelica_DeviceDrivers/Resources/License.txt) (the Modelica package parts remain under [Modelica License 2](https://modelica.org/licenses/ModelicaLicense2)).
    * Improved Modelica compatibility: Fixed the use of conditionally enabled variable `procPrio` outside of connect in `Blocks.OperatingSystem.SynchronizeRealtime` and `ClockedBlocks.OperatingSystem.SynchronizeRealtime`.
    * Improved Modelica compatibility: Fixed the invalid integer to enumeration type conversion in `HardwareIO`.
    * Fully specified the initial conditions for example models.
    * Simplified the linking with system libraries (MSVC only).
    * Added continuous integration for the external C code (thanks to [Travis CI](https://travis-ci.org/modelica/Modelica_DeviceDrivers)).
    * Improved and updated documentation.
    * Improved compatibility with the DLR Visualization Library.
    * Improved support of automatic Code-Export from SimulationX 3.7.
    * Fixes for the clocked communication blocks (added missing `byteOrder` support).
    * Other (minor) fixes.
*  [Version v1.4.0 (2015-09-01)](../../releases/tag/v1.4.0)
    * Switched to [semantic versioning](http://semver.org).
    * Migrated to new release process motivated by [impact-on-library-developers](https://github.com/xogeny/impact/blob/master/resources/docs/modelica2015/paper/impact.md#impact-on-librarydevelopers).
    * Added support for external trigger signals to trigger communication blocks.
    * Added support to configure byte ordering in communication blocks.
    * Added support for TCP/IP communication for Windows.
    * Added serial port support for Windows (was already available for Linux).
    * Added compiler support for MinGW and Cygwin.
    * Added support for all 32 joystick buttons.
    * Fixed Modelica compatibility of output buffers in communication blocks.
    * Fixed multi-threaded access of UDP and shared memory communication for Windows.
    * Fixed many small issues, particularly for improved compatibility with SimulationX.
*  [Version v1.3 (2014-05-19)](../../archive/v1.3+build.2.zip)
    * Fixed many issues in order to support SimulationX (with the indispensable help of [Thomas Beutlich](https://github.com/beutlich)).
    * Particularly, a SimulationX compatible wrapper DLL to give access to the external C functions was added.
    * Added serial port support for Linux.
*  [Version v1.2 (2013-10-01)](../../archive/v1.2+build.1.zip)
    * Adapted to the conventions of the Modelica Standard Library 3.2.1 and Modelica_Synchronous 0.92.
    * Added utility functions to load parameters from a file.
*  [Version v1.1 (2013-04-24)](../../archive/v1.1build4.zip)
    * Latest build (2013-09-20) uses latest Modelica Standard Library version 3.2.1 and Modelica_Synchronous version 0.92, but will also work with previous versions 3.2 and 0.91.
    * Improved Modelica 3.3 standard conformance (hopefully completely standard conform by now)
    * Included support for the Linux Controller Area Network Protocol Family (aka Socket CAN). This is considered an alpha feature. Therefore the API is not stable and testing has been very limited
    * The CMake based build system for the external C sources of this library has been improved to be more robust and better documented.
    * Bugs in the SerialPackager's AddString and GetString blocks have been resolved and new blocks AddFloat and GetFloat are now available.
    * Some smaller additional bug fixes and improvements.
*  [Version v1.0 (2012-10-17)](../../archive/v1.0.zip)
    * Initial release `v1.0_build5` with improved documentation

## License

This Modelica package is free software and the use is completely at your own risk;
it can be redistributed and/or modified under the terms of the [3-Clause BSD License](LICENSE).

## Development and contribution
Main developers:
* [Bernhard Thiele](https://github.com/bernhard-thiele), release management, Linux specific code, etc.
* [Thomas Beutlich](https://github.com/beutlich), SimulationX support, new features, Windows specific code, etc.
* [Tobias Bellmann](https://github.com/tbellmann), most of the initial MS Windows specific code.

You may report any issues with using the [Issues](https://github.com/modelica/Modelica_DeviceDrivers/issues) button.

Contributions in shape of [Pull Requests](https://github.com/modelica/Modelica_DeviceDrivers/pulls) are always welcome.

The following people have directly contributed to the implementation of the library (many more have contributed by providing feedback and suggestions):
* [Miguel Neves](https://github.com/ChukasNeves), human readable error codes for the Softing CAN interface.
* Dominik Sommer, code for Linux serial port support.
* [Rangarajan Varadan](http://www.codeproject.com/Members/Rangarajan-Varadan), [code for Windows serial port support](http://www.codeproject.com/Articles/81933/Serial-Port-R-W-With-Read-Thread).
* [Dietmar Winkler](https://github.com/dietmarw), GitHub project setup, development services integration etc.
* [Martin Sjölund](https://github.com/sjoelund), `EmbeddedTargets.AVR` support.
* [Lutz Berger](https://github.com/it-cosmos), `EmbeddedTargets.STM32F4` (experimental) support.
* And several more contributed bug fix PRs etc.
