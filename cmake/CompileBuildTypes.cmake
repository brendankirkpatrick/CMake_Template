# Add source files as library
if(SOURCE_FILES)
    add_library(${PROJECT_NAME}_lib OBJECT ${SOURCE_FILES} ${HEADER_FILES})
    if(PCH)
        target_precompile_headers(${PROJECT_NAME}_lib PUBLIC ${PCH})
    endif()
    target_link_libraries(
        ${PROJECT_NAME}_lib
        PRIVATE ${PROJECT_NAME}_settings
        )

    list(TRANSFORM INCLUDE_DIRS PREPEND "${PROJECT_SOURCE_DIR}/src/")
    target_include_directories(${PROJECT_NAME}_lib PUBLIC "${PROJECT_SOURCE_DIR}/src" ${INCLUDE_DIRS})

    enable_clang_tidy(${PROJECT_NAME}_lib)
elseif(HEADER_FILES)
    add_library(${PROJECT_NAME}_lib INTERFACE ${HEADER_FILES})

    if(MAIN)
        get_source_file_property(MAIN_LANG ${MAIN} LANGUAGE)
        set_target_properties(${PROJECT_NAME}_lib PROPERTIES LINKER_LANGUAGE ${MAIN_LANG})
    else()
        set(${PROJ_NAME}_HEADER_ONLY_LINK_LANG "CXX" CACHE STRING "Set the linker language for header-only tooling target")
        set_property(CACHE HEADER_ONLY_LINK_LANG PROPERTY STRINGS C CXX)
        set_target_properties(${PROJECT_NAME}_lib PROPERTIES LINKER_LANGUAGE ${PROJ_NAME}_HEADER_ONLY_LINK_LANG)
    endif()

    if(PCH)
        target_precompile_headers(${PROJECT_NAME}_lib INTERFACE ${PCH})
    endif()
    target_link_libraries(
        ${PROJECT_NAME}_lib
        INTERFACE ${PROJECT_NAME}_settings
        )

    list(TRANSFORM INCLUDE_DIRS PREPEND "${PROJECT_SOURCE_DIR}/src/")
    target_include_directories(${PROJECT_NAME}_lib INTERFACE "${PROJECT_SOURCE_DIR}/src" ${INCLUDE_DIRS})

    enable_clang_tidy(${PROJECT_NAME}_lib)
elseif(DEFINED MAIN)
    add_library(${PROJECT_NAME}_lib INTERFACE)
else()
    message(FATAL_ERROR "Tried to create target without specifying any source or header files???")
endif()

if(${PROJ_NAME}_BUILD_TYPE STREQUAL "Executable")
    if(SOURCE_FILES)
        add_executable(${PROJECT_NAME} ${MAIN} $<TARGET_OBJECTS:${PROJECT_NAME}_lib>)
    else()
        add_executable(${PROJECT_NAME} ${MAIN})
    endif()
    target_link_libraries(
        ${PROJECT_NAME}
        PRIVATE ${PROJECT_NAME}_settings
        ${PROJECT_NAME}_lib
        )
    enable_clang_tidy(${PROJECT_NAME})

    # Enable PIE
    if(${PROJ_NAME}_POSITION_INDEPENDENT)
        include(CheckPIESupported)
        check_pie_supported()
        set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)
    else()
        set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE OFF)
    endif()

elseif(${PROJ_NAME}_BUILD_TYPE STREQUAL "Shared")
    add_library(${PROJECT_NAME} SHARED)
    target_link_libraries(${PROJECT_NAME} PUBLIC ${PROJECT_NAME}_lib)
    set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)
    enable_clang_tidy(${PROJECT_NAME})

elseif(${PROJ_NAME}_BUILD_TYPE STREQUAL "Static")
    add_library(${PROJECT_NAME} STATIC)
    target_link_libraries(${PROJECT_NAME} PUBLIC ${PROJECT_NAME}_lib)
    enable_clang_tidy(${PROJECT_NAME})

elseif(${PROJ_NAME}_BUILD_TYPE STREQUAL "Header-Only")
    add_library(${PROJECT_NAME} INTERFACE)
    target_link_libraries(${PROJECT_NAME} INTERFACE ${PROJECT_NAME}_lib)
    enable_clang_tidy(${PROJECT_NAME})

else()
    message(FATAL_ERROR "Tried to build project without known BUILD_TYPE")
endif()

# If we define a main fn for testing purposes, add our library to it
if(MAIN AND NOT ${PROJ_NAME}_BUILD_TYPE STREQUAL "Executable")
    add_executable(${PROJECT_NAME}_libtest ${MAIN})
    target_link_libraries(
        ${PROJECT_NAME}_libtest
        PRIVATE ${PROJECT_NAME}_settings
        ${PROJECT_NAME}
        )
    enable_clang_tidy(${PROJECT_NAME}_libtest)
endif()
