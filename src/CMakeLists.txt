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

if(PROGRAM_ENTRY)
    # Add executable
    add_executable(${PROJECT_NAME} ${PROGRAM_ENTRY})
endif()

# Add source files as library
if(SOURCE_FILES OR HEADER_FILES)
    add_library(${PROJECT_NAME}_lib ${SOURCE_FILES} ${HEADER_FILES})
    set_target_properties(${PROJECT_NAME}_lib
                          PROPERTIES
                          LINKER_LANGUAGE CXX
                          OUTPUT_NAME ${PROJECT_NAME}_lib
                          )
    target_include_directories(${PROJECT_NAME}_lib PUBLIC ${PROJECT_SOURCE_DIR}/src)
    target_link_libraries(
        ${PROJECT_NAME}
        PRIVATE ${PROJECT_NAME}_lib
        )
endif()
target_link_libraries(
    ${PROJECT_NAME}
    INTERFACE ${PROJECT_NAME}_settings
    )
