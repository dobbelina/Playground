#NoEnv
#SingleInstance force
SetWorkingDir %A_ScriptDir%
IniName = ffmpeg.ini
Incoming := chr(34) . A_Args[1] . chr(34)
Clipboard := Incoming
Datefile := "%Y-%m-%d_%H-%M-%S." 
Drawtext := "-vf " . chr(34) . "drawtext=text='%{pts\:hms}':box=1:x=(w-tw)/2:y=h-(2*lh):fontsize=24" . chr(34)
if (A_ScriptDir = A_AppData . "\Kodi\userdata")
{	
msgbox, Do Not Run From The Userdata Folder!
ExitApp
}
if !FileExist(IniName)
{
FileSelectFile, SelectedFile, 3, , Select ffmpeg.exe, ffmpeg (*.exe)
if (SelectedFile = "")
{
MsgBox, The user didn't select anything.
ExitApp
}
else
IniWrite, %SelectedFile%, %IniName%, Init, ffmpeg
SplitPath, SelectedFile,, binpath
if !FileExist(binpath . "\ffplay.exe")
{
msgbox, ffplay.exe is missing in %binpath%
FileDelete, %IniName%
ExitApp
}
IniWrite, %binpath%\ffplay.exe, %IniName%, Init, ffplay    
FileSelectFolder, OutputVar, , 3, Choose Output Folder
if OutputVar =
{
MsgBox, You didn't select a folder.
FileDelete, %IniName%
ExitApp
}
else
IniWrite, %OutputVar%, %IniName%, Init, outputfolder
IniWrite, mp4, %IniName%, Options, container
IniWrite, on, %IniName%, Options, timestamp
FileInstall, playercorefactory.xml, playercorefactory.xml
FileInstall, playercorefactory2.xml, playercorefactory2.xml
FileInstall, Switch.ico, Switch.ico
FileInstall, Instructions.txt, Instructions.txt
if (A_Is64bitOS = 1)
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
IniRead, timestamp, ffmpeg.ini, Options, timestamp
if (timestamp <> "on")
Drawtext =   
PathFile := chr(34) . outputfolder . "\" . Datefile . container . chr(34)
Recorder := chr(34) . ffmpeg . chr(34)
Mplayer := chr(34) . ffplay . chr(34)
Progress,B fs16 c0 zh0  w300 h55 Cblack,Press "1" Download Only`nPress "2" Download + Watch,,Arial
Loop {
If (getKeyState("1", "P")) or (getKeyState("Numpad1", "P"))
gosub, Label1
else if (getKeyState("2", "P")) or (getKeyState("Numpad2", "P"))
gosub, Label2      
Sleep 50
} 

label1:
Progress, off
Run, %Recorder% -i %Incoming% -c copy -f segment -segment_time 21600 -strftime 1 %PathFile% 
ExitApp
label2:
Progress, off
Run, %comspec% /c "%Recorder% -i %Incoming% -c copy -f segment -segment_time 21600 -strftime 1 %PathFile% -c copy -f mpegts - | %Mplayer% -fs %Drawtext% -autoexit -"
ExitApp

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
