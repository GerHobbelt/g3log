# ==========================================================================
# 2010 by KjellKod.cc. This is PUBLIC DOMAIN to use at your own risk and comes
# with no warranties. This code is yours to share, use and modify with no
# strings attached and no restrictions or obligations.
#
# For more information see g3log/LICENSE or refer refer to http://unlicense.org
# ============================================================================*/


# Below are details for compiling on Windows and Linux
# by default only an example g3log binary is created
# the performance and unit tests creation can be enabled by switching their
# OPTIONs from OFF to ON --- See below at around line 110

# === WINDOWS ===
# Example for: Visual Studio 2013 (earlier should work too)
# 1. please use the "Visual Studio Command Prompt 12 (2013)"
# 2. from the g3log folder
#    mkdir build
#    cd build;
# 3. cmake -DCMAKE_BUILD_TYPE=Release -G "Visual Studio XXX" ..
#     (cmake -DCMAKE_BUILD_TYPE=Release -G "Visual Studio 12")
#    (XXX is the Visual Studio version you are running)
# 4. msbuild g3log.sln /p:Configuration=Release
#
# Try to run an example, such as:
# 5. Release\g3log-FATAL-contract.exe
#
#

# ===   LINUX: === To try this out from folder g3log:
#    mkdir build
#    cd build
# >> create makefiles in g3log/build directory
#   cmake -DCMAKE_BUILD_TYPE=Release ..
#    make -jN   (where N stands for number of cores you want to utilize)
#
#
#
# ===  Clang on Linux ===
#   From g3log
#   mkdir build && cd build
#   cmake -DCMAKE_CXX_COMPILER=clang++ ..
#   if you want to double-check settings:   "VERBOSE=1 make"
#   otherwise just run:   "make -j"
#
# ============================================================================

cmake_minimum_required (VERSION 3.1)
ENABLE_LANGUAGE(CXX)
if( POLICY CMP0054 )
	cmake_policy(SET CMP0054 NEW)
endif()

# set(CMAKE_BUILD_TYPE Release)

project (g3log)
set( g3log_version "1.2.0.2" )

set( MSVC_KNOWN_VERSIONS
	1000=4.x
	1100=5.0
	1200=6.0
	1300=7.0
	1310=7.1
	1400=8.0
	1500=9.0
	1600=10.0
	1700=11.0
	1800=12.0
	1900=14.0
	1910=15.0
)
		
# Detect 64 or 32 bit
if (CMAKE_SIZEOF_VOID_P EQUAL 8)
   # 64-bit project
   SET(64_BIT_OS TRUE)
   MESSAGE(STATUS "A 64-bit OS detected")
 else()
   SET(64_BIT_OS FALSE)
   MESSAGE(STATUS "A 32-bit OS detected")
endif()

if( NOT WIN32 )
   SET(CMAKE_INSTALL_LIBDIR lib CACHE PATH "Output dir for libraries")
   SET(CMAKE_INSTALL_HEADERDIR include CACHE PATH "Output dir for headers")
else()
	set( MSVC_VER "" )
	# Only accept the exact version for headers and libraries
	foreach( version ${MSVC_KNOWN_VERSIONS} )
		if( MSVC_VERSION AND ${version} MATCHES "^${MSVC_VERSION}=" )
			string( REGEX REPLACE "^([0-9]+)=([0-9\.]+)$" "-\\2" MSVC_VER ${version} )
			break()
		endif()
	endforeach()

	if( 64_BIT_OS )
		set( CXXVER "${CMAKE_CXX_COMPILER_ID}-64${MSVC_VER}/g3log/g3log-${g3log_version}" )
	else()
		set( CXXVER "${CMAKE_CXX_COMPILER_ID}-32${MSVC_VER}/g3log/g3log-${g3log_version}" )
	endif()
	
   message( STATUS "Install location: ${g3log_SOURCE_DIR}-install/${CXXVER}")
   SET(CMAKE_INSTALL_LIBDIR "${g3log_SOURCE_DIR}-install/${CXXVER}/lib/$<CONFIG>" CACHE PATH "Output dir for libraries")
   SET(CMAKE_INSTALL_HEADERDIR "${g3log_SOURCE_DIR}-install/${CXXVER}/include" CACHE PATH "Output dir for headers")
endif()


   # ============================================================================
   # G3LOG OPTIONAL FEATURES
   # ============================================================================
   INCLUDE (${g3log_SOURCE_DIR}/Options.cmake)


   # =========================================================================
   # G3 Macro definitions in Options.cmake are written to file
   #    this avoids having to re-state your definitions in your source code
   #    or compile options
   #==========================================================================
   INCLUDE (${g3log_SOURCE_DIR}/GenerateMacroDefinitionsFile.cmake)

   option (ADD_BUILD_WIN_SHARED  "Build shared library on Windows" OFF)

   # =========================================================================
   # G3LOG BUILD
   #==========================================================================
   INCLUDE (${g3log_SOURCE_DIR}/Build.cmake)



   # ============================================================================
   # EXAMPLE OPTIONS: By defauls is ON. This will create 'g3log-FATAL-* examples'
   # ============================================================================
   # DISABLE WITH:  -DADD_FATAL_EXAMPLE=OFF
   INCLUDE (${g3log_SOURCE_DIR}/example/Example.cmake)



   # ============================================================================
   # PERFORMANCE TEST OPTIONS: Performance operations for g3log
   # ============================================================================
   # ENABLE WITH:  -DADD_G3LOG_PERFORMANCE=ON
   INCLUDE (${g3log_SOURCE_DIR}/test_performance/Performance.cmake)



   # ==========================================================================
   # UNIT TEST OPTIONS:
   # ============================================================================
   # ENABLE WITH:  -DADD_G3LOG_UNIT_TEST=ON
   INCLUDE (${g3log_SOURCE_DIR}/test_unit/Test.cmake)


if( WIN32 AND G3LOG_SHARED_LIBRARY )
   install( PROGRAMS $<TARGET_PDB_FILE:g3logger_shared>
		DESTINATION "${CMAKE_INSTALL_LIBDIR}"
		COMPONENT libraries
	)
endif()

INSTALL( TARGETS g3logger ${G3LOG_SHARED_LIBRARY}
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
		RUNTIME DESTINATION ${CMAKE_INSTALL_LIBDIR}
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
		COMPONENT libraries)

INSTALL( FILES ${HEADER_FILES}
		DESTINATION ${CMAKE_INSTALL_HEADERDIR}/g3log
		COMPONENT headers)

IF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
   # ==========================================================================
   # BETA : package manager for G3Log,. not yet reliable. Use at your own risk
   #        only tested on Ubuntu and CentOS
   #
   #        For OSX you can install an older version using 'brew install'
   #
   # ==========================================================================
   #   Package handling is done AFTER all other CMake setup
   #   usage:   make package
   #   Check the output result and install accordingly.
   # ==========================================================================
   INCLUDE (${g3log_SOURCE_DIR}/CPackLists.txt)
ENDIF()


IF (NOT MSVC)
   MESSAGE(STATUS "\n\n
      *******************************************************************
      Please do 'make clean-cmake' before next cmake generation.
         It is a good idea to purge your build directory of CMake
         generated cache files
      *******************************************************************
       ")
   add_custom_target(clean-cmake
      COMMAND ${CMAKE_COMMAND} -P ${g3log_SOURCE_DIR}/CleanAll.cmake
   )
ENDIF()





