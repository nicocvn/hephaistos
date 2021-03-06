# ---------------------------------------------------------------------------- #
# CMake Hephaistos::ToolchainManager
#
# Nicolas Clauvelin (n.clauvelin+code@gmail.com)
# nicocvn.com, 2017
#
#
# MODULE:   Hephaistos
#
# PROVIDES:
#
#   heph_toolchain_diagnostic()
#
#       This commands outputs the settings for the current toolchain.
#
#
#   heph_setup_toolchain([TOOLCHAIN toolchainID])
#
#       This command sets up the toolchain to be used by the project. The
#       following supported toolchains are:
#           GCC ARM for bare metal projects     GCC_ARM_BAREMETAL
#           GCC on OS X using Homebrew          GCC_OSX_HOMEBREW
#           GCC on Linux (recent versions)      GCC_LINUX_RECENT
#       The toolchain is set for C and C++.
#
#       If not toolchain ID is given this will used the default CMake
#       toolchain.
#
#       For most projects the default toolchain is suitable but in some cases
#       but in some cases this function provides an easy way to change the
#       toolchain.
#       For embedded projects it is required to properly set the toolchain.
#
#       The toolchain is set by modifying the CMAKE_TOOLCHAIN_FILE variable,
#       and this has to be done before any project declaration.
#
#       --- GCC_ARM_BAREMETAL ---
#       For the GCC ARM toolchain the path to the root directory needs to be set
#       in the variable ARM_TC_PATH.
#
# ---------------------------------------------------------------------------- #


# CMake minimum version and dependencies.
cmake_minimum_required(VERSION 3.8)


macro(PrintTC key value)
    message(STATUS "HEPHAISTOS:: Toolchain ${key}: ${value}")
endmacro()


# Store script location.
set(_ToolchainManagerDir "${CMAKE_CURRENT_LIST_DIR}")


# Toolchain diagnostic function.
function(heph_toolchain_diagnostic)

    # System name.
    PrintTC("system name" ${CMAKE_SYSTEM_NAME})

    # System processor and cross-compiling.
    PrintTC("system processor" ${CMAKE_SYSTEM_PROCESSOR})
    PrintTC("cross-compiling" ${CMAKE_CROSSCOMPILING})

    # Compilers.
    PrintTC("C compiler" ${CMAKE_C_COMPILER})
    PrintTC("C++ compiler" ${CMAKE_CXX_COMPILER})

    # Linker.
    PrintTC("linker command" ${CMAKE_LINKER})

    # Those commands might not be available for all compilers so we do some
    # checking.
    if (CMAKE_OBJCOPY)
        PrintTC("objcopy command" ${CMAKE_OBJCOPY})
    endif ()
    if (CMAKE_OBJDUMP)
        PrintTC("objdump command" ${CMAKE_OBJDUMP})
    endif ()
    if (CMAKE_NM)
        PrintTC("nm command" ${CMAKE_NM})
    endif ()
    if (CMAKE_AR)
        PrintTC("ar command" ${CMAKE_AR})
    endif ()
    if (CMAKE_RANLIB)
        PrintTC("ranlib command" ${CMAKE_RANLIB})
    endif ()
    if (CMAKE_STRIP)
        PrintTC("strip command" ${CMAKE_STRIP})
    endif ()

endfunction()


# Toolchain setup function.
function(heph_setup_toolchain)

    # Define function interface.
    set(options "")          # Options.
    set(oneValueArgs            # Arguments (all single value arguments).
        TOOLCHAIN)
    set(multiValueArgs "")      # None.

    # Parse arguments.
    cmake_parse_arguments(TCMGR_ARGS
                          "${options}"
                          "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN})

    # Default case.
    if (NOT TCMGR_ARGS_TOOLCHAIN)    
        message(STATUS
                "HEPHAISTOS:: Using default toolchain")
        return ()
    endif ()

    # GCC_ARM_BAREMETAL.
    if (TCMGR_ARGS_TOOLCHAIN STREQUAL "GCC_ARM_BAREMETAL")
        if (NOT DEFINED ARM_TC_PATH)
            message(FATAL_ERROR
                    "ARM_TC_PATH is required to be set to the GCC ARM toolchain root directory")
        endif ()
        message(STATUS "HEPHAISTOS:: Toolchain set to GCC_ARM_BAREMETAL")
        set(CMAKE_TOOLCHAIN_FILE
            "${_ToolchainManagerDir}/toolchains_support/GCC_ARM_BAREMETAL.cmake"
            PARENT_SCOPE)
        return ()
    endif ()

    # GCC_OSX_HOMEBREW.
    if (TCMGR_ARGS_TOOLCHAIN STREQUAL "GCC_OSX_HOMEBREW")
        message(STATUS "HEPHAISTOS:: Toolchain set to GCC_OSX_HOMEBREW")
        set(CMAKE_TOOLCHAIN_FILE
            "${_ToolchainManagerDir}/toolchains_support/GCC_OSX_HOMEBREW.cmake"
            PARENT_SCOPE)
        return ()
    endif ()

    # GCC_LINUX_RECENT.
    if (TCMGR_ARGS_TOOLCHAIN STREQUAL "GCC_LINUX_RECENT")
        message(STATUS "HEPHAISTOS:: Toolchain set to GCC_LINUX_RECENT")
        set(CMAKE_TOOLCHAIN_FILE
            "${_ToolchainManagerDir}/toolchains_support/GCC_LINUX_RECENT.cmake"
            PARENT_SCOPE)
        return ()
    endif ()

    # Warning if unknown.
    if (NOT TCMGR_ARGS_QUIET)
        message(STATUS
                "HEPHAISTOS:: Toolchain ID unknown; using default")
    endif ()

endfunction()
