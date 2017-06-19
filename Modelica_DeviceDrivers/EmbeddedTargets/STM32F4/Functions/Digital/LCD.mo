within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions.Digital;
package LCD
extends .Modelica.Icons.Package;

encapsulated package HD44780
extends .Modelica.Icons.Package;

function updateTextBufferByte "Updates the text buffer of the LCD. Does not actually update the displayed text."
  extends .Modelica.Icons.Function;
  input Init lcd;
  input Integer index(min=1, max=32), character(min=0, max=255);
  external "C" MDD_avr_digitial_HD44780_updateTextBufferByte(lcd, index, character)
  annotation (Include="#include \"MDDARMHD44780.h\"");
  annotation(__ModelicaAssociation_Impure=true);
end updateTextBufferByte;

function updateDisplay "Updates the displayed text of the LCD from the buffer."
  extends .Modelica.Icons.Function;
  input Init lcd;
  external "C" MDD_avr_digitial_HD44780_updateDisplay(lcd)
  annotation (Include="#include \"MDDARMHD44780.h\"");
  annotation(__ModelicaAssociation_Impure=true);
end updateDisplay;

class Init "Interface to Hitachi HD44780, a 16x2 character LCD display"

extends ExternalObject;

function constructor "Initialize device"
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Constants;
  import Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Types;
  extends .Modelica.Icons.Function;
  input Types.Port port "Uses up pins 0-2, 4-7 on a single port on the STM32F4";
  input String text=Constants.spaces_16+Constants.spaces_16 "Assumes 16x2=32 characters are passed. No bounds checking.";
  output Init lcd;
  external "C" lcd = MDD_avr_digitial_HD44780_init(port,text)
  annotation (Include="#include \"MDDARMHD44780.h\"");
end constructor;

function destructor
  extends .Modelica.Icons.Function;
  input Init lcd;
  external "C" MDD_avr_digitial_HD44780_close(lcd)
  annotation (Include="#include \"MDDARMHD44780.h\"");
end destructor;

annotation(Documentation(info="<html>
<p>The PIN mapping of the HD44780 implementation is not very flexible.
You need an entire 8-bit digitial output port in order to use this driver.</p>
<p>PIN mapping: PX = Pin X on the chosen port</p>
<p>P0=LCD RS, P1=LCD RW, P2=LCD EN, P3=NC, P4-7=LCD DB4-7</p>
</html>"));

end Init;

end HD44780;

end LCD;
