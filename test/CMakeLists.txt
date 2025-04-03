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
  GIT_TAG        v3.4.0 # or a later release
)
FetchContent_MakeAvailable(Catch2)

target_include_directories(UNIT_TEST PUBLIC ${PROJECT_SOURCE_DIR}/src)
add_executable(UNIT_TEST ${SOURCE_FILES} ${HEADER_FILES})
target_link_libraries(
    UNIT_TEST
    PRIVATE ${PROJECT_NAME}_settings
    PRIVATE Catch2::Catch2WithMain
    PUBLIC src_files
)
