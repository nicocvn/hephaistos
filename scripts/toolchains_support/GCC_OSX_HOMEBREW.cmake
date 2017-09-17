# ---------------------------------------------------------------------------- #
# CMake Hephaistos::ToolchainManager toolchain file
# Toolchain file for GCC on OS X through Homebrew.
#
# Nicolas Clauvelin (n.clauvelin+code@gmail.com)
# nicocvn.com, 2017
#
#
# MODULE:   Hephaistos
#
# REQUIREMENTS:
#   This requires a functional installation of the GCC toolchain in Homebrew.
#
# ---------------------------------------------------------------------------- #


# Search for gcc-6 and gcc-7.
find_path(HBREW_GCC_6
          NAME gcc-6
          HINTS /usr/local/homebrew/bin /usr/local/bin
          NO_DEFAULT_PATH)
find_path(HBREW_GCC_7
          NAME gcc-7
          HINTS /usr/local/homebrew/bin /usr/local/bin
          NO_DEFAULT_PATH)
if (NOT HBREW_GCC_7 AND NOT HBREW_GCC_6)
    message(FATAL_ERROR
            "HEPHAISTOS:: Could not locate gcc-6 or gcc-7 in homebrew")
endif ()

# Switch to most recent version.
set(GCC_PATH "")
set(GCC_VER "")
if (HBREW_GCC_7)
    set(GCC_PATH "${HBREW_GCC_7}/")
    set(GCC_VER 7)
else ()
    set(GCC_PATH "${HBREW_GCC_6}/")
    set(GCC_VER 6)
endif ()


# CMAKE_FIND_ROOT_PATH
# We indicate the path to the compiler libraries as well.
set(CMAKE_FIND_ROOT_PATH ${GCC_PATH})

# Compilers.
# Those values are automatically added to CACHE.
set(CMAKE_C_COMPILER ${GCC_PATH}gcc-${GCC_VER}
    CACHE STRING "GCC C Compiler" FORCE)
set(CMAKE_CXX_COMPILER ${GCC_PATH}g++-${GCC_VER}
    CACHE STRING "GCC C++ Compiler" FORCE)

# Other toolchain executables.
# Those values need to be forced into CACHE.
# We do not specify the linker.
if (EXISTS ${GCC_PATH}gobjcopy)
    set(CMAKE_OBJCOPY ${GCC_PATH}gobjcopy
        CACHE FILEPATH "Toolchain objcopy command" FORCE)
endif (EXISTS ${GCC_PATH}gobjcopy)
#
if (EXISTS ${GCC_PATH}gobjdump)
    set(CMAKE_OBJDUMP ${GCC_PATH}gobjdump
        CACHE FILEPATH "Toolchain objdump command" FORCE)
endif (EXISTS ${GCC_PATH}gobjdump)
#
if (EXISTS ${GCC_PATH}gstrip)
    set(CMAKE_STRIP ${GCC_PATH}gstrip
        CACHE FILEPATH "Toolchain strip command" FORCE)
endif (EXISTS ${GCC_PATH}gstrip)
#
if (EXISTS ${GCC_PATH}gcc-nm-${GCC_VER})
    set(CMAKE_NM ${GCC_PATH}gcc-nm-${GCC_VER}
        CACHE FILEPATH "Toolchain nm command" FORCE)
endif (EXISTS ${GCC_PATH}gcc-nm-${GCC_VER})

# We do not overwrite the AR and RANLIB commands for OS X. This creates issues
# with plugins (i.e., LTO).
# if (EXISTS ${GCC_PATH}gcc-ar-${GCC_VER})
#     set(CMAKE_AR ${GCC_PATH}gcc-ar-${GCC_VER}
#         CACHE FILEPATH "Toolchain ar command" FORCE)
# endif (EXISTS ${GCC_PATH}gcc-ar-${GCC_VER})
# if (EXISTS ${GCC_PATH}gcc-ranlib-${GCC_VER})
#     set(CMAKE_RANLIB ${GCC_PATH}gcc-ranlib-${GCC_VER}
#         CACHE FILEPATH "Toolchain ranlib command" FORCE)
# endif (EXISTS ${GCC_PATH}gcc-ranlib-${GCC_VER})
