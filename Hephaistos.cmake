# -------------------------------------------------------------------------- #
# CMake Hephaistos
#
# Nicolas Clauvelin (nclauvelin@sendyne.com)
# Sendyne Corp., 2017
#
#
# MODULE:   Hephaistos
#
#   This file is to be included by any CMake script using Hephaistos.
#   See README.md for mode details about functionalities.
#
# -------------------------------------------------------------------------- #

# CMake minimum version.
cmake_minimum_required(VERSION 3.0)

set(_HephaistosDir ${CMAKE_CURRENT_LIST_DIR})

# Load scripts.
include(${_HephaistosDir}/scripts/CompilerSetup.cmake)
include(${_HephaistosDir}/scripts/ProjectTree.cmake)
include(${_HephaistosDir}/scripts/ToolchainManager.cmake)
