@echo off

set build32=%~dp0\g3log-build\VisualStudio14\win32
set build64=%~dp0\g3log-build\VisualStudio14\win64

if "%1"=="cmake" GOTO cmake
if "%1"=="build" GOTO build

:cmake

rd /S /Q %~dp0\g3log-build

mkdir %~dp0\g3log-build
mkdir %~dp0\g3log-build\VisualStudio14
mkdir %build32%
mkdir %build64%

set options=-DCHANGE_G3LOG_DEBUG_TO_DBUG=ON -DENABLE_WIN_WSTRING_SUPPPORT=ON -DENABLE_FATAL_SIGNALHANDLING=OFF -DENABLE_VECTORED_EXCEPTIONHANDLING=ON -DUSE_DYNAMIC_LOGGING_LEVELS=ON -DADD_BUILD_WIN_SHARED=ON
cd %build32%
cmake -G "Visual Studio 14" %options% %~dp0/g3log
cd %build64%
cmake -G "Visual Studio 14 Win64" %options% %~dp0/g3log

:build

call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\vsvars32.bat"

cd %build32%
msbuild INSTALL.vcxproj /p:Configuration=Debug
msbuild INSTALL.vcxproj /p:Configuration=RelWithDebInfo

:build64

cd %build64%
msbuild INSTALL.vcxproj /p:Configuration=Debug
msbuild INSTALL.vcxproj /p:Configuration=RelWithDebInfo

:cleanup
cd %~dp0