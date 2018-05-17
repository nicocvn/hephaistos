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
#   heph_compiler_setup([ARM_ARCH mcu_flavor])
#
#       This command sets the compiler flags for the various build types. It
#       always enforce C++11 and C99 standards.
#
#       The following setups are currently supported:
#           PLATFORM            COMPILER
#           Unix                GCC (requires a recent version >= 6)
#           OS X                Clang, GCC (recent version required >= 6)
#           Windows             MSVC, GCC (using MinGW64)
#           ARM bare metal      GCC
#
#       Refer to the files in compilers_support/ for details about the flags.
#
#       For ARM setups, the argument ARM_ARCH should be set to one of:
#       "M4", "M0+"
#
# ---------------------------------------------------------------------------- #


# CMake minimum version and dependencies.
cmake_minimum_required(VERSION 3.8)
include(${CMAKE_CURRENT_LIST_DIR}/SysConfig.cmake)


# Store script location.
set(_CompilerSetupDir "${CMAKE_CURRENT_LIST_DIR}")


# Compiler setup function.
function(heph_setup_compiler)

    # Define function interface.
    set(options NO_AVX CPP14 CPP17)
    set(oneValueArgs ARM_ARCH)
    set(multiValueArgs "")

    # Parse function arguments.
    cmake_parse_arguments(HEPH_COMPILER_ARGS
                          "${options}"
                          "${oneValueArgs}"
                          "${multiValueArgs}"
                          ${ARGN})

    # Get platform and compiler ids.
    set(PlatformIdentity "")
    set(CompilerIdentity "")
    heph_platform_id(PLATFORM PlatformIdentity)
    heph_compiler_id(COMPILER CompilerIdentity)

    # Check the NO_AVX option.
    set(DISABLE_AVX OFF)
    if (HEPH_COMPILER_ARGS_NO_AVX)
        message(STATUS
                "HEPHAISTOS:: AVX/AVX2 instructions disabled")
        set(DISABLE_AVX ON)
    endif ()

    # Set language standards.
    if (HEPH_COMPILER_ARGS_CPP14)
        message(STATUS
                "HEPHAISTOS:: Using C++14 standard")
        set(CMAKE_CXX_STANDARD 14 PARENT_SCOPE)
    elseif (HEPH_COMPILER_ARGS_CPP17)
        message(STATUS
                "HEPHAISTOS:: Using C++17 standard")
        set(CMAKE_CXX_STANDARD 17 PARENT_SCOPE)
    else ()
        message(STATUS
                "HEPHAISTOS:: Using C++11 standard")
        set(CMAKE_CXX_STANDARD 11 PARENT_SCOPE)
    endif ()
    set(CMAKE_C_STANDARD 99 PARENT_SCOPE)
    set(CMAKE_C_STANDARD_REQUIRED TRUE PARENT_SCOPE)
    set(CMAKE_CXX_STANDARD_REQUIRED TRUE PARENT_SCOPE)

    # Below we load the corresponding compiler flags.

    # Unix / GCC flags.
    # If the compiler is not GCC we do not touch anything.
    if (PlatformIdentity STREQUAL "Unix"
        AND CompilerIdentity STREQUAL "GCC")
        message(STATUS
                "HEPHAISTOS:: Loading compiler flags for Unix + GCC")
        include(${_CompilerSetupDir}/compilers_support/LinuxUnix_GCC.cmake)
        return()
    endif ()

    # macOS.
    if (PlatformIdentity STREQUAL "macOS")

        # GCC compiler.
        if (CompilerIdentity STREQUAL "GCC")
            message(STATUS
                    "HEPHAISTOS:: Loading compiler flags for macOS + GCC")
            include(${_CompilerSetupDir}/compilers_support/OSX_GCC.cmake)
            return()
        endif ()

        # Clang compiler.
        if (CompilerIdentity STREQUAL "Clang")
            message(STATUS
                    "HEPHAISTOS:: Loading compiler flags for macOS + Clang")
            include(${_CompilerSetupDir}/compilers_support/OSX_Clang.cmake)
            return()
        endif ()

    endif ()

    # Windows.
    if (PlatformIdentity STREQUAL "Windows")

        # MSVC.
        if (CompilerIdentity STREQUAL "MSVC")
            message(STATUS
                    "HEPHAISTOS:: Loading compiler flags for Windows + MSVC")
            include(${_CompilerSetupDir}/compilers_support/Windows_MSVC.cmake)
            return()
        endif ()

        # GCC.
        if (CompilerIdentity STREQUAL "GCC")
            message(STATUS
                    "HEPHAISTOS:: Loading compiler flags for Windows + GCC")
            include(${_CompilerSetupDir}/compilers_support/Windows_GCC.cmake)
            return()
        endif ()

    endif ()

    # ARM bare metal.
    if (PlatformIdentity STREQUAL "arm_bare")

        # Warning about NO_AVX.
        if (HEPH_COMPILER_ARGS_NO_AVX)
            message(STATUS
                    "HEPHAISTOS:: NO_AVX has no effects with GCC ARM.")
        endif ()

        # Hardware specifics flags
        if (HEPH_COMPILER_ARGS_ARM_ARCH STREQUAL "")
            message(FATAL_ERROR
                    "HEPHAISTOS:: For GCC ARM the MCU type is required to be defined by the ARM_ARCH argument")
        endif ()
        message(STATUS
                "HEPHAISTOS:: Loading compiler flags for ARM + GCC")
        if (HEPH_COMPILER_ARGS_ARM_ARCH STREQUAL "M4")
            message(STATUS "HEPHAISTOS:: Using ARM Cortex-M4 flags")
            include(${_CompilerSetupDir}/compilers_support/ARM_GCC_Cortex-M4.cmake)
        elseif (HEPH_COMPILER_ARGS_ARM_ARCH STREQUAL "M3")
            message(STATUS "HEPHAISTOS:: Using ARM Cortex-M3 flags")
            include(${_CompilerSetupDir}/compilers_support/ARM_GCC_Cortex-M3.cmake)
        elseif (HEPH_COMPILER_ARGS_ARM_ARCH STREQUAL "M0+")
            message(STATUS "HEPHAISTOS:: Using ARM Cortex-M0+ flags")
            include(${_CompilerSetupDir}/compilers_support/ARM_GCC_Cortex-M0+.cmake)
        else ()
            message(FATAL_ERROR
                    "HEPHAISTOS:: ARM_ARCH unsupported value: ${HEPH_COMPILER_ARGS_ARM_ARCH}")
        endif ()

        # Generic GCC ARM flags.
        include(${_CompilerSetupDir}/compilers_support/ARM_GCC.cmake)
        return()
        
    endif ()

    # Default.
    message(STATUS
            "HEPHAISTOS:: Using default compiler flags")

endfunction()
