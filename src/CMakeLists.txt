# Header files
set(HEADER_FILES
    )

# Source Files
set(SOURCE_FILES
    )

# Program entry (main fn)
set(PROGRAM_ENTRY
    main.cpp
    )

# Add source files as library 
add_library(src_files ${SOURCE_FILES} ${HEADER_FILES})
set_target_properties(src_files 
                      PROPERTIES LINKER_LANGUAGE CXX 
                      OUTPUT_NAME "libname")
target_include_directories(src_files PUBLIC ${PROJECT_SOURCE_DIR}/src)

add_executable(EXE_NAME ${PROGRAM_ENTRY})
target_link_libraries(
    EXE_NAME
    PRIVATE ${PROJECT_NAME}_settings
    PUBLIC src_files
)
                
