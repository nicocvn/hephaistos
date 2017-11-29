# Hephaistos #
Copyright Nicolas Clauvelin, 2017. All rights reserved ([LICENSE](LICENSE)).


## Motivation ##
Setting up project in [CMake] can be a bit cumbersome, especially when dealing with custom toolchains. In addition, the project setup does not vary much between projects. This project is an effort to provide some basic functionalities to facilitate project setup in [CMake]. By design, the implementation is usable on [CLion].

Most of my personal programing projects are usually cross-platform or sometimes designed for a specific hardware (usually embedded). [CMake] therefore seems like a good choice as it provides:

* low-level project management functionalities,
* cross-platform support for project configuration, build and install steps,
* can be used as the project format in [CLion].

This project was originally developed for personal projects and then got sanitized to be used in production at Sendyne Corp.


## Project description ##
The project is a collection of [CMake] scripts grouped into a module named Hephaistos. In order to use the module, it is sufficient to include the main script [Hephaistos.cmake](Hephaistos.cmake).


## Features ##
The `Hephaistos` [CMake] module provides the following functionalities:

* support for various toolchains using the [heph_setup_toolchain] command,
* the [heph_setup_project_tree] command to set up the various project directories used for compiling, building, and installing the project,
* a [heph_setup_compiler] command to adjust compiler settings for various setups (`Debug`, `Release`, `RelWithDebInfo`, and `MinSizeRel`).

All those commands will report status information when [CMake] is going through the configuration stage.

The file [Hephaistos.cmake](Hephaistos.cmake) should be included in the [CMake] project file in order to load the definitions of those various commands.


## heph_setup_toolchain ##
This command is implemented in [ToolchainManager.cmake](scripts/ToolchainManager.cmake) and provides toolchain management functionalities. For most projects the toolchain will be automatically setup during [CMake] configuration step, but in some cases (*e.g.*, embedded platforms) explicit toolchain configuration will be required. In addition, it is sometimes useful to use a specific toolchain for debugging purpose.

The script [ToolchainManager.cmake](scripts/ToolchainManager.cmake) provides two commands:

* `heph_setup_toolchain([TOOLCHAIN ToolchainID])`: if `ToolchainID` is not specified this will use the default toolchain identified by [CMake] during the configure step,
* `heph_toolchain_diagnostic()`: this command outputs the details of the toolchain configuration.

The table below lists the supported toolchains:

| Platform | Toolchain | Supported | Comment                                |
| -------- | --------- | :-: | -------------------------------------------- |
| Windows  | MSVC      | YES | supported through generator                  |
| Windows  | MinGW-w64 | YES | supported through `CMAKE_C/CXX_COMPILER`     |
| Linux    | GCC       | YES | supported by default (see note below)        |
| OS X     | Clang     | YES | supported by default                         |
| OS X     | GCC       | YES | `GCC_OSX_HOMEBREW` ID (requires hombrew)     |
| ARM      | GCC       | YES | `GCC_ARM_BAREMETAL` ID                       |

### Note on Linux support ###
Most Linux distributions are still providing *old* GCC versions (for example, GCC-4.X or GCC-5.X). In order to simplify support for modern versions, the toolchain ID `GCC_LINUX_RECENT` should be used to enforce GCC-6.X or GCC-7.X usage. It is strongly recommended to use this toolchain for any Linux projects.

### Note on GCC ARM toolchain ###
This toolchain requires the variable `ARM_TC_PATH` to be set to the root of the toolchain installation.


## heph_setup_project_tree ##
This command is implemented in [ProjectTree.cmake](scripts/ProjectTree.cmake) and provides an automated way to setup the project tree for [CMake] builds and [CLion] as well. The typical way to implement this in a project is to use the following snippet (after the project declaration):

```
heph_setup_project_tree(PROJ_BUILD_DIR ${BUILD_DIR}
                        PROJ_INSTALL_DIR ${INSTALL_DIR})
```

This will use the default location for the project tree (*i.e.*, the [CMake] build directory), but makes it possible override those when invoking [CMake] using:

```
cmake -DBUILD_DIR=/path/to/build/dir -DINSTALL_DIR=/path/to/install/dir
```

This command will create dedicated folder for each build types in the build and install directories.


## heph_setup_compiler ##
This command is implemented in [CompilerSetup.cmake](scripts/CompilerSetup.cmake) and provides an automated way to set compiler flags depending on the platform and the compiler. This command will set the flags for the various build types (`Debug`, `Release`, `MinSizeRel`, `RelWithDebInfo`). This command does not take any argument and in case the platform and/or the compiler is not supported it will simply use [CMake] defaults. It is sufficient to call this command after the project declaration to perform the compiler setup.

The supported configurations are (click on the links to see details):

* [Windows + GCC](scripts/compilers_support/Windows_GCC.cmake)
* [Windows + MSVC](scripts/compilers_support/Windows_MSVC.cmake)
* [Linux/Unix + GCC](scripts/compilers_support/LinuxUnix_GCC.cmake)
* [OSX + Clang](scripts/compilers_support/OSX_Clang.cmake)
* [OSX + GCC](scripts/compilers_support/OSX_GCC.cmake)
* [GCC ARM bare metal](scripts/compilers_support/ARM_GCC.cmake): this will set the compiler for bare metal builds

Note that, compiler flags for GCC on Linux and Unix platforms are functional for recent GCC versions. It is recommended to use the `GCC_LINUX_RECENT` toolchain ID to enforce this usage.

The compiler will be identified based on the toolchain setup. The platform identification relies on the system description. For ARM bare metal projects it is required to configure the toolchain using [heph_setup_toolchain].

### GCC ARM compiler ###
When using the GCC ARM toolchain for embedded projects, the compiler setup command requires the type of ARM hardware to be explicitly specified. This is used by the script to properly define compiler flags for hardware support (*e.g.*, FPU).

The current implementation supports the following ARM architectures:

* Cortex-M0+
* Cortex-M4

To use a specific architecture the compiler setup should be invoked as follow:

```
# For Cortex-M0+.
heph_setup_compiler("M0+")

# For Cortex-M4.
heph_setup_compiler("M4")
```

The compiler setup is designed for bare metal builds ([ARM + GCC](scripts/compilers_support/ARM_GCC.cmake)).


[CMake]: https://cmake.org/
[CLion]: https://www.jetbrains.com/clion/
[heph_setup_toolchain]: #heph_setup_toolchain
[heph_setup_project_tree]: #heph_setup_project_tree
[heph_setup_compiler]: #heph_setup_compiler

