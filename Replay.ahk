#NoEnv
#SingleInstance ignore
CoordMode, Pixel, Screen
Coordmode, Mouse, Screen

keybutton = Space
IniName = 2-Coordinates.ini
IfNotExist, %IniName%
{
InputBox, Command , Command To Send To Kodi, p = Play`n{DOWN}p = Play Next`nSee Keyboard Controls For Kodi.`nF4 To Exit, , , , , , , , p
if ErrorLevel
{
ExitApp
}
else
{
IniWrite, %Command%, %IniName%, Init, Command
}
InputBox, Shortcut , Keyboard Shortcut To Toggle Switch, Keyboard Shortcut To Toggle Switch.`nSee Hotkey Documentation For Autohotkey.`nDo Not Use F4, , , , , , , , 1
if ErrorLevel
{
FileDelete, %IniName%
ExitApp
} 
else
{
IniWrite, %Shortcut%, %IniName%, Init, Shortcut
} 
MsgBox,, Create 2 Coordinates, Place Cursor And Click Space on 2 Mouse Coordinates.`nDelete 2-Coordinates.ini To Start Over.

KeyWait, %keybutton%, D 
KeyWait, %keybutton%, U
MouseGetPos, LocX, LocY
IniWrite, %LocX%, %IniName%, Init, Cord1X
IniWrite, %LocY%, %IniName%, Init, Cord1Y
PixelGetColor, LocColor, %LocX%, %LocY%
IniWrite, %LocColor%, %IniName%, Init, FirstColor
SoundBeep, 1000, 500
KeyWait, %keybutton%, D 
KeyWait, %keybutton%, U
MouseGetPos, LocX, LocY
IniWrite, %LocX%, %IniName%, Init, Cord2X
IniWrite, %LocY%, %IniName%, Init, Cord2Y
PixelGetColor, LocColor, %LocX%, %LocY%
IniWrite, %LocColor%, %IniName%, Init, SecondColor
SoundBeep, 1200, 300
SoundBeep, 1200, 300
Reload
}

IniRead, Command, 2-Coordinates.ini, Init, Command
IniRead, Shortcut, 2-Coordinates.ini, Init, Shortcut
IniRead, Cord1X, 2-Coordinates.ini, Init, Cord1X
IniRead, Cord1Y, 2-Coordinates.ini, Init, Cord1Y
IniRead, FirstColor, 2-Coordinates.ini, Init, FirstColor
IniRead, Cord2X, 2-Coordinates.ini, Init, Cord2X
IniRead, Cord2Y, 2-Coordinates.ini, Init, Cord2Y
IniRead, SecondColor, 2-Coordinates.ini, Init, SecondColor  
Hotkey1 = %Shortcut%

Hotkey %Hotkey1%, Shortcut
return

Shortcut:
RepeatKey := !RepeatKey
If RepeatKey 
SetTimer, CheckColor, 2000
Else
SetTimer, CheckColor, Off
Return
 
CheckColor:
PixelGetColor, color1, %Cord1X%, %Cord1Y%
PixelGetColor, color2, %Cord2X%, %Cord2Y% 
If ( color1 = FirstColor && Color2 = SecondColor )
{
send %Command% 
} 
return 

F4::ExitApp






