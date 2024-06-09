Option Explicit

Public StdOut, SourceFileName, TargetFileName, Regular, FSO, SourceTextStream, TargetTextStream, ReturnValue, String

Main()

Sub Main()

On Error Resume Next

Set StdOut = WScript.Stdout

GetArguments

Set Regular = New RegExp
Regular.Pattern = "([^/][^/]) in '.*'.*([,;])"
Regular.Global = True
Regular.IgnoreCase = True

Set FSO = CreateObject("Scripting.FileSystemObject")
Set TargetTextStream = FSO.CreateTextFile(TargetFileName, True)

If Err.Number <> 0 Then
        StdOut.WriteLine "# mkmk-ERROR: Unable to create file '" & TargetFileName & "' (" & Err.Number & "): " & Err.Description
        WScript.Quit(1)
End If

Const ForReading=1
Set SourceTextStream = FSO.OpenTextFile(SourceFileName, ForReading)

If Err.Number <> 0 Then
        StdOut.WriteLine "# mkmk-ERROR: Unable to open file '" & SourceFileName & "' (" & Err.Number & "): " & Err.Description
        WScript.Quit(1)
End If

Do While Not SourceTextStream.AtEndOfStream
	String = SourceTextStream.ReadLine
	ReturnValue = Regular.Test(String)
	If ReturnValue Then
		TargetTextStream.WriteLine Regular.Replace(String, "$1$2")
	Else
		TargetTextStream.WriteLine String
	End If
Loop

SourceTextStream.Close
TargetTextStream.Close

If Err.Number <> 0 Then
        StdOut.WriteLine "# mkmk-ERROR: Unable to convert file '" & SourceFileName & "' (" & Err.Number & "): " & Err.Description
        WScript.Quit(1)
End If

Set StdOut = Nothing
Set Regular = Nothing
Set FSO = Nothing
Set SourceTextStream = Nothing
Set TargetTextStream = Nothing

End sub

Function GetArguments

On Error Resume Next

If WScript.arguments.length <> 2 Then
        StdOut.WriteLine "# mkmk-ERROR: Unable to get arguments in 'mkConvertDpr.vbs': bad number"
        WScript.Quit(1)
End If

SourceFileName = WScript.arguments.item(0)
TargetFileName = WScript.arguments.item(1)

If Err.Number <> 0 Then
        StdOut.WriteLine "# mkmk-ERROR: Unable to get arguments in 'mkConvertDpr.vbs' (" & Err.Number & "): " & Err.Description
        WScript.Quit(1)
End If

End Function

