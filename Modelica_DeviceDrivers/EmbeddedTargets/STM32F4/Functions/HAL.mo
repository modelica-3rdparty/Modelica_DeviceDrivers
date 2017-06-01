within Modelica_DeviceDrivers.EmbeddedTargets.STM32F4.Functions;

package HAL
  extends .Modelica.Icons.Package;

  function GetTick
    extends .Modelica.Icons.Function;
    input HAL.Init hal;
    output Integer tick;
    external "C" tick = MDD_stm32f4_hal_getTick(hal);
    annotation (Include="#include \"MDDSTM32F4HAL.h\"");
  end GetTick;


  
  class Init
    extends ExternalObject;
  function constructor "Initialize HAL"
    extends .Modelica.Icons.Function;
    output HAL.Init hal "Dummy handle (always 0)";
    external "C" hal = MDD_stm32f4_hal_init()
    annotation (Include="#include \"MDDSTM32F4HAL.h\"");
  end constructor;

  function destructor
    extends .Modelica.Icons.Function;
    input HAL.Init hal "Device handle";
    external "C" MDD_stm32f4_hal_close(hal)
    annotation (Include="#include \"MDDSTM32F4HAL.h\"");
  end destructor;
    
  end Init;

end HAL;
