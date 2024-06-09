@if not DEFINED ADL_DEBUG @echo off

setlocal
rem # common initialization
call "%~dp0adl_init_gui.bat"
set rtcode=%ERRORLEVEL%
if not "%rtcode%" == "0" goto end

rem #######################################
rem # SCM Merger                          #
rem #######################################

rem # Different local environment
set CLASSPATH=%ADL_PATH%\docs\java\ADLJavaMerger2.jar;%ADL_PATH%\docs\java\ADLJBasic.jar;%ADL_PATH%\docs\java\CATJTIBase.jar;%ADL_PATH%\docs\java\ADLJavaMerger2JNI.jar;%ADL_PATH%\docs\java\CATJTIPreferencesManager.jar;%ADL_PATH%\docs\java\ADLCMJObjects.jar;%ADL_PATH%\docs\java\ADLCMJServices.jar;%ADL_PATH%\docs\java\swingall.jar;%ADL_PATH%\docs\java\CATJTIImageServices.jar;%ADL_PATH%\docs\java\CATJTIXML.jar;%ADL_PATH%\docs\java\CATJTIThreading.jar;%ADL_PATH%\docs\java\

rem # Run SCM Merger
if "%ADL_ODT_CLASS%" == "" (
	rem # Lancement normal du Fusionneur
	call "%ADL_JAVA_ROOT_PATH%\bin\java" %options% com.dassault_systemes.adelemerger.adljavamerger2.ADLMMain ADLMerger2 %* >%OutputTmpFile% 2>&1
) else (
	rem # Lancement de l'odt correspondant à la variable ADL_ODT_CLASS
	set CLASSPATH=%CLASSPATH%;%ADL_ODT_JAR_NAME%
	call "%ADL_JAVA_ROOT_PATH%\bin\java" %options% %ADL_ODT_CLASS% ADLMerger2 %*
)
endlocal


set rtcode=%ERRORLEVEL%
if exist  "%OutputTmpFile%" (
	if not "%rtcode%" == "0" (
		if not "%rtcode%" == "2" (
			cat "%OutputTmpFile%"
		)
	)

	if "%ADL_DEBUG%"=="" (
		del /Q "%OutputTmpFile%"
	)
)
:end

call return_code.exe %rtcode%


