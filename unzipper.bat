@echo off
call :ProZip
pause

:ProZip
SETLOCAL EnableDelayedExpansion
call :renameNoSpace
(for %%a in (*.zip) do (
   echo %%a
   set xx= %%~na
   mkdir !xx!
   tar -xf %%a -C !xx!
   del %%a
   cd !xx!
   call :ProZip
   cd ..
))
powershell -command "Get-ChildItem -File | Rename-Item -NewName { $_.BaseName.Replace('+',' ') + $_.Extension }"
ENDLOCAL
EXIT /B 0

:renameNoSpace  [/R]  [FolderPath]
setlocal disableDelayedExpansion
if /i "%~1"=="/R" (
  set "forOption=%~1 %2"
  set "inPath="
) else (
  set "forOption="
  if "%~1" neq "" (set "inPath=%~1\") else set "inPath="
)
for %forOption% %%F in ("%inPath%* *") do (
  if /i "%~f0" neq "%%~fF" (
    set "folder=%%~dpF"
    set "file=%%~nxF"
    setlocal enableDelayedExpansion
    echo ren "!folder!!file!" "!file: =!"
    ren "!folder!!file!" "!file: =!"
    endlocal
  )
)