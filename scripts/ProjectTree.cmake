# -------------------------------------------------------------------------- #
# CMake Hephaistos::ProjectTree
#
# Nicolas Clauvelin (nclauvelin@sendyne.com)
# Sendyne Corp., 2017
#
#
# MODULE:   Hephaistos
#
# PROVIDES:
#
#   heph_setup_project_tree([PROJ_BUILD_DIR projBuildDir]
#                           [PROJ_INSTALL_DIR projInstallDir]
#                           [QUIET])
#
#       For a project located at proj_dir/ this command setup the build and 
#       install directories as follow:
#       proj_dir/
#       cmake/
#           build/
#               Debug/
#                   bin/ lib/ ...
#               MinSizeRel/
#                   bin/ lib/ ...
#               Release/
#                   bin/ lib/ ...
#               RelWithDebInfo/
#                   bin/ lib/ ...
#           install/
#               Debug/
#                   bin/ lib/ ...
#               MinSizeRel/
#                   bin/ lib/ ...
#               Release/
#                   bin/ lib/ ...
#               RelWithDebInfo/
#                   bin/ lib/ ...
#
#       The precise location of the build directory can be controlled with the
#       PROJ_BUILD_DIR argument and PROJ_INSTALL_DIR controls the install
#       directory.
# 
#       For the build location, there is the restriction that PROJ_BUIL_DIR
#       has to be under the directory from where the cmake process is invoked.
#
#       The QUIET option can be used to turn off any logging output.
#
# -------------------------------------------------------------------------- #


# CMake minimum version and dependencies.
cmake_minimum_required(VERSION 3.0)
include(CMakeParseArguments)


# Declare the available build types.
set(CMAKE_CONFIGURATION_TYPES
    Debug Release RelWithDebInfo MinSizeRel
    CACHE TYPE INTERNAL FORCE)

# If no build type is defined set Debug as default.
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug"
        CACHE STRING
        "Possible build type: Debug, Release, RelWithDebInfo, MinSizeRel."
        FORCE)
    message(STATUS
            "HEPHAISTOS:: No build type defined; Debug set as default.")
endif ()
message(STATUS "HEPHAISTOS:: Build type is ${CMAKE_BUILD_TYPE}")


# heph_setup_project_tree function.
function(heph_setup_project_tree)

    # Define function interface.
    set(options QUIET)          # Options.
    set(oneValueArgs            # Arguments (all single value arguments).
        PROJ_BUILD_DIR
        PROJ_INSTALL_DIR)
    set(multiValueArgs "")      # None.

    # Parse arguments.
    cmake_parse_arguments(PT_ARGS
                          "${options}"
                          "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN})

    # Set the build location.
    # The double set calls are required due to some global/local conflicts.
    if (PT_ARGS_PROJ_BUILD_DIR)
        get_filename_component(BUILD_DIR_FULL ${PT_ARGS_PROJ_BUILD_DIR}
                               ABSOLUTE)
        set(CMAKE_BINARY_DIR "${BUILD_DIR_FULL}"
            CACHE PATH "Build products location." FORCE)
        set(CMAKE_BINARY_DIR "${BUILD_DIR_FULL}" PARENT_SCOPE)
    else () # PT_ARGS_PROJ_BUILD_DIR
        set(CMAKE_BINARY_DIR "${CMAKE_SOURCE_DIR}/build"
            CACHE PATH "Build products location." FORCE)
        set(CMAKE_BINARY_DIR "${CMAKE_SOURCE_DIR}/build" PARENT_SCOPE)
    endif () # PT_ARGS_PROJ_BUILD_DIR

    # Configure products directories depending on the build type.
    # Executables are in bin/, libraries in lib/.
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY
        "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/bin"
        PARENT_SCOPE)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY
        "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/lib"
        PARENT_SCOPE)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY
        "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/lib"
        PARENT_SCOPE)

    # Logging.
    if (NOT PT_ARGS_QUIET)
        message(STATUS 
                "HEPHAISTOS:: Build products location: ${CMAKE_BINARY_DIR}")
    endif ()

    # Set the install location.
    # The double set calls are required due to some global/local conflicts.
    if (PT_ARGS_PROJ_INSTALL_DIR)
        get_filename_component(INSTALL_DIR_FULL ${PT_ARGS_PROJ_INSTALL_DIR}
                               ABSOLUTE CACHE)
        set(CMAKE_INSTALL_PREFIX
            "${INSTALL_DIR_FULL}/${CMAKE_BUILD_TYPE}"
            CACHE PATH "Install location." FORCE)
        # set(CMAKE_INSTALL_PREFIX "${INSTALL_DIR_FULL}/${CMAKE_BUILD_TYPE}"
        #     PARENT_SCOPE)
    else () # PT_ARGS_PROJ_INSTALL_DIR
        set(CMAKE_INSTALL_PREFIX 
            "${CMAKE_SOURCE_DIR}/install/${CMAKE_BUILD_TYPE}"
            CACHE PATH "Install location." FORCE)
        set(CMAKE_INSTALL_PREFIX
            "${CMAKE_SOURCE_DIR}/install/${CMAKE_BUILD_TYPE}"
            PARENT_SCOPE)
    endif () # PT_ARGS_PROJ_INSTALL_DIR

    # Sum up message.
    if (NOT PT_ARGS_QUIET)
        message(STATUS
                "HEPHAISTOS:: Install location: ${CMAKE_INSTALL_PREFIX}")
    endif ()

endfunction()

