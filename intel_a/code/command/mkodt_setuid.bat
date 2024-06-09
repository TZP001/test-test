@echo off
if %1 == exit (
  echo exit %2 > c:\temp\sucmd%CATDefaultEnvironment%.sh
  exit
)
set userloggin=%2
set tmpvar=errorlevel
echo @echo off>c:\temp\sucmd%CATDefaultEnvironment%.bat
set | awk "{print \"set\",$0}" >> c:\temp\sucmd%CATDefaultEnvironment%.bat
echo setcatenv -e %CATDefaultEnvironment% -p %MKMK_LST_RTV% >> c:\temp\sucmd%CATDefaultEnvironment%.bat
echo sh +C %3 %4 %5 %6 %7 %8 %9>> c:\temp\sucmd%CATDefaultEnvironment%.bat
echo %whence_ro% exit %%errorlevel%%>> c:\temp\sucmd%CATDefaultEnvironment%.bat
c:\tools\lcs\LaunchCommandControl -window -userlogin %userloggin% -userpassword ovbupc -host %COMPUTERNAME% -command "c:\temp\sucmd%CATDefaultEnvironment%.bat > c:\temp\sucmd%CATDefaultEnvironment%.output 2>&1" > NUL
cat c:\temp\sucmd%CATDefaultEnvironment%.output 2> NUL
del c:\temp\sucmd%CATDefaultEnvironment%.bat 2> NUL
del c:\temp\sucmd%CATDefaultEnvironment%.output 2> NUL
if exist c:\temp\sucmd%CATDefaultEnvironment%.sh goto end
echo ## ERROR : Unable to change to user %userloggin%
echo exit 1 | sh
exit

:end
sh +C c:\temp\sucmd%CATDefaultEnvironment%.sh
