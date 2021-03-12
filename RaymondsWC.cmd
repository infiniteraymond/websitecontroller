@ECHO OFF
title Raymond's Website Controller
rem We gotta make sure that Heroku is installed. Otherwise it won't work.
:CheckForDependencies
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Checking dependencies..
WHERE heroku >nul 2>nul
IF %ERRORLEVEL% NEQ 0 goto PromptHerokuInstallation
WHERE git >nul 2>nul
IF %ERRORLEVEL% NEQ 0 goto PromptGitInstallation

rem This is where it actually starts lol

:StartingPage
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Welcome!
echo.
echo c: New project
echo p: Open existing project
echo i: Info about Raymond's WC
choice /c cpl /n >nul
if %errorlevel%==1 goto CreateNewProject
if %errorlevel%==2 goto OpenProject
if %errorlevel%==3 goto RaymondsWCInfo

:CreateNewProject
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Create new project
echo.
echo Press enter to open the app creation page,
echo Create a new app,
echo and type the name of it below.
echo.
pause >nul
start "Create New App | Heroku" "https://dashboard.heroku.com/new-app"
set /p AppName="App Name: "
if exist %UserProfile%\Documents\%AppName%\ (
echo This project already exists!
echo Open it, instead of creating it.
pause >nul
goto StartingPage
) else (
goto CreateNewProject2
)

:CreateNewProject2
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Creating new project, please wait!
mkdir %UserProfile%\Documents\%AppName%
cd %UserProfile%\Documents\%AppName%
echo Creating git repository and connecting to Heroku..
git init
heroku git:remote -a %AppName%
echo.
echo Press enter to close Raymond's WC, reopen it and load your new app!
pause >nul
exit 

:OpenProject
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Which project would you like to open?
echo Type "home" to go back.
set /p AppName="App Name: "
if "%AppName%"=="home" goto StartingPage
if exist %UserProfile%\Documents\%AppName%\ (
echo Opening %AppName%!
start cmd /k "cd %UserProfile%\Documents\%AppName% & heroku git:remote -a %AppName% & exit"
goto ControlPanel
) else (
echo %AppName% doesn't exist as a project on this computer.
pause >nul
goto OpenProject
)

:ControlPanel 
cd %UserProfile%\Documents\%AppName%
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Control Panel for %AppName%
echo.
echo Tip: It's recommended to use .php files for your site or it may not work.
echo.
echo a: Add files
echo c: Commit Changes
echo e: Open site in File Explorer
echo o: Open site in Web Browser
choice /c aceo /n >nul
if %errorlevel%==1 goto AddFilesToApp
if %errorlevel%==2 goto CommitAppChanges
if %errorlevel%==3 start "%SystemRoot%\explorer.exe" "%UserProfile%\Documents\%AppName%\"
if %errorlevel%==4 start "" "https://%AppName%.herokuapp.com/"
goto ControlPanel

:AddFilesToApp
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Add files to %AppName%
echo.
echo Type the directory of files to add:
echo (eg: index.html , api/, api/index.html)
set /p FilesToAdd="App Name: "
echo Uploading.. please wait.
start cmd /k "cd %UserProfile%\Documents\%AppName% & git add %FilesToAdd% & exit"
pause >nul
goto ControlPanel

:CommitAppChanges
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Committing changes for %AppName%
echo This will take a minute.
echo.
git commit -am "Uploading changes"
timeout 1 >nul
git push heroku master
pause >nul
goto ControlPanel

:RaymondsWCInfo
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Information
echo.
echo Raymond's WC is an advanced command-line based program
echo  created to help make small applications.
echo.
echo Dependencies
echo.
echo   - Heroku CLI*
echo   - Git
echo.
echo * Will prompt to install it.
pause >nul
goto StartingPage

rem Here is where all installations are started

:PromptHerokuInstallation
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo The Heroku CLI isn't installed.
echo Would you like to install it now?
echo (Y/N)
choice /c yn /n >nul
if %errorlevel%==1 goto HerokuInstallation
if %errorlevel%==2 goto HerokuIsNotInstalled

:PromptGitInstallation
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Git isn't installed.
echo Would you like to install it now?
echo (Y/N)
choice /c yn /n >nul
if %errorlevel%==1 goto GitInstallation
if %errorlevel%==2 goto GitIsNotInstalled

:HerokuInstallation
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo This will take a minute. Please wait.
timeout 2 >nul
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
if %OS%==32BIT goto 32BitHerokuInstallation
if %OS%==64BIT goto 64BitHerokuInstallation

:GitInstallation
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo This will take a minute. Please wait.
timeout 2 >nul
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
if %OS%==32BIT goto 32BitGitInstallation
if %OS%==64BIT goto 64BitGitInstallation

:32BitGitInstallation
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Downloading 32-bit installer..
C:\Windows\System32\bitsadmin.exe /transfer "JobName" https://github.com/git-for-windows/git/releases/download/v2.30.2.windows.1/Git-2.30.2-32-bit.exe %temp%\GitInstaller.exe >nul
goto StartGitInstaller

:64BitGitInstallation
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Downloading 64-bit installer..
C:\Windows\System32\bitsadmin.exe /transfer "JobName" https://github.com/git-for-windows/git/releases/download/v2.30.2.windows.1/Git-2.30.2-64-bit.exe %temp%\GitInstaller.exe >nul
goto StartGitInstaller

:32BitHerokuInstallation
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Downloading 32-bit installer..
C:\Windows\System32\bitsadmin.exe /transfer "JobName" https://cli-assets.heroku.com/heroku-x86.exe %temp%\HerokuInstaller.exe >nul
goto StartHerokuInstaller

:64BitHerokuInstallation
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Downloading 64-bit installer..
C:\Windows\System32\bitsadmin.exe /transfer "JobName" https://cli-assets.heroku.com/heroku-x64.exe %temp%\HerokuInstaller.exe >nul
goto StartHerokuInstaller

:StartHerokuInstaller
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Please follow the prompts you will see on-screen in a few seconds,
echo and then re-launch Raymond's WC!
timeout 3 >nul
start "Heroku Installer" "%temp%\HerokuInstaller.exe"
exit

:StartGitInstaller
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Please follow the prompts you will see on-screen in a few seconds,
echo and then re-launch Raymond's WC!
timeout 3 >nul
start "Git Installer" "%temp%\GitInstaller.exe"
exit

:HerokuIsNotInstalled
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo The Heroku CLI is required to use Raymond's WC.
echo Sorry to see you go!
echo (ENTER)
pause >nul
exit

:GitIsNotInstalled
cls
echo     [                   ]
echo     [    Raymond's WC   ]
echo     [                   ]
echo.
echo Git is required to use Raymond's WC.
echo Sorry to see you go!
echo (ENTER)
pause >nul
exit
