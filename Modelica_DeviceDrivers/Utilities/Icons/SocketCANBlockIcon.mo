within Modelica_DeviceDrivers.Utilities.Icons;
partial block SocketCANBlockIcon "Icon for (Linux) Socket CAN blocks"
  extends LinuxTuxBlockIcon;
  extends BaseIcon;
  extends BusIcon;

  annotation (Icon(graphics={
          Bitmap(extent={{10,-22},{112,-92}},fileName="modelica://Modelica_DeviceDrivers/Resources/Images/Icons/tux-enhanced.png")}));
end SocketCANBlockIcon;
