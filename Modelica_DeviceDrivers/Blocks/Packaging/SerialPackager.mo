within Modelica_DeviceDrivers.Blocks.Packaging;
package SerialPackager "Blocks for constructing packages"
  extends Modelica.Icons.Package;
  package Internal
    extends Modelica.Icons.InternalPackage;
    partial block PartialSerialPackager
      parameter Integer nu(min=0,max=1) = 0 "Output connector size"
          annotation(Dialog(connectorSizing=true), HideResult=true);
      Interfaces.PackageIn pkgIn annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=180,
            origin={0,108})));
      Interfaces.PackageOut pkgOut[nu](dummy(each start=0, each fixed=true))
        annotation (Placement(transformation(extent={{-20,-128},{20,-88}})));
    equation
      if nu == 1 then
        pkgOut.pkg = fill(pkgIn.pkg, nu);
        pkgOut.trigger = fill(pkgIn.trigger, nu);
        pkgOut.backwardTrigger = fill(pkgIn.backwardTrigger,nu);
        pkgOut.userPkgBitSize = fill(pkgIn.userPkgBitSize,nu);
      else
        pkgIn.backwardTrigger = false;
        pkgIn.userPkgBitSize = -1;
      end if;

    end PartialSerialPackager;

    package DummyFunctions
      extends Modelica.Icons.InternalPackage;
      function addReal
        input Modelica_DeviceDrivers.Packaging.SerialPackager     pkg;
        input Real u[:];
        input Real dummy;
        input Modelica_DeviceDrivers.Utilities.Types.ByteOrder byteOrder;
        output Real dummy2;
      algorithm
       Modelica_DeviceDrivers.Packaging.SerialPackager_.addReal(pkg,u,byteOrder);
       dummy2 :=dummy;
      end addReal;

      function addRealAsFloat
        input Modelica_DeviceDrivers.Packaging.SerialPackager  pkg;
        input Real u[:];
        input Real dummy;
        input Modelica_DeviceDrivers.Utilities.Types.ByteOrder byteOrder;
        output Real dummy2;
      algorithm
       Modelica_DeviceDrivers.Packaging.SerialPackager_.addRealAsFloat(pkg,u,byteOrder);
       dummy2 :=dummy;
      end addRealAsFloat;

      function addString
        input Modelica_DeviceDrivers.Packaging.SerialPackager     pkg;
        input String u;
        input Integer bufferSize;
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Packaging.SerialPackager_.addString(pkg, u, bufferSize);
        dummy2 :=dummy;
      end addString;

      function addInteger
        input Modelica_DeviceDrivers.Packaging.SerialPackager     pkg;
        input Integer u[:];
        input Real dummy;
        input Modelica_DeviceDrivers.Utilities.Types.ByteOrder byteOrder;
        output Real dummy2;
      algorithm
       Modelica_DeviceDrivers.Packaging.SerialPackager_.addInteger(pkg,u,byteOrder);
       dummy2 := dummy;
      end addInteger;

      function getReal
        input Modelica_DeviceDrivers.Packaging.SerialPackager     pkg;
        input Integer n;
        input Real dummy;
        input Modelica_DeviceDrivers.Utilities.Types.ByteOrder byteOrder;
        output Real y[n];
        output Real dummy2;
      algorithm
        y := Modelica_DeviceDrivers.Packaging.SerialPackager_.getReal(pkg, n, byteOrder);
        dummy2 :=dummy;
      end getReal;

      function getRealFromFloat
        input Modelica_DeviceDrivers.Packaging.SerialPackager     pkg;
        input Integer n;
        input Real dummy;
        input Modelica_DeviceDrivers.Utilities.Types.ByteOrder byteOrder;
        output Real y[n];
        output Real dummy2;
      algorithm
        y := Modelica_DeviceDrivers.Packaging.SerialPackager_.getRealFromFloat(pkg, n, byteOrder);
        dummy2 :=dummy;
      end getRealFromFloat;

      function resetPointer
        input Modelica_DeviceDrivers.Packaging.SerialPackager     pkg;
        input Real dummy;
        output Real dummy2;
      algorithm
        Modelica_DeviceDrivers.Packaging.SerialPackager_.resetPointer(pkg);
        dummy2 :=dummy;
      end resetPointer;

      function getInteger
        input Modelica_DeviceDrivers.Packaging.SerialPackager     pkg;
        input Integer n;
        input Real dummy;
        input Modelica_DeviceDrivers.Utilities.Types.ByteOrder byteOrder;
        output Integer y[n];
        output Real dummy2;
      algorithm
        y := Modelica_DeviceDrivers.Packaging.SerialPackager_.getInteger(pkg, n, byteOrder);
        dummy2 :=dummy;
      end getInteger;

      function getString
        input Modelica_DeviceDrivers.Packaging.SerialPackager     pkg;
        input Integer bufferSize;
        output String y;
        input Real dummy;
        output Real dummy2;
      algorithm
        y := Modelica_DeviceDrivers.Packaging.SerialPackager_.getString(pkg, bufferSize);
        dummy2 :=dummy;
      end getString;

      function clear
        input Modelica_DeviceDrivers.Packaging.SerialPackager     pkg;
        input Real dummy;
        output Real dummy2;
      algorithm
       Modelica_DeviceDrivers.Packaging.SerialPackager_.clear(pkg);
       dummy2 := dummy;
      end clear;

    function integerBitPack "Encode integer value at bit level"
        import Modelica_DeviceDrivers.Packaging.SerialPackager;
      import Modelica_DeviceDrivers;
      input Modelica_DeviceDrivers.Packaging.SerialPackager
                           pkg;
      input Integer bitOffset
          "Bit offset from current packager position until first encoding bit";
      input Integer width "Number of bits that encode the integer value";
      input Integer value "Value to encode in with bits";
      input Real dummy;
      output Real dummy2;
    algorithm
       Modelica_DeviceDrivers.Packaging.SerialPackager_.integerBitPack(pkg, bitOffset, width, value);
       dummy2 := dummy;
    end integerBitPack;

    function integerBitUnpack "Unpack integer value encoded at bit level"
        import Modelica_DeviceDrivers.Packaging.SerialPackager;
        import Modelica_DeviceDrivers;
      input Modelica_DeviceDrivers.Packaging.SerialPackager
                           pkg;
      input Integer bitOffset
          "Bit offset from current packager position until first encoding bit";
      input Integer width "Number of bits that encode the integer value";
      input Real dummy;
      output Integer value "Decoded integer value";
      output Real dummy2;
    algorithm
      value := Modelica_DeviceDrivers.Packaging.SerialPackager_.integerBitUnpack(pkg, bitOffset, width);
      dummy2 := dummy;
    end integerBitUnpack;
    end DummyFunctions;
  end Internal;

  model Packager
    "Create a package which allows to add signals of various types"
    import
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions;
    import Modelica_DeviceDrivers.Packaging.SerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;

    parameter Boolean enableExternalTrigger = false
      "true, enable external trigger input signal, otherwise use sample time settings below"
      annotation (Dialog(tab="Advanced", group="Activation"), choices(checkBox=true));
    parameter Boolean useBackwardSampleTimePropagation = true
      "true, use backward propagation for sample time, otherwise switch to forward propagation"
      annotation(Dialog(enable = not enableExternalTrigger, tab="Advanced", group="Activation"), choices(checkBox=true));
    parameter Modelica.SIunits.Period sampleTime=0.01
      "Sample time if forward propagation of sample time is used"
       annotation (Dialog(enable = (not useBackwardSampleTimePropagation) and (not enableExternalTrigger), tab="Advanced", group="Activation"));

    parameter Boolean useBackwardPropagatedBufferSize = true
      "true, use backward propagated (automatic) buffer size for package, otherwise use manually specified buffer size below"
      annotation(Dialog(tab="Advanced", group="Buffer size settings"), choices(checkBox=true));
    parameter Integer userBufferSize = 16*1024
      "Buffer size for package if backward propagation of buffer size is deactivated"
       annotation (Dialog(enable = not useBackwardPropagatedBufferSize, tab="Advanced", group="Buffer size settings"));
    Interfaces.PackageOut pkgOut(pkg = SerialPackager(if useBackwardPropagatedBufferSize then bufferSize else userBufferSize), dummy(start=0, fixed=true))
      annotation (Placement(transformation(extent={{-20,-128},{20,-88}})));
    Modelica.Blocks.Interfaces.BooleanInput trigger if                    enableExternalTrigger
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  protected
    Modelica.Blocks.Interfaces.BooleanInput internalTrigger;
    Modelica.Blocks.Interfaces.BooleanInput conditionalInternalTrigger if not enableExternalTrigger;
    Modelica.Blocks.Interfaces.BooleanInput actTrigger
         annotation (HideResult=true);
    Integer backwardPropagatedBufferSize;
    Integer bufferSize;
  equation
    /* Condional connect equations to either use external trigger or internal trigger */
    internalTrigger = if useBackwardSampleTimePropagation then pkgOut.backwardTrigger else sample(0,sampleTime);
    connect(internalTrigger, conditionalInternalTrigger);
    connect(conditionalInternalTrigger, actTrigger);
    connect(trigger, actTrigger);

    when initial() then
      /* If userPkgBitSize is set, use it. Otherwise use auto package size. */
      backwardPropagatedBufferSize = if pkgOut.userPkgBitSize > 0 then
          alignAtByteBoundary(pkgOut.userPkgBitSize)  else
          alignAtByteBoundary(pkgOut.autoPkgBitSize);
      bufferSize = if useBackwardPropagatedBufferSize then backwardPropagatedBufferSize
         else userBufferSize;
    end when;

    pkgOut.trigger = actTrigger;
    when pkgOut.trigger then
      pkgOut.dummy = DummyFunctions.clear(pkgOut.pkg, time);
    end when;

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Bitmap(extent={{-70,-70},{70,70}},
              fileName="Modelica://Modelica_DeviceDrivers/Resources/Images/Icons/package.png")}), Documentation(info="<html>
<p>
The <code>Packager</code> block creates a packager object to which payload can be added by subsequent blocks.
</p>
<h5>Advanced parameter settings</h5>
<p>
With the default parameter settings the buffer size (size of the serialized package), as well as the sample time of the block is determined automatically by
backward propagation. However, that values may also be set manually. An example there this functionality is used is the <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager\"><code>TestSerialPackager</code></a> model. In that model the parameter <code>sampleTime</code> is explicitly set, since backward propagation is not possible in that case.
</p>
<h4>Examples</h4>
<p>
The block is used in several examples, e.g. in,
<a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackager_UDP\"><code>TestSerialPackager_UDP</code></a>.
The figure below shows an arrangement in which a <code>Packager</code> object is created and after that a payload of three Real values
and one Integer value is added, serialized and finally sent using UDP.
</p>
<p><img src=\"modelica://Modelica_DeviceDrivers/Resources/Images/TestSerialPackager_UDP_model.png\"/></p>
</html>"));
  end Packager;

  block AddBoolean "Add a Boolean vector to package"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerWriteIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
    parameter Integer n = 1 "Vector size";
    parameter ByteOrder byteOrder = ByteOrder.LE;
    Modelica.Blocks.Interfaces.BooleanInput u[n]
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  protected
    Integer u_int[n];
  equation

    for i in 1:n loop
      u_int[i] = if
                   (u[i] == true) then 1 else 0;
    end for;

    when initial() then
      pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + n*32 else n*32;
    end when;
    when pkgIn.trigger then
      pkgOut.dummy =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.addInteger(
          pkgOut.pkg,
          u_int,
          pkgIn.dummy,
          byteOrder);
    end when;

    annotation (Icon(graphics={
          Text(
            extent={{-118,40},{-38,-40}},
            lineColor={255,0,255},
            textString="B"),
          Polygon(
            points={{6,0},{-14,20},{-14,10},{-44,10},{-44,-10},{-14,-10},{-14,
                -20},{6,0}},
            lineColor={255,0,255},
            fillColor={255,0,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,-50},{100,-90}},
            textString="%n * int32")}));
  end AddBoolean;

  block AddInteger "Add an Integer vector to package"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerWriteIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
    parameter Integer n = 1 "Vector size";
    parameter ByteOrder byteOrder = ByteOrder.LE;
    Modelica.Blocks.Interfaces.IntegerInput u[n]
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  equation

    when initial() then
      pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + n*32 else n*32;
    end when;
    when pkgIn.trigger then
      pkgOut.dummy =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.addInteger(
          pkgOut.pkg,
          u,
          pkgIn.dummy,
          byteOrder);
    end when;

    annotation (Icon(graphics={
          Text(
            extent={{-100,-50},{100,-90}},
            textString="%n * int32"),
          Text(
            extent={{-120,40},{-40,-40}},
            lineColor={255,127,0},
            textString="I"),
          Polygon(
            points={{6,0},{-14,20},{-14,10},{-44,10},{-44,-10},{-14,-10},{-14,
                -20},{6,0}},
            lineColor={255,127,0},
            fillColor={255,127,0},
            fillPattern=FillPattern.Solid)}),
      Documentation(info="<html>

</html>"));
  end AddInteger;

  block AddReal "Add a Real vector to package"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerWriteIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
    parameter Integer n = 1 "Vector size";
    parameter ByteOrder byteOrder = ByteOrder.LE;
    Modelica.Blocks.Interfaces.RealInput u[n]
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  equation

    when initial() then
      pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + n*64 else n*64;
    end when;

    when pkgIn.trigger then
      pkgOut.dummy =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.addReal(
          pkgOut.pkg,
          u,
          pkgIn.dummy,
          byteOrder);
    end when;
    annotation (Icon(graphics={
          Text(
            extent={{-100,-50},{100,-90}},
            textString="%n * double"),
          Text(
            extent={{-112,40},{-32,-40}},
            lineColor={0,0,255},
            fillPattern=FillPattern.Solid,
            fillColor={0,0,255},
            textString="R"),
          Polygon(
            points={{8,0},{-12,20},{-12,10},{-42,10},{-42,-10},{-12,-10},{-12,
                -20},{8,0}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}));
  end AddReal;

  block AddFloat
    "Cast all elements of Real vector to float and add to package (loss of precision!)"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerWriteIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
    parameter Integer n = 1 "Vector size";
    parameter ByteOrder byteOrder = ByteOrder.LE;
    Modelica.Blocks.Interfaces.RealInput u[n]
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  equation

    when initial() then
      pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + n*32 else n*32;
    end when;

    when pkgIn.trigger then
      pkgOut.dummy =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.addRealAsFloat(
          pkgOut.pkg,
          u,
          pkgIn.dummy,
          byteOrder);
    end when;
    annotation (Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                 graphics={
          Text(
            extent={{-100,-50},{100,-90}},
            textString="%n * float"),
          Text(
            extent={{-112,40},{-32,-40}},
            lineColor={0,0,255},
            fillPattern=FillPattern.Solid,
            fillColor={0,0,255},
            textString="R"),
          Bitmap(extent={{-40,-22},{20,22}}, fileName=
                "modelica://Modelica_DeviceDrivers/Resources/Images/Icons/Real2FloatArrow.png")}));
  end AddFloat;

  block AddString "Add string to package"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerWriteIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    parameter Integer bufferSize = 40
      "Buffer size (in bytes) reserved for String (ensure that same buffer size is used in corresponding GetString block!)";
    input String data = "A mostly harmless String" "Input string written to package; required: length(data) <= bufferSize" annotation(Dialog(enable=true));
  equation
    when initial() then
      pkgIn.autoPkgBitSize = if nu == 1 then
        alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + bufferSize*8 else bufferSize*8;
    end when;
    when pkgIn.trigger then
      assert((Modelica.Utilities.Strings.length(data) + 1 <= bufferSize),
      "AddString: Length of string (+ string termination character) exceeds reserved bufferSize");
      pkgOut.dummy =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.addString(
          pkgOut.pkg,
          data,
          bufferSize,
          pkgIn.dummy);
    end when;
    annotation (Icon(graphics={
          Text(
            extent={{-112,40},{-32,-40}},
            lineColor={255,127,0},
            textString="S"),
          Polygon(
            points={{14,0},{-6,20},{-6,10},{-36,10},{-36,-10},{-6,-10},{-6,-20},
                {14,0}},
            lineColor={255,127,0},
            fillColor={255,127,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,-40},{100,-80}},
            lineColor={255,127,0},
            textString="%data")}));
  end AddString;

  model GetBoolean "Get Boolean vector from package"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerReadIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
    parameter Integer n = 1 "Vector size";
    parameter ByteOrder byteOrder = ByteOrder.LE;
    discrete Modelica.Blocks.Interfaces.BooleanOutput y[n](each start=false, each fixed=true)
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  protected
    Integer y_int[n](each start=0, each fixed=true);
    Real dummy(start=0, fixed=true);
  equation
    when initial() then
      pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary( pkgOut[1].autoPkgBitSize)*8 + n*32 else n*32;
    end when;

    when pkgIn.trigger then
      (y_int, dummy) =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.getInteger(
          pkgIn.pkg,
          n,
          pkgIn.dummy,
          byteOrder);
      pkgOut.dummy = fill(dummy,nu);
    end when;

    for i in 1:n loop
      y[i] = if (y_int[i] == 1) then true else false;
    end for;

    annotation (Icon(graphics={
          Text(
            extent={{30,40},{110,-40}},
            lineColor={255,0,255},
            textString="B"),
          Polygon(
            points={{44,0},{24,20},{24,10},{-6,10},{-6,-10},{24,-10},{24,-20},{
                44,0}},
            lineColor={255,0,255},
            fillColor={255,0,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,-52},{100,-92}},
            textString="%n * int32")}));
  end GetBoolean;

  model GetInteger "Get Integer vector from package"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerReadIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
    parameter Integer n = 1 "Vector size";
    parameter ByteOrder byteOrder = ByteOrder.LE;
    discrete Modelica.Blocks.Interfaces.IntegerOutput y[n](each start=0, each fixed=true)
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  protected
    Real dummy(start=0, fixed=true);
  equation
    when initial() then
      pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary( pkgOut[1].autoPkgBitSize)*8 + n*32 else n*32;
    end when;

    when pkgIn.trigger then
      (y,dummy) =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.getInteger(
          pkgIn.pkg,
          n,
          pkgIn.dummy,
          byteOrder);
      pkgOut.dummy = fill(dummy,nu);
    end when;

    annotation (Icon(graphics={
          Text(
            extent={{40,40},{120,-40}},
            lineColor={255,127,0},
            textString="I"),
          Polygon(
            points={{44,0},{24,20},{24,10},{-6,10},{-6,-10},{24,-10},{24,-20},{
                44,0}},
            lineColor={255,127,0},
            fillColor={255,127,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,-50},{100,-90}},
            textString="%n * int32")}));
  end GetInteger;

  model GetReal "Get Real vector from package"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerReadIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
    parameter Integer n = 1 "Vector size";
    parameter ByteOrder byteOrder = ByteOrder.LE;
    discrete Modelica.Blocks.Interfaces.RealOutput y[n](each start=0, each fixed=true)
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  protected
    Real dummy(start=0, fixed=true);
  equation

    when initial() then
      pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + n*64 else n*64;
    end when;

    when pkgIn.trigger then
      (y,dummy) =
         Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.getReal(
          pkgIn.pkg,
          n,
          pkgIn.dummy,
          byteOrder);
      pkgOut.dummy = fill(dummy,nu);
    end when;

    annotation (Icon(graphics={
          Text(
            extent={{30,40},{110,-40}},
            lineColor={0,0,255},
            fillPattern=FillPattern.Solid,
            fillColor={0,0,255},
            textString="R"),
          Polygon(
            points={{44,0},{24,20},{24,10},{-6,10},{-6,-10},{24,-10},{24,-20},{
                44,0}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,-50},{100,-90}},
            textString="%n * double")}));
  end GetReal;

  model GetFloat
    "Get float vector from package (all values casted to double before assigning it to Modelica Real array)"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerReadIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
    parameter Integer n = 1 "Vector size";
    parameter ByteOrder byteOrder = ByteOrder.LE;
    discrete Modelica.Blocks.Interfaces.RealOutput y[n](each start=0, each fixed=true)
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  protected
    Real dummy(start=0, fixed=true);
  equation

    when initial() then
      pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + n*32 else n*32;
    end when;

    when pkgIn.trigger then
      (y,dummy) =
         Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.getRealFromFloat(
          pkgIn.pkg,
          n,
          pkgIn.dummy,
          byteOrder);
      pkgOut.dummy = fill(dummy,nu);
    end when;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),
                     graphics={
          Text(
            extent={{30,40},{110,-40}},
            lineColor={0,0,255},
            fillPattern=FillPattern.Solid,
            fillColor={0,0,255},
            textString="R"),
          Text(
            extent={{-100,-50},{100,-90}},
            textString="%n * float"),
          Bitmap(extent={{-20,-20},{46,19}}, fileName=
                "modelica://Modelica_DeviceDrivers/Resources/Images/Icons/Float2RealArrow.png")}));
  end GetFloat;

  model GetString "Get String from package"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerReadIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
    import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
    import Modelica.Utilities.Strings.length;
    parameter Integer bufferSize = 40
      "Buffer size (in bytes) reserved for String (ensure that same buffer size is used in corresponding AddString block!)";
    discrete output String data "Output string (read from package)";
  protected
    Real dummy(start=0, fixed=true);
  equation

    when initial() then
      pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + bufferSize*8 else bufferSize*8;
    end when;

    when pkgIn.trigger then
      (data,dummy) =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.getString(
          pkgIn.pkg,
          bufferSize,
          pkgIn.dummy);
      pkgOut.dummy = fill(dummy,nu);
    end when;

    annotation (Icon(graphics={
          Text(
            extent={{38,40},{118,-40}},
            lineColor={255,127,0},
            textString="S"),
          Polygon(
            points={{42,0},{22,20},{22,10},{-8,10},{-8,-10},{22,-10},{22,-20},{
                42,0}},
            lineColor={255,127,0},
            fillColor={255,127,0},
            fillPattern=FillPattern.Solid)}));
  end GetString;

  block PackUnsignedInteger "Encode (non-negative) integer value at bit level"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerWriteIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
    parameter Integer bitOffset = 0
      "Bit offset from current packager position until first encoding bit";
    parameter Integer width = 32 "Number of bits that encode the integer value";
    Modelica.Blocks.Interfaces.IntegerInput u(min=0)
      "Only positive (unsigned) values are supported"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  equation

    when initial() then
      pkgIn.autoPkgBitSize = if nu == 1 then pkgOut[1].autoPkgBitSize + bitOffset + width else bitOffset + width;
    end when;

    when pkgIn.trigger then
      pkgOut.dummy =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.integerBitPack(
          pkgOut.pkg,
          bitOffset,
          width,
          u,
          pkgIn.dummy);
    end when;

    annotation (defaultComponentName="packInt",
      Icon(graphics={
          Text(
            extent={{-120,40},{-40,-40}},
            lineColor={255,127,0},
            textString="I"),
          Text(
            extent={{-100,-50},{100,-90}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            textString="%bitOffset + %width bits"),
          Bitmap(extent={{-56,-20},{8,19}}, fileName=
                "Modelica://Modelica_DeviceDrivers/Resources/Images/Icons/Int2BitArrow.png")}),
      Documentation(info="<html>
<p>The block allows to pack unsigned integer values on bit level. The number of bits used for encoding is set by parameter <code>width</code>, therefore the maximum value of the integer signal that can be encoded is <code>2^width - 1</code>. The parameter <code>bitOffset</code> allows to specify the bit at which the encoding starts <b>relative</b> to the preceding block. </p>
<p>If an <code>AddBoolean</code>, <code>AddInteger</code>, <code>AddReal</code> or <code>AddString</code> block follows a <code>PackUnsignedInteger</code> block the bit position after the <code>PackUnsignedInteger</code> block is aligned to the next byte boundary.</p>
<h4><font color=\"#008000\">Endianness</font></h4>
<p>Currently, the pack block only supports Intel-Endiannes (<b>little-endian!</b>).</p>
<p>For information about endianness in computing see for example <a href=\"http://en.wikipedia.org/wiki/Endianness\">http://en.wikipedia.org/wiki/Endianness</a></p>
<h4><font color=\"#008000\">Example</font></h4>
<p>
The block is used in example
<a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackagerBitPack_UDP\"><code>TestSerialPackagerBitPack_UDP</code></a>, depicted below.
</p>
<p><img src=\"modelica://Modelica_DeviceDrivers/Resources/Images/TestSerialPackagerBitPack_UDP_model.png\"/></p>
The first 3*8 byte of the payload is used for the Real variables. After that two Integer variables are <b>packed</b> into the payload. Finally one Integer variable is added using an ordinary <code>AddInteger</code> block. Assuming that the value of the first Integer variable was <code>3 (decimal) == 11 (binary)</code> we would get the memory layout below. A '.' denotes that the bit is not part of the bits encoding the value (LSB = Least Significant Byte and MSB = Most Significant Byte).
<pre>
                                           byte 24                 byte 25
                                             LSB                      MSB
Relative bit position in Memory: (0  1  2  3  4  5  6  7)  (8  9  10 11 12 13 14 15) ( ..
Value of bit                   : (0  0  0  0  0  0  1  1)  (.  .   .  .  .  .  0  0)
</pre>
<p>See also <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.UnpackUnsignedInteger\"><code>UnpackUnsignedInteger</code></a>.</p>
</html>"));
  end PackUnsignedInteger;

  model UnpackUnsignedInteger "decode integer value encoded at bit level"
    extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerReadIcon;
    extends
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
    parameter Integer bitOffset = 0
      "Bit offset from current packager position until first encoding bit";
    parameter Integer width = 32 "Number of bits that encode the integer value";
    Modelica.Blocks.Interfaces.IntegerOutput y(min=0, start=0, fixed=true)
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  protected
    Real dummy(start=0, fixed=true);
  equation

    when initial() then
      pkgIn.autoPkgBitSize = if nu == 1 then pkgOut[1].autoPkgBitSize + bitOffset + width else bitOffset + width;
    end when;

    when pkgIn.trigger then
      (y,dummy) =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.integerBitUnpack(
          pkgIn.pkg,
          bitOffset,
          width,
          pkgIn.dummy);
      pkgOut.dummy = fill(dummy,nu);
    end when;

    annotation (defaultComponentName="unpackInt",
      Icon(graphics={
          Bitmap(extent={{-7,-20},{57,19}}, fileName=
                "Modelica://Modelica_DeviceDrivers/Resources/Images/Icons/Bit2IntArrow.png"),
          Text(
            extent={{-100,-50},{100,-90}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            textString="%bitOffset + %width bits"),
          Text(
            extent={{40,40},{120,-40}},
            lineColor={255,127,0},
            textString="I")}),
      Documentation(info="<html>
<p>The block allows to unpack unsigned integer values on bit level. The number of bits used for decoding is set by parameter <code>width</code>. The parameter <code>bitOffset</code> allows to specify the bit at which the decoding starts <b>relative</b> to the preceding block. </p>
<p>If an <code>GetBoolean</code>, <code>GetInteger</code>, <code>GetReal</code> or <code>GetString</code> block follows an <code>UnpackUnsignedInteger</code> block the bit position after the <code>UnpackUnsignedInteger</code> block is aligned to the next byte boundary.</p>
<h4><font color=\"#008000\">Endianness</font></h4>
<p>Currently, the pack block only supports Intel-Endiannes (<b>little-endian!</b>).</p>
<p>For information about endianness in computing see for example <a href=\"http://en.wikipedia.org/wiki/Endianness\">http://en.wikipedia.org/wiki/Endianness</a></p>
<h4><font color=\"#008000\">Example</font></h4>
<p>
The block is used in example
<a href=\"modelica://Modelica_DeviceDrivers.Blocks.Examples.TestSerialPackagerBitPack_UDP\"><code>TestSerialPackagerBitPack_UDP</code></a>, depicted below.
</p>
<p><img src=\"modelica://Modelica_DeviceDrivers/Resources/Images/TestSerialPackagerBitUnpack_UDP_model.png\"/></p>
The first 3*8 byte of the payload is deserialized to Real variables. After that two Integer variables are unpacked from the payload. Finally one Integer variable is deserialized using an ordinary <code>GetInteger</code> block. Assume that we had the memory layout below and would like to unpack the second Integer value. A '.' denotes that the bit is not part of the bits encoding the value (LSB = Least Significant Byte and MSB = Most Significant Byte).
<pre>
                                  byte 24  byte 25  byte 26          byte 27                    byte 28
                                                                       LSB                         MSB
Relative bit position in Memory:   0-7      8-15     16-23   (24 25 26 27 28 29 30 31) (32 33 34 35 36 37 38 39) (..
Value of bit                   :                               0  1  .  .  .  .  .  .    0  0  0  0  0  0  0  1
</pre>
<p>The value of the unpacked second Integer value would be <code>5 (decimal) == 101 (binary)</code>.</p>
<p>See also <a href=\"modelica://Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.PackUnsignedInteger\"><code>PackUnsignedInteger</code></a>.</p>
</html>"));
  end UnpackUnsignedInteger;

  block ResetPointer "Set current writing/reading position of package to zero"
    extends
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
  protected
    Real dummy(start=0, fixed=true);
  equation
    when initial() then
      pkgIn.autoPkgBitSize = 0;
    end when;
    when pkgIn.trigger then
      dummy =
        Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Internal.DummyFunctions.resetPointer(pkgIn.pkg, pkgIn.dummy);
      pkgOut.dummy = fill(dummy,nu);
    end when;

    annotation (Icon(graphics={
            Ellipse(
              extent={{39,-20},{-41,60}}),
                               Rectangle(
            extent={{-3,70},{3,48}},
            fillPattern=FillPattern.Solid),Rectangle(
            extent={{-7,76},{-3,44}},
            lineColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fillColor={255,255,255}),
                               Rectangle(
            extent={{3,74},{7,42}},
            lineColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fillColor={255,255,255}),
          Text(
            extent={{-100,-40},{100,-80}},
            fillPattern=FillPattern.Solid,
            textString="Reset")}));
  end ResetPointer;
annotation (preferredView="info", Documentation(info="<html>
<p>The concept of the SerialPackager is to allow adding/retrieving data to/from a package in a device independent manner. See
<a href=\"modelica://Modelica_DeviceDrivers.UsersGuide.GettingStarted\">Getting started</a>.</p>
</html>"));
end SerialPackager;
