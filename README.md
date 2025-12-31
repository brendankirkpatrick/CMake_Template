# CMake_Template
This project is a simple CMake template that features:

- compiler warnings (optionally treated as errors)
- sanitization options (address, memory, etc...)
- clang-tidy static analysis
- clang-format formatting
- basic unit testing with [Catch2](https://github.com/catchorg/Catch2)
- automatic Valgrind integration (when sanitization is disabled)

## Setup
Users can build four types of projects: *Executable*, *Static*, *Shared*, and *Header-Only*.

To setup CMake, use the `ccmake -S . -B build` command. 
This will bring up a TUI application that allows users to set the build type, sanitization options, link language, etc.
By default, warnings-as-errors are enabled along with a few gcc sanitizatizers. 

To build the program and (simultaneously) run unit tests, the repo provides a simple `run.sh` script. 
Unit test binaries and libraries are output to the build directory and executables are output in the source directory.

## Usage
To customize the project, users can modify the CMakeLists.txt file in the src (or test) directories.
By default, we use the `detect_files` function to automatically set the following variables:
- MAIN
- SOURCE_FILES
- HEADER_FILES
- PCH
- INCLUDE_DIRS

The *MAIN* variable is our program's entrypoint. 
The `detect_files` function automatically searches for any file called *main* and adds it as an entrypoint. 
In the src/CMakeLists.txt file, it is mandatory that any entrypoint files are declared if they are not named main.cpp for unit tests to properly build.

The *SOURCE_FILES* variable represents to all of our source files (.c, .cpp, etc.).
Any source files with an odd extension can be manually added to the variable to be compiled.

The *HEADER_FILES* variable reprensents all of our header files.
We include header files in the build process to allow for creating header-only libraries.

The *PCH* variable contains precompiled headers.
Any files with pch.h in their name will be automatically assumed to be a precompiled header, but users can also manually add precompiled headers with different names as well.

The *INCLUDE_DIRS* variable contains the paths for all subdirectories within the src/ directory, automatically adding them to our include directories.
This enables including files existing in subdirectories without typing their full path in the `#include` statement.
