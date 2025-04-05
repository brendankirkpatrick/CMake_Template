# Header files
set(HEADER_FILES
    example.h
    )

# Source Files
set(SOURCE_FILES
    example.cpp
    )

# Program entry (main fn)
set(PROGRAM_ENTRY
    main.cpp
    )

# Add source files as library 
add_library(src_files ${SOURCE_FILES} ${HEADER_FILES})
set_target_properties(src_files 
                      PROPERTIES LINKER_LANGUAGE CXX 
                      OUTPUT_NAME ${PROJECT_NAME})
target_include_directories(src_files PUBLIC ${PROJECT_SOURCE_DIR}/src)

add_executable(${PROJECT_NAME} ${PROGRAM_ENTRY})
target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE ${PROJECT_NAME}_settings
    PUBLIC src_files
)
