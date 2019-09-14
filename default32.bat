@ECHO off
IF NOT EXIST %APPDATA%\Kodi\userdata\playercorefactory1.xml IF NOT EXIST %APPDATA%\Kodi\userdata\playercorefactory2.xml  goto :missing
If EXiST %APPDATA%\Kodi\userdata\playercorefactory2.xml ren %APPDATA%\Kodi\userdata\playercorefactory.xml playercorefactory1.xml & ren %APPDATA%\Kodi\userdata\playercorefactory2.xml playercorefactory.xml & goto endofscript
ren %APPDATA%\Kodi\userdata\playercorefactory.xml playercorefactory2.xml & ren %APPDATA%\Kodi\userdata\playercorefactory1.xml playercorefactory.xml
:endofscript
taskkill /im Kodi.exe /f
timeout /t 2 /nobreak
Start "kodi" "C:\Program Files\Kodi\kodi.exe"
:missing
exit





