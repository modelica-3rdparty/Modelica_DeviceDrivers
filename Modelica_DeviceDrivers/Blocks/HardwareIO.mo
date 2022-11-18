within Modelica_DeviceDrivers.Blocks;
package HardwareIO
  "Data acquisition hardware like digital-analog converter, analog-digital converter and other interface hardware."
  extends Modelica.Icons.Package;

  package Comedi
    "Support for the linux control and measurement library 'Comedi'"
     extends Modelica.Icons.Package;
    record ComediConfig
      "Configuration for the linux control and measurement library 'Comedi'"
    extends Modelica_DeviceDrivers.Utilities.Icons.ComediRecordIcon;

      import Modelica_DeviceDrivers.HardwareIO.Comedi;
      parameter String deviceName = "/dev/comedi0" "Name of Comedi device";

      final parameter Comedi dh = Comedi(deviceName) "Handle to comedi device";

      annotation (defaultComponentName="comedi",
            preferredView="info",
            Icon(graphics={
            Text(
              extent={{-98,72},{94,46}},
              textString="%deviceName"),
              Bitmap(extent={{-96,-92},{10,20}}, fileName=
                  "modelica://Modelica_DeviceDrivers/Resources/Images/Icons/gears.png")}),
        Documentation(info="<html>
<p>Record for configuring a Comedi device. At initialization time the comedi device given by the parameter <code>deviceName </code>will be opened and a handle to that device will be assigned to the final parameter<code> dh.</code>This handle needs to be passed as parameter to the remaining Comedi read and write blocks<code>.</code></p>
<h4>Note</h4>
<p>Only supported for Linux, since Comedi is only available for linux (<a href=\"http://www.comedi.org/\">http://www.comedi.org/</a>). Requires that Comedilib is installed and that the simulation process has sufficient privileges to access the intended device (usually that requires &quot;root&quot; privileges).</p>
</html>"));
    end ComediConfig;

    block DataWrite "Write raw Integer value to Comedi DAC channel"
      extends Modelica_DeviceDrivers.Utilities.Icons.ComediBlockIcon;
      Modelica.Blocks.Interfaces.IntegerInput u
        annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
      import Modelica_DeviceDrivers.HardwareIO.Comedi;

      parameter Modelica.Units.SI.Period sampleTime=0.01 "Sample time of block";
      parameter Comedi comedi "Handle to comedi device";
      parameter Integer subDevice=1 "Subdevice";
      parameter Integer channel=0 "Channel";
      parameter Integer range=0 "Range";
      parameter Types.Aref aref=Types.Aref.AREF_GROUND "(ground) Reference to use";
    equation
      when sample(0,sampleTime) then
        Modelica_DeviceDrivers.HardwareIO.Comedi_.data_write(
          comedi, subDevice, channel, range, if aref == Types.Aref.AREF_GROUND then 0 elseif aref == Types.Aref.AREF_COMMON then 1 elseif aref == Types.Aref.AREF_DIFF then 2 else 3, u);
      end when;

      annotation (defaultComponentName="dataWrite",
              preferredView="info",
              Icon(graphics={Text(extent={{-222,
                  88},{222,58}},
              textString="Subdevice: %subDevice"), Text(extent={{-222,
                  54},{222,24}},
              textString="Channel: %channel"), Text(extent={{-220,
                  20},{224,-10}},
              textString="Ts: %sampleTime s"), Text(extent={{-220,
                  -104},{224,-134}},
              textString="Device: %comedi"), Text(extent={{-150,142},{150,102}},
                textString="%name")}),
        Documentation(info="<html>
<p>The parameter <code>comedi</code> needs to be set to a valid Comedi device handle, i.e., needs to be set to the record member <code>dh</code> of a <code>ComediConfig</code> record instance.</p>
<p>Wraps the Comedi function<code> comedi_data_write(..)</code>. See the Comedi documentation for the meanings of the parameters <code>subDevice, channel, range, aref</code>.</p>
<h4>Note</h4>
<p>Only supported for Linux, since Comedi is only available for linux (<a href=\"http://www.comedi.org/\">http://www.comedi.org/</a>). Requires that Comedilib is installed and that the simulation process has sufficient privileges to access the intended device (usually that means &quot;root&quot; privileges).</p>
</html>"));
    end DataWrite;

    block DataRead "Read raw Integer value from Comedi ADC channel"
      extends Modelica_DeviceDrivers.Utilities.Icons.ComediBlockIcon;
      import Modelica_DeviceDrivers.HardwareIO.Comedi;

      parameter Modelica.Units.SI.Period sampleTime=0.01 "Sample time of block";
      parameter Comedi comedi "Handle to comedi device";
      parameter Integer subDevice=0 "Subdevice";
      parameter Integer channel=0 "Channel";
      parameter Integer range=0 "Range";
      parameter Types.Aref aref=Types.Aref.AREF_GROUND "(ground) Reference to use";
      Modelica.Blocks.Interfaces.IntegerOutput y
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      when sample(0,sampleTime) then
        y = Modelica_DeviceDrivers.HardwareIO.Comedi_.data_read(
          comedi, subDevice, channel, range, if aref == Types.Aref.AREF_GROUND then 0 elseif aref == Types.Aref.AREF_COMMON then 1 elseif aref == Types.Aref.AREF_DIFF then 2 else 3);
      end when;

      annotation (defaultComponentName="dataRead",
              preferredView="info",
              Icon(graphics={Text(extent={{-222,
                  88},{222,58}},
              textString="Subdevice: %subDevice"), Text(extent={{-222,
                  54},{222,24}},
              textString="Channel: %channel"), Text(extent={{-220,
                  20},{224,-10}},
              textString="Ts: %sampleTime s"), Text(extent={{-220,
                  -104},{224,-134}},
              textString="Device: %comedi"), Text(extent={{-152,142},{148,102}},
                textString="%name")}),        Documentation(info="<html>
<p>The parameter <code>comedi</code> needs to be set to a valid Comedi device handle, i.e., needs to be set to the record member <code>dh</code> of a <code>ComediConfig</code> record instance.</p>
<p>Wraps the Comedi function<code> comedi_data_read(..)</code>. See the Comedi documentation for the meanings of the parameters <code>subDevice, channel, range, aref</code>.</p>
<h4>Note</h4>
<p>Only supported for Linux, since Comedi is only available for linux (<a href=\"http://www.comedi.org/\">http://www.comedi.org/</a>). Requires that Comedilib is installed and that the simulation process has sufficient privileges to access the intended device (usually that means &quot;root&quot; privileges).</p>
</html>"));
    end DataRead;

    block PhysicalDataWrite
      "Write physical value (volts or milliamps) to Comedi DAC channel"
      extends Modelica_DeviceDrivers.Utilities.Icons.ComediBlockIcon;
      Modelica.Blocks.Interfaces.RealInput    u
        annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
      import Modelica_DeviceDrivers.HardwareIO.Comedi;

      parameter Modelica.Units.SI.Period sampleTime=0.01 "Sample time of block";
      parameter Comedi comedi "Handle to comedi device";
      parameter Integer subDevice=1 "Subdevice";
      parameter Integer channel=0 "Channel";
      parameter Integer range=0 "Range";
      parameter Types.Aref aref=Types.Aref.AREF_GROUND "(ground) Reference to use";
    protected
      Real min "Minimal physical value of channel";
      Real max "Maximal physical value of channel";
      Types.ConverterUnit converterUnit "Physical unit type (volts or milliamps)";
      Integer maxData "Maximal Integer raw value of DAC channel";
      Integer rawData "Raw value written to DAC channel";
      Integer cUnit;
    equation
      when initial() then
        (min, max, cUnit) = Modelica_DeviceDrivers.HardwareIO.Comedi_.get_range(
          comedi, subDevice, channel, range);
        converterUnit = if cUnit == 0 then Types.ConverterUnit.UNIT_volt elseif cUnit == 1 then Types.ConverterUnit.UNIT_mA else Types.ConverterUnit.UNIT_none; // convert magic int to readable Modelica enumeration value
        maxData = Modelica_DeviceDrivers.HardwareIO.Comedi_.get_maxdata(
          comedi, subDevice, channel);
      end when;
      when sample(0,sampleTime) then
        rawData = Modelica_DeviceDrivers.HardwareIO.Comedi_.from_phys(
          u, min, max, cUnit, maxData);
        Modelica_DeviceDrivers.HardwareIO.Comedi_.data_write(
          comedi, subDevice, channel, range, if aref == Types.Aref.AREF_GROUND then 0 elseif aref == Types.Aref.AREF_COMMON then 1 elseif aref == Types.Aref.AREF_DIFF then 2 else 3, rawData);
      end when;

      annotation (defaultComponentName="dataWrite",
              preferredView="info",
              Icon(graphics={Text(extent={{-222,
                  88},{222,58}},
              textString="Subdevice: %subDevice"), Text(extent={{-222,
                  54},{222,24}},
              textString="Channel: %channel"), Text(extent={{-220,
                  20},{224,-10}},
              textString="Ts: %sampleTime s"), Text(extent={{-220,
                  -104},{224,-134}},
              textString="Device: %comedi"), Text(extent={{-150,142},{150,102}},
                textString="%name")}),
        Documentation(info="<html>
<p>The parameter <code>comedi</code> needs to be set to a valid Comedi device handle, i.e., needs to be set to the record member <code>dh</code> of a <code>ComediConfig</code> record instance.</p>
<p>Uses the Comedi function<code> comedi_from_phys(..)</code> to support providing a physical value (volts or milliamps) as input to the DAC. See the Comedi documentation for the meanings of the parameters <code>subDevice, channel, range, aref.</code></p>
<h4>Note</h4>
<p>Only supported for Linux, since Comedi is only available for linux (<a href=\"http://www.comedi.org/\">http://www.comedi.org/</a>). Requires that Comedilib is installed and that the simulation process has sufficient privileges to access the intended device (usually that means &quot;root&quot; privileges).</p>
</html>"));
    end PhysicalDataWrite;

    block PhysicalDataRead
      "Read physical value (in volts or milliamps) from Comedi ADC channel"
      extends Modelica_DeviceDrivers.Utilities.Icons.ComediBlockIcon;
      import Modelica_DeviceDrivers.HardwareIO.Comedi;

      parameter Modelica.Units.SI.Period sampleTime=0.01 "Sample time of block";
      parameter Comedi comedi "Handle to comedi device";
      parameter Integer subDevice=0 "Subdevice";
      parameter Integer channel=0 "Channel";
      parameter Integer range=0 "Range";
      parameter Types.Aref aref=Types.Aref.AREF_GROUND "(ground) Reference to use";
      Modelica.Blocks.Interfaces.RealOutput y
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    protected
      Real min "Minimal physical value of channel";
      Real max "Maximal physical value of channel";
      Types.ConverterUnit converterUnit "Physical unit type (volts or milliamps)";
      Integer maxData "Maximal Integer raw value of DAC channel";
      Integer rawData "Raw value read from ADC channel";
      Integer cUnit;
    equation
      when initial() then
        (min, max, cUnit) = Modelica_DeviceDrivers.HardwareIO.Comedi_.get_range(
          comedi, subDevice, channel, range);
        converterUnit = if cUnit == 0 then Types.ConverterUnit.UNIT_volt elseif cUnit == 1 then Types.ConverterUnit.UNIT_mA else Types.ConverterUnit.UNIT_none; // convert magic int to readable Modelica enumeration value
        maxData = Modelica_DeviceDrivers.HardwareIO.Comedi_.get_maxdata(
          comedi, subDevice, channel);
      end when;
      when sample(0,sampleTime) then
        rawData = Modelica_DeviceDrivers.HardwareIO.Comedi_.data_read(
          comedi, subDevice, channel, range, if aref == Types.Aref.AREF_GROUND then 0 elseif aref == Types.Aref.AREF_COMMON then 1 elseif aref == Types.Aref.AREF_DIFF then 2 else 3);
        y = Modelica_DeviceDrivers.HardwareIO.Comedi_.to_phys(
          rawData, min, max, cUnit, maxData);
      end when;

      annotation (defaultComponentName="dataRead",
              preferredView="info",
              Icon(graphics={Text(extent={{-222,
                  88},{222,58}},
              textString="Subdevice: %subDevice"), Text(extent={{-222,
                  54},{222,24}},
              textString="Channel: %channel"), Text(extent={{-220,
                  20},{224,-10}},
              textString="Ts: %sampleTime s"), Text(extent={{-220,
                  -104},{224,-134}},
              textString="Device: %comedi"), Text(extent={{-152,142},{148,102}},
                textString="%name")}),        Documentation(info="<html>
<p>The parameter <code>comedi</code> needs to be set to a valid Comedi device handle, i.e., needs to be set to the record member <code>dh</code> of a <code>ComediConfig</code> record instance.</p>
<p>Uses the Comedi function<code> comedi_to_phys(..)</code> to convert a raw input obtained from the ADC to a physical value (volts or milliamps) . See the Comedi documentation for the meanings of the parameters <code>subDevice, channel, range, aref.</code></p>
<h4>Note</h4>
<p>Only supported for Linux, since Comedi is only available for linux (<a href=\"http://www.comedi.org/\">http://www.comedi.org/</a>). Requires that Comedilib is installed and that the simulation process has sufficient privileges to access the intended device (usually that means &quot;root&quot; privileges).</p>
</html>"));
    end PhysicalDataRead;

    block DIOWrite "Write value to Comedi DIO channel"
      extends Modelica_DeviceDrivers.Utilities.Icons.ComediBlockIcon;
      Modelica.Blocks.Interfaces.BooleanInput u
        annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
      import Modelica_DeviceDrivers.HardwareIO.Comedi;

      parameter Modelica.Units.SI.Period sampleTime=0.01 "Sample time of block";
      parameter Comedi comedi "Handle to comedi device";
      parameter Integer subDevice=2 "Subdevice";
      parameter Integer channel=0 "Channel";

    equation
      when initial() then
        Modelica_DeviceDrivers.HardwareIO.Comedi_.dio_config(
          comedi, subDevice, channel, 1);
      end when;
      when sample(0,sampleTime) then
        Modelica_DeviceDrivers.HardwareIO.Comedi_.dio_write(
          comedi, subDevice, channel, u);
      end when;

      annotation (defaultComponentName="dioWrite",
              preferredView="info",
              Icon(graphics={Text(extent={{-222,
                  88},{222,58}},
              textString="Subdevice: %subDevice"), Text(extent={{-222,
                  54},{222,24}},
              textString="Channel: %channel"), Text(extent={{-220,
                  20},{224,-10}},
              textString="Ts: %sampleTime s"), Text(extent={{-220,
                  -104},{224,-134}},
              textString="Device: %comedi"), Text(extent={{-150,142},{150,102}},
                textString="%name")}),
        Documentation(info="<html>
<p>The parameter <code>comedi</code> needs to be set to a valid Comedi device handle, i.e., needs to be set to the record member <code>dh</code> of a <code>ComediConfig</code> record instance.</p>
<p>Wraps the Comedi function<code> comedi_dio_write(..)</code>. See the Comedi documentation for the meanings of the parameters <code>subDevice </code>and<code> channel</code>.</p>
<h4>Note</h4>
<p>Only supported for Linux, since Comedi is only available for linux (<a href=\"http://www.comedi.org/\">http://www.comedi.org/</a>). Requires that Comedilib is installed and that the simulation process has sufficient privileges to access the intended device (usually that means &quot;root&quot; privileges).</p>
</html>"));
    end DIOWrite;

    block DIORead "Read value from Comedi DIO channel"
      extends Modelica_DeviceDrivers.Utilities.Icons.ComediBlockIcon;
      import Modelica_DeviceDrivers.HardwareIO.Comedi;

      parameter Modelica.Units.SI.Period sampleTime=0.01 "Sample time of block";
      parameter Comedi comedi "Handle to comedi device";
      parameter Integer subDevice=2 "Subdevice";
      parameter Integer channel=0 "Channel";

      Modelica.Blocks.Interfaces.BooleanOutput y
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    equation
      when initial() then
        Modelica_DeviceDrivers.HardwareIO.Comedi_.dio_config(
          comedi, subDevice, channel, 0);
      end when;
      when sample(0,sampleTime) then
        y = Modelica_DeviceDrivers.HardwareIO.Comedi_.dio_read(
          comedi, subDevice, channel);
      end when;

      annotation (defaultComponentName="dioRead",
              preferredView="info",
              Icon(graphics={Text(extent={{-222,
                  88},{222,58}},
              textString="Subdevice: %subDevice"), Text(extent={{-222,
                  54},{222,24}},
              textString="Channel: %channel"), Text(extent={{-220,
                  20},{224,-10}},
              textString="Ts: %sampleTime s"), Text(extent={{-220,
                  -104},{224,-134}},
              textString="Device: %comedi"), Text(extent={{-150,142},{150,102}},
                textString="%name")}),
        Documentation(info="<html>
<p>The parameter <code>comedi</code> needs to be set to a valid Comedi device handle, i.e., needs to be set to the record member <code>dh</code> of a <code>ComediConfig</code> record instance.</p>
<p>Wraps the Comedi function<code> comedi_dio_read(..)</code>. See the Comedi documentation for the meanings of the parameters <code>subDevice </code>and<code> channel</code>.</p>
<h4>Note</h4>
<p>Only supported for Linux, since Comedi is only available for linux (<a href=\"http://www.comedi.org/\">http://www.comedi.org/</a>). Requires that Comedilib is installed and that the simulation process has sufficient privileges to access the intended device (usually that means &quot;root&quot; privileges).</p>
</html>"));
    end DIORead;

    package Types "Types used within the HardwareIO package"
      extends Modelica.Icons.TypesPackage;
      type Aref = enumeration(
          AREF_GROUND "analog ref = ground",
          AREF_COMMON "analog ref = common",
          AREF_DIFF "analog ref = differential",
          AREF_OTHER "analog ref = other (undefined)")
        "Choices for channel reference"
        annotation (Documentation(info="<html>
<p>
Enumeration that defines the available reference channels used in a DAQ-card
</p>
</html>"));

      type Direction = enumeration(
          COMEDI_INPUT "Configuring IO for input",
          COMEDI_OUTPUT "Configuring IO for output")
        "Choices for configuring digital IO channels";

      type ConverterUnit = enumeration(
          UNIT_volt "Volts",
          UNIT_mA "Milliamps",
          UNIT_none "Unitless") "Physical unit of DAC or ADC converter";

      annotation (Documentation(info="<html>
<p>Some type definitions used within the HardwareIO package.</p>
</html>"));
    end Types;
  end Comedi;

  package IIO "Support for the linux device communication library 'libiio'"
     extends Modelica.Icons.Package;

    record IIOConfig "Configuration for the linux device communication library 'libiio'"
    extends Modelica_DeviceDrivers.Utilities.Icons.ComediRecordIcon;

      import Modelica_DeviceDrivers.HardwareIO.IIO;
      parameter String deviceName = "" "Network address of IIO device. Leave empty for local device (Linux only)";

      final parameter IIO dh = IIO(deviceName) "Handle to comedi device";

      annotation (defaultComponentName="iio",
            preferredView="info",
            Icon(graphics={
            Text(
              extent={{-98,72},{94,46}},
              textString="%deviceName"),
              Bitmap(extent={{-96,-92},{10,20}}, fileName=
                  "modelica://Modelica_DeviceDrivers/Resources/Images/Icons/gears.png")}),
        Documentation(info="<html>
<p>Record for configuring a IIO device. At initialization time the IIO device given by the parameter <span style=\"font-family: Courier New;\">deviceName </span>will be opened and a handle to that device will be assigned to the final parameter<span style=\"font-family: Courier New;\"> dh.</span>This handle needs to be passed as parameter to the remaining IIO read and write blocks<span style=\"font-family: Courier New;\">.</span></p>
<h4>Note</h4>
<p>If accessing a local linux device, it iis required that the simulation process has sufficient privileges to access the intended device (usually that requires &quot;root&quot; privileges).</p>
</html>"));
    end IIOConfig;

    block PhysicalDataRead "Read Real value from IIO channel"
      extends Modelica_DeviceDrivers.Utilities.Icons.ComediBlockIcon;
      import Modelica_DeviceDrivers.HardwareIO.IIO;
      import Modelica_DeviceDrivers.HardwareIO.IIOchannel;

      parameter Modelica.Units.SI.Period sampleTime=0.01 "Sample time of block";
      parameter IIO iio "Handle to comedi device";
      parameter String devicename "Device name";
      parameter String channelname "Channel name";
      Modelica.Blocks.Interfaces.RealOutput y
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    protected
      final parameter IIOchannel channel = IIOchannel(iio, devicename, channelname);
      Real scaleData "Scale value read from channel";
      Real rawData "Raw value read from channel";

    equation
      when initial() then
        scaleData = Modelica_DeviceDrivers.HardwareIO.IIO_.data_read(channel, "scale");
      end when;
      when sample(0,sampleTime) then
        rawData = Modelica_DeviceDrivers.HardwareIO.IIO_.data_read(channel, "raw");
        y = scaleData*rawData;
      end when;

      annotation (defaultComponentName="dataRead",
              preferredView="info",
              Icon(graphics={Text(extent={{-222,
                  88},{222,58}},
              textColor={0,0,0},
              textString="Device: %devicename"), Text(extent={{-222,
                  54},{222,24}},
              textString="channel: %channelname",
              textColor={0,0,0}), Text(extent={{-220,
                  20},{224,-10}},
              textString="Ts: %sampleTime",
              textColor={0,0,0}), Text(extent={{-220,
                  -104},{224,-134}},
              textString="Device: %iio",
              textColor={0,0,0}), Text(extent={{-152,142},{148,102}},
                textString="%name")}), Documentation(info="<html>
<p>The parameter <span style=\"font-family: Courier New;\">iio</span> needs to be set to a valid IIO context handle, i.e., needs to be set to the record member <span style=\"font-family: Courier New;\">dh</span> of a <span style=\"font-family: Courier New;\">IIOConfig</span> record instance.</p>
<p>Uses the Comedi function<span style=\"font-family: Courier New;\"> iio_channel_attr_read_double(..)</span> to read the a <span style=\"font-family: Courier New;\">raw</span> and <span style=\"font-family: Courier New;\">scale</span> attribute of a IIO channel and multiplies them to get the value reading.</p>
</html>"));
    end PhysicalDataRead;
  end IIO;
end HardwareIO;
