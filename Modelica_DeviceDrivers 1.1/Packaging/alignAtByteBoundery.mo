within Modelica_DeviceDrivers.Packaging;
function alignAtByteBoundery
  "Returns the minimum number of bytes required to encode the specified number of bits"
  input Integer bitSize;
  output Integer nBytes;
algorithm
  nBytes := div((bitSize + 7), 8);
end alignAtByteBoundery;
