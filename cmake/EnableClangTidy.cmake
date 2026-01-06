function(enable_clang_tidy target)
    find_program(CLANGTIDY clang-tidy)
    if(CLANGTIDY)
        # Construct the clang-tidy command line
        set(CLANG_TIDY_OPTIONS
            ${CLANGTIDY}
            #--fix
            #--fix-notes
            #--fix-errors
            --quiet
            --use-color
            --extra-arg=-Wno-unknown-warning-option
            --extra-arg=-Wno-ignored-optimization-argument
            --extra-arg=-Wno-unused-command-line-argument
       )
        # Set warnings as errors
        if(${PROJ_NAME}_WARNINGS_AS_ERRORS)
            list(APPEND CLANG_TIDY_OPTIONS -warnings-as-errors=*)
        endif()

        if(CMAKE_C_STANDARD)
            if("${CLANG_TIDY_OPTIONS_DRIVER_MODE}" STREQUAL "cl")
                set(CLANG_TIDY_OPTIONS ${CLANG_TIDY_OPTIONS} -extra-arg=/std:c${CMAKE_C_STANDARD})
            else()
                set(CLANG_TIDY_OPTIONS ${CLANG_TIDY_OPTIONS} -extra-arg=-std=c${CMAKE_C_STANDARD})
            endif()

            set_target_properties(${target} PROPERTIES C_CLANG_TIDY "${CLANG_TIDY_OPTIONS}")
        endif()

        if(CMAKE_CXX_STANDARD)
            if("${CLANG_TIDY_OPTIONS_DRIVER_MODE}" STREQUAL "cl")
                set(CLANG_TIDY_OPTIONS ${CLANG_TIDY_OPTIONS} -extra-arg=/std:c++${CMAKE_CXX_STANDARD})
            else()
                set(CLANG_TIDY_OPTIONS ${CLANG_TIDY_OPTIONS} -extra-arg=-std=c++${CMAKE_CXX_STANDARD})
            endif()

            set_target_properties(${target} PROPERTIES CXX_CLANG_TIDY "${CLANG_TIDY_OPTIONS}")
        endif()

        message("Setting clang-tidy on target: ${target}")
    else()
        message(${WARNING_MESSAGE} "clang-tidy requested but executable not found")
    endif()
endfunction()
