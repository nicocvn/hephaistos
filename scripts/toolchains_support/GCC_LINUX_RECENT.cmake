# ---------------------------------------------------------------------------- #
# CMake Hephaistos::ToolchainManager toolchain file
# Toolchain file for GCC on Linux with support for recent versions.
#
# Nicolas Clauvelin (n.clauvelin+code@gmail.com)
# nicocvn.com, 2017
#
#
# MODULE:   Hephaistos
#
# REQUIREMENTS:
#   This requires a functional installation of GCC (6 or 7).
#   This toolchain file is provided to avoid issue on Linux distributions
#   still using "old" GCC versions.
#   Modern versions support LTO and recent C++ standards (among other things).
#   This is therefore the recommended choice for Linux builds.
#
# ---------------------------------------------------------------------------- #


# Search for gcc-6 and gcc-7.
find_path(LINUX_GCC_6
          NAME gcc-6
          HINTS /usr/bin /usr/local/bin)
find_path(LINUX_GCC_7
          NAME gcc-7
          HINTS /usr/bin /usr/local/bin)
if (NOT LINUX_GCC_6 AND NOT LINUX_GCC_7)
    message(FATAL_ERROR
            "HEPHAISTOS:: Could not locate gcc-6 or gcc-7")
endif ()

# Switch to most recent version.
set(GCC_PATH "")
set(GCC_VER "")
if (LINUX_GCC_7)
    set(GCC_PATH "${LINUX_GCC_7}/")
    set(GCC_VER 7)
else ()
    set(GCC_PATH "${LINUX_GCC_6}/")
    set(GCC_VER 6)
endif ()

# Compilers.
# Those values are automatically added to CACHE.
set(CMAKE_C_COMPILER ${GCC_PATH}gcc-${GCC_VER}
    CACHE STRING "GCC C Compiler" FORCE)
set(CMAKE_CXX_COMPILER ${GCC_PATH}g++-${GCC_VER}
    CACHE STRING "GCC C++ Compiler" FORCE)

# Other toolchain executables.
# Those values need to be forced into CACHE.
# We do not specify the linker.
if (EXISTS ${GCC_PATH}objcopy)
    set(CMAKE_OBJCOPY ${GCC_PATH}objcopy
        CACHE FILEPATH "Toolchain objcopy command" FORCE)
endif (EXISTS ${GCC_PATH}objcopy)
#
if (EXISTS ${GCC_PATH}objdump)
    set(CMAKE_OBJDUMP ${GCC_PATH}objdump
        CACHE FILEPATH "Toolchain objdump command" FORCE)
endif (EXISTS ${GCC_PATH}objdump)
#
if (EXISTS ${GCC_PATH}strip)
    set(CMAKE_STRIP ${GCC_PATH}strip
        CACHE FILEPATH "Toolchain strip command" FORCE)
endif (EXISTS ${GCC_PATH}strip)
#
if (EXISTS ${GCC_PATH}gcc-nm-${GCC_VER})
    set(CMAKE_NM ${GCC_PATH}gcc-nm-${GCC_VER}
        CACHE FILEPATH "Toolchain nm command" FORCE)
endif (EXISTS ${GCC_PATH}gcc-nm-${GCC_VER})
#
if (EXISTS ${GCC_PATH}gcc-ar-${GCC_VER})
    set(CMAKE_AR ${GCC_PATH}gcc-ar-${GCC_VER}
        CACHE FILEPATH "Toolchain ar command" FORCE)
endif (EXISTS ${GCC_PATH}gcc-ar-${GCC_VER})
#
if (EXISTS ${GCC_PATH}gcc-ranlib-${GCC_VER})
    set(CMAKE_RANLIB ${GCC_PATH}gcc-ranlib-${GCC_VER}
        CACHE FILEPATH "Toolchain ranlib command" FORCE)
endif (EXISTS ${GCC_PATH}gcc-ranlib-${GCC_VER})
