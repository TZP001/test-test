@if not DEFINED ADL_DEBUG @echo off

setlocal
rem # common initialization
call "%~dp0adl_init_gui.bat"
set rtcode=%ERRORLEVEL%
if not "%rtcode%" == "0" goto end

rem ###################################################
rem # SCM graphical interface                         #
rem ###################################################

rem # Different local environment
set CLASSPATH=%ADL_PATH%\docs\java\swingall.jar;%ADL_PATH%\docs\java\CATJTIBase.jar;%ADL_PATH%\docs\java\CATJTIThreading.jar;%ADL_PATH%\docs\java\CATJTIImageServices.jar;%ADL_PATH%\docs\java\CATJTIPreferencesManager.jar;%ADL_PATH%\docs\java\ADLJBasic.jar;%ADL_PATH%\docs\java\ADLCMJObjects.jar;%ADL_PATH%\docs\java\ADLCMJServices.jar;%ADL_PATH%\docs\java\ADLImportGUI.jar;%ADL_PATH%\docs\java\ADLSOChgGUI.jar;%ADL_PATH%\docs\java\ADLCMHistoryGUI.jar;%ADL_PATH%\docs\java\ADLCMDiffwsGUI.jar;%ADL_PATH%\docs\java\ADLIsGUI.jar;%ADL_PATH%\docs\java\ADLGUI.jar;%ADL_PATH%\docs\java
set TNS_ADMIN=%ADL_ORA_TNS_ADMIN%
set NLS_LANG=%ADL_NLS_LANG%
set CATUserSettingPath=%RADECATSettingPath%\SCM
set MULTISITEGUITMP=%ADL_TMP%\adlmultisitegui_%RANDOM_NUMBER%.txt
set ADL_MSADMIN_CONSTANT_VARIABLES_FILE=%ADL_PATH%/docs/java/ADLMSAdminConstantVariables.properties

rem # Run SCM GUI
if "%ADL_ODT_CLASS%" == "" (
	if "%ADL_DEBUG%" == "" (
		rem # Lancement normal dans une fenetre independante
		start ""  "%ADL_JAVA_ROOT_PATH%\bin\javaw" %options% com.dassault_systemes.adeleconfigmanagement.adlgui.Main adl_gui %* 
	) else (
		rem # Lancement normal avec la console pour le debug
		call "%ADL_JAVA_ROOT_PATH%\bin\java" %options% com.dassault_systemes.adeleconfigmanagement.adlgui.Main adl_gui %*
	)
) else (
	rem # Lancement de l'odt correspondant à la variable ADL_ODT_CLASS
	set CLASSPATH=%CLASSPATH%;%ADL_ODT_JAR_NAME%
	set ADL_DEBUG=t
	echo call "%ADL_JAVA_ROOT_PATH%\bin\java" %options% %ADL_ODT_CLASS% %*
	call "%ADL_JAVA_ROOT_PATH%\bin\java" %options% %ADL_ODT_CLASS% %*
)
endlocal

set rtcode=%ERRORLEVEL%
:end
exit /B %rtcode%
