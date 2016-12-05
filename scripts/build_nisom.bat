echo off
call :normalise "%~dp0\.."
set cur_dir=%cd%

set build_dir=%src_dir%-build\nisom
set install_dir=%src_dir%-install\nisom

if "%1"=="cmake" GOTO cmake
if "%1"=="build" GOTO build

set options=-DCHANGE_G3LOG_DEBUG_TO_DBUG=ON -DENABLE_FATAL_SIGNALHANDLING=OFF -DENABLE_VECTORED_EXCEPTIONHANDLING=ON -DUSE_DYNAMIC_LOGGING_LEVELS=ON 

:cmake

@RD /s /q %build_dir% 

rem Re-make the directories
mkdir %src_dir%-build
mkdir %build_dir%

call :create_build_dir RelWithDebInfo
call :create_build_dir Debug

:build

cd %build_dir%\RelWithDebInfo
make install
cd %build_dir%\Debug
make install

goto cleanup

:normalise
SET "src_dir=%~f1"
goto :eof

:create_build_dir
echo --
echo -- Creating %1 build directory in '%build_dir%\%1'
mkdir %build_dir%\%1
cmake %src_dir% -DCMAKE_INSTALL_PREFIX=%install_dir% -DCMAKE_INSTALL_PREFIX=%install_dir%\%1 %options% -DCMAKE_TOOLCHAIN_FILE="%src_dir%\scripts\CMakeToolchainNISOM.cmake" -DCMAKE_BUILD_TYPE=%1 -B%build_dir%/%1 "-GMinGW Makefiles"
exit /b

:cleanup
cd %cur_dir%