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
foreach (lang IN ITEMS C CXX)
  set("CMAKE_${lang}_CLANG_TIDY_save" "${CMAKE_${lang}_CLANG_TIDY}")
  set("CMAKE_${lang}_CLANG_TIDY" "")
endforeach ()
FetchContent_MakeAvailable(Catch2)
foreach (lang IN ITEMS C CXX)
  set("CMAKE_${lang}_CLANG_TIDY" "${CMAKE_${lang}_CLANG_TIDY_save}")
endforeach ()

add_executable(UNIT_TEST ${SOURCE_FILES} ${HEADER_FILES})

# Set UNIT_TEST output directory
set_target_properties(UNIT_TEST PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

target_link_libraries(
    UNIT_TEST
    PRIVATE ${PROJECT_NAME}_settings
    PRIVATE Catch2::Catch2WithMain
    PUBLIC src_files
)
