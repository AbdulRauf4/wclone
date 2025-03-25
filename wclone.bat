@echo off
:: wclone project (c) 2025 FranzeDigitalCodingGroup, All Rights Reserved. Do not redistribute!
:: Very lightweight file managing software, used to extract, copy and delete files.
chcp 65001 >NUL
set "wcloneversion=B2025324RV"
set "author=FranzeDigitalCodingGroup ^| Liam Pfundt"
set "build_date=March 25th 2025"
set "copyright=(c) 2025 FranzeDigitalCodingGroup"
setlocal enabledelayedexpansion
goto var

:var
if "%~1"=="-f" goto var2
if "%~1"=="--wclone" goto info
if "%~1"=="--about" goto about
if "%~1"=="--credits" goto credits
if "%~1"=="--autoconf" goto autoconf
if "%~1"=="--clearconf" goto clearconf
if "%~1"=="--refreshconf" goto refreshconf
if "%~1"=="--help" goto wclonehelp
goto usage

:usage
echo wclone: [31;1merror[0m: Invalid usage of arguments
echo.
exit /b

:var2
if "%~2"=="" goto usage
set "filetocopy=%~2"
goto var3

:var3
if "%~3"=="" goto usage
if "%~3"=="-c" goto fileclone
if "%~3"=="-d" goto filedelete
if "%~3"=="-u" goto fileunzip
goto usage

:fileunzip
set "zipfile=%filetocopy%"
set "unzipdir=%~4"
set "tempdir=%TEMP%\wclone_unzip_temp"
mkdir "%tempdir%"
powershell -Command "Expand-Archive -Path '%zipfile%' -DestinationPath '%tempdir%'" >NUL 2>&1
if !errorlevel! neq 0 (
    echo wclone: [31;1merror[0m: could not unzip "%zipfile%"
    echo.
    rmdir /S /Q "%tempdir%"
    exit /b
)
xcopy "%tempdir%\*" "%unzipdir%" /E /I /H /Y >NUL
rmdir /S /Q "%tempdir%" >NUL
echo wclone: [32;1msuccess[0m: successfully unzipped "%zipfile%" to "%unzipdir%"
echo.
exit /b

:fileclone
if "%~4"=="" goto usage
set "out=%~4"
if EXIST wclone.temp (
    goto waitforfin
)
echo wclone: cloning %~2, please stand by ...
type %~2 > wclone.temp
rename wclone.temp %out% >NUL
goto checkerrclone

:checkerrclone
if !errorlevel! neq 0 (
    echo wclone: [31;1merror[0m: could not clone "%~2"
    echo.
    exit /b
) else (
    echo wclone: [32;1msuccess[0m: successfully cloned "%~2"
    echo.
    exit /b
)

:filedelete
del /Q /S /F %filetocopy% >nul
goto checkerrdelete

:checkerrdelete
if !errorlevel! neq 0 (
    echo wclone: [31;1merror[0m: could not remove "%~2"
    echo.
    exit /b
) else (
    echo wclone: [32;1msuccess[0m: successfully removed "%~2"
    echo.
    exit /b
)

:info
echo ┌──────────────────┐
echo │  [92;1mwclone project[0m  │
echo └──────────────────┘
echo (c) 2025 FranzeDigitalCodingGroup
echo.
echo Current build:     %wcloneversion%
echo Current errorcode: %errorlevel%
echo.
exit /b

:waitforfin
echo wclone: [33mattention[0m: there is already a file being cloned, waiting until that file is cloned ...
goto waitforfin1

:waitforfin1
if EXIST wclone.temp (
    goto waitforfin1
) else (
    goto fileclone
)

:about
echo ┌──────────────────┐
echo │  [92;1mwclone project[0m  │
echo └──────────────────┘
echo (c) 2025 FranzeDigitalCodingGroup
echo.
echo [92;1mwclone[0m is a program made by FranzeDigitalCodingGroup, it's purpose is to
echo be able to clone and remove files without needing to run CMD as adminis-
echo trator. It's a free-to-use software made for anyone that likes to code, 
echo program, or is just interested in [92;1mwclone[0m.
echo.
exit /b

:filebackup
echo wclone: [36;7mniib[0m: this feature is not included in this build
echo.
exit /b

:credits
echo ┌──────────────────┐
echo │  [92;1mwclone project[0m  │
echo └──────────────────┘
echo (c) 2025 FranzeDigitalCodingGroup
echo.
echo Main script coding: [4mLiam Pfundt[0m
echo Testing:            [4mLiam Pfundt[0m
echo ASCII art:          [4masciiflow.com[0m
echo Idea by:            [4mLiam Pfundt[0m
echo Powered by:         [4mWindows Batch[0m
echo Coded in:           [4mMicrosoft Visual Studio Code 1.98.2[0m
echo Other help:         [4mMicrosoft Copilot, ChatGPT[0m
echo.
echo Author e-mail:      [4mfranzedcg@gmail.com[0m
echo.
exit /b

:autoconf
if EXIST "%WINDIR%\System32\wclone.conf" (
    goto autoconfex
)
echo     ┌────────────────────────┐    
echo     │FranzeDigitalCodingGroup│    
echo     └────────────────────────┘    
echo Copyright ^(c^), All Rights Reserved
echo.
echo [*] You are about to autoconf wclone, proceed?
choice /c YN /N /M "[Y/n] "
if %errorlevel%==1 goto autoconfpro
echo [*] Autoconf aborted ...
echo.
exit /b

:autoconfpro
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo wclone: [31;1merror[0m: This operation requires administrative privileges.
    echo.
    exit /b
)
echo cnf, CONF (runmode autoCONF) > "%WINDIR%\System32\wclone.conf"
copy "wclone.bat" "%WINDIR%\System32" >NUL
echo @echo off > "%WINDIR%\System32\cd-wclone.bat"
echo cd %cd% >> "%WINDIR%\System32\cd-wclone.bat"
echo. >> "%WINDIR%\System32\cd-wclone.bat"
if %errorlevel% neq 0 (
    echo [x] There was an error trying to autoconf wclone, aborted ...
    echo.
    exit /b
) else (
    echo [+] Autoconf was successful!
    echo.
    exit /b
)

:autoconfex
echo     ┌────────────────────────┐    
echo     │FranzeDigitalCodingGroup│    
echo     └────────────────────────┘    
echo Copyright ^(c^), All Rights Reserved
echo.
echo [x] Autoconf has already been ran
echo.
exit /b

:clearconf
if NOT EXIST "%WINDIR%\System32\wclone.conf" (
    goto clearconfex
)
goto clearpro


:clearpro
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo wclone: [31;1merror[0m: This operation requires administrative privileges.
    echo.
    exit /b
)
del /Q "%WINDIR%\System32\wclone.conf"
del /Q "%WINDIR%\System32\wclone.bat"
del /Q "%WINDIR%\System32\cd-wclone.bat"
if %errorlevel% neq 0 (
    echo [x] There was an error trying to clear the autoconf, aborted ...
    echo.
    exit /b
) else (
    echo     ┌────────────────────────┐    
    echo     │FranzeDigitalCodingGroup│    
    echo     └────────────────────────┘    
    echo Copyright ^(c^), All Rights Reserved
    echo.
    echo [+] Clearing autoconf was successful!
    echo.
    exit /b
)

:clearconfex
echo     ┌────────────────────────┐    
echo     │FranzeDigitalCodingGroup│    
echo     └────────────────────────┘    
echo Copyright ^(c^), All Rights Reserved
echo.
echo [x] Autoconf has not yet been ran ...
echo.
exit /b

:wclonehelp
echo ┌──────────────────┐
echo │  [92;1mwclone project[0m  │
echo └──────────────────┘
echo (c) 2025 FranzeDigitalCodingGroup
echo.
echo Usage for wclone:
echo wclone [-f, --wclone, --about, --credits, --auto/clear/refreshconf, --help] "<FILE>" [-c, -d, -u] ^<OUTPUT FILE^>
echo.
echo -f              Tell wclone that you want to use wclone on a file
echo --wclone        Displays information about the current wclone build
echo --about         Displays information about wclone as a program
echo --credits       Displays the credits of the wclone creators
echo --autoconf      Let wclone automatically configure itself
echo --clearconf     Reverts autoconfing wclone on your system (do this in the main wclone folder!)
echo --refreshconf   Refreshes the autoconf of wclone (do this in the main wclone folder!)
echo --help          Displays this message
echo.
echo ^<FILE^>          Tells wclone where the file is that you want to use wclone on (put this part between quotation marks!)
echo -c              Tells wclone that you want to clone the file
echo -d              Tells wclone that you want to delete the file
echo -u              Tells wclone that you want to unzip this file
echo ^<OUTPUT FILE^>   Sets the name of the output file (only use this if you clone a file)
echo.
echo cd-wclone       Automatically sets your current directory to the main folder of wclone (only possible after running autoconf!)
echo.
echo [33mNOTE[0m: If you don't run commands such as --clear- and --refreshconfig inside the main wclone folder, you will get errors.
echo.
exit /b

:refreshconf
if NOT EXIST "%WINDIR%\System32\wclone.conf" (
    goto clearconfex
)
goto refreshpro

:refreshpro
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo wclone: [31;1merror[0m: This operation requires administrative privileges.
    echo.
    exit /b
)
del /Q "%WINDIR%\System32\wclone.conf"
del /Q "%WINDIR%\System32\wclone.bat"
)
del /Q "%WINDIR%\System32\cd-wclone.bat"
if %errorlevel% neq 0 (
    echo [x] There was an error trying to refresh the autoconf, aborted ...
    echo.
    exit /b
) else (
    echo     ┌────────────────────────┐    
    echo     │FranzeDigitalCodingGroup│    
    echo     └────────────────────────┘    
    echo Copyright ^(c^), All Rights Reserved
    echo.
    echo [+] Clearing autoconf was successful!
    echo cnf, CONF (runmode autoCONF) > "%WINDIR%\System32\wclone.conf"
    copy "wclone.bat" "%WINDIR%\System32" >NUL
    echo @echo off > "%WINDIR%\System32\cd-wclone.bat"
    echo cd %cd% >> "%WINDIR%\System32\cd-wclone.bat"
    echo. >> "%WINDIR%\System32\cd-wclone.bat"
    if %errorlevel% neq 0 (
    echo [x] There was an error trying to autoconf wclone, aborted ...
    echo.
    exit /b
) else (
    echo [+] Refreshing the autoconf was successful!
    echo.
    exit /b
)
)

:: END OF wclone
:: wclone project (c) 2025 FranzeDigitalCodingGroup, All Rights Reserved. Do not redistribute!