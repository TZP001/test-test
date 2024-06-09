%TCKOS_Runtime% Clean path

@call "%TCK_ROOT_PATH%\code\bin\return_random"
set TMPFILE=%TEMP%\TCKunset_%ERRORLEVEL%.bat
@call "%TCK_ROOT_PATH%\code\bin\delete_from_path" "%TCK_ROOT_PATH%\TCK\command" >"%TMPFILE%"
@call "%TMPFILE%"
del /Q "%TMPFILE%"

