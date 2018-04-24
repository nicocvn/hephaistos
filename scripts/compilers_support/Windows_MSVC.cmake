# ---------------------------------------------------------------------------- #
# CMake Hephaistos::CompilerSetup Windows MSVC compiler flags
#
# Nicolas Clauvelin (n.clauvelin+code@gmail.com)
# nicocvn.com, 2017
#
#
# DESCRIPTION:
#
#   This is not implemented as of now and will therefore use the default flags
#   provided by CMake Visual Studio generator.
#
# FLOAT PERFORMANCE:
#
#   By default with MSVC SSE/SSE2 is enabled for x64 builds so we do not need to
#   specify it.
#   AVX is not enabled unless /arch:AVX or /arch:AVX2 is set.
#   In other words, there is nothing special to set here for float performance.
#
# ---------------------------------------------------------------------------- #


# C99 and C++11 standards.
set(CMAKE_C_STANDARD 99 PARENT_SCOPE)
set(CMAKE_CXX_STANDARD 11 PARENT_SCOPE)
set(CMAKE_C_STANDARD_REQUIRED TRUE PARENT_SCOPE)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE PARENT_SCOPE)
