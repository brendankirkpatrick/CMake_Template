# Header files
set(HEADER_FILES
    example.h
    )

# Source Files
set(SOURCE_FILES
    example.cpp
    )

# Main function (auto detect main.cpp)
set(MAIN main.cpp)

# Set pre-compiled-header (auto detect pch.h)
set(PCH
)

# Set subdirectories to include
# Allows files to directly include headers without specifying the full subdirectory path
set(INCLUDE_DIRS
)

# (OPTIONAL) In the current directory, detect all files for variables set above
# Removes duplicate files
detect_files(${CMAKE_CURRENT_SOURCE_DIR})

# Include library/executable creation given above options
include(../cmake/CompileBuildTypes.cmake)
