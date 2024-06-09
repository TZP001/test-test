
# Acces aux modules C++
if [ "$MkmkOS_NAME" = "Windows_NT" ]; then
	PATH="$PATH;$MkcsSHLIB_PATH"
	# Temporaire pour compatibilite mkCheckSourceM
	export MkmkROOT_PATH="$MkcsROOT_PATH;$MkmkROOT_PATH"
else
	export $MkmkSHLIB_NAME=$MkcsSHLIB_PATH
	PATH="$PATH:$MkcsSHLIB_PATH"
	# Temporaire pour compatibilite mkCheckSourceM
	export MkmkROOT_PATH=$MkcsROOT_PATH:$MkmkROOT_PATH
fi


# Lancement
$*

	
