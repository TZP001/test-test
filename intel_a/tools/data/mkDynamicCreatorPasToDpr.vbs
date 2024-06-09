Option Explicit

Public StdOut, WSShell, FSO, Text
Public Check, Application, Units, ConvertData
Public DynamicCreatorDll, PasFilesDirectory, OutputPath, OutputExt, DllName, FileName, Uses, UsesSection

Main()

Sub Main()

On Error Resume Next

Set StdOut = WScript.Stdout

GetArguments

Register

Set Application = CreateObject("DynamicCreator.CApplication")
Set ConvertData = CreateObject("DynamicCreator.CConvertData")
Set Units = Application.NewDLL(PasFilesDirectory, True)
Units.DllName = DllName
Units.FileName = FileName
ConvertData.OutputPath = OutputPath
ConvertData.FileExtension = OutputExt

Units.ConvertToDelphiProject ConvertData, Uses, UsesSection

If Err.Number <> 0 Then
	StdOut.WriteLine "# mkmk-ERROR: Unable to convert data in 'mkDynamicCreatorPasToDpr.vbs' (" & Err.Number & "): " & Err.Description
	WScript.Quit(1)
End If

Set Application = Nothing
Set ConvertData = Nothing
Set Units = Nothing
Set StdOut = Nothing

End Sub

Function GetArguments

On Error Resume Next

If WScript.arguments.length <> 7 Then
        StdOut.WriteLine "# mkmk-ERROR: Unable to get arguments in 'mkDynamicCreatorPasToDpr.vbs': bad number"
        WScript.Quit(1)
End If

DynamicCreatorDll = WScript.arguments.item(0)
PasFilesDirectory = WScript.arguments.item(1)
DllName = WScript.arguments.item(2)
OutputPath = WScript.arguments.item(3)
FileName = WScript.arguments.item(4)
OutputExt = WScript.arguments.item(5)
Uses = WScript.arguments.item(6)
UsesSection = FileName & "." & OutputExt

If Err.Number <> 0 Then
        StdOut.WriteLine "# mkmk-ERROR: Unable to get arguments in 'mkDynamicCreatorPasToDpr.vbs' (" & Err.Number & "): " & Err.Description
        WScript.Quit(1)
End If

End Function

Function Register

On Error Resume Next

Set Application = CreateObject("DynamicCreator.CApplication")

If Err.Number <> 0 Then

	On Error Resume Next

        Set WSShell = WScript.CreateObject("WScript.Shell")
        Set FSO = CreateObject("Scripting.FileSystemObject")

        If (FSO.FileExists(DynamicCreatorDll)) Then
                StdOut.WriteLine "# mkmk-INFO: Register '" & DynamicCreatorDll & "'"
                Text = "REGSVR32.EXE " & Chr(34) & DynamicCreatorDll & Chr(34) & " /S"
                WSShell.Run(Text),0,TRUE
        Else
                StdOut.WriteLine "# mkmk-ERROR: Unable to register '" & DynamicCreatorDll & "' in 'mkDynamicCreatorPasToDpr.vbs': no such file"
                WScript.Quit(1)
        End If
	
	If Err.Number <> 0 Then
        	StdOut.WriteLine "# mkmk-ERROR: Unable to register '" & DynamicCreatorDll & "' in 'mkDynamicCreatorPasToDpr.vbs' (" & Err.Number & "): " & Err.Description
        	WScript.Quit(1)
	End If

        Set WSShell = Nothing
        Set FSO = Nothing

End If

Set Application = Nothing

End Function

