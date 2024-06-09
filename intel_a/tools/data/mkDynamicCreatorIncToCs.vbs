Option Explicit

Public StdOut, WSShell, FSO, Text
Public Application, Includes, ConvertData
Public DynamicCreatorDll, IncFilesDirectory, OutputPath, OutputExt, BaseNameSpace, CSTypesFile, CSTypesClassesFile, CSIgnoredConstsFile

Main()

Sub Main()

On Error Resume Next

Set StdOut = WScript.Stdout

GetArguments

Register

Set Application = CreateObject("DynamicCreator.CApplication")
Set ConvertData = CreateObject("DynamicCreator.CConvertData")
Set Includes = Application.NewTypes(IncFilesDirectory)
ConvertData.OutputPath = OutputPath
ConvertData.FileExtension = OutputExt

Includes.ConvertToCsFile ConvertData, CSTypesFile, BaseNameSpace, CSTypesClassesFile, CSIgnoredConstsFile

If Err.Number <> 0 Then
	StdOut.WriteLine "# mkmk-ERROR: Unable to convert data in 'mkDynamicCreatorIncToCs.vbs' (" & Err.Number & "): " & Err.Description
	WScript.Quit(1)
End If

Set Application = Nothing
Set ConvertData = Nothing
Set Includes = Nothing
Set StdOut = Nothing

End Sub

Function GetArguments

On Error Resume Next

If WScript.arguments.length <> 7 Then
        StdOut.WriteLine "# mkmk-ERROR: Unable to get arguments in 'mkDynamicCreatorIncToCs.vbs': bad number"
        WScript.Quit(1)
End If

DynamicCreatorDll = WScript.arguments.item(0)
IncFilesDirectory = WScript.arguments.item(1)
OutputPath = WScript.arguments.item(2)
OutputExt = "cs"
BaseNameSpace = WScript.arguments.item(3)
CSTypesFile = WScript.arguments.item(4)
CSTypesClassesFile = WScript.arguments.item(5)
CSIgnoredConstsFile = WScript.arguments.item(6)

If Err.Number <> 0 Then
        StdOut.WriteLine "# mkmk-ERROR: Unable to get arguments in 'mkDynamicCreatorIncToCs.vbs' (" & Err.Number & "): " & Err.Description
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
                StdOut.WriteLine "# mkmk-ERROR: Unable to register '" & DynamicCreatorDll & "' in 'mkDynamicCreatorIncToCs.vbs': no such file"
                WScript.Quit(1)
        End If
	
	If Err.Number <> 0 Then
        	StdOut.WriteLine "# mkmk-ERROR: Unable to register '" & DynamicCreatorDll & "' in 'mkDynamicCreatorIncToCs.vbs' (" & Err.Number & "): " & Err.Description
        	WScript.Quit(1)
	End If

        Set WSShell = Nothing
        Set FSO = Nothing

End If

Set Application = Nothing

End Function

