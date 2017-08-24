within Modelica_DeviceDrivers.Incubate.Bustesting;
expandable connector CANBus
  "CAN bus that is adapted to the signals connected to it"
    import Modelica_DeviceDrivers.Incubate.*;
  extends Modelica.Icons.SignalBus;
  Real realSignal1 "First Real signal"  annotation(HideResult=false);
  Integer integerSignal "Integer signal"  annotation(HideResult=false);
  Boolean booleanSignal "Boolean signal"  annotation(HideResult=false);
  CAN_Msg1 cAN_Msg1 "CAN msg1"  annotation(HideResult=false);
  CAN_Msg2 cAN_Msg2 "CAN msg2"  annotation(HideResult=false);

end CANBus;
