@echo off
set input=%*%
echo set args=%input% |sed -e "s/\//\\/g" |sed -e "s/-D/\/d:/g" | sed -e "s/-mx[0-9a-z]*//g"| sed -e "s/-ms[0-9a-z]*//g" > %ADL_ODT_TMP%\tempbatch.bat
echo set CLASSPATH=%CLASSPATH%  |sed -e "s/\//\\/g" >>%ADL_ODT_TMP%\tempbatch.bat
call %ADL_ODT_TMP%\tempbatch.bat
%ADL_ODT_JAVACOV% jview /cp "%CLASSPATH%" %args%
set rc=%ERRORLEVEL%
echo exit %rc% | sh
