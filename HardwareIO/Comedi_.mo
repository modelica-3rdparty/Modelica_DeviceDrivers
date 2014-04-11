within Modelica_DeviceDrivers.HardwareIO;
package Comedi_ "Accompanying functions for the Comedi object"
  extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
encapsulated function data_write "Synchronous write to analog channel"
    import Modelica_DeviceDrivers.HardwareIO.Comedi;
  input Comedi comedi "Device handle";
  input Integer subDevice "Subdevice number";
  input Integer channel "Channel number";
  input Integer range "Range specification";
  input Integer aref "Analog reference type";
  input Integer data "Value that is written to channel";
  external "C" MDD_comedi_data_write(comedi, subDevice, channel, range, aref, data)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
    Include="#include \"MDDComedi.h\"",
    Library={"comedi"});
end data_write;

encapsulated function data_read "Synchronous read from analog channel"
    import Modelica_DeviceDrivers.HardwareIO.Comedi;
  input Comedi comedi "Device handle";
  input Integer subDevice "Subdevice number";
  input Integer channel "Channel number";
  input Integer range "Range specification";
  input Integer aref "Analog reference type";
  output Integer data "Value that is read from channel";
  external "C" data = MDD_comedi_data_read(comedi, subDevice, channel, range, aref)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
    Include="#include \"MDDComedi.h\"",
    Library={"comedi"});
end data_read;

encapsulated function dio_config
    "Input/Output configuration of digital channel"
    import Modelica_DeviceDrivers.HardwareIO.Comedi;
  input Comedi comedi "Device handle";
  input Integer subDevice "Subdevice number";
  input Integer channel "Channel number";
  input Integer direction "Signal direction (input=0, output=1)";
  external "C" MDD_comedi_dio_config(comedi, subDevice, channel, direction)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
    Include="#include \"MDDComedi.h\"",
    Library={"comedi"});
end dio_config;

encapsulated function dio_write "Synchronous write to digital channel"
    import Modelica_DeviceDrivers.HardwareIO.Comedi;
  input Comedi comedi "Device handle";
  input Integer subDevice "Subdevice number";
  input Integer channel "Channel number";
  input Boolean data "Value that is written to channel";
  external "C" MDD_comedi_dio_write(comedi, subDevice, channel, data)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
    Include="#include \"MDDComedi.h\"",
    Library={"comedi"});
end dio_write;

encapsulated function dio_read "Synchronous read from digital channel"
    import Modelica_DeviceDrivers.HardwareIO.Comedi;
  input Comedi comedi "Device handle";
  input Integer subDevice "Subdevice number";
  input Integer channel "Channel number";
  output Boolean data "Value that is read from channel";
  external "C" data = MDD_comedi_dio_read(comedi, subDevice, channel)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
    Include="#include \"MDDComedi.h\"",
    Library={"comedi"});
end dio_read;

encapsulated function set_global_oor_behavior
    "Set global out-of-range behavior of comedi_to_phys(..) function (i.e. behavior for sample values equal 0 or maxdata)"
  input Integer behavior(min=0,max=1)
      "0: COMEDI_OOR_NUMBER, 1: COMEDDI_OOR_NAN";
  output Integer old_behavior "Previous behavior setting";
  external "C" old_behavior = MDD_comedi_set_global_oor_behavior(behavior)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
    Include="#include \"MDDComedi.h\"",
    Library={"comedi"});
end set_global_oor_behavior;

encapsulated function get_range "Get range information of channel"
    import Modelica_DeviceDrivers.HardwareIO.Comedi;
  input Comedi comedi "Device handle";
  input Integer subDevice "Subdevice number";
  input Integer channel "Channel number";
  input Integer range "Range specification";
  output Real min "(Physical) min value";
  output Real max "(Physical) max value";
  output Integer unit
      "physical unit type (for endpoints). UNIT_volt=0 for volts, UNIT_mA=1 for milliamps, or UNIT_none=2 for unitless";
  external "C" MDD_comedi_get_range(comedi, subDevice, channel, range, min, max, unit)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
    Include="#include \"MDDComedi.h\"",
    Library={"comedi"});
end get_range;

encapsulated function get_maxdata "Get maximal possible raw value of channel"
    import Modelica_DeviceDrivers.HardwareIO.Comedi;
  input Comedi comedi "Device handle";
  input Integer subDevice "Subdevice number";
  input Integer channel "Channel number";
  output Integer maxData "Maximum raw value of ADC or DAC";
  external "C" maxData = MDD_comedi_get_maxdata(comedi, subDevice, channel)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
    Include="#include \"MDDComedi.h\"",
    Library={"comedi"});
end get_maxdata;

encapsulated function to_phys "Convert raw value of channel to physical value"
  input Integer rawData "Raw value from channel";
  input Real min "Physical min value of channel";
  input Real max "Physical max value of channel";
  input Integer unit "Physical unit type of channel";
  input Integer maxdata "Maximal raw value of channel";
  output Real physData "Physical value of channel";
  external "C" physData = MDD_comedi_to_phys(rawData, min, max, unit, maxdata)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
    Include="#include \"MDDComedi.h\"",
    Library={"comedi"});
end to_phys;

encapsulated function from_phys
    "Convert physical value of channel to corresponding raw value"
  input Real physData "Physical value of channel";
  input Real min "Physical min value of channel";
  input Real max "Physical max value of channel";
  input Integer unit "Physical unit type of channel";
  input Integer maxdata "Maximal raw value of channel";
  output Integer rawValue "Raw value of channel";
  external "C" rawValue = MDD_comedi_from_phys(physData, min, max, unit, maxdata)
  annotation (IncludeDirectory="modelica://Modelica_DeviceDrivers/Resources/Include",
    Include="#include \"MDDComedi.h\"",
    Library={"comedi"});
end from_phys;
end Comedi_;
