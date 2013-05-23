within Modelica_DeviceDrivers.Incubate.Bustesting;
expandable connector CAN_Msg1 "CAN_msg1"
    import Modelica_DeviceDrivers.Incubate.*;
  extends Modelica.Icons.SignalBus;
  parameter Real myParam = 2 "testme";
  Real rSi1 "IEEE Double, startbit 1, signal"  annotation(HideResult=false);
  Integer iSig1 "Signed Integer signal"  annotation(HideResult=false);

end CAN_Msg1;
