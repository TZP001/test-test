rem Clean path

@call "%TCK_ROOT_PATH%\code\bin\return_random"
set TMPFILE=%ADL_TMP%\adl_unset_%ERRORLEVEL%.bat
@call "%TCK_ROOT_PATH%\code\bin\delete_from_path" "%ADL_USER_PATH%" "%ADL_ADMIN_PATH%" >%TMPFILE%
@call %TMPFILE%
del /Q %TMPFILE%

