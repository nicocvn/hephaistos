# ---------------------------------------------------------------------------- #
# CMake Hephaistos::CompilerSetup
#
# Nicolas Clauvelin (n.clauvelin+code@gmail.com)
# nicocvn.com, 2017
#
#
# MODULE:   Hephaistos
#
# PROVIDES:
#
#   heph_compiler_setup([QUIET])
#
#       This command sets the compiler flags for the various build types. It
#       always enforce C++11 and C99 standards.
#
#       The following setups are currently supported:
#           PLATFORM            COMPILER
#           Unix                GCC (requires a recent version >= 6)
#           OS X                Clang, GCC (recent version required >= 6)
#           Windows             MSVC, GCC (e.g., using MinGW64)
#           ARM bare metal      GCC
#           C2000 bare metal    TI CGT
#
#       Refer to the files in compilers_support/ for details about the flags.
#
#       For ARM setups, an additional argument is required to indicated the
#       CPU type.
#       Currently supported: M0+, M4
#
# ---------------------------------------------------------------------------- #


# CMake minimum version and dependencies.
cmake_minimum_required(VERSION 3.8)
include(${CMAKE_CURRENT_LIST_DIR}/SysConfig.cmake)


# Store script location.
set(_CompilerSetupDir "${CMAKE_CURRENT_LIST_DIR}")


# Compiler setup function.
function(heph_setup_compiler)

    # Get platform and compiler ids.
    set(PlatformIdentity "")
    set(CompilerIdentity "")
    heph_platform_id(PLATFORM PlatformIdentity)
    heph_compiler_id(COMPILER CompilerIdentity)

    # Below we load the corresponding compiler flags.

    # Unix / GCC flags.
    # If the compiler is not GCC we do not touch anything.
    if (${PlatformIdentity} STREQUAL "Unix"
        AND ${CompilerIdentity} STREQUAL "GCC")
        message(STATUS
                "HEPHAISTOS:: Loading compiler flags for Unix + GCC")
        include(${_CompilerSetupDir}/compilers_support/LinuxUnix_GCC.cmake)
        return()
    endif ()

    # macOS.
    if (${PlatformIdentity} STREQUAL "macOS")

        # GCC compiler.
        if (${CompilerIdentity} STREQUAL "GCC")
            message(STATUS
                    "HEPHAISTOS:: Loading compiler flags for macOS + GCC")
            include(${_CompilerSetupDir}/compilers_support/OSX_GCC.cmake)
            return()
        endif ()

        # Clang compiler.
        if (${CompilerIdentity} STREQUAL "Clang")
            message(STATUS
                    "HEPHAISTOS:: Loading compiler flags for macOS + Clang")
            include(${_CompilerSetupDir}/compilers_support/OSX_Clang.cmake)
            return()
        endif ()

    endif ()

    # Windows.
    if (${PlatformIdentity} STREQUAL "Windows")

        # MSVC.
        if (${CompilerIdentity} STREQUAL "MSVC")
            message(STATUS
                    "HEPHAISTOS:: Loading compiler flags for Windows + MSVC")
            include(${_CompilerSetupDir}/compilers_support/Windows_MSVC.cmake)
            return()
        endif ()

        # GCC.
        if (${CompilerIdentity} STREQUAL "GCC")
            message(STATUS
                    "HEPHAISTOS:: Loading compiler flags for Windows + GCC")
            include(${_CompilerSetupDir}/compilers_support/Windows_GCC.cmake)
            return()
        endif ()

    endif ()

    # ARM bare metal.
    if (${PlatformIdentity} STREQUAL "arm_bare")

        # Hardware specifics flags
        set(ARM_CORTEX ${ARGV})
        if (${ARM_CORTEX} STREQUAL "")
            message(FATAL_ERROR
                    "HEPHAISTOS:: For ARM+GCC the CPU type is required to be defined by the ARM_CORTEX option")
        endif ()
        message(STATUS
                "HEPHAISTOS:: Loading compiler flags for ARM + GCC")
        message(STATUS
            "HEPHAISTOS:: ${ARM_CORTEX}")
        if ("${ARM_CORTEX}" STREQUAL "M4")
            message(STATUS "HEPHAISTOS:: Using ARM Cortex-M4 flags")
            include(${_CompilerSetupDir}/compilers_support/ARM_GCC_Cortex-M4.cmake)
        elseif ("${ARM_CORTEX}" STREQUAL "M0+")
            message(STATUS "HEPHAISTOS:: Using ARM Cortex-M0+ flags")
            include(${_CompilerSetupDir}/compilers_support/ARM_GCC_Cortex-M0+.cmake)
        else ()
            message(FATAL_ERROR
                    "HEPHAISTOS:: ARM_CORTEX invalid value")
        endif ()

        # Generic GCC ARM flags.
        include(${_CompilerSetupDir}/compilers_support/ARM_GCC.cmake)
        return()
        
    endif ()

    # C2000 bare metal.
    # if (IS_C2000_BM)
    #         message(STATUS
    #                 "HEPHAISTOS:: Loading compiler flags for C2000")
    #     include(${_CompilerSetupDir}/compilers_support/C2000.cmake)
    #     return()
    # endif ()

    # Default.
    message(STATUS
            "HEPHAISTOS:: Using default compiler flags")

endfunction()
