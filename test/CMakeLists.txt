# Header files
set(HEADER_FILES
    )

# Source files
set(SOURCE_FILES
    test.cpp
    )

# Fetch Content to include Catch2 testing
Include(FetchContent)
FetchContent_Declare(
  Catch2
  GIT_REPOSITORY https://github.com/catchorg/Catch2.git
  GIT_TAG        v3.8.0 # or a later release
)
FetchContent_MakeAvailable(Catch2)

add_executable(UNIT_TEST ${SOURCE_FILES} ${HEADER_FILES})

# Unit test output bin in build directory
set_target_properties(UNIT_TEST PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

if(TARGET ${PROJECT_NAME}_lib)
    target_link_libraries(
        UNIT_TEST
        INTERFACE ${PROJECT_NAME}_settings
        PRIVATE Catch2::Catch2WithMain
        ${PROJECT_NAME}_lib
    )
else()
    target_link_libraries(
        UNIT_TEST
        INTERFACE ${PROJECT_NAME}_settings
        PRIVATE Catch2::Catch2WithMain
    )
endif()
