within Modelica_DeviceDrivers.EmbeddedTargets;
package AVR "Support for AVR microcontrollers"
  extends Modelica_DeviceDrivers.Utilities.Icons.GenericICPackage;




  annotation(preferredView="info",Documentation(info="<html>
<h4><font color=\"#008000\">Support for the Atmel17 AVR family of microcontrollers</font></h4>
<p>
As of MDD v1.5.0, only ATmega16 and ATmega328P (=Arduino
Uno) are supported. The code can easily be extended, but requires
checking the data sheets in order to write to the correct bits.
</p>
<p><b>So far only known to work with OpenModelica's ExperimentalEmbeddedC code generation</b>.
However, in principle it should work similarly with other (low foot-print) code generators.</p>
<h4><font color=\"#008000\">Translation using OpenModelica v1.12.0 beta</font></h4>
<p>
OpenModelica v1.12.0 beta includes an experimental code generator for low footprint code.
The code generator supports a subset of the Modelica language which will be extended in future versions.
The current version is capable of translating the examples in the subpackages,
but it is not as automated (no generation of makefiles) and it has been only tested using Linux
as the host system. The basics are described in the initial AVR pull request
<a href=\"https://github.com/modelica/Modelica_DeviceDrivers/pull/169\">#169</a>,
but the description below aims to be a bit more complete.
</p>
<p>
Using an Ubuntu Linux, following packages are required:
</p>
<pre>
sudo apt-get install gcc-avr
sudo apt-get install avr-libc
sudo apt-get install avrdude
</pre>
<p>
<h5><font color=\"#008000\">Create a MOS script for the Blink example</font></h5>
For the translation it is convenient to use the OpenModelica scripting interface and
collect the commands in a MOS file, e.g., named
<code>runMDDAvr.mos</code>:
</p>
<pre>
loadModel(Modelica);
getErrorString();

loadFile(\"/path_to_MDD/Modelica_DeviceDrivers/package.mo\");
getErrorString();

translateModel(Modelica_DeviceDrivers.EmbeddedTargets.AVR.Examples.Arduino.UNO.Blink, fileNamePrefix=\"Blink\");
getErrorString();
</pre>
<p>
<h5><font color=\"#008000\">Translate and flash Blink example</font></h5>
Put the <code>runMDDAvr.mos</code> file in a (build) directory and execute following commands on the command line:
</p>
<pre>
omc --simCodeTarget=ExperimentalEmbeddedC runMDDAvr.mos

avr-gcc -Os -std=c11 -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000UL -Wl,--gc-sections Blink_main.c -o Blink -I /path_to_MDD/Modelica_DeviceDrivers/Resources/Include -I /usr/include/omc/c

avr-objcopy -O ihex -R .eeprom Blink Blink.hex
avrdude -F -V -c arduino -p ATMEGA328P -P /dev/ttyACM0 -b 115200 -U flash:w:Blink.hex
</pre>
</html>"),
Icon(graphics={  Text(origin = {32, -3}, lineColor = {255, 255, 255}, extent = {{-44, 19}, {-20, -13}}, textString = "AVR", fontSize = 70, fontName = "Arial", textStyle = {TextStyle.Bold})}, coordinateSystem(initialScale = 0.1)));
end AVR;
