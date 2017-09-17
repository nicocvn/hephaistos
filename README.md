# Hephaistos #
Copyright Nicolas Clauvelin, 2017. All rights reserved ([LICENSE](LICENSE)).  
[Nicolas Clauvelin](mailto:nclauvelin@sendyne.com)  


## Motivation ##
Setting up project in [CMake], and therefore in [CLion], can be a bit cumbersome. This project is an effort to provide some basic commands to facilitate project setup in [CMake] and [CLion].

Most of my personal programing projects are usually cross-platform or sometimes designed for a specific hardware (usually embedded). [CMake] therefore seems like a good choice as it provides:

* low-level project management functionalities,
* cross-platform support for project configuration, build and install steps,
* can be used as the project format in [CLion].

This project was originally developed for personal projects and then got sanitized to be used in production at Sendyne.


## Module description ##
The `Hephaistos` [CMake] module provides the following functionalities:

* support for various toolchains using the [heph_setup_toolchain] command (including embedded toolchains GCC ARM and TI C2000),
* the [heph_setup_project_tree] command to set up the various project directories used for compiling, building, and installing the project,
* a [heph_setup_compiler] command to adjust compiler settings for various setups (`Debug`, `Release`, `RelWithDebInfo`, `MinSizeRel`).

All those commands will report status information when [CMake] is going through the configuration stage.

The file [Hephaistos.cmake](Hephaistos.cmake) should be included in the [CMake] project file in order to load the definitions of those various commands.


## heph_setup_toolchain ##
This command is implemented in [ToolchainManager.cmake](scripts/ToolchainManager.cmake) and provides toolchain management functionalities. For most projects the toolchain will be automatically setup during [CMake] configuration step, but in some cases (*e.g.*, embedded platforms) explicit toolchain configuration will be required. In addition, it is sometimes useful to use a specific toolchain for debugging purpose.

The script [ToolchainManager.cmake](scripts/ToolchainManager.cmake) provides two commands:

* `heph_setup_toolchain([TOOLCHAIN ToolchainID])`: if `ToolchainID` is not specified this will use the default toolchain identified by [CMake] during the configure step,
* `heph_toolchain_diagnostic()`: this command outputs the details of the toolchain configuration.

The table below sums up the supported toolchains:

| Platform | Toolchain | Supported | Comment                                |
| -------- | --------- | :-: | -------------------------------------------- |
| Windows  | MSVC      | NO  | use [CMake] GUI (see [boilerplate] wiki)     |
| Windows  | MinGW-w64 | YES | supported through [CLion]; no ID required    |
| Linux    | GCC       | YES | supported by default; (see note below)       |
| OS X     | Clang     | YES | supported by default; no ID required         |
| OS X     | GCC       | YES | requires homebrew; use `GCC_OSX_HOMEBREW` ID |
| ARM      | GCC       | YES | use `GCC_ARM_BAREMETAL` ID                   |
| TI C2000 | TI CGT    | YES | use `TI_C2000` ID                            |

The TI C2000 toolchain support is somewhat still experimental.

### Note on Linux support ###
Most Linux distributions are still providing *old* GCC versions (for example, GCC-4.X or GCC-5.X). In order to simplify support for modern versions, the toolchain ID `GCC_LINUX_RECENT` should be used to enforce GCC-6.X or GCC-7.X usage. It is strongly recommended to use this toolchain for any Linux projects.


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
* [ARM + GCC](scripts/compilers_support/ARM_GCC.cmake): this will activate support for the MK64FN1M0xxx12 MCU and set the compiler for bare metal builds
* [TI C2000](scripts/compilers_support/C2000.cmake): this will set the compiler for bare metal builds

Note that, compiler flags for GCC on Linux and Unix platforms are functional for recent GCC versions. It is recommended to use the `GCC_LINUX_RECENT` toolchain ID to enforce this usage.


[CMake]: https://cmake.org/
[CLion]: https://www.jetbrains.com/clion/
[heph_setup_toolchain]: #heph_setup_toolchain
[heph_setup_project_tree]: #heph_setup_project_tree
[heph_setup_compiler]: #heph_setup_compiler

