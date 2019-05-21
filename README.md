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
[![Build Status](https://travis-ci.org/modelica-3rdparty/Modelica_DeviceDrivers.svg)](https://travis-ci.org/modelica-3rdparty/Modelica_DeviceDrivers)

## Current release

Download [Modelica_DeviceDrivers latest release](../../releases/latest)

Please note that the library is known to work with
* Dymola,
* SimulationX (with `userBufferSize` all non-clocked communication blocks are working in SimulationX, but `autoBufferSize` only works for external solvers CVode and Fixed Step solver and fails for BDF and MEBDF solvers, see [#54 (comment)](https://github.com/modelica/Modelica_DeviceDrivers/issues/54#issuecomment-76032325)),
* OpenModelica (partial support starting with OpenModelica v1.11.0 Beta 1, e.g., UDP, serial port, shared memory, LCM, keyboard).

If you tested the library successfully with another Modelica tool, please contact [Bernhard Thiele](https://github.com/bernhard-thiele) or send a [pull request](https://github.com/modelica/Modelica_DeviceDrivers/pulls) that updates this README.md.

#### Release notes

Bug fix releases usually do not have release notes, so please use the download link from above to get the latest release including bug fixes.

*  [Version v1.7.0 (2019-03-28)](../../releases/tag/v1.7.0)
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

For information about previous releases, see [Release Notes of Previous Versions](ReleaseNotesPreviousVersions.md).


## License

This Modelica package is free software and the use is completely at your own risk;
it can be redistributed and/or modified under the terms of the [BSD-3-Clause License](LICENSE).

## Development and contribution

The master branch of the  Modelica_DeviceDrivers library should work out-of-the-box when loading the library into a supporting Modelica tool. The branch contains the necessary external C libraries as pre-build binaries below folder [Modelica_DeviceDrivers/Resources/Library](Modelica_DeviceDrivers/Resources/Library).

If you need to build the external C libraries from the sources, clone the repo with

```git
git clone --recursive https://github.com/modelica/Modelica_DeviceDrivers.git
git submodule update --init --recursive
```

and see [Modelica_DeviceDrivers/Resources/README.md](Modelica_DeviceDrivers/Resources/README.md).

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
