set(CLANG_WARNINGS
    -Wall
    -Wextra # reasonable and standard
    -Wshadow # warn the user if a variable declaration shadows one from a parent context
    -Wcast-align # warn for potential performance problem casts
    -Wunused # warn on anything being unused
    -Wconversion # warn on type conversions that may lose data
    -Wsign-conversion # warn on sign conversions
    -Wnull-dereference # warn if a null dereference is detected
    -Wdouble-promotion # warn if float is implicit promoted to double
    -Wformat=2 # warn on security issues around functions that format output (ie printf)
    -Wimplicit-fallthrough # warn on statements that fallthrough without an explicit annotation
)
set(CLANG_CXX_WARNINGS
    ${CLANG_WARNINGS}
    -Wnon-virtual-dtor # warn the user if a class with virtual functions has a non-virtual destructor. This helps
    # catch hard to track down memory errors
    -Wold-style-cast # warn for c-style casts
    -Wpedantic # warn if non-standard C++ is used
    -Woverloaded-virtual # warn if you overload (not override) a virtual function
)

set(GCC_WARNINGS
    ${CLANG_WARNINGS}
    -Wmisleading-indentation # warn if indentation implies blocks where blocks do not exist
    -Wduplicated-cond # warn if if / else chain has duplicated conditions
    -Wduplicated-branches # warn if if / else branches have duplicated code
    -Wlogical-op # warn about logical operations being used where bitwise were probably wanted
)
set(GCC_CXX_WARNINGS
    ${GCC_WARNINGS}
    ${CLANG_CXX_WARNINGS}
    -Wsuggest-override # warn if an overridden member function is not marked 'override' or 'final'
    -Wuseless-cast # warn if you perform a cast to the same type
)

if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    set(PROJECT_WARNINGS_CXX ${CLANG_CXX_WARNINGS})
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(PROJECT_WARNINGS_CXX ${GCC_CXX_WARNINGS})
endif()

if(CMAKE_C_COMPILER_ID MATCHES ".*Clang")
    set(PROJECT_WARNINGS_C ${CLANG_WARNINGS})
elseif(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    set(PROJECT_WARNINGS_C ${GCC_WARNINGS})
endif()

target_compile_options(
    ${PROJECT_NAME}_settings
    INTERFACE
    # C++ warnings
    $<$<COMPILE_LANGUAGE:CXX>:${PROJECT_WARNINGS_CXX}>
    # C warnings
    $<$<COMPILE_LANGUAGE:C>:${PROJECT_WARNINGS_C}>
)

if(${WARNINGS_AS_ERRORS})
    target_compile_options(
        ${PROJECT_NAME}_settings
        INTERFACE
        -Werror
    )
endif()
