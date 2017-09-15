# -------------------------------------------------------------------------- #
# CMake Hephaistos::CompilerSetup Windows MSVC compiler flags
#
# Nicolas Clauvelin (nclauvelin@sendyne.com)
# Sendyne Corp., 2017
#
#
# DESCRIPTION:
#
#   This is not implemented as of now and will therefore use the default flags
#   provided by CMake Visual Studio generator.
#
# -------------------------------------------------------------------------- #


# C99 and C++11 standards.
set(CMAKE_C_STANDARD 99 PARENT_SCOPE)
set(CMAKE_CXX_STANDARD 11 PARENT_SCOPE)
set(CMAKE_C_STANDARD_REQUIRED TRUE PARENT_SCOPE)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE PARENT_SCOPE)
