@echo off
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

echo ///// Version 1.0
echo ////
echo ///        AX-SYS Tool
echo //
echo / Made by FerrousInk

:start
if exist "%programfiles% (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat" echo [ + ] SDKs Installed!
if exist "%programfiles% (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat" goto after-sdk
if not exist "%programfiles% (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat" goto :sdk-not-installed

:sdk-not-installed
echo [ - ] Windows 10 ADK; Win-ADK-Pe-Addon Not Installed!
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
winget install Microsoft.WindowsADK
winget install Microsoft.ADKPEAddon
goto after-sdk

:install-rufus
winget install Rufus.Rufus
goto after-rufus

:after-sdk
if exist "%localappdata%\Microsoft\WinGet\Packages\Rufus.Rufus_Microsoft.Winget.Source_8wekyb3d8bbwe\rufus.exe" echo [ + ] Rufus Installed!
if exist "%localappdata%\Microsoft\WinGet\Packages\Rufus.Rufus_Microsoft.Winget.Source_8wekyb3d8bbwe\rufus.exe" goto after-rufus
if not exist "%localappdata%\Microsoft\WinGet\Packages\Rufus.Rufus_Microsoft.Winget.Source_8wekyb3d8bbwe\rufus.exe" goto :rufus-not-installed

:after-rufus
if exist %userprofile%\Desktop\AX-SYS ISO Builder.bat del %userprofile%\Desktop\AX-SYS ISO Builder.bat
echo [ + ] Installing Script
curl -o "%appdata%\AX-SYS.temp.zip" "https://raw.githubusercontent.com/FerrousInk/AX-SYS-Tool/main/files.zip"
mkdir %appdata%\AX-SYS
powershell.exe -Command Expand-Archive -Force "%appdata%\AX-SYS.temp.zip" "%appdata%\AX-SYS"
del "%appdata%\AX-SYS.temp.zip"
move "%appdata%\AX-SYS\iso_builder.txt" "%userprofile%\Desktop\AX-SYS ISO Builder.bat"
if not exist "%userprofile%\Desktop\AX-SYS ISO Builder.bat" (goto offline-install) else (goto install-finished)
:offline-install
echo [ - ] Server not reachable!
echo [ - ] Please connect to the internet to install latest version of the AX-SYS Tool
pause
exit

:install-finished
echo [ + ] Install Finished!
pause
exit