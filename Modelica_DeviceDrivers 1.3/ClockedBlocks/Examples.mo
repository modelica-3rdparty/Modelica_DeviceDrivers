within Modelica_DeviceDrivers.ClockedBlocks;
package Examples
  "Executable usage examples for the provided device driver blocks (require Modelica_Synchronous library!)"
  extends Modelica.Icons.ExamplesPackage;

  model TestSerialPackager "Example for using the SerialPackager"
  extends Modelica.Icons.Example;
    Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(3*sin(
          time) + 3))
      annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
    ClockedBlocks.Packaging.SerialPackager.Packager packager
      annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
    ClockedBlocks.Packaging.SerialPackager.PackUnsignedInteger packInt(nu=1, width=10)
      annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
    ClockedBlocks.Packaging.SerialPackager.AddInteger addInteger(nu=1)
      annotation (Placement(transformation(extent={{-50,-46},{-30,-26}})));
    Modelica.Blocks.Sources.IntegerExpression integerExpression2(y=integer(5*sin(
          time)))
      annotation (Placement(transformation(extent={{-100,-46},{-80,-26}})));
    Modelica.Blocks.Sources.IntegerExpression integerExpression1(y=integer(5*sin(
          time) + 5))
      annotation (Placement(transformation(extent={{-100,-8},{-80,12}})));
    ClockedBlocks.Packaging.SerialPackager.PackUnsignedInteger packInt1(
      nu=1,
      bitOffset=5,
      width=10)
      annotation (Placement(transformation(extent={{-50,-8},{-30,12}})));
    ClockedBlocks.Packaging.SerialPackager.ResetPointer resetPointer(nu=1)
      annotation (Placement(transformation(extent={{26,66},{46,86}})));
    ClockedBlocks.Packaging.SerialPackager.UnpackUnsignedInteger unpackInt(nu=1, width=10)
      annotation (Placement(transformation(extent={{26,32},{46,52}})));
    ClockedBlocks.Packaging.SerialPackager.GetInteger getInteger
      annotation (Placement(transformation(extent={{26,-42},{46,-22}})));
    ClockedBlocks.Packaging.SerialPackager.UnpackUnsignedInteger unpackInt1(
      nu=1,
      bitOffset=5,
      width=10) annotation (Placement(transformation(extent={{26,-4},{46,16}})));
    Modelica_Synchronous.IntegerSignals.Sampler.SampleClocked  sample1
      annotation (Placement(transformation(extent={{-72,34},{-60,46}})));
    Modelica_Synchronous.IntegerSignals.Sampler.SampleClocked  sample2
      annotation (Placement(transformation(extent={{-72,-4},{-60,8}})));
    Modelica_Synchronous.IntegerSignals.Sampler.SampleClocked  sample3
      annotation (Placement(transformation(extent={{-72,-42},{-60,-30}})));
    Modelica_Synchronous.ClockSignals.Clocks.PeriodicRealClock periodicRealClock(period=
          0.1)
      annotation (Placement(transformation(extent={{-98,-82},{-78,-62}})));
  equation
    connect(packager.pkgOut, packInt.pkgIn) annotation (Line(
        points={{-40,69.2},{-40,50.8}},
        pattern=LinePattern.None));
    connect(packInt.pkgOut[1], packInt1.pkgIn) annotation (Line(
        points={{-40,29.2},{-40,12.8}},
        pattern=LinePattern.None));
    connect(packInt1.pkgOut[1], addInteger.pkgIn) annotation (Line(
        points={{-40,-8.8},{-40,-25.2}},
        pattern=LinePattern.None));
    connect(addInteger.pkgOut[1], resetPointer.pkgIn) annotation (Line(
        points={{-40,-46.8},{-40,-56},{0,-56},{0,94},{36,94},{36,86.8}},
        pattern=LinePattern.None));
    connect(resetPointer.pkgOut[1], unpackInt.pkgIn) annotation (Line(
        points={{36,65.2},{36,52.8}},
        pattern=LinePattern.None));
    connect(unpackInt.pkgOut[1], unpackInt1.pkgIn) annotation (Line(
        points={{36,31.2},{36,16.8}},
        pattern=LinePattern.None));
    connect(unpackInt1.pkgOut[1], getInteger.pkgIn) annotation (Line(
        points={{36,-4.8},{36,-21.2}},
        pattern=LinePattern.None));
    connect(integerExpression.y, sample1.u) annotation (Line(
        points={{-79,40},{-73.2,40}},
        color={255,127,0}));
    connect(sample1.y, packInt.u) annotation (Line(
        points={{-59.4,40},{-52,40}},
        color={255,127,0}));
    connect(integerExpression1.y, sample2.u) annotation (Line(
        points={{-79,2},{-73.2,2}},
        color={255,127,0}));
    connect(sample2.y, packInt1.u) annotation (Line(
        points={{-59.4,2},{-52,2}},
        color={255,127,0}));
    connect(integerExpression2.y, sample3.u) annotation (Line(
        points={{-79,-36},{-73.2,-36}},
        color={255,127,0}));
    connect(sample3.y, addInteger.u[1]) annotation (Line(
        points={{-59.4,-36},{-52,-36}},
        color={255,127,0}));
    connect(periodicRealClock.y, sample1.clock) annotation (Line(
        points={{-77,-72},{-56,-72},{-56,28},{-66,28},{-66,32.8}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(sample2.clock, periodicRealClock.y) annotation (Line(
        points={{-66,-5.2},{-66,-18},{-56,-18},{-56,-72},{-77,-72}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(sample3.clock, periodicRealClock.y) annotation (Line(
        points={{-66,-43.2},{-66,-72},{-77,-72}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    annotation (experiment(StopTime=5.0),
      Documentation(info="<html>
<p>
The example demonstrates that pack and unpack blocks of the <code>SerialPackager</code> package can be connected directly.
</p>
</html>"));
  end TestSerialPackager;

  model TestSerialPackager_String
    "Example for using the SerialPackager with the AddString and GetString block"
  extends Modelica.Icons.Example;
    Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(3*sin(
          time) + 3))
      annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
    ClockedBlocks.Packaging.SerialPackager.Packager packager
      annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
    ClockedBlocks.Packaging.SerialPackager.PackUnsignedInteger packInt(      width=10, nu=1)
      annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
    ClockedBlocks.Packaging.SerialPackager.AddInteger addInteger(nu=1)
      annotation (Placement(transformation(extent={{-50,-46},{-30,-26}})));
    Modelica.Blocks.Sources.IntegerExpression integerExpression2(y=integer(5*sin(
          time)))
      annotation (Placement(transformation(extent={{-100,-46},{-80,-26}})));
    ClockedBlocks.Packaging.SerialPackager.ResetPointer resetPointer(nu=1)
      annotation (Placement(transformation(extent={{-12,64},{8,84}})));
    ClockedBlocks.Packaging.SerialPackager.UnpackUnsignedInteger unpackInt(      width=10, nu=1)
      annotation (Placement(transformation(extent={{-12,30},{8,50}})));
    ClockedBlocks.Packaging.SerialPackager.GetInteger getInteger
      annotation (Placement(transformation(extent={{-12,-44},{8,-24}})));
    Modelica_Synchronous.IntegerSignals.Sampler.SampleClocked  sample1
      annotation (Placement(transformation(extent={{-72,34},{-60,46}})));
    Modelica_Synchronous.IntegerSignals.Sampler.SampleClocked  sample3
      annotation (Placement(transformation(extent={{-72,-42},{-60,-30}})));
    Modelica_Synchronous.ClockSignals.Clocks.PeriodicRealClock periodicRealClock(period=
          0.1)
      annotation (Placement(transformation(extent={{-98,-82},{-78,-62}})));
    Packaging.SerialPackager.AddString addString(nu=1, data=stringEx.y)
      annotation (Placement(transformation(extent={{-50,-6},{-30,14}})));
    Packaging.SerialPackager.GetString getString(nu=1)
      annotation (Placement(transformation(extent={{-12,-8},{8,12}})));
    Modelica.Blocks.Sources.IntegerExpression findString(y=
          Modelica.Utilities.Strings.find(getString.data, "examp"))
      annotation (Placement(transformation(extent={{20,-10},{94,14}})));
    Utilities.StringExpression stringEx
      annotation (Placement(transformation(extent={{-92,-6},{-64,12}})));
  equation
    connect(packager.pkgOut, packInt.pkgIn) annotation (Line(
        points={{-40,69.2},{-40,50.8}},
        pattern=LinePattern.None));
    connect(addInteger.pkgOut[1], resetPointer.pkgIn) annotation (Line(
        points={{-40,-46.8},{-40,-56},{-20,-56},{-20,94},{-2,94},{-2,84.8}},
        pattern=LinePattern.None));
    connect(resetPointer.pkgOut[1], unpackInt.pkgIn) annotation (Line(
        points={{-2,63.2},{-2,50.8}},
        pattern=LinePattern.None));
    connect(integerExpression.y, sample1.u) annotation (Line(
        points={{-79,40},{-73.2,40}},
        color={255,127,0}));
    connect(sample1.y, packInt.u) annotation (Line(
        points={{-59.4,40},{-52,40}},
        color={255,127,0}));
    connect(integerExpression2.y, sample3.u) annotation (Line(
        points={{-79,-36},{-73.2,-36}},
        color={255,127,0}));
    connect(sample3.y, addInteger.u[1]) annotation (Line(
        points={{-59.4,-36},{-52,-36}},
        color={255,127,0}));
    connect(periodicRealClock.y, sample1.clock) annotation (Line(
        points={{-77,-72},{-56,-72},{-56,28},{-66,28},{-66,32.8}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(sample3.clock, periodicRealClock.y) annotation (Line(
        points={{-66,-43.2},{-66,-72},{-77,-72}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(packInt.pkgOut[1], addString.pkgIn) annotation (Line(
        points={{-40,29.2},{-40,14.8}},
        pattern=LinePattern.None));
    connect(addString.pkgOut[1], addInteger.pkgIn) annotation (Line(
        points={{-40,-6.8},{-40,-25.2}},
        pattern=LinePattern.None));
    connect(unpackInt.pkgOut[1], getString.pkgIn) annotation (Line(
        points={{-2,29.2},{-2,12.8}},
        pattern=LinePattern.None));
    connect(getString.pkgOut[1], getInteger.pkgIn) annotation (Line(
        points={{-2,-8.8},{-2,-23.2}},
        pattern=LinePattern.None));
    annotation (experiment(StopTime=5.0),
      Documentation(info="<html>
<p>
Using Strings in input or output connectors is not very common in Modelica. There are currently no standard connectors for
Strings available in the MSL. Nevertheless, the <code>SerialPackager</code> package provides blocks for Strings, too. The use of this blocks
is demonstrated in this example.
</p>
</html>"));
  end TestSerialPackager_String;

  model TestSerialPackager_UDP
    "Example for combining UDP and SerialPackager blocks"
  extends Modelica.Icons.Example;
    Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Packager
                       packager
      annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
    Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.AddReal
                      addReal(n=3, nu=1)
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    Modelica.Blocks.Sources.RealExpression realExpression[3](y=sin(time)*{1,2,3})
      annotation (Placement(transformation(extent={{-96,20},{-76,40}})));
    Modelica_DeviceDrivers.ClockedBlocks.Communication.UDPSend
                                    uDPSend(port_send=10002)
                                                   annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-30,-58})));
    Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.AddInteger
                         addInteger(nu=1)
      annotation (Placement(transformation(extent={{-40,-38},{-20,-18}})));
    Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(10*sin(
          time)))
      annotation (Placement(transformation(extent={{-96,-38},{-76,-18}})));
    Modelica_Synchronous.IntegerSignals.Sampler.SampleClocked  sample1
      annotation (Placement(transformation(extent={{-66,-34},{-54,-22}})));
    Modelica_Synchronous.RealSignals.Sampler.SampleVectorizedAndClocked sample2(n=3)
      annotation (Placement(transformation(extent={{-66,24},{-54,36}})));
    Modelica_Synchronous.ClockSignals.Clocks.PeriodicRealClock periodicRealClock(period=
          0.1)
      annotation (Placement(transformation(extent={{-94,-90},{-74,-70}})));
    Modelica_DeviceDrivers.ClockedBlocks.Communication.UDPReceive
                                   uDPReceive(port_recv=10002)
                                        annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={30,70})));
    Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.GetReal
                      getReal(n=3, nu=1)
      annotation (Placement(transformation(extent={{20,20},{40,40}})));
    Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.GetInteger
                         getInteger
      annotation (Placement(transformation(extent={{20,-44},{40,-24}})));
    Modelica_Synchronous.RealSignals.Sampler.AssignClockVectorized assignClock1(n=3)
      annotation (Placement(transformation(extent={{52,24},{64,36}})));
    Modelica_Synchronous.IntegerSignals.Sampler.AssignClock
      assignClock2
      annotation (Placement(transformation(extent={{52,-40},{64,-28}})));
    Packaging.SerialPackager.AddFloat addFloat(nu=1, n=2)
      annotation (Placement(transformation(extent={{-40,-8},{-20,12}})));
    Modelica.Blocks.Sources.RealExpression realExpression1[2](y=sin(time)*{1,2})
      annotation (Placement(transformation(extent={{-96,-8},{-76,12}})));
    Modelica_Synchronous.RealSignals.Sampler.SampleVectorizedAndClocked sample3(n=2)
      annotation (Placement(transformation(extent={{-66,-4},{-54,8}})));
    Packaging.SerialPackager.GetFloat getFloat(nu=1, n=2)
      annotation (Placement(transformation(extent={{20,-14},{40,6}})));
    Modelica_Synchronous.RealSignals.Sampler.AssignClockVectorized assignClock3(n=2)
      annotation (Placement(transformation(extent={{52,-10},{64,2}})));
  equation
    connect(packager.pkgOut, addReal.pkgIn) annotation (Line(
        points={{-30,59.2},{-30,40.8}},
        pattern=LinePattern.None));
    connect(addInteger.pkgOut[1], uDPSend.pkgIn) annotation (Line(
        points={{-30,-38.8},{-30,-47.2}},
        pattern=LinePattern.None));
    connect(integerExpression.y, sample1.u) annotation (Line(
        points={{-75,-28},{-67.2,-28}},
        color={255,127,0}));
    connect(sample1.y, addInteger.u[1]) annotation (Line(
        points={{-53.4,-28},{-42,-28}},
        color={255,127,0}));
    connect(periodicRealClock.y, sample1.clock) annotation (Line(
        points={{-73,-80},{-60,-80},{-60,-35.2}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));

    connect(uDPReceive.pkgOut,getReal. pkgIn) annotation (Line(
        points={{30,59.2},{30,50},{30,50},{30,40.8}},
        pattern=LinePattern.None));
    connect(getInteger.y[1], assignClock2.u) annotation (Line(
        points={{41,-34},{50.8,-34}},
        color={255,127,0}));
    connect(periodicRealClock.y, assignClock2.clock) annotation (Line(
        points={{-73,-80},{58,-80},{58,-41.2}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(addReal.pkgOut[1], addFloat.pkgIn) annotation (Line(
        points={{-30,19.2},{-30,12.8}},
        pattern=LinePattern.None));
    connect(addFloat.pkgOut[1], addInteger.pkgIn) annotation (Line(
        points={{-30,-8.8},{-30,-17.2}},
        pattern=LinePattern.None));
    connect(realExpression1.y, sample3.u) annotation (Line(
        points={{-75,2},{-67.2,2}},
        color={0,0,127}));
    connect(realExpression.y, sample2.u) annotation (Line(
        points={{-75,30},{-67.2,30}},
        color={0,0,127}));
    connect(sample2.y, addReal.u) annotation (Line(
        points={{-53.4,30},{-42,30}},
        color={0,0,127}));
    connect(sample3.y, addFloat.u) annotation (Line(
        points={{-53.4,2},{-42,2}},
        color={0,0,127}));
    connect(periodicRealClock.y, sample3.clock) annotation (Line(
        points={{-73,-80},{-50,-80},{-50,-16},{-60,-16},{-60,-5.2}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(periodicRealClock.y, sample2.clock) annotation (Line(
        points={{-73,-80},{-50,-80},{-50,18},{-60,18},{-60,22.8}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(getReal.pkgOut[1], getFloat.pkgIn) annotation (Line(
        points={{30,19.2},{30,6.8}},
        pattern=LinePattern.None));
    connect(getFloat.pkgOut[1], getInteger.pkgIn) annotation (Line(
        points={{30,-14.8},{30,-23.2}},
        pattern=LinePattern.None));
    connect(getReal.y, assignClock1.u) annotation (Line(
        points={{41,30},{50.8,30}},
        color={0,0,127}));
    connect(periodicRealClock.y, assignClock3.clock) annotation (Line(
        points={{-73,-80},{72,-80},{72,-20},{58,-20},{58,-11.2}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(periodicRealClock.y, assignClock1.clock) annotation (Line(
        points={{-73,-80},{80,-80},{80,14},{58,14},{58,22.8}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(getFloat.y, assignClock3.u) annotation (Line(
        points={{41,-4},{50.8,-4}},
        color={0,0,127}));
    annotation (experiment(StopTime=5.0),
      Documentation(info="<html>
<p>
The <code>uDPSend</code> block sends to the local port 10002. The <code>uDPReceive</code> block starts a background process that listens at port 10002. Consequently, the <code>uDPReceive</code> block receives what the <code>uDPSend</code> block sends.
</p>
<p>
<b>Note:</b> There is no causality between the <code>uDPSend</code> block and the <code>uDPReceive</code> block. Therefore the execution order of the blocks is not determined. Additionally, the <code>uDPReceive</code> block starts an own receiving thread, so that the time the data was received is not equal to the time the external function within the <code>uDPReceive</code> block was called. This indeterminism may also show up in the plots.
</p>
</html>"));
  end TestSerialPackager_UDP;

  model TestSerialPackagerBitPack_UDP
    "Example for the PackUnsignedInteger and UnpackUnsignedInteger blocks from the SerialPackager"
  extends Modelica.Icons.Example;
    Modelica_DeviceDrivers.ClockedBlocks.Communication.UDPSend
                                    uDPSend(port_send=10002)
                                                   annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-28,-68})));
    Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(5*sin(
          time) + 10))
      annotation (Placement(transformation(extent={{-94,16},{-74,36}})));
    Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Packager
                            packager
      annotation (Placement(transformation(extent={{-38,80},{-18,100}})));
    Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.PackUnsignedInteger
                                                                     packInt(
        width=10, bitOffset=0,
      nu=1)
      annotation (Placement(transformation(extent={{-38,16},{-18,36}})));
    Modelica_DeviceDrivers.ClockedBlocks.Communication.UDPReceive
                              uDPReceive2_1(port_recv=10002) annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={30,86})));
    Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                         unpackInt(width=10, nu=1)
      annotation (Placement(transformation(extent={{20,14},{40,34}})));
    Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.PackUnsignedInteger
                                                                     packInt1(
        width=10, bitOffset=20,
      nu=1)
      annotation (Placement(transformation(extent={{-38,-16},{-18,4}})));
    Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.AddInteger
                              addInteger1(n=1, nu=1)
      annotation (Placement(transformation(extent={{-38,-46},{-18,-26}})));
    Modelica.Blocks.Sources.IntegerExpression integerExpression1(y=integer(10*sin(
          time) + 10))
      annotation (Placement(transformation(extent={{-94,-16},{-74,4}})));
    Modelica.Blocks.Sources.IntegerConstant integerConstant1(k=4)
      annotation (Placement(transformation(extent={{-94,-46},{-74,-26}})));
    Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.UnpackUnsignedInteger
                                         unpackInt1(width=10, bitOffset=20,
      nu=1)
      annotation (Placement(transformation(extent={{20,-16},{40,4}})));
    Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.GetInteger
                         getInteger1(n=1)
      annotation (Placement(transformation(extent={{20,-52},{40,-32}})));
    Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.AddReal
                           addReal(n=3, nu=1)
      annotation (Placement(transformation(extent={{-38,48},{-18,68}})));
    Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.GetReal
                           getReal(n=3, nu=1)
      annotation (Placement(transformation(extent={{20,46},{40,66}})));
    Modelica.Blocks.Sources.RealExpression realExpression[3](y=sin(time)*{1,2,3})
      annotation (Placement(transformation(extent={{-94,48},{-74,68}})));
    Modelica_Synchronous.ClockSignals.Clocks.PeriodicRealClock periodicRealClock(period=
          0.1)
      annotation (Placement(transformation(extent={{-94,-94},{-74,-74}})));
    Modelica_Synchronous.RealSignals.Sampler.SampleClocked  sample2[3]
      annotation (Placement(transformation(extent={{-64,52},{-52,64}})));
    Modelica_Synchronous.IntegerSignals.Sampler.SampleClocked  sample1
      annotation (Placement(transformation(extent={{-64,20},{-52,32}})));
    Modelica_Synchronous.IntegerSignals.Sampler.SampleClocked  sample3
      annotation (Placement(transformation(extent={{-64,-12},{-52,0}})));
    Modelica_Synchronous.IntegerSignals.Sampler.SampleClocked  sample4
      annotation (Placement(transformation(extent={{-64,-42},{-52,-30}})));
    Modelica_Synchronous.RealSignals.Sampler.AssignClock  assignClock1[3]
      annotation (Placement(transformation(extent={{54,50},{66,62}})));
    Modelica_Synchronous.IntegerSignals.Sampler.AssignClock
      assignClock2
      annotation (Placement(transformation(extent={{54,18},{66,30}})));
    Modelica_Synchronous.IntegerSignals.Sampler.AssignClock
      assignClock3
      annotation (Placement(transformation(extent={{54,-12},{66,0}})));
    Modelica_Synchronous.IntegerSignals.Sampler.AssignClock
      assignClock4
      annotation (Placement(transformation(extent={{54,-48},{66,-36}})));
  equation
    connect(packager.pkgOut, addReal.pkgIn) annotation (Line(
        points={{-28,79.2},{-28,68.8}},
        pattern=LinePattern.None));
    connect(addReal.pkgOut[1], packInt.pkgIn) annotation (Line(
        points={{-28,47.2},{-28,36.8}},
        pattern=LinePattern.None));
    connect(packInt.pkgOut[1], packInt1.pkgIn) annotation (Line(
        points={{-28,15.2},{-28,4.8}},
        pattern=LinePattern.None));
    connect(packInt1.pkgOut[1], addInteger1.pkgIn) annotation (Line(
        points={{-28,-16.8},{-28,-25.2}},
        pattern=LinePattern.None));
    connect(addInteger1.pkgOut[1], uDPSend.pkgIn) annotation (Line(
        points={{-28,-46.8},{-28,-52},{-28,-57.2},{-28,-57.2}},
        pattern=LinePattern.None));
    connect(uDPReceive2_1.pkgOut, getReal.pkgIn) annotation (Line(
        points={{30,75.2},{30,71.4},{30,66.8},{30,66.8}},
        pattern=LinePattern.None));
    connect(getReal.pkgOut[1], unpackInt.pkgIn) annotation (Line(
        points={{30,45.2},{30,34.8}},
        pattern=LinePattern.None));
    connect(unpackInt.pkgOut[1], unpackInt1.pkgIn) annotation (Line(
        points={{30,13.2},{30,4.8}},
        pattern=LinePattern.None));
    connect(unpackInt1.pkgOut[1], getInteger1.pkgIn) annotation (Line(
        points={{30,-16.8},{30,-31.2}},
        pattern=LinePattern.None));
    connect(realExpression.y, sample2.u) annotation (Line(
        points={{-73,58},{-65.2,58}},
        color={0,0,127}));
    connect(sample2.y, addReal.u) annotation (Line(
        points={{-51.4,58},{-40,58}},
        color={0,0,127}));
    connect(periodicRealClock.y, sample4.clock) annotation (Line(
        points={{-73,-84},{-58,-84},{-58,-43.2}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(integerConstant1.y, sample4.u) annotation (Line(
        points={{-73,-36},{-65.2,-36}},
        color={255,127,0}));
    connect(sample4.y, addInteger1.u[1]) annotation (Line(
        points={{-51.4,-36},{-40,-36}},
        color={255,127,0}));
    connect(integerExpression1.y, sample3.u) annotation (Line(
        points={{-73,-6},{-65.2,-6}},
        color={255,127,0}));
    connect(sample3.y, packInt1.u) annotation (Line(
        points={{-51.4,-6},{-40,-6}},
        color={255,127,0}));
    connect(integerExpression.y, sample1.u) annotation (Line(
        points={{-73,26},{-65.2,26}},
        color={255,127,0}));
    connect(sample1.y, packInt.u) annotation (Line(
        points={{-51.4,26},{-40,26}},
        color={255,127,0}));
    connect(periodicRealClock.y, sample3.clock) annotation (Line(
        points={{-73,-84},{-46,-84},{-46,-20},{-58,-20},{-58,-13.2}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(periodicRealClock.y, sample1.clock) annotation (Line(
        points={{-73,-84},{-46,-84},{-46,14},{-58,14},{-58,18.8}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(periodicRealClock.y, sample2[1].clock) annotation (Line(
        points={{-73,-84},{-46,-84},{-46,46},{-58,46},{-58,50.8}},
        color={128,0,255},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(periodicRealClock.y, sample2[2].clock) annotation (Line(
        points={{-73,-84},{-46,-84},{-46,46},{-58,46},{-58,50.8}},
        color={128,0,255},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(periodicRealClock.y, sample2[3].clock) annotation (Line(
        points={{-73,-84},{-46,-84},{-46,46},{-58,46},{-58,50.8}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(unpackInt.y, assignClock2.u) annotation (Line(
        points={{41,24},{52.8,24}},
        color={255,127,0}));
    connect(unpackInt1.y, assignClock3.u) annotation (Line(
        points={{41,-6},{52.8,-6}},
        color={255,127,0}));
    connect(getInteger1.y[1], assignClock4.u) annotation (Line(
        points={{41,-42},{52.8,-42}},
        color={255,127,0}));
    connect(periodicRealClock.y, assignClock4.clock) annotation (Line(
        points={{-73,-84},{60,-84},{60,-49.2}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(periodicRealClock.y, assignClock3.clock) annotation (Line(
        points={{-73,-84},{74,-84},{74,-28},{60,-28},{60,-13.2}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(periodicRealClock.y, assignClock2.clock) annotation (Line(
        points={{-73,-84},{74,-84},{74,8},{60,8},{60,16.8}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(periodicRealClock.y, assignClock1[1].clock) annotation (Line(
        points={{-73,-84},{74,-84},{74,40},{60,40},{60,48.8}},
        color={128,0,255},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(getReal.y, assignClock1.u) annotation (Line(
        points={{41,56},{52.8,56}},
        color={0,0,127}));
    connect(periodicRealClock.y, assignClock1[2].clock) annotation (Line(
        points={{-73,-84},{74,-84},{74,40},{60,40},{60,48.8}},
        color={128,0,255},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(periodicRealClock.y, assignClock1[3].clock) annotation (Line(
        points={{-73,-84},{74,-84},{74,40},{60,40},{60,48.8}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));
    annotation (experiment(StopTime=5.0),
      Documentation(info="<html>
<p>
In particular this model demonstrates how integer values can be packed and unpacked at bit level using the <a href=\"modelica://Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.PackUnsignedInteger\"> <code>PackUnsignedInteger</code></a> and <a href=\"modelica://Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.UnpackUnsignedInteger\"><code>UnpackUnsignedInteger</code></a> blocks.
</p>
</html>"));
  end TestSerialPackagerBitPack_UDP;

  model TestSerialPackager_SharedMemory
    "Example for combining SharedMemory and SerialPackager blocks"
  extends Modelica.Icons.Example;
    ClockedBlocks.Packaging.SerialPackager.Packager packager
      annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
    ClockedBlocks.Packaging.SerialPackager.AddReal addReal(n=3, nu=1)
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    ClockedBlocks.Packaging.SerialPackager.AddInteger addInteger(nu=1)
      annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
    ClockedBlocks.Communication.SharedMemoryWrite sharedMemoryWrite(
        autoBufferSize=true)                          annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-30,-50})));
    Modelica.Blocks.Sources.RealExpression realExpression[3](y=sin(time)*{1,2,3})
      annotation (Placement(transformation(extent={{-96,20},{-76,40}})));
    Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(10*sin(
          time)))
      annotation (Placement(transformation(extent={{-96,-20},{-76,0}})));
    Modelica_Synchronous.IntegerSignals.Sampler.SampleClocked  sample1
      annotation (Placement(transformation(extent={{-66,-16},{-54,-4}})));
    Modelica_Synchronous.RealSignals.Sampler.SampleClocked  sample2[3]
      annotation (Placement(transformation(extent={{-66,24},{-54,36}})));
    Modelica_Synchronous.ClockSignals.Clocks.PeriodicRealClock periodicRealClock(period=
          0.1)
      annotation (Placement(transformation(extent={{-94,-90},{-74,-70}})));
    ClockedBlocks.Packaging.SerialPackager.GetReal getReal(n=3, nu=1)
      annotation (Placement(transformation(extent={{30,30},{50,50}})));
    ClockedBlocks.Packaging.SerialPackager.GetInteger getInteger
      annotation (Placement(transformation(extent={{30,-10},{50,10}})));
    ClockedBlocks.Communication.SharedMemoryRead sharedMemoryRead(
        autoBufferSize=true)                        annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={40,80})));
    Modelica_Synchronous.RealSignals.Sampler.AssignClock  assignClock1[3]
      annotation (Placement(transformation(extent={{62,34},{74,46}})));
    Modelica_Synchronous.IntegerSignals.Sampler.AssignClock
      assignClock2
      annotation (Placement(transformation(extent={{62,-6},{74,6}})));
  equation
    connect(packager.pkgOut, addReal.pkgIn) annotation (Line(
        points={{-30,59.2},{-30,40.8}},
        pattern=LinePattern.None));
    connect(addReal.pkgOut[1], addInteger.pkgIn) annotation (Line(
        points={{-30,19.2},{-30,0.8}},
        pattern=LinePattern.None));
    connect(addInteger.pkgOut[1], sharedMemoryWrite.pkgIn) annotation (Line(
        points={{-30,-20.8},{-30,-30},{-30,-39.2},{-30,-39.2}},
        pattern=LinePattern.None));
    connect(integerExpression.y,sample1. u) annotation (Line(
        points={{-75,-10},{-67.2,-10}},
        color={255,127,0}));
    connect(sample1.y, addInteger.u[1]) annotation (Line(
        points={{-53.4,-10},{-42,-10}},
        color={255,127,0}));
    connect(periodicRealClock.y,sample1. clock) annotation (Line(
        points={{-73,-80},{-60,-80},{-60,-17.2}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(realExpression.y,sample2. u) annotation (Line(
        points={{-75,30},{-67.2,30}},
        color={0,0,127}));
    connect(periodicRealClock.y, sample2[1].clock) annotation (Line(
        points={{-73,-80},{-48,-80},{-48,12},{-60,12},{-60,22.8}},
        color={128,0,255},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(periodicRealClock.y, sample2[2].clock) annotation (Line(
        points={{-73,-80},{-48,-80},{-48,12},{-60,12},{-60,22.8}},
        color={128,0,255},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(periodicRealClock.y, sample2[3].clock) annotation (Line(
        points={{-73,-80},{-48,-80},{-48,12},{-60,12},{-60,22.8}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(sample2.y, addReal.u) annotation (Line(
        points={{-53.4,30},{-42,30}},
        color={0,0,127}));
    connect(periodicRealClock.y, assignClock2.clock) annotation (Line(
        points={{-73,-80},{68,-80},{68,-7.2}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(periodicRealClock.y, assignClock1[1].clock) annotation (Line(
        points={{-73,-80},{88,-80},{88,18},{68,18},{68,32.8}},
        color={128,0,255},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(periodicRealClock.y, assignClock1[2].clock) annotation (Line(
        points={{-73,-80},{88,-80},{88,18},{68,18},{68,32.8}},
        color={128,0,255},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(periodicRealClock.y, assignClock1[3].clock) annotation (Line(
        points={{-73,-80},{88,-80},{88,18},{68,18},{68,32.8}},
        color={135,135,135},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(sharedMemoryRead.pkgOut, getReal.pkgIn) annotation (Line(
        points={{40,69.2},{40,50.8}},
        pattern=LinePattern.None));
    connect(getReal.pkgOut[1], getInteger.pkgIn) annotation (Line(
        points={{40,29.2},{40,10.8}},
        pattern=LinePattern.None));
    connect(getReal.y, assignClock1.u) annotation (Line(
        points={{51,40},{60.8,40}},
        color={0,0,127}));
    connect(getInteger.y[1], assignClock2.u) annotation (Line(
        points={{51,0},{60.8,0}},
        color={255,127,0}));
    annotation (experiment(StopTime=5.0),
      Documentation(info="<html>
<p>
The <code>sharedMemoryWrite</code> block writes to the memory partition with <code>memoryID = \"sharedMemory\"</code>. The <code>sharedMemoryRead</code> block reads from that partition.
</p>
<p>
<b>Note:</b> There is no causality between the <code>sharedMemoryWrite</code> block and the <code>sharedMemoryRead</code> block. Therefore the execution order of the blocks is not determined. This indeterminism may also show up in the plots.
</p>
</html>"));
  end TestSerialPackager_SharedMemory;

  model TestInputSpaceMouse "Example for a 3Dconnexion SpaceMouse"
    extends Modelica.Icons.Example;
    OperatingSystem.SynchronizeRealtime synchronizeRealtime
      annotation (Placement(transformation(extent={{-42,60},{-22,80}})));
    Modelica_Synchronous.ClockSignals.Clocks.PeriodicRealClock periodicRealClock(period=
          0.1)
      annotation (Placement(transformation(extent={{-74,-18},{-54,2}})));
    InputDevices.SpaceMouseInput spaceMouseInput
      annotation (Placement(transformation(extent={{-78,18},{-58,38}})));
    Modelica_Synchronous.RealSignals.Sampler.AssignClock  assignClock1
      annotation (Placement(transformation(extent={{-36,28},{-24,40}})));
  equation

    connect(spaceMouseInput.axes[1], assignClock1.u) annotation (Line(
        points={{-57,33.1667},{-47.7,33.1667},{-47.7,34},{-37.2,34}},
        color={0,0,127}));
    connect(periodicRealClock.y, assignClock1.clock) annotation (Line(
        points={{-53,-8},{-30,-8},{-30,26.8}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    annotation (experiment(StopTime=5.0),
      Documentation(info="<html>
<p>
Basic example of using inputs from a <a href=\"http://www.3dconnexion.com/\">3Dconnexion SpaceMouse</a>.
</p>
<p>
<b>Important for Linux users:</b> In order to work under Linux it is needed that the <a href=\"http://www.3dconnexion.com/service/drivers.html\">linux drivers</a> provided by 3Dconnexion are installed and running.
</p>
</html>"));
  end TestInputSpaceMouse;

  model TestInputJoystick "Example for a joystick/gamepad"
    extends Modelica.Icons.Example;
    InputDevices.JoystickInput joystickInput
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    OperatingSystem.SynchronizeRealtime synchronizeRealtime
      annotation (Placement(transformation(extent={{-42,60},{-22,80}})));
    Modelica_Synchronous.ClockSignals.Clocks.PeriodicRealClock periodicRealClock(period=
          0.1)
      annotation (Placement(transformation(extent={{-74,-18},{-54,2}})));
    Modelica_Synchronous.RealSignals.Sampler.AssignClock  assignClock1
      annotation (Placement(transformation(extent={{-26,28},{-14,40}})));
  equation

    connect(assignClock1.u, joystickInput.pOV) annotation (Line(
        points={{-27.2,34},{-42,34},{-42,30},{-59,30}},
        color={0,0,127}));
    connect(periodicRealClock.y, assignClock1.clock) annotation (Line(
        points={{-53,-8},{-20,-8},{-20,26.8}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    annotation (experiment(StopTime=5.0),
      Documentation(info="<html>
<p>
Basic example of using inputs from a joystick/gamepad device.
</p>
</html>"));
  end TestInputJoystick;

  model TestInputKeyboard "Example for keyboard input"
    extends Modelica.Icons.Example;
    OperatingSystem.SynchronizeRealtime synchronizeRealtime
      annotation (Placement(transformation(extent={{-42,60},{-22,80}})));
    Modelica_Synchronous.ClockSignals.Clocks.PeriodicRealClock periodicRealClock(period=
          0.1)
      annotation (Placement(transformation(extent={{-74,-18},{-54,2}})));
    Modelica_Synchronous.BooleanSignals.Sampler.AssignClock
      assignClock1
      annotation (Placement(transformation(extent={{-30,24},{-18,36}})));
    InputDevices.KeyboardInput keyboardInput
      annotation (Placement(transformation(extent={{-82,22},{-62,42}})));
  equation

    connect(periodicRealClock.y, assignClock1.clock) annotation (Line(
        points={{-53,-8},{-24,-8},{-24,22.8}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(keyboardInput.keyUp, assignClock1.u) annotation (Line(
        points={{-61,38},{-48,38},{-48,30},{-31.2,30}},
        color={255,0,255}));
    annotation (experiment(StopTime=5.0),
      Documentation(info="<html>
<p>
Basic example of using a keyboard as input device.
</p>
</html>"));
  end TestInputKeyboard;

  model TestInputKeyboardKey
    "Example for keyboard input using the KeyboardKeyInput block"
    extends Modelica.Icons.Example;
    OperatingSystem.SynchronizeRealtime synchronizeRealtime
      annotation (Placement(transformation(extent={{-42,60},{-22,80}})));
    Modelica_Synchronous.ClockSignals.Clocks.PeriodicRealClock periodicRealClock(period=
          0.1)
      annotation (Placement(transformation(extent={{-74,-18},{-54,2}})));
    Modelica_Synchronous.BooleanSignals.Sampler.AssignClock
      assignClock1
      annotation (Placement(transformation(extent={{-30,24},{-18,36}})));
    InputDevices.KeyboardKeyInput keyboardKeyInput(keyCode="Space")
      annotation (Placement(transformation(extent={{-78,20},{-58,40}})));
  equation

    connect(keyboardKeyInput.keyState, assignClock1.u) annotation (Line(
        points={{-57,30},{-31.2,30}},
        color={255,0,255}));
    connect(periodicRealClock.y, assignClock1.clock) annotation (Line(
        points={{-53,-8},{-24,-8},{-24,22.8}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    annotation (experiment(StopTime=5.0),
      Documentation(info="<html>
<p>Basic example of using a keyboard as input device. For this example the parameter <code>keyCode</code> is set to the &quot;space&quot; key. Therefore, pressing <i>space</i> while the simulation is running will turn the output of the block to <b>true</b>, otherwise it is <b>false</b>
</p>
</html>"));
  end TestInputKeyboardKey;

  model TestRandomRealSource "Example for using the RandomRealSource block"
    extends Modelica.Icons.Example;
    Modelica_Synchronous.ClockSignals.Clocks.PeriodicRealClock periodicRealClock(period=
          0.1)
      annotation (Placement(transformation(extent={{-66,-12},{-46,8}})));
    Modelica_Synchronous.RealSignals.Sampler.AssignClock  assignClock1
      annotation (Placement(transformation(extent={{-18,28},{-6,40}})));
    OperatingSystem.RandomRealSource randomRealSource
      annotation (Placement(transformation(extent={{-74,24},{-54,44}})));
    OperatingSystem.SynchronizeRealtime synchronizeRealtime
      annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  equation

    connect(randomRealSource.y[1], assignClock1.u) annotation (Line(
        points={{-53,34},{-19.2,34}},
        color={0,0,127}));
    connect(periodicRealClock.y, assignClock1.clock) annotation (Line(
        points={{-45,-2},{-12,-2},{-12,26.8}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    annotation (experiment(StopTime=1.1));
  end TestRandomRealSource;

  model TestHardwareIOComedi
    "Example for comedi daq support using USB-DUX D (http://www.linux-usb-daq.co.uk/)"
    import Modelica_DeviceDrivers;
  extends Modelica.Icons.Example;
    Modelica_DeviceDrivers.ClockedBlocks.HardwareIO.Comedi.DataWrite
                               dataWrite(comedi=comedi.dh, subDevice=1)
      annotation (Placement(transformation(extent={{-14,20},{6,40}})));

    Modelica_DeviceDrivers.Blocks.HardwareIO.Comedi.ComediConfig
                                                          comedi
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
    Modelica.Blocks.Sources.Sine sine(
      freqHz=2,
      amplitude=2000,
      offset=2000)
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    Modelica.Blocks.Math.RealToInteger realToInteger
      annotation (Placement(transformation(extent={{-46,20},{-26,40}})));
    Modelica_DeviceDrivers.ClockedBlocks.OperatingSystem.SynchronizeRealtime
      synchronizeRealtime
      annotation (Placement(transformation(extent={{60,60},{80,80}})));
    Modelica_Synchronous.RealSignals.Sampler.SampleClocked sample
      annotation (Placement(transformation(extent={{-70,24},{-58,36}})));
    Modelica_Synchronous.ClockSignals.Clocks.PeriodicRealClock realClock(period=
          0.1)
      annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
    Modelica_DeviceDrivers.ClockedBlocks.HardwareIO.Comedi.DataRead dataRead(
        comedi=comedi.dh, channel=0)
      annotation (Placement(transformation(extent={{22,20},{42,40}})));
    Modelica_Synchronous.IntegerSignals.Sampler.AssignClock assignClock1
      annotation (Placement(transformation(extent={{54,24},{66,36}})));
    Modelica.Blocks.Sources.Sine sine1(
      freqHz=2,
      amplitude=4,
      offset=0)
      annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
    Modelica_Synchronous.RealSignals.Sampler.SampleClocked sample1
      annotation (Placement(transformation(extent={{-70,-56},{-58,-44}})));
    Modelica_DeviceDrivers.ClockedBlocks.HardwareIO.Comedi.PhysicalDataWrite
      dataWrite1(comedi=comedi.dh, channel=1)
      annotation (Placement(transformation(extent={{-46,-60},{-26,-40}})));
    Modelica_Synchronous.RealSignals.Sampler.AssignClock assignClock2
      annotation (Placement(transformation(extent={{38,-56},{50,-44}})));
    Modelica_DeviceDrivers.ClockedBlocks.HardwareIO.Comedi.PhysicalDataRead
      dataRead1(comedi=comedi.dh, channel=1)
      annotation (Placement(transformation(extent={{8,-60},{28,-40}})));
    Modelica.Blocks.Logical.Less less
      annotation (Placement(transformation(extent={{-46,-20},{-26,0}})));
    Modelica.Blocks.Sources.Constant const(k=2000)
      annotation (Placement(transformation(extent={{-100,-28},{-80,-8}})));
    Modelica_Synchronous.RealSignals.Sampler.SampleClocked sample2
      annotation (Placement(transformation(extent={{-70,-24},{-58,-12}})));
    Modelica_DeviceDrivers.ClockedBlocks.HardwareIO.Comedi.DIOWrite dioWrite(
        comedi=comedi.dh)
      annotation (Placement(transformation(extent={{-14,-20},{6,0}})));
    Modelica_DeviceDrivers.ClockedBlocks.HardwareIO.Comedi.DIORead dioRead(
        channel=1, comedi=comedi.dh)
      annotation (Placement(transformation(extent={{20,-20},{40,0}})));
    Modelica_Synchronous.BooleanSignals.Sampler.AssignClock assignClock3
      annotation (Placement(transformation(extent={{54,-16},{66,-4}})));
  equation
    connect(realToInteger.y, dataWrite.u) annotation (Line(
        points={{-25,30},{-16,30}},
        color={255,127,0}));
    connect(sine.y, sample.u) annotation (Line(
        points={{-79,30},{-71.2,30}},
        color={0,0,127}));
    connect(sample.y, realToInteger.u) annotation (Line(
        points={{-57.4,30},{-48,30}},
        color={0,0,127}));
    connect(dataRead.y, assignClock1.u) annotation (Line(
        points={{43,30},{52.8,30}},
        color={255,127,0}));
    connect(sine1.y, sample1.u) annotation (Line(
        points={{-79,-50},{-71.2,-50}},
        color={0,0,127}));
    connect(sample1.clock, realClock.y) annotation (Line(
        points={{-64,-57.2},{-64,-90},{-79,-90}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(sample1.y, dataWrite1.u) annotation (Line(
        points={{-57.4,-50},{-48,-50}},
        color={0,0,127}));
    connect(assignClock2.clock, realClock.y) annotation (Line(
        points={{44,-57.2},{44,-90},{-79,-90}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(assignClock2.u, dataRead1.y) annotation (Line(
        points={{36.8,-50},{29,-50}},
        color={0,0,127}));
    connect(const.y, sample2.u) annotation (Line(
        points={{-79,-18},{-71.2,-18}},
        color={0,0,127}));
    connect(sample2.y, less.u2) annotation (Line(
        points={{-57.4,-18},{-48,-18}},
        color={0,0,127}));
    connect(less.u1, sample.y) annotation (Line(
        points={{-48,-10},{-54,-10},{-54,30},{-57.4,30}},
        color={0,0,127}));
    connect(sample2.clock, realClock.y) annotation (Line(
        points={{-64,-25.2},{-64,-38},{-74,-38},{-74,-90},{-79,-90}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(sample.clock, realClock.y) annotation (Line(
        points={{-64,22.8},{-64,0},{-74,0},{-74,-90},{-79,-90}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(less.y, dioWrite.u) annotation (Line(
        points={{-25,-10},{-16,-10}},
        color={255,0,255}));
    connect(dioRead.y, assignClock3.u) annotation (Line(
        points={{41,-10},{52.8,-10}},
        color={255,0,255}));
    connect(assignClock3.clock, realClock.y) annotation (Line(
        points={{60,-17.2},{60,-90},{-79,-90}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    connect(assignClock1.clock, realClock.y) annotation (Line(
        points={{60,22.8},{60,4},{74,4},{74,-90},{-79,-90}},
        color={175,175,175},
        pattern=LinePattern.Dot,
        thickness=0.5));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),
                        graphics={Text(
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
end Examples;
