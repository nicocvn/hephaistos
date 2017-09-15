# -------------------------------------------------------------------------- #
# CMake Hephaistos::ToolchainManager toolchain file
# Toolchain file for TI C2000 bare metal.
#
# Nicolas Clauvelin (nclauvelin@sendyne.com)
# Sendyne Corp., 2017


# MODULE:   Hephaistos
#
# REQUIREMENTS:
#   TI_CGT_PATH needs to be defined to point at the root directory of the TI
#   CGT installation.
#
# -------------------------------------------------------------------------- #


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
set(CMAKE_SYSTEM_PROCESSOR C2000)
set(CMAKE_CROSSCOMPILING TRUE)
set(CMAKE_ASM_COMPILER_WORKS TRUE)
set(CMAKE_C_COMPILER_WORKS TRUE)
set(CMAKE_CXX_COMPILER_WORKS TRUE)
set(CMAKE_DETERMINE_C_ABI_COMPILED TRUE)
set(CMAKE_DETERMINE_CXX_ABI_COMPILED TRUE)

# CMAKE_FIND_ROOT_PATH
# We indicate the path to the compiler libraries as well.
set(CMAKE_FIND_ROOT_PATH ${TI_CGT_PATH})

# Cross compilers.
# Those values are automatically added to CACHE.
set(CMAKE_ASM_COMPILER ${TI_CGT_PATH}bin/cl2000${PROG_SUFFIX})
set(CMAKE_C_COMPILER ${TI_CGT_PATH}bin/cl2000${PROG_SUFFIX})
set(CMAKE_CXX_COMPILER ${TI_CGT_PATH}bin/cl2000${PROG_SUFFIX})

# Force compilers ID.
set(CMAKE_C_COMPILER_ID "TI"
    CACHE STRING "TI C Compiler ID" FORCE)
set(CMAKE_CXX_COMPILER_ID "TI"
    CACHE STRING "TI C++ Compiler ID" FORCE)

# Other toolchain executables.
# Those values need to be forced into CACHE.
SET(CMAKE_AR ${TI_CGT_PATH}bin/ar2000${PROG_SUFFIX}
    CACHE PATH "C2000 CodeGeneration Tools ar Program" FORCE)
SET(CMAKE_NM ${TI_CGT_PATH}bin/nm2000${PROG_SUFFIX}
    CACHE PATH "C2000 Code Generation Tools nm Program")
SET(CMAKE_OBJDUMP ${TI_CGT_PATH}bin/ofd2000${PROG_SUFFIX}
    CACHE PATH "C2000 Code Generation Tools objdump Program" FORCE)
SET(CMAKE_LINKER ${TI_CGT_PATH}bin/cl2000${PROG_SUFFIX}
    CACHE PATH "C2000 CodeGeneration Tools linker Program" FORCE)
SET(CMAKE_STRIP ${TI_CGT_PATH}bin/strip2000${PROG_SUFFIX}
    CACHE PATH "C2000 Code Generation Tools strip Program" FORCE)

# Never search for programs in the build host directories.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# For libraries and headers only look in targets directory.
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# For commands define below see for some comments:
# https://public.kitware.com/Bug/view.php?id=14876

# ASM commands.
set(CMAKE_ASM_SOURCE_FILE_EXTENSIONS asm;s;abs)
set(CMAKE_ASM_COMPILE_OBJECT  "<CMAKE_ASM_COMPILER> --compile_only --asm_file=<SOURCE> <DEFINES> <INCLUDES> <FLAGS> --output_file=<OBJECT>")
set(CMAKE_ASM_LINK_EXECUTABLE "<CMAKE_ASM_COMPILER> <OBJECTS> --run_linker --output_file=<TARGET> <CMAKE_ASM_LINK_FLAGS> <LINK_FLAGS> <LINK_LIBRARIES>")

# C commands.
set(CMAKE_C_CREATE_ASSEMBLY_SOURCE "<CMAKE_C_COMPILER> --compile_only --skip_assembler --c_file=<SOURCE> <DEFINES> <INCLUDES> <FLAGS> --output_file=<ASSEMBLY_SOURCE>")
set(CMAKE_C_CREATE_PREPROCESSED_SOURCE "<CMAKE_C_COMPILER> --preproc_only --c_file=<SOURCE> <DEFINES> <INCLUDES> <FLAGS> --output_file=<PREPROCESSED_SOURCE>")
set(CMAKE_C_COMPILE_OBJECT  "<CMAKE_C_COMPILER> --compile_only --c_file=<SOURCE> <DEFINES> <INCLUDES> <FLAGS> --output_file=<OBJECT>")
set(CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> -r <TARGET> <OBJECTS>")
set(CMAKE_C_LINK_EXECUTABLE "<CMAKE_C_COMPILER> --run_linker --output_file=<TARGET> --map_file=<TARGET>.map <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> <LINK_LIBRARIES>")

# C++ commands.
set(CMAKE_CXX_CREATE_ASSEMBLY_SOURCE "<CMAKE_CXX_COMPILER> --compile_only --skip_assembler --cpp_file=<SOURCE> <DEFINES> <INCLUDES> <FLAGS> --output_file=<ASSEMBLY_SOURCE>")
set(CMAKE_CXX_CREATE_PREPROCESSED_SOURCE "<CMAKE_CXX_COMPILER> --preproc_only --cpp_file=<SOURCE> <DEFINES> <INCLUDES> <FLAGS> --output_file=<PREPROCESSED_SOURCE>")
set(CMAKE_CXX_COMPILE_OBJECT  "<CMAKE_CXX_COMPILER> --compile_only --cpp_file=<SOURCE> <DEFINES> <INCLUDES> <FLAGS> --output_file=<OBJECT>")
set(CMAKE_CXX_ARCHIVE_CREATE "<CMAKE_AR> -r <TARGET> <OBJECTS>")
set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_CXX_COMPILER> --run_linker --output_file=<TARGET> --map_file=<TARGET>.map <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> <LINK_LIBRARIES>")

# Archive commands.
set(CMAKE_C_ARCHIVE_APPEND "<CMAKE_AR> -r <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_CXX_ARCHIVE_APPEND "<CMAKE_AR> -r <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_C_ARCHIVE_FINISH "")
set(CMAKE_CXX_ARCHIVE_FINISH "")
