within ;
package ForScreenshots
  model Overview
    Modelica_DeviceDrivers.Blocks.Communication.SharedMemoryRead
      sharedMemoryRead
      annotation (Placement(transformation(extent={{-20,42},{0,62}})));
    Modelica_DeviceDrivers.Blocks.Communication.UDPReceive uDPReceive
      annotation (Placement(transformation(extent={{10,20},{30,40}})));
    Modelica_DeviceDrivers.Blocks.Communication.SerialPortReceive
      serialPortReceive(baud=Modelica_DeviceDrivers.Utilities.Types.SerialBaudRate.B19200)
      annotation (Placement(transformation(extent={{46,0},{66,20}})));
    Modelica_DeviceDrivers.Blocks.Communication.TCPIP_Client_IO tCPIP_Client_IO
      annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
    Modelica_DeviceDrivers.Blocks.Communication.LCMReceive lCMReceive
      annotation (Placement(transformation(extent={{-48,-20},{-28,0}})));
    Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN.SoftingReadMessage
      rxMessage
      annotation (Placement(transformation(extent={{-76,50},{-56,70}})));
    Modelica_DeviceDrivers.Blocks.Communication.SocketCAN.ReadMessage
      rxMessage1
      annotation (Placement(transformation(extent={{-48,12},{-28,32}})));
    Modelica_DeviceDrivers.Blocks.InputDevices.JoystickInput joystickInput
      annotation (Placement(transformation(extent={{40,52},{60,72}})));
    Modelica_DeviceDrivers.Blocks.InputDevices.KeyboardInput keyboardInput
      annotation (Placement(transformation(extent={{-6,-14},{14,6}})));
    Modelica_DeviceDrivers.Blocks.InputDevices.SpaceMouseInput spaceMouseInput
      annotation (Placement(transformation(extent={{42,-64},{62,-44}})));
    Modelica_DeviceDrivers.Blocks.OperatingSystem.SynchronizeRealtime
      synchronizeRealtime
      annotation (Placement(transformation(extent={{-54,-64},{-34,-44}})));
    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.DataRead adcRead
      annotation (Placement(transformation(extent={{-14,-64},{6,-44}})));
    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.DIORead dioRead
      annotation (Placement(transformation(extent={{66,-28},{86,-8}})));
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager
      annotation (Placement(transformation(extent={{24,-44},{44,-24}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Overview;

  model InputDevices
    Modelica_DeviceDrivers.Blocks.InputDevices.JoystickInput joystickInput
      annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
    Modelica_DeviceDrivers.Blocks.InputDevices.SpaceMouseInput spaceMouseInput
      annotation (Placement(transformation(extent={{-52,40},{-32,60}})));
    Modelica_DeviceDrivers.Blocks.InputDevices.KeyboardInput keyboardInput
      annotation (Placement(transformation(extent={{-22,40},{-2,60}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end InputDevices;

  block Communication
    Modelica_DeviceDrivers.Blocks.Communication.SharedMemoryWrite
      sharedMemoryWrite
      annotation (Placement(transformation(extent={{-86,-50},{-66,-30}})));
    Modelica_DeviceDrivers.Blocks.Communication.UDPSend uDPSend
      annotation (Placement(transformation(extent={{-86,-20},{-66,0}})));
    Modelica_DeviceDrivers.Blocks.Communication.SerialPortSend serialPortSend(
        baud=Modelica_DeviceDrivers.Utilities.Types.SerialBaudRate.B19200)
      annotation (Placement(transformation(extent={{-56,-50},{-36,-30}})));
    Modelica_DeviceDrivers.Blocks.Communication.TCPIP_Client_IO tCPIP_Client_IO
      annotation (Placement(transformation(extent={{-26,-50},{-6,-30}})));
    Modelica_DeviceDrivers.Blocks.Communication.LCMSend lCMSend
      annotation (Placement(transformation(extent={{4,-50},{24,-30}})));
    Modelica_DeviceDrivers.Blocks.Communication.SocketCAN.WriteMessage
      txMessage1
      annotation (Placement(transformation(extent={{-26,-20},{-6,0}})));
    Modelica_DeviceDrivers.Blocks.Communication.SocketCAN.SocketCANConfig
      socketCANConfig
      annotation (Placement(transformation(extent={{-56,-20},{-36,0}})));
    Modelica_DeviceDrivers.Blocks.Communication.SoftingCAN.SoftingCANConfig
      softingCANConfig
      annotation (Placement(transformation(extent={{4,-20},{24,0}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false), graphics={
          Text(
            extent={{-54,10},{24,8}},
            lineColor={135,135,135},
            fontSize=16,
            textString="Platform specific CAN support"),
          Rectangle(extent={{-60,12},{28,-22}}, lineColor={135,135,135})}));
  end Communication;

  model Packaging
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddBoolean
      addBoolean
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddReal addReal
      annotation (Placement(transformation(extent={{0,40},{20,60}})));
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat
      annotation (Placement(transformation(extent={{-30,12},{-10,32}})));
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddString addString(
        data="Hello World")
      annotation (Placement(transformation(extent={{-60,12},{-40,32}})));
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.PackUnsignedInteger
      packInt(bitOffset=8, width=16)
      annotation (Placement(transformation(extent={{0,12},{20,32}})));
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddInteger
      addInteger
      annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Packaging;

  model HardwareIO
    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.ComediConfig comedi
      annotation (Placement(transformation(extent={{-26,-38},{-6,-18}})));
    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.DataWrite dataWrite
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.DataRead dataRead
      annotation (Placement(transformation(extent={{-56,-10},{-36,10}})));
    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.PhysicalDataWrite
      physicalDataWrite
      annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.PhysicalDataRead
      physicalDataRead
      annotation (Placement(transformation(extent={{4,-10},{24,10}})));
    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.DIOWrite dioWrite
      annotation (Placement(transformation(extent={{-80,-38},{-60,-18}})));
    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.DIORead dioRead
      annotation (Placement(transformation(extent={{-56,-38},{-36,-18}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end HardwareIO;

  model TestHardwareIOComedi
    "Example for comedi daq support using USB-DUX D (http://www.linux-usb-daq.co.uk/)"
    import Modelica_DeviceDrivers;
  extends Modelica.Icons.Example;
    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.DataWrite
                               dataWrite(comedi=comedi.dh, subDevice=1)
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.ComediConfig
                                                          comedi
      annotation (Placement(transformation(extent={{-96,-40},{-76,-20}})));
    Modelica.Blocks.Sources.Sine sine(
      freqHz=2,
      amplitude=2000,
      offset=2000)
      annotation (Placement(transformation(extent={{-96,20},{-76,40}})));
    Modelica.Blocks.Math.RealToInteger realToInteger
      annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.DataRead dataRead(
      comedi=comedi.dh,
      subDevice=0,
      channel=0) annotation (Placement(transformation(extent={{-14,20},{6,40}})));
    Modelica_DeviceDrivers.Blocks.OperatingSystem.SynchronizeRealtime
      synchronizeRealtime
      annotation (Placement(transformation(extent={{60,60},{80,80}})));
    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.DIOWrite dioWrite(
                                                                     comedi=
          comedi.dh)
      annotation (Placement(transformation(extent={{-40,-8},{-20,12}})));
    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.DIORead dioRead(
                                                                   channel=1,
        comedi=comedi.dh)
      annotation (Placement(transformation(extent={{-14,-8},{6,12}})));
    Modelica.Blocks.Logical.Less less
      annotation (Placement(transformation(extent={{-68,-8},{-48,12}})));
    Modelica.Blocks.Sources.Constant const(k=2000)
      annotation (Placement(transformation(extent={{-96,-10},{-76,10}})));
    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.PhysicalDataWrite physicalDataWrite(comedi=
          comedi.dh, channel=1)
      annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
    Modelica.Blocks.Sources.Sine sine1(
      freqHz=2,
      amplitude=4,
      offset=0)
      annotation (Placement(transformation(extent={{-68,-40},{-48,-20}})));
    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.PhysicalDataRead physicalDataRead(comedi=
          comedi.dh, channel=1)
      annotation (Placement(transformation(extent={{-14,-40},{6,-20}})));
  equation
    connect(sine.y, realToInteger.u) annotation (Line(
        points={{-75,30},{-72,30},{-70,30}},
        color={0,0,127}));
    connect(realToInteger.y, dataWrite.u) annotation (Line(
        points={{-47,30},{-42,30}},
        color={255,127,0}));
    connect(const.y, less.u2) annotation (Line(
        points={{-75,0},{-75,-6},{-70,-6}},
        color={0,0,127}));
    connect(less.u1, sine.y) annotation (Line(
        points={{-70,2},{-74,2},{-74,30},{-75,30}},
        color={0,0,127}));
    connect(less.y, dioWrite.u) annotation (Line(
        points={{-47,2},{-42,2}},
        color={255,0,255}));
    connect(sine1.y, physicalDataWrite.u)
      annotation (Line(points={{-47,-30},{-42,-30}}, color={0,0,127}));
    annotation (Diagram(graphics={Text(
            extent={{-108,106},{108,76}},
            lineColor={0,0,255},
            textString="Example for USB-DUX D
Assuming input channels are electrical connected to corresponding output channels we should read what we wrote")}),
        experiment(StopTime=5.0),
      Documentation(info="<html>
<p>
<b>Important: Works only under Linux.</b> The reason for this is, that the interfaced <a href=\"http://www.comedi.org/\">Comedi</a> device drivers are only available for Linux.
</p>
<p>
Example tested with <a href=\"http://www.linux-usb-daq.co.uk/tech2_usbdux/\">USB-DUX D</a>. Assuming input channels are electrical connected to corresponding output channels we should read what we wrote
</p>
</html>"));
  end TestHardwareIOComedi;
  annotation (uses(Modelica_DeviceDrivers(version="1.4.4"), Modelica(version=
            "3.2.2")));
end ForScreenshots;
