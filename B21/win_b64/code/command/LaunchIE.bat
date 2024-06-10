c:
cd C:\Program Files\Plus!\Microsoft Internet
set htmlfiletoload=%1
rem \IEXPLORE.EXE <fully_qualified_pathname_of_html_file>
echo Launching HTML File.....%htmlfiletoload%
IEXPLORE.EXE %htmlfiletoload%
cd C:\Temp
