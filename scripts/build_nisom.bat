echo off
set cur_parent=%~dp0
set build_dir=%cur_parent%\g3log-build\nisom
set install_dir=%cur_parent%\g3log-install\nisom

if "%1"=="cmake" GOTO cmake
if "%1"=="build" GOTO build

set options=-DCHANGE_G3LOG_DEBUG_TO_DBUG=ON -DENABLE_FATAL_SIGNALHANDLING=OFF -DENABLE_VECTORED_EXCEPTIONHANDLING=ON -DUSE_DYNAMIC_LOGGING_LEVELS=ON 

:cmake

@RD /s /q %build_dir% 

rem Re-make the directories
mkdir %build_dir%

call :create_build_dir RelWithDebInfo
call :create_build_dir Debug

:build

cd %build_dir%\RelWithDebInfo
make install
cd %build_dir%\Debug
make install

cd %cur_parent%

goto :EOF

:create_build_dir
echo --
echo -- Creating %1 build directory in '%build_dir%\%1'
mkdir %build_dir%\%1
cmake %cur_parent%\g3log -DCMAKE_INSTALL_PREFIX=%install_dir% -DCMAKE_INSTALL_PREFIX=%install_dir%\%1 %options% -DCMAKE_TOOLCHAIN_FILE="%cur_parent%\CMakeToolchainNISOM.cmake" -DCMAKE_BUILD_TYPE=%1 -B%build_dir%/%1 "-GMinGW Makefiles"
exit /b