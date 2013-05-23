within Modelica_DeviceDrivers.Incubate.Bustesting;
expandable connector CAN_Msg2 "CAN_msg2"
    import Modelica_DeviceDrivers.Incubate.*;
  extends Modelica.Icons.SignalBus;
  Real rSi1 "IEEE Double, startbit 1, signal"  annotation(HideResult=false);
  Integer iSig1 "Signed Integer signal"  annotation(HideResult=false);

end CAN_Msg2;
