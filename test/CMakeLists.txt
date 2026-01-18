# Header files
set(HEADER_FILES
    )

# Source files
set(SOURCE_FILES
    )

# Detect files for above types, doesn't compile pch or main.ccp files
detect_files(${CMAKE_CURRENT_SOURCE_DIR})

# Fetch Content to include Catch2 testing
Include(FetchContent)

# Pre-configure Catch2 to be quiet
set(BUILD_TESTING ON CACHE INTERNAL "")
set(CATCH_BUILD_TESTING OFF CACHE INTERNAL "")
set(CATCH_INSTALL_DOCS ON CACHE INTERNAL "")
set(CATCH_INSTALL_EXTRAS ON CACHE INTERNAL "")
set(CATCH_DEVELOPMENT_BUILD OFF CACHE INTERNAL "")
set(CATCH_ENABLE_REPRODUCIBLE_BUILD ON CACHE INTERNAL "")

FetchContent_Declare(
  Catch2
  GIT_REPOSITORY https://github.com/catchorg/Catch2.git
  GIT_TAG        v3.8.0 # or a later release
)
FetchContent_MakeAvailable(Catch2)

# Hide remaining FetchContent variables
mark_as_advanced(
    FETCHCONTENT_BASE_DIR
    FETCHCONTENT_QUIET
    FETCHCONTENT_SOURCE_DIR_CATCH2
    FETCHCONTENT_BINARY_DIR_CATCH2
    FETCHCONTENT_UPDATES_DISCONNECTED
    FETCHCONTENT_UPDATES_DISCONNECTED_CATCH2
    FETCHCONTENT_BASE_DIR
    FETCHCONTENT_FULLY_DISCONNECTED
)

add_executable(${PROJECT_NAME}_UNIT_TEST ${SOURCE_FILES} ${HEADER_FILES})

# Discover unit tests automagically
include(Catch)
catch_discover_tests(${PROJECT_NAME}_UNIT_TEST EXTRA_ARGS --colour-mode ansi)

# Unit test output bin in build directory
set_target_properties(${PROJECT_NAME}_UNIT_TEST PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

if(TARGET ${PROJECT_NAME})
    get_target_property(TYPE_VAR ${PROJECT_NAME} TYPE)
    if(TYPE_VAR STREQUAL "EXECUTABLE")
        target_link_libraries(
            ${PROJECT_NAME}_UNIT_TEST
            PRIVATE ${PROJECT_NAME}_settings
            Catch2::Catch2WithMain
            ${PROJECT_NAME}_lib
        )
    else()
        target_link_libraries(
            ${PROJECT_NAME}_UNIT_TEST
            PRIVATE ${PROJECT_NAME}_settings
            Catch2::Catch2WithMain
            ${PROJECT_NAME}
        )
    endif()
else()
    message(FATAL_ERROR "${PROJECT_NAME} target not found...")
endif()
