@echo off
rem # ---------------------------------------------------------
rem # Publish a Customization of an existing enovia application
rem # to database
rem # ---------------------------------------------------------
rem # This script generates librairies, metadata dictionaries
rem # SQL scripts (ddl) and Enovia Settings
rem # ---------------------------------------------------------
rem set NLS_LANG=AMERICAN
goto debut

rem------------------------------------------------------------
:CheckMetadataInDB2 
set isInDB=""
if exist %tmp%\%USERNAME%tmpSQLresult.txt del %tmp%\%USERNAME%tmpSQLresult.txt
if exist %tmp%\%USERNAME%tmpSQLresult2.txt del %tmp%\%USERNAME%tmpSQLresult2.txt

echo select distinct vmetadataname from %ENOTableOwner%.adminid where vmetadataname in ('%1'); >%tmp%\%USERNAME%tmpSQLquery.txt
rem call db2cmd /c /w db2batch -d %ENOVDataBaseAliasName% -s off -q on -f %tmp%\%USERNAME%tmpSQLquery.txt -r %tmp%\%USERNAME%tmpSQLresult.txt
rem add -a %ENOVDBAID%/%ENOVDBAPSSD% for IR A0647896
call db2cmd /c /w db2batch -d %ENOVDataBaseAliasName% -a %ENOVDBAID%/%ENOVDBAPSSD% -s off -q on -f %tmp%\%USERNAME%tmpSQLquery.txt -r %tmp%\%USERNAME%tmpSQLresult.txt

if exist %tmp%\%USERNAME%tmpSQLresult.txt (
	if "%envUnixLike%"=="yes" (
		awk '{print $1}' %tmp%\%USERNAME%tmpSQLresult.txt > %tmp%\%USERNAME%tmpSQLresult2.txt
		FOR /F "usebackq delims==" %%i IN (`type %tmp%\%USERNAME%tmpSQLresult2.txt`) do if "%%i"=="%1" set isInDB="%%i"
	)
	if "%envUnixLike%"=="no" (
		FOR /F "usebackq delims= " %%i IN (`type %tmp%\%USERNAME%tmpSQLresult.txt`) do echo %%i >> %tmp%\%USERNAME%tmpSQLresult2.txt
		if exist %tmp%\%USERNAME%tmpSQLresult2.txt (
			FOR /F "usebackq delims==" %%i IN (`type %tmp%\%USERNAME%tmpSQLresult2.txt`) do if "%%i"=="%1"  set isInDB="%%i"
			FOR /F "usebackq delims==" %%i IN (`type %tmp%\%USERNAME%tmpSQLresult2.txt`) do if "%%i"=="%1 " set isInDB="%1"
		)
	)
)

if "%TRACEFORLWTVAR%"=="yes" (
	echo ============== search for %1 in database ============== >> %TRACEFORLWTFILE%
	if %isInDB% NEQ "%1" echo Test DB2: %1 was not found in database >> %TRACEFORLWTFILE%
	if %isInDB%=="%1" echo Test DB2: %1 is in database >> %TRACEFORLWTFILE%
	echo The command launched was: call db2cmd /c /w db2batch -d %ENOVDataBaseAliasName% -a %ENOVDBAID%/%ENOVDBAPSSD% -s off -q on -f %tmp%\%USERNAME%tmpSQLquery.txt -r %tmp%\%USERNAME%tmpSQLresult.txt >> %TRACEFORLWTFILE%
	echo The input file %tmp%\%USERNAME%tmpSQLquery.txt contains: >> %TRACEFORLWTFILE%
	if exist %tmp%\%USERNAME%tmpSQLquery.txt cat %tmp%\%USERNAME%tmpSQLquery.txt >> %TRACEFORLWTFILE%
	echo The result file %tmp%\%USERNAME%tmpSQLresult.txt >> %TRACEFORLWTFILE%
	if exist %tmp%\%USERNAME%tmpSQLresult.txt cat %tmp%\%USERNAME%tmpSQLresult.txt >> %TRACEFORLWTFILE%	
	echo The filtered result file %tmp%\%USERNAME%tmpSQLresult2.txt where name %1 is searched >> %TRACEFORLWTFILE%
	if exist %tmp%\%USERNAME%tmpSQLresult2.txt cat %tmp%\%USERNAME%tmpSQLresult2.txt >> %TRACEFORLWTFILE%	
)

rem echo %isInDB%
if exist %tmp%\%USERNAME%tmpSQLresult2.txt del %tmp%\%USERNAME%tmpSQLresult2.txt
if exist %tmp%\%USERNAME%tmpSQLresult.txt del %tmp%\%USERNAME%tmpSQLresult.txt
if exist %tmp%\%USERNAME%tmpSQLquery.txt del %tmp%\%USERNAME%tmpSQLquery.txt

goto :EOF

:CheckMetadataInOracle 
set isInDB=""
if exist %tmp%\%USERNAME%tmpSQLresult.txt del %tmp%\%USERNAME%tmpSQLresult.txt

echo select distinct vmetadataname from %ENOTableOwner%.adminid where vmetadataname in ('%1'); >%tmp%\%USERNAME%tmpSQLquery.txt
echo quit; >> %tmp%\%USERNAME%tmpSQLquery.txt
call sqlplus %ENOVDBAID%/%ENOVDBAPSSD%@%ENOVDataBaseAliasName% @%tmp%\%USERNAME%tmpSQLquery.txt > %tmp%\%USERNAME%tmpSQLresult.txt 

if exist %tmp%\%USERNAME%tmpSQLresult.txt (
	call "%VBTRADELibs%\code\bin\CATVBTSQLErrorGrepM.exe" "%tmp%\%USERNAME%tmpSQLresult.txt" "no rows selected"
	if %ERRORLEVEL%==0 set isInDB="%1"
	if %ERRORLEVEL%==1 set isInDB=""
)

if "%TRACEFORLWTVAR%"=="yes" (
	echo ============== search for %1 in database ============== >> %TRACEFORLWTFILE%
	if %isInDB% NEQ "%1" echo Test Oracle: %1 was not found in database >> %TRACEFORLWTFILE%
	if %isInDB%=="%1" echo Test Oracle: %1 is in database >> %TRACEFORLWTFILE%
	echo The command launched was: sqlplus %ENOVDBAID%/%ENOVDBAPSSD%@%ENOVDataBaseAliasName% @%tmp%\%USERNAME%tmpSQLquery.txt >> %TRACEFORLWTFILE%
	echo The input file %tmp%\%USERNAME%tmpSQLquery.txt contains: >> %TRACEFORLWTFILE%
	if exist %tmp%\%USERNAME%tmpSQLquery.txt cat %tmp%\%USERNAME%tmpSQLquery.txt >> %TRACEFORLWTFILE%
	echo The result file %tmp%\%USERNAME%tmpSQLresult.txt where "no rows selected" is searched >> %TRACEFORLWTFILE%
	if exist %tmp%\%USERNAME%tmpSQLresult.txt cat %tmp%\%USERNAME%tmpSQLresult.txt >> %TRACEFORLWTFILE%	
)

if exist %tmp%\%USERNAME%tmpSQLresult.txt del %tmp%\%USERNAME%tmpSQLresult.txt
if exist %tmp%\%USERNAME%tmpSQLquery.txt del %tmp%\%USERNAME%tmpSQLquery.txt

goto :EOF

rem------------------------------------------------------------
:executeSafe
	call %* > %TEMP%\ExecuteSafe.tmp 2>&1
	IF %ERRORLEVEL% NEQ 0 goto errorExecuteSafe
	IF NOT "%DEBUG%" NEQ "YES" goto debugExecuteSafe
	goto :EOF

:errorExecuteSafe
	type %TEMP%\ExecuteSafe.tmp
	del %TEMP%\ExecuteSafe.tmp
	set return=FAIL
	goto :EOF

:debugExecuteSafe
	type %TEMP%\ExecuteSafe.tmp
	del %TEMP%\ExecuteSafe.tmp
	goto :EOF

rem -----------------------------------------------------------
:PATHUpdate
	if %1=="" goto :EOF
	if 	DEFINED newpath set newpath=%newpath%;%1
	if 	DEFINED newpath goto :EOF
	if NOT DEFINED newpath set newpath=%1
	goto :EOF

rem -----------------------------------------------------------
:REFPATHUpdate
	if %1=="" goto :EOF
	if 	DEFINED reffilespath set reffilespath=%reffilespath%;%1
	if 	DEFINED reffilespath goto :EOF
	if NOT DEFINED reffilespath set reffilespath=%1
	goto :EOF

rem -----------------------------------------------------------
:DICPATHUpdate
	if %1=="" goto :EOF
	if 	DEFINED dictionarypath set dictionarypath=%dictionarypath%;%1
	if 	DEFINED dictionarypath goto :EOF
	if NOT DEFINED dictionarypath set dictionarypath=%1
	goto :EOF

rem -----------------------------------------------------------
:SPLPATHUpdate
	if %1=="" goto :EOF
	if     DEFINED splitpath set splitpath=%splitpath%;%1
	if     DEFINED splitpath goto :EOF
	if NOT DEFINED splitpath set splitpath=%1
	goto :EOF

rem -----------------------------------------------------------
:DDLPATHUpdate
	if %1=="" goto :EOF
	if     DEFINED ddlpath set ddlpath=%ddlpath%;%1
	if     DEFINED ddlpath goto :EOF
	if NOT DEFINED ddlpath set ddlpath=%1
	goto :EOF

rem -----------------------------------------------------------
:checkDB2
	set DDLExt=clp
	if not exist %ENOVDB2_HOME%\sqllib goto NoDB2
	goto :EOF

rem -----------------------------------------------------------
:checkPeopleSingle
	call %1
	IF "%CATVBTUseNames%"=="PEOPLE" set CUSTOPEOPLE=YES
	echo set ENOVDBAID=%ENOVDBAID%> %ENOVApplicationPath%/CAAPeopleVariables.bat
	echo set ENOVDataBaseType=%ENOVDataBaseType%>> %ENOVApplicationPath%/CAAPeopleVariables.bat
	echo set ENOVORACLE_HOME=%ENOVORACLE_HOME%>> %ENOVApplicationPath%/CAAPeopleVariables.bat
	echo set ENOVDB2_HOME=%ENOVDB2_HOME%>> %ENOVApplicationPath%/CAAPeopleVariables.bat
	echo set ENOVDataBaseAliasName=%ENOVDataBaseAliasName% >> %ENOVApplicationPath%/CAAPeopleVariables.bat
	echo set ENOVTableSpaceName=%m_tbl%>> %ENOVApplicationPath%/CAAPeopleVariables.bat
	echo set ENOVSavePath=\tmp>> %ENOVApplicationPath%/CAAPeopleVariables.bat
	echo set ENOVApplicationPath=%ENOVApplicationPath%>> %ENOVApplicationPath%/CAAPeopleVariables.bat
	echo set CATVBTMetadataName=%CATVBTMetadataName%>> %ENOVApplicationPath%/CAAPeopleVariables.bat
	GOTO :EOF

rem -----------------------------------------------------------
:checkPeopleALL
	cd %ENOVApplicationPath%
	for /F %%i in ( 'dir *.CustomEnv.bat /b' ) do (
		call :checkPeopleSingle %%i
	)
	GOTO :EOF

rem -----------------------------------------------------------
rem ---------------------- generateDDL ------------------------
rem -----------------------------------------------------------
:generateDDL
	set CATDictionaryPath=%dictionarypath%
	
  	rem set METATOOLS_TRACE=1
	cd %ENOVApplicationPath%

	REM on se place dans le repertoire contenant les CustomEnv
	cd %ENOVApplicationPath%
	REM boucler sur le *.CustomEnv.bat (* est le nom de chaque metadata)
	for /F %%i in ( 'dir *.CustomEnv.bat /b') do (
		call :ENOMetaDiffLoop %%i
	) 
	REM end boucle *.CustomEnv.bat

	cd %ENOVApplicationPath%
	REM boucler sur le *.CustomEnv.bat
	for /F %%i in ( 'dir *.CustomEnv.bat /b') do (
		call :ENODDLGeneLoop %%i
	) 
	GOTO :EOF

:ENOMetaDiffLoop
	REM	on lance le .bat courrant pour positionnrer: CATVBTListOfMetadata et CATVBTMetadataName
	
	cd %ENOVApplicationPath%
	call %1 
	IF NOT EXIST "%ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl" mkdir %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl
	cd intel_a\code\dictionary
	
	REM	s'il exite un .off du metadata *,on construit les metadiff en appellant ENOMetadiffTool
	IF EXIST %CATVBTMetadataName%.metadata.off call ENOMetaDiffTool.exe -Old %CATVBTMetadataName%.metadata.off -New %CATVBTMetadataName%.metadata -Diff %CATVBTMetadataName%.metadiff
	REM	sinon on construit les metadiff en appellant ENOMetadiffTool avec d'autres parametres
    if NOT EXIST %CATVBTMetadataName%.metadata.off call ENOMetaDiffTool.exe -New %CATVBTMetadataName%.metadata -Diff %CATVBTMetadataName%.metadiff
	
	if "%TRACEFORLWTVAR%"=="yes" (
		echo ============== generate metadiff for %1  ============== >> %TRACEFORLWTFILE%
		IF EXIST %CATVBTMetadataName%.metadata.off echo %CATVBTMetadataName%.metadata.off exist >> %TRACEFORLWTFILE%
		IF NOT EXIST %CATVBTMetadataName%.metadata.off echo %CATVBTMetadataName%.metadata.off does not exist >> %TRACEFORLWTFILE%
		echo metadiff is the following >> %TRACEFORLWTFILE%
		if exist %CATVBTMetadataName%.metadiff  cat %CATVBTMetadataName%.metadiff >> %TRACEFORLWTFILE%
	)
	
	GOTO :EOF

:ENODDLGeneLoop     
	REM remise a zero de la liste des metadiff pour enoDDL
	set CATVBTNewMetaDiff=
	REM remise a zero de la liste des metadata pour enoDDL
	set CATVBTNewMetaList=
	REM remise a zero de la liste des metaddiff a renommer pour enoDDL  
	set MetaDiffListToRename=

	REM	on lance le .bat courrant pour positionnrer: CATVBTListOfMetadata et CATVBTMetadataName
	cd %ENOVApplicationPath%
	set CATVBTListOfMetadata=
	call %1
	cd intel_a\code\dictionary
	REM	recuperer la variable CATVBTListOFMetaData
	REM	on la tokenize sur space
	set CATVBTListOFMetadata=%CATVBTListOFMetadata% %CATVBTMetadataName%.metadata
	FOR /F "usebackq delims==" %%i IN (`call CATVBTCut.exe -d " " "%CATVBTListOFMetadata%"`) do call :UpdateEnoDDLGeneratorArgument %%i
    REM	end pour chaque token
	REM	s'il exite un .off du metadata *
	rem echo CATVBTNewMetaDiff=%CATVBTNewMetaDiff%	
	rem echo CATVBTNewMetaList=%CATVBTNewMetaList%	
	rem echo MetaDiffListToRename=%MetaDiffListToRename%
	
	if "%TRACEFORLWTVAR%"=="yes" (
		IF NOT EXIST %CATVBTMetadataName%.metadiff echo  ============== no generate ddl for %1 because %CATVBTMetadataName%.metadiff does not exist  ============== >> %TRACEFORLWTFILE%
	)

	if NOT EXIST %CATVBTMetadataName%.metadiff goto :EOF

	echo    ### Work on %CATVBTMetadataName%.metadata

	rem on efface les ordres precedent
	del /Q %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\*.*
    rem echo CATVBTNewMetaDiff = %CATVBTNewMetaDiff%
	rem echo CATVBTNewMetaList=%CATVBTNewMetaList%
	
	if "%CATVBTNewMetaList%"=="" set Metadata=
	if "%CATVBTNewMetaList%" NEQ "" set Metadata=-Metadata %CATVBTNewMetaList%

	rem echo call ENODDLGeneratorTool.exe -Diff %CATVBTNewMetaDiff% -MetadataPath %dictionarypath% %Metadata% -DBVendor %ENOVDataBaseType% -DBServerName %ENOVDataBaseAliasName% -DBUser %ENOVDBAID% -DBPwd %ENOVDBAPSSD% -DBTablesOwner %ENOTableOwner% -TbsName %ENOVTableSpace% -IdxTbsName %ENOVTableSpace% -TablesOwner %ENOTableOwner% -SplitFile %ENOVApplicationPath%\%MkmkOS_VAR%\reffiles\DBMS\Generator\TmpSplitFile%CATVBTMetadataName%.param -OutputFile %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%CATVBTMetadataName%.%DDLExt%
  	rem set METATOOLS_TRACE=4

	call ENODDLGeneratorTool.exe -Diff %CATVBTNewMetaDiff% -MetadataPath %dictionarypath% %Metadata% -DBVendor %ENOVDataBaseType% -DBServerName %ENOVDataBaseAliasName% -DBUser %ENOVDBAID% -DBPwd %ENOVDBAPSSD% -DBTablesOwner %ENOTableOwner% -TbsName %ENOVTableSpace% -IdxTbsName %ENOVTableSpace% -TablesOwner %ENOTableOwner% -SplitFile %ENOVApplicationPath%\%MkmkOS_VAR%\reffiles\DBMS\Generator\TmpSplitFile%CATVBTMetadataName%.param -OutputFile %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%CATVBTMetadataName%.%DDLExt% >%ENOVApplicationPath%\ToolsData\RADE\TmpTraceEnoDDLGeneratorTool.txt 2>&1

	REM	on renomme les metadiff de la liste a renommer
	FOR /F "usebackq delims==" %%i IN (`call "CATVBTCut.exe" -d " " "%MetaDiffListToRename%"`) do (
			IF NOT "%CATVBTMetadataName%.metadiff" == "%%i" if exist %%i rename %%i %%i.save
	)
	
 	if "%TRACEFORLWTVAR%"=="yes" (
		echo ============== generate ddl for %1  ============== >> %TRACEFORLWTFILE%
		echo %CATVBTMetadataName%.metadiff exists >> %TRACEFORLWTFILE%
		echo Command launched is: call ENODDLGeneratorTool.exe -Diff %CATVBTNewMetaDiff% -MetadataPath %dictionarypath% %Metadata% -DBVendor %ENOVDataBaseType% -DBServerName %ENOVDataBaseAliasName% -DBUser %ENOVDBAID% -DBPwd %ENOVDBAPSSD% -DBTablesOwner %ENOTableOwner% -TbsName %ENOVTableSpace% -IdxTbsName %ENOVTableSpace% -TablesOwner %ENOTableOwner% -SplitFile %ENOVApplicationPath%\%MkmkOS_VAR%\reffiles\DBMS\Generator\TmpSplitFile%CATVBTMetadataName%.param -OutputFile %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%CATVBTMetadataName%.%DDLExt% >> %TRACEFORLWTFILE%
		echo Let check files: %ENOVApplicationPath%\%MkmkOS_VAR%\reffiles\DBMS\Generator\TmpSplitFile%CATVBTMetadataName%.param %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%CATVBTMetadataName%.%DDLExt% >> %TRACEFORLWTFILE%
	)

	REM on reset les variables CATVBTNewMetaDiff, CATVBTNewMetaList et MetaDiffListToRename
	set CATVBTNewMetaDiff=
	set CATVBTNewMetaList=
	set MetaDiffListToRename=
	
	GOTO :EOF

:UpdateEnoDDLGeneratorArgument
	REM on recupere le nom du metadata sans extension
	rem echo UpdateEnoDDLGeneratorArgument
	FOR /F "usebackq delims==" %%i IN (`call "CATVBTCut.exe" -f "0" -d "." "%1"`) do set MetaDataBaseName=%%i

	REM	on regarde si il existe une version du metadata en base
	rem echo %MetaDataBaseName%
	if "%ENOVDataBaseType%"=="ORACLE"	call :CheckMetadataInORACLE %MetaDataBaseName%
	if "%ENOVDataBaseType%"=="DB2" call :CheckMetadataInDB2 %MetaDataBaseName%
	rem echo %isInDB% NEQ "%MetaDataBaseName%" 
	IF %isInDB% NEQ "%MetaDataBaseName%" GOTO :metadataNotInDB


:metadataInDB
	
	REM on concatenne le nom du metadata (avec extension .metadata) a la liste de l'option -metadata
	if exist %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\code\dictionary\%MetaDataBaseName%.metadata.off set CATVBTNewMetaList=%CATVBTNewMetaList% %MetaDataBaseName%.metadata.off
	if not exist %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\code\dictionary\%MetaDataBaseName%.metadata.off set CATVBTNewMetaList=%CATVBTNewMetaList% %MetaDataBaseName%.metadata
	IF EXIST %ENOVApplicationPath%\%MkmkOS_VAR%\code\dictionary\%MetaDataBaseName%.metadiff GOTO :metadataNotInDB
	goto :EOF

REM	si non =>  
:metadataNotInDB

	REM	on concatenne le nom du metadata (avec extension .metadiff) a la liste de l'option -metadiff
	set CATVBTNewMetaDiff=%CATVBTNewMetaDiff% %MetaDataBaseName%.metadiff

	REM	on concatenne le fichier de split associe au fichier de split temp que l'on va passe a enoDDLGene
	if exist %ENOVApplicationPath%\%MkmkOS_VAR%\reffiles\DBMS\Generator\%MetaDataBaseName%.param FOR /F "usebackq delims= " %%i IN (`type %ENOVApplicationPath%\%MkmkOS_VAR%\reffiles\DBMS\Generator\%MetaDataBaseName%.param`)do echo %%i >> %ENOVApplicationPath%\%MkmkOS_VAR%\reffiles\DBMS\Generator\TmpSplitFile%CATVBTMetadataName%.param
	rem awk '{ print $1 }' %ENOVApplicationPath%\%MkmkOS_VAR%\reffiles\DBMS\Generator\%MetaDataBaseName%.param >> %ENOVApplicationPath%\%MkmkOS_VAR%\reffiles\DBMS\Generator\TmpSplitFile%CATVBTMetadataName%.param
	
	
	REM	on ajoute le metadiff a la liste des metadiff a renommer
	set MetaDiffListToRename=%MetaDiffListToRename% %MetaDataBaseName%.metadiff
	goto :EOF
REM retour de la fonction



rem -----------------------------------------------------------
rem ---------------- updateDB2DataBase ------------------------
rem -----------------------------------------------------------

:updateDB2DataBase
	echo ## Update DB2 Data Base	
	if "%ENOVDataBaseType%"=="DB2" set LD_LIBRARY_PATH=%ENOVDB2_HOME%\sqllib\lib;%LD_LIBRARY_PATH%
	cd %ENOVApplicationPath%
	
	rem ## On boucle sur les metadata en R11
	cd %ENOVApplicationPath%
	for /F %%i in ( 'dir *.CustomEnv.bat /b') do (
		call :updateDB2DataBaseSingle %%i
		if %return% NEQ SUCCESS goto :EOF
	)
	GOTO :EOF

rem -----------------------------------------------------------
rem ----------------------- updateDB2DataBaseSingle -----------
rem -----------------------------------------------------------
:updateDB2DataBaseSingle
	echo ## UpdateDataBaseSingle : %1
	call %1
	IF NOT EXIST %ENOVApplicationPath%\intel_a\code\dictionary\%CATVBTMetadataName%.metadiff call :executeSafe copy %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\code\dictionary\%CATVBTMetadataName%.metadata %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\code\dictionary\%CATVBTMetadataName%.metadata.off
	IF EXIST %ENOVApplicationPath%\intel_a\code\dictionary\%CATVBTMetadataName%.metadiff goto :existMetaDiff
	goto :EOF

:existMetaDiff			
 	 rem on utilise la routine CATVBTPlaySQLOrders pour supprimer le probleme avec db2batch.
 	 rem En effet, celui ci ne semble accepter que 533 ordres au maximum
 	 rem ce qui peut etre depasse lors de customization de classes d'un meme arbre
 	if "%TRACEFORLWTVAR%"=="yes" (
		echo ============== execute db2 ddl for %CATVBTMetadataName%  ============== >> %TRACEFORLWTFILE%
		echo Launching %CATVBTMetadataName% ... >> %TRACEFORLWTFILE%
	)

    echo   ## Update tables in Database for %CATVBTMetadataName%
    call  :PlayDb2SQLOrders %CATVBTMetadataName%
        
	if "%TRACEFORLWTVAR%"=="yes" (
		echo Launching insert_%CATVBTMetadataName% ... >> %TRACEFORLWTFILE%
	)

 	echo   ## Inserting tables in Database for %CATVBTMetadataName%
    call  :PlayDb2SQLOrders insert_%CATVBTMetadataName%
        
	if "%TRACEFORLWTVAR%"=="yes" (
		echo Launching changePrivilege and grant_%CATVBTMetadataName% ... >> %TRACEFORLWTFILE%
	)

	echo   ## Granting tables in Database for %CATVBTMetadataName%
	
	rem 02/05/2009 For IR change privilege PUBLIC to VPLMAdmin
	call  :ChangePrivilege %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\grant_%CATVBTMetadataName%.%DDLExt% 
	
	call  :PlayDb2SQLOrders grant_%CATVBTMetadataName%
	
	call :executeSafe copy %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\code\dictionary\%CATVBTMetadataName%.metadata %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\code\dictionary\%CATVBTMetadataName%.metadata.off
	call :executeSafe move %ENOVApplicationPath%\intel_a\code\dictionary\%CATVBTMetadataName%.metadiff %ENOVApplicationPath%\intel_a\code\dictionary\%CATVBTMetadataName%.metadiff.save

	goto :EOF

:PlayDb2SQLOrders
    set TMP_SQL_FILE=%ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\tmp_%1.%DDLExt%
    set TMP_SQL_FILE_TRACE=%ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\tmp_%1_trace.txt
    set TMP_SQL_FILE_ANALYSE=%ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\tmp_%1_analyse.txt

    if exist %TMP_SQL_FILE_TRACE%  del /Q %TMP_SQL_FILE_TRACE%

    rem echo  connect to %ENOVDataBaseAliasName%; >%TMP_SQL_FILE%
	if not exist %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%1.%DDLExt% echo Wng: No file %1.%DDLExt% generated
    if exist %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%1.%DDLExt% type %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%1.%DDLExt% >> %TMP_SQL_FILE%
    rem echo  terminate; >>%TMP_SQL_FILE%

    rem call db2cmd /c /w db2 –tf %TMP_SQL_FILE% -l %TMP_SQL_FILE_TRACE% -s
    call db2cmd /c /w "ExecuteSqlFile.exe -u %ENOVDBAID% -p %ENOVDBAPSSD% -d %ENOVDataBaseAliasName% -v db2 -f %TMP_SQL_FILE% -t >%TMP_SQL_FILE_TRACE% 2>&1"
    call "%VBTRADELibs%\code\bin\CATVBTGrep.exe" "%TMP_SQL_FILE_TRACE%" "%TMP_SQL_FILE_ANALYSE%" "-v" "DB20000I" "-m" "SQL" "-c"
    if %ERRORLEVEL% NEQ 0 goto :fatalErrorUpdatedb2Single
        
 	if "%TRACEFORLWTVAR%"=="yes" (
		echo %1.%DDLExt% has been launched and was ok >> %TRACEFORLWTFILE%
	)

    if exist %TMP_SQL_FILE%  del /Q %TMP_SQL_FILE%
    if exist %TMP_SQL_FILE_ANALYSE%  del /Q %TMP_SQL_FILE_ANALYSE%
	goto :EOF


:fatalErrorUpdateDB2Single
	echo  Update DB2 fatal error
    set return=FAIL
	goto :KO
	goto :EOF

:fatalErrorUpdateORACLESingle
	echo  Update Oracle error
	type %1
    set return=FAIL
	goto :KO
	goto :EOF

rem -----------------------------------------------------------
rem ------------------ updateOracleDataBaseSingle -------------
rem -----------------------------------------------------------
:updateOracleDataBaseSingle
	call %1
	echo ## UpdateDataBaseSingle : %CATVBTMetadataName%
	IF NOT EXIST %ENOVApplicationPath%\intel_a\code\dictionary\%CATVBTMetadataName%.metadiff call :executeSafe copy %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\code\dictionary\%CATVBTMetadataName%.metadata %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\code\dictionary\%CATVBTMetadataName%.metadata.off
	IF EXIST %ENOVApplicationPath%\intel_a\code\dictionary\%CATVBTMetadataName%.metadiff goto :existMetaDiffORACLE
	goto :EOF

:existMetaDiffORACLE

	if "%TRACEFORLWTVAR%"=="yes" (
		echo ============== execute oracle ddl for %CATVBTMetadataName%  ============== >> %TRACEFORLWTFILE%
	)

	echo set feedback on> %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql
   	echo spool %ENOVApplicationPath%\ToolsData\RADE\%CATVBTMetadataName%.trace >> %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql
	type %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%CATVBTMetadataName%.%DDLExt% >> %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql
    echo spool off >> %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql
	echo quit >> %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql	

	if "%TRACEFORLWTVAR%"=="yes" (
		echo Launching %CATVBTMetadataName%.%DDLExt% with following sql script >> %TRACEFORLWTFILE%
		if exist %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql cat %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql  >> %TRACEFORLWTFILE%
	)

	sqlplus %ENOVDBAID%/%ENOVDBAPSSD%@%ENOVDataBaseAliasName% @%ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql > %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%USERNAME%%CATVBTMetadataName%.trace1
	call "%VBTRADELibs%\code\bin\CATVBTSQLErrorGrepM.exe" "%ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%USERNAME%%CATVBTMetadataName%.trace1" "ERROR"
	if %ERRORLEVEL% NEQ 0 call :fatalErrorUpdateORACLESingle "%ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%USERNAME%%CATVBTMetadataName%.trace1"

	echo set feedback on> %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql
    echo spool %ENOVApplicationPath%\ToolsData\RADE\insert_%CATVBTMetadataName%.trace >> %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql
	type %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\insert_%CATVBTMetadataName%.%DDLExt% >> %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql
    echo spool off >> %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql
	echo quit >> %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql
	
	if "%TRACEFORLWTVAR%"=="yes" (
		echo Launching insert_%CATVBTMetadataName%.%DDLExt% with following sql script >> %TRACEFORLWTFILE%
		if exist %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql cat %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql  >> %TRACEFORLWTFILE%
	)

	sqlplus %ENOVDBAID%/%ENOVDBAPSSD%@%ENOVDataBaseAliasName% @%ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql > %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%USERNAME%%CATVBTMetadataName%.trace2
	rem C:\WINDOWS\system32\find.exe "ERROR" %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%USERNAME%%CATVBTMetadataName%.trace2 > %tmp%\%USERNAME%tmp
	call "%VBTRADELibs%\code\bin\CATVBTSQLErrorGrepM.exe" "%ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%USERNAME%%CATVBTMetadataName%.trace2" "ERROR"
	if %ERRORLEVEL% NEQ 0 call :fatalErrorUpdateORACLESingle "%ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%USERNAME%%CATVBTMetadataName%.trace2"

	echo set feedback on> %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql
	echo spool  %ENOVApplicationPath%\ToolsData\RADE\grant_%CATVBTMetadataName%.trace >> %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql

	rem no change privilege on oracle
	rem call :ChangePrivilege %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\grant_%CATVBTMetadataName%.%DDLExt% 
	
	type %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\grant_%CATVBTMetadataName%.%DDLExt% >> %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql
	echo spool off >> %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql
	echo quit  >> %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql
	
	if "%TRACEFORLWTVAR%"=="yes" (
		rem echo changePrivilege has been launched
		echo Launching grant_%CATVBTMetadataName%.%DDLExt% with following sql script >> %TRACEFORLWTFILE%
		if exist %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql cat %ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql  >> %TRACEFORLWTFILE%
	)

	sqlplus %ENOVDBAID%/%ENOVDBAPSSD%@%ENOVDataBaseAliasName% @%ENOVApplicationPath%\ToolsData\RADE\Tmp%CATVBTMetadataName%.sql > %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%USERNAME%%CATVBTMetadataName%.trace3
	call "%VBTRADELibs%\code\bin\CATVBTSQLErrorGrepM.exe" "%ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%USERNAME%%CATVBTMetadataName%.trace3" "ERROR"
	if %ERRORLEVEL% NEQ 0 call :fatalErrorUpdateORACLESingle "%ENOVApplicationPath%\%CATVBTMetadataName%\CNext\reffiles\DBMS\ddl\%USERNAME%%CATVBTMetadataName%.trace3"

	copy %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\code\dictionary\%CATVBTMetadataName%.metadata %ENOVApplicationPath%\%CATVBTMetadataName%\CNext\code\dictionary\%CATVBTMetadataName%.metadata.off
	move %ENOVApplicationPath%\intel_a\code\dictionary\%CATVBTMetadataName%.metadiff %ENOVApplicationPath%\intel_a\code\dictionary\%CATVBTMetadataName%.metadiff.save
	goto :EOF

:ChangePrivilege
	if not exist %1 goto :EOF

	if "%envUnixLike%"=="yes" (
		sed "s, TO PUBLIC , TO %USERNAME% ,g" %1 > %1.chgPriv
	)

	if "%envUnixLike%"=="no" (
		call "%VBTRADELibs%\code\bin\CATVBTSed.exe" %1  %1.chgPriv "-s" " TO PUBLIC " "-n" " TO %USERNAME% " "-a"
	)
	
	mv %1.chgPriv %1
	goto :EOF
	
rem -----------------------------------------------------------
rem ------------------ updateOracleDataBase -------------------
rem -----------------------------------------------------------
:updateOracleDataBase

	set PATH=%PATH%;%ENOVORACLE_HOME%\bin
	set ORACLE_HOME=%ENOVORACLE_HOME%

 	rem ------------------------------------------------------------------
	rem echo set feedback on> %ENOVApplicationPath%\ToolsData\RADE\TmpFile0.sql
    rem echo spool %ENOVApplicationPath%\ToolsData\RADE\Connect.trace >> %ENOVApplicationPath%\ToolsData\RADE\TmpFile0.sql
    rem echo create user %m_USER% identified externally  >> %ENOVApplicationPath%\ToolsData\RADE\TmpFile0.sql
	rem echo grant connect,resource to %m_USER% ; >> %ENOVApplicationPath%\ToolsData\RADE\TmpFile0.sql
	rem echo alter user %m_USER% quota unlimited on %ENOVTableSpace% ;  >> %ENOVApplicationPath%\ToolsData\RADE\TmpFile0.sql
    rem echo spool off >> %ENOVApplicationPath%\ToolsData\RADE\TmpFile0.sql
	rem echo quit;  >> %ENOVApplicationPath%\ToolsData\RADE\TmpFile0.sql	
	rem sqlplus %ENOVDBAID%/%ENOVDBAPSSD%@%ENOVDataBaseAliasName% @%ENOVApplicationPath%\ToolsData\RADE\TmpFile0.sql > %ENOVApplicationPath%\ToolsData\RADE\TmpFile.txt

	rem ## On boucle sur les metadata en R11 
	cd %ENOVApplicationPath%
	for /F %%i in ( 'dir *.CustomEnv.bat /b' ) do (
		call :updateOracleDataBaseSingle %%i
		IF %return% NEQ SUCCESS goto :EOF
	)
	goto :EOF


rem -----------------------------------------------------------
:debut
	set return=SUCCESS
	set TMPNEWSETCATENV=yes
	set m_USER=%USERNAME%
	set USER=%ENOVDBAID%
	set LOGNAME=%ENOVDBAID%
	set DBAuthentication="system"
	set CATReferenceSettingPath=
	set Concatenation=""
	set ConcatenationOff=""
	echo ## EAA Publish Script
	echo ## Application Path   : %ENOVApplicationPath%
	echo ## User               : %m_USER%
	echo ## ENOVIA Level       : %ENOVIALevel%
	
	rem test env mksnt or not
	set envUnixLike=no
	set TRACEFORLWTFILE=%tmp%\traceForLWT.txt
	set TRACEFORLWTVAR=yes
	
	if "%ENOVDBAID%"=="" goto NoAdmin
	if "%CATSettingPath%"=="" goto NoSettings
	if not exist "%CATSettingPath%" goto NoSettings
	
	rem ----------------------------------------------------------
	rem #Gestion du type de database 
	rem ----------------------------------------------------------
	if "%ENOVDataBaseType%"=="oracle" (
		set DDLExt=sql
		set ENOVDataBaseType=ORACLE
		if not exist "%ENOVORACLE_HOME%" goto NoORACLE
	)
	if "%ENOVDataBaseType%"=="db2" (
		set DDLExt=clp
		set ENOVDataBaseType=DB2
		if not exist "%ENOVDB2_HOME%\SQLLIB" goto NoDB2
	)
	if not defined DDLExt goto NoDatabase
	if not exist %ENOVApplicationPath% goto NoApplicationPath
	if "%ENOVDataBaseAliasName%"=="" goto NoDataBaseAlias

	rem ----------------------------------------------------------
	rem #Gestion du niveau de LCA 
	rem ----------------------------------------------------------
	if "%ENOVIALevel%"=="" goto NoENOVIALevel

	rem ----------------------------------------------------------
	rem #Gestion de l'OS 
	rem ----------------------------------------------------------
	if not defined MkmkOS_VAR goto NoEAATools

	rem ----------------------------------------------------------
	rem # Nom des tablespaces 
	rem ----------------------------------------------------------
	if "%ENOVTableSpace%"=="" goto NoTBS 
	set m_tbl=%ENOVTableSpace%

	rem ----------------------------------------------------------
	rem # Gestion du Password
	rem ----------------------------------------------------------
	if "%ENOVDBAPSSD%"=="" goto NoAdminPssd

	rem ----------------------------------------------------------
	rem # Traces
	rem ----------------------------------------------------------
	if "%TRACEFORLWTVAR%"=="yes" (
		echo ============== Let start ============== > %TRACEFORLWTFILE%
		echo Script has been launched with following env >> %TRACEFORLWTFILE%
		set >> %TRACEFORLWTFILE%	
	)
	
	rem ----------------------------------------------------------
	rem set variables à partir de la runtime view
	rem ----------------------------------------------------------
	set addtovar=
	set dictionarypath=
	set splitpath=
	set reffilespath=
	set ddlpath=
	echo ## Read Workspace Configuration
	for /F "delims=*" %%i in ('mkGetPreq -W %ENOVApplicationPath%') do (
	 	echo 		%%i  
 		call :PATHUpdate    "%%i\%MkmkOS_VAR%\code\bin"
		call :PATHUpdate    "%%i\%MkmkOS_VAR%\code\command"
 		call :DICPATHUpdate "%%i\%MkmkOS_VAR%\code\dictionary"
 		call :REFPATHUpdate "%%i\%MkmkOS_VAR%\reffiles"
 		call :SPLPATHUpdate "%%i\%MkmkOS_VAR%\reffiles\DBMS\Generator"
		call :DDLPATHUpdate "%%i\%MkmkOS_VAR%\reffiles\DBMS\ddl"
	)

	if "%TRACEFORLWTVAR%"=="yes" (
		echo After analyse of mkgetpreq with %ENOVApplicationPath%, env is the following >> %TRACEFORLWTFILE%
		set >> %TRACEFORLWTFILE%	
	)

	rem echo NewPath=%newpath%
	rem echo DicPath=%dictionarypath%
	rem echo ReffilesPath=%reffilespath%
	rem echo SpliPath=%splitpath%

	rem ----------------------------------------------------------
	echo ## Build Identity Card
	cd %ENOVApplicationPath%
	call mkmk -a

	rem ----------------------------------------------------------
	echo #######
	echo ## Generating Runtime-View
	if defined mkmkbuild call mkrtv -W %ENOVApplicationPath% -d
	rem if defined mkmkbuild call mkrtv -W %ENOVApplicationPath%

	rem on efface une partie de la runtimeview, avant place au dessus de build identityCard
	cd %ENOVApplicationPath%\%MkmkOS_VAR%\code\dictionary
	if exist *.metadiff.save del /Q *.metadiff.save

	rem ----------------------------------------------------------
	echo #######
	echo ## Update ENOVIA Files
	set DictionaryPath=%dictionarypath%
	set CATDictionaryPath=%dictionarypath%
	set CATDDLPath=%ddlpath%

	set PATH=%newpath%;%PATH%
	rem ajout fya 17/03/04
	echo ## Export VPMAdmin
	call :executeSafe catstart -run "ExportAdmin -f %ENOVApplicationPath%/%MkmkOS_VAR%/code/dictionary/VPMAdmin.adm" -env WorkspaceEnv -direnv %ENOVApplicationPath%\CATEnv
	rem fin ajout fya 17/03/04

	call "%VBTRADELibs%\code\command\CATVBTCustoENOVIA.bat"
	if %ERRORLEVEL% NEQ 0 goto :KO
	
	echo #######
	echo ## Generate DDL Order
	cd %ENOVApplicationPath%
	if exist *.CustomEnv.bat call :generateDDL
	if %return% NEQ SUCCESS goto :EOF

	call :checkPeopleALL
	if "%CUSTOPEOPLE%"=="YES" goto endSimulatePeople

	if "%ENOVSimulatePublish%"=="YES" goto endSimulate

	rem ----------------------------------------------------------
	rem # Creation des tables en base ----------------------------
	echo #######
	echo ## Execute SQL update commands

	IF "%ENOVDataBaseType%" == "DB2" call :updateDB2DataBase
	IF %return% NEQ SUCCESS goto :EOF	

	IF "%ENOVDataBaseType%" == "ORACLE" call :updateOracleDataBase
	IF %return% NEQ SUCCESS goto :EOF
	

	rem ---------------------------------------------------------
	echo #######
	echo ## Create Environement 
	
	set CATUserSettingPath=%CATSettingPath%
	set CATReffilesPath=%reffilespath%;%CATReffilesPath%

	call :executeSafe catstart -run "LoadAdmin %ENOVApplicationPath%\%MkmkOS_VAR%\code\dictionary\VPMAdmin.adm" -env WorkspaceEnv -direnv %ENOVApplicationPath%\CATEnv
	rem if %ERRORLEVEL% NEQ 0 goto :KO
	
	rem --------------------------------------------------------
	echo #######
	echo ## Update Default Mask
	call :executeSafe catstart -run "VPMPeopleUpdate -object -m" -env WorkspaceEnv -direnv %ENOVApplicationPath%\CATEnv
	rem if %return% NEQ SUCCESS goto :KO

	rem --------------------------------------------------------
	echo #######
	echo ## Copy generated files to output directory
	if not defined mkmkbuild call mkCreateRuntimeView -W %ENOVApplicationPath%
	if defined mkmkbuild call mkrtv -W %ENOVApplicationPath%

	if NOT EXIST %ENOVOutputDirectory% mkdir %ENOVOutputDirectory%
	if NOT EXIST %ENOVOutputDirectory%\%MkmkOS_VAR% mkdir %ENOVOutputDirectory%\%MkmkOS_VAR%
	if NOT EXIST %ENOVOutputDirectory%\%MkmkOS_VAR%\code mkdir %ENOVOutputDirectory%\%MkmkOS_VAR%\code
	if NOT EXIST %ENOVOutputDirectory%\%MkmkOS_VAR%\code\bin mkdir %ENOVOutputDirectory%\%MkmkOS_VAR%\code\bin
	if NOT EXIST %ENOVOutputDirectory%\%MkmkOS_VAR%\code\dictionary mkdir %ENOVOutputDirectory%\%MkmkOS_VAR%\code\dictionary
	if NOT EXIST %ENOVOutputDirectory%\%MkmkOS_VAR%\reffiles mkdir %ENOVOutputDirectory%\%MkmkOS_VAR%\reffiles
	if NOT EXIST %ENOVOutputDirectory%\%MkmkOS_VAR%\reffiles\DBMS mkdir %ENOVOutputDirectory%\%MkmkOS_VAR%\reffiles\DBMS
	if NOT EXIST %ENOVOutputDirectory%\%MkmkOS_VAR%\reffiles\DBMS\ddl mkdir %ENOVOutputDirectory%\%MkmkOS_VAR%\reffiles\DBMS\ddl

	if exist %ENOVApplicationPath%\%MkmkOS_VAR%\code\dictionary\*   call :executeSafe xcopy %ENOVApplicationPath%\%MkmkOS_VAR%\code\dictionary\* %ENOVOutputDirectory%\%MkmkOS_VAR%\code\dictionary /y
	if exist %ENOVApplicationPath%\%MkmkOS_VAR%\reffiles\DBMS\ddl\* call :executeSafe xcopy %ENOVApplicationPath%\%MkmkOS_VAR%\reffiles\DBMS\ddl\* %ENOVOutputDirectory%\%MkmkOS_VAR%\reffiles\DBMS\ddl /y

	goto end

:NoAdmin
	echo ## No DataBase Administrator defined !
	goto KO

:NoAdminPssd
	echo ## No Password defined !
	goto KO

:NoSettings
	echo ## No or bad CATSettingPath [%CATSettingPath%]
	goto KO

:NoENOVIALevel
	echo ## No ENOVIA Level defined !
	goto KO

:NoEAATools
	echo ## No EAA tools defined !
	goto KO

:NoTBS
	echo ## Unknown or not set table-space name
	goto KO

:NoDB2
	echo ## Bad or missing db2 client installation directory [%ENOVDB2_HOME%]
	goto KO

:NoORACLE
	echo ## Bad or missing oracle client installation directory [%ENOVORACLE_HOME%]
	goto KO

:NoDatabase
	echo ## Unknown or not set Database Type : [%ENOVDataBaseType%]
	goto KO

:NoApplicationPath
	echo ## No or bad Workspace specified [%ENOVApplicationPath%]
	goto KO

:NoDataBaseAlias
	echo ## No or bad database instance name [%ENOVDataBaseAliasName%]
	goto KO

:SQLError
	echo Error while publishing datas ionto database
	goto KO

:NoMetadiffFileError
    echo Error in creating metadiff file : %1
    goto KO

:KO
	echo . KO
	goto end

:endSimulate
    echo ## End of simulation
	echo To disable simulation mode, modify the ENOVSimulatePublish variable
	goto end

:endSimulatePeople
	echo ## To go on with the Publishing process, you have to be ENOVIA admin and go to the server.
	echo ## Please consult the ENOVIA people RADE customization documentation.
	goto end

:end
 exit 0

