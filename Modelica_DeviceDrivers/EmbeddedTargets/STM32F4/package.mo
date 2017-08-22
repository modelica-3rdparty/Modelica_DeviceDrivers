within Modelica_DeviceDrivers.EmbeddedTargets;
package STM32F4 "Support for STM32F4 microcontrollers"
  extends Modelica_DeviceDrivers.Utilities.Icons.GenericICPackage;
  annotation(preferredView="info",Documentation(info="<html>
<h4><font color=\"#008000\">Support for the STM43F4 family of STM boards</font></h4>
<p>
As of MDD v1.5.0, only ATmega16, ATmega328P (=Arduino
Uno) and STM32F4-Discovery are supported. The code can easily be extended, but requires
checking the data sheets in order to write to the correct bits.
</p>
<p><b>So far only known to work with OpenModelica's ExperimentalEmbeddedC code generation</b>.
However, in principle it should work similarly with other (low foot-print) code generators.</p>
<h4><font color=\"#008000\">Translation using OpenModelica v1.12.0 beta</font></h4>
<p>
OpenModelica v1.12.0 beta includes an experimental code generator for low footprint code.
The code generator supports a subset of the Modelica language which will be extended in future versions.
The current version is capable of translating the examples in the subpackages,
but it is not as automated (no generation of makefiles) except for STM32F4-Discovery Blink example and it has been only tested using Linux
as the host system. 
</p>
<p>
Using Debian Linux (tested with jessy 64 bit), following packages are required:
</p>
<pre>
sudo aptitude install arm-none-eabi-gcc
sudo aptitude installarm-none-eabi-gdb
sudo aptitude install arm-none-eabi-binutils
sudo aptitude install openocd <br>
Using Ubuntu Linux (tested version 14.04.5 LTS) follow the installation guide lines in <a href=http://yottadocs.mbed.com/#linux-cross-compile>doc</a><br>,
download and unpack to folder of your choice STM32F4CUBE from <a href=http://www.st.com/content/st_com/en/products/embedded-software/mcus-embedded-software/stm32-embedded-software/stm32cube-embedded-software/stm32cubef4.html>STM43F4CUBE</a>
</pre>
<p>
<h5><font color=\"#008000\">Create C-code, object debug code, binary and hex file for the Blink example</font></h5>
Set the environment variable STM23F4CUBEROOT: <br><code>export STM23F4CUBEROOT=&lsaquo;Root directory of downloaded stm32cubef4&rsaquo; </code><br><br>
Go to the directory <a href=modelica://Modelica_DeviceDrivers/Resources/Scripts/OpenModelica/EmbeddedTargets/STM32F4/Examples/STM32F4_Discovery/Blink>Script and Makefile Directory</a>. For Ubuntu users adjust the CC variable in the <a href=modelica://Modelica_DeviceDrivers/Resources/Scripts/OpenModelica/EmbeddedTargets/STM32F4/Makefile.inc>Makefile.in</a>. Call &quot;make&quot;. When successfull, all object code will be in the &quot;Debug&quot; directory and &quot;.elf&quot; and &quot;.hex&quot; file will be created in the current directory.
</p>
<p>
<h5><font color=\"#008000\">Debugging, flashing and running the application</font></h5>
Using gdb:
<pre>
arm-none-eabi-gdb
</pre> in the debugger console enter
<pre>
target remote localhost:3333
monitor reset halt
file Blink_main.elf
load
monitor reset
continue
<pre>
Using openocd:
<pre>
openocd -f /usr/share/openocd/scripts/board/stm32f4discovery.cfg</pre>
In a new console open a telnet terminal:
<pre>telnet localhost 4444</pre>
In the telnet terminal enter:
<pre>
> reset halt
> flash write_image erase Blink_main.hex
> reset run
</pre>
</html>"),
Icon(graphics = {Text(origin = {32, -3}, lineColor = {255, 255, 255}, extent = {{-44, 19}, {-20, -13}}, textString = "STM32F4", fontSize = 70, fontName = "Arial", textStyle = {TextStyle.Bold})}, coordinateSystem(initialScale = 0.1)));
end STM32F4;
