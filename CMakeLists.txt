cmake_minimum_required(VERSION 3.21)

# Treat warnings as errors
option(WARNINGS_AS_ERRORS "Treat Warnings As Errors" ON)

# Sanitizer options
option(ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" ON)
option(ENABLE_SANITIZER_LEAK "Enable leak sanitizer" ON)
option(ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" ON)
option(ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
option(ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)

if (NOT DEFINED CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 20)
endif()

project(
  PROJ_NAME
  VERSION 1.0.0
  DESCRIPTION "Insert Description"
  LANGUAGES CXX C
  )

# Generate compile_commands.json to make it easier to work with clang based tools
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_BUILD_TYPE
      Debug
      CACHE STRING "Choose the type of build." FORCE)

# Set the possible values of build type for cmake-gui, ccmake
set_property(
CACHE CMAKE_BUILD_TYPE
PROPERTY STRINGS
         "Debug"
         "Release"
         "MinSizeRel"
         "RelWithDebInfo")

# Create target for compiler options
add_library(${PROJECT_NAME}_settings INTERFACE)

set(CLANG_WARNINGS
    -Wall
    -Wextra # reasonable and standard
    -Wshadow # warn the user if a variable declaration shadows one from a parent context
    -Wnon-virtual-dtor # warn the user if a class with virtual functions has a non-virtual destructor. This helps
    # catch hard to track down memory errors
    -Wold-style-cast # warn for c-style casts
    -Wcast-align # warn for potential performance problem casts
    -Wunused # warn on anything being unused
    -Woverloaded-virtual # warn if you overload (not override) a virtual function
    -Wpedantic # warn if non-standard C++ is used
    -Wconversion # warn on type conversions that may lose data
    -Wsign-conversion # warn on sign conversions
    -Wnull-dereference # warn if a null dereference is detected
    -Wdouble-promotion # warn if float is implicit promoted to double
    -Wformat=2 # warn on security issues around functions that format output (ie printf)
    -Wimplicit-fallthrough # warn on statements that fallthrough without an explicit annotation
)
set(GCC_WARNINGS
    ${CLANG_WARNINGS}
    -Wmisleading-indentation # warn if indentation implies blocks where blocks do not exist
    -Wduplicated-cond # warn if if / else chain has duplicated conditions
    -Wduplicated-branches # warn if if / else branches have duplicated code
    -Wlogical-op # warn about logical operations being used where bitwise were probably wanted
    -Wuseless-cast # warn if you perform a cast to the same type
    -Wsuggest-override # warn if an overridden member function is not marked 'override' or 'final'
)

if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    set(PROJECT_WARNINGS_CXX ${CLANG_WARNINGS})
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(PROJECT_WARNINGS_CXX ${GCC_WARNINGS})
endif()

target_compile_options(
    ${PROJECT_NAME}_settings
    INTERFACE 
    # C++ warnings
    $<$<COMPILE_LANGUAGE:CXX>:${PROJECT_WARNINGS_CXX}>
)

# Enable sanitizers
set(SANITIZERS "")
if(${ENABLE_SANITIZER_ADDRESS})
  list(APPEND SANITIZERS "address")
endif()

if(${ENABLE_SANITIZER_LEAK})
  list(APPEND SANITIZERS "leak")
endif()

if(${ENABLE_SANITIZER_UNDEFINED_BEHAVIOR})
  list(APPEND SANITIZERS "undefined")
endif()

if(${ENABLE_SANITIZER_THREAD})
  if("address" IN_LIST SANITIZERS OR "leak" IN_LIST SANITIZERS)
    message(WARNING "Thread sanitizer does not work with Address and Leak sanitizer enabled")
  else()
    list(APPEND SANITIZERS "thread")
  endif()
endif()

if(${ENABLE_SANITIZER_MEMORY} AND CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
  message(
    WARNING
      "Memory sanitizer requires all the code (including libc++) to be MSan-instrumented otherwise it reports false positives"
  )
  if("address" IN_LIST SANITIZERS
     OR "thread" IN_LIST SANITIZERS
     OR "leak" IN_LIST SANITIZERS)
    message(WARNING "Memory sanitizer does not work with Address, Thread or Leak sanitizer enabled")
  else()
    list(APPEND SANITIZERS "memory")
  endif()
endif()

list( JOIN
      SANITIZERS
      ","
      LIST_OF_SANITIZERS)

if(LIST_OF_SANITIZERS)
    if(NOT
       "${LIST_OF_SANITIZERS}"
       STREQUAL
       "")
# Apparently MSVC is weird so just disable for now
        if(NOT MSVC)
            target_compile_options(${PROJECT_NAME}_settings INTERFACE -fsanitize=${LIST_OF_SANITIZERS})
            target_link_options(${PROJECT_NAME}_settings INTERFACE -fsanitize=${LIST_OF_SANITIZERS})
        endif()
    endif()
endif()

# Enable clang tidy macro
macro(enable_clang_tidy target WARNINGS_AS_ERRORS)
  find_program(CLANGTIDY clang-tidy)
  if(CLANGTIDY)
    # Construct the clang-tidy command line
    set(CLANG_TIDY_OPTIONS
        ${CLANGTIDY}
        --fix
        --fix-notes
        --fix-errors
        --quiet
        --use-color
        --extra-arg=-Wno-unknown-warning-option
        --extra-arg=-Wno-ignored-optimization-argument
        --extra-arg=-Wno-unused-command-line-argument
       ) 
    # Set standard
    if(NOT
       "${CMAKE_CXX_STANDARD}"
       STREQUAL
       "")
      if("${CLANG_TIDY_OPTIONS_DRIVER_MODE}" STREQUAL "cl")
        set(CLANG_TIDY_OPTIONS ${CLANG_TIDY_OPTIONS} -extra-arg=/std:c++${CMAKE_CXX_STANDARD})
      else()
        set(CLANG_TIDY_OPTIONS ${CLANG_TIDY_OPTIONS} -extra-arg=-std=c++${CMAKE_CXX_STANDARD})
      endif()
    endif()

    # Set warnings as errors
    if(${WARNINGS_AS_ERRORS})
      list(APPEND CLANG_TIDY_OPTIONS -warnings-as-errors=*)
    endif()

    message("Also setting clang-tidy globally")
    set(CMAKE_CXX_CLANG_TIDY ${CLANG_TIDY_OPTIONS})
  else()
    message(${WARNING_MESSAGE} "clang-tidy requested but executable not found")
  endif()
endmacro()
enable_clang_tidy(options ${WARNINGS_AS_ERRORS})

# Set output directory
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BUILD_DIRECTORY})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BUILD_DIRECTORY})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR})

# Add our src folder to build
add_subdirectory(src)

# Enable tests
enable_testing()
add_subdirectory(test)

if("${LIST_OF_SANITIZERS}"
    STREQUAL
    "")
    find_program(VALGRIND valgrind)
    if(VALGRIND)
        add_test(NAME MEMCHECK_TEST
                COMMAND valgrind
                  --error-exitcode=1
                  --tool=memcheck
                  --leak-check=full
                  --errors-for-leak-kinds=definite
                  --show-leak-kinds=definite $<TARGET_FILE:UNIT_TEST>
                WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
    endif()
endif()

add_test(NAME UNIT_TEST COMMAND UNIT_TEST)
set_tests_properties(UNIT_TEST PROPERTIES TIMEOUT 30) 

