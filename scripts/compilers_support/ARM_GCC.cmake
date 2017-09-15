# -------------------------------------------------------------------------- #
# CMake Hephaistos::CompilerSetup ARM GCC bare metal compiler flags
#
# Nicolas Clauvelin (nclauvelin@sendyne.com)
# Sendyne Corp., 2017
#
#
# DESCRIPTION:
#
#   Regular flags with some added warnings for debug builds.
#   C++14 disabled.
#   Code reduction is activated for all build types using function and data
#   sections with gc-sections. In addition, for MinSizeReal Os is used.
#
#   Some ARM related flags are also defined in the toolchain support for GCC
#   ARM (see GCC_ARM_BAREMETAL.cmake).
#
# -------------------------------------------------------------------------- #


# C99 and C++11 standards.
set(CMAKE_C_STANDARD 99 PARENT_SCOPE)
set(CMAKE_CXX_STANDARD 11 PARENT_SCOPE)
set(CMAKE_C_STANDARD_REQUIRED TRUE PARENT_SCOPE)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE PARENT_SCOPE)


# --- Debug flags ---

# C debug flags.
set(C_DEBUG_FLAGS
    ${C_CORTEX_SPECIFIC_FLAGS}
    -g3
    -Wall
    -Wextra
    -Wunused-value
    -Wunused
    -Wmissing-declarations
    -Wmissing-include-dirs
    -Wno-unused-parameter
    -Wuninitialized
    -Wdouble-promotion
    -Wconversion
    -Wl,--gc-sections)

# C++ debug flags.
set(CXX_DEBUG_FLAGS
    ${CXX_CORTEX_SPECIFIC_FLAGS}
    -g3
    -Wall
    -Wextra
    -Wunused-value
    -Wunused
    -Wmissing-declarations
    -Wmissing-include-dirs
    -Wno-unused-parameter
    -Wuninitialized
    -Wdouble-promotion
    -Wconversion
    -Wno-c++14-compat
    -Weffc++
    -Wl,--gc-sections)


# --- Release flags ---

# C release flags.
set(C_RELEASE_FLAGS
    ${C_CORTEX_SPECIFIC_FLAGS}
    -O2
    -DNDEBUG
    -flto
    -Wl,--gc-sections,-flto,-s,--as-needed,--relax)

# C++ release flags.
set(CXX_RELEASE_FLAGS
    ${CXX_CORTEX_SPECIFIC_FLAGS}
    -Wno-c++14-compat
    -O2
    -DNDEBUG
    -flto
    -Wl,--gc-sections,-flto,-s,--as-needed,--relax)


# --- RelWithDebInfo flags ---

# C release with debug info flags.
set(C_RELWITHDEBINFO_FLAGS
    ${C_CORTEX_SPECIFIC_FLAGS}
    -O2
    -g
    -DNDEBUG
    -Wl,--gc-sections,-flto,-s,--as-needed,--relax)

# C++ release with debug info flags.
set(CXX_RELWITHDEBINFO_FLAGS
    ${CXX_CORTEX_SPECIFIC_FLAGS}
    -Wno-c++14-compat
    -O2
    -g
    -DNDEBUG
    -Wl,--gc-sections,-flto,-s,--as-needed,--relax)


# --- MinSizeRel flags ---

# It should be check if visibility settings could help further reducing the
# code size.

# C minimal size release flags.
set(C_MINSIZEREL_FLAGS
    ${C_CORTEX_SPECIFIC_FLAGS}
    -Os
    -DNDEBUG
    -flto
    -s
    -Wl,--gc-sections,-s,--as-needed,--relax,-flto)

# C++ minimal size release flags.
set(CXX_MINSIZEREL_FLAGS
    ${CXX_CORTEX_SPECIFIC_FLAGS}
    -Wno-c++14-compat
    -Os
    -DNDEBUG
    -flto
    -s
    -Wl,--gc-sections,-s,--as-needed,--relax,-flto)


# --- Compiler flags setup ---

# We use the previously define lists to setup flags for all build types.

# We start by replacing the previously defined lists with string.
string(REPLACE ";" " " C_DEBUG_FLAGS "${C_DEBUG_FLAGS}")
string(REPLACE ";" " " CXX_DEBUG_FLAGS "${CXX_DEBUG_FLAGS}")
#
string(REPLACE ";" " " C_RELEASE_FLAGS "${C_RELEASE_FLAGS}")
string(REPLACE ";" " " CXX_RELEASE_FLAGS "${CXX_RELEASE_FLAGS}")
#
string(REPLACE ";" " " C_RELWITHDEBINFO_FLAGS "${C_RELWITHDEBINFO_FLAGS}")
string(REPLACE ";" " " CXX_RELWITHDEBINFO_FLAGS "${CXX_RELWITHDEBINFO_FLAGS}")
#
string(REPLACE ";" " " C_MINSIZEREL_FLAGS "${C_MINSIZEREL_FLAGS}")
string(REPLACE ";" " " CXX_MINSIZEREL_FLAGS "${CXX_MINSIZEREL_FLAGS}")

# Set CMake flags.
set(CMAKE_C_FLAGS_DEBUG "${C_DEBUG_FLAGS}"
    CACHE STRING "Debug C flags" FORCE)
set(CMAKE_CXX_FLAGS_DEBUG "${CXX_DEBUG_FLAGS}"
    CACHE STRING "Debug C++ flags" FORCE)
#
set(CMAKE_C_FLAGS_RELEASE "${C_RELEASE_FLAGS}"
    CACHE STRING "Release C flags" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE "${CXX_RELEASE_FLAGS}"
    CACHE STRING "Release C++ flags" FORCE)
#
set(CMAKE_C_FLAGS_RELWITHDEBINFO "${C_RELWITHDEBINFO_FLAGS}"
    CACHE STRING "RelWithDebInfo C flags" FORCE)
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CXX_RELWITHDEBINFO_FLAGS}"
    CACHE STRING "RelWithDebInfo C++ flags" FORCE)
#
set(CMAKE_C_FLAGS_MINSIZEREL "${C_MINSIZEREL_FLAGS}"
    CACHE STRING "MinSizeRel C flags" FORCE)
set(CMAKE_CXX_FLAGS_MINSIZEREL "${CXX_MINSIZEREL_FLAGS}"
    CACHE STRING "MinSizeRel C++ flags" FORCE)
