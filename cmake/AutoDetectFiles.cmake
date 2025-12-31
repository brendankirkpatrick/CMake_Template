function(detect_files BASE_DIR)
    # Lists to store results
    set(REGULAR_HEADERS "")
    set(PCH_FILES "")
    set(SOURCE_FILES_TMP "")
    set(MAIN_FILES "")
    set(INCLUDE_DIRS_TMP "")

    # ---- Scan all files in one pass ----
    file(GLOB_RECURSE ALL_FILES
        "${BASE_DIR}/*.h"
        "${BASE_DIR}/*.hpp"
        "${BASE_DIR}/*.c"
        "${BASE_DIR}/*.cpp"
        "${BASE_DIR}/*.cxx"
    )

    foreach(file IN LISTS ALL_FILES)
        get_filename_component(fname ${file} NAME)
        get_filename_component(dir ${file} PATH)

        # Collect headers and PCH
        if(fname MATCHES ".*pch\\.(h|hpp)$")
            list(APPEND PCH_FILES ${file})
        elseif(fname MATCHES ".*\\.(h|hpp)$")
            list(APPEND REGULAR_HEADERS ${file})
            list(APPEND INCLUDE_DIRS_TMP ${dir})
        endif()

        # Collect sources and main files
        if(fname MATCHES "^main\\.(c|cpp|cxx)$")
            list(APPEND MAIN_FILES ${file})
        elseif(fname MATCHES ".*\\.(c|cpp|cxx)$")
            list(APPEND SOURCE_FILES_TMP ${file})
        endif()
    endforeach()

    # ---- Remove duplicates ----
    list(REMOVE_DUPLICATES REGULAR_HEADERS)
    list(REMOVE_DUPLICATES PCH_FILES)
    list(REMOVE_DUPLICATES SOURCE_FILES_TMP)
    list(REMOVE_DUPLICATES INCLUDE_DIRS_TMP)
    list(REMOVE_DUPLICATES HEADER_FILES)
    list(REMOVE_DUPLICATES PCH)
    list(REMOVE_DUPLICATES SOURCE_FILES)
    list(REMOVE_DUPLICATES INCLUDE_DIRS)
    list(REMOVE_DUPLICATES MAIN)

    # ---- Append to global variables ----
    list(APPEND HEADER_FILES ${REGULAR_HEADERS})
    list(APPEND PCH ${PCH_FILES})
    list(APPEND SOURCE_FILES ${SOURCE_FILES_TMP})
    list(APPEND MAIN ${MAIN_FILES})
    list(APPEND INCLUDE_DIRS ${INCLUDE_DIRS_TMP})

    # ---- Remove PCH from headers ----
    foreach(pch_file IN LISTS PCH)
        list(REMOVE_ITEM HEADER_FILES ${pch_file})
    endforeach()

    # ---- Remove MAIN from sources ----
    foreach(main_file IN LISTS MAIN)
        list(REMOVE_ITEM SOURCE_FILES ${main_file})
    endforeach()

    # ---- Export variables ----
    set(HEADER_FILES ${HEADER_FILES} PARENT_SCOPE)
    set(PCH ${PCH} PARENT_SCOPE)
    set(SOURCE_FILES ${SOURCE_FILES} PARENT_SCOPE)
    set(MAIN ${MAIN} PARENT_SCOPE)
    set(INCLUDE_DIRS ${INCLUDE_DIRS} PARENT_SCOPE)
endfunction()
