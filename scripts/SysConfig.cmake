# ---------------------------------------------------------------------------- #
# CMake Hephaistos::SysConfig
#
# Nicolas Clauvelin (n.clauvelin+code@gmail.com)
# nicocvn.com, 2017
#
#
# MODULE:   Hephaistos
#
# PROVIDES:
#
#   hep_platform_id(PLATFORM [variable])
#
#   hep_compiler_id(COMPILER [variable])
#
#
# ---------------------------------------------------------------------------- #


# CMake minimum version and dependencies.
cmake_minimum_required(VERSION 3.8)


# Store script location.
set(_SysConfigDir "${CMAKE_CURRENT_LIST_DIR}")


# Platform identification function.
#
# Returns:
# - macOS for macOS and Darwin-based operating systems.
# - Windows for Windows (any version).
# - Unix for Unix-like systems including Linux.
# - arm_bare for ARM bare metal systems.
function(heph_platform_id)

    # Define function interface.
    set(options "")
    set(oneValueArgs PLATFORM)
    set(multiValueArgs "")

    # Parse arguments.
    cmake_parse_arguments(PARSED_ARGS
                          "${options}"
                          "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN})

    # If no variable is passed to store the platform we flag an error.
    if (NOT PARSED_ARGS_PLATFORM)
        message(FATAL_ERROR
                "heph_platform_id PLATFORM argument is missing")
    endif ()

    # We now test the various platforms:
    # https://cmake.org/Wiki/CMake_Checking_Platform
    # We test APPLE prior to testing unix because macOS is also flagged as an
    # Unix.
    if (APPLE)
        set(${PARSED_ARGS_PLATFORM} "macOS" PARENT_SCOPE)
        message(STATUS
                "HEPHAISTOS:: platform identified as macOS")
        return ()
    endif ()
    if (WIN32)
        set(${PARSED_ARGS_PLATFORM} "Windows" PARENT_SCOPE)
        message(STATUS
                "HEPHAISTOS:: platform identified as Windows")
        return ()
    endif ()
    if (UNIX)
        set(${PARSED_ARGS_PLATFORM} "Unix" PARENT_SCOPE)
        message(STATUS
                "HEPHAISTOS:: platform identified as Unix")
        return ()
    endif ()

    # We add a few more tests for bare metal platforms.
    if (${CMAKE_SYSTEM_PROCESSOR} STREQUAL "arm"
        AND ${CMAKE_SYSTEM_NAME} STREQUAL "Generic")
        set(${PARSED_ARGS_PLATFORM} "arm_bare" PARENT_SCOPE)
        message(STATUS
                "HEPHAISTOS:: platform identified as arm_bare")
        return ()
    endif ()

endfunction()


# Compiler check function.
#
# Returns:
# - GCC for GCC-based compilers.
# - Clang for Clang-based compilers.
# - MSVC for Visual Studio compilers.
function(heph_compiler_id)

    # Define function interface.
    set(options "")
    set(oneValueArgs COMPILER)
    set(multiValueArgs "")

    # Parse arguments.
    cmake_parse_arguments(PARSED_ARGS
                          "${options}"
                          "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN})

    # If no variable is passed to store the platform we flag an error.
    if (NOT PARSED_ARGS_COMPILER)
        message(FATAL_ERROR
                "heph_check_compiler COMPILER argument is missing")
    endif ()

    # We now test the various compilers.
    if (${CMAKE_CXX_COMPILER_ID} MATCHES "Clang" AND
        ${CMAKE_C_COMPILER_ID} MATCHES "Clang")
        set(${PARSED_ARGS_COMPILER} "Clang" PARENT_SCOPE)
        message(STATUS
                "HEPHAISTOS:: compiler identified as Clang")
        return ()
    endif ()
    if (${CMAKE_CXX_COMPILER_ID} MATCHES "GNU" AND
        ${CMAKE_C_COMPILER_ID} MATCHES "GNU")
        set(${PARSED_ARGS_COMPILER} "GCC" PARENT_SCOPE)
        message(STATUS
                "HEPHAISTOS:: compiler identified as GCC")
        return ()
    endif ()
    if (MSVC)
        set(${PARSED_ARGS_COMPILER} "MSVC" PARENT_SCOPE)
        message(STATUS
                "HEPHAISTOS:: compiler identified as MSVC")
        return ()
    endif ()

endfunction()
