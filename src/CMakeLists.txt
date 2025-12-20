# Header files
set(HEADER_FILES
    example.h
    )

# Source Files
set(SOURCE_FILES
    example.cpp
    )

# Main function (must be set for unit tests to work properly)
set(MAIN main.cpp)

# Set PCH if you have one
set(PCH)

# Set subdirectories to include. Allows files to directly include
# headers without specifying the full subdirectory path
set(INCLUDE_DIRS
)

################################################################################

# Add source files as library
if(SOURCE_FILES OR HEADER_FILES)
    add_library(${PROJECT_NAME}_lib OBJECT ${SOURCE_FILES} ${HEADER_FILES})
    if(PCH)
        target_precompile_headers(${PROJECT_NAME}_lib PUBLIC ${PCH})
    endif()
    target_link_libraries(
        ${PROJECT_NAME}_lib
        PRIVATE ${PROJECT_NAME}_settings
        )

    list(TRANSFORM INCLUDE_DIRS PREPEND "${PROJECT_SOURCE_DIR}/src/")
    message("${INCLUDE_DIRS}")
    target_include_directories(${PROJECT_NAME}_lib PUBLIC "${PROJECT_SOURCE_DIR}/src" ${INCLUDE_DIRS})
else()
    message(FATAL_ERROR "Tried to create target without specifying any source or header files???")
endif()

if(${BUILD_ARTIFACT_TYPE} STREQUAL "Executable")
    add_executable(${PROJECT_NAME} ${MAIN} $<TARGET_OBJECTS:${PROJECT_NAME}_lib>)
    target_link_libraries(
        ${PROJECT_NAME}
        PRIVATE ${PROJECT_NAME}_settings
        ${PROJECT_NAME}_lib
        )

    # Enable PIE
    if(${POSITION_INDEPENDENT_EXECUTABLE})
        include(CheckPIESupported)
        check_pie_supported()
        set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)
    endif()

elseif(${BUILD_ARTIFACT_TYPE} STREQUAL "Shared")
    add_library(${PROJECT_NAME} SHARED)
    target_link_libraries(${PROJECT_NAME} PUBLIC ${PROJECT_NAME}_lib)
    set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)

elseif(${BUILD_ARTIFACT_TYPE} STREQUAL "Static")
    add_library(${PROJECT_NAME} STATIC)
    target_link_libraries(${PROJECT_NAME} PUBLIC ${PROJECT_NAME}_lib)

else()
    message(FATAL_ERROR "Tried to build project without known BUILD_ARTIFACT_TYPE")
endif()

# If we define a main fn for testing purposes, add our library to it
if(MAIN AND (${BUILD_ARTIFACT_TYPE} STREQUAL "Static" OR ${BUILD_ARTIFACT_TYPE} STREQUAL "Shared"))
    add_executable(${PROJECT_NAME}_libtest ${MAIN})
    target_link_libraries(
        ${PROJECT_NAME}_libtest
        PRIVATE ${PROJECT_NAME}_settings
        ${PROJECT_NAME}
        )
endif()
