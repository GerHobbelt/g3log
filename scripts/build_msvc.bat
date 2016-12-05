@echo off

call :normalise "%~dp0\.."
set cur_dir=%cd%

set build32=%src_dir%-build\VisualStudio14\win32
set build64=%src_dir%-build\VisualStudio14\win64

if "%1"=="cmake" GOTO cmake
if "%1"=="build" GOTO build

:cmake

rd /S /Q %src_dir%-build\VisualStudio14

mkdir %src_dir%-build
mkdir %src_dir%-build\VisualStudio14
mkdir %build32%
mkdir %build64%

set options=-DCHANGE_G3LOG_DEBUG_TO_DBUG=ON -DENABLE_WIN_WSTRING_SUPPPORT=ON -DENABLE_FATAL_SIGNALHANDLING=OFF -DENABLE_VECTORED_EXCEPTIONHANDLING=ON -DUSE_DYNAMIC_LOGGING_LEVELS=ON -DADD_BUILD_WIN_SHARED=ON
cd %build32%
cmake -G "Visual Studio 14" %options% %src_dir%
cd %build64%
cmake -G "Visual Studio 14 Win64" %options% %src_dir%

:build

call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\vsvars32.bat"

cd %build32%
msbuild INSTALL.vcxproj /p:Configuration=Debug
msbuild INSTALL.vcxproj /p:Configuration=RelWithDebInfo

:build64

cd %build64%
msbuild INSTALL.vcxproj /p:Configuration=Debug
msbuild INSTALL.vcxproj /p:Configuration=RelWithDebInfo

goto cleanup

:normalise
SET "src_dir=%~f1"
goto :eof

:cleanup
cd %cur_dir%