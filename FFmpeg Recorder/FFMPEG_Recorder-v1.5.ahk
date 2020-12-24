;@Ahk2Exe-SetCopyright    Dobbelina
;@Ahk2Exe-SetDescription  FFmpeg Recorder for Kodi
;@Ahk2Exe-SetFileVersion   1.5.0.0
;@Ahk2Exe-SetProductName   FFMPEG_Recorder.exe
;@Ahk2Exe-SetProductVersion   1.5.0.0

#NoEnv
#SingleInstance force
SetWorkingDir %A_ScriptDir%
IniName = ffmpeg.ini
Incoming0 := A_Args[1]
Incoming := UrlDecode(Incoming0)
Clipboard := Incoming
FormatTime, Datefile,, yyyy-MM-dd_HH-mm-ss.
Drawtext := "-vf " . chr(34) . "drawtext=text='%{pts\:hms}':box=1:x=(w-tw)/2:y=h-(2*lh):fontsize=(h/30)" . chr(34)
if (A_ScriptDir = A_AppData . "\Kodi\userdata")
{
MsgBox, 48, Attention!, Do Not Run From The Userdata Folder!
ExitApp
}
if !FileExist(IniName)
{
FileSelectFile, SelectedFile, 3, , Select ffmpeg.exe, ffmpeg (*.exe)
if (SelectedFile = "")
{
MsgBox, 48, Attention!, The user didn't select anything.
ExitApp
}
SplitPath, SelectedFile, exename
if (exename != "ffmpeg.exe")
{
MsgBox, 48, Attention!, Wrong file!
ExitApp
}
IniWrite, %SelectedFile%, %IniName%, Init, ffmpeg
SplitPath, SelectedFile,, binpath
if !FileExist(binpath . "\ffplay.exe")
{
MsgBox, 48, Attention!, ffplay.exe is missing in %binpath%
FileDelete, %IniName%
ExitApp
}
IniWrite, %binpath%\ffplay.exe, %IniName%, Init, ffplay
FileSelectFolder, OutputVar, , 3, Choose Output Folder
if OutputVar =
{
MsgBox, 48, Attention!, You didn't select a folder.
FileDelete, %IniName%
ExitApp
}
IniWrite, %OutputVar%, %IniName%, Init, outputfolder
IniWrite, mp4, %IniName%, Options, container
IniWrite, -c copy, %IniName%, Options, ffcommand
IniWrite, on, %IniName%, Options, timestamp
FileInstall, playercorefactory.xml, playercorefactory.xml
FileInstall, playercorefactory2.xml, playercorefactory2.xml
FileInstall, Switch.ico, Switch.ico
FileInstall, Instructions.txt, Instructions.txt
if FileExist("C:\Program Files (x86)\Kodi\kodi.exe")
FileInstall, default.bat, default.bat
else
FileInstall, default32.bat, default.bat
filePath := "playercorefactory.xml"
lineNumToReplace := 4
newLine := " <filename>" . A_ScriptDir . "\FFMPEG_Recorder.exe" . "</filename>"
ReplaceLine(filePath, lineNumToReplace, newLine)
filePath := "playercorefactory2.xml"
ReplaceLine(filePath, lineNumToReplace, newLine)
filePath := "Instructions.txt"
lineNumToReplace := 3
newLine := A_AppData . "\Kodi\userdata"
ReplaceLine(filePath, lineNumToReplace, newLine)
FileCreateShortcut, %A_ScriptDir%\default.bat, %A_Desktop%\FFMPEG_Recorder Default Change.lnk, "%A_ScriptDir%", , FFMPEG_Recorder Default Change, %A_ScriptDir%\Switch.ico
Run, Instructions.txt
ExitApp
}
IniRead, ffmpeg, ffmpeg.ini, Init, ffmpeg
IniRead, ffplay, ffmpeg.ini, Init, ffplay
IniRead, outputfolder, ffmpeg.ini, Init, outputfolder
IniRead, container, ffmpeg.ini, Options, container
IniRead, ffcommand, ffmpeg.ini, Options, ffcommand
IniRead, timestamp, ffmpeg.ini, Options, timestamp
RegExMatch(Incoming, "^[a-zA-Z]{1,5}:.*?(?=[|]|$)", Link0)
Link:= chr(34) . Link0 . chr(34)
RegExMatch(Incoming, "(?i)(?<=user-agent=)(.*?)(?=&|$)", Uagent0)
if (Uagent0)
Uagent:= "-user_agent " . chr(34) . Uagent0 . chr(34)
RegExMatch(Incoming, "(?i)(?<=Referer=)(.*?)(?=&|$)", Referer0)
if (Referer0)
Referer:= "-referer " . chr(34) . Referer0 . chr(34)
RegExMatch(Incoming, "(?i)(?<=Cookie=)(.*?)(?=&|$)", Cookie0)
if (Cookie0)
Cookie:= "-cookies " . chr(34) . Cookie0 . chr(34)
if (timestamp <> "on")
Drawtext =
PathFile := chr(34) . outputfolder . "\" . Datefile . container . chr(34)
Recorder := chr(34) . ffmpeg . chr(34)
Mplayer := chr(34) . ffplay . chr(34)
Progress,B2 fs16 c0 zh0  w300 h80 Cblack,Press "1" Download Only`nPress "2" Download + Watch`nPress "3" Watch Only,,Arial
Loop {
If (getKeyState("1", "P")) or (getKeyState("Numpad1", "P"))
gosub, Label1
else if (getKeyState("2", "P")) or (getKeyState("Numpad2", "P"))
gosub, Label2
else if (getKeyState("3", "P")) or (getKeyState("Numpad3", "P"))
gosub, Label3
Sleep 50
}

label1:
Progress, off
Run, %Recorder% %Uagent% %Referer% %Cookie% -i %Link% %ffcommand% %PathFile%
ExitApp
label2:
Progress, off
Run, %comspec% /c "%Recorder% %Uagent% %Referer% %Cookie% -i %Link% %ffcommand% %PathFile% -c copy -f mpegts - | %Mplayer% -fs %Drawtext% -autoexit -"
WinWait, ahk_exe cmd.exe, , 2
WinWaitClose, ahk_exe cmd.exe
ExitApp
label3:
Progress, off
Run, %Mplayer% -fs -autoexit %Uagent% %Referer% %Cookie% -i %Link%
WinWait, ahk_exe ffplay.exe, , 2
WinWaitClose, ahk_exe ffplay.exe
ExitApp

UrlDecode(str) {
    Loop
 If RegExMatch(str, "i)(?<=%)[\da-f]{1,2}", hex)
    StringReplace, str, str, `%%hex%, % Chr("0x" . hex), All
    Else Break
 Return, str
}

ReplaceLine(filePath, lineNum, text) {
   oFile := FileOpen(filePath, "rw")
   start := oFile.Pos
   Loop % lineNum {
      line := oFile.ReadLine()
      if (A_Index = lineNum - 1)
         linePos := oFile.Pos
      if (A_Index = lineNum && notEOF := true)
         rest := oFile.Read()
   } until oFile.AtEOF
   if notEOF {
      oFile.Pos := linePos
      oFile.Write( text . RegExReplace(line, "[^`r`n]+") )
      oFile.Write(rest)
      oFile.Length := oFile.Pos
   }
   oFile.Close()
}
