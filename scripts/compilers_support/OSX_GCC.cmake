# ---------------------------------------------------------------------------- #
# CMake Hephaistos::CompilerSetup OSX GCC compiler flags
#
# Nicolas Clauvelin (n.clauvelin+code@gmail.com)
# nicocvn.com, 2018
#
#
# DESCRIPTION:
#
#   * C99 and C++11 enforced.
#   * For all build types visibility is set to hidden.
#   * LTO and dead code stripping are enabled for Release and MinSizeRel only
#     (for RelWithDebInfo: it is not recommended to enable debug symbols with
#     LTO)
#   * Release and RelWithDebInfo use O2.
#   * Release, RelWithDebInfo, and MinSizeRel use march=native and mfpmath=sse.
#   * For Debug, Wall, Wextra, Weff-c++ and a few others are enabled.
#   * For Debug, sanitizers for address and undefined are enabled.
#
# ---------------------------------------------------------------------------- #


# Flags to disable AVX/AVX2.
set(NOAVX_FLAGS "")
if (DISABLE_AVX)
    set(NOAVX_FLAGS -mno-avx -mno-avx2)
endif ()


# --- Debug flags ---

# C debug flags.
set(C_DEBUG_FLAGS
    -fvisibility=hidden
    -g3
    -fno-omit-frame-pointer
    -fexceptions
    # Warnings.
    -Wall
    -Wextra
    -Wunused-value
    -Wunused
    -Wunused-parameter
    -Wunused-result
    -Wmissing-declarations
    -Wmissing-include-dirs
    -Wuninitialized
    -Wconversion
    -Wreturn-type
    # Sanitizer
    -fsanitize=address
    -fsanitize=undefined
    ${NOAVX_FLAGS})

# C++ debug flags.
set(CXX_DEBUG_FLAGS
    -fvisibility=hidden
    -g3
    -fno-omit-frame-pointer
    -fexceptions
    # Warnings.
    -Wall
    -Wextra
    -Wunused-value
    -Wunused
    -Wunused-parameter
    -Wunused-result
    -Wmissing-declarations
    -Wmissing-include-dirs
    -Wuninitialized
    -Wconversion
    -Wreturn-type
    -Weffc++
    # Sanitizer
    -fsanitize=address
    -fsanitize=undefined
    ${NOAVX_FLAGS})

# Debug linker flags.
set(LINKER_DEBUG_FLAGS )


# --- Release flags ---

# C release flags.
set(C_RELEASE_FLAGS
    -fvisibility=hidden
    -fexceptions
    # Arch.
    -march=native
    -mfpmath=sse
    # Optimization.
    -O2
    -DNDEBUG
    # LTO.
    -flto
    -ffunction-sections
    -fdata-sections
    ${NOAVX_FLAGS})

# C++ release flags.
set(CXX_RELEASE_FLAGS
    -fvisibility=hidden
    # Arch.
    -march=native
    -mfpmath=sse
    # Optimization.
    -O2
    -DNDEBUG
    # LTO.
    -flto
    -ffunction-sections
    -fdata-sections
    ${NOAVX_FLAGS})

# Release linker flags.
# With GCC the linker is accepting the flto flag.
set(LINKER_RELEASE_FLAGS
    -flto
    -dead_strip)


# --- RelWithDebInfo flags ---

# C release with debug info flags.
set(C_RELWITHDEBINFO_FLAGS
    -fvisibility=hidden
    -fexceptions
    # Arch.
    -march=native
    -mfpmath=sse
    # Optimization with debug symbols.
    -O2
    -g3
    -DNDEBUG
    ${NOAVX_FLAGS})

# C++ release flags.
set(CXX_RELWITHDEBINFO_FLAGS
    -fvisibility=hidden
    # Arch.
    -march=native
    -mfpmath=sse
    # Optimization with debug symbols.
    -O2
    -g3
    -DNDEBUG
    ${NOAVX_FLAGS})

# Release with debug info linker flags.
set(LINKER_RELWITHDEBINFO_FLAGS)


# --- MinSizeRel flags ---

# C minimal size release flags.
set(C_MINSIZEREL_FLAGS
    -fvisibility=hidden
    -fexceptions
    # Arch.
    -march=native
    -mfpmath=sse
    # Optimization.
    -Os
    -DNDEBUG
    # LTO.
    -flto
    -ffunction-sections
    -fdata-sections
    ${NOAVX_FLAGS})

# C++ minimal size release flags.
set(CXX_MINSIZEREL_FLAGS
    -fvisibility=hidden
    -fno-rtti
    # Arch.
    -march=native
    -mfpmath=sse
    # Optimization.
    -Os
    -DNDEBUG
    # LTO.
    -flto
    -ffunction-sections
    -fdata-sections
    ${NOAVX_FLAGS})

# Minimal size release linker flags.
set(LINKER_MINSIZEREL_FLAGS
    -flto
    -dead_strip)


# --- Compiler flags setup ---

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
