# ---------------------------------------------------------------------------- #
# CMake Hephaistos::CompilerSetup ARM GCC bare metal compiler flags
#
# Nicolas Clauvelin (n.clauvelin+code@gmail.com)
# nicocvn.com, 2017
#
#
# DESCRIPTION:
#
#   Basic ARM bare metal flags are defined during toolchain compilation and
#   architecture specific flags (e.g., Cortex-M4) are managed by the
#   CompilerSetup script.
#
#   For all build types debug symbols are generated. This is not an issue as for
#   bare metal a binary will be produced by objcopy which strips the debug
#   information. This is however useful to perform meaningful remote debugging.
#
#   Except for Debug build types LTO is always enabled. C++14 is disabled for
#   all build types.
#   
#   Release and RelWithDebInfo build types only differ in the amount of debug
#   symbols generated.
#
#   Some ARM related flags are also defined in the toolchain support for GCC
#   ARM (see GCC_ARM_BAREMETAL.cmake).
#
# ---------------------------------------------------------------------------- #


# C99 and C++11 standards.
set(CMAKE_C_STANDARD 99 PARENT_SCOPE)
set(CMAKE_CXX_STANDARD 11 PARENT_SCOPE)
set(CMAKE_C_STANDARD_REQUIRED TRUE PARENT_SCOPE)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE PARENT_SCOPE)


# --- Flags common to all configurations ---

# Common C flags.
set(C_COMMON
    -mthumb
    -ffreestanding
    -fno-move-loop-invariants
    -fmessage-length=0
    -funsigned-char
    -fomit-frame-pointer
    -fno-exceptions
    -nostdlib
    #
    -flto
    -ffunction-sections
    -fdata-sections
    # Architecture.
    ${C_CORTEX_SPECIFIC_FLAGS})

# Common CXX flags.
set(CXX_COMMON
    -mthumb
    -ffreestanding
    -fno-move-loop-invariants
    -fmessage-length=0
    -funsigned-char
    -fomit-frame-pointer
    -fabi-version=0
    -fno-exceptions
    -fno-rtti
    -fno-use-cxa-atexit
    -fno-threadsafe-statics
    -nostdlib
    #
    -flto
    -ffunction-sections
    -fdata-sections
    # Architecture.
    ${CXX_CORTEX_SPECIFIC_FLAGS})

# Common linker flags.
set(LINKER_COMMON
    -flto
    --gc-sections
    --specs=nano.specs
    --specs=nosys.specs)


# --- Debug flags ---

# C debug flags.
set(C_DEBUG_FLAGS
    ${C_CORTEX_SPECIFIC_FLAGS}
    -g3
    -Og
    -Wall
    -Wextra
    -Wunused-value
    -Wunused
    -Wmissing-declarations
    -Wmissing-include-dirs
    -Wno-unused-parameter
    -Wuninitialized
    -Wdouble-promotion
    -Wconversion)

# C++ debug flags.
set(CXX_DEBUG_FLAGS
    ${CXX_CORTEX_SPECIFIC_FLAGS}
    -g3
    -Og
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
    -Weffc++)

# Debug linker flags.
set(LINKER_DEBUG_FLAGS ${LINKER_COMMON})


# --- Release flags ---

# C release flags.
set(C_RELEASE_FLAGS
    ${C_CORTEX_SPECIFIC_FLAGS}
    -O2
    -g3
    -DNDEBUG
    -flto)

# C++ release flags.
set(CXX_RELEASE_FLAGS
    ${CXX_CORTEX_SPECIFIC_FLAGS}
    -Wno-c++14-compat
    -O2
    -g3
    -DNDEBUG
    -flto)

# Release linker flags.
set(LINKER_RELEASE_FLAGS ${LINKER_COMMON})


# --- RelWithDebInfo flags ---

# C release with debug info flags.
set(C_RELWITHDEBINFO_FLAGS
    ${C_CORTEX_SPECIFIC_FLAGS}
    -O2
    -g3
    -DNDEBUG
    -flto)

# C++ release with debug info flags.
set(CXX_RELWITHDEBINFO_FLAGS
    ${CXX_CORTEX_SPECIFIC_FLAGS}
    -Wno-c++14-compat
    -O2
    -g3
    -DNDEBUG
    -flto)

# RelWithDebInfo linker flags.
set(LINKER_RELWITHDEBINFO_FLAGS ${LINKER_COMMON})


# --- MinSizeRel flags ---

# C minimal size release flags.
set(C_MINSIZEREL_FLAGS
    ${C_CORTEX_SPECIFIC_FLAGS}
    -Os
    -g3
    -DNDEBUG
    -flto)

# C++ minimal size release flags.
set(CXX_MINSIZEREL_FLAGS
    ${CXX_CORTEX_SPECIFIC_FLAGS}
    -Wno-c++14-compat
    -Os
    -g3
    -DNDEBUG
    -flto)

# MinSizeRel linker flags.
set(LINKER_MINSIZEREL_FLAGS ${LINKER_COMMON})


# --- Compiler flags setup ---

# We use the previously define lists to setup flags for all build types.

# We start by replacing the previously defined lists with string.
string(REPLACE ";" " " C_DEBUG_FLAGS "${C_DEBUG_FLAGS}")
string(REPLACE ";" " " CXX_DEBUG_FLAGS "${CXX_DEBUG_FLAGS}")
string(REPLACE ";" " " LINKER_DEBUG_FLAGS "${LINKER_DEBUG_FLAGS}")
#
string(REPLACE ";" " " C_RELEASE_FLAGS "${C_RELEASE_FLAGS}")
string(REPLACE ";" " " CXX_RELEASE_FLAGS "${CXX_RELEASE_FLAGS}")
string(REPLACE ";" " " LINKER_RELEASE_FLAGS "${LINKER_RELEASE_FLAGS}")
#
string(REPLACE ";" " " C_RELWITHDEBINFO_FLAGS "${C_RELWITHDEBINFO_FLAGS}")
string(REPLACE ";" " " CXX_RELWITHDEBINFO_FLAGS "${CXX_RELWITHDEBINFO_FLAGS}")
string(REPLACE ";" " " LINKER_RELWITHDEBINFO_FLAGS "${LINKER_RELWITHDEBINFO_FLAGS}")
#
string(REPLACE ";" " " C_MINSIZEREL_FLAGS "${C_MINSIZEREL_FLAGS}")
string(REPLACE ";" " " CXX_MINSIZEREL_FLAGS "${CXX_MINSIZEREL_FLAGS}")
string(REPLACE ";" " " LINKER_MINSIZEREL_FLAGS "${LINKER_MINSIZEREL_FLAGS}")

# Set CMake flags.
set(CMAKE_C_FLAGS_DEBUG "${C_DEBUG_FLAGS}"
    CACHE STRING "Debug C flags" FORCE)
set(CMAKE_CXX_FLAGS_DEBUG "${CXX_DEBUG_FLAGS}"
    CACHE STRING "Debug C++ flags" FORCE)
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${LINKER_DEBUG_FLAGS}"
    CACHE STRING "Debug linker flags" FORCE)
#
set(CMAKE_C_FLAGS_RELEASE "${C_RELEASE_FLAGS}"
    CACHE STRING "Release C flags" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE "${CXX_RELEASE_FLAGS}"
    CACHE STRING "Release C++ flags" FORCE)
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${LINKER_RELEASE_FLAGS}"
    CACHE STRING "Release linker flags" FORCE)
#
set(CMAKE_C_FLAGS_RELWITHDEBINFO "${C_RELWITHDEBINFO_FLAGS}"
    CACHE STRING "RelWithDebInfo C flags" FORCE)
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CXX_RELWITHDEBINFO_FLAGS}"
    CACHE STRING "RelWithDebInfo C++ flags" FORCE)
set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "${LINKER_RELWITHDEBINFO_FLAGS}"
    CACHE STRING "RelWithDebInfo linker flags" FORCE)
#
set(CMAKE_C_FLAGS_MINSIZEREL "${C_MINSIZEREL_FLAGS}"
    CACHE STRING "MinSizeRel C flags" FORCE)
set(CMAKE_CXX_FLAGS_MINSIZEREL "${CXX_MINSIZEREL_FLAGS}"
    CACHE STRING "MinSizeRel C++ flags" FORCE)
set(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL "${LINKER_MINSIZEREL_FLAGS}"
    CACHE STRING "MinSizeRel linker flags" FORCE)
