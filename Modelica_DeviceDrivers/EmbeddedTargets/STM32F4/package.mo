within Modelica_DeviceDrivers.EmbeddedTargets;
package STM32F4 "EXPERIMENTAL: Support for STM32F4 microcontrollers. UNSTABLE API!"
  extends Modelica_DeviceDrivers.Utilities.Icons.GenericICPackage;

  extends Modelica_DeviceDrivers.Utilities.Icons.ExperimentalNoStableAPIPackage;

  annotation(preferredView="info",Documentation(info="<html>
<h4>EXPERIMENTAL: Support for the STM32F4 family of STM boards</h4>
<p>
<b>Experimental feature with unstable API! Don't use it, except you want to experiment and you are prepared for severe bugs and other limitations.</b>
</p>
<p>
As of MDD v1.6.0, only the STM32F4-Discovery board is supported. The code can easily be extended, but requires
checking the data sheets in order to write to the correct bits.
</p>
<p><b>So far only known to work with OpenModelica's ExperimentalEmbeddedC code generation</b>.
However, in principle it should work similarly with other (low foot-print) code generators.</p>
<h4>Translation using OpenModelica v1.12.0</h4>
<p>
OpenModelica v1.12.0 includes an experimental code generator for low foot-print code.
The code generator supports a subset of the Modelica language which will be extended in future versions.
The current version is capable of translating the examples in the subpackages,
but it is not as automated (no generation of Makefiles). For the examples within package
<a href=\"modelica://Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Examples.STM32F4_Discovery\">Examples.STM32F4_Discovery</a>
corresponding build scripts and Makefiles are shipped with this library.
They can be found below the library's Resources subfolder
(<a href=\"modelica://Modelica_DeviceDrivers/Resources/Scripts/OpenModelica/EmbeddedTargets/STM32F4/Examples/STM32F4_Discovery\">Resources/Scripts/OpenModelica/EmbeddedTargets/STM32F4/Examples/STM32F4_Discovery</a>).
These scripts and Makefiles have only be tested using Linux as the host system.
</p>
<h5>Debian Linux (tested with jessy 64 bit)</h5>
<p>
Following packages are required:
</p>
<pre>
sudo aptitude install arm-none-eabi-gcc
sudo aptitude installarm-none-eabi-gdb
sudo aptitude install arm-none-eabi-binutils
sudo aptitude install openocd
</pre>
<h5>Ubuntu 16.04.4 LTS (and presumably later)</h5>
<p>
Following packages are required (tested version 16.04.4 LTS):
</p>
<pre>
sudo apt-get install gdb-arm-none-eabi
</pre>
<p>
(should automatically also install binutils-arm-none-eabi and gcc-arm-none-eabi).
</p>
<h5>Ubuntu 14.04.5 LTS</h5>
<p>
Using Ubuntu Linux 14.04.5 LTS with the default repository packages was not successful.
Instead follow the installation guide lines in <a href=\"http://yottadocs.mbed.com/#linux-cross-compile\">doc</a>.
</p>
<h5>Create C-code, object debug code, binary and hex file for the Blink example</h5>
<p>
Download STM32F4CUBE from <a href=\"http://www.st.com/content/st_com/en/products/embedded-software/mcus-embedded-software/stm32-embedded-software/stm32cube-embedded-software/stm32cubef4.html\">STM43F4CUBE</a>
and unpack to folder of your choice.
Set environment variable pointing to the STM32F4 HAL package:
</p>
<pre>
export STM23F4CUBEROOT=/path/to/STM32Cube_FW_F4_V1.XX.X
</pre>
<p>
Go to the directory
<a href=\"modelica://Modelica_DeviceDrivers/Resources/Scripts/OpenModelica/EmbeddedTargets/STM32F4/Examples/STM32F4_Discovery/Blink\">Script and Makefile Directory</a>.
Call &quot;make&quot;
When successful, all object code will be in the &quot;Debug&quot; directory and
&quot;.elf&quot; and &quot;.hex&quot; file will be created in the current directory.
</p>
<h4>Debugging, flashing and running the application</h4>
<p>
There are several options how this can be done, e.g., using gdb or using openocd.
</p>
<h5>Using gdb</h5>
<p>
First set up stlink:
</p>
<pre>
sudo apt-get install git libusb-1.0.0-dev pkg-config autotools-dev
git clone https://github.com/texane/stlink.git
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
sudo make install
# Reload udev rules or reboot system:
sudo udevadm control --reload-rules
sudo udevadm trigger
</pre>
<p>
Now do:
</p>
<pre>
sudo st-util
</pre>
<p>
Check the port which opened (default for me: 4242). Start the debugger:
</p>
<pre>
sudo arm-none-eabi-gdb
</pre>
<p>
In the debugger console enter:
</p>
<pre>
target remote localhost:4242
monitor reset halt
file Blink_main.elf
load
monitor reset
continue
</pre>
<h5>Using openocd</h5>
<pre>
openocd -f /usr/share/openocd/scripts/board/stm32f4discovery.cfg
</pre>
<p>In a new console open a telnet terminal:</p>
<pre>telnet localhost 4444</pre>
<p>In the telnet terminal enter:</p>
<pre>
> reset halt
> flash write_image erase Blink_main.hex
> reset run
</pre>
</html>"),
Icon(graphics={  Text(origin = {32, -3}, textColor = {255, 255, 255}, extent = {{-44, 19}, {-20, -13}}, textString = "STM32F4", fontSize = 70, fontName = "Arial", textStyle = {TextStyle.Bold})}, coordinateSystem(initialScale = 0.1)));
end STM32F4;
