within Modelica_DeviceDrivers.OperatingSystem;
function randomReal "returns a random real within the given Range."
input Real minValue = 0;
input Real maxValue = 1;
output Real y;
external "C" y = OS_getRandomNumberDouble(minValue, maxValue);
annotation (Include = "

#include <stdlib.h>
#include <time.h>
static int _randomGeneratorInitialized = 0;
double OS_getRandomNumberDouble(double minValue, double maxValue)
{
  int randomInteger;
  double randomDouble;
  if(!_randomGeneratorInitialized)
  {
    srand ( clock() * time(NULL) );
    _randomGeneratorInitialized = 1;
  }
  randomInteger = rand();
  randomDouble = ((double)randomInteger/(double)RAND_MAX) * (maxValue - minValue) + minValue;
  return randomDouble;
}



");
end randomReal;
