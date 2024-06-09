@if NOT DEFINED _DEBUG_ @echo off
rem ---------------------------------------------------------------------------
set mkcsINSTALL_PATH=
if DEFINED MkmkINSTALL_PATH set mkcsINSTALL_PATH=%MkmkINSTALL_PATH%
set mkcsROOT_PATH=
if DEFINED MkmkROOTINSTALL_PATH set mkcsROOT_PATH=%MkmkROOTINSTALL_PATH%
set mkcsSHLIB_NAME=
if DEFINED MkmkSHLIB_NAME set mkcsSHLIB_NAME=%MkmkSHLIB_NAME%
set mkcsSHLIB_PATH=
if DEFINED MkmkSHLIB_PATH set mkcsSHLIB_PATH=%MkmkSHLIB_PATH%
rem ---------------------------------------------------------------------------
set mkcsOS_NAME=
if DEFINED MkmkOS_NAME set mkcsOS_NAME=%MkmkOS_NAME%
set mkcsOS_Buildtime=
if DEFINED MkmkOS_Buildtime set mkcsOS_Buildtime=%MkmkOS_Buildtime%
set mkcsOS_Runtime=
if DEFINED MkmkOS_Runtime set mkcsOS_Runtime=%MkmkOS_Runtime%
rem ---------------------------------------------------------------------------
set mkcsVERSION=
if DEFINED MkmkVERSION set mkcsVERSION=%MkmkVERSION%
set mkcsbuild=
if DEFINED Mkmkbuild set mkcsbuild=%Mkmkbuild%
rem ---------------------------------------------------------------------------
:end
call set mkcsINSTALL_PATH >NUL
