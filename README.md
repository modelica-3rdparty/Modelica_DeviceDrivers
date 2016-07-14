# Modelica_DeviceDrivers
Free library for interfacing hardware drivers to Modelica models.
There is support for joysticks, keyboards, UDP, TCP/IP, LCM, shared memory, AD/DA converters, serial port and other devices.

## Library description
The `Modelica_DeviceDrivers` library is an open source Modelica package under [Modelica License 2](https://modelica.org/licenses/ModelicaLicense2) that interfaces hardware drivers to Modelica models.
It unifies previous developments concerning device driver support in Modelica, see [Interactive Simulations and advanced Visualization with Modelica](https://modelica.org/events/modelica2009/Proceedings/memorystick/pages/papers/0056/0056.pdf) and [Modelica for Embedded Systems](https://modelica.org/events/modelica2009/Proceedings/memorystick/pages/papers/0096/0096.pdf) (Modelica'2009 conference). The functionality covered by this library has been used internally at DLR for several years, such as for Driver-in-the-Loop simulation and for the [DLR Robot Motion Simulator](http://www.dlr.de/media/en/desktopdefault.aspx/tabid-4995/8426_read-17606/).
The previously fragmented functionality was streamlined, improved, and extended to a coherent cross-platform library.

Main features:
  * Cross-platform (Windows and Linux).
  * (Soft) real-time synchronization of a simulation.
  * Support for keyboard, joystick/gamepad, and 3Dconnexion Spacemouse.
  * Support for a universal packaging concept to pack Modelica variables in a graphical and convenient way into a bit vector and transport such a bit vector via UDP, TCP/IP, LCM, serial I/O or shared memory (CAN support is prototypical available).
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
[![Build Status](https://drone.io/github.com/modelica/Modelica_DeviceDrivers/status.png)](https://drone.io/github.com/modelica/Modelica_DeviceDrivers/latest)
[![Build Status](https://travis-ci.org/modelica/Modelica_DeviceDrivers.svg)](https://travis-ci.org/modelica/Modelica_DeviceDrivers)

## Current release

Download [Modelica_DeviceDrivers latest release](../../releases/latest)

Please note that the library is known to work with Dymola (preferable Dymola 2013FD01 and later) and with SimulationX (with `userBufferSize` all non-clocked communication blocks are working in SimulationX, but `autoBufferSize` only works for external solvers CVode and Fixed Step solver and fails for BDF and MEBDF solvers, see [#54 (comment)](https://github.com/modelica/Modelica_DeviceDrivers/issues/54#issuecomment-76032325)). If you tested the library successfully with another Modelica tool, please contact [Bernhard Thiele](https://github.com/bernhard-thiele) or send a [pull request](https://github.com/modelica/Modelica_DeviceDrivers/pulls) that updates this README.md.

#### Release notes
Bugfix releases usually won't have release notes, so please use the download link from above to get the latest release including bugfixes.  
*  [Version v1.4.4 (2016-04-12)](../../releases/tag/v1.4.4)
  * Bugfix release, no new features, but many improvements since version v1.4.0 (more than 70 commits since v1.4.0), so let's list some of the improvements...
  * Uses latest version of Modelica Standard Library (v3.2.2).
  * Changed the license of the external C code and header files to [Simplified BSD License](Modelica_DeviceDrivers/Resources/License.txt) (the Modelica package parts remain under [Modelica License 2](https://modelica.org/licenses/ModelicaLicense2)).
  * Impoved Modelica compatibility: Fixed the use of conditionally enabled variable `procPrio` outside of connect in `Blocks.OperatingSystem.SynchronizeRealtime` and `ClockedBlocks.OperatingSystem.SynchronizeRealtime`.
  * Impoved Modelica compatibility: Fixed the invalid integer to enumeration type conversion in `HardwareIO`.
  * Fully specified the initial conditions for example models.
  * Simplified the linking with system libraries (MSVC only).
  * Added continuous integration for the external C code (thanks to [drone.io](https://drone.io/github.com/modelica/Modelica_DeviceDrivers/latest) and [Travis CI](https://travis-ci.org/modelica/Modelica_DeviceDrivers)).
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
  * Fixed many issues in order to support SimulationX (with the indispensable help of [tbeu](https://github.com/tbeu)).
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
  * Some smaller additional bugfixes and improvements.
*  [Version v1.0 (2012-10-17)](../../archive/v1.0.zip)
  * Initial release `v1.0_build5` with improved documentation

## License

This Modelica package is free software and the use is completely at your own risk;
it can be redistributed and/or modified under the terms of the [Modelica License 2](https://modelica.org/licenses/ModelicaLicense2).

## Development and contribution
Main developers:
* [Bernhard Thiele](https://github.com/bernhard-thiele), release management and the Linux specific code
* [Tobias Bellmann](https://github.com/tbellmann), most of the initial MS Windows specific code
* [tbeu](https://github.com/tbeu), various fixes and improvements, particularly SimulationX support

You may report any issues with using the [Issues](https://github.com/modelica/Modelica_DeviceDrivers/issues) button.

Contributions in shape of [Pull Requests](https://github.com/modelica/Modelica_DeviceDrivers/pulls) are always welcome.

The following people have directly contributed to the implementation of the library (many more have contributed by providing feedback and suggestions):
* Miguel Neves, human readable error codes for the Softing CAN interface.
* Dominik Sommer, code for Linux serial port support.
* Rangarajan Varadan, code for Windows serial port support.
* [Dietmar Winkler](https://github.com/dietmarw), Github project setup, development services integration etc.
