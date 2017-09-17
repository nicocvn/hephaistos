# ---------------------------------------------------------------------------- #
# CMake Hephaistos::CompilerSetup TI C2000 bare metal compiler flags
#
# Nicolas Clauvelin (n.clauvelin+code@gmail.com)
# nicocvn.com, 2017
#
#
# DESCRIPTION:
#
#   This file provides compiler flags tailored for the TI LAUNCHXL F2837xS
#   board.
#
#   The C/C++ TI compiler uses flags with a very different syntax than
#   GCC/Clang. Refer to the reference manual for explicit meaning.
#
#   The linking command is redefined to include the linker script from
#   2837xS_Generic_FLASH_lnk.cmd and F2837xS_Headers_nonBIOS.cmd. The other
#   linking files in this directory are for difference configurations (in RAM
#   code and BIOS features).
#
#   This setup has been tested and validated on the TI LAUNCHXL F2837xS board.
#   Any changes should be followed by a rigorous testing.
#
# ---------------------------------------------------------------------------- #


# Enforce ASM support.
# This is required for some files.
enable_language(ASM)


# --- TI C2000 Launchpad XL F2837xS specific flags ---

# -mt (--unified_memory)    for unified memory model
# --float_support=fpu32     for hardware floating point support
# --tmu_support=tmu0        for trigonometric hardware support
# --cla_support=cla1        CLA type 1 support
# --vcu_support=vcu2        VCU type 2 support
# --c99                     C99 support
# --c++03                   C++03 support
# LARGE_MODEL               identification of the launchpad XL
# _LAUNCHXL_F28377S         identification of the launchpad model
# CPU1                      target CPU1
# _FLASH                    create firmware for flash mode

# Specific flags.
set(LXL_F2837XS_SPECIFIC_FLAGS
    --unified_memory
    --float_support=fpu32
    --fp_mode=relaxed
    --tmu_support=tmu0
    --cla_support=cla1
    --vcu_support=vcu2
    --define=_LAUNCHXL_F28377S
    --define=LARGE_MODEL
    --define=CPU1
    --define=_FLASH)

# ASM flags.
set(ASM_FLAGS ${LXL_F2837XS_SPECIFIC_FLAGS})


# --- Debug flags ---

# C debug flags.
set(C_DEBUG_FLAGS
    ${LXL_F2837XS_SPECIFIC_FLAGS}
    --c99
    -g
    --define=_DEBUG
    --display_error_number)

# C++ debug flags.
set(CXX_DEBUG_FLAGS
    ${LXL_F2837XS_SPECIFIC_FLAGS}
    --c++03
    -g
    --define=_DEBUG
    --display_error_number)


# --- Release flags ---

# C release flags.
set(C_RELEASE_FLAGS
    ${LXL_F2837XS_SPECIFIC_FLAGS}
    --c99
    --opt_level=4
    --fp_reassoc=on
    --opt_for_speed=4
    --symdebug:none)

# C++ release flags.
set(CXX_RELEASE_FLAGS
    ${LXL_F2837XS_SPECIFIC_FLAGS}
    --c++03
    --opt_level=4
    --fp_reassoc=on
    --opt_for_speed=4
    --symdebug:none)


# --- RelWithDebInfo flags ---

# C release flags.
set(C_RELWITHDEBINFO_FLAGS
    ${LXL_F2837XS_SPECIFIC_FLAGS}
    -g
    --c99
    --opt_level=4
    --fp_reassoc=on
    --opt_for_speed=4
    --symdebug:dwarf)

# C++ release flags.
set(CXX_RELWITHDEBINFO_FLAGS
    ${LXL_F2837XS_SPECIFIC_FLAGS}
    -g
    --c++03
    --opt_level=4
    --fp_reassoc=on
    --opt_for_speed=4
    --symdebug:dwarf)


# --- MinSizeRel flags ---

# C minimal size release flags.
set(C_MINSIZEREL_FLAGS
    ${LXL_F2837XS_SPECIFIC_FLAGS}
    --c99
    --opt_level=4
    --fp_reassoc=on
    --opt_for_speed=2
    --symdebug:none)

# C++ minimal size release flags.
set(CXX_MINSIZEREL_FLAGS
    ${LXL_F2837XS_SPECIFIC_FLAGS}
    --c++03
    --opt_level=4
    --fp_reassoc=on
    --opt_for_speed=2
    --symdebug:none)


# --- Compiler flags setup ---

# We use the previously define lists to setup flags for all build types.

# We start by replacing the previously defined lists with string.
string(REPLACE ";" " " ASM_FLAGS "${ASM_FLAGS}")
#
string(REPLACE ";" " " C_DEBUG_FLAGS "${C_DEBUG_FLAGS}")
string(REPLACE ";" " " CXX_DEBUG_FLAGS "${CXX_DEBUG_FLAGS}")
#
string(REPLACE ";" " " C_RELEASE_FLAGS "${C_RELEASE_FLAGS}")
string(REPLACE ";" " " CXX_RELEASE_FLAGS "${CXX_RELEASE_FLAGS}")
##
string(REPLACE ";" " " C_RELWITHDEBINFO_FLAGS "${C_RELWITHDEBINFO_FLAGS}")
string(REPLACE ";" " " CXX_RELWITHDEBINFO_FLAGS "${CXX_RELWITHDEBINFO_FLAGS}")
##
string(REPLACE ";" " " C_MINSIZEREL_FLAGS "${C_MINSIZEREL_FLAGS}")
string(REPLACE ";" " " CXX_MINSIZEREL_FLAGS "${CXX_MINSIZEREL_FLAGS}")

# Set CMake flags.
set(CMAKE_ASM_FLAGS "${ASM_FLAGS}"
    CACHE STRING "ASM flags" FORCE)
#
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

# Linker flags.
# This specifies the linker map file.
# Those flags are requied for proper linking.
# Note that we pass the linker files only for executables.
set(CMAKE_EXE_LINKER_FLAGS
    "--define=_FLASH\
 --define=CPU1 --define=LARGE_MODEL --define=_LAUNCHXL_F28377S\
 --rom_model\
 --quiet --display_error_number\
 --diag_warning=225 --verbose_diagnostics --issue_remarks\
 --priority --reread_libs --warn_sections\
 -i${TI_CGT_PATH}/lib\
 -lrts2800_fpu32.lib\
 ${CMAKE_CURRENT_LIST_DIR}/F2837xS_Headers_nonBIOS.cmd\
 ${CMAKE_CURRENT_LIST_DIR}/2837xS_Generic_FLASH_lnk.cmd"
    CACHE STRING "Linker flags" FORCE)
#
set(CMAKE_STATIC_LINKER_FLAGS
    "--define=_FLASH\
 --define=CPU1 --define=LARGE_MODEL --define=_LAUNCHXL_F28377S\
 --rom_model\
 --quiet --display_error_number\
 --diag_warning=225 --verbose_diagnostics --issue_remarks\
 --priority --reread_libs --warn_sections\
 -i${TI_CGT_PATH}/lib\
 -lrts2800_fpu32.lib"
    CACHE STRING "Linker flags (archive)" FORCE)
