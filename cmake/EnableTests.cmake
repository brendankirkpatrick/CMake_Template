# Enable tests
include(CTest)
add_subdirectory(test)

if("${LIST_OF_SANITIZERS}"
    STREQUAL
    "")
    find_program(VALGRIND valgrind)
    if(VALGRIND)
        add_test(NAME MEMCHECK_TEST
                COMMAND valgrind
                  --error-exitcode=1
                  --tool=memcheck
                  --leak-check=full
                  --errors-for-leak-kinds=definite
                  --show-leak-kinds=definite $<TARGET_FILE:UNIT_TEST>
                WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
    endif()
endif()
