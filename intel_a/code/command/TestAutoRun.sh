#
if [ "$MkmkOS_NAME" = "Windows_NT" ]; then
  PATH="$PATH;$MkmkSHLIB_PATH"
else
  eval $MkmkSHLIB_NAME=$MkmkSHLIB_PATH
  export $MkmkSHLIB_NAME
  PATH=$PATH:$MkmkSHLIB_PATH
fi

$*
