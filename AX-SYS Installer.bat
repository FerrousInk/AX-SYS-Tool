@echo off


rem Get Admin

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~dpnx0"
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"
  
  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

echo .                         Made by FerrousInk
echo .
echo .        _/_/    _/      _/              _/_/_/  _/      _/    _/_/_/   
echo .     _/    _/    _/  _/              _/          _/  _/    _/          
echo .    _/_/_/_/      _/    _/_/_/_/_/    _/_/        _/        _/_/       
echo .   _/    _/    _/  _/                    _/      _/            _/      
echo .  _/    _/  _/      _/            _/_/_/        _/      _/_/_/         
echo .


:start
if exist "%programfiles% (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat" echo [ + ] SDKs Installed!
if exist "%programfiles% (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat" goto after-sdk
if not exist "%programfiles% (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat" goto :sdk-not-installed

:sdk-not-installed
echo [ - ] WindowsADK; Pe-Addon Not Installed!
:ask-again-sdk-install
set /p sdk-install=[ - ] Install them? [Y/N] :
if y == %sdk-install% (goto install-sdks) else (if Y == %sdk-install% (goto install-sdks) else (if n == %sdk-install% (goto after-sdk) else (if N == %sdk-install% (goto after-sdk) else (goto ask-again-sdk-install))))

:rufus-not-installed
echo [ - ] Rufus Not Installed!
:ask-again-rufus-install
set /p rufus-install=[ - ] Install Rufus? (Rufus is only needed for flashing a usb) [Y/N] :
if y == %rufus-install% (goto install-rufus) else (if Y == %rufus-install% (goto install-rufus) else (if n == %rufus-install% (goto after-rufus) else (if N == %rufus-install% (goto after-rufus) else (goto ask-again-rufus-install))))


rem Installs

:install-sdks
winget install Microsoft.WindowsADK | echo [ i ] Installing WindowsADK (This may take a while)
winget install Microsoft.ADKPEAddon | echo [ i ] Installing Pe-Addon (This may take a while)
goto after-sdk

:install-rufus
winget install Rufus.Rufus | echo [ i ] Installing Rufus
goto after-rufus

:after-sdk
if exist "%localappdata%\Microsoft\WinGet\Packages\Rufus.Rufus_Microsoft.Winget.Source_8wekyb3d8bbwe\rufus.exe" echo [ + ] Rufus Installed!
if exist "%localappdata%\Microsoft\WinGet\Packages\Rufus.Rufus_Microsoft.Winget.Source_8wekyb3d8bbwe\rufus.exe" goto after-rufus
if not exist "%localappdata%\Microsoft\WinGet\Packages\Rufus.Rufus_Microsoft.Winget.Source_8wekyb3d8bbwe\rufus.exe" goto :rufus-not-installed

:after-rufus
if exist "%userprofile%\Desktop\AX-SYS ISO Builder.bat" del "%userprofile%\Desktop\AX-SYS ISO Builder.bat"
echo [ + ] Installing Script
mkdir "%appdata%\AX-SYS"
mkdir "%temp%\AX-SYS"
curl -o "%temp%\AX-SYS\files_layer.7z" "https://raw.githubusercontent.com/FerrousInk/AX-SYS-Tool/main/files.7z"
curl -o "%temp%\AX-SYS\7zr.exe" "https://www.7-zip.org/a/7zr.exe"
call "%temp%\AX-SYS\7zr.exe" x "%temp%\AX-SYS\files_layer.7z" -o"%temp%\AX-SYS"
call "%temp%\AX-SYS\7zr.exe" x "%temp%\AX-SYS\files.7z" -o"%appdata%\AX-SYS"
rmdir /s /q "%temp%\AX-SYS"
move "%appdata%\AX-SYS\iso_builder.txt" "%userprofile%\Desktop\AX-SYS ISO Builder.bat"
if not exist "%userprofile%\Desktop\AX-SYS ISO Builder.bat" (goto offline-install) else (goto install-finished)
:offline-install
color 0c
echo [ - ] Debug Information ^
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ] Installtion Failed! Please make sure you're connected to the internet!
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
pause | echo [ i ] Press any key to check AX-SYS files
if not exist "%appdata%\AX-SYS\iso_builder.txt" (echo [ + ] ISO Builder moved to Desktop) else (echo [ ! ] Failed to move ISO Builder to Desktop)
if not exist "%appdata%\AX-SYS\AX-SYS\copy_winpe.cmd" (echo [ ! ] Failed to extract copy_winpe.cmd) else (echo [ + ] Extracted copy_winpe.cmd)
if not exist "%appdata%\AX-SYS\AX-SYS\create_iso.cmd" (echo [ ! ] Failed to extract create_iso.cmd) else (echo [ + ] Extracted create_iso.cmd)
if not exist "%appdata%\AX-SYS\Scripts\Windows\System32\install.cmd" (echo [ ! ] Failed to extract install.cmd) else (echo [ + ] Extracted install.cmd)
if not exist "%appdata%\AX-SYS\Scripts\Windows\System32\startnet.cmd" (echo [ ! ] Failed to extract startnet.cmd) else (echo [ + ] Extracted startnet.cmd)
if not exist "%appdata%\AX-SYS\Scripts\Windows\System32\get_admin_group.cmd" (echo [ ! ] Failed to extract get_admin_group.cmd) else (echo [ + ] Extracted get_admin_group.cmd)
if not exist "%temp%\AX-SYS\7zr.exe" (echo [ ! ] Failed to download 7zip) else (echo [ + ] Downloaded 7zip)

:install-finished
echo [ - ] Debug Information ^
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ] Install Finished!
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
echo [ - ]
pause | echo [ i ] Press any key to exit
exit
