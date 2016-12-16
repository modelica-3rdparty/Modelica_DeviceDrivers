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
      annotation (Placement(transformation(extent={{-86,-60},{-66,-40}})));
    Modelica_DeviceDrivers.Blocks.Communication.UDPSend uDPSend
      annotation (Placement(transformation(extent={{-86,-20},{-66,0}})));
    Modelica_DeviceDrivers.Blocks.Communication.SerialPortSend serialPortSend(
        baud=Modelica_DeviceDrivers.Utilities.Types.SerialBaudRate.B19200)
      annotation (Placement(transformation(extent={{-56,-60},{-36,-40}})));
    Modelica_DeviceDrivers.Blocks.Communication.TCPIP_Client_IO tCPIP_Client_IO
      annotation (Placement(transformation(extent={{-26,-60},{-6,-40}})));
    Modelica_DeviceDrivers.Blocks.Communication.LCMSend lCMSend
      annotation (Placement(transformation(extent={{4,-60},{24,-40}})));
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
            extent={{-54,-28},{24,-30}},
            lineColor={238,46,47},
            fontSize=20,
            textString="Recent additions"),
          Text(
            extent={{-54,10},{24,8}},
            lineColor={238,46,47},
            fontSize=20,
            textString="Platform specific CAN support"),
          Rectangle(extent={{-60,12},{28,-22}}, lineColor={255,0,0}),
          Rectangle(extent={{-60,-26},{28,-62}}, lineColor={255,0,0})}));
  end Communication;
  annotation (uses(Modelica_DeviceDrivers(version="1.4.4")));
end ForScreenshots;
