# Header files
set(HEADER_FILES
    )

# Source files
set(SOURCE_FILES
    test.cpp
    )

target_include_directories(UNIT_TEST_NAME PUBLIC ${PROJECT_SOURCE_DIR}/src)

add_executable(UNIT_TEST_NAME ${SOURCE_FILES} ${HEADER_FILES})
target_link_libraries(
    UNIT_TEST_NAME
    PRIVATE ${PROJECT_NAME}_settings
    PUBLIC src_files
)
