cmake_minimum_required(VERSION 3.21)

# Treat warnings as errors
option(WARNINGS_AS_ERRORS "Treat Warnings As Errors" ON)

# Sanitizer options
option(ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" ON)
option(ENABLE_SANITIZER_LEAK "Enable leak sanitizer" ON)
option(ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" ON)
option(ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
option(ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)

# Enable position independent code
option(POSITION_INDEPENDENT "Set position independent code" ON)

# Set the possible values of build type for cmake-gui, ccmake
set(BUILD_TYPE
    "Executable"
    CACHE STRING "Choose the type of build.")
set_property(
    CACHE BUILD_TYPE
    PROPERTY STRINGS
     "Executable"
     "Static"
     "Shared"
     "Header-Only")

set(CMAKE_BUILD_TYPE
      "Debug"
      CACHE STRING "Choose the type of build.")
set_property(
    CACHE CMAKE_BUILD_TYPE
    PROPERTY STRINGS
     "Debug"
     "Release"
     "MinSizeRel"
     "RelWithDebInfo")

# Set project name to be equal to root level directory
get_filename_component(PROJ_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
project(
  ${PROJ_NAME}
  VERSION 1.0.0
  LANGUAGES CXX C
  )

# Generate compile_commands.json to make it easier to work with clang based tools
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_C_STANDARD 23)

# Create target for compiler options
add_library(${PROJECT_NAME}_settings INTERFACE)

# Include warnings and optionally set warnings as errors
include(cmake/AddWarnings.cmake)

# Include sanitizers and add them to settings library
include(cmake/AddSanitizers.cmake)

# Include sanitizers and add them to settings library
include(cmake/EnableClangTidy.cmake)

# Include before adding subdirectories to provide function to subdirectories
include(cmake/AutoDetectFiles.cmake)

# Set output directory
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR})

# Add our src folder to build
add_subdirectory(src)

# Include unit test directory and add them to project
include(cmake/EnableTests.cmake)

