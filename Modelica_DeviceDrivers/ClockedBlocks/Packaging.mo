within Modelica_DeviceDrivers.ClockedBlocks;
package Packaging
  extends Modelica.Icons.Package;
  package SerialPackager "Blocks for constructing packages"
    extends Modelica.Icons.Package;

    package Internal
      extends Modelica.Icons.InternalPackage;
      partial block PartialSerialPackager
        extends
          Modelica_DeviceDrivers.Utilities.Icons.PartialClockedDeviceDriverIcon;
        parameter Integer nu(min=0,max=1) = 0 "Output connector size"
            annotation(Dialog(connectorSizing=true), HideResult=true);
        Interfaces.PackageIn pkgIn         annotation (Placement(transformation(
              extent={{-20,-20},{20,20}},
              rotation=180,
              origin={0,108})));
        Interfaces.PackageOut pkgOut[nu]
          annotation (Placement(transformation(extent={{-20,-128},{20,-88}})));
      equation
        if nu == 1 then
          pkgOut.pkg = fill(pkgIn.pkg, nu);
          pkgOut.userPkgBitSize = fill(pkgIn.userPkgBitSize,nu);
        else
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
         Modelica_DeviceDrivers.Packaging.SerialPackager_.addReal(pkg,u, byteOrder);
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
          Modelica_DeviceDrivers.Packaging.SerialPackager_.addString(pkg,u, bufferSize);
          dummy2 :=dummy;
        end addString;

        function addInteger
          input Modelica_DeviceDrivers.Packaging.SerialPackager     pkg;
          input Integer u[:];
          input Real dummy;
          input Modelica_DeviceDrivers.Utilities.Types.ByteOrder byteOrder;
          output Real dummy2;
        algorithm
         Modelica_DeviceDrivers.Packaging.SerialPackager_.addInteger(pkg, u, byteOrder);
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
          output String y;
          input Integer bufferSize;
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
         Modelica_DeviceDrivers.Packaging.SerialPackager_.integerBitPack(
                                       pkg, bitOffset, width, value);
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
        value := Modelica_DeviceDrivers.Packaging.SerialPackager_.integerBitUnpack(
                                                 pkg, bitOffset, width);
        dummy2 := dummy;
      end integerBitUnpack;
      end DummyFunctions;
    end Internal;

    model Packager
      "Create a package which allows to add signals of various types"
      extends
        Modelica_DeviceDrivers.Utilities.Icons.PartialClockedDeviceDriverIcon;
      import
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.DummyFunctions;
      import Modelica_DeviceDrivers.Packaging.SerialPackager;
      import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;

      parameter Boolean useBackwardPropagatedBufferSize = true
        "true, use backward propagated (automatic) buffer size for package (default!), otherwise use manually specified buffer size below"
        annotation(Dialog(tab="Advanced"), choices(checkBox=true));
      parameter Integer userBufferSize = 16*1024
        "Buffer size for package if backward propagation of buffer size is deactivated" annotation (Dialog(enable = not useBackwardPropagatedBufferSize, tab="Advanced"));

      Interfaces.PackageOut        pkgOut
        annotation (Placement(transformation(extent={{-20,-128},{20,-88}})));
    protected
      Boolean initialized(start=false);
      Real dummy(start=0);
      Real Ts = interval();
      Integer backwardPropagatedBufferSize;
      Integer bufferSize;
    equation
      if not previous(initialized) then
        /* If userPkgBitSize is set, use it. Otherwise use auto package size. */
        backwardPropagatedBufferSize = if pkgOut.userPkgBitSize > 0 then
          alignAtByteBoundary(pkgOut.userPkgBitSize) else alignAtByteBoundary(
          pkgOut.autoPkgBitSize);
        bufferSize =  if useBackwardPropagatedBufferSize then
          backwardPropagatedBufferSize else userBufferSize;
        pkgOut.pkg =  SerialPackager(bufferSize);
        Modelica.Utilities.Streams.print("SerialPackager: Created package with "+String(bufferSize)+" bytes size.");
         initialized =  true;
      else
        backwardPropagatedBufferSize = previous(backwardPropagatedBufferSize);
        bufferSize = previous(bufferSize);
        pkgOut.pkg = previous(pkgOut.pkg);
        initialized = previous(initialized);
      end if;

    // The following is not working in Dymola 2013 Synchronous Beta 3!?:
    //  dummy := previous(dummy) + interval();
      dummy =  previous(dummy) + Ts;
      pkgOut.dummy = DummyFunctions.clear(pkgOut.pkg, dummy);

      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={Bitmap(extent={{-70,-70},{70,70}},
                fileName="Modelica://Modelica_DeviceDrivers/Resources/Images/Icons/package.png")}));
    end Packager;

    block AddBoolean "Add a Boolean vector to package"
      extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerWriteIcon;
      extends
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
      import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
      import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
      parameter Integer n = 1;
      parameter ByteOrder byteOrder = ByteOrder.LE;
      Modelica.Blocks.Interfaces.BooleanInput u[n]
        annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    protected
      Integer u_int[n];
    equation

        pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)
          *8 + n*32 else n*32;

        for i in 1:n loop
          u_int[i] = if (u[i] == true) then 1 else 0;
        end for;
        pkgOut.dummy =
          Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.DummyFunctions.addInteger(
          pkgOut.pkg,
          u_int,
          pkgIn.dummy,
          byteOrder);

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

    block AddInteger "Add an Integer array to package"
      extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerWriteIcon;
      extends
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
      import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
      import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
      parameter Integer n = 1;
      parameter ByteOrder byteOrder = ByteOrder.LE;
      Modelica.Blocks.Interfaces.IntegerInput u[n]
        annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    equation
      pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + n*32 else n*32;

      pkgOut.dummy =
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.DummyFunctions.addInteger(
        pkgOut.pkg,
        u,
        pkgIn.dummy,
        byteOrder);
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
              fillPattern=FillPattern.Solid)}));
    end AddInteger;

    block AddReal "Add a Real vector to package"
      extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerWriteIcon;
      extends
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
      import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
      import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
      parameter Integer n = 1;
      parameter ByteOrder byteOrder = ByteOrder.LE;
      Modelica.Blocks.Interfaces.RealInput u[n]
        annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    equation
      pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + n*64 else n*64;

      pkgOut.dummy =
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.DummyFunctions.addReal(
        pkgOut.pkg,
        u,
        pkgIn.dummy,
        byteOrder);
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
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
      import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
      import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
      parameter Integer n = 1;
      parameter ByteOrder byteOrder = ByteOrder.LE;
      Modelica.Blocks.Interfaces.RealInput u[n]
        annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    equation
      pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + n*32 else n*32;

      pkgOut.dummy =
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.DummyFunctions.addRealAsFloat(
        pkgOut.pkg,
        u,
        pkgIn.dummy,
        byteOrder);
      annotation (Icon(graphics={
            Text(
              extent={{-100,-50},{100,-90}},
              textString="%n * float"),
            Text(
              extent={{-112,40},{-32,-40}},
              lineColor={0,0,255},
              fillPattern=FillPattern.Solid,
              fillColor={0,0,255},
              textString="R"),
            Bitmap(extent={{-42,-22},{18,22}}, fileName=
                  "modelica://Modelica_DeviceDrivers/Resources/Images/Icons/Real2FloatArrow.png")}));
    end AddFloat;

    block AddString "Add String to package"
      extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerWriteIcon;
      extends
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
      import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
      import Modelica.Utilities.Strings.length;
      parameter Integer bufferSize = 40
        "Buffer size (in bytes) reserved for String (ensure that same buffer size is used in corresponding GetString block!)";
      input String data = "A mostly harmless String" annotation(Dialog(enable=true));
    equation
      pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + bufferSize*8 else bufferSize*8;

      pkgOut.dummy =
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.DummyFunctions.addString(
        pkgOut.pkg,
        data,
        bufferSize,
        pkgIn.dummy);

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
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
      import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
      import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
      parameter Integer n = 1;
      parameter ByteOrder byteOrder = ByteOrder.LE;
      Modelica.Blocks.Interfaces.BooleanOutput y[n](each start=false)
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    protected
      Integer y_int[n];
      Real dummy;
    equation
      when Clock() then
         pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary( pkgOut[1].autoPkgBitSize)*8 + n*32 else n*32;

         (y_int,dummy) =
           Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.DummyFunctions.getInteger(
                 pkgIn.pkg,
                 n,
                 pkgIn.dummy,
                 byteOrder);
          pkgOut.dummy = fill(dummy,nu);

          for i in 1:n loop
            y[i] = if    (y_int[i] == 1) then true else false;
          end for;
      end when;

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
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
      import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
      import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
      parameter Integer n = 1;
      parameter ByteOrder byteOrder = ByteOrder.LE;
      Modelica.Blocks.Interfaces.IntegerOutput y[n]
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    protected
      Real dummy;
    equation
      when Clock() then
        pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary( pkgOut[1].autoPkgBitSize)*8 + n*32 else n*32;

       (y,dummy) =
           Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.DummyFunctions.getInteger(
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
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
      import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
      import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
      parameter Integer n = 1;
      parameter ByteOrder byteOrder = ByteOrder.LE;
      Modelica.Blocks.Interfaces.RealOutput y[n]
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    protected
      Real dummy;
    equation
      when Clock() then
         pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + n*64 else n*64;

         (y,dummy) =
            Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.DummyFunctions.getReal(
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
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
      import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
      import Modelica_DeviceDrivers.Utilities.Types.ByteOrder;
      parameter Integer n = 1;
      parameter ByteOrder byteOrder = ByteOrder.LE;
      Modelica.Blocks.Interfaces.RealOutput y[n]
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    protected
      Real dummy;
    equation
      when Clock() then
         pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + n*32 else n*32;

         (y,dummy) =
            Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.DummyFunctions.getRealFromFloat(
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
            Text(
              extent={{-100,-50},{100,-90}},
              textString="%n * float"),
            Bitmap(extent={{-18,-19},{48,20}}, fileName=
                  "modelica://Modelica_DeviceDrivers/Resources/Images/Icons/Float2RealArrow.png")}));
    end GetFloat;

    model GetString "Get String from package"
      extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerReadIcon;
      extends
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
      import Modelica_DeviceDrivers.Packaging.alignAtByteBoundary;
      import Modelica.Utilities.Strings.length;
      parameter Integer bufferSize = 40
        "Buffer size (in bytes) reserved for String (ensure that same buffer size is used in corresponding AddString block!)";
      output String data;
    protected
      Real dummy;
    equation
      when Clock() then
         pkgIn.autoPkgBitSize = if nu == 1 then alignAtByteBoundary(pkgOut[1].autoPkgBitSize)*8 + bufferSize*8 else bufferSize*8;

        (data,dummy) =
            Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.DummyFunctions.getString(
             pkgIn.pkg, bufferSize, pkgIn.dummy);
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

    block PackUnsignedInteger
      "Encode (non-negative) integer value at bit level"
      extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerWriteIcon;
      extends
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
      parameter Integer bitOffset = 0
        "Bit offset from current packager position until first encoding bit";
      parameter Integer width = 32
        "Number of bits that encode the integer value";
      Modelica.Blocks.Interfaces.IntegerInput u(min=0)
        "Only positive (unsigned) values are supported"
        annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    equation
      when Clock() then
         pkgIn.autoPkgBitSize = if nu == 1 then pkgOut[1].autoPkgBitSize + bitOffset + width else bitOffset + width;

         pkgOut.dummy =
            Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.DummyFunctions.integerBitPack(
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
<p>Currently, the pack block only supports Intel-Endiannes (<b>little-endian!</b>).</p>
</html>"));
    end PackUnsignedInteger;

    model UnpackUnsignedInteger "Unpack integer value encoded at bit level"
      extends Modelica_DeviceDrivers.Utilities.Icons.SerialPackagerReadIcon;
      extends
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
      parameter Integer bitOffset = 0
        "Bit offset from current packager position until first encoding bit";
      parameter Integer width = 32
        "Number of bits that encode the integer value";
      Modelica.Blocks.Interfaces.IntegerOutput y(min=0)
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    protected
      Real dummy;
    equation
      when Clock() then
         pkgIn.autoPkgBitSize = if nu == 1 then pkgOut[1].autoPkgBitSize + bitOffset + width else bitOffset + width;

        (y,dummy) =
           Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.DummyFunctions.integerBitUnpack(
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
<p>Currently, the unpack block only supports Intel-Endiannes (<b>little-endian!</b>).</p>
</html>"));
    end UnpackUnsignedInteger;

    block ResetPointer
      "Set current writing/reading position of package to zero"
      extends
        Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.PartialSerialPackager;
    protected
        Real dummy;
    equation
      when Clock() then
         pkgIn.autoPkgBitSize = 0;
         dummy =
           Modelica_DeviceDrivers.ClockedBlocks.Packaging.SerialPackager.Internal.DummyFunctions.resetPointer(
            pkgIn.pkg, pkgIn.dummy);
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
<p>The concept of the SerialPackager is to allow adding/retrieving data to/from a package in a device independent manner. See <a href=\"modelica://Modelica_DeviceDrivers.UsersGuide.GettingStarted\">Getting started</a>.</p>
</html>"));
  end SerialPackager;
end Packaging;
