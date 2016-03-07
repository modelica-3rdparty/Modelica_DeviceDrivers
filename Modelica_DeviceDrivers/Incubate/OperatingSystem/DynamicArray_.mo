within Modelica_DeviceDrivers.Incubate.OperatingSystem;
package DynamicArray_ "Accompanying functions for the DynamicArray object"
    extends Modelica_DeviceDrivers.Utilities.Icons.DriverIcon;
 encapsulated function setMatrix
  import Modelica;
  import Modelica_DeviceDrivers.Incubate.OperatingSystem.DynamicArray;
    input DynamicArray arrayID;
    input Real u[:,:] "data to be stored";
    input Integer index "index, where in memory data has to be stored";
  external"C" MDD_setMatrix(
      arrayID,
      u,
      index);
 end setMatrix;

  encapsulated function getMatrix
    import Modelica;
  import Modelica_DeviceDrivers.Incubate.OperatingSystem.DynamicArray;
    input DynamicArray arrayID;
    input Integer index "index, where in memory data is stored";
    input Integer m "Number of rows of Matrix";
    input Integer n "Number of columns of Matrix";
    output Real u[m,n] "data to be stored";

  external"C" MDD_getMatrix(
      arrayID,
      u,
      index);
  end getMatrix;

  encapsulated function getSize
  import Modelica;
  import Modelica_DeviceDrivers.Incubate.OperatingSystem.DynamicArray;
    input DynamicArray arrayID;
    output Integer maxIndex;
  external"C" maxIndex = MDD_getSize(arrayID);
  end getSize;
end DynamicArray_;
