# ---------------------------------------------------------------------------- #
# CMake Hephaistos::CompilerSetup
#
# Nicolas Clauvelin (n.clauvelin+code@gmail.com)
# nicocvn.com, 2017
#
#
# MODULE:   Hephaistos
#
# PROVIDES:m
#
#   heph_compiler_setup([QUIET])
#
#       This command sets the compiler flags for the various build types. It
#       always enforce C++11 and C99 standards.
#
#       The following setups are currently supported:
#           PLATFORM            COMPILER
#           Linux/Unix          GCC (requires a recent version >5)
#           OS X                Clang, GCC (recent version required >5)
#           Windows             MSVC, GCC (using MinGW64)
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
cmake_minimum_required(VERSION 3.0)
include(CMakeParseArguments)


# Store script location.
set(_CompilerSetupDir "${CMAKE_CURRENT_LIST_DIR}")


# Compiler setup function.
function(heph_setup_compiler)

    # Define function interface.
    set(options QUIET)                      # Options.
    set(oneValueArgs "")                    # None.
    set(multiValueArgs "")                  # None.

    # Parse arguments.
    cmake_parse_arguments(COMPSET_ARGS
                          "${options}"
                          "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN})

    # The first step is to identify the platform and possibly the compiler.
    # For regular operating systems it is rather easy; for embedded platforms
    # we check the processor type.
    set(IS_UNIX FALSE)
    set(IS_OSX FALSE)
    set(IS_WINDOWS FALSE)
    set(IS_ARM_BM FALSE)
    set(IS_C2000_BM FALSE)
    if (UNIX AND NOT APPLE) # OS X is an Unix so we discriminate here.
        set(IS_UNIX TRUE)
        set(IS_OSX FALSE)
    endif ()
    if (APPLE)
        set(IS_UNIX FALSE)
        set(IS_OSX TRUE)
    endif ()
    if (WIN32)
        set(IS_WINDOWS TRUE)
    endif ()
    if (${CMAKE_SYSTEM_PROCESSOR} STREQUAL "arm")
        set(IS_ARM_BM TRUE)
    endif ()
    if (${CMAKE_SYSTEM_PROCESSOR} STREQUAL "C2000")
        set(IS_C2000_BM TRUE)
    endif ()

    # Compiler identification.
    set(IS_GCC FALSE)
    set(IS_CLANG FALSE)
    set(IS_MSVC FALSE)
    if (${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU" AND
        ${CMAKE_C_COMPILER_ID} STREQUAL "GNU")
        set(IS_GCC TRUE)
    endif ()
    if (${CMAKE_CXX_COMPILER_ID} MATCHES "Clang" AND
        ${CMAKE_C_COMPILER_ID} MATCHES "Clang")
        set(IS_CLANG TRUE)
    endif ()
    if (MSVC)
        set(IS_MSVC TRUE)
    endif ()

    # Below we load the corresponding compiler flags.

    # Linux / GCC flags.
    # If the compiler is not GCC we do not touch anything.
    if (IS_UNIX AND IS_GCC)
        if (NOT COMPSET_ARGS_QUIET)
            message(STATUS
                    "HEPHAISTOS:: Loading compiler flags for Linux/Unix + GCC")
        endif ()
        include(${_CompilerSetupDir}/compilers_support/LinuxUnix_GCC.cmake)
        return()
    endif ()

    # OS X.
    if (IS_OSX)

        # GCC compiler.
        if (IS_GCC)
            if (NOT COMPSET_ARGS_QUIET)
                message(STATUS
                        "HEPHAISTOS:: Loading compiler flags for OSX + GCC")
            endif ()
            include(${_CompilerSetupDir}/compilers_support/OSX_GCC.cmake)
            return()
        endif ()

        # Clang compiler.
        if (IS_CLANG)
            if (NOT COMPSET_ARGS_QUIET)
                message(STATUS
                        "HEPHAISTOS:: Loading compiler flags for OSX + Clang")
            endif ()
            include(${_CompilerSetupDir}/compilers_support/OSX_Clang.cmake)
            return()
        endif ()

    endif ()

    # Windows.
    if (IS_WINDOWS)

        # MSVC.
        if (IS_MSVC)
            if (NOT COMPSET_ARGS_QUIET)
                message(STATUS
                        "HEPHAISTOS:: Loading compiler flags for Windows + MSVC")
            endif ()
            include(${_CompilerSetupDir}/compilers_support/Windows_MSVC.cmake)
            return()
        endif ()

        # GCC.
        if (IS_GCC)
            if (NOT COMPSET_ARGS_QUIET)
                message(STATUS
                        "HEPHAISTOS:: Loading compiler flags for Windows + GCC")
            endif ()
            include(${_CompilerSetupDir}/compilers_support/Windows_GCC.cmake)
            return()
        endif ()

    endif ()

    # ARM bare metal.
    if (IS_ARM_BM)
        set(ARM_CORTEX ${ARGV})
        if (NOT COMPSET_ARGS_QUIET)
            message(STATUS
                    "HEPHAISTOS:: Loading compiler flags for ARM + GCC")
            message(STATUS
                "HEPHAISTOS:: ${ARM_CORTEX}")
        endif ()
        if (${ARM_CORTEX} STREQUAL "")
            message(FATAL_ERROR
                    "HEPHAISTOS:: For ARM+GCC the CPU type is required to be defined by the ARM_CORTEX option")
        endif ()
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
        include(${_CompilerSetupDir}/compilers_support/ARM_GCC.cmake)
        return()
    endif ()

    # C2000 bare metal.
    if (IS_C2000_BM)
        if (NOT COMPSET_ARGS_QUIET)
            message(STATUS
                    "HEPHAISTOS:: Loading compiler flags for C2000")
        endif ()
        include(${_CompilerSetupDir}/compilers_support/C2000.cmake)
        return()
    endif ()

    # Default.
    if (NOT COMPSET_ARGS_QUIET)
        message(STATUS
                "HEPHAISTOS:: Using default compiler flags")
    endif ()

endfunction()
