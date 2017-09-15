# -------------------------------------------------------------------------- #
# CMake Hephaistos::CompilerSetup Linux/Unix GCC compiler flags
#
# Nicolas Clauvelin (nclauvelin@sendyne.com)
# Sendyne Corp., 2017
#
#
# DESCRIPTION:
#
#   Regular flags with some added warnings for debug builds.
#   Address sanitizer used in debug builds only.
#   C++14 disabled.
#   MinSizeRel relies on data-sections and such to reduce sizing.
#   For MinSizeRel exceptions and RTTI are disabled.
#   This requires a recent GCC support (see GCC_LINUX_RECENT toolchain).
#   Note that, LTO is disabled as it seems that as of today it causes numerous
#   issues on Linux (... this is somewhat worrisome).
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
    -fvisibility=hidden
    -g3
    -Wall
    -Wextra
    -Wunused-value
    -Wunused
    -Wmissing-declarations
    -Wmissing-include-dirs
    -Wno-unused-parameter
    -Wuninitialized
    -Wconversion
    -fsanitize=address
    -fno-omit-frame-pointer)

# C++ debug flags.
set(CXX_DEBUG_FLAGS
    -fvisibility=hidden
    -g3
    -Wall
    -Wextra
    -Wunused-value
    -Wunused
    -Wmissing-declarations
    -Wmissing-include-dirs
    -Wno-unused-parameter
    -Wuninitialized
    -Wconversion
    -fsanitize=address
    -fno-omit-frame-pointer
    -Wno-c++14-compat
    -Weffc++)


# --- Release flags ---

# C release flags.
set(C_RELEASE_FLAGS
    -fvisibility=hidden
    -O2
    -DNDEBUG
    -march=native
    -mfpmath=sse)
    # -flto
    # -Wl,-flto)

# C++ release flags.
set(CXX_RELEASE_FLAGS
    -fvisibility=hidden
    -Wno-c++14-compat
    -O2
    -DNDEBUG
    -march=native
    -mfpmath=sse)
    # -flto
    # -Wl,-flto)


# --- RelWithDebInfo flags ---

# C release with debug info flags.
set(C_RELWITHDEBINFO_FLAGS
    -fvisibility=hidden
    -O2
    -g
    -DNDEBUG
    -march=native
    -mfpmath=sse)

# C++ release with debug info flags.
set(CXX_RELWITHDEBINFO_FLAGS
    -fvisibility=hidden
    -Wno-c++14-compat
    -O2
    -g
    -DNDEBUG
    -march=native
    -mfpmath=sse)


# --- MinSizeRel flags ---

# It should be check if visibility settings could help further reducing the
# code size.

# C minimal size release flags.
set(C_MINSIZEREL_FLAGS
    -fvisibility=hidden
    -Os
    -DNDEBUG
    -march=native
    -mfpmath=sse
    # -flto
    -ffunction-sections
    -fdata-sections
    -s
    -Wl,--gc-sections,-s,--as-needed,--relax)
    # -Wl,--gc-sections,-s,--as-needed,--relax,-flto)

# C++ minimal size release flags.
set(CXX_MINSIZEREL_FLAGS
    -fvisibility=hidden
    -Wno-c++14-compat
    -Os
    -DNDEBUG
    -march=native
    -mfpmath=sse
    # -fno-exceptions       We maintain exceptions for desktop builds.
    -fno-rtti
    # -flto
    -ffunction-sections
    -fdata-sections
    -s
    -Wl,--gc-sections,-s,--as-needed,--relax)
    # -Wl,--gc-sections,-s,--as-needed,--relax,-flto)


# --- Compiler flags setup ---

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
