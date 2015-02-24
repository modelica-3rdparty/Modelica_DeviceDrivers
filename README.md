# Modelica_DeviceDrivers
Free library for interfacing hardware drivers to Modelica models.
There is support for joysticks, keyboards, UDP, shared memory, AD/DA converters and other devices.

## Library description
The `Modelica_DeviceDrivers` library is an open source Modelica package under [Modelica License 2](https://modelica.org/licenses/ModelicaLicense2) that interfaces hardware drivers to Modelica models.
It unifies previous developments concerning device driver support in Modelica, see [Interactive Simulations and advanced Visualization with Modelica](https://modelica.org/events/modelica2009/Proceedings/memorystick/pages/papers/0056/0056.pdf) and [Modelica for Embedded Systems](https://modelica.org/events/modelica2009/Proceedings/memorystick/pages/papers/0096/0096.pdf) (Modelica'2009 conference). The functionality covered by this library has been used internally at DLR for several years, such as for Driver-in-the-Loop simulation and for the [DLR Robot Motion Simulator](http://www.dlr.de/media/en/desktopdefault.aspx/tabid-4995/8426_read-17606/).
The previously fragmented functionality was streamlined, improved, and extended to a coherent cross-platform library.

Main features:
  * Cross-platform (Windows and Linux).
  * (Soft) real-time synchronization of a simulation.
  * Support for Keyboard, Joystick/Gamepad, and 3Dconnexion Spacemouse.
  * Support for a universal packaging concept to pack Modelica variables in a graphical and convenient way into a bit vector and transport such a bit vector via UDP or Shared Memory (CAN support is prototypical available).
  * Support of the Linux control and measurement device interface for digital and analog IO (Comedi interface).

All device drivers are made available via external Modelica functions. Furthermore, high level interfaces on these functions are provided via Modelica blocks. The first interface uses Modelica 3.2 functionality only (when-clauses and sample-operator).
The second interface uses the synchronous language elements introduced in Modelica 3.3 and is based on clocks (works together with the new `Modelica_Synchronous` library).

![BlockOverview](screenshot.png)

### Self-certification
 - [X] Internationalized
 - [ ] Unit tests
 - [X] End-user documentation
 - [X] Internal documentation (documentation, interfaces, etc.)
 - [X] Existed and maintained for at least 6 months

## Current release

Download [Modelica_DeviceDrivers v1.3 (2014-05-19)](../../archive/v1.3+build.2.zip)

Please note that currently (2015-02-24) the library is known to work with Dymola (preferable Dymola 2013FD01 and later) and partially with SimulationX. If you tested the library successfully with another Modelica tool, please contact me (Bernhard), so that I can include that information.

#### Release notes
*  [Version v1.3 (2014-05-19)](../../archive/v1.3+build.2.zip)
  * Fixed many issues in order to support SimulationX (with the indispensable help of [tbeu](https://github.com/tbeu/)).
  * Particularly, a SimulationX compatible wrapper DLL to give access to the external C functions was added.
  * Added serial port support for Linux.
*  [Version v1.2 (2013-10-01)](../../archive/v1.2+build.1.zip)
  * Adapted to the conventions of the Modelica Standard Library 3.2.1 and Modelica_Synchronous 0.92.
  * Added utility functions to load parameters from a file.
*  [Version v1.1 (2013-04-24)](../../archive/v1.1build4.zip)
  * Latest build (2013-09-20) uses latest Modelica Standard Library version 3.2.1 and Modelica_Synchronous version 0.92, but will also work with previous versions 3.2 and 0.91.
  * Improved Modelica 3.3 standard conformance (hopefully completely standard conform by now)
  * Included support for the Linux Controller Area Network Protocol Family (aka Socket CAN). This is considered an alpha feature. Therefore the API is not stable and testing has been very limited
  * The cmake based build system for the external C sources of this library has been improved to be more robust and better documented.
  * Bugs in the SerialPackager's AddString and GetString blocks have been resolved and new blocks AddFloat and GetFloat are now available.
  * Some smaller additional bugfixes and improvements.
*  [Version v1.0 (2012-10-17)](../../archive/v1.0.zip)
  * Initial release `v1.0_build5` with improved documentation

## License

This Modelica package is free software and the use is completely at your own risk;
it can be redistributed and/or modified under the terms of the [Modelica License 2](https://modelica.org/licenses/ModelicaLicense2).

## Development and contribution
Main developers:
* [Bernhard Thiele](https://github.com/bernhard-thiele), release management and the Linux specific code.
* [Tobias Bellmann](mailto:tobias.bellmann@dlr.de), most of the MS Windows specific code.

You may report any issues with using the [Issues](../../issues) button.

Contributions in shape of [Pull Requests](../../pulls) are always welcome.

The following people have directly contributed to the implementation of the library (many more have contributed by providing feedback and suggestions):
* [Dominik Sommer](mailto:dominik.sommer@dlr.de), code for Linux serial port support.
* [tbeu](https://github.com/tbeu/), many fixes and good proposals, especially regarding the SimulationX support.
