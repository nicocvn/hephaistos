# ---------------------------------------------------------------------------- #
# CMake Hephaistos::ToolchainManager toolchain file
# Toolchain file for GCC ARM bare metal.
#
# Nicolas Clauvelin (n.clauvelin+code@gmail.com)
# nicocvn.com, 2017
#
#
# MODULE:   Hephaistos
#
# REQUIREMENTS:
#   ARM_TC_PATH needs to be defined to point at the root directory of the GCC
#   ARM installation.
#
#   This file provides the toolchain definition for ARM cross compiling using
#   GCC ARM. This targets thumb-enabled ARM processors. The specific CPU and
#   FPU types needs to be specified as regular compiler flags.
#
# ---------------------------------------------------------------------------- #


# Adapt program suffix for Windows platforms.
set(PROG_SUFFIX "")
if (WIN32)
    set(PROG_SUFFIX ".exe")
endif (WIN32)

# CMAKE_SYSTEM_NAME
# For bare metal it is recommended to use Generic.
set(CMAKE_SYSTEM_NAME Generic)

# CMAKE_SYSTEM_PROCESSOR
# We disable the automated check as they will surely fail.
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_CROSSCOMPILING TRUE)         # executables cannot run on the host
set(CMAKE_C_COMPILER_WORKS TRUE)       # do not check the C compiler
set(CMAKE_CXX_COMPILER_WORKS TRUE)     # do not check the CXX compiler

# CMAKE_FIND_ROOT_PATH
set(CMAKE_FIND_ROOT_PATH ${ARM_TC_PATH})

# Toolchain prefix for all toolchain executables.
set(CROSS_COMPILE /bin/arm-none-eabi-)

# Cross compilers.
# Those values are automatically added to CACHE.
set(CMAKE_C_COMPILER
    "${ARM_TC_PATH}${CROSS_COMPILE}gcc${PROG_SUFFIX}")
set(CMAKE_CXX_COMPILER
    "${ARM_TC_PATH}${CROSS_COMPILE}g++${PROG_SUFFIX}")

# Other toolchain executables.
# Those values need to be forced into CACHE.
set(CMAKE_LINKER ${ARM_TC_PATH}${CROSS_COMPILE}ld${PROG_SUFFIX}
    CACHE FILEPATH "Toolchain linker command" FORCE)
#
set(CMAKE_OBJCOPY ${ARM_TC_PATH}${CROSS_COMPILE}objcopy${PROG_SUFFIX}
    CACHE FILEPATH "Toolchain objcopy command" FORCE)
#
set(CMAKE_OBJDUMP ${ARM_TC_PATH}${CROSS_COMPILE}objdump${PROG_SUFFIX}
    CACHE FILEPATH "Toolchain objdump command" FORCE)
#
set(CMAKE_NM ${ARM_TC_PATH}${CROSS_COMPILE}gcc-nm${PROG_SUFFIX}
    CACHE FILEPATH "Toolchain nm command" FORCE)
#
set(CMAKE_AR ${ARM_TC_PATH}${CROSS_COMPILE}gcc-ar${PROG_SUFFIX}
    CACHE FILEPATH "Toolchain ar command" FORCE)
#
set(CMAKE_RANLIB ${ARM_TC_PATH}${CROSS_COMPILE}gcc-ranlib${PROG_SUFFIX}
    CACHE FILEPATH "Toolchain ranlib command" FORCE)
#
set(CMAKE_STRIP ${ARM_TC_PATH}${CROSS_COMPILE}strip${PROG_SUFFIX}
    CACHE FILEPATH "Toolchain strip command" FORCE)

# Never search for programs in the build host directories.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# For libraries and headers only look in targets directory.
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
