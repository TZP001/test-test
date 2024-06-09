
echo "
### Generation du PluginList.CATRsc"
if not exist %ENOVApplicationPath%\%ENOVFramework%\CNext\resources mkdir %ENOVApplicationPath%\%ENOVFramework%\CNext\resources
if not exist %ENOVApplicationPath%\%ENOVFramework%\CNext\resources\msgcatalog mkdir %ENOVApplicationPath%\%ENOVFramework%\CNext\resources\msgcatalog

echo %ENOVPluginName% = "0"; >> %ENOVApplicationPath%\%ENOVFramework%\CNext\resources\msgcatalog\PluginList.CATRsc

