@rem
@rem Purpose: to run a DOS command from another application
@rem and to get traces from execution
@rem Usage: %1 = file for output traces
@rem        %2 = command to run
@rem        %3 = command's arguments


@call %2 %3 %4 %5 %6 %7 %8 %9 > %1 2>&1
@set rtcode=%ERRORLEVEL%
@goto Label_OK

:Label_KO
@echo execution failed
@call "%ADL_PATH%\code\bin\return_code.exe" 5

:Label_OK
echo 2 = %2 >> %1
echo 3 = %3 >> %1
echo 4 = %4 >> %1
echo 5 = %5 >> %1
@call "%ADL_PATH%\code\bin\return_code.exe" %rtcode%

